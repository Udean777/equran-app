from __future__ import annotations

import asyncio
import logging
import os
import tempfile
import time
from pathlib import Path
from typing import TYPE_CHECKING

from fastapi import APIRouter, File, Form, HTTPException, Request, UploadFile

from models.schemas import CompareResponse, WordErrorItem
from services.scorer import Scorer

if TYPE_CHECKING:
    from services.transcriber import TranscriberService

logger = logging.getLogger(__name__)

router = APIRouter()
scorer = Scorer()


def _get_transcriber(request: Request) -> "TranscriberService":
    transcriber = getattr(request.app.state, "transcriber", None)
    if transcriber is None:
        raise HTTPException(status_code=503, detail="Transcriber not ready")
    return transcriber


@router.post("/compare", response_model=CompareResponse)
async def compare(
    request: Request,
    user_audio: UploadFile = File(...),
    target_text: str = Form(...),
    threshold: float = Form(75.0),
):
    transcriber = _get_transcriber(request)
    start_time = time.time()

    if not user_audio.filename:
        raise HTTPException(status_code=422, detail="No audio file provided")

    if not target_text.strip():
        raise HTTPException(status_code=422, detail="target_text is required")

    suffix = Path(user_audio.filename).suffix or ".webm"
    tmp = tempfile.NamedTemporaryFile(delete=False, suffix=suffix)
    try:
        content = await user_audio.read()
        if not content:
            raise HTTPException(status_code=422, detail="Empty audio file")

        tmp.write(content)
        tmp.flush()
        tmp_path = tmp.name

        # Transcribe with timeout to prevent hanging
        try:
            transcribed = await asyncio.wait_for(
                asyncio.to_thread(transcriber.transcribe, tmp_path),
                timeout=120.0,
            )
        except asyncio.TimeoutError:
            logger.error("Transcription timeout after 120s")
            raise HTTPException(
                status_code=504,
                detail="Transcription timeout - audio too long or server overloaded",
            )
    except HTTPException:
        raise
    except Exception as e:
        logger.exception("Transcription failed")
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        tmp.close()
        os.unlink(tmp.name)

    result = scorer.score(
        transcribed=transcribed,
        target=target_text,
        threshold=threshold,
        is_arabic=True,
    )

    elapsed_ms = int((time.time() - start_time) * 1000)

    return CompareResponse(
        score=result.score,
        passed=result.passed,
        threshold=result.threshold,
        transcribed=result.transcribed,
        target=result.target,
        cer=result.cer,
        word_errors=[
            WordErrorItem(
                expected=we.expected,
                actual=we.actual,
                position=we.position,
            )
            for we in result.word_errors
        ],
        duration_ms=elapsed_ms,
    )

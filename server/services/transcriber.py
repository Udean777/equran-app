import logging
import time
from pathlib import Path

# pyrefly: ignore [missing-import]
from faster_whisper import WhisperModel

logger = logging.getLogger(__name__)


class TranscriberService:
    def __init__(self, model_size: str = "tiny"):
        logger.info("Loading faster-whisper model: %s (cpu, int8)", model_size)
        start = time.time()
        self.model = WhisperModel(
            model_size,
            device="cpu",
            compute_type="int8",
        )
        elapsed = time.time() - start
        logger.info("Model loaded in %.2fs", elapsed)

    def transcribe(self, audio_path: str | Path) -> str:
        logger.info("Transcribing: %s", audio_path)
        start = time.time()
        segments, info = self.model.transcribe(
            str(audio_path),
            language="ar",
            beam_size=3,
            condition_on_previous_text=True,
        )
        text = " ".join(seg.text.strip() for seg in segments)
        elapsed = time.time() - start
        logger.info("Transcription done in %.2fs: %s", elapsed, text[:80])
        return text

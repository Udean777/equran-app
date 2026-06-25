import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routers.compare import router as compare_router

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
)
logger = logging.getLogger(__name__)


def create_app() -> FastAPI:
    app = FastAPI(
        title="Quran Hafalan AI",
        description="AI-powered Quran recitation comparison using Whisper",
        version="0.1.0",
    )

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    app.include_router(compare_router, prefix="")

    @app.on_event("startup")
    async def load_model():
        logger.info("Loading Whisper model on startup...")
        try:
            from services.transcriber import TranscriberService

            app.state.transcriber = TranscriberService()
            logger.info("Transcriber ready")
        except Exception:
            logger.exception("Failed to load transcriber")
            app.state.transcriber = None

    @app.get("/health")
    async def health():
        ok = getattr(app.state, "transcriber", None) is not None
        return {"status": "ok" if ok else "loading"}

    return app


app = create_app()

from typing import Optional

from pydantic import BaseModel, Field


class WordErrorItem(BaseModel):
    expected: str
    actual: str
    position: int


class CompareRequest(BaseModel):
    threshold: Optional[float] = Field(default=75.0, ge=0.0, le=100.0)
    is_arabic: Optional[bool] = Field(default=True)


class CompareResponse(BaseModel):
    score: float
    passed: bool
    threshold: float
    transcribed: str
    target: str
    cer: float
    word_errors: list[WordErrorItem] = []
    duration_ms: int = 0

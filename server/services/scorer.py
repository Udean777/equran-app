from dataclasses import dataclass, field
from typing import Optional
from utils.normalizer import normalize


@dataclass
class WordError:
    expected: str
    actual: str
    position: int


@dataclass
class ScorerResult:
    score: float
    passed: bool
    threshold: float
    transcribed: str
    target: str
    transcribed_normalized: str
    target_normalized: str
    cer: float
    word_errors: list[WordError] = field(default_factory=list)
    duration_ms: int = 0


class Scorer:
    def __init__(self, default_threshold: float = 75.0):
        self.default_threshold = default_threshold

    def score(
        self,
        transcribed: str,
        target: str,
        threshold: Optional[float] = None,
        is_arabic: bool = True,
    ) -> ScorerResult:
        threshold = threshold if threshold is not None else self.default_threshold
        norm_transcribed = normalize(transcribed, is_arabic=is_arabic)
        norm_target = normalize(target, is_arabic=is_arabic)

        if not norm_target:
            return ScorerResult(
                score=0.0,
                passed=False,
                threshold=threshold,
                transcribed=transcribed,
                target=target,
                transcribed_normalized=norm_transcribed,
                target_normalized=norm_target,
                cer=1.0,
            )

        distance = self._levenshtein(norm_transcribed, norm_target)
        max_len = max(len(norm_target), len(norm_transcribed))
        cer = distance / max_len if max_len > 0 else 0.0
        score = round((1.0 - cer) * 100, 2)

        word_errors = self._find_word_errors(norm_transcribed, norm_target)

        return ScorerResult(
            score=max(0.0, score),
            passed=score >= threshold,
            threshold=threshold,
            transcribed=transcribed,
            target=target,
            transcribed_normalized=norm_transcribed,
            target_normalized=norm_target,
            cer=round(cer, 4),
            word_errors=word_errors,
        )

    def _levenshtein(self, s1: str, s2: str) -> int:
        if len(s1) < len(s2):
            s1, s2 = s2, s1

        prev_row = list(range(len(s2) + 1))
        for i, c1 in enumerate(s1):
            curr_row = [i + 1]
            for j, c2 in enumerate(s2):
                cost = 0 if c1 == c2 else 1
                curr_row.append(
                    min(
                        prev_row[j + 1] + 1,
                        curr_row[j] + 1,
                        prev_row[j] + cost,
                    )
                )
            prev_row = curr_row

        return prev_row[-1]

    def _find_word_errors(
        self, transcribed: str, target: str
    ) -> list[WordError]:
        words_t = transcribed.split()
        words_e = target.split()
        errors: list[WordError] = []
        max_len = max(len(words_t), len(words_e))

        for i in range(max_len):
            w_t = words_t[i] if i < len(words_t) else ''
            w_e = words_e[i] if i < len(words_e) else ''
            if w_t != w_e:
                errors.append(WordError(
                    expected=w_e,
                    actual=w_t,
                    position=i,
                ))

        return errors

from services.scorer import Scorer, WordError


def test_word_errors_detected():
    scorer = Scorer()
    result = scorer.score("بسم الله", "بسم الله الرحمن")
    assert len(result.word_errors) > 0


def test_no_word_errors_on_perfect():
    scorer = Scorer()
    result = scorer.score("بسم الله", "بسم الله")
    assert len(result.word_errors) == 0


def test_word_error_position():
    scorer = Scorer()
    result = scorer.score("السلام عليكم", "بسم الله")
    assert len(result.word_errors) >= 1
    first = result.word_errors[0]
    assert first.position == 0


def test_word_error_has_expected_and_actual():
    scorer = Scorer()
    result = scorer.score("بسم الله", "بسم الرحمن")
    errors = [e for e in result.word_errors if e.expected != e.actual]
    if errors:
        assert errors[0].expected
        assert errors[0].actual

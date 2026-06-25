from services.scorer import Scorer


def test_perfect_match():
    scorer = Scorer()
    result = scorer.score("بسم الله الرحمن الرحيم", "بسم الله الرحمن الرحيم")
    assert result.score == 100.0
    assert result.passed is True
    assert result.cer == 0.0


def test_partial_match():
    scorer = Scorer()
    result = scorer.score("بسم الله الرحمن", "بسم الله الرحمن الرحيم")
    assert result.score < 100.0
    assert result.score > 0.0


def test_completely_wrong():
    scorer = Scorer()
    result = scorer.score("الحمد لله رب العالمين", "بسم الله الرحمن الرحيم")
    assert result.score < 50.0


def test_empty_transcribed():
    scorer = Scorer()
    result = scorer.score("", "بسم الله الرحمن الرحيم")
    assert result.score == 0.0
    assert result.passed is False


def test_empty_target():
    scorer = Scorer()
    result = scorer.score("بسم الله الرحمن الرحيم", "")
    assert result.score == 0.0
    assert result.passed is False


def test_custom_threshold():
    scorer = Scorer(default_threshold=90.0)
    result = scorer.score("بسم الله الرحمن", "بسم الله الرحمن الرحيم")
    assert result.threshold == 90.0


def test_levenshtein_distance():
    scorer = Scorer()
    assert scorer._levenshtein("", "") == 0
    assert scorer._levenshtein("abc", "") == 3
    assert scorer._levenshtein("", "abc") == 3
    assert scorer._levenshtein("abc", "abc") == 0
    assert scorer._levenshtein("abc", "abd") == 1
    assert scorer._levenshtein("kitten", "sitting") == 3

from utils.normalizer import normalize_arabic, normalize


def test_remove_tashkeel():
    assert normalize_arabic("بِسْمِ") == "بسم"
    assert normalize_arabic("الرَّحْمَـٰنِ") == "الرحمان"


def test_remove_tatweel():
    assert normalize_arabic("الـرحمن") == "الرحمن"


def test_normalize_alef():
    assert normalize_arabic("أحمد") == "احمد"
    assert normalize_arabic("إحسان") == "احسان"
    assert normalize_arabic("آدم") == "ادم"
    assert normalize_arabic("ٱلله") == "الله"


def test_normalize_teh_marbuta():
    assert normalize_arabic("رحمة") == "رحمه"


def test_strip_punctuation():
    assert normalize_arabic("بسم الله!") == "بسم الله"


def test_normalize_whitespace():
    assert normalize_arabic("بسم   الله") == "بسم الله"


def test_normalize_not_arabic():
    result = normalize("Hello World!", is_arabic=False)
    assert result == "hello world"


def test_empty_string():
    assert normalize_arabic("") == ""

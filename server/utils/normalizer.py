import re

ARABIC_DIACRITICS = re.compile(
    r'[\u064B-\u065F\u0610-\u061A\u06D6-\u06ED]'
)

DAGGER_ALIF = re.compile(r'\u0670')

TATWEEL = re.compile(r'\u0640+')

ALEF_VARIANTS = re.compile(r'[أإآٱ]')
TEH_MARBUTA = re.compile(r'ة')
YEH_VARIANTS = re.compile(r'[ى]')
WAW_WITH_HAMZA = re.compile(r'ؤ')

PUNCTUATION = re.compile(r'[^\w\s]')
WHITESPACE = re.compile(r'\s+')


def normalize_arabic(text: str) -> str:
    text = ARABIC_DIACRITICS.sub('', text)
    text = DAGGER_ALIF.sub('ا', text)
    text = TATWEEL.sub('', text)
    text = ALEF_VARIANTS.sub('ا', text)
    text = TEH_MARBUTA.sub('ه', text)
    text = YEH_VARIANTS.sub('ي', text)
    text = WAW_WITH_HAMZA.sub('و', text)
    text = PUNCTUATION.sub('', text)
    text = WHITESPACE.sub(' ', text)
    return text.strip()


def normalize(text: str, is_arabic: bool = True) -> str:
    if is_arabic:
        return normalize_arabic(text)
    text = text.lower()
    text = PUNCTUATION.sub('', text)
    text = WHITESPACE.sub(' ', text)
    return text.strip()

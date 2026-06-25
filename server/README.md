# Quran Hafalan AI Backend

FastAPI backend untuk fitur AI-based audio comparison (setoran hafalan).

## Tech Stack

- **Framework**: FastAPI 0.115.12
- **Speech-to-Text**: faster-whisper (base model)
- **Scoring**: Levenshtein distance → Character Error Rate
- **Testing**: pytest (19 unit tests)
- **Deployment**: Docker / Render

## Local Development

### Setup

```bash
cd server
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### Run

```bash
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

API tersedia di: `http://localhost:8000`
- Docs: `http://localhost:8000/docs`
- Health: `http://localhost:8000/health`

### Test

```bash
pytest tests/ -v
```

## Deployment

### Render (Recommended)

1. Push repo ke GitHub
2. Connect repo ke Render: https://dashboard.render.com
3. Render akan auto-detect `render.yaml` di root project
4. Click "Apply" untuk deploy service `equran-hafalan-api`
5. Service URL: `https://equran-hafalan-api.onrender.com`

**Auto-deploy**: setiap push ke branch `main` atau `dev` akan trigger deploy otomatis.

**Free tier limits**:
- 750 compute hours/month
- Sleep after 15 min inactivity (cold start ~30s)
- 512 MB RAM

**Environment**: Render akan auto-set `PORT` variable.

### Docker

```bash
# Build
docker build -t equran-hafalan-api .

# Run
docker run -p 8000:8000 equran-hafalan-api

# Docker Compose
docker-compose up
```

## API Endpoints

### POST /compare

Compare user audio recording dengan target text (ayat Al-Quran).

**Request** (multipart/form-data):
```
user_audio: file (audio .m4a, .wav, .mp3)
target_text: string (teks Arab ayat)
threshold: float (optional, default 75.0)
```

**Response**:
```json
{
  "transcribed_text": "بسم الله الرحمن الرحيم",
  "target_text": "بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ",
  "score": 95.5,
  "is_passed": true,
  "threshold": 75.0,
  "word_errors": []
}
```

**Scoring**:
- Normalisasi: strip tashkeel, normalize alef/yeh/teh-marbuta variants
- Levenshtein distance → CER (Character Error Rate)
- Score = (1 - CER) × 100
- Pass jika score ≥ threshold

### GET /health

Health check endpoint.

**Response**:
```json
{
  "status": "ok"  // or "loading" if model belum ready
}
```

## Model

- **faster-whisper base**: ~75MB, CPU-optimized (int8 quantization)
- **Language**: Arabic (`ar`)
- **Auto-download**: model di-download otomatis saat startup pertama
- **Location**: `~/.cache/huggingface/hub/`

## Architecture

```
server/
├── main.py                 # FastAPI app + startup
├── routers/
│   └── compare.py          # POST /compare endpoint
├── services/
│   ├── transcriber.py      # Whisper transcription
│   └── scorer.py           # Levenshtein CER scoring
├── utils/
│   └── normalizer.py       # Arabic text normalization
├── models/
│   └── schemas.py          # Pydantic models
└── tests/                  # Unit tests
    ├── test_compare.py
    ├── test_scorer.py
    └── test_normalizer.py
```

## Notes

- **CORS**: allow all origins (ubah di production jika perlu)
- **File upload limit**: default FastAPI (16MB)
- **Audio format**: support .m4a, .wav, .mp3, .ogg
- **Startup time**: ~5-10s (model loading)
- **Cold start (Render free)**: ~30s first request after sleep

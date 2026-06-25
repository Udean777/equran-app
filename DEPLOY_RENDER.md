# Deployment Guide: Render

Panduan deploy backend Python (FastAPI) ke Render dengan auto-deploy dari GitHub.

## Prerequisites

- ✅ Repo sudah di GitHub
- ✅ File `render.yaml` sudah ada di root project
- ✅ Akun Render (gratis): https://dashboard.render.com

---

## Step 1: Setup Render Service

### 1.1 Connect GitHub Repo

1. Login ke Render: https://dashboard.render.com
2. Klik **"New +"** → **"Blueprint"**
3. Connect GitHub account (authorize Render)
4. Pilih repo: `equran-app`
5. Klik **"Connect"**

### 1.2 Apply Blueprint

Render akan auto-detect `render.yaml` dan show preview:

```yaml
Service: equran-hafalan-api
Type: Web Service
Region: Singapore
Plan: Free
Runtime: Python 3.11
```

Klik **"Apply"** untuk create service.

### 1.3 Wait for Initial Deploy

- Build time: ~3-5 menit (install dependencies + download Whisper model)
- Status: Dashboard akan show build logs real-time
- Success: Service URL akan muncul → `https://equran-hafalan-api.onrender.com`

Test health endpoint:
```bash
curl https://equran-hafalan-api.onrender.com/health
```

Expected response:
```json
{"status": "ok"}
```

---

## Step 2: Setup Auto-Deploy (CI/CD)

### 2.1 Get Deploy Hook URL

1. Buka service di Render dashboard: `equran-hafalan-api`
2. Tab **"Settings"** → scroll ke **"Deploy Hook"**
3. Copy URL (format: `https://api.render.com/deploy/srv-xxxxx?key=yyyyy`)

### 2.2 Add GitHub Secret

1. Buka repo di GitHub: https://github.com/YOUR_USERNAME/equran-app
2. **Settings** → **Secrets and variables** → **Actions**
3. Klik **"New repository secret"**
   - Name: `RENDER_DEPLOY_HOOK_URL`
   - Value: (paste Deploy Hook URL dari Render)
4. Klik **"Add secret"**

### 2.3 Test Auto-Deploy

Push commit ke branch `main` atau `dev` yang mengubah folder `server/`:

```bash
# Example: update README
echo "# Test" >> server/README.md
git add server/README.md
git commit -m "test: trigger render deploy"
git push origin dev
```

GitHub Actions akan:
1. ✅ Run pytest (19 tests)
2. ✅ Trigger Render deployment via webhook
3. ✅ Render rebuild + redeploy service

Cek status:
- GitHub: **Actions** tab → workflow "Server CI/CD"
- Render: **Dashboard** → `equran-hafalan-api` → **Events** tab

---

## Step 3: Update Flutter App URL

### Development (Local Testing)

Gunakan IP lokal laptop:

```dart
// lib/features/hafalan/constants/hafalan_constants.dart
static const String apiBaseUrl = 'http://192.168.1.100:8000';
```

### Production (Release Build)

Ganti ke Render URL:

```dart
// lib/features/hafalan/constants/hafalan_constants.dart
static const String apiBaseUrl = 'https://equran-hafalan-api.onrender.com';
```

Rebuild app:
```bash
flutter clean
flutter build apk --release
# atau
flutter build ios --release
```

---

## Monitoring & Troubleshooting

### Check Service Status

**Render Dashboard**:
- **Logs** tab: real-time application logs
- **Metrics** tab: CPU, memory, request stats
- **Events** tab: deploy history

**Health Check**:
```bash
curl https://equran-hafalan-api.onrender.com/health
```

### Common Issues

#### 1. Service sleeping (Free Tier)
**Symptom**: First request after 15 min inactivity takes ~30s

**Solution**: Normal behavior on free tier. Upgrade ke paid plan ($7/month) untuk always-on.

**Workaround**: Ping service setiap 10 menit dengan cron job:
```yaml
# render.yaml - tambahkan cron job (optional)
services:
  - type: cron
    name: keep-alive-ping
    env: docker
    schedule: "*/10 * * * *"  # every 10 minutes
    dockerCommand: curl https://equran-hafalan-api.onrender.com/health
```

#### 2. Build failed: dependencies error
**Symptom**: `ERROR: Could not find a version that satisfies the requirement...`

**Solution**: 
- Cek `server/requirements.txt` → pastikan semua package valid
- Cek Python version di `render.yaml` → must be 3.11

#### 3. Runtime error: model not found
**Symptom**: `/health` returns `{"status": "loading"}` forever

**Solution**: 
- Cek logs di Render dashboard
- Whisper model auto-download butuh internet + ~75MB download
- Free tier RAM: 512MB (cukup untuk base model)

#### 4. CORS error dari Flutter app
**Symptom**: `DioException: Connection refused` atau `CORS policy blocked`

**Solution**:
- Cek `server/main.py` → CORS middleware sudah allow all origins
- Pastikan Flutter app pakai HTTPS: `https://equran-hafalan-api.onrender.com`
- Test langsung via curl/Postman dulu

---

## Free Tier Limits

| Resource | Limit |
|----------|-------|
| Compute hours | 750 hours/month (~31 days) |
| RAM | 512 MB |
| Bandwidth | 100 GB/month |
| Disk | Ephemeral (reset on redeploy) |
| Sleep | After 15 min inactivity |
| Build time | 20 min max |

**Tips**:
- Model Whisper di-cache setelah first download
- Logs disimpan 7 hari
- Auto-SSL certificate (HTTPS gratis)

---

## Upgrade to Paid Plan

Jika butuh:
- ✅ Always-on (no sleep)
- ✅ More RAM (1GB, 2GB, 4GB, ...)
- ✅ Custom domain
- ✅ Priority support

**Pricing**: mulai dari $7/month

Upgrade: Dashboard → Service → **"Upgrade"** button

---

## Alternative: Manual Deploy (No CI/CD)

Jika tidak mau setup GitHub Actions:

1. Push commit ke GitHub (any branch)
2. Buka Render dashboard → `equran-hafalan-api`
3. Klik **"Manual Deploy"** → **"Deploy latest commit"**
4. Wait ~3-5 min

---

## Security Notes

- ⚠️ **Deploy Hook URL is sensitive**: siapa saja yang punya URL bisa trigger deploy
- ✅ Store di GitHub Secrets (jangan commit ke repo)
- ✅ Render auto-rotate key jika leaked
- ✅ HTTPS enabled by default (auto SSL certificate)

---

## Next Steps

1. ✅ Deploy backend ke Render
2. ✅ Test endpoint via curl/Postman
3. ✅ Update Flutter app URL ke production
4. ✅ Test E2E flow: record → upload → compare
5. (Optional) Setup monitoring/alerts via Render dashboard
6. (Optional) Add custom domain (e.g., `api.equran.com`)

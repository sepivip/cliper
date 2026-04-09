# Cliper

A self-hosted media downloader with a clean web UI. Paste a link — get the file. Built on [yt-dlp](https://github.com/yt-dlp/yt-dlp) + Flask, designed to deploy safely as a public service (Turnstile, rate limits, domain allowlist, auto-cleanup) or run privately on your own machine.

Originally forked from `reclip`, rebuilt with hardening and a Revolut-style redesign.

## Features

- MP4 video or MP3 audio downloads
- Quality picker, bulk paste, auto-cleanup (30 min TTL)
- Cloudflare Turnstile bot protection (optional)
- Per-IP rate limiting (`CF-Connecting-IP` aware)
- Domain allowlist (YouTube, TikTok, X, Instagram, FB, Reddit, Vimeo, SoundCloud)
- Max duration / filesize caps
- SSRF protection (private IPs blocked)
- Concurrency semaphore + gunicorn production server
- Single-file backend, vanilla JS frontend

## Local quick start

```bash
brew install yt-dlp ffmpeg      # or: apt install ffmpeg && pip install yt-dlp
./cliper.sh
```

Open **http://localhost:8899**.

Or Docker:

```bash
docker build -t cliper .
docker run -p 8899:8899 cliper
```

## Deploy on Railway

1. Push this repo to GitHub
2. Create a new Railway project → **Deploy from GitHub repo**
3. Railway auto-detects the Dockerfile and builds
4. In **Variables**, optionally set:
   - `TURNSTILE_SITE_KEY` — Cloudflare Turnstile site key
   - `TURNSTILE_SECRET_KEY` — Cloudflare Turnstile secret
5. **Settings → Networking → Generate Domain**
6. (Recommended) Put Cloudflare in front and add a geo-block rule to restrict countries

Set a **spending cap** in Railway so traffic spikes can't drain your account.

### Tuning

All knobs live at the top of [app.py](app.py):

```python
ALLOWED_DOMAINS = {...}
MAX_DURATION_SEC = 30 * 60
MAX_FILESIZE = 500 * 1024 * 1024
FILE_TTL_SEC = 30 * 60
MAX_CONCURRENT_DOWNLOADS = 4
```

## Stack

- **Backend:** Python · Flask · gunicorn · flask-limiter
- **Frontend:** Vanilla HTML/CSS/JS (single file, no build)
- **Downloader:** yt-dlp + ffmpeg
- **Deploy:** Docker, Railway-ready

## Disclaimer

Personal use only. Respect copyright and the terms of service of the platforms you download from.

## License

MIT

FROM python:3.12-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# Always grab the latest yt-dlp at build time (YouTube breaks it frequently)
RUN pip install --no-cache-dir --upgrade yt-dlp

COPY . .

EXPOSE 8899
ENV HOST=0.0.0.0
ENV PORT=8899
CMD ["sh", "-c", "gunicorn -w 2 -k gthread --threads 8 -t 320 -b 0.0.0.0:${PORT:-8899} app:app"]

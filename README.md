# aniwave

This repository includes a simple Codespace-friendly HLS relay / re-encode script and a small player.

What I added
- .devcontainer/Dockerfile + .devcontainer/devcontainer.json — devcontainer that installs ffmpeg and Node.js so Codespaces can build/run the tools.
- public/index.html — a phone-friendly player that will play an HLS playlist served from the Codespace.
- .env.example — environment variable examples used by the scripts.

What is already here
- remote_decode.sh — a ready-to-run ffmpeg script that pulls a stream, transcodes to HLS, and serves the HLS directory via python3 -m http.server. This is the re-encode variant.

Quick usage (re-encode variant — uses remote_decode.sh)
1. In GitHub Codespaces, open this repository and let the devcontainer build (it will install ffmpeg/node).
2. Copy `.env.example` to `.env` and update STREAM_URL to the exact stream (an .m3u8 or another ffmpeg-accepted source).
3. In the Codespace terminal:
   - sudo apt-get update && sudo apt-get install -y ffmpeg   # if not using the devcontainer image
   - chmod +x remote_decode.sh
   - SRC="$STREAM_URL" OUTDIR="/workspaces/stream/hls" PORT=8080 ./remote_decode.sh
4. In the Codespaces UI forward port 8080 and open the forwarded URL on your phone. Open `/index.m3u8` or load the root page if you serve `public/index.html`.

Notes
- Be sure you are allowed to re-stream the content. Do not attempt to bypass DRM.
- Codespaces are development environments. They have resource and uptime limits. This setup is for testing/experimenting, not production streaming.

If you want I can:
- Add a low-CPU proxy-only relay (no re-encode) that reverse-proxies an HLS playlist and its segments.
- Add a Node-based server to serve the player and proxy segments with CORS headers.
- Create a small GitHub Action to start the Codespace and run the relay (not recommended for continuous streaming).


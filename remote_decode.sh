#!/usr/bin/env bash
# language: bash
# file: remote_decode.sh
# target: GitHub Codespace (Ubuntu 22.04) → ffmpeg HLS, phone plays from forwarded port
# deps: sudo apt-get install -y ffmpeg
set -euo pipefail

SRC="${SRC:-https://stream.thewave.cv/}"
OUTDIR="${OUTDIR:-/workspaces/stream/hls}"
PORT="${PORT:-8080}"
# phone-friendly: 720p max, low bitrate, keyframe every 2s
VBITRATE="${VBITRATE:-1200k}"
SCALE="${SCALE:-1280:-2}"

mkdir -p "$OUTDIR"
rm -f "$OUTDIR"/*.ts "$OUTDIR"/*.m3u8 2>/dev/null || true

echo "[ffmpeg] source=$SRC -> $OUTDIR on :$PORT"
echo "[ffmpeg] scale=$SCALE vbitrate=$VBITRATE"

# serve the HLS dir in the background
python3 -m http.server "$PORT" --directory "$OUTDIR" --bind 0.0.0.0 &
HTTP_PID=$!
trap 'kill $HTTP_PID 2>/dev/null || true' EXIT

# pull → transcode → HLS
exec ffmpeg -hide_banner -loglevel warning \
    -reconnect 1 -reconnect_streamed 1 -reconnect_delay_max 5 \
    -i "$SRC" \
    -c:v libx264 -preset veryfast -tune zerolatency \
    -vf "scale=${SCALE}" -b:v "$VBITRATE" -maxrate "$VBITRATE" -bufsize 2400k \
    -g 48 -keyint_min 48 -sc_threshold 0 \
    -c:a aac -b:a 96k -ac 2 \
    -f hls \
    -hls_time 2 \
    -hls_list_size 6 \
    -hls_flags delete_segments+append_list+omit_endlist \
    -hls_segment_filename "$OUTDIR/seg_%05d.ts" \
    "$OUTDIR/index.m3u8"

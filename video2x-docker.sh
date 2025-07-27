#!/bin/bash
# Video2X Docker Wrapper
if [ $# -lt 2 ]; then
    echo "Usage: $0 <input_file> <output_file> [options]"
    echo "Example: $0 input/video.mp4 output/upscaled.mp4 -p realesrgan -s 2"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"
shift 2
ADDITIONAL_OPTIONS="${@:--p realesrgan -s 2 --realesrgan-model realesr-animevideov3}"

echo "🎬 Processing: $INPUT_FILE → $OUTPUT_FILE"
docker run --rm -v "$(pwd)":/host ghcr.io/k4yt3x/video2x:latest \
    -i "$INPUT_FILE" -o "$OUTPUT_FILE" $ADDITIONAL_OPTIONS

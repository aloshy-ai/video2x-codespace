#!/bin/bash

# Video2X Docker Wrapper Script
# Usage: ./video2x-docker.sh input.mp4 output.mp4 [options]

if [ $# -lt 2 ]; then
    echo "Usage: $0 <input_file> <output_file> [additional_options]"
    echo ""
    echo "Examples:"
    echo "  $0 input/test.mp4 output/upscaled.mp4"
    echo "  $0 input/video.mp4 output/upscaled.mp4 -p realesrgan -s 4"
    echo "  $0 input/anime.mp4 output/anime_4k.mp4 -p anime4k -s 4"
    echo ""
    echo "Available processors (-p):"
    echo "  - realesrgan (default for real videos)"
    echo "  - anime4k (best for anime)"
    echo "  - rife (for frame interpolation)"
    echo ""
    echo "Scale factors (-s): 2, 3, 4"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"
shift 2
ADDITIONAL_OPTIONS="$@"

# Set default options if none provided
if [ -z "$ADDITIONAL_OPTIONS" ]; then
    ADDITIONAL_OPTIONS="-p realesrgan -s 2 --realesrgan-model realesr-animevideov3"
fi

echo "🎬 Starting Video2X processing..."
echo "📥 Input: $INPUT_FILE"
echo "📤 Output: $OUTPUT_FILE"
echo "⚙️  Options: $ADDITIONAL_OPTIONS"
echo ""

# Run Video2X using Docker
docker run --rm \
    -v "$(pwd)":/host \
    ghcr.io/k4yt3x/video2x:latest \
    -i "$INPUT_FILE" \
    -o "$OUTPUT_FILE" \
    $ADDITIONAL_OPTIONS

echo ""
echo "✅ Video2X processing completed!"

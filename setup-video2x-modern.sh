#!/bin/bash

echo "🎬 Setting up Video2X (Modern Version) for Codespace"
echo "===================================================="

# Check if we're in a Codespace
if [ "$CODESPACES" = "true" ]; then
    echo "✅ Running in GitHub Codespace"
else
    echo "ℹ️  Not in Codespace, but continuing..."
fi

# Install Docker if not available (shouldn't be needed in Codespaces)
if ! command -v docker &> /dev/null; then
    echo "🐳 Docker not found. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl start docker
    sudo usermod -aG docker $USER
    echo "⚠️  You may need to restart your terminal for Docker group changes to take effect"
else
    echo "✅ Docker is available"
fi

# Create directories for Video2X work
echo "📁 Setting up directories..."
mkdir -p /workspaces/video2x-codespace/{input,output,temp}

# Download a test video if it doesn't exist
echo "🎥 Setting up test video..."
if [ ! -f "/workspaces/video2x-codespace/input/test_sample.mp4" ]; then
    if command -v ffmpeg &> /dev/null; then
        ffmpeg -f lavfi -i testsrc=duration=10:size=480x360:rate=30 \
            /workspaces/video2x-codespace/input/test_sample.mp4 \
            -y -loglevel quiet 2>/dev/null || echo "Test video creation skipped"
        echo "✅ Test video created"
    else
        echo "⚠️  FFmpeg not available, skipping test video creation"
    fi
fi

# Create a Video2X wrapper script for easy usage
cat > /workspaces/video2x-codespace/video2x-docker.sh << 'EOF'
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
EOF

chmod +x /workspaces/video2x-codespace/video2x-docker.sh

# Create Python wrapper for notebook integration
cat > /workspaces/video2x-codespace/video2x_wrapper.py << 'EOF'
#!/usr/bin/env python3
"""
Python wrapper for Video2X Docker integration
"""

import subprocess
import os
import sys
from pathlib import Path

class Video2X:
    def __init__(self, workspace_dir="/workspaces/video2x-codespace"):
        self.workspace_dir = Path(workspace_dir)
        self.input_dir = self.workspace_dir / "input"
        self.output_dir = self.workspace_dir / "output"
        
    def upscale(self, input_file, output_file=None, processor="realesrgan", scale=2, model="realesr-animevideov3"):
        """
        Upscale a video using Video2X
        
        Args:
            input_file: Path to input video
            output_file: Path to output video (optional)
            processor: Processing algorithm (realesrgan, anime4k, rife)
            scale: Scale factor (2, 3, 4)
            model: Model to use for realesrgan
        """
        input_path = Path(input_file)
        
        if output_file is None:
            output_file = self.output_dir / f"{input_path.stem}_upscaled{input_path.suffix}"
        
        # Ensure output directory exists
        Path(output_file).parent.mkdir(parents=True, exist_ok=True)
        
        # Build command
        cmd = [
            "docker", "run", "--rm",
            "-v", f"{self.workspace_dir}:/host",
            "ghcr.io/k4yt3x/video2x:latest",
            "-i", str(input_file),
            "-o", str(output_file),
            "-p", processor,
            "-s", str(scale)
        ]
        
        if processor == "realesrgan":
            cmd.extend(["--realesrgan-model", model])
        
        print(f"🎬 Starting Video2X upscaling...")
        print(f"📥 Input: {input_file}")
        print(f"📤 Output: {output_file}")
        print(f"⚙️  Processor: {processor}, Scale: {scale}x")
        
        try:
            result = subprocess.run(cmd, cwd=self.workspace_dir, check=True, 
                                  capture_output=True, text=True)
            print("✅ Video2X processing completed!")
            return str(output_file)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error during processing: {e}")
            print(f"Error output: {e.stderr}")
            return None
    
    def interpolate(self, input_file, output_file=None, target_fps=60):
        """
        Perform frame interpolation using RIFE
        """
        return self.upscale(input_file, output_file, processor="rife", scale=1)

# Test function
def test_video2x():
    v2x = Video2X()
    test_file = v2x.input_dir / "test_sample.mp4"
    
    if test_file.exists():
        print("🧪 Testing Video2X with sample video...")
        result = v2x.upscale(str(test_file), scale=2)
        if result:
            print(f"✅ Test completed! Output: {result}")
        else:
            print("❌ Test failed")
    else:
        print("⚠️  No test video found. Place a video in input/ directory to test.")

if __name__ == "__main__":
    test_video2x()
EOF

chmod +x /workspaces/video2x-codespace/video2x_wrapper.py

# Install additional Python packages for video processing
echo "🐍 Installing Python packages for video processing..."
pip3 install --user opencv-python numpy matplotlib pandas tqdm pillow

# Pull the Video2X Docker image
echo "🐳 Pulling Video2X Docker image..."
if command -v docker &> /dev/null; then
    docker pull ghcr.io/k4yt3x/video2x:latest || echo "⚠️  Could not pull Docker image (may need to try later)"
else
    echo "⚠️  Docker not available, skipping image pull"
fi

echo ""
echo "✅ Video2X setup complete!"
echo ""
echo "🎯 Usage Options:"
echo "1. Command line: ./video2x-docker.sh input/video.mp4 output/upscaled.mp4"
echo "2. Python notebook: import video2x_wrapper; v2x = video2x_wrapper.Video2X()"
echo "3. Test installation: python3 video2x_wrapper.py"
echo ""
echo "📁 Directories:"
echo "  - Input videos: /workspaces/video2x-codespace/input/"
echo "  - Output videos: /workspaces/video2x-codespace/output/"
echo ""
echo "🚀 Start Jupyter: jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"

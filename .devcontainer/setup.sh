#!/bin/bash
set -e

echo "🚀 Video2X Codespace Setup"
echo "========================="

# Update system and install essential packages
echo "📦 Installing system packages..."
sudo apt-get update -qq
sudo apt-get install -y ffmpeg curl wget git build-essential

# Upgrade pip and install Python packages
echo "🐍 Setting up Python environment..."
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install jupyter jupyterlab notebook
python3 -m pip install numpy opencv-python pillow matplotlib pandas tqdm

# Create workspace directories
echo "📁 Setting up workspace..."
mkdir -p /workspaces/video2x-codespace/{input,output,temp}
sudo chown -R vscode:vscode /workspaces/video2x-codespace/

# Create sample test video
echo "🎥 Creating test video..."
if command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -f lavfi -i testsrc=duration=10:size=480x360:rate=30 \
        /workspaces/video2x-codespace/input/test_sample.mp4 \
        -y -loglevel quiet 2>/dev/null || echo "Test video creation skipped"
fi

# Setup Video2X Docker wrapper
echo "🎬 Setting up Video2X Docker integration..."

# Create Docker wrapper script
cat > /workspaces/video2x-codespace/video2x-docker.sh << 'EOF'
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
EOF

# Create Python wrapper
cat > /workspaces/video2x-codespace/video2x_wrapper.py << 'EOF'
#!/usr/bin/env python3
"""Video2X Python wrapper for easy notebook integration"""
import subprocess
import os
from pathlib import Path

class Video2X:
    def __init__(self, workspace_dir="/workspaces/video2x-codespace"):
        self.workspace_dir = Path(workspace_dir)
        self.input_dir = self.workspace_dir / "input"
        self.output_dir = self.workspace_dir / "output"
        
    def upscale(self, input_file, output_file=None, processor="realesrgan", scale=2):
        """Upscale video using Video2X Docker"""
        if output_file is None:
            input_path = Path(input_file)
            output_file = self.output_dir / f"{input_path.stem}_upscaled{input_path.suffix}"
        
        Path(output_file).parent.mkdir(parents=True, exist_ok=True)
        
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
            cmd.extend(["--realesrgan-model", "realesr-animevideov3"])
        
        print(f"🎬 Upscaling: {input_file} → {output_file}")
        try:
            subprocess.run(cmd, cwd=self.workspace_dir, check=True)
            print("✅ Processing complete!")
            return str(output_file)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error: {e}")
            return None

if __name__ == "__main__":
    # Test the wrapper
    v2x = Video2X()
    print(f"Video2X wrapper initialized. Workspace: {v2x.workspace_dir}")
EOF

# Create Jupyter startup script
cat > /workspaces/video2x-codespace/start-jupyter.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting Jupyter Lab for Video2X"
echo "=================================="
cd /workspaces/video2x-codespace
export PATH="$HOME/.local/bin:$PATH"
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
    --NotebookApp.token='' --NotebookApp.password='' \
    --NotebookApp.allow_origin='*' --NotebookApp.disable_check_xsrf=True
EOF

# Make scripts executable
chmod +x /workspaces/video2x-codespace/video2x-docker.sh
chmod +x /workspaces/video2x-codespace/video2x_wrapper.py
chmod +x /workspaces/video2x-codespace/start-jupyter.sh

# Pull Video2X Docker image (in background to avoid blocking)
echo "🐳 Pulling Video2X Docker image..."
docker pull ghcr.io/k4yt3x/video2x:latest > /dev/null 2>&1 &

echo ""
echo "✅ Setup complete!"
echo ""
echo "🎯 Quick Start:"
echo "  • Jupyter Lab: ./start-jupyter.sh"
echo "  • Process video: ./video2x-docker.sh input/video.mp4 output/upscaled.mp4"
echo "  • Python: import video2x_wrapper; v2x = video2x_wrapper.Video2X()"
echo ""
echo "📁 Directories:"
echo "  • Input:  /workspaces/video2x-codespace/input/"
echo "  • Output: /workspaces/video2x-codespace/output/"
echo ""
echo "🌐 Jupyter will be available at: http://localhost:8888"

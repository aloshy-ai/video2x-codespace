#!/bin/bash
set -e

echo "🚀 Setting up Video2X Notebook Environment (Optimized)"
echo "======================================================"

# Update system packages
echo "📦 Updating system packages..."
sudo apt-get update -qq

# Install essential system dependencies for Video2X
echo "🔧 Installing system dependencies..."
sudo apt-get install -y \
    curl wget software-properties-common build-essential \
    git ffmpeg python3-pip python3-dev libvulkan1 vulkan-utils \
    > /dev/null 2>&1

# Upgrade pip and install wheel
echo "🐍 Setting up Python environment..."
python3 -m pip install --upgrade pip setuptools wheel

# Install Jupyter ecosystem (critical for notebook)
echo "📓 Installing Jupyter ecosystem..."
pip3 install jupyter jupyterlab notebook ipywidgets jupyter-widgets-base widgetsnbextension ipykernel

# Install Video2X
echo "🎬 Installing Video2X..."
if curl -LO https://github.com/k4yt3x/video2x/releases/download/6.2.0/video2x-linux-ubuntu2204-amd64.deb 2>/dev/null; then
    if sudo apt-get install -y ./video2x-linux-ubuntu2204-amd64.deb 2>/dev/null; then
        echo "  ✅ Video2X installed via deb package"
        rm -f video2x-linux-ubuntu2204-amd64.deb
    else
        echo "  ⚠️ Deb package failed, trying pip..."
        rm -f video2x-linux-ubuntu2204-amd64.deb
        pip3 install video2x
    fi
else
    echo "  ⚠️ Download failed, trying pip..."
    pip3 install video2x
fi

# Install additional Python packages for notebook functionality
echo "📚 Installing Python packages..."
pip3 install numpy opencv-python pillow psutil tqdm matplotlib pandas

# Enable Jupyter widgets
echo "🎛️ Enabling Jupyter widgets..."
jupyter nbextension enable --py widgetsnbextension --user || true

# Set up environment variables
echo "🌍 Setting up environment..."
echo 'export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json' >> ~/.bashrc
echo 'export PATH="\$HOME/.local/bin:\$PATH"' >> ~/.bashrc

# Create workspace directories
echo "📁 Setting up workspace..."
mkdir -p /workspaces/video2x-codespace/{input,output,temp}
sudo chown -R vscode:vscode /workspaces/video2x-codespace/

# Create test video
echo "🎥 Creating test video..."
if command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -f lavfi -i testsrc=duration=10:size=480x360:rate=30 \
        /workspaces/video2x-codespace/input/test_sample.mp4 \
        -y -loglevel quiet 2>/dev/null || echo "Test video creation skipped"
fi

echo ""
echo "✅ Setup complete!"
echo "🎯 Ready to use Video2X_Codespace_Adapted.ipynb"

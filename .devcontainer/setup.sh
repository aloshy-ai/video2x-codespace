#!/bin/bash
set -e

echo "🚀 Setting up Video2X development environment..."

# Update system packages
sudo apt-get update

# Install system dependencies
sudo apt-get install -y \
    curl \
    wget \
    software-properties-common \
    libvulkan1 \
    vulkan-utils \
    mesa-vulkan-drivers \
    build-essential \
    git \
    ffmpeg

# Add FFmpeg 7 repository (if needed)
sudo add-apt-repository -y ppa:ubuntuhandbook1/ffmpeg7 || true
sudo apt-get update

# Install Video2X
echo "📦 Installing Video2X..."
curl -LO https://github.com/k4yt3x/video2x/releases/download/6.2.0/video2x-linux-ubuntu2204-amd64.deb
sudo apt-get install -y ./video2x-linux-ubuntu2204-amd64.deb || echo "Video2X installation may need GPU runtime"
rm -f video2x-linux-ubuntu2204-amd64.deb

# Install Python packages
echo "🐍 Installing Python packages..."
pip install --upgrade pip

pip install \
    jupyter \
    jupyterlab \
    notebook \
    ipywidgets \
    google-cloud-storage \
    google-auth \
    google-auth-oauthlib \
    google-auth-httplib2 \
    google-api-python-client \
    pandas \
    numpy \
    matplotlib \
    pillow \
    opencv-python \
    tqdm \
    psutil

# Enable Jupyter widgets
jupyter nbextension enable --py widgetsnbextension --sys-prefix
pip install jupyterlab-widgets

# Set up Vulkan environment
echo "🎮 Setting up Vulkan environment..."
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/intel_icd.x86_64.json:/usr/share/vulkan/icd.d/radeon_icd.x86_64.json

# Create workspace directories (note the updated path)
mkdir -p /workspaces/video2x-codespace/{input,output,temp}
sudo chown -R vscode:vscode /workspaces/video2x-codespace

echo "✅ Setup complete! You can now run the Video2X notebook."

# Check GPU availability
if command -v nvidia-smi &> /dev/null; then
    echo "🎯 GPU detected:"
    nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
else
    echo "⚠️  No GPU detected. Video2X will run in CPU mode (slower)."
fi

echo "🎯 Vulkan status:"
vulkaninfo --summary || echo "Vulkan not available"

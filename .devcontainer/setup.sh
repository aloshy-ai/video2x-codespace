#!/bin/bash
set -e

echo "🚀 Setting up Video2X development environment..."

# Update system packages
sudo apt-get update

# Install system dependencies
echo "📦 Installing system dependencies..."
sudo apt-get install -y \
    curl \
    wget \
    software-properties-common \
    build-essential \
    git \
    ffmpeg \
    python3-pip \
    python3-dev

# Install Video2X from pip (more reliable than deb package)
echo "📦 Installing Video2X..."
pip3 install --user video2x --break-system-packages || pip3 install --user video2x

# Install Python packages
echo "🐍 Installing Python packages..."
pip3 install --user \
    jupyter \
    jupyterlab \
    notebook \
    ipywidgets \
    pandas \
    numpy \
    matplotlib \
    pillow \
    opencv-python \
    tqdm \
    psutil --break-system-packages || pip3 install --user \
    jupyter \
    jupyterlab \
    notebook \
    ipywidgets \
    pandas \
    numpy \
    matplotlib \
    pillow \
    opencv-python \
    tqdm \
    psutil

# Add user bin to PATH
echo 'export PATH="\$HOME/.local/bin:\$PATH"' >> ~/.bashrc

# Enable Jupyter widgets
jupyter nbextension enable --py widgetsnbextension --user || echo "Jupyter widgets setup skipped"

# Create workspace directories
mkdir -p /workspaces/video2x-codespace/{input,output,temp}

echo "✅ Setup complete! You can now run the Video2X notebook."

# Check installations
echo "🎯 Installation status:"
python3 --version
which python3
echo "Video2X path: \$(which video2x || echo 'Not in PATH - use ~/.local/bin/video2x')"
echo "Jupyter path: \$(which jupyter || echo 'Not in PATH - use ~/.local/bin/jupyter')"

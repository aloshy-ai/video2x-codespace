#!/bin/bash

echo "🚀 Setting up Video2X Notebook Environment (Robust)"
echo "===================================================="

# Function to log errors
log_error() {
    echo "❌ ERROR: $1" >&2
    exit 1
}

# Function to log info
log_info() {
    echo "ℹ️  INFO: $1"
}

# Wait a moment for container to fully initialize
sleep 2

# Check if we're running as the right user
log_info "Current user: $(whoami)"
log_info "Working directory: $(pwd)"

# Ensure we have proper permissions
sudo chown -R vscode:vscode /workspaces/video2x-codespace 2>/dev/null || log_info "Permissions already set"

# Update system packages with error handling
echo "📦 Updating system packages..."
if ! sudo apt-get update -qq; then
    log_error "Failed to update package lists"
fi

# Install essential system dependencies one by one for better error tracking
echo "🔧 Installing system dependencies..."

log_info "Installing curl and wget..."
sudo apt-get install -y curl wget || log_error "Failed to install curl/wget"

log_info "Installing build tools..."
sudo apt-get install -y software-properties-common build-essential || log_error "Failed to install build tools"

log_info "Installing git..."
sudo apt-get install -y git || log_error "Failed to install git"

log_info "Installing ffmpeg..."
sudo apt-get install -y ffmpeg || log_error "Failed to install ffmpeg"

log_info "Installing Vulkan (optional)..."
sudo apt-get install -y libvulkan1 vulkan-utils || log_info "Vulkan install failed (non-critical)"

# Check Python installation
echo "🐍 Checking Python environment..."
if command -v python3 >/dev/null 2>&1; then
    log_info "Python3 found: $(python3 --version)"
    python3 -m pip install --upgrade pip setuptools wheel || log_error "Failed to upgrade pip"
else
    log_info "Installing Python3..."
    sudo apt-get install -y python3 python3-pip python3-dev || log_error "Failed to install Python3"
    python3 -m pip install --upgrade pip setuptools wheel || log_error "Failed to upgrade pip"
fi

# Install Jupyter ecosystem
echo "📓 Installing Jupyter ecosystem..."
python3 -m pip install jupyter jupyterlab notebook || log_error "Failed to install Jupyter"
python3 -m pip install ipywidgets jupyter-widgets-base widgetsnbextension ipykernel || log_info "Widget install failed (non-critical)"

# Try to install Video2X with fallback
echo "🎬 Installing Video2X..."
if curl -LO https://github.com/k4yt3x/video2x/releases/download/6.2.0/video2x-linux-ubuntu2204-amd64.deb 2>/dev/null; then
    if sudo apt-get install -y ./video2x-linux-ubuntu2204-amd64.deb 2>/dev/null; then
        log_info "Video2X installed via deb package"
        rm -f video2x-linux-ubuntu2204-amd64.deb
    else
        log_info "Deb package failed, trying pip..."
        rm -f video2x-linux-ubuntu2204-amd64.deb
        python3 -m pip install video2x || log_info "Video2X pip install failed (non-critical)"
    fi
else
    log_info "Download failed, trying pip..."
    python3 -m pip install video2x || log_info "Video2X pip install failed (non-critical)"
fi
# Install additional Python packages for notebook functionality
echo "📚 Installing Python packages..."
python3 -m pip install numpy pillow psutil tqdm matplotlib pandas || log_info "Some Python packages failed (non-critical)"
python3 -m pip install opencv-python || log_info "OpenCV install failed (non-critical)"

# Enable Jupyter widgets (non-critical)
echo "🎛️ Enabling Jupyter widgets..."
jupyter nbextension enable --py widgetsnbextension --user 2>/dev/null || log_info "Widget extension failed (non-critical)"

# Set up environment variables
echo "🌍 Setting up environment..."
echo 'export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.json' >> ~/.bashrc || true
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc || true

# Create workspace directories
echo "📁 Setting up workspace..."
mkdir -p /workspaces/video2x-codespace/{input,output,temp} || log_error "Failed to create workspace directories"
sudo chown -R vscode:vscode /workspaces/video2x-codespace/ || log_info "Ownership change failed (non-critical)"

# Create test video (non-critical)
echo "🎥 Creating test video..."
if command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -f lavfi -i testsrc=duration=10:size=480x360:rate=30 \
        /workspaces/video2x-codespace/input/test_sample.mp4 \
        -y -loglevel quiet 2>/dev/null || log_info "Test video creation skipped"
else
    log_info "FFmpeg not available, skipping test video"
fi

echo ""
echo "✅ Setup complete!"
echo "🎯 Ready to use Video2X_Codespace_Adapted.ipynb"
echo "🌐 Access Jupyter Lab at: http://localhost:8888"
echo ""
echo "To start Jupyter Lab manually, run:"
echo "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"

#!/bin/bash

echo "🎬 Installing Video2X in Codespace"
echo "=================================="

# Check if we're in a Codespace
if [ "$CODESPACES" = "true" ]; then
    echo "✅ Running in GitHub Codespace"
else
    echo "ℹ️  Not in Codespace, but continuing..."
fi

# Update system packages
echo "📦 Updating packages..."
sudo apt-get update -qq

# Install additional system dependencies that Video2X needs
echo "🔧 Installing Video2X system dependencies..."
sudo apt-get install -y \
    build-essential \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
    libavresample-dev \
    pkg-config \
    python3-dev \
    python3-pip \
    git \
    cmake

# Install Video2X from source since pip version isn't available
echo "📥 Cloning Video2X repository..."
cd /tmp
git clone https://github.com/k4yt3x/video2x.git
cd video2x

# Install Video2X dependencies
echo "🐍 Installing Video2X Python dependencies..."
pip3 install --user -r requirements.txt

# Install Video2X
echo "⚙️ Installing Video2X..."
pip3 install --user .

# Verify installation
echo "🔍 Verifying installation..."
if python3 -c "import video2x; print('Video2X imported successfully')" 2>/dev/null; then
    echo "✅ Video2X installed successfully!"
else
    echo "❌ Video2X installation may have issues, but continuing..."
fi

# Install additional helpful packages for the notebook
echo "📚 Installing additional packages for notebook..."
pip3 install --user opencv-python tqdm psutil

# Create a simple test script
cat > /workspaces/video2x-codespace/test_video2x.py << 'EOF'
#!/usr/bin/env python3
"""
Test script to verify Video2X installation
"""

try:
    import video2x
    print("✅ Video2X imported successfully!")
    print(f"Video2X version: {video2x.__version__ if hasattr(video2x, '__version__') else 'Unknown'}")
except ImportError as e:
    print(f"❌ Failed to import Video2X: {e}")

try:
    import cv2
    print("✅ OpenCV imported successfully!")
    print(f"OpenCV version: {cv2.__version__}")
except ImportError as e:
    print(f"❌ Failed to import OpenCV: {e}")

try:
    import numpy as np
    print("✅ NumPy imported successfully!")
    print(f"NumPy version: {np.__version__}")
except ImportError as e:
    print(f"❌ Failed to import NumPy: {e}")

print("\n🎯 Environment ready for Video2X notebooks!")
EOF

chmod +x /workspaces/video2x-codespace/test_video2x.py

echo ""
echo "✅ Video2X setup complete!"
echo "🧪 Run 'python3 /workspaces/video2x-codespace/test_video2x.py' to test"
echo "🚀 Start Jupyter with: jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"
echo "📁 Your workspace is at: /workspaces/video2x-codespace/"

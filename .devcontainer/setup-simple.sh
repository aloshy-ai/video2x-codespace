#!/bin/bash
set -e

echo "🚀 Setting up Video2X Environment (Simple)"
echo "=========================================="

# Update package lists
apt-get update

# Install essential packages
apt-get install -y \
    curl wget git sudo \
    python3 python3-pip python3-dev \
    ffmpeg build-essential \
    software-properties-common

# Create user
useradd -m -s /bin/bash vscode
usermod -aG sudo vscode
echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to vscode user for package installations
su - vscode -c "
    python3 -m pip install --user --upgrade pip setuptools wheel
    python3 -m pip install --user jupyter jupyterlab notebook
    python3 -m pip install --user video2x numpy opencv-python pillow psutil tqdm matplotlib pandas
    
    mkdir -p /workspaces/video2x-codespace/{input,output,temp}
"

# Set ownership
chown -R vscode:vscode /workspaces/

echo "✅ Setup complete!"
echo "🌐 Start Jupyter with: jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"

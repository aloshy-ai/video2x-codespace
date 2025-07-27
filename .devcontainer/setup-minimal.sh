#!/bin/bash

echo "🚀 Minimal Video2X Setup"
echo "========================"

# Update and install only essential packages
sudo apt-get update
sudo apt-get install -y ffmpeg curl wget git

# Install Python packages
python3 -m pip install --upgrade pip
python3 -m pip install jupyter jupyterlab notebook
python3 -m pip install numpy pillow matplotlib pandas

# Try to install Video2X (allow failure)
python3 -m pip install video2x || echo "Video2X install failed - you can install it manually later"

# Create workspace
mkdir -p /workspaces/video2x-codespace/{input,output,temp}

echo "✅ Minimal setup complete!"
echo "🌐 Start Jupyter: jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"

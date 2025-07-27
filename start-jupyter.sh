#!/bin/bash

echo "🚀 Starting Video2X Jupyter Environment"
echo "======================================"

# Set up environment
export PATH="$HOME/.local/bin:$PATH"

# Check if Jupyter is installed
if ! command -v jupyter &> /dev/null; then
    echo "📦 Installing Jupyter..."
    pip3 install --user jupyter jupyterlab notebook
fi

# Create directories if they don't exist
mkdir -p /workspaces/video2x-codespace/{input,output,temp}

# Start Jupyter Lab
echo "🌐 Starting Jupyter Lab..."
echo "📍 Workspace: /workspaces/video2x-codespace"
echo "🔗 Access URL: http://localhost:8888"
echo ""
echo "Press Ctrl+C to stop Jupyter Lab"
echo ""

cd /workspaces/video2x-codespace

# Start Jupyter Lab with proper configuration for Codespaces
jupyter lab \
    --ip=0.0.0.0 \
    --port=8888 \
    --no-browser \
    --allow-root \
    --NotebookApp.token='' \
    --NotebookApp.password='' \
    --NotebookApp.allow_origin='*' \
    --NotebookApp.disable_check_xsrf=True

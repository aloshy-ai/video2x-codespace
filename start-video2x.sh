#!/bin/bash

echo "🎬 Video2X Codespace - Production Setup"
echo "======================================"

# Check if we're in Codespace
if [ "$CODESPACES" = "true" ]; then
    echo "✅ Running in GitHub Codespace"
    WORKSPACE_DIR="/workspaces/video2x-codespace"
else
    echo "⚠️ Not in Codespace - using current directory"
    WORKSPACE_DIR="$(pwd)"
fi

echo "📍 Workspace: $WORKSPACE_DIR"

# Ensure we're in the right directory
cd "$WORKSPACE_DIR" || exit 1

# Create directories
echo "📁 Setting up directories..."
mkdir -p input output temp

# Test Video2X installation
echo "🔧 Testing Video2X..."
if command -v video2x >/dev/null 2>&1; then
    echo "✅ Video2X found: $(video2x --version | head -1)"
else
    echo "❌ Video2X not found - running setup..."
    
    # Run the setup script
    if [ -f ".devcontainer/setup.sh" ]; then
        echo "📦 Running setup script..."
        .devcontainer/setup.sh
    else
        echo "⚠️ Setup script not found - manual installation needed"
    fi
fi

# Test Python environment
echo "🐍 Testing Python environment..."
python3 test-notebook.py

# Start Jupyter Lab
echo "🚀 Starting Jupyter Lab..."
echo "💡 Access via forwarded ports in VS Code"

# Set PATH to include local bin
export PATH="$HOME/.local/bin:$PATH"

# Start Jupyter with proper configuration
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
    --notebook-dir="$WORKSPACE_DIR" \
    --ServerApp.token='' \
    --ServerApp.password='' \
    --ServerApp.allow_origin='*' \
    --ServerApp.allow_remote_access=True


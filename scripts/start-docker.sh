#!/bin/bash

echo "🐳 Starting Docker Daemon for Video2X"
echo "===================================="

# Check if Docker daemon is running
if docker info >/dev/null 2>&1; then
    echo "✅ Docker daemon is already running"
else
    echo "🔄 Starting Docker daemon..."
    
    # Start Docker daemon in background
    sudo dockerd >/dev/null 2>&1 &
    
    # Wait for Docker to be ready
    echo "⏳ Waiting for Docker to be ready..."
    for i in {1..30}; do
        if docker info >/dev/null 2>&1; then
            echo "✅ Docker daemon started successfully"
            break
        fi
        sleep 1
        echo "   Waiting... ($i/30)"
    done
    
    if ! docker info >/dev/null 2>&1; then
        echo "❌ Failed to start Docker daemon"
        echo "💡 Try running: sudo service docker start"
        exit 1
    fi
fi

# Check if Video2X image is available
echo ""
echo "🔍 Checking Video2X Docker image..."
if docker images | grep -q "ghcr.io/k4yt3x/video2x"; then
    echo "✅ Video2X image already available"
else
    echo "📦 Pulling Video2X image..."
    if docker pull ghcr.io/k4yt3x/video2x:latest; then
        echo "✅ Video2X image pulled successfully"
    else
        echo "❌ Failed to pull Video2X image"
        echo "💡 Check internet connection and try again"
    fi
fi

echo ""
echo "🎯 Docker Status:"
docker --version
echo "📦 Available images:"
docker images | grep -E "(REPOSITORY|video2x)" || echo "No Video2X images found"

echo ""
echo "✅ Docker setup complete!"
echo "🎬 You can now use Video2X for video processing"

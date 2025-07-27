#!/bin/bash
echo "🔍 Verifying Video2X Codespace Setup..."
echo ""

echo "📊 System Information:"
echo "CPU cores: $(nproc)"
echo "RAM: $(free -h | awk '/^Mem:/ { print $2 }')"
echo "Disk: $(df -h / | awk 'NR==2 { print $4 " available" }')"
echo ""

echo "🐍 Python Environment:"
python3 --version
pip3 --version
echo ""

echo "📦 Video2X Installation:"
if command -v video2x &> /dev/null; then
    echo "✅ Video2X is installed"
    video2x --version
else
    echo "❌ Video2X not found"
fi
echo ""

echo "🎮 GPU Status:"
if command -v nvidia-smi &> /dev/null; then
    echo "✅ NVIDIA GPU detected:"
    nvidia-smi --query-gpu=name,memory.total --format=csv,noheader
else
    echo "⚠️ No NVIDIA GPU detected - will use CPU processing"
fi
echo ""

echo "📂 Project Structure:"
ls -la
echo ""

echo "🧪 Python Packages:"
pip3 list | grep -E "jupyter|ipywidgets|numpy|opencv"
echo ""

echo "✅ Verification complete!"

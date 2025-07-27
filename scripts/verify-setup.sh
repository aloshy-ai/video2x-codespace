#!/bin/bash

echo "🧪 Video2X Codespace Structure Verification"
echo "==========================================="

# Check directory structure
echo "📁 Checking directory structure..."
directories=(".devcontainer" "scripts" "input" "output" "temp")
for dir in "${directories[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✅ $dir/"
    else
        echo "  ❌ $dir/ (missing)"
    fi
done

# Check essential files
echo ""
echo "📄 Checking essential files..."
files=(
    ".devcontainer/devcontainer.json"
    ".devcontainer/setup.sh"
    "scripts/video2x-docker.sh"
    "scripts/video2x_wrapper.py" 
    "scripts/start-jupyter.sh"
    "scripts/test_video2x.py"
    "Video2X_Codespace_Adapted.ipynb"
    "README.md"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "  ✅ $file"
    else
        echo "  ❌ $file (missing)"
    fi
done

# Check script permissions
echo ""
echo "🔧 Checking script permissions..."
scripts=("scripts/video2x-docker.sh" "scripts/start-jupyter.sh" "scripts/test_video2x.py" ".devcontainer/setup.sh")
for script in "${scripts[@]}"; do
    if [ -x "$script" ]; then
        echo "  ✅ $script (executable)"
    else
        echo "  ⚠️  $script (not executable)"
        chmod +x "$script" 2>/dev/null && echo "    🔧 Fixed permissions"
    fi
done

echo ""
echo "📊 Project Statistics:"
echo "  📁 Directories: $(find . -type d | wc -l)"
echo "  📄 Files: $(find . -type f | wc -l)"
echo "  💾 Total size: $(du -sh . | cut -f1)"

echo ""
echo "✅ Verification complete!"
echo "🚀 Ready to use Video2X Codespace"

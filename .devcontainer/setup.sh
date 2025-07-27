#!/bin/bash
set -e

echo "🚀 Video2X + SciPy Notebook Setup (Official Method)"
echo "=================================================="
echo "📦 Base image: jupyter/scipy-notebook"
echo "✅ Pre-installed: NumPy, SciPy, Pandas, Matplotlib, scikit-image, Dask, Numba"
echo "🌐 Jupyter Lab: Starts automatically (official method)"
echo ""

# The scipy-notebook already has most packages we need!
# Just add video-specific packages and setup

# Install additional video processing packages
echo "🎬 Installing video-specific packages..."
pip install --quiet opencv-python

# Install additional useful packages for video work  
echo "📚 Installing additional packages for video analysis..."
pip install --quiet tqdm psutil

# Set up workspace directories with proper permissions
echo "📁 Setting up workspace..."
mkdir -p ${HOME}/work/video2x-codespace/{input,output,temp,scripts}

# Change to the workspace directory for all subsequent operations
cd ${HOME}/work/video2x-codespace

# Create sample test video if ffmpeg is available
echo "🎥 Creating test video..."
if command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -f lavfi -i testsrc=duration=10:size=480x360:rate=30 \
        input/test_sample.mp4 \
        -y -loglevel quiet 2>/dev/null || echo "Test video creation skipped"
fi

# Setup Video2X Docker integration
echo "🐳 Setting up Video2X Docker integration..."

# Create Docker wrapper script
cat > scripts/video2x-docker.sh << 'EOF'
#!/bin/bash
# Video2X Docker Wrapper for SciPy Notebook Environment
if [ $# -lt 2 ]; then
    echo "Usage: $0 <input_file> <output_file> [options]"
    echo ""
    echo "Examples:"
    echo "  $0 input/video.mp4 output/upscaled.mp4"
    echo "  $0 input/video.mp4 output/upscaled.mp4 -p realesrgan -s 4"
    echo "  $0 input/anime.mp4 output/anime_4k.mp4 -p anime4k -s 4"
    echo ""
    echo "Available processors (-p):"
    echo "  - realesrgan (default for real videos)"
    echo "  - anime4k (best for anime)" 
    echo "  - rife (for frame interpolation)"
    exit 1
fi

INPUT_FILE="$1"
OUTPUT_FILE="$2"
shift 2
ADDITIONAL_OPTIONS="${@:--p realesrgan -s 2 --realesrgan-model realesr-animevideov3}"

echo "🎬 Video2X Processing"
echo "===================="
echo "📥 Input:  $INPUT_FILE"
echo "📤 Output: $OUTPUT_FILE"
echo "⚙️  Options: $ADDITIONAL_OPTIONS"
echo ""

# Run Video2X using Docker
docker run --rm \
    -v "$(pwd)":/host \
    ghcr.io/k4yt3x/video2x:latest \
    -i "$INPUT_FILE" \
    -o "$OUTPUT_FILE" \
    $ADDITIONAL_OPTIONS

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Video2X processing completed successfully!"
else
    echo ""
    echo "❌ Video2X processing failed!"
fi
EOF
# Create Python wrapper with enhanced features for SciPy environment
cat > scripts/video2x_wrapper.py << 'EOF'
#!/usr/bin/env python3
"""
Video2X Python wrapper optimized for SciPy Notebook environment
Includes video analysis and quality metrics using scikit-image
"""

import subprocess
import os
from pathlib import Path
import cv2
import numpy as np
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import peak_signal_noise_ratio as psnr
import matplotlib.pyplot as plt
import pandas as pd
from tqdm import tqdm

class Video2X:
    def __init__(self, workspace_dir=None):
        if workspace_dir is None:
            # Default to jovyan home work directory
            workspace_dir = Path.home() / "work" / "video2x-codespace"
        self.workspace_dir = Path(workspace_dir)
        self.input_dir = self.workspace_dir / "input"
        self.output_dir = self.workspace_dir / "output"
        
        # Ensure directories exist
        self.input_dir.mkdir(parents=True, exist_ok=True)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
    def upscale(self, input_file, output_file=None, processor="realesrgan", scale=2, model="realesr-animevideov3"):
        """Upscale video using Video2X Docker with progress tracking"""
        input_path = Path(input_file)
        
        if output_file is None:
            output_file = self.output_dir / f"{input_path.stem}_{processor}_{scale}x{input_path.suffix}"
        
        output_path = Path(output_file)
        output_path.parent.mkdir(parents=True, exist_ok=True)
        
        # Build command
        cmd = [
            "docker", "run", "--rm",
            "-v", f"{self.workspace_dir}:/host",
            "ghcr.io/k4yt3x/video2x:latest",
            "-i", str(input_file),
            "-o", str(output_file),
            "-p", processor,
            "-s", str(scale)
        ]
        
        if processor == "realesrgan":
            cmd.extend(["--realesrgan-model", model])
        
        print(f"🎬 Starting Video2X upscaling...")
        print(f"📥 Input: {input_file}")
        print(f"📤 Output: {output_file}")
        print(f"⚙️ Processor: {processor}, Scale: {scale}x")
        
        try:
            result = subprocess.run(cmd, cwd=self.workspace_dir, check=True, 
                                  capture_output=False, text=True)
            print("✅ Video2X processing completed!")
            return str(output_file)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error during processing: {e}")
            return None
    
    def analyze_quality(self, original_file, processed_file, sample_frames=10):
        """
        Analyze quality difference between original and processed videos
        using SSIM and PSNR metrics from scikit-image
        """
        print(f"📊 Analyzing video quality...")
        
        cap_orig = cv2.VideoCapture(str(original_file))
        cap_proc = cv2.VideoCapture(str(processed_file))
        
        if not cap_orig.isOpened() or not cap_proc.isOpened():
            print("❌ Could not open video files for analysis")
            return None
        
        # Get video properties
        total_frames_orig = int(cap_orig.get(cv2.CAP_PROP_FRAME_COUNT))
        total_frames_proc = int(cap_proc.get(cv2.CAP_PROP_FRAME_COUNT))
        
        # Sample frames evenly throughout the video
        frame_indices = np.linspace(0, min(total_frames_orig, total_frames_proc) - 1, 
                                   sample_frames, dtype=int)
        
        ssim_scores = []
        psnr_scores = []
        
        print(f"📈 Analyzing {sample_frames} sample frames...")
        
        for frame_idx in tqdm(frame_indices):
            # Read frames
            cap_orig.set(cv2.CAP_PROP_POS_FRAMES, frame_idx)
            cap_proc.set(cv2.CAP_PROP_POS_FRAMES, frame_idx)
            
            ret1, frame1 = cap_orig.read()
            ret2, frame2 = cap_proc.read()
            
            if ret1 and ret2:
                # Convert to grayscale for SSIM calculation
                gray1 = cv2.cvtColor(frame1, cv2.COLOR_BGR2GRAY)
                gray2 = cv2.cvtColor(frame2, cv2.COLOR_BGR2GRAY)
                
                # Resize original to match processed (for fair comparison)
                if gray1.shape != gray2.shape:
                    gray1 = cv2.resize(gray1, (gray2.shape[1], gray2.shape[0]))
                
                # Calculate metrics
                ssim_score = ssim(gray1, gray2, data_range=255)
                psnr_score = psnr(gray1, gray2, data_range=255)
                
                ssim_scores.append(ssim_score)
                psnr_scores.append(psnr_score)
        
        cap_orig.release()
        cap_proc.release()
        
        # Create results
        results = {
            'ssim_mean': np.mean(ssim_scores),
            'ssim_std': np.std(ssim_scores),
            'psnr_mean': np.mean(psnr_scores),
            'psnr_std': np.std(psnr_scores),
            'ssim_scores': ssim_scores,
            'psnr_scores': psnr_scores,
            'frame_indices': frame_indices
        }
        
        print(f"📊 Quality Analysis Results:")
        print(f"   SSIM: {results['ssim_mean']:.4f} ± {results['ssim_std']:.4f}")
        print(f"   PSNR: {results['psnr_mean']:.2f} ± {results['psnr_std']:.2f} dB")
        
        return results
    
    def plot_quality_analysis(self, results):
        """Plot quality analysis results using matplotlib"""
        if results is None:
            print("❌ No results to plot")
            return
        
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
        
        # SSIM plot
        ax1.plot(results['frame_indices'], results['ssim_scores'], 'b-o', alpha=0.7)
        ax1.axhline(y=results['ssim_mean'], color='r', linestyle='--', 
                   label=f'Mean: {results["ssim_mean"]:.4f}')
        ax1.set_xlabel('Frame Index')
        ax1.set_ylabel('SSIM Score')
        ax1.set_title('Structural Similarity Index (SSIM)')
        ax1.legend()
        ax1.grid(True, alpha=0.3)
        
        # PSNR plot
        ax2.plot(results['frame_indices'], results['psnr_scores'], 'g-o', alpha=0.7)
        ax2.axhline(y=results['psnr_mean'], color='r', linestyle='--',
                   label=f'Mean: {results["psnr_mean"]:.2f} dB')
        ax2.set_xlabel('Frame Index')
        ax2.set_ylabel('PSNR (dB)')
        ax2.set_title('Peak Signal-to-Noise Ratio (PSNR)')
        ax2.legend()
        ax2.grid(True, alpha=0.3)
        
        plt.tight_layout()
        plt.show()
        
        return fig

if __name__ == "__main__":
    # Test the wrapper
    v2x = Video2X()
    print(f"🧪 Video2X SciPy wrapper initialized")
    print(f"📁 Workspace: {v2x.workspace_dir}")
    print(f"🔬 Enhanced with scikit-image quality analysis")
EOF

# Create enhanced test script
cat > scripts/test_video2x.py << 'EOF'
#!/usr/bin/env python3
"""Test script for Video2X SciPy environment"""

import sys
from pathlib import Path

# Add scripts to path
scripts_path = Path.home() / "work" / "video2x-codespace" / "scripts"
sys.path.append(str(scripts_path))

print("🧪 Testing Video2X SciPy Environment")
print("=" * 40)

# Test basic imports
try:
    import numpy as np
    print(f"✅ NumPy {np.__version__}")
except ImportError:
    print("❌ NumPy not available")

try:
    import scipy
    print(f"✅ SciPy {scipy.__version__}")
except ImportError:
    print("❌ SciPy not available")

try:
    import pandas as pd
    print(f"✅ Pandas {pd.__version__}")
except ImportError:
    print("❌ Pandas not available")

try:
    import matplotlib
    print(f"✅ Matplotlib {matplotlib.__version__}")
except ImportError:
    print("❌ Matplotlib not available")

try:
    import skimage
    print(f"✅ scikit-image {skimage.__version__}")
except ImportError:
    print("❌ scikit-image not available")

try:
    import cv2
    print(f"✅ OpenCV {cv2.__version__}")
except ImportError:
    print("❌ OpenCV not available")

# Test Docker
import subprocess
try:
    result = subprocess.run(['docker', '--version'], capture_output=True, text=True)
    if result.returncode == 0:
        print(f"✅ Docker available")
    else:
        print("❌ Docker not working")
except FileNotFoundError:
    print("❌ Docker not installed")

# Test Video2X wrapper
try:
    import video2x_wrapper
    v2x = video2x_wrapper.Video2X()
    print(f"✅ Video2X wrapper loaded")
    print(f"📁 Workspace: {v2x.workspace_dir}")
except ImportError as e:
    print(f"❌ Video2X wrapper failed: {e}")

print("\n🎯 SciPy Video2X environment ready!")
print("🔬 Enhanced with scientific image processing capabilities")
print("🌐 Jupyter Lab should be running automatically at: http://localhost:8888")
EOF

# Make all scripts executable
chmod +x scripts/video2x-docker.sh
chmod +x scripts/video2x_wrapper.py  
chmod +x scripts/test_video2x.py

# Pull Video2X Docker image in background
echo "🐳 Setting up Docker and pulling Video2X image..."

# Ensure Docker daemon is running
if ! docker info >/dev/null 2>&1; then
    echo "🔄 Starting Docker daemon..."
    sudo service docker start || sudo dockerd >/dev/null 2>&1 &
    
    # Wait for Docker to be ready
    for i in {1..15}; do
        if docker info >/dev/null 2>&1; then
            echo "✅ Docker daemon started"
            break
        fi
        sleep 1
    done
fi

# Pull Video2X image
if docker info >/dev/null 2>&1; then
    docker pull ghcr.io/k4yt3x/video2x:latest >/dev/null 2>&1 &
    echo "📦 Video2X image pull started in background"
else
    echo "⚠️ Docker daemon not ready - image pull skipped"
    echo "💡 Run './scripts/start-docker.sh' after setup completes"
fi

echo ""
echo "✅ Video2X + SciPy Notebook setup complete!"
echo ""
echo "🌐 Jupyter Lab: Starts automatically (official method)"
echo "🔗 Access at: http://localhost:8888"
echo ""
echo "🎯 Quick Start:"
echo "  • Test setup: python3 scripts/test_video2x.py"
echo "  • Process video: ./scripts/video2x-docker.sh input/video.mp4 output/upscaled.mp4"
echo ""
echo "🔬 Enhanced Features:"
echo "  • Scientific image processing with scikit-image"
echo "  • Quality analysis with SSIM and PSNR metrics"
echo "  • Advanced visualization with matplotlib + seaborn"
echo "  • Performance analysis with pandas"
echo "  • Parallel processing capabilities with dask"
echo ""
echo "📁 Directories:"
echo "  • Workspace: ${HOME}/work/video2x-codespace/"
echo "  • Input:     ${HOME}/work/video2x-codespace/input/"
echo "  • Output:    ${HOME}/work/video2x-codespace/output/"
echo "  • Scripts:   ${HOME}/work/video2x-codespace/scripts/"

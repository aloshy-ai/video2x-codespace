# Video2X Codespace

AI-powered video upscaling using Video2X v6+ on the professional Jupyter SciPy Notebook environment.

## 🚀 Quick Start

1. **Open in Codespace** - Jupyter Lab starts automatically at http://localhost:8888
2. **Process videos**:
   ```bash
   # Test environment
   python3 scripts/test_video2x.py
   
   # Upscale video
   ./scripts/video2x-docker.sh input/video.mp4 output/upscaled.mp4
   ```

## 📁 Structure

```
├── .devcontainer/           # Codespace configuration  
├── scripts/                 # Utilities
│   ├── video2x-docker.sh   # Command-line processing
│   ├── video2x_wrapper.py  # Python integration with quality analysis
│   └── test_video2x.py     # Environment test
├── input/                   # Place videos here
├── output/                  # Processed videos
└── Video2X_Codespace_Adapted.ipynb  # Main notebook
```

## 🎬 Video Processing

### Jupyter Notebook (Recommended)
Access http://localhost:8888 and use the enhanced Python wrapper:

```python
import sys
sys.path.append('scripts')
import video2x_wrapper

# Enhanced wrapper with quality analysis  
v2x = video2x_wrapper.Video2X()

# Process with automatic quality analysis
output = v2x.upscale("input/video.mp4", processor="realesrgan", scale=2)

# Analyze video quality using scikit-image
results = v2x.analyze_quality("input/video.mp4", output)
v2x.plot_quality_analysis(results)
```

### Command Line
```bash
# Real-world videos (Real-ESRGAN 2x)
./scripts/video2x-docker.sh input/video.mp4 output/upscaled.mp4

# Anime content (Anime4K 4x)  
./scripts/video2x-docker.sh input/anime.mp4 output/anime_4k.mp4 -p anime4k -s 4

# Frame interpolation (RIFE)
./scripts/video2x-docker.sh input/video.mp4 output/smooth.mp4 -p rife
```

## 🧠 AI Algorithms

- **Real-ESRGAN**: Best for real-world videos and photos
- **Anime4K**: Optimized for anime and cartoon content  
- **RIFE**: Frame interpolation for smoother motion

## 🔬 Scientific Features

**Pre-installed in SciPy environment:**
- **Core**: NumPy, SciPy, Pandas, Matplotlib, Seaborn
- **Image Processing**: scikit-image for video frame analysis
- **Performance**: Numba, Dask for parallel processing  
- **Quality Metrics**: SSIM, PSNR analysis with scikit-image
- **Machine Learning**: scikit-learn for content analysis

**Video-specific additions:**
- **OpenCV**: Video I/O and processing
- **Enhanced wrapper**: Quality analysis and batch processing

## 💡 Tips

- Start with short clips to test settings
- Real-ESRGAN 2x: Good balance of quality and speed
- Anime4K 4x: Best for animated content
- Output files are typically 2-8x larger than input
- Processing time: ~30 seconds to 2 minutes per input minute

---

*Professional video processing with scientific analysis powered by Jupyter SciPy Notebook.*

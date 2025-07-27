# Video2X Codespace

A streamlined GitHub Codespace environment for AI-powered video upscaling using the modern Video2X v6+ Docker implementation.

## 🚀 Quick Start

1. **Open in Codespace** - The environment sets up automatically
2. **Start working**:
   ```bash
   # Start Jupyter Lab
   ./scripts/start-jupyter.sh
   
   # Or process videos directly
   ./scripts/video2x-docker.sh input/video.mp4 output/upscaled.mp4
   ```

## 📁 Project Structure

```
video2x-codespace/
├── .devcontainer/                 # Codespace configuration
│   ├── devcontainer.json         # Container setup
│   └── setup.sh                  # Automated installation
├── scripts/                      # All utility scripts
│   ├── video2x-docker.sh        # Command-line video processing
│   ├── video2x_wrapper.py       # Python integration
│   ├── start-jupyter.sh         # Jupyter Lab launcher
│   └── test_video2x.py          # Installation test
├── input/                        # Place videos here for processing
├── output/                       # Processed videos appear here
├── temp/                         # Temporary files
└── Video2X_Codespace_Adapted.ipynb  # Main Jupyter notebook
```

## 🎬 Video Processing

### Using Jupyter Notebook (Recommended)
1. Run `./scripts/start-jupyter.sh`
2. Open `Video2X_Codespace_Adapted.ipynb`
3. Follow the interactive workflow

### Using Command Line
```bash
# Real-world videos (2x upscaling)
./scripts/video2x-docker.sh input/video.mp4 output/upscaled.mp4

# Anime content (4x upscaling)
./scripts/video2x-docker.sh input/anime.mp4 output/anime_4k.mp4 -p anime4k -s 4

# Frame interpolation (smoother motion)
./scripts/video2x-docker.sh input/video.mp4 output/smooth.mp4 -p rife
```

### Using Python
```python
import sys
sys.path.append('scripts')
import video2x_wrapper

v2x = video2x_wrapper.Video2X()
v2x.upscale("input/video.mp4", processor="realesrgan", scale=2)
```

## 🧠 AI Algorithms

- **Real-ESRGAN**: Best for real-world videos, photos, and live-action content
- **Anime4K**: Optimized for anime, cartoons, and drawn/animated content
- **RIFE**: Frame interpolation for creating smoother motion (60fps+)

## 🔧 Technical Details

- **Base**: Python 3.10 with Docker support
- **Video2X**: Modern v6+ C/C++ implementation via containers
- **Processing**: CPU-based (works in any Codespace)
- **Formats**: Supports MP4, AVI, MKV, MOV, and more

## 💡 Tips

- **Start small**: Test with short clips before processing long videos
- **Real-ESRGAN 2x**: Good balance of quality and speed
- **Anime4K 4x**: Best results for animated content
- **File sizes**: Output files are typically 2-8x larger than input
- **Processing time**: Roughly 30 seconds to 2 minutes per input minute

---

*Uses the modern Video2X v6+ which is significantly faster and more reliable than older Python-based versions.*

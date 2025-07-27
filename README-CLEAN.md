# Video2X Codespace - Clean Setup

A streamlined GitHub Codespace environment for video upscaling using the modern Video2X (v6+) Docker implementation.

## 🚀 Quick Start

1. **Open in Codespace** - The environment will automatically set up
2. **Start Jupyter Lab**:
   ```bash
   ./start-jupyter.sh
   ```
3. **Open the notebook**: `Video2X_Modern_Docker.ipynb`

## 📁 Project Structure

```
video2x-codespace/
├── .devcontainer/
│   ├── devcontainer.json          # Codespace configuration
│   └── setup.sh                   # Automated setup script
├── input/                         # Place videos to process here
├── output/                        # Processed videos appear here
├── temp/                          # Temporary files
├── video2x-docker.sh             # Command-line wrapper
├── video2x_wrapper.py            # Python integration
├── start-jupyter.sh              # Jupyter Lab launcher
└── Video2X_Modern_Docker.ipynb   # Main notebook
```

## 🎬 Video Processing

### Command Line
```bash
# Basic upscaling (2x with Real-ESRGAN)
./video2x-docker.sh input/video.mp4 output/upscaled.mp4

# Anime content (4x with Anime4K)
./video2x-docker.sh input/anime.mp4 output/anime_4k.mp4 -p anime4k -s 4

# Frame interpolation
./video2x-docker.sh input/video.mp4 output/smooth.mp4 -p rife
```

### Python/Jupyter
```python
import video2x_wrapper
v2x = video2x_wrapper.Video2X()

# Upscale video
v2x.upscale("input/video.mp4", processor="realesrgan", scale=2)

# For anime content
v2x.upscale("input/anime.mp4", processor="anime4k", scale=4)
```

## 🧠 Algorithms

- **Real-ESRGAN**: Best for real-world videos and photos
- **Anime4K**: Optimized for anime and cartoon content  
- **RIFE**: Frame interpolation for smoother motion

## ⚙️ Requirements

- GitHub Codespace (includes Docker support)
- Input videos in `input/` directory
- Adequate processing time (upscaling can be slow)

## 🔧 Technical Details

- **Base Image**: Python 3.10 on Debian Bullseye
- **Video2X**: Modern v6+ C/C++ implementation via Docker
- **Docker**: Enabled via devcontainer features
- **Python Packages**: OpenCV, NumPy, Matplotlib, Pandas, Jupyter

---

*This setup uses the modern Video2X v6+ which is significantly faster and more reliable than the old Python-based versions.*

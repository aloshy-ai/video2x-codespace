# Video2X GitHub Codespace Project

## 🚀 Quick Start

This project provides a complete GitHub Codespace environment for running Video2X video upscaling directly in VS Code.

### Setup Steps:
1. **Fork this repository** to your GitHub account
2. **Create a Codespace:**
   - Click the green "Code" button
   - Select "Codespaces" tab  
   - Click "Create codespace on main"
3. **Wait for setup** (3-5 minutes for first run)
4. **Open the notebook:** Video2X_Codespace.ipynb
5. **Run cells sequentially** to start processing videos

## 📁 Project Structure

```
~/aloshy-ai/video2x-codespace/
├── .devcontainer/
│   ├── devcontainer.json    # Codespace configuration
│   └── setup.sh            # Installation script
├── .github/workflows/
│   └── codespace-prebuilds.yml # Prebuild automation
├── input/                  # Upload your videos here
├── output/                 # Processed videos appear here
├── temp/                   # Temporary processing files
├── requirements.txt        # Python dependencies
├── Video2X_Codespace.ipynb # Main notebook
└── README.md              # This file
```

## ⚙️ Features

- Interactive Jupyter notebook interface in VS Code
- File upload/management widgets for easy video handling
- RealESRGAN and libplacebo filter support
- Automatic Video2X installation and setup
- GPU support (when available in Codespace)

## 🔧 Configuration Files

- ✅ DevContainer configuration with GPU support
- ✅ Setup script with Video2X installation  
- ✅ Python requirements with all dependencies
- ✅ GitHub workflow for Codespace prebuilds
- 📝 Jupyter notebook template ready

## 📝 Next Steps

1. Create the Jupyter notebook: Video2X_Codespace.ipynb
2. Initialize git repository: ./init-git.sh
3. Push to GitHub
4. Create Codespace from GitHub repository

## ⚠️ Important Notes

- GPU acceleration may be limited in GitHub Codespaces
- For best performance, use Google Colab with GPU or local machine
- Video2X will run in CPU mode if no GPU is available (slower processing)

## 🎯 Usage

Once the Codespace is running:
1. Open Video2X_Codespace.ipynb in VS Code
2. Run system check cell to verify installation
3. Upload videos using the file management interface
4. Configure processing settings (RealESRGAN recommended)
5. Start video processing
6. Download processed videos from output folder

## 📍 Project Location

This project is located at: ~/aloshy-ai/video2x-codespace/

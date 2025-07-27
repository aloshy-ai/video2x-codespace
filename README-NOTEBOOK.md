# 📓 Video2X Codespace Notebook Guide

## 🎯 Quick Start

Your Video2X environment now includes an adapted version of the original Colab notebook that works perfectly in Codespace!

### 📁 **Available Notebooks:**

1. **`Video2X_Codespace_Adapted.ipynb`** ← **Use This One!**
   - Direct adaptation of original Colab notebook
   - Same Video2X logic and parameters
   - Uses local filesystem (no Google Drive)
   - Interactive widgets for configuration

2. **`Video2X_Complete.ipynb`**
   - Advanced interface with comprehensive features
   - Professional UI with progress monitoring

## 🚀 **Using the Adapted Notebook:**

### **Step 1: Open Notebook**
- Open `Video2X_Codespace_Adapted.ipynb` in VS Code
- Ensure Python kernel is selected

### **Step 2: Run Setup Cells**
```python
# Cell 1: System Check
# - Checks GPU availability
# - Verifies Video2X installation

# Cell 2: Install Dependencies  
# - Installs Video2X and dependencies
# - Sets up environment properly
```

### **Step 3: File Management**
```python
# Cell 3: File Management
# - Creates local directories
# - Provides upload interface
# - Shows manual upload instructions
```

**Manual Upload Method:**
1. Use VS Code file explorer
2. Navigate to `/workspaces/video2x-codespace/input/`
3. Drag and drop your video files
4. Refresh the cell to see new files

### **Step 4: Configure Processing**
```python
# Cell 4: Configuration
# - Choose filter: RealESRGAN or libplacebo
# - Select model: anime or real-life
# - Set scale factor: 2x, 3x, or 4x
# - Adjust quality settings
```

**Recommended Settings:**
- **Anime/Cartoon**: `realesr-animevideov3` with 2x-4x scale
- **Real-life**: `realesrgan-plus` with 4x scale
- **Quality**: CRF 20 for good balance

### **Step 5: Process Video**
```python
# Cell 5: Processing
# - Builds Video2X command
# - Executes processing
# - Shows real-time progress
```

### **Step 6: Download Results**
```python
# Cell 6: Results
# - Lists processed files
# - Shows file sizes
# - Provides download instructions
```

## 📊 **Key Differences from Colab:**

| Feature | Colab Version | Codespace Version |
|---------|---------------|-------------------|
| Storage | Google Drive | Local filesystem |
| Upload | Colab files.upload() | VS Code drag-drop |
| GPU | Always available | Optional |
| Runtime | 12 hour limit | Flexible |
| Access | Browser only | VS Code + Browser |

## 🔧 **Troubleshooting:**

### **Video2X Not Found:**
```bash
# Run setup manually
.devcontainer/setup.sh

# Or install via pip
pip3 install --user video2x
export PATH="$HOME/.local/bin:$PATH"
```

### **Upload Issues:**
- Use manual upload via VS Code file explorer
- Place files in `/workspaces/video2x-codespace/input/`
- Refresh notebook cell to see files

### **GPU Not Available:**
- Processing will use CPU (slower but works)
- Consider using original Colab for GPU processing
- Or use smaller scale factors (2x instead of 4x)

### **Jupyter Issues:**
```bash
# Start Jupyter manually
./start-video2x.sh
```

## 🎬 **Processing Examples:**

### **Example 1: Anime Upscaling**
```python
filter_type = "realesrgan"
model = "realesr-animevideov3"
scale = 2  # Start with 2x for speed
crf = 20
```

### **Example 2: Real-life Video**
```python
filter_type = "realesrgan" 
model = "realesrgan-plus"
scale = 4
crf = 18  # Higher quality
```

### **Example 3: High Quality Anime**
```python
filter_type = "realesrgan"
model = "realesr-animevideov3" 
scale = 4
crf = 16  # Best quality
```

## 📁 **File Organization:**

```
/workspaces/video2x-codespace/
├── input/           ← Upload videos here
├── output/          ← Processed videos appear here  
├── temp/            ← Temporary processing files
├── Video2X_Codespace_Adapted.ipynb  ← Main notebook
└── start-video2x.sh ← Jupyter startup script
```

## 💡 **Pro Tips:**

1. **Start Small**: Test with short clips before processing long videos
2. **Monitor Resources**: Check system resources during processing
3. **Backup Originals**: Always keep original videos safe
4. **Progressive Quality**: Start with lower settings, increase gradually
5. **Batch Processing**: Process multiple videos with same settings

## 🚀 **Ready to Go!**

Your Video2X Codespace is now fully configured with both notebook options:
- **Adapted Notebook**: Direct port of Colab functionality
- **Complete Interface**: Advanced features and monitoring

Choose the notebook that best fits your workflow and start enhancing your videos! 🎬✨

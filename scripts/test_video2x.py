#!/usr/bin/env python3
"""
Test script to verify Video2X installation
"""

try:
    import video2x
    print("✅ Video2X imported successfully!")
    print(f"Video2X version: {video2x.__version__ if hasattr(video2x, '__version__') else 'Unknown'}")
except ImportError as e:
    print(f"❌ Failed to import Video2X: {e}")

try:
    import cv2
    print("✅ OpenCV imported successfully!")
    print(f"OpenCV version: {cv2.__version__}")
except ImportError as e:
    print(f"❌ Failed to import OpenCV: {e}")

try:
    import numpy as np
    print("✅ NumPy imported successfully!")
    print(f"NumPy version: {np.__version__}")
except ImportError as e:
    print(f"❌ Failed to import NumPy: {e}")

print("\n🎯 Environment ready for Video2X notebooks!")

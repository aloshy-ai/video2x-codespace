#!/usr/bin/env python3
"""
Python wrapper for Video2X Docker integration
"""

import subprocess
import os
import sys
from pathlib import Path

class Video2X:
    def __init__(self, workspace_dir="/workspaces/video2x-codespace"):
        self.workspace_dir = Path(workspace_dir)
        self.input_dir = self.workspace_dir / "input"
        self.output_dir = self.workspace_dir / "output"
        
    def upscale(self, input_file, output_file=None, processor="realesrgan", scale=2, model="realesr-animevideov3"):
        """
        Upscale a video using Video2X
        
        Args:
            input_file: Path to input video
            output_file: Path to output video (optional)
            processor: Processing algorithm (realesrgan, anime4k, rife)
            scale: Scale factor (2, 3, 4)
            model: Model to use for realesrgan
        """
        input_path = Path(input_file)
        
        if output_file is None:
            output_file = self.output_dir / f"{input_path.stem}_upscaled{input_path.suffix}"
        
        # Ensure output directory exists
        Path(output_file).parent.mkdir(parents=True, exist_ok=True)
        
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
        print(f"⚙️  Processor: {processor}, Scale: {scale}x")
        
        try:
            result = subprocess.run(cmd, cwd=self.workspace_dir, check=True, 
                                  capture_output=True, text=True)
            print("✅ Video2X processing completed!")
            return str(output_file)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error during processing: {e}")
            print(f"Error output: {e.stderr}")
            return None
    
    def interpolate(self, input_file, output_file=None, target_fps=60):
        """
        Perform frame interpolation using RIFE
        """
        return self.upscale(input_file, output_file, processor="rife", scale=1)

# Test function
def test_video2x():
    v2x = Video2X()
    test_file = v2x.input_dir / "test_sample.mp4"
    
    if test_file.exists():
        print("🧪 Testing Video2X with sample video...")
        result = v2x.upscale(str(test_file), scale=2)
        if result:
            print(f"✅ Test completed! Output: {result}")
        else:
            print("❌ Test failed")
    else:
        print("⚠️  No test video found. Place a video in input/ directory to test.")

if __name__ == "__main__":
    test_video2x()

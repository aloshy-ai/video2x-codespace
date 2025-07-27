#!/usr/bin/env python3
"""Video2X Python wrapper for easy notebook integration"""
import subprocess
import os
from pathlib import Path

class Video2X:
    def __init__(self, workspace_dir="/workspaces/video2x-codespace"):
        self.workspace_dir = Path(workspace_dir)
        self.input_dir = self.workspace_dir / "input"
        self.output_dir = self.workspace_dir / "output"
        
    def upscale(self, input_file, output_file=None, processor="realesrgan", scale=2):
        """Upscale video using Video2X Docker"""
        if output_file is None:
            input_path = Path(input_file)
            output_file = self.output_dir / f"{input_path.stem}_upscaled{input_path.suffix}"
        
        Path(output_file).parent.mkdir(parents=True, exist_ok=True)
        
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
            cmd.extend(["--realesrgan-model", "realesr-animevideov3"])
        
        print(f"🎬 Upscaling: {input_file} → {output_file}")
        try:
            subprocess.run(cmd, cwd=self.workspace_dir, check=True)
            print("✅ Processing complete!")
            return str(output_file)
        except subprocess.CalledProcessError as e:
            print(f"❌ Error: {e}")
            return None

if __name__ == "__main__":
    # Test the wrapper
    v2x = Video2X()
    print(f"Video2X wrapper initialized. Workspace: {v2x.workspace_dir}")

#!/usr/bin/env python3
"""
Validate DevContainer Configuration for Video2X_Codespace_Adapted.ipynb
"""

import json
import os
import sys
from pathlib import Path

def validate_devcontainer():
    print("🔍 Validating DevContainer for Video2X_Codespace_Adapted.ipynb")
    print("=" * 65)
    
    # Check devcontainer.json exists
    devcontainer_path = Path(".devcontainer/devcontainer.json")
    if not devcontainer_path.exists():
        print("❌ devcontainer.json not found")
        return False
    
    # Load and validate devcontainer.json
    try:
        with open(devcontainer_path) as f:
            config = json.load(f)
        print("✅ devcontainer.json is valid JSON")
    except json.JSONDecodeError as e:
        print(f"❌ devcontainer.json invalid: {e}")
        return False
    
    # Required components for Video2X notebook
    requirements = {
        "Python Base Image": lambda c: "python" in c.get("image", ""),
        "Jupyter Extensions": lambda c: any("jupyter" in ext for ext in 
            c.get("customizations", {}).get("vscode", {}).get("extensions", [])),
        "Python Extension": lambda c: "ms-python.python" in 
            c.get("customizations", {}).get("vscode", {}).get("extensions", []),
        "Port Forwarding": lambda c: 8888 in c.get("forwardPorts", []),
        "Setup Script": lambda c: c.get("postCreateCommand", "").endswith("setup.sh"),
        "Workspace User": lambda c: c.get("remoteUser") == "vscode"
    }
    
    print("\n📋 Configuration Validation:")
    all_passed = True
    
    for requirement, check in requirements.items():
        if check(config):
            print(f"✅ {requirement}")
        else:
            print(f"❌ {requirement}")
            all_passed = False
    
    # Check setup script
    setup_script = Path(".devcontainer/setup.sh")
    if setup_script.exists():
        print("✅ Setup script exists")
        
        with open(setup_script) as f:
            setup_content = f.read()
        
        setup_requirements = {
            "Video2X Installation": "video2x" in setup_content,
            "Jupyter Installation": "jupyter" in setup_content,
            "Python Packages": "pip3 install" in setup_content,
            "Widget Support": "ipywidgets" in setup_content,
            "OpenCV Support": "opencv" in setup_content,
            "Directory Creation": "mkdir" in setup_content and "input" in setup_content
        }
        
        print("\n📦 Setup Script Validation:")
        for requirement, check in setup_requirements.items():
            if check:
                print(f"✅ {requirement}")
            else:
                print(f"❌ {requirement}")
                all_passed = False
    else:
        print("❌ Setup script missing")
        all_passed = False
    
    # Check notebook exists
    notebook_path = Path("Video2X_Codespace_Adapted.ipynb")
    if notebook_path.exists():
        print("\n📓 Notebook Validation:")
        print("✅ Video2X_Codespace_Adapted.ipynb exists")
        
        try:
            with open(notebook_path) as f:
                notebook = json.load(f)
            
            cells = notebook.get("cells", [])
            print(f"✅ Notebook has {len(cells)} cells")
            
            # Check for key components in notebook
            notebook_content = json.dumps(notebook)
            notebook_checks = {
                "System Check": "nvidia-smi" in notebook_content,
                "Video2X Installation": "video2x" in notebook_content,
                "File Management": "pathlib" in notebook_content and "input_dir" in notebook_content,
                "Interactive Widgets": "ipywidgets" in notebook_content,
                "Processing Logic": "realesrgan" in notebook_content,
                "Results Management": "output_dir" in notebook_content
            }
            
            for check, passed in notebook_checks.items():
                if passed:
                    print(f"✅ {check}")
                else:
                    print(f"❌ {check}")
                    all_passed = False
                    
        except json.JSONDecodeError:
            print("❌ Notebook is invalid JSON")
            all_passed = False
    else:
        print("❌ Video2X_Codespace_Adapted.ipynb not found")
        all_passed = False
    
    # Summary
    print("\n" + "=" * 65)
    if all_passed:
        print("🎉 DevContainer is PERFECT for Video2X_Codespace_Adapted.ipynb!")
        print("✅ All requirements met")
        print("🚀 Ready for Codespace creation")
    else:
        print("⚠️ DevContainer needs improvements")
        print("🔧 Some requirements not met")
    
    return all_passed

if __name__ == "__main__":
    success = validate_devcontainer()
    sys.exit(0 if success else 1)

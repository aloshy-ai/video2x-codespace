#!/bin/bash
echo "🚀 Starting Jupyter Lab for Video2X"
echo "=================================="
cd /workspaces/video2x-codespace
export PATH="$HOME/.local/bin:$PATH"
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
    --NotebookApp.token='' --NotebookApp.password='' \
    --NotebookApp.allow_origin='*' --NotebookApp.disable_check_xsrf=True

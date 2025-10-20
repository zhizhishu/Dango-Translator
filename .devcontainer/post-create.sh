#!/bin/bash

# This script runs after the Codespace container is created.
# It prepares a ready-to-run Python environment for Dango-Translator in GitHub Codespaces.

set -euo pipefail

echo "==> [1/4] Updating package lists..."
sudo apt-get update -y

echo "==> [2/4] Installing system dependencies (Qt runtime, Tesseract, OpenGL, X11, clipboard)..."
sudo apt-get install -y --no-install-recommends \
    git \
    tesseract-ocr \
    tesseract-ocr-chi-sim \
    libgl1 \
    libglib2.0-0 \
    libxkbcommon-x11-0 \
    libxi6 \
    libxtst6 \
    libxcb-xinerama0 \
    xclip

echo "==> [3/4] Creating Python virtual environment and upgrading pip..."
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel

echo "==> [4/4] Installing Python dependencies from requirements.txt (Linux-friendly subset)..."
TEMP_REQ=/tmp/requirements.codespaces.txt
# Filter out Windows-specific or incompatible pins
grep -v -E '^(pywin32|winreglib|opencv_python|scikit_image|skimage)=="?[^\n]*' requirements.txt > "$TEMP_REQ" || true

# Install remaining requirements
pip install -r "$TEMP_REQ" || true

# Provide Linux-compatible alternatives
pip install opencv-python-headless scikit-image || true

# Auto-activate virtualenv for future shells in this container
if ! grep -q "source .venv/bin/activate" ~/.bashrc 2>/dev/null; then
  echo 'source .venv/bin/activate' >> ~/.bashrc
fi

echo "✅ Environment setup complete. Activate the venv with: 'source .venv/bin/activate' (auto-activated in new shells)."
echo "To run the app: python app.py (note: GUI windows cannot display in Codespaces)."

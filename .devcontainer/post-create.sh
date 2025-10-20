#!/usr/bin/env bash

set -euo pipefail

echo "==> [1/3] Updating apt package lists..."
sudo apt-get update -y

echo "==> [2/3] Installing system dependencies (OpenCV/Qt runtime, fonts, tesseract)..."
sudo apt-get install -y --no-install-recommends \
  libgl1 \
  libglib2.0-0 \
  libsm6 \
  libxext6 \
  libxrender1 \
  libxkbcommon-x11-0 \
  libnss3 \
  fonts-noto-cjk \
  tesseract-ocr

echo "==> [3/3] Preparing Python environment..."
python -m pip install --upgrade pip

if [ -f "requirements.txt" ]; then
  echo "Installing Python dependencies (Linux-friendly subset)..."
  # Filter out Windows-only packages to avoid install failures in Linux Codespaces
  grep -v -E '^(pywin32|winreglib|system_hotkey)\b' requirements.txt > /tmp/requirements.linux.txt || true
  python -m pip install -r /tmp/requirements.linux.txt || true
fi

echo
echo "Environment setup complete. Notes:"
echo "- This is a cloud Linux environment; GUI windows will not display."
echo "- You can run non-GUI scripts and unit tests."
echo "- If you need the full Windows app UI, please develop locally on Windows."

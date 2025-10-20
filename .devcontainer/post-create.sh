#!/bin/bash

# This script runs after the Codespace container is created.
# It installs all necessary dependencies for the Dango-Translator project.

set -e

echo "==> [1/2] Updating package lists..."
sudo apt-get update -y

echo "==> [2/2] Installing Dango-Translator dependencies..."
sudo apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    qtbase5-dev \
    qttools5-dev \
    libopencv-dev \
    libleptonica-dev \
    libtesseract-dev \
    tesseract-ocr-sim

echo "✅ Environment setup complete. You can now configure and build the project."

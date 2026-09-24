#!/bin/bash
set -e

# Keep the OpenCV version in sync with the Dockerfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCV_VERSION=$(sed -n 's/^ARG OPENCV_VERSION=//p' "$SCRIPT_DIR/Dockerfile" | tr -d '\r')

mkdir -p "$SCRIPT_DIR/cache"
pushd "$SCRIPT_DIR/cache" > /dev/null

if [ ! -s opencv-$OPENCV_VERSION.zip ]; then
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip -O opencv-$OPENCV_VERSION.zip
fi

popd > /dev/null

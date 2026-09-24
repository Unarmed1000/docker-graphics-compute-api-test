#!/bin/bash
set -e

# Keep the OpenCV version in sync with the Dockerfile
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCV_VERSION=$(sed -n 's/^ARG OPENCV_VERSION=//p' "$SCRIPT_DIR/Dockerfile" | tr -d '\r')

mkdir -p "$SCRIPT_DIR/cache"
pushd "$SCRIPT_DIR/cache" > /dev/null

# Download to a temp name so an interrupted download is never mistaken for a cached file
download() {
    if command -v curl > /dev/null; then
        curl -fL --retry 3 -o "$2.part" "$1"
    elif command -v wget > /dev/null; then
        wget "$1" -O "$2.part"
    else
        echo "prepCache.sh: curl or wget is required" >&2
        exit 1
    fi
    mv "$2.part" "$2"
}

if [ ! -s opencv-$OPENCV_VERSION.zip ]; then
    download https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip opencv-$OPENCV_VERSION.zip
fi

popd > /dev/null

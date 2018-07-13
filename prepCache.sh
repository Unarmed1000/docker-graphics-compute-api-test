#!/bin/bash
if [ ! -d "cache" ]; then
  mkdir cache
fi

pushd cache > /dev/null

if [ ! -f vulkansdk-linux-x86_64-1.0.68.0.run ] || [ ! -s vulkansdk-linux-x86_64-1.0.68.0.run ]; then
    #wget https://sdk.lunarg.com/sdk/download/1.0.68.0/linux/vulkansdk-linux-x86_64-1.0.68.0.run?Human=true -O vulkansdk-linux-x86_64-1.0.68.0.run
    wget https://sdk.lunarg.com/sdk/download/1.0.68.0/linux/vulkansdk-linux-x86_64-1.0.68.0.run -O vulkansdk-linux-x86_64-1.0.68.0.run
fi
if [ ! -s vulkansdk-linux-x86_64-1.0.68.0.run ]; then
    echo WARNING: Downloaded VULKAN SDK is a empty file, please download vulkansdk-linux-x86_64-1.0.68.0.run to the cache directory
fi

if [ ! -f Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb ]; then
    wget https://armkeil.blob.core.windows.net/developer/Files/downloads/open-gl-es-emulator/3.0.2/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb
fi

if [ ! -f opencv-3.2.0.zip ]; then
    wget https://github.com/opencv/opencv/archive/3.2.0.zip -O opencv-3.2.0.zip
fi

if [ ! -f AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 ]; then
    echo Go to: https://developer.amd.com/amd-accelerated-parallel-processing-app-sdk/ and
    echo download AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 to the cache directory.
fi

popd > /dev/null






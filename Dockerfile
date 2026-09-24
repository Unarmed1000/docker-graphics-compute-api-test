FROM ubuntu:26.04

ARG OPENCV_VERSION=5.0.0

# set noninteractive installation
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/New_York

RUN apt-get update \
 && apt-get -y install \
        build-essential \
        clang \
        clang-format \
        clang-tools \
        clang-tidy \
        cmake \
        git \
        g++ \
        lcov \
        libassimp-dev \
        libdevil-dev \
        libxrandr-dev \
        ninja-build \
        ocl-icd-opencl-dev \
        python3 \
        software-properties-common \
        tzdata \
        unzip \
        wget \
 && rm -rf /var/lib/apt/lists/*

# Ubuntu 26.04 ships Python 3.14 as its system Python, so no PPA is needed.
RUN apt-get update \
 && apt-get -y install python3.14 \
 && python3.14 --version | grep -E '^Python 3\.14\.' \
 && rm -rf /var/lib/apt/lists/*

# OpenCV compilation
#RUN wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip -O OpenCV.zip
COPY cache/opencv-$OPENCV_VERSION.zip opencv.zip
RUN unzip opencv.zip \
 && rm opencv.zip \
 && cd opencv-$OPENCV_VERSION \
 && mkdir release \
 && cd release \
 && cmake -GNinja -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
 && ninja -j $(nproc)\
 && ninja install \
 && ninja clean \
 && cd ../.. \
 && ln -s /usr/local/include/opencv5/opencv2/ /usr/local/include/opencv2 \
 && rm -rf opencv-$OPENCV_VERSION

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Install OpenGL ES / EGL using Mesa (libgles2-mesa-dev is only a transitional package for libgles-dev)
RUN apt-get update \
 && apt-get install -y \
        libegl-dev \
        libegl-mesa0 \
        libgl1-mesa-dri \
        libgles-dev \
 && rm -rf /var/lib/apt/lists/*

# Install Vulkan
# Keep the version in sync with VULKAN_SDK_VERSION in the DemoFramework GitHub CI (.github/workflows/ci.yml).
# Vulkan headers older than 1.3 define VK_NULL_HANDLE as 0 in C++ which breaks RapidVulkan 1.4.x (std::exchange(handle, VK_NULL_HANDLE)).
ENV DOCKERIMAGE_VULKAN_SDK_VERSION="1.4.357.1"
ARG DOCKERIMAGE_VULKAN_SDK_SHA256="4b41e3b30e8aedaa5dac7c136561ab463eb316a25a54e2c6245f2c299ea1fb85"
RUN apt-get update \
 && apt-get install -y \
        cmake \
        libpciaccess0 \
        libpng-dev \
        libx11-dev \
        libxcb-dri3-0 \
        libxcb-present0 \
        libxrandr-dev \
        xz-utils \
 && rm -rf /var/lib/apt/lists/* \
 && wget -q https://sdk.lunarg.com/sdk/download/${DOCKERIMAGE_VULKAN_SDK_VERSION}/linux/vulkansdk-linux-x86_64-${DOCKERIMAGE_VULKAN_SDK_VERSION}.tar.xz -O vulkan-sdk.tar.xz \
 && echo "${DOCKERIMAGE_VULKAN_SDK_SHA256}  vulkan-sdk.tar.xz" | sha256sum -c - \
 && mkdir VulkanSDK \
 && tar xJf vulkan-sdk.tar.xz -C VulkanSDK \
 && rm vulkan-sdk.tar.xz \
 && test -f /VulkanSDK/${DOCKERIMAGE_VULKAN_SDK_VERSION}/x86_64/include/vulkan/vulkan_core.h

#        libglm-dev \
#        libmirclient-dev \
#        libxcb-ewmh-dev \
#        libxcb-dri3-dev \
#        libxcb-keysyms1-dev \
#        libwayland-dev \
 
ENV VULKAN_SDK /VulkanSDK/${DOCKERIMAGE_VULKAN_SDK_VERSION}/x86_64
ENV PATH $VULKAN_SDK/bin:$PATH
ENV LD_LIBRARY_PATH $VULKAN_SDK/lib:$LD_LIBRARY_PATH
ENV VK_LAYER_PATH $VULKAN_SDK/etc/explicit_layer.d
ENV LIBRARY_PATH $VULKAN_SDK/lib:$LIBRARY_PATH

RUN wget https://raw.github.com/eriwen/lcov-to-cobertura-xml/master/lcov_cobertura/lcov_cobertura.py \
 && chmod +x lcov_cobertura.py \
 && mkdir CUSTOM_TOOLS \
 && mv lcov_cobertura.py /CUSTOM_TOOLS/lcov_cobertura.py

ENV PATH /CUSTOM_TOOLS:$PATH

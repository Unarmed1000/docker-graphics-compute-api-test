# syntax=docker/dockerfile:1

ARG OPENCV_VERSION=5.0.0

# OpenCV is compiled in its own stage so it builds in parallel with the main image,
# and the source zip (bind mounted, not copied) never ends up in an image layer.
# With only the build tools installed, OpenCV uses its bundled 3rd party libraries.
FROM ubuntu:26.04 AS opencv-build
ARG OPENCV_VERSION
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get -y install \
        build-essential \
        cmake \
        ninja-build \
        python3 \
        unzip \
 && rm -rf /var/lib/apt/lists/*
RUN --mount=type=bind,source=cache/opencv-${OPENCV_VERSION}.zip,target=/tmp/opencv.zip \
    unzip -q /tmp/opencv.zip -d /tmp \
 && cmake -S /tmp/opencv-${OPENCV_VERSION} -B /tmp/opencv-release -GNinja -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
 && ninja -C /tmp/opencv-release -j $(nproc) \
 && DESTDIR=/opencv-install ninja -C /tmp/opencv-release install \
 && ln -s /usr/local/include/opencv5/opencv2/ /opencv-install/usr/local/include/opencv2

FROM ubuntu:26.04

# set noninteractive installation
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/New_York

RUN apt-get update \
 && apt-get -y install \
        build-essential \
        clang \
        clang-tools \
        cmake \
        git \
        g++ \
        lcov \
        libassimp-dev \
        libdevil-dev \
        libxrandr-dev \
        ninja-build \
        ocl-icd-opencl-dev \
        pkgconf \
        python3 \
        software-properties-common \
        tzdata \
        unzip \
        wget \
 && rm -rf /var/lib/apt/lists/*

# clang-format and clang-tidy from apt.llvm.org, since Ubuntu 26.04 only ships up to LLVM 22.
# The unversioned names are linked in /usr/local/bin so they resolve to this version.
ARG LLVM_TOOLS_VERSION=23
RUN . /etc/os-release \
 && mkdir -p /etc/apt/keyrings \
 && wget -qO /etc/apt/keyrings/apt.llvm.org.asc https://apt.llvm.org/llvm-snapshot.gpg.key \
 && echo "deb [signed-by=/etc/apt/keyrings/apt.llvm.org.asc] https://apt.llvm.org/${VERSION_CODENAME}/ llvm-toolchain-${VERSION_CODENAME}-${LLVM_TOOLS_VERSION} main" > /etc/apt/sources.list.d/llvm-toolchain.list \
 && apt-get update \
 && apt-get -y install \
        clang-format-${LLVM_TOOLS_VERSION} \
        clang-tidy-${LLVM_TOOLS_VERSION} \
 && rm -rf /var/lib/apt/lists/* \
 && for tool in clang-format git-clang-format clang-tidy run-clang-tidy clang-apply-replacements; do \
        test -x /usr/bin/$tool-${LLVM_TOOLS_VERSION} && ln -sf /usr/bin/$tool-${LLVM_TOOLS_VERSION} /usr/local/bin/$tool || exit 1; \
    done \
 && clang-format --version | grep -E "version ${LLVM_TOOLS_VERSION}\." \
 && clang-tidy --version | grep -E "version ${LLVM_TOOLS_VERSION}\."

# Ubuntu 26.04 ships Python 3.14 as its system Python, so no PPA is needed.
RUN apt-get update \
 && apt-get -y install python3.14 \
 && python3.14 --version | grep -E '^Python 3\.14\.' \
 && rm -rf /var/lib/apt/lists/*

# OpenCV (built in the opencv-build stage)
COPY --from=opencv-build /opencv-install/usr/local/ /usr/local/

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
 && test -f /VulkanSDK/${DOCKERIMAGE_VULKAN_SDK_VERSION}/x86_64/include/vulkan/vulkan_core.h \
 && test -f /VulkanSDK/${DOCKERIMAGE_VULKAN_SDK_VERSION}/x86_64/lib/VulkanLoader/lib/libvulkan.so \
 && test -d /VulkanSDK/${DOCKERIMAGE_VULKAN_SDK_VERSION}/x86_64/share/vulkan/explicit_layer.d

#        libglm-dev \
#        libmirclient-dev \
#        libxcb-ewmh-dev \
#        libxcb-dri3-dev \
#        libxcb-keysyms1-dev \
#        libwayland-dev \
 
# Mirrors the SDK's setup-env.sh (with --set-dep-ld): the Vulkan loader lives in lib/VulkanLoader,
# so it has to be on CMAKE_PREFIX_PATH for cmake's FindVulkan to locate libvulkan.so.
ENV VULKAN_SDK /VulkanSDK/${DOCKERIMAGE_VULKAN_SDK_VERSION}/x86_64
ENV PATH $VULKAN_SDK/bin:$PATH
ENV LD_LIBRARY_PATH $VULKAN_SDK/lib/VulkanLoader/lib:$VULKAN_SDK/lib:$LD_LIBRARY_PATH
ENV LIBRARY_PATH $VULKAN_SDK/lib/VulkanLoader/lib:$VULKAN_SDK/lib:$LIBRARY_PATH
ENV CMAKE_PREFIX_PATH $VULKAN_SDK:$VULKAN_SDK/lib/VulkanLoader
ENV PKG_CONFIG_PATH $VULKAN_SDK/lib/VulkanLoader/lib/pkgconfig:$VULKAN_SDK/share/pkgconfig:$VULKAN_SDK/lib/pkgconfig
ENV VK_ADD_LAYER_PATH $VULKAN_SDK/share/vulkan/explicit_layer.d

RUN wget https://raw.github.com/eriwen/lcov-to-cobertura-xml/master/lcov_cobertura/lcov_cobertura.py \
 && chmod +x lcov_cobertura.py \
 && mkdir CUSTOM_TOOLS \
 && mv lcov_cobertura.py /CUSTOM_TOOLS/lcov_cobertura.py

ENV PATH /CUSTOM_TOOLS:$PATH

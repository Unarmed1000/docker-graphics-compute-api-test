FROM ubuntu:21.04

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

# OpenCV 4 compilation
#RUN wget https://github.com/opencv/opencv/archive/4.5.2.zip -O OpenCV.zip
COPY cache/opencv-4.5.2.zip opencv.zip
RUN unzip opencv.zip \
 && rm opencv.zip \
 && cd opencv-4.5.2 \
 && mkdir release \
 && cd release \
 && cmake -GNinja -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
 && ninja -j $(nproc)\
 && ninja install \
 && ninja clean \
 && cd ../.. \
 && ln -s /usr/local/include/opencv4/opencv2/ /usr/local/include/opencv2 \
 && rm -rf opencv-4.5.2

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Install mesa OpenGL ES Emulator
RUN apt-get update \
 && apt-get install -y libgles2-mesa-dev \
 && rm -rf /var/lib/apt/lists/*

# Install Vulkan
ENV DOCKERIMAGE_VULKAN_SDK_VERSION="1.2.135.0"
#RUN wget https://sdk.lunarg.com/sdk/download/${DOCKERIMAGE_VULKAN_SDK_VERSION}/linux/vulkansdk-linux-x86_64-${DOCKERIMAGE_VULKAN_SDK_VERSION}.run?Human=true -O vulkan-sdk.run
#COPY cache/vulkansdk-linux-x86_64-${DOCKERIMAGE_VULKAN_SDK_VERSION}.run vulkan-sdk.run
#RUN chmod ugo+x vulkan-sdk.run \
# && ./vulkan-sdk.run \
# && rm vulkan-sdk.run
COPY cache/vulkansdk-linux-x86_64-${DOCKERIMAGE_VULKAN_SDK_VERSION}.tar.gz vulkan-sdk.tar.gz
RUN mkdir VulkanSDK \
 && mv vulkan-sdk.tar.gz VulkanSDK \
 && cd VulkanSDK \
 && tar zxf vulkan-sdk.tar.gz \
 && rm vulkan-sdk.tar.gz \
 && apt-get update \
 && apt-get install -y \
        cmake \
        libpciaccess0 \
        libpng-dev \
        libx11-dev \
        libxcb-dri3-0 \
        libxcb-present0 \
        libxrandr-dev \
 && rm -rf /var/lib/apt/lists/* \
 && cd ..

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

# Install gcc-11 as default
RUN apt-get update \
 && apt-get -y install \
        gcc-11 \
        g++-11 \ 
        gcc-11-base \
 && rm -rf /var/lib/apt/lists/* \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 100 \
 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-11 100

ENV PATH /CUSTOM_TOOLS:$PATH

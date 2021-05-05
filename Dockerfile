FROM ubuntu:18.04

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
        python3 \
        software-properties-common \
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

# Install Arm Mali OpenGL ES 3.0 Emulator
#RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/open-gl-es-emulator/3.0.2/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb -O MaliOpenGLESEmu.deb

COPY cache/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb  MaliOpenGLESEmu.deb
RUN dpkg -i MaliOpenGLESEmu.deb \
 && rm MaliOpenGLESEmu.deb

ENV LD_LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LD_LIBRARY_PATH
ENV LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LIBRARY_PATH

# Install Vulkan
ENV DOCKERIMAGE_VULKAN_SDK_VERSION="1.2.170.0"
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

ENV PATH /CUSTOM_TOOLS:$PATH

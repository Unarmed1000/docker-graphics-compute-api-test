FROM ubuntu:16.04

RUN apt-get update \
 && apt-get -y install \
        build-essential \
        git \
        libassimp-dev \
        libdevil-dev \
        libxrandr-dev \
        python3 \
        software-properties-common \
        unzip \
        wget \
 && add-apt-repository ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && apt-get install -y \
        g++-6 \
        gcc-6 \
 && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 20 --slave /usr/bin/g++ g++ /usr/bin/g++-6 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
# CMake 3.10.2 - Use the same version that comes with Ubuntu 18.04
RUN wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.sh -O cmake.sh \
 && mkdir /opt/cmake \
 && sh cmake.sh --skip-license --prefix=/opt/cmake \
 && rm cmake.sh \
 && ln -s /opt/cmake/bin/cmake /usr/local/bin/cmake

 # AMD OpenCL
COPY cache/AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 amd-app-sdk.tar.bz2
RUN tar xvjf amd-app-sdk.tar.bz2 \
 && rm amd-app-sdk.tar.bz2 \
 && (echo 'y' | ./AMD-APP-SDK-v2.9-1.599.381-GA-linux64.sh) \
 && rm AMD-APP-SDK-v2.9-1.599.381-GA-linux64.sh

ENV AMDAPPSDKROOT /opt/AMDAPPSDK-2.9-1
ENV LD_LIBRARY_PATH $AMDAPPSDKROOT/lib/x86_64:$LD_LIBRARY_PATH
ENV PATH $AMDAPPSDKROOT/bin:$PATH

# OpenCV dependencies
RUN apt-get update \
 && apt-get install -y \
        libavcodec-dev \
        libavformat-dev \
        libdc1394-22-dev \
        libgtk2.0-dev \
        libjasper-dev \
        libjpeg-dev \
        libpng-dev \
        libtbb-dev \
        libtbb2 \
        libtiff-dev \
        libswscale-dev \
        pkg-config \
        python-dev \
        python-numpy \
 && rm -rf /var/lib/apt/lists/*

# OpenCV 4 compilation
#RUN wget https://github.com/opencv/opencv/archive/4.0.1.zip -O OpenCV.zip
COPY cache/opencv-4.0.1.zip opencv.zip
RUN unzip opencv.zip \
 && rm opencv.zip \
 && cd opencv-4.0.1 \
 && mkdir release \
 && cd release \
 && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
 && make -j $(nproc)\
 && make install \
 && make clean \
 && cd ../.. \
 && ln -s /usr/local/include/opencv4/opencv2/ /usr/local/include/opencv2 \
 && rm -rf opencv-4.0.1

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Install Arm Mali OpenGL ES 3.0 Emulator
#RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/open-gl-es-emulator/3.0.2/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb -O MaliOpenGLESEmu.deb

COPY cache/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb  MaliOpenGLESEmu.deb
RUN dpkg -i MaliOpenGLESEmu.deb \
 && rm MaliOpenGLESEmu.deb

ENV LD_LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LD_LIBRARY_PATH
ENV LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LIBRARY_PATH

# Install Vulkan
ENV DOCKERIMAGE_VULKAN_SDK_VERSION="1.1.92.1"
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
 && apt-get install -y \
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


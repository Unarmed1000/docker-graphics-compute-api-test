FROM ubuntu:18.10

RUN apt-get update \
 && apt-get -y install \
        build-essential \
        cmake \
        git \
        libassimp-dev \
        libdevil-dev \
        libxrandr-dev \
        python3 \
        software-properties-common \
        unzip \
        wget \
 && rm -rf /var/lib/apt/lists/*


# AMD OpenCL
COPY cache/AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2 amd-app-sdk.tar.bz2
RUN tar xvjf amd-app-sdk.tar.bz2 \
 && rm amd-app-sdk.tar.bz2 \
 && (echo 'y' | ./AMD-APP-SDK-v2.9-1.599.381-GA-linux64.sh) \
 && rm AMD-APP-SDK-v2.9-1.599.381-GA-linux64.sh

ENV AMDAPPSDKROOT /opt/AMDAPPSDK-2.9-1
ENV LD_LIBRARY_PATH $AMDAPPSDKROOT/lib/x86_64:$LD_LIBRARY_PATH
ENV PATH $AMDAPPSDKROOT/bin:$PATH

# OpenCV 3.2 dependencies
# Since libjasper has been removed in Ubuntu17 we need to add it manually
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main" \
 && apt-get update \
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

# OpenCV 3.4.4 compilation
RUN wget https://github.com/opencv/opencv/archive/3.4.4.zip -O opencv.tar.gz \
 && tar -xvzf opencv.tar.gz \
 && rm opencv.tar.gz \
 && cd opencv-3.4.4 \
 && mkdir release \
 && cd release \
 && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
 && make -j $(nproc)\
 && make install \
 && make clean \
 && cd ../.. \
 && rm -rf opencv-3.4.4

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Install Arm Mali OpenGL ES 3.0 Emulator
#RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/open-gl-es-emulator/3.0.2/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb -O MaliOpenGLESEmu.deb

COPY cache/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb  MaliOpenGLESEmu.deb
RUN dpkg -i MaliOpenGLESEmu.deb \
 && rm MaliOpenGLESEmu.deb

ENV LD_LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LD_LIBRARY_PATH
ENV LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LIBRARY_PATH

# Install Vulkan
ENV DOCKERIMAGE_VULKAN_SDK_VERSION="1.1.70.1"
#RUN wget https://sdk.lunarg.com/sdk/download/${DOCKERIMAGE_VULKAN_SDK_VERSION}/linux/vulkansdk-linux-x86_64-${DOCKERIMAGE_VULKAN_SDK_VERSION}.run?Human=true -O vulkan-sdk.run
COPY cache/vulkansdk-linux-x86_64-${DOCKERIMAGE_VULKAN_SDK_VERSION}.run vulkan-sdk.run
RUN chmod ugo+x vulkan-sdk.run \
 && ./vulkan-sdk.run \
 && rm vulkan-sdk.run

ENV VULKAN_SDK /VulkanSDK/${DOCKERIMAGE_VULKAN_SDK_VERSION}/x86_64
ENV PATH $VULKAN_SDK/bin:$PATH
ENV LD_LIBRARY_PATH $VULKAN_SDK/lib:$LD_LIBRARY_PATH
ENV VK_LAYER_PATH $VULKAN_SDK/etc/explicit_layer.d
ENV LIBRARY_PATH $VULKAN_SDK/lib:$LIBRARY_PATH


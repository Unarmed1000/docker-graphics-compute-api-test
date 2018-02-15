FROM ubuntu:14.04

RUN apt-get update \
 && apt-get -y upgrade \
 && apt-get -y install \
        mc \
        wget \
        git \
        python3 \
        build-essential \
        libxrandr-dev \
        libdevil-dev \
        libassimp-dev \
        cmake \
        unzip

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
RUN apt install -y \
        libgtk2.0-dev \
        pkg-config \
        libavcodec-dev \
        libavformat-dev \
        libswscale-dev \
        python-dev \
        python-numpy \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libdc1394-22-dev

# OpenCV 3.2 compilation
#RUN wget https://github.com/opencv/opencv/archive/3.2.0.zip -O OpenCV.zip
COPY cache/opencv-3.2.0.zip opencv.zip
RUN unzip opencv.zip \
 && rm opencv.zip \
 && cd opencv-3.2.0 \
 && mkdir release \
 && cd release \
 && cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local .. \
 && make -j $(nproc)\
 && make install \
 && make clean \
 && cd ../.. \
 && rm -rf opencv-3.2.0

ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Install Arm Mali OpenGL ES 3.0 Emulator
#RUN wget https://armkeil.blob.core.windows.net/developer/Files/downloads/open-gl-es-emulator/3.0.2/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb -O MaliOpenGLESEmu.deb

COPY cache/Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb  MaliOpenGLESEmu.deb
RUN dpkg -i MaliOpenGLESEmu.deb \
 && rm MaliOpenGLESEmu.deb

ENV LD_LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LD_LIBRARY_PATH
ENV LIBRARY_PATH /usr/lib/mali-opengl-es-emulator:$LIBRARY_PATH

# Install Vulkan
#RUN wget https://sdk.lunarg.com/sdk/download/1.0.68.0/linux/vulkansdk-linux-x86_64-1.0.68.0.run?Human=true -O vulkan-sdk.run
COPY cache/vulkansdk-linux-x86_64-1.0.68.0.run vulkan-sdk.run
RUN chmod ugo+x vulkan-sdk.run \
 && ./vulkan-sdk.run \
 && rm vulkan-sdk.run

ENV VULKAN_SDK /VulkanSDK/1.0.68.0/x86_64
ENV PATH $VULKAN_SDK/bin:$PATH
ENV LD_LIBRARY_PATH $VULKAN_SDK/lib:$LD_LIBRARY_PATH
ENV VK_LAYER_PATH $VULKAN_SDK/etc/explicit_layer.d
ENV LIBRARY_PATH $VULKAN_SDK/lib:$LIBRARY_PATH

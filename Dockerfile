FROM ubuntu:16.04

RUN apt-get update \
 && apt-get -y install \
        build-essential \
        cmake \
        git \
        libassimp-dev \
        libdevil-dev \
        libxrandr-dev \
        python3 \
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

# Install mesa OpenGL ES Emulator
RUN apt-get update \
 && apt-get install -y libgles2-mesa-dev \
 && rm -rf /var/lib/apt/lists/*

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


FROM ubuntu:18.04

RUN apt-get update \
 && apt-get -y install \
        build-essential \
        cmake \
        gcovr \
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
ENV DOCKERIMAGE_VULKAN_SDK_VERSION="1.1.85.0"
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

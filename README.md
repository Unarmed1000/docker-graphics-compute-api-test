# docker-graphics-compute-api-test:u17_10

Graphics and compute development and test images

Builds common Ubuntu images with 
* OpenGL ES 2/3 emulation
* OpenCL
* OpenCV 3.4
* Vulkan SDK

## Build requirements
To build these images you will need to populate a local 'cache' directory with some SDK's.
The cache directory should contain these files before you build.

* [AMD-APP-SDK-linux-v2.9-1.599.381-GA-x64.tar.bz2](https://developer.amd.com/amd-accelerated-parallel-processing-app-sdk/)
* [Mali_OpenGL_ES_Emulator-v3.0.2.g694a9-Linux-64bit.deb](https://developer.arm.com/products/software-development-tools/graphics-development-tools/opengl-es-emulator/downloads)
* [opencv-3.2.0.zip](https://opencv.org/releases.html)
* [vulkansdk-linux-x86_64-1.0.68.0.run](https://vulkan.lunarg.com/sdk/home#linux)

Most of them can be fetched automatically with the ```prepCache.sh``` script.

**Please make sure you comply with their licenses before using them.**

## Images

| Name        | OpenGL ES 2/3                 | OpenCL           | OpenCV | Vulkan   | Ubuntu | GCC  |
|-------------|-------------------------------|------------------|--------|----------|--------|------|
| u14_04      | Mali OpenGL ES Emulator 3.2.0 | AMD-APP-SDK v2.9 | 3.2.0  | 1.0.68.0 | 14.04  | 4.8+ |
| u16_04      | Mali OpenGL ES Emulator 3.2.0 | AMD-APP-SDK v2.9 | 3.2.0  | 1.0.68.0 | 16.04  | 5.4+ |
| u17_10      | Mali OpenGL ES Emulator 3.2.0 | AMD-APP-SDK v2.9 | 3.2.0  | 1.0.68.0 | 17.10  | 7.2+ |
| u18_04      | Mali OpenGL ES Emulator 3.2.0 | AMD-APP-SDK v2.9 | 3.2.0  | 1.0.68.0 | 17.10  | 7.3+ |
| u18_10      | Mali OpenGL ES Emulator 3.2.0 | AMD-APP-SDK v2.9 | 3.2.0  | 1.0.68.0 | 17.10  | 8.2+ |
| u16_04_mesa | libgles2-mesa-dev             | AMD-APP-SDK v2.9 | 3.2.0  | 1.0.68.0 | 16.04  | 5.4+ |
| u17_10_mesa | libgles2-mesa-dev             | AMD-APP-SDK v2.9 | 3.2.0  | 1.0.68.0 | 17.10  | 7.2+ |

## Important

All images are in their own branches
* [u14_04](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u14_04)
* [u16_04](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u16_04)
* [u17_10](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u17_10)
* [u16_04_mesa](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u16_04_mesa)
* [u17_10_mesa](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u17_10_mesa)


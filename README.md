# docker-graphics-compute-api-test

Graphics and compute development and test images

Builds common Ubuntu images with 
* OpenGL ES 2/3 (Mesa)
* OpenCL
* OpenCV 5.0
* Vulkan SDK

## Build requirements
To build these images you will need to populate a local 'cache' directory.
The cache directory should contain these files before you build.

* [opencv-5.0.0.zip](https://github.com/opencv/opencv/archive/5.0.0.zip)

They can be fetched automatically with the ```prepCache.sh``` script.
The Vulkan SDK is downloaded during the image build.

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
| u24_04      | Mesa (libgles-dev)            | ocl-icd          | 5.0.0  | 1.4.357.1 | 24.04 | 13+  |
| u26_04      | Mesa (libgles-dev)            | ocl-icd          | 5.0.0  | 1.4.357.1 | 26.04 | 15+  |

## Important

All images are in their own branches
* [u14_04](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u14_04)
* [u16_04](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u16_04)
* [u17_10](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u17_10)
* [u16_04_mesa](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u16_04_mesa)
* [u17_10_mesa](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u17_10_mesa)
* [u24_04](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u24_04)
* [u26_04](https://github.com/Unarmed1000/docker-graphics-compute-api-test/tree/u26_04)


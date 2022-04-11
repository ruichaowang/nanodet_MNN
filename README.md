# NanoDet MNN Demo

 对于 0 基础的人, 这里会添加一些使用说明. 
 当前软件可以运行在 mac 或者是 android 上.
 
## 准备 MNN & 模型 & 修改原始代码的地址
- MNN 要从官方进行编译, for example , 咱们现在这个 demo 是运行在 mac 上的要用 c++ ,那就要用 https://www.yuque.com/mnn/en/build_linux  , Linux / macOS / Ubuntu 这一段来进行编译.
- MNN 编译, 在 linux 出来的就是 so, 在 mac 出来的就是 libMNN.dylib, 我会把这个文件放在 'demo_mnn/mnn/lib'
- 模型的准备可以选择直接用它提供的 download link 进行下载, 也可以进行转化, 转化方法学习一下 MNN 的说明 https://www.yuque.com/mnn/en/cvrt_linux 就好. 转换好,我就把模型文件放在了 'demo_mnn/model'
- 修改 main.cpp 中 NanoDet detector 的加载地址.   比如我会修改到 NanoDet("../model/nanodet-plus-m_416_mnn.mnn", 416, 416, 4, 0.45, 0.3);


## NanoDet 编译
- MNN include, 在编译的时候是需要加载 MNN 的 头文件, 我会把原来 'MNN-master/include/MNN' 复制到 'demo_mnn/mnn/include/MNN' 中,不过由于原始文件的路径是在 MNN 下, 直接加载会有些问题, 懒得修改加载路径了图省事, 所以我专门复制了一份资料放入的 'demo_mnn/mnn/include'
- 修改 CMakeLists.txt 中  OpenCV 的地址, 由于我是用 brew 安装的,  "/opt/homebrew/Cellar/opencv/4.5.5/include/opencv4"
- 修改 #define __SAVE_RESULT__, 为此我就直接注释掉了. 因为并不需要额外存储,以及他其实会报错...


--------------------------------
# 对 V1.2 版本后的说明:
## 编译 MNN
定义 NDK 的地址.
```
export ANDROID_NDK="/Users/wangruichao/Library/Android/sdk/ndk/24.0.8215888"
source ~/.bash_profile
source ~/.bashrc
```
进行编译
```
mkdir build &&  cd build
cmake ../../.. \
-DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
-DCMAKE_BUILD_TYPE=Release \
-DANDROID_ABI="arm64-v8a" \
-DMNN_OPENMP=ON \
-DANDROID_STL=c++_static \
-DMNN_USE_LOGCAT=false \
-DMNN_BUILD_BENCHMARK=ON \
-DMNN_USE_SSE=OFF \
-DMNN_SUPPORT_BF16=OFF \
-DMNN_BUILD_TEST=ON \
-DANDROID_NATIVE_API_LEVEL=android-21  \
-DMNN_BUILD_FOR_ANDROID_COMMAND=true \
-DNATIVE_LIBRARY_OUTPUT=. -DNATIVE_INCLUDE_OUTPUT=. $1 $2 $3
make -j8
```

## 添加对 openMP 的支持
```
FIND_PACKAGE( OpenMP REQUIRED)
if(OPENMP_FOUND)
message("OPENMP FOUND")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif()
```



-------------------------------------------------
# 原始版本说明
This fold provides NanoDet inference code using
[Alibaba's MNN framework](https://github.com/alibaba/MNN). Most of the implements in
this fold are same as *demo_ncnn*.

## Install MNN

### Python library

Just run:

``` shell
pip install MNN
```

### C++ library

Please follow the [official document](https://www.yuque.com/mnn/en/build_linux) to build MNN engine.

## Convert model

1. Export ONNX model

   ```shell
    python tools/export_onnx.py --cfg_path ${CONFIG_PATH} --model_path ${PYTORCH_MODEL_PATH}
   ```

2. Convert to MNN

   ``` shell
   python -m MNN.tools.mnnconvert -f ONNX --modelFile sim.onnx --MNNModel nanodet.mnn
   ```

It should be note that the input size does not have to be fixed, it can be any integer multiple of strides,
since NanoDet is anchor free. We can adapt the shape of `dummy_input` in *./tools/export_onnx.py* to get ONNX and MNN models
with different input sizes.

Here are converted model
[Download Link](https://github.com/RangiLyu/nanodet/releases/download/v1.0.0-alpha-1/nanodet-plus-m_416_mnn.mnn).

## Build

For C++ code, replace `libMNN.so` under *./mnn/lib* with the one you just compiled, modify OpenCV path at CMake file,
and run

``` shell
mkdir build && cd build
cmake ..
make
```

Note that a flag at `main.cpp` is used to control whether to show the detection result or save it into a fold.

``` c++
#define __SAVE_RESULT__ // if defined save drawed results to ../results, else show it in windows
```

## Run

### Python

The multi-backend python demo is still working in progress.

### C++

C++ inference interface is same with NCNN code, to detect images in a fold, run:

``` shell
./nanodet-mnn "1" "../imgs/*.jpg"
```

For speed benchmark

``` shell
./nanodet-mnn "3" "0"
```

## Custom model

If you want to use custom model, please make sure the hyperparameters
in `nanodet_mnn.h` are the same with your training config file.

```cpp
int input_size[2] = {416, 416}; // input height and width
int num_class = 80; // number of classes. 80 for COCO
int reg_max = 7; // `reg_max` set in the training config. Default: 7.
std::vector<int> strides = { 8, 16, 32, 64 }; // strides of the multi-level feature.
```

## Reference

[Ultra-Light-Fast-Generic-Face-Detector-1MB](https://github.com/Linzaer/Ultra-Light-Fast-Generic-Face-Detector-1MB/tree/master/MNN)

[ONNX Simplifier](https://github.com/daquexian/onnx-simplifier)

[NanoDet NCNN](https://github.com/RangiLyu/nanodet/tree/main/demo_ncnn)

[MNN](https://github.com/alibaba/MNN)

## Example results

![screenshot](./results/000252.jpg?raw=true)
![screenshot](./results/000258.jpg?raw=true)

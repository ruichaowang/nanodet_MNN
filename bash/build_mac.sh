#清除已经生成的文件
if [ ! -d build_mac ]; then
    mkdir -p build_mac
fi
cd build_mac
rm -rf *


# 生成
cd ..
cmake -S . -B build_mac -DCMAKE_OSX_ARCHITECTURES="arm64" 
cmake --build build_mac -j16 
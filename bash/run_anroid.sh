# 这个比较麻烦就是要把软件推到安卓上运行.
# mkdir /data/chao
# mkdir /data/chao/model

#推程序
adb push ./build_android/nanodet-mnn /data/chao
adb push ./model /data/chao
adb push ./imgs /data/chao
adb push ./3rdparty/mnn_android/lib/libMNN.so /data/chao
# 额外的,推 openMP
# 解决思路也很粗暴，直接将NDK里libomp.so拷贝到'src/main/jniLibs'或者'libs'，即可解决问题。
adb push ./3rdparty/libomp.so /data/chao

#运行
adb shell "chmod +x /data/chao/nanodet-mnn"
adb shell "cd /data/chao \
         && export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH \
         && ./nanodet-mnn "1" "./imgs/*.jpg""
adb pull "/data/chao/imgs" ~/Desktop

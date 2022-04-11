cmake_minimum_required(VERSION 3.22)
project(nanodet-mnn VERSION 1.2.0)

set(CMAKE_CXX_STANDARD 17)

if (Darwin STREQUAL ${CMAKE_SYSTEM_NAME})
        message(STATUS " 给 mac 编译"  )
        find_package(OpenCV REQUIRED COMPONENTS core highgui imgproc videoio PATHS /opt/homebrew/Cellar/opencv/4.5.5/include/opencv4)
        include_directories(
                3rdparty/mnn/include
                .
        )
        link_directories(3rdparty/mnn/lib)
elseif(${CMAKE_SYSTEM_NAME} STREQUAL Android)
        message(STATUS "给 andorid 编译" )

        set(OpenCV_DIR 3rdparty/opencv-mobile-4.5.4-android/sdk/native/jni)
        find_package(OpenCV REQUIRED COMPONENTS core highgui imgproc  )  # 貌似没有给 android video 编译 opencv
        include_directories(
                3rdparty/mnn_android/include
                .
        )
        link_directories(3rdparty/mnn_android/lib)
        # find_package(OpenMP)
        # if(OpenMP_CXX_FOUND)
        # message("OPENMP FOUND", ${OpenMP_CXX})
        # endif()
else()
        message(STATUS "找不到系统"  )
endif()

#  Debug 信息
message(STATUS "找到的 OpenCV_INCLUDE_DIRS 地址 : ${OpenCV_INCLUDE_DIRS}")
message(STATUS "找到的 OpenCV_LIBS : ${OpenCV_LIBS}" )

# 新增 openmp 支持
FIND_PACKAGE( OpenMP REQUIRED)
if(OPENMP_FOUND)
        message("OPENMP FOUND")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
        set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
        add_executable(nanodet-mnn main.cpp nanodet_mnn.cpp)
        target_link_libraries(nanodet-mnn MNN ${OpenCV_LIBS} OpenMP::OpenMP_CXX ${OpenCV_LIBS})

else()
        add_executable(nanodet-mnn main.cpp nanodet_mnn.cpp)
        target_link_libraries(nanodet-mnn MNN ${OpenCV_LIBS} )
endif()

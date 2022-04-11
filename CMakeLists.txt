cmake_minimum_required(VERSION 3.22)
project(nanodet-mnn VERSION 1.1.0)

set(CMAKE_CXX_STANDARD 17)

if (Darwin STREQUAL ${CMAKE_SYSTEM_NAME})
        message(STATUS " 给 mac 编译"  )
        find_package(OpenCV REQUIRED COMPONENTS core highgui imgproc videoio PATHS /opt/homebrew/Cellar/opencv/4.5.5/include/opencv4)
        include_directories(
                3rdparty/mnn/include
                .
        )
        link_directories(3rdparty/mnn/lib)
endif()

add_executable(nanodet-mnn main.cpp nanodet_mnn.cpp)
target_link_libraries(nanodet-mnn MNN ${OpenCV_LIBS})

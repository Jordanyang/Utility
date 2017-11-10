# 文件说明：使用cmake构建编译CUDA和OpenCV混合程序所必须包含的内容
# 使用说明: 在CUDA程序文件集中直接包含该CMakeLists.txt即可正常构建编译目标程序
# Date 2017-09-27
# Author 杨洪余
# set cmake version
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
# set project name
PROJECT(TestEigen)
INCLUDE_DIRECTORIES(/home/yanghongyu/eigen)
# file name
FILE(GLOB SOURCES "*.cpp" "*.h")
ADD_EXECUTABLE(app ${SOURCES})
# C++ list
LIST(APPEND CMAKE_CXX_FLAGS "-std=c++11 -O3 -ffast-math -Wall -pthread")

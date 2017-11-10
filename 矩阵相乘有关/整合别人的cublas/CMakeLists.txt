# 文件说明：使用cmake构建编译CUDA和OpenCV混合程序所必须包含的内容
# 使用说明: 在CUDA程序文件集中直接包含该CMakeLists.txt即可正常构建编译目标程序
# Date 2017-09-27
# Author 杨洪余
# set cmake version
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
# set project name
PROJECT(gpuMat)
# CUDA package
FIND_PACKAGE(CUDA REQUIRED)  
# CUDA include directories
INCLUDE(FindCUDA)

# file name
FILE(GLOB SOURCES "*.cu" "*.cpp" "*.h")
# set NVCC compiler flags
set(CUDA_PROPAGATE_HOST_FLAGS OFF)
set(CUDA_NVCC_FLAGS "${CUDA_NVCC_FLAGS} -std=c++11 -g -G" )
# CUDA execu
CUDA_ADD_EXECUTABLE(app ${SOURCES})
CUDA_ADD_CUBLAS_TO_TARGET(app)
# C++ list
LIST(APPEND CMAKE_CXX_FLAGS "-std=c++11 -O3 -ffast-math -Wall -pthread")

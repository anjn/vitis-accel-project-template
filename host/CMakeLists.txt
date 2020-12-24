include(${PROJECT_SOURCE_DIR}/common/vitis-host.cmake)

set(HOST vadd)
set(HOST_SRCS src/vadd.cpp src/xcl2.cpp src/ocl_common.cpp)

add_host(${HOST} "${HOST_SRCS}" "")


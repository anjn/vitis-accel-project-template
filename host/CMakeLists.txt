add_custom_target(host)

set(HOST vadd)
set(HOST_SRCS src/vadd.cpp)
add_executable(${HOST} ${HOST_SRCS})
target_include_directories(${HOST} PRIVATE $ENV{XILINX_XRT}/include)
target_link_libraries(${HOST} PRIVATE OpenCL rt stdc++)
target_compile_options(${HOST} PRIVATE -Wall -fmessage-length=0 -Wno-unknown-pragmas -Wno-unused-label)
target_compile_features(${HOST} PRIVATE cxx_std_17)
add_dependencies(host ${HOST})


cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

enable_testing()

# Project
set(PROJECT_NAME vitis-template)
project(${PROJECT_NAME} LANGUAGES CXX)

set(FPGA_PART xcu200-fsgd2104-2-e)
set(CLOCK_PERIOD 400MHz)

#find_package(Threads REQUIRED)

include(FetchContent)

# googletest
set(GOOGLETEST_VER 1.10.0)
set(GOOGLETEST_LOCAL_PATH "filefile://://${PROJECT_SOURCE_DIR}/external/googletest-release-${GOOGLETEST_VER}.zip")
FetchContent_Declare(
  googletest
  URL ${GOOGLETEST_LOCAL_PATH} https://github.com/google/googletest/archive/release-${GOOGLETEST_VER}.zip
)
FetchContent_MakeAvailable(googletest)

add_subdirectory(kernel)
add_subdirectory(test)
add_subdirectory(device)
add_subdirectory(host)

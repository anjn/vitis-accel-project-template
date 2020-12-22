# Unit Tests
set(TEST_SRCS
  src/vadd_test.cpp
  )
set(TEST_NAME unit_tests)
add_executable(${TEST_NAME} ${TEST_SRCS})
target_link_libraries(${TEST_NAME} gtest_main)
target_include_directories(${TEST_NAME} PRIVATE ${PROJECT_SOURCE_DIR}/kernel/include src)
add_test(NAME ${TEST_NAME} COMMAND $<TARGET_FILE:${TEST_NAME}>)

# Vitis Kernel Tests
include(${PROJECT_SOURCE_DIR}/common/vhls-test.cmake)

add_kernel_test(
  # kernel name
  vadd_kernel
  # test name
  vadd_kernel
  # cxxflags
  ""
  # ldflags
  ""
  # test args
  ""
  )

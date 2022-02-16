function(add_kernel_test KERNEL TEST_NAME CXXFLAGS LDFLAGS TEST_ARGS)

  set(KERNEL_SRC ${PROJECT_SOURCE_DIR}/kernel/src/${KERNEL}.cpp)
  set(TEST_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/${TEST_NAME}_test.cpp)

  list(APPEND CXXFLAGS -I${PROJECT_SOURCE_DIR}/kernel/include -std=c++17)
  list(APPEND LDFLAGS $<TARGET_FILE:gtest>)

  # csim
  add_test(
    NAME ${TEST_NAME}.csim
    COMMAND vitis_hls -f ${PROJECT_SOURCE_DIR}/common/vhls.tcl ${TEST_NAME}_csim ${KERNEL} vitis csim ${FPGA_PART} ${CLOCK_PERIOD} "${KERNEL_SRC}" "cxxflags=${CXXFLAGS}" "ldflags=${LDFLAGS}" "${TEST_SRC}" "${TEST_ARGS}" | ${PROJECT_SOURCE_DIR}/common/vhls-colorize.sh
    )

  # cosim
  add_test(
    NAME ${TEST_NAME}.cosim
    COMMAND vitis_hls -f ${PROJECT_SOURCE_DIR}/common/vhls.tcl ${TEST_NAME}_cosim ${KERNEL} vitis cosim ${FPGA_PART} ${CLOCK_PERIOD} "${KERNEL_SRC}" "cxxflags=${CXXFLAGS}" "ldflags=${LDFLAGS}" "${TEST_SRC}" "${TEST_ARGS}" | ${PROJECT_SOURCE_DIR}/common/vhls-colorize.sh
    )

  # debug_csim
  add_custom_target(
    ${TEST_NAME}.csim_debug
    COMMAND vitis_hls -f ${PROJECT_SOURCE_DIR}/common/vhls.tcl ${TEST_NAME}_csim_debug ${KERNEL} vitis csim_debug ${FPGA_PART} ${CLOCK_PERIOD} "${KERNEL_SRC}" "cxxflags=${CXXFLAGS}" "ldflags=${LDFLAGS}" "${TEST_SRC}" "${TEST_ARGS}" | ${PROJECT_SOURCE_DIR}/common/vhls-colorize.sh
    COMMAND gdb --args ${TEST_NAME}_csim_debug/solution/csim/build/csim.exe ${TEST_ARGS}
    )

  # debug_cosim
  add_custom_target(
    ${TEST_NAME}.cosim_debug
    COMMAND vitis_hls -f ${PROJECT_SOURCE_DIR}/common/vhls.tcl ${TEST_NAME}_cosim_debug ${KERNEL} vitis cosim_debug ${FPGA_PART} ${CLOCK_PERIOD} "${KERNEL_SRC}" "cxxflags=${CXXFLAGS}" "ldflags=${LDFLAGS}" "${TEST_SRC}" "${TEST_ARGS}" | ${PROJECT_SOURCE_DIR}/common/vhls-colorize.sh
    COMMAND gdb --args ${TEST_NAME}_csim_debug/solution/csim/build/csim.exe ${TEST_ARGS}
    )

endfunction()

function(add_kernel KERNEL CXXFLAGS)

  set(KERNEL_SRC ${PROJECT_SOURCE_DIR}/kernel/src/${KERNEL}.cpp)

  list(APPEND CXXFLAGS -I${PROJECT_SOURCE_DIR}/kernel/include -std=c++17)

  # csyn
  add_custom_target(
    ${KERNEL}.csyn
    COMMAND vitis_hls -f ${PROJECT_SOURCE_DIR}/common/vhls.tcl ${TEST_NAME}_csyn ${KERNEL} vitis csyn ${FPGA_PART} ${CLOCK_PERIOD} "${KERNEL_SRC}" "cxxflags=${CXXFLAGS}" "ldflags=" "" "" | ${PROJECT_SOURCE_DIR}/common/vhls-colorize.sh
    )

  # syn
  add_custom_target(
    ${KERNEL}.syn
    COMMAND vitis_hls -f ${PROJECT_SOURCE_DIR}/common/vhls.tcl ${TEST_NAME}_syn ${KERNEL} vitis syn ${FPGA_PART} ${CLOCK_PERIOD} "${KERNEL_SRC}" "cxxflags=${CXXFLAGS}" "ldflags=" "" "" | ${PROJECT_SOURCE_DIR}/common/vhls-colorize.sh
    )

  # impl
  add_custom_target(
    ${KERNEL}.impl
    COMMAND vitis_hls -f ${PROJECT_SOURCE_DIR}/common/vhls.tcl ${TEST_NAME}_impl ${KERNEL} vitis impl ${FPGA_PART} ${CLOCK_PERIOD} "${KERNEL_SRC}" "cxxflags=${CXXFLAGS}" "ldflags=" "" "" | ${PROJECT_SOURCE_DIR}/common/vhls-colorize.sh
    )

endfunction()

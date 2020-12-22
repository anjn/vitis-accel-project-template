include(${PROJECT_SOURCE_DIR}/common/vitis-device.cmake)

set(KERNEL_SRCS
  ${PROJECT_SOURCE_DIR}/kernel/src/vadd_kernel.cpp
  )
set(KERNEL_INCLUDE_DIRS
  ${PROJECT_SOURCE_DIR}/kernel/include
  )

set(VPP_FLAGS
  )
set(VPP_COMPILE_FLAGS
  )
set(VPP_LINK_FLAGS
  )

# .ini files
set(VPP_COMPILE_CONFIGS
  )
set(VPP_LINK_CONFIGS
  ${CMAKE_CURRENT_SOURCE_DIR}/link_u200.ini)

add_xclbin(
  vadd
  "${KERNEL_SRCS}"
  "${KERNEL_INCLUDE_DIRS}"
  "${VPP_FLAGS}"
  "${VPP_COMPILE_FLAGS}"
  "${VPP_LINK_FLAGS}"
  "${VPP_COMPILE_CONFIGS}"
  "${VPP_LINK_CONFIGS}"
  xilinx_u200_xdma_201830_2
  )


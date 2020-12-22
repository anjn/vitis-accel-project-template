# # Kernel
# xclbin_dir ?= xclbin
# xclobj_dir ?= xclobj
# 
# dsa := $(basename $(notdir $(platform)))
# 
# VPP := $(XILINX_VITIS)/bin/v++
# vpp_flags += -t $(build) --platform $(platform)
# 
# XCLBIN += $(xclbin_dir)/$(xclbin_name).$(build).$(dsa).xclbin
# XOBJS += $(patsubst %, $(xclobj_dir)/%.$(build).$(dsa).xo, $(kernels))
# 
# # for clean build
# XCLBIN_ALL += $(xclbin_dir)/$(xclbin_name).*.$(dsa).xclbin*
# XOBJS_ALL += $(patsubst %, $(xclobj_dir)/%.*.$(dsa).xo, $(kernels))
# 
# $(XOBJS): $(xclobj_dir)/%.$(build).$(dsa).xo: %.cpp
#         @mkdir -p $(xclobj_dir)
#         $(VPP) -c -k $* -o'$@' '$<' $(vpp_flags) $(vpp_compile_flags) --xp prop:kernel.$*.kernel_flags="$(kernel_flags)"
# 
# $(xclbin_dir)/$(xclbin_name).$(build).$(dsa).xclbin: $(XOBJS) $(xclbin_depends) $(rtl_kernels)
#         @mkdir -p $(xclbin_dir)
#         LANG= $(VPP) -l -o'$@' $(XOBJS) $(rtl_kernels) $(vpp_flags) $(vpp_link_flags)
# 
# emconfig.json:
#         emconfigutil --platform $(platform)

add_custom_target(host)

set(HOST vadd)
set(HOST_SRCS src/vadd.cpp)
add_executable(${HOST} ${HOST_SRCS})
target_include_directories(${HOST} PRIVATE $ENV{XILINX_XRT}/include)
target_link_libraries(${HOST} PRIVATE OpenCL rt stdc++)
target_compile_options(${HOST} PRIVATE -Wall -fmessage-length=0 -Wno-unknown-pragmas -Wno-unused-label)
target_compile_features(${HOST} PRIVATE cxx_std_17)
add_dependencies(host ${HOST})


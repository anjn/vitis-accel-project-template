MAKE := $(MAKE) --no-print-directory

TARGET ?= hw
DEVICE ?= xilinx_u200_xdma_201830_2

# Test target name (regex)
NAME ?=
JOBS ?= 1

all: help

.PHONY: help
help:
	@echo
	@echo "## Test & Debug ##"
	@echo "make test        [NAME=<test name>]                                 ... Run unit tests"
	@echo "make csim        [NAME=<test name>]                                 ... Run C-Simulation"
	@echo "make cosim       [NAME=<test name>]                                 ... Run Co-Simulation"
	@echo "make csim_debug   NAME=<test name>                                  ... Launch gdb"
	@echo "make cosim_debug  NAME=<test name>                                  ... Launch waveform viewer"
	@echo
	@echo "## Check QoR ##"
	@echo "make csyn NAME=<kernel name>                                        ... Run C-Synthesis" 
	@echo "make syn  NAME=<kernel name>                                        ... Run RTL-Synthesis" 
	@echo "make impl NAME=<kernel name>                                        ... Run RTL-Synthesis and P&R" 
	@echo
	@echo "## Vitis Build & Run ##"
	@echo "make build  [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Build xclbin and host code"
	@echo "make device [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Build xclbin"
	@echo "make host                                                           ... Build host code"
	@echo "make run    [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Run host code"
	@echo
	@echo "make help                                                           ... Show this help"
	@echo

.PHONY: download
download:
	@$(MAKE) -C external download

build/cmake.mk:
	@$(MAKE) -C external cmake
	@mkdir -p build
	@echo 'CMAKE = $$(shell readlink -f $$(firstword $$(wildcard external/cmake-*/bin/cmake)))' > $@

.PHONY: cmake_conf
cmake_conf:
	@mkdir -p build; cd build; $(CMAKE) ..

.PHONY: cmake_build
cmake_build: cmake_conf
	@cd build; $(MAKE)

.PHONY: test
test: cmake_build
ifeq ($(NAME),)
	@cd build ; env CTEST_OUTPUT_ON_FAILURE=1 GTEST_COLOR=1 ctest -V -j $(JOBS) -R unit_tests
else
	@cd build ; env CTEST_OUTPUT_ON_FAILURE=1 GTEST_COLOR=1 ctest -V -j $(JOBS) -R "${NAME}"
endif

.PHONY: csim
csim: cmake_build
	@cd build ; env CTEST_OUTPUT_ON_FAILURE=1 GTEST_COLOR=1 ctest -V -j $(JOBS) -R "$(NAME).*csim"

.PHONY: cosim
cosim: cmake_build
	@cd build ; env CTEST_OUTPUT_ON_FAILURE=1 GTEST_COLOR=1 ctest -V -j $(JOBS) -R "$(NAME).*cosim"

.PHONY: csim_debug
csim_debug: cmake_build
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; env GTEST_COLOR=1 $(MAKE) $(NAME)_csim_debug

.PHONY: cosim_debug
cosim_debug: cmake_build
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; env GTEST_COLOR=1 $(MAKE) $(NAME)_cosim_debug

.PHONY: csyn
csyn: cmake_conf
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; $(MAKE) $(NAME)_csyn

.PHONY: syn
syn: cmake_conf
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; $(MAKE) $(NAME)_syn

.PHONY: impl
impl: cmake_conf
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; $(MAKE) $(NAME)_impl

.PHONY: build
build: device host

.PHONY: device
device: cmake_conf
	@cd build; $(MAKE) device.${TARGET}.${DEVICE}

.PHONY: host
host: cmake_conf
	@cd build; $(MAKE) host

.PHONY: run
run: cmake_conf
	@cd build; $(MAKE) run.${TARGET}.${DEVICE}

.PHONY: clean
clean:
	@$(MAKE) -C external clean
	@rm -rf build

.PHONY: ultraclean
ultraclean: clean
	@test -e .git && git clean -dfX || true
	@test -e .git && git clean -df || true

-include build/cmake.mk

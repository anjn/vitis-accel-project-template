CMAKE = $(shell readlink -f $(firstword $(wildcard external/cmake-*/bin/cmake)))

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
	@echo "make host   [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Build host code"
	@echo "make run    [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Run host code"
	@echo
	@echo "make help                                                           ... Show this help"
	@echo

.PHONY: cmake
cmake:
	@$(MAKE) --no-print-directory -C external cmake
	@echo cmake path: $(CMAKE)

.PHONY: cmake_build
cmake_build: cmake
	@mkdir -p build; cd build; $(CMAKE) .. ; make --no-print-directory

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
	@cd build ; env GTEST_COLOR=1 make $(NAME)_csim_debug

.PHONY: cosim_debug
cosim_debug: cmake_build
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; env GTEST_COLOR=1 make $(NAME)_cosim_debug

.PHONY: csyn
csyn: cmake_build
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; make $(NAME)_csyn

.PHONY: syn
syn: cmake_build
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; make $(NAME)_syn

.PHONY: impl
impl: cmake_build
ifeq ($(NAME),)
	$(error NAME is not specified!)
endif
	@cd build ; make $(NAME)_impl

.PHONY: clean
clean:
	@$(MAKE) --no-print-directory -C external clean
	rm -rf build

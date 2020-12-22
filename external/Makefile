# CMake
CMAKE_TAR_GZ  := cmake-3.16.8-Linux-x86_64.tar.gz
CMAKE_DIR     := cmake-3.16.8-Linux-x86_64
CMAKE_BIN     := $(CMAKE_DIR)/bin/cmake
DOWNLOADS     += $(CMAKE_TAR_GZ)
TARGETS       += $(CMAKE_BIN)

$(CMAKE_TAR_GZ):
	wget https://github.com/Kitware/CMake/releases/download/v3.16.8/cmake-3.16.8-Linux-x86_64.tar.gz

$(CMAKE_DIR): $(CMAKE_TAR_GZ)
	tar xf $<

$(CMAKE_BIN): $(CMAKE_DIR)

.PHONY: cmake
cmake: $(CMAKE_BIN)

# googletest
GOOGLETEST_VER := 1.10.0
GOOGLETEST_ZIP := googletest-release-$(GOOGLETEST_VER).zip
DOWNLOADS       += $(GOOGLETEST_ZIP)

$(GOOGLETEST_ZIP):
	wget https://github.com/google/googletest/archive/release-$(GOOGLETEST_VER).zip -O $@

# common
.DEFAULT_GOAL := all
all: $(TARGETS)

.PHONY: download
download: $(DOWNLOADS)

.PHONY: clean
clean:
	rm -rf $(TARGETS) $(DOWNLOADS)


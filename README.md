# Vitis Accel Project Template

```
$ make help

## Test & Debug ##
make test        [NAME=<test name>]                                 ... Run unit tests
make csim        [NAME=<test name>]                                 ... Run C-Simulation
make cosim       [NAME=<test name>]                                 ... Run Co-Simulation
make csim_debug   NAME=<test name>                                  ... Launch gdb
make cosim_debug  NAME=<test name>                                  ... Launch waveform viewer

## Check QoR ##
make csyn NAME=<kernel name>                                        ... Run C-Synthesis
make syn  NAME=<kernel name>                                        ... Run RTL-Synthesis
make impl NAME=<kernel name>                                        ... Run RTL-Synthesis and P&R

## Vitis Build & Run ##
make build  [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Build xclbin and host code
make device [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Build xclbin
make host   [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Build host code
make run    [TARGET=<sw_emu|hw_emu|hw>] [DEVICE=<alveo platform>]   ... Run host code

make help                                                           ... Show this help
```

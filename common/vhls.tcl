set name      [lindex $argv 2]
set top       [lindex $argv 3]
set flow      [lindex $argv 4]
set mode      [lindex $argv 5]
set part      [lindex $argv 6]
set period    [lindex $argv 7]
set srcs      [lindex $argv 8]
set cxxflags  [lindex $argv 9]
set ldflags   [lindex $argv 10]
set test_srcs [lindex $argv 11]
set test_args [lindex $argv 12]

regsub "cxxflags=" $cxxflags {} cxxflags
regsub "ldflags=" $ldflags {} ldflags

open_project -reset $name
add_files -cflags "$cxxflags" $srcs
if { $test_srcs != "" } {
  add_files -cflags "$cxxflags" -tb $test_srcs
}
set_top $top
open_solution -flow_target $flow solution
set_part $part
create_clock -period $period -name default

if { $mode == "csim" } {
  csim_design -O -ldflags "$ldflags" -argv "$test_args"
}

if { $mode == "csim_debug" } {
  csim_design -O -ldflags "$ldflags" -setup
}

if { $mode == "cosim" } {
  csynth_design
  cosim_design -ldflags "$ldflags" -argv "$test_args"
}

if { $mode == "cosim_debug" } {
  csynth_design
  cosim_design -trace_level all -wave_debug -ldflags "$ldflags" -argv "$test_args"
}

if { $mode == "csyn" } {
  csynth_design
}

if { $mode == "syn" } {
  csynth_design
  export_design -flow syn
}

if { $mode == "impl" } {
  csynth_design
  export_design -flow impl
}

exit


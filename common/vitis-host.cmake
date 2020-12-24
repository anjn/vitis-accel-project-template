add_custom_target(host)

# emconfig.json
get_target_property(DEVICES xclbin DEVICES)
#message("Defined devices: ${DEVICES}")
foreach(DEVICE IN LISTS DEVICES)
  #message("Define target: emconfig.json.${DEVICE}")
  add_custom_command(
    OUTPUT emconfig.json.${DEVICE}
    COMMAND rm -f emconfig.json
    COMMAND emconfigutil --platform ${DEVICE}
    COMMAND mv emconfig.json emconfig.json.${DEVICE}
    )
endforeach()

# add_host
function(add_host HOST_NAME HOST_SRCS HOST_ARGS)

  # host
  add_executable(${HOST_NAME} ${HOST_SRCS})
  target_include_directories(${HOST_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include $ENV{XILINX_XRT}/include)
  target_link_libraries(${HOST_NAME} PRIVATE OpenCL rt stdc++)
  target_compile_options(${HOST_NAME} PRIVATE -Wall -fmessage-length=0 -Wno-unknown-pragmas -Wno-unused-label)
  target_compile_features(${HOST_NAME} PRIVATE cxx_std_17)
  add_dependencies(host ${HOST_NAME})

  # run
  get_target_property(DEVICES xclbin DEVICES)
  foreach(DEVICE IN LISTS DEVICES)
    # sw_emu, hw_emu
    foreach(TARGET IN ITEMS sw_emu hw_emu)
      get_target_property(XCLBIN "xclbin.${TARGET}.${DEVICE}" LOCATION)
      add_custom_target(
        run.${TARGET}.${DEVICE}
        COMMAND rm -f emconfig.json
        COMMAND ln -s emconfig.json.${DEVICE} emconfig.json
        COMMAND env XCL_EMULATION_MODE=${TARGET} $<TARGET_FILE:${HOST_NAME}> ${XCLBIN} ${HOST_ARGS}
        DEPENDS host xclbin.${TARGET}.${DEVICE} emconfig.json.${DEVICE}
        )
    endforeach()

    # hw
    set(TARGET hw)
    get_target_property(XCLBIN "xclbin.${TARGET}.${DEVICE}" LOCATION)
    add_custom_target(
      run.${TARGET}.${DEVICE}
      COMMAND $<TARGET_FILE:${HOST_NAME}> ${XCLBIN} ${HOST_ARGS}
      DEPENDS host xclbin.${TARGET}.${DEVICE}
      )
  endforeach()
endfunction()


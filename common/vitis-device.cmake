function(add_xclbin NAME KERNEL_SRCS KERNEL_INCLUDE_DIRS VPP_FLAGS VPP_COMPILE_FLAGS VPP_LINK_FLAGS VPP_COMPILE_CONFIGS VPP_LINK_CONFIGS DEVICE)
  # TODO
  set(KERNEL_DEPENDENCIES)
  foreach(DIR IN LISTS KERNEL_INCLUDE_DIRS)
    file(GLOB_RECURSE TMP CONFIGURE_DEPENDS LIST_DIRECTORIES false "${DIR}/*")
    list(APPEND KERNEL_DEPENDENCIES ${TMP})
    list(APPEND VPP_COMPILE_FLAGS -I${DIR})
  endforeach()

  foreach(CONF IN LISTS VPP_COMPILE_CONFIGS)
    list(APPEND VPP_COMPILE_FLAGS --config ${CONF})
  endforeach()

  foreach(CONF IN LISTS VPP_LINK_CONFIGS)
    list(APPEND VPP_LINK_FLAGS --config ${CONF})
  endforeach()

  foreach(TARGET IN ITEMS sw_emu hw_emu hw)
    set(KERNEL_XOS)
    
    foreach(KERNEL_SRC IN LISTS KERNEL_SRCS)
      get_filename_component(KERNEL_NAME ${KERNEL_SRC} NAME_WE)
      set(KERNEL_XO ${KERNEL_NAME}.${TARGET}.${DEVICE}.xo)
      add_custom_command(
        OUTPUT ${KERNEL_XO}
        COMMAND echo Compile flags: ${VPP_FLAGS} ${VPP_COMPILE_FLAGS}
        COMMAND v++ --compile --target ${TARGET} --platform ${DEVICE} --kernel ${KERNEL_NAME} ${KERNEL_SRCS} -o ${KERNEL_XO} --temp_dir _x.${TARGET}.${DEVICE} --save-temps --log_dir _x.${TARGET}.${DEVICE}/logs ${VPP_FLAGS} ${VPP_COMPILE_FLAGS}
        MAIN_DEPENDENCY ${KERNEL_SRC}
        DEPENDS ${KERNEL_DEPENDENCIES}
        )
      list(APPEND KERNEL_XOS ${KERNEL_XO})
    endforeach()
    
    set(XCLBIN ${NAME}.${TARGET}.${DEVICE}.xclbin)
    
    add_custom_command(
      OUTPUT ${XCLBIN}
      COMMAND echo Link flags: ${VPP_FLAGS} ${VPP_LINK_FLAGS}
      COMMAND v++ --link --target ${TARGET} --platform ${DEVICE} -o ${XCLBIN} ${KERNEL_XOS} ${VPP_FLAGS} ${VPP_LINK_FLAGS}
      MAIN_DEPENDENCY ${KERNEL_XOS}
      )
    
    add_custom_target(
      device.${TARGET}.${DEVICE}
      SOURCES ${XCLBIN}
      )
  endforeach()
endfunction()


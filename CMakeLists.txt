cmake_minimum_required (VERSION 2.8)

project(matbiips)

set(MATBIIPS_VERSION 0.11.0)

option (FIND_OCTAVE "Build Matbiips for Octave instead of Matlab" OFF)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/CMakeModules/")

# configure build
math(EXPR BITS "${CMAKE_SIZEOF_VOID_P} * 8")

# Determine compiler target architecture
set(SYSTEM_ARCH ${CMAKE_SYSTEM_PROCESSOR})

if (UNIX) # Linux or MacOSX
  #execute_process(COMMAND "dpkg" "--print-architecture" OUTPUT_VARIABLE SYSTEM_ARCH)
  #string(REGEX MATCH "[^\n]*" SYSTEM_ARCH ${SYSTEM_ARCH})
  execute_process(COMMAND uname -m
    OUTPUT_VARIABLE SYSTEM_ARCH
    OUTPUT_STRIP_TRAILING_WHITESPACE)

elseif (WIN32) # Windows
  if (BITS STREQUAL 64)
    set( SYSTEM_ARCH "x86_64" )
  else()
    set( SYSTEM_ARCH "x86" )
  endif()
endif()


if (FIND_OCTAVE)
    find_package(Octave)
    if (NOT OCTAVE)
      message(FATAL_ERROR "Octave not found") 
    endif() 
else()
    find_package(MATLAB)
    if (NOT MATLAB)
      message(FATAL_ERROR "Matlab not found") 
    endif()
endif()


enable_testing()

add_subdirectory(tests)
add_subdirectory(doc)

# create archive
if (OCTAVE)
  set(MATBIIPS_NAME octbiips)
else()
  set(MATBIIPS_NAME matbiips)
endif()

if (WIN32)
	set(ARCHIVE_EXT zip)
  
	find_package(Zip)
	if (NOT ZIP)
		message(FATAL_ERROR "Zip not found. Cannot make matbiips package archive.")
	endif()
else()
  set(ARCHIVE_EXT tar.gz)
endif()

set(MATBIIPS_ARCHIVE "${CMAKE_BINARY_DIR}/${MATBIIPS_NAME}_${MATBIIPS_VERSION}_${SYSTEM_ARCH}_${CMAKE_SYSTEM_NAME}.${ARCHIVE_EXT}")

file(GLOB ARCHIVE_FILES RELATIVE "${CMAKE_SOURCE_DIR}"
    *.m
    *.${MEX_EXT}
    private/*.m 
    private/*.${MEX_EXT}
    demo/*.m
    demo/*.bug
)


if (ARCHIVE_EXT STREQUAL tar.gz)
    # using cmake -E
    set (ARCHIVE_COMMAND ${CMAKE_COMMAND} -E tar cvfz)
elseif (ARCHIVE_EXT STREQUAL zip)
    # using zip
    set (ARCHIVE_COMMAND ${ZIP_COMMAND})
endif()

add_custom_target( matbiips_package
  DEPENDS matbiips
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMAND ${ARCHIVE_COMMAND} ${MATBIIPS_ARCHIVE}
  ${ARCHIVE_FILES}
  COMMENT "Packaging matbiips"
)


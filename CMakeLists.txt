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
  option(BUILD_64BIT "Build 64bit binaries" ON)

  if(BUILD_64BIT)
      set(BITS "64")
  endif()

  if (BITS STREQUAL 64)
    set( SYSTEM_ARCH "x86_64" )
  else()
    set( SYSTEM_ARCH "x86" )
  endif()
endif()


# Determine compiler
if (UNIX) # Linux or OS X
  execute_process(COMMAND ${CMAKE_CXX_COMPILER} -v
      OUTPUT_VARIABLE COMPILER_INFO_OUT
      ERROR_VARIABLE COMPILER_INFO_ERR
      OUTPUT_STRIP_TRAILING_WHITESPACE)
  string(REGEX MATCH clang|gcc COMPILER_NAME ${COMPILER_INFO_OUT} ${COMPILER_INFO_ERR})

  if (COMPILER_NAME STREQUAL clang)
    # set(BIIPS_COMPILE_FLAGS "-stdlib=libstdc++ -fPIC -Wno-redeclared-class-member -Wno-c++11-extensions")
    set(BIIPS_COMPILE_FLAGS "-std=c++11 -stdlib=libstdc++ -fPIC -Wno-redeclared-class-member")
    set(BIIPS_LINK_FLAGS "-stdlib=libstdc++")

  elseif (COMPILER_NAME STREQUAL gcc)
      # TODO : check if g++ version >= 4.7 or 4.8 ?
    set(BIIPS_COMPILE_FLAGS "-std=c++11 -fPIC -Wno-unused-local-typedefs -Wno-deprecated-declarations")

  else()
    message(WARNING "FIXME: Could not determine compiler name")
    set(BIIPS_COMPILE_FLAGS "-fPIC")
  endif()

elseif (WIN32) # Windows
  set(BIIPS_COMPILE_FLAGS "-m${BITS}")
  set(BIIPS_LINK_FLAGS "-m${BITS}")
endif()

set(BIIPS_COMPILE_FLAGS "${BIIPS_COMPILE_FLAGS}")

add_definitions(${BIIPS_COMPILE_FLAGS})
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${BIIPS_LINK_FLAGS}")
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} ${BIIPS_LINK_FLAGS}")


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
    
    if ( (${MATLAB_ARCH} STREQUAL x64) AND (BITS EQUAL 32) )
        message(FATAL_ERROR "Can not build matbiips for 32bit. Matlab architecture is 64bit.")
    elseif ( (${MATLAB_ARCH} STREQUAL i386) AND (BITS EQUAL 64) )
        message(FATAL_ERROR "Can not build matbiips for 64bit. Matlab architecture is 32bit.")
    endif ()
endif()


enable_testing()

add_subdirectory(src)
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


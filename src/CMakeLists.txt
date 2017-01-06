
# find boost
set (Boost_VERSION_REQUIRED 1.49.0)
find_package(Boost ${Boost_VERSION_REQUIRED})

# include directories
set(Core_INCLUDE_DIRS 
	${CMAKE_CURRENT_SOURCE_DIR}/biips/include/core
)

set(Base_INCLUDE_DIRS 
	${CMAKE_CURRENT_SOURCE_DIR}/biips/include/base
)

set(Compiler_INCLUDE_DIRS 
	${CMAKE_CURRENT_SOURCE_DIR}/biips/include/compiler
)

if (WIN32)
	set(Compiler_INCLUDE_DIRS ${Compiler_INCLUDE_DIRS}
    	${CMAKE_CURRENT_SOURCE_DIR}/biips/include/win32)
endif()

# source files list generation
file (GLOB_RECURSE Core_SRC
	${CMAKE_CURRENT_SOURCE_DIR}/biips/src/core/*.cpp
)

file (GLOB_RECURSE Base_SRC
	${CMAKE_CURRENT_SOURCE_DIR}/biips/src/base/*.cpp
)

file (GLOB_RECURSE Compiler_SRC
	${CMAKE_CURRENT_SOURCE_DIR}/biips/src/compiler/*.cpp
	${CMAKE_CURRENT_SOURCE_DIR}/biips/src/compiler/*.cc
)

file(GLOB MATBIIPS_SRC 
	${CMAKE_CURRENT_SOURCE_DIR}/*.cpp 
)
file(GLOB MATBIIPS_INCLUDES 
	${CMAKE_CURRENT_SOURCE_DIR}/*.h 
	${CMAKE_CURRENT_SOURCE_DIR}/*.hpp
)

set(BIIPS_LIBS biipsbase biipscompiler biipscore)

if (MATLAB OR OCTAVE) 
	
 	if(WIN32)

		# set incude flags
		foreach(d ${Boost_INCLUDE_DIRS} ${Core_INCLUDE_DIRS} ${Base_INCLUDE_DIRS} ${Compiler_INCLUDE_DIRS})
			set(MATBIIPS_INCLUDE_FLAGS ${MATBIIPS_INCLUDE_FLAGS} -I"${d}")
		endforeach()

		# biips src files targets
		foreach(f ${Core_SRC} ${Base_SRC} ${Compiler_SRC} ${MATBIIPS_SRC})
			# file extension
			get_filename_component(fext ${f} EXT)
			# file name
			get_filename_component(fname ${f} NAME_WE)

			# check cpp source file
			if(fext STREQUAL .c OR fext STREQUAL .cpp OR fext STREQUAL .cc)
				# target command
				add_custom_command(OUTPUT ${fname}.${MEX_OBJ_EXT}
					COMMAND ${MEX_COMMAND} ${MEX_FLAGS_${CMAKE_BUILD_TYPE}} ${MEX_COMPILE_OPT} ${MEX_OUTPUT_OPT} ${fname}.${MEX_OBJ_EXT} ${MATBIIPS_INCLUDE_FLAGS} ${f}
					COMMENT "Building ${fname}.${MEX_OBJ_EXT}"
					IMPLICIT_DEPENDS CXX ${f})
				set(Mbiips_OBJ ${Mbiips_OBJ} ${fname}.${MEX_OBJ_EXT})
			endif()
		endforeach()

		file(TO_CMAKE_PATH ${CMAKE_CURRENT_BINARY_DIR}/matbiips.${MEX_EXT} MATBIIPS_TARGET_LOC)

		# matbiips mexfile target
		add_custom_command(OUTPUT ${MATBIIPS_TARGET_LOC}
			DEPENDS ${MATBIIPS_OBJ}
			COMMAND ${MEX_COMMAND} ${MEX_MEX_OPT} ${MEX_FLAGS_${CMAKE_BUILD_TYPE}} ${MEX_OUTPUT_OPT} matbiips.${MEX_EXT} ${MATBIIPS_INCLUDE_FLAGS} ${MATBIIPS_OBJ}
			COMMENT "Linking mexfile matbiips.${MEX_EXT}"
		)
		add_custom_target(matbiips
			DEPENDS ${MATBIIPS_TARGET_LOC}
		)


 	elseif (UNIX)
 	    include_directories(${Core_INCLUDE_DIRS}
 			${Base_INCLUDE_DIRS}
 			${Compiler_INCLUDE_DIRS}
 			${MATLAB_INCLUDE_DIR}
 			${Boost_INCLUDE_DIRS}
 		)
 		
 		if (COMPILER_NAME STREQUAL gcc AND BIIPS_DEBUG)
 		    set(MATLAB_COMPILE_FLAGS "${MATLAB_COMPILE_FLAGS} -fpermissive")
 		endif()
 
 		add_library(matbiips SHARED 
 			${Core_SRC} ${Core_INCLUDES} 
 			${Base_SRC} ${Base_INCLUDES} 
 			${Compiler_SRC} ${Compiler_INCLUDES} 
 			${MATBIIPS_SRC} ${MATBIIPS_INCLUDES}
		)
 		target_link_libraries(matbiips ${MATLAB_LIBRARIES})
 		set_target_properties(matbiips PROPERTIES
 			COMPILE_FLAGS "${MATLAB_COMPILE_FLAGS}"
 			LINK_FLAGS "${MATLAB_LINK_FLAGS}"
 			PREFIX ""
 			SUFFIX .${MEX_EXT}
 		)
 	
 	endif()
else()
    if (FIND_OCTAVE)
        message (FATAL_ERROR "OCTAVE not found on your computer.\n"
        			 "Try setting OCTAVE_ROOT to the root path of 
        your OCTAVE installation. eg: c:\\Octave\\3.6.4")
    else()
        message (FATAL_ERROR "MATLAB not found on your computer.\n"
        			 "Try setting MATLAB_ROOT to the root path of 
        your MATLAB installation. eg: c:\\Program Files\\MATLAB\\R2012a")
    endif()
endif()


# install mexfile in the source directory
add_custom_command(TARGET matbiips
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:matbiips> "${CMAKE_SOURCE_DIR}"
    COMMENT "Copying mexfile in source directory"
    VERBATIM
)


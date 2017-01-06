set(MATBIIPS_TESTS 
    test_console test_output test_smc test_macros test_internals 
    test_funcmat test_distmat
    test_crash1 test_crash2
)
    
foreach(_test ${MATBIIPS_TESTS})
    set (MAT_COMS "cd ${CMAKE_CURRENT_SOURCE_DIR}; addpath('..'); ${_test}; exit")
    if (MATLAB)
        add_test(NAME ${_test}-matlab
            COMMAND ${MATLAB_COMMAND} ${MATLAB_FLAGS} -r "${MAT_COMS}"
        )
        set_tests_properties(${_test}-matlab PROPERTIES TIMEOUT 30)
    elseif (OCTAVE)
        add_test(NAME ${_test}-octave
            COMMAND ${MATLAB_COMMAND} ${MATLAB_FLAGS} --eval "${MAT_COMS}"
        )
        set_tests_properties(${_test}-octave PROPERTIES TIMEOUT 30)
    endif()
endforeach()

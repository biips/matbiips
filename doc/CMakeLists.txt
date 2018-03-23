find_package(LATEX)
add_custom_command(OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/matbiips_intro.pdf
                   DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/matbiips_intro.tex
                   COMMAND ${PDFLATEX_COMPILER}
                   ARGS ${CMAKE_CURRENT_SOURCE_DIR}/matbiips_intro.tex) 
add_custom_target(matbiips_doc 
                  DEPENDS  ${CMAKE_CURRENT_BINARY_DIR}/matbiips_intro.pdf) 

add_custom_command(OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/matbiips_internals.pdf
                   DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/matbiips_internals.tex
                   COMMAND ${PDFLATEX_COMPILER}
                   ARGS ${CMAKE_CURRENT_SOURCE_DIR}/matbiips_internals.tex) 
add_custom_target(matbiips_doc 
                  DEPENDS  ${CMAKE_CURRENT_BINARY_DIR}/matbiips_internals.pdf) 


#
# For Swift Package Manager, all output files placed in the package directories must be saved.  These include the output from gyb and LinuxMain.swift.
#
set_directory_properties(PROPERTIES CLEAN_NO_CUSTOM 1)

file(GLOB_RECURSE TEST_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.swift *.gyb)
file(GLOB LINUX_MAIN RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} LinuxMain.swift)

#
# Remove LinuxMain.swift from the list as this will be handled separately if Linux.
#
list(REMOVE_ITEM TEST_FILES "${LINUX_MAIN}")
get_filename_component(LINUX_MAIN ${LINUX_MAIN} ABSOLUTE BASE_DIR ${CMAKE_SOURCE_DIR})

#
# Test Target
#
add_custom_target(tests ALL
        COMMAND swift test
        DEPENDS build
        SOURCES ${TEST_FILES} ${CMAKE_SOURCE_DIR}/Package.swift
        WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
        )

add_custom_target(generate-tests)

add_dependencies(tests generate-tests)

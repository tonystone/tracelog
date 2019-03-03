#
# For Swift Package Manager, all output files placed in the package directories must be saved.  These include the output from gyb.
#
set_directory_properties(PROPERTIES CLEAN_NO_CUSTOM 1)

#
# Build the list of sources dynamically.
#
file(GLOB_RECURSE SOURCE_FILES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} *.swift)

#
# Main Build Target
#
add_custom_target(build ALL
        COMMAND swift build
        BYPRODUCTS .build
        SOURCES ${SOURCE_FILES} ${CMAKE_SOURCE_DIR}/Package.swift
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        )

add_custom_target(generate-source)

add_dependencies(build generate-source)

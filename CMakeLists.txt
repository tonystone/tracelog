cmake_minimum_required(VERSION 3.9)

project(TraceLog LANGUAGES NONE)

message(STATUS "Configuring TraceLog for ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "  Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "")

# Look for modules in the our root.
LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR})

include(Gyb)

#
# Clean the package
#
add_custom_target(build-clean
        COMMAND swift package clean
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        )

#
# Build xcode project Target
#
add_custom_target(xcode-project
        DEPENDS generate-source generate-tests
        COMMAND swift package generate-xcodeproj --xcconfig-overrides Package.xcconfig --enable-code-coverage
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
        SOURCES Package.swift)


add_custom_target(documentation
        DEPENDS xcode-project generate-source
        COMMAND jazzy --clean
        WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")

add_subdirectory(Sources)
add_subdirectory(Tests)

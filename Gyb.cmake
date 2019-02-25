#
# Creates a target to process a Gyb file.
#
# add_gyb_target(
#     targetName
#     SOURCE sourceGyb
#     OUTPUT output
#     [GYB gybPath]
#     [FLAGS [flags ...]]
#     [DEPENDS [depends ...]]
#     [COMMENT comment]
#     [WORKING_DIRECTORY dir])
#
# targetName
#   The name of this target which can be referenced later in your code.
#
# SOURCE
#   .gyb suffixed source file
#
# OUTPUT
#   Output filename to be generated
#
# GYB
#    Path to the GYB command, if not present it assumes its located in BUILD_TOOLS_BIN.
#
# FLAGS
#    Flags to pass to the GYB command.
#
# DEPENDS
#    Tragets this target depends on such as build-tools itself.
#
# COMMENT
#    Additional comments to be added to the message.
#
# WORKING_DIRECTORY
#    A directory that the target should work in, all paths should be relative to this one if included.
#
function(add_gyb_target targetName)

    set(options)
    set(singleValueArgs SOURCE OUTPUT GYB COMMENT WORKING_DIRECTORY)
    set(multiValueArgs FLAGS DEPENDS)

    cmake_parse_arguments(
            GYB_TARGET # prefix
            "${options}" "${singleValueArgs}" "${multiValueArgs}" ${ARGN})

    IF(NOT DEFINED GYB_TARGET_WORKING_DIRECTORY)
        set(GYB_TARGET_WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
    ENDIF(NOT DEFINED GYB_TARGET_WORKING_DIRECTORY)

    IF(NOT DEFINED GYB_TARGET_GYB)
        set(GYB_TARGET_GYB ${BUILD_TOOLS_BIN}/gyb)
    ENDIF(NOT DEFINED GYB_TARGET_GYB)

    # Note: the depedencies below don't work with relative paths (even when WORKING_DIRECTORY is used) so we convert all paths to absolute.
    get_filename_component(ABSOLUTE_SOURCE ${GYB_TARGET_SOURCE} ABSOLUTE BASE_DIR ${GYB_TARGET_WORKING_DIRECTORY})
    get_filename_component(ABSOLUTE_OUTPUT ${GYB_TARGET_OUTPUT} ABSOLUTE BASE_DIR ${GYB_TARGET_WORKING_DIRECTORY})

    # Add the command and targets to generate the file
    add_custom_command(
            OUTPUT ${ABSOLUTE_OUTPUT}
            DEPENDS ${ABSOLUTE_SOURCE} ${GYB_TARGET_DEPENDS}
            COMMAND ${GYB_TARGET_GYB}
            ARGS ${GYB_TARGET_FLAGS} -o "${ABSOLUTE_OUTPUT}" "${ABSOLUTE_SOURCE}"
            COMMENT "Generating ${GYB_TARGET_OUTPUT} from ${GYB_TARGET_SOURCE} ${GYB_TARGET_COMMENT}"
    )
    add_custom_target(${targetName}
            DEPENDS ${ABSOLUTE_SOURCE} ${ABSOLUTE_OUTPUT}
            )
    set_source_files_properties(${ABSOLUTE_OUTPUT}
            PROPERTIES GENERATED TRUE
            )
endfunction(add_gyb_target)

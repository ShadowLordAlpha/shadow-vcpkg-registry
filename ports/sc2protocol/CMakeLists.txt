cmake_minimum_required(VERSION 3.14)
project(sc2protocol)

file(GLOB proto_files "s2clientprotocol/*.proto")

if ("${proto_files}" STREQUAL "")
    message(FATAL_ERROR "Missing SC2 Protocol files. Please fix and try again")
endif ()

# Create the output directory for generated protos.
set(proto_generation_dir "${SOURCE_PATH}/generated/s2clientprotocol")
file(MAKE_DIRECTORY "${proto_generation_dir}")

foreach(proto ${proto_files})
    get_filename_component(proto_name ${proto} NAME_WE)
    list(APPEND proto_src
            "${proto_generation_dir}/${proto_name}.pb.cc"
            "${proto_generation_dir}/${proto_name}.pb.h")
endforeach()

add_library(${PROJECT_NAME} STATIC ${proto_src})
target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC "${SOURCE_PATH}/generated")
target_link_libraries(${PROJECT_NAME} PUBLIC libprotobuf)

if (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W0)
endif (MSVC)

foreach (proto ${proto_files})
#    get_filename_component(proto_name ${proto} NAME)
    get_filename_component(proto_name_we ${proto} NAME_WE)
    set(protoc_out_cc "${proto_generation_dir}/${proto_name_we}.pb.cc")
    set(protoc_out_h "${proto_generation_dir}/${proto_name_we}.pb.h")

    add_custom_command(
        OUTPUT
            "${protoc_out_cc}"
            "${protoc_out_h}"
        COMMAND
            "${PROJECT_BINARY_DIR}/bin/protoc"
            "-I=${sc2protocol_SOURCE_DIR}"
            "--cpp_out=${PROJECT_BINARY_DIR}/generated"
            "${proto}"
        DEPENDS protoc
        VERBATIM
    )
endforeach()

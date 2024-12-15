cmake_minimum_required(VERSION 3.14)
project(sc2protocol)

file(GLOB proto_files "s2clientprotocol/*.proto")

if ("${proto_files}" STREQUAL "")
    message(FATAL_ERROR "Missing SC2 Protocol files. Please fix and try again")
endif ()

# Create the output directory for generated protos.
set(proto_generation_dir "${PROJECT_BINARY_DIR}/generated/s2clientprotocol")
file(MAKE_DIRECTORY "${proto_generation_dir}")

foreach(proto ${proto_files})
    get_filename_component(proto_name ${proto} NAME_WE)
    list(APPEND proto_src
            "${proto_generation_dir}/${proto_name}.pb.cc"
            "${proto_generation_dir}/${proto_name}.pb.h")
endforeach()

add_library(${PROJECT_NAME} STATIC ${proto_src})
target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC "${PROJECT_BINARY_DIR}/generated")
target_link_libraries(${PROJECT_NAME} PUBLIC libprotobuf)

add_dependencies(${PROJECT_NAME} protoc)

foreach (proto ${proto_files})
    get_filename_component(proto_name ${proto} NAME)
    get_filename_component(proto_name_we ${proto} NAME_WE)
    set(outputCC ${PROJECT_BINARY_DIR}/generated/s2clientprotocol/${proto_name_we}.pb.cc)
    set(outputH ${PROJECT_BINARY_DIR}/generated/s2clientprotocol/${proto_name_we}.pb.h)

    add_custom_command(
            DEPENDS protoc
            COMMAND ${PROJECT_BINARY_DIR}/bin/protoc -I=${CMAKE_CURRENT_SOURCE_DIR}/../protocol/ --cpp_out=${PROJECT_BINARY_DIR}/generated ${proto}
            OUTPUT ${outputCC} ${outputH}
    )

endforeach()

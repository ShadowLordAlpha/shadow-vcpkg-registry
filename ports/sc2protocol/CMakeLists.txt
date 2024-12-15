cmake_minimum_required(VERSION 3.14)
project(sc2protocol)

# Find the Protobuf library
find_package(Protobuf REQUIRED)

file(GLOB PROTO_FILES "s2clientprotocol/*.proto")

if ("${PROTO_FILES}" STREQUAL "")
    message(FATAL_ERROR "Missing SC2 Protocol files. Please fix and try again")
endif ()

# Create the output directory for generated protos.
set(proto_generation_dir "${SOURCE_PATH}/generated/s2clientprotocol")
file(MAKE_DIRECTORY "${proto_generation_dir}")

add_library(${PROJECT_NAME})

# Generate C++ code from the .proto files
protobuf_generate(
    LANGUAGE cpp
    TARGET ${PROJECT_NAME}
    PROTOS ${PROTO_FILES}
    PROTOC_OUT_DIR ${proto_generation_dir}
)

target_link_libraries(${PROJECT_NAME} PUBLIC Protobuf::libprotobuf)

if (MSVC)
    target_compile_options(${PROJECT_NAME} PRIVATE /W0)
endif (MSVC)

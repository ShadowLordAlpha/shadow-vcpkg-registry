vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO Blizzard/s2client-proto
        REF a6d60f4cce7886a3be2bf7af2c1b12fdab6e9c63
        SHA512 420282f912bad0637f6e2b22c3e5326f13b930bddaed7b3463d191eda5fe3fcd50a58dc806cc183c7dcd0feefb40060c174102ba814c710480c07e6cabff07b0
        HEAD_REF master
)

file(COPY "${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt" DESTINATION "${SOURCE_PATH}")

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH})
vcpkg_cmake_install()
vcpkg_install_copyright("${SOURCE_PATH}/PROTOCOL_LICENSE")

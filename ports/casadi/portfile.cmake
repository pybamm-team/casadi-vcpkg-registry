vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO casadi/casadi
  REF 3.6.6
  SHA512 58b82d860c7fad5b04bbfbc8c8e8bf01de9181a0d8ac525f035485d4cff38144e8c8125b9f43aa709662261bd6af1e6aadf2d785b470144e9d9d42176b4edf26
  HEAD_REF master
)


string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" CASADI_BUILD_STATIC)
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "dynamic" CASADI_BUILD_SHARED)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
  OPTIONS 
    -DENABLE_STATIC=${CASADI_BUILD_STATIC}
    -DENABLE_SHARED=${CASADI_BUILD_SHARED}

)
vcpkg_install_cmake()

# Note: it was lib/cmake/${PORT} on a mac
vcpkg_fixup_cmake_targets(
  CONFIG_PATH ${PORT}/cmake
)

file(MAKE_DIRECTORY "${CURRENT_PACKAGES_DIR}/lib/pkgconfig")
file(RENAME "${CURRENT_PACKAGES_DIR}/debug/casadi/pkgconfig/casadi.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/casadi.pc")
vcpkg_fixup_pkgconfig()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/casadi/pkgconfig")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/casadi/pkgconfig")

file(COPY "${CURRENT_PACKAGES_DIR}/casadi/include" DESTINATION "${CURRENT_PACKAGES_DIR}")

file(
  INSTALL "${SOURCE_PATH}/LICENSE.txt"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)


vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO casadi/casadi
  REF 3.8.1
  SHA512 4750d2e9c7eda630bae02a8b8adb074a6e7ce361fd2a83425e3ac215a1446e90316ddfb0d4e3c1ecf3264c441833749c5bb8c6cecb96f1fd7b283b7dfdcc6a4f
  HEAD_REF master
)
# Tip for later: use git rev-parse HEAD:ports/<port-name> to update the git tree
# in casadi.json after updating the version above

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

# CasADi 3.7+ respects CMAKE_INSTALL_LIBDIR (set to lib by vcpkg) for
# pkgconfig, but cmake config still installs to casadi/cmake on Windows
# since vcpkg doesn't set CMAKE_PREFIX_RELATIVE.
vcpkg_fixup_cmake_targets(
  CONFIG_PATH ${PORT}/cmake
)

vcpkg_fixup_pkgconfig()

# Clean up any leftover casadi/ prefix directories from the install
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/casadi/pkgconfig")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/casadi/pkgconfig")

# Copy headers if they ended up under casadi/include instead of include/
if(EXISTS "${CURRENT_PACKAGES_DIR}/casadi/include")
  file(COPY "${CURRENT_PACKAGES_DIR}/casadi/include" DESTINATION "${CURRENT_PACKAGES_DIR}")
endif()

file(
  INSTALL "${SOURCE_PATH}/LICENSE.txt"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)

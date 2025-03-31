vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO casadi/casadi
  REF 3.7.0
  SHA512 884711734e3753e1e0b769777aa9c05af87f61f04455758f02199a5f574968e02f4c92bbc071bcb9a19230b4a5a790cf597a64c7c3ba3e423aaccfaa85f0f739
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


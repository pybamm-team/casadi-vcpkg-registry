vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO casadi/casadi
  REF 3.6.7
  SHA512 2c95368281f0bda385c6c451e361c168589f13aa66af6bc6fadf01f899bcd6c785ea7da3dee0fb5835559e58982e499182a4d244af3ea208ac05f672ea99cfd1
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
file(RENAME "${CURRENT_PACKAGES_DIR}/release/casadi/pkgconfig/casadi.pc" "${CURRENT_PACKAGES_DIR}/lib/pkgconfig/casadi.pc")
vcpkg_fixup_pkgconfig()
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/casadi/pkgconfig")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/release/casadi/pkgconfig")

file(COPY "${CURRENT_PACKAGES_DIR}/casadi/include" DESTINATION "${CURRENT_PACKAGES_DIR}")

file(
  INSTALL "${SOURCE_PATH}/LICENSE.txt"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)


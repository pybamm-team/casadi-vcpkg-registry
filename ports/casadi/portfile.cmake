vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO casadi/casadi
  REF nightly-ship
  SHA512 548f01b00a814645f9b520e2381b21ff623e110c8c2ac5696053c202b46cd3876e27dc2c1e2c3b5412422e28f60bd3baeb2890e12a3ae8b552f44343abbf17e7
  HEAD_REF master
)

vcpkg_configure_cmake(
  SOURCE_PATH "${SOURCE_PATH}"
  PREFER_NINJA
)
vcpkg_install_cmake()

# Note: it was lib/cmake/${PORT} on a mac
vcpkg_fixup_cmake_targets(
  CONFIG_PATH ${PORT}/cmake
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/LICENSE.txt"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)


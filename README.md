A [vcpkg](https://github.com/microsoft/vcpkg) registry providing a portfile for the [sundials library](https://computing.llnl.gov/projects/sundials/sundials-software) with a feature to 
enable compilation against [SuiteSparse](https://people.engr.tamu.edu/davis/suitesparse.html)'s KLU algorithm.

See
- [Selecting library features](https://github.com/microsoft/vcpkg/blob/master/docs/users/selecting-library-features.md)
- [Registries: Bring your own libraries to vcpkg](https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/)
### Why a separate registry?

sundials [is available through vcpkg](https://github.com/microsoft/vcpkg/tree/master/ports/sundials), but is compiled without KLU
support.  To enable this, the portfile (among other things) must be
modified to enable KLU support (i.e. setting `KLU_ENABLE` to `TRUE`) but
also find the SuiteSparse library.

### Installing sundials from this registry

You need to tell you vcpkg installation to look for sundials port here, instead
of the main vcpkg registry. This is achieved using `vcpkg-configuration.json` file
at the root of you vcpkg installation (or project if you're using vcpkg in manifest mode):
```json
{
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/pybamm-team/sundials-vcpkg-registry.git",
      "packages": [ "sundials" ]
    }
  ]
}
```

Next, you can install sundials with KLU support with
```shell
vcpkg install sundials[klu] --feature-flags=registries
```
this will installed sundials with KLU support, along with the required dependencies
(e.g. SuiteSparse).

### Summary of changes

The two main changes compared are:

- A `klu` feature that depends on SuiteSparse
  ```json
  # ports/sundials/vcpkg.json
  {
    "name": "sundials",
	# ...
    "features": {
	    "klu": {
	        "description": "KLU support for SUNDIALS",
	        "dependencies": ["suitesparse"]
	        }
      }
  }
  ```
  
  ```cmake
  # ports/sundials/portfile.cmake
  #...
  if ("klu" IN_LIST FEATURES)
	  set(ENABLE_KLU ON)
  else()
	  set(CMAKE_DISABLE_FIND_PACKAGE_SUITESPARSE ON)
  endif()
  # ...
  ```
- A `find-klu.patch` patch that makes sure CMake finds vcpkg's SuiteSparse when
  compiling sundials.
  ```cmake
  # ports/sundials/portfile.cmake
  vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO LLNL/sundials
    # ...
    PATCHES "find-klu.patch"
    # ...
  )
  ```
  See the vcpkg docs at [Patching Example: Patching libpng to work for x64-uwp](https://github.com/microsoft/vcpkg/blob/master/docs/examples/patching.md).


# PyBaMM CasADi VCPKG registry

A [vcpkg](https://github.com/microsoft/vcpkg) registry providing a portfile for the
[CasADi](https://github.com/casadi/casadi) package.

See
- [Selecting library features](https://github.com/microsoft/vcpkg/blob/master/docs/users/selecting-library-features.md)
- [Registries: Bring your own libraries to vcpkg](https://devblogs.microsoft.com/cppblog/registries-bring-your-own-libraries-to-vcpkg/)

### Why a separate registry?

## Installing CasADi from this registry

You need to tell you vcpkg installation to look for sundials port here, instead
of the main vcpkg registry. This is achieved using `vcpkg-configuration.json` file
at the root of you vcpkg installation (or project if you're using vcpkg in manifest mode):
```json
{
  "registries": [
    {
      "kind": "git",
      "repository": "https://github.com/pybamm-team/casadi-vcpkg-registry.git",
      "packages": [ "casadi" ]
    }
  ]
}
```

Next, you can install casadi with
```shell
vcpkg install casadi --feature-flags=registries
```
this will install CasADi, along with the required dependencies.

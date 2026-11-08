# ImGui Bindings for Nim [![Nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png)](https://github.com/nim-lang/nimble)

Separated module from [NimGL](https://nimgl.dev/). In order to maintain small
sized modules to facilitate development and reduce number of required modules.

Some developers do not require the entire bundle of APIs that
[NimGL](https://nimgl.dev/) offers, and so, prefer to only download the required
modules.

Updated Dear ImGui (CImGui) to 1.93.1 WIP dock (docking branch) (2026/11).

## Two build modes

The bindings support two ways of linking against cimgui:

### 1. C++ static compile (default, `nim cpp`)

When compiled with `nim cpp` (and without `-d:cimguiDLL`), the cimgui /
Dear ImGui C++ sources under `src/imgui/private/cimgui/` are compiled and
linked directly into your binary.

### 2. Dynamic link via cimgui (`-d:cimguiDLL`) 

When compiled with `nim c`, or with `-d:cimguiDLL`, the bindings load
`cimgui.dll` (Windows), `cimgui.so` (Linux) or `cimgui.dylib` (macOS) at
runtime.   
Build the shared library from `src/imgui/private/cimgui/` with

   ```sh
   nimlbe cimgui
   ```

and place it next to your executable.

## Installation

### Nimble download

You can install this package through the official package manager of Nim.

```bash
$ nimble install https://github.com/nimgl/imgui.git
```

In order to respect already existing libraries in the package registry, and
because [NimGL](https://nimgl.dev/) already exists in there, this package is
only able to be accessible by direct git url.

### Nimble direct install

```bash
$ git clone --recursive -j8 https://github.com/nimgl/imgui.git
$ cd imgui
$ nimble install
```

### NimGL module

```bash
$ nimble install nimgl
```

You can find more information in the [main repo](https://github.com/nimgl/nimgl).

### Running the tests

```bash
$ nimble test     # opens a window with the ImGui demo (GLFW + OpenGL)
$ nimble ci       # headless null-backend demo
```

### Runtime requirements

Depending on the compilation backend, different prerequisites are needed:

#### nim cpp (static linking, default)

The cimgui renderer backend (`imgui_impl_glfw.cpp`) is compiled from source and
requires the GLFW 3 development headers and import library :

* **Windows (MSYS2)**: `pacman -S mingw-w64-ucrt-x86_64-glfw`
* **Linux**: install the GLFW development package, e.g.
  `sudo apt install libglfw3 libglfw3-dev` (Debian/Ubuntu) or the equivalent
  package of your distribution.

#### nim c (dynamic linking via cimgui DLL)

Build the shared library beforehand and place it next to your executable:

```bash
$ nimble cimgui    # builds src/imgui/private/cimgui/build/cimgui.dll via CMake
                   # and copies it to tests/
```

Alternatively, build it manually with `make` inside
`src/imgui/private/cimgui/` or with CMake directly.

## Development Dear ImGui wrapper

### Regenerating the bindings

The Nim bindings in `src/imgui.nim` are generated from the cimgui headers by
`tools/generator.nim`:

```bash
$ make gen        # runs: nimble gen (nim c -r tools/generator.nim)
```

It is currently being developed and tested on

* Windows 11 
* ~MacOS Mojave~~
* Linux Debian 13

## Contribute

I'm only one person and I use this library almost daily for school and personal
projects. If you are missing some extension, procedures, bindings or anything
related feel free to PR them or open an Issue with the specification and
if you can some examples to have an idea on how to implement it.
Thank you so much :tada:

### This being a separate module behaves slightly differently.

Please open all issues in the [main repository](https://github.com/nimgl/nimgl).
The PRs and new feature development will occur in each binding's repo.

## Usage

See the [examples](https://github.com/nimgl/nimgl/blob/master/examples/timgui.nim) in the main
repository for usage.

Check out the references and doc in order to understand ImGui usage.

## License

[MIT License](https://github.com/nimgl/nimgl/blob/master/LICENSE)

NimGL is open source and is under the MIT License, we highly encourage every
developer that uses it to make improvements and fork them here.

## Contributors

Thank you to every contributor that has spent their time improving this library.

[List of all contributors.](https://github.com/nimgl/nimgl/graphs/contributors)

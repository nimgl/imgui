[![docs](https://img.shields.io/badge/docs-passing-4caf50.svg?style=flat-square)](https://nimgl.dev/docs)

# ImGui Bindings for Nim [![Nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble.png)](https://github.com/nim-lang/nimble)

Separated module from [NimGL](https://nimgl.dev/). In order to mantain small
sized modules to facilitate development and reduce number of required modules.

Some developers do not require the entire bundle of APIs that
[NimGL](https://nimgl.dev/) offer, and so, prefere to only download the required
modules.

## Installation

### Nimble download

You can install this package through the official package manager of Nim.

```bash
$ nimble install https://github.com/nimgl/imgui.git
```

In order to respect already existing libraries in the package registry, and
because [NimGL](https://nimgl.dev/) already exists in there, this package is
only able to be accesible by direct git url.

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

### Development

It is currently being developed and tested on

* Windows 10
* MacOS Mojave
* Linux Ubuntu 18.10

## Contribute

I'm only one person and I use this library almost daily for school and personal
projects. If you are missing some extension, procedures, bindings or anything
related feel free to PR them or open an Issue with the specification and
if you can some examples to have an idea on how to implement it.
Thank you so much :tada:

### This being a separate module behaves slightly diferently.

Please open all issues in the [main repository](https://github.com/nimgl/nimgl).
The PRs and new feature development will occur in each binding's repo.

## Usage

```nim
import imgui

igText("Hello World")

var f: float32
igSliderFloat("float", f, 0.0f, 1.0f)
```

Check out the references and doc in order to understand ImGui usage.

## License

[MIT License](https://github.com/nimgl/nimgl/blob/master/LICENSE)

NimGL is open source and is under the MIT License, we highly encourage every
developer that uses it to make improvements and fork them here.

## Contributors

Thank you to every contributor that has spent their time improving this library.

[List of all contributors.](https://github.com/nimgl/nimgl/graphs/contributors)

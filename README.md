
# Portable libapt-pkg-perl Runtime

<img width="1254" height="1254" alt="portable_libapt_pkg_perl" src="https://github.com/user-attachments/assets/48337568-6e8c-4ee4-8a10-85362e042f0f" />


> A lightweight Bash tool for building a portable development runtime for libapt-pkg-perl and Perl dependencies.

[![License: GPL-2.0](https://img.shields.io/badge/License-GPL--2.0-blue.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/Bash-4%2B-4EAA25.svg)](https://www.gnu.org/software/bash/)

---

## 📖 Overview

`get_mirror_deps.sh` creates a portable development runtime for `libapt-pkg-perl`.

The script collects:

- Perl interpreter
- Perl standard runtime libraries
- `libapt-pkg-perl`
- APT libraries
- Required shared library dependencies

The dependency packages are downloaded from Debian repositories because `apt` and `libapt-pkg-perl` are provided through Debian package infrastructure.

The generated runtime is isolated from the host system and can be used by developers who need a ready-to-use `libapt-pkg-perl` environment without installing the complete dependency chain globally.

---

## ✨ Features

* **🐪 Portable Perl Environment** — Provides Perl and required standard runtime files.
* **🔗 libapt-pkg-perl Runtime** — Bundles Perl APT bindings and native APT libraries.
* **📦 Dependency Collection** — Automatically gathers required runtime dependencies.
* **🔓 No Host Installation** — Packages are extracted without modifying the host system.
* **📚 Shared Library Bundle** — Includes required `.so` dependencies.
* **🛠️ ELF Runtime Setup** — Configures bundled libraries with correct runtime paths.
* **📁 Developer-focused Runtime** — Provides an isolated environment for developing with `libapt-pkg-perl`.

---

## 🚀 Usage

Configure:

```bash
nano conf.sh
````

Run:

```bash
chmod +x get_mirror_deps.sh
./get_mirror_deps.sh
```

Generated runtime:

```text
build/
└── amd64/
    ├── runtime/
    └── shards_libs/
```

---

## 🔧 How It Works

```text
Debian Packages
        |
        v
Download Dependencies
        |
        v
Extract Packages
        |
        v
Collect Perl + libapt-pkg-perl
        |
        v
Collect Shared Libraries
        |
        v
Configure Runtime Paths
        |
        v
Portable Development Runtime
```

Packages are used only as dependency sources and are not installed into the host operating system.

---

## 📂 Output

Example:

```text
build/
└── amd64/
    ├── runtime/
    │   ├── perl
    │   ├── perl libraries
    │   └── libapt-pkg-perl
    │
    └── shards_libs/
        ├── libapt-pkg.so.*
        └── required shared libraries
```

---

## 🌍 Compatibility

The runtime is designed to provide a portable `libapt-pkg-perl` development environment.

The generated runtime is self-contained and does not require the original Debian packages to be installed on the target system.

The only external runtime dependencies are:

* `ld-linux` (the ELF dynamic loader)
* `glibc` (GNU C Library)

All other components, including:

* Perl interpreter
* Perl standard runtime libraries
* `libapt-pkg-perl`
* APT libraries
* Required shared libraries

are bundled inside the generated runtime.

The generated files depend on:

* target architecture
* Linux ABI compatibility
* bundled libraries
  
---

## 📄 License

GPL-2.0

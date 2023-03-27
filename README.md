<div align="center">

# asdf-lf [![Build](https://github.com/iul1an/asdf-lf/actions/workflows/build.yml/badge.svg)](https://github.com/iul1an/asdf-lf/actions/workflows/build.yml) [![Lint](https://github.com/iul1an/asdf-lf/actions/workflows/lint.yml/badge.svg)](https://github.com/iul1an/asdf-lf/actions/workflows/lint.yml)


[lf](https://github.com/gokcehan/lf) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents
- [Compatibility](#compatibility)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Compatibility
This plugin works with Linux and MacOS, both amd64 and arm64 CPU architecture.

# Install

Plugin:

```shell
asdf plugin add lf
# or
asdf plugin add lf https://github.com/iul1an/asdf-lf.git
```

lf:

```shell
# Show all installable versions
asdf list-all lf

# Install specific version
asdf install lf latest

# Set a version globally (on your ~/.tool-versions file)
asdf global lf latest

# Now lf commands are available
lf --help
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/iul1an/asdf-lf/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Iulian Mandache](https://github.com/iul1an/)

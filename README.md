# Dotfiles

## Prerequisites

**Packages**

- make

## Usage

Pick the target for your distro:

```sh
make setup-ubuntu   # Debian/Ubuntu (apt)
make setup-arch     # Arch (pacman)
```

Each distro is fully self-contained under its own folder (`ubuntu/`, `arch/`);
Individual steps can also be run on their own, e.g. `make config-git-arch`.
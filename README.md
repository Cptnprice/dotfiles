# Dotfiles

## Prerequisites

**Packages**

- make

## Usage

Setup is split on two independent parts: **distro** (which package manager) and
**desktop environment** (which keyboard-binding mechanism). Run one target from
each.

```sh
# 1. Distro — packages, zsh, git, fzf
make setup-ubuntu     # Debian/Ubuntu (apt)
make setup-arch       # Arch (pacman)
make setup-fedora     # Fedora (dnf)

# 2. Desktop environment — keyboard bindings
make keybindings-gnome
make keybindings-kde  # Plasma 6
```

For example, Fedora + KDE is `make setup-fedora && make keybindings-kde`.

Each distro is fully self-contained under its own folder (`ubuntu/`, `arch/`, `fedora/`),
and keyboard bindings live under `keyboard-shortcuts/{gnome,kde}/` since they
depend on the desktop environment, not the distro. Individual steps can also be
run on their own, e.g. `make config-git-arch`.
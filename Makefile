SHELL := /bin/bash
BOLD  := $(shell tput bold)
RESET := $(shell tput sgr0)

.PHONY: setup-ubuntu install-packages-ubuntu setup-zsh-ubuntu setup-keyboard-bindings-ubuntu config-zsh-ubuntu config-git-ubuntu config-git-aliases-ubuntu config-fzf-ubuntu \
        setup-arch install-packages-arch setup-zsh-arch setup-keyboard-bindings-arch config-zsh-arch config-git-arch config-git-aliases-arch config-fzf-arch

# ── Ubuntu ──────────────────────────────────────────────────────────

setup-ubuntu: install-packages-ubuntu setup-zsh-ubuntu setup-keyboard-bindings-ubuntu config-zsh-ubuntu config-git-ubuntu config-git-aliases-ubuntu config-fzf-ubuntu

install-packages-ubuntu:
	@echo "$(BOLD)Installing packages...$(RESET)"
	@bash ubuntu/packages/installPackages.sh

setup-zsh-ubuntu:
	@echo "$(BOLD)Setting up zsh...$(RESET)"
	@bash ubuntu/shell/zsh/setupZsh.sh

setup-keyboard-bindings-ubuntu:
	@echo "$(BOLD)Setting up keyboard bindings...$(RESET)"
	@bash ubuntu/keyboard-shortcuts/setCustomBindings.sh

config-zsh-ubuntu:
	@echo "$(BOLD)Configuring zsh...$(RESET)"
	@bash ubuntu/configuration/zsh/config.sh

config-git-ubuntu:
	@echo "$(BOLD)Configuring git...$(RESET)"
	@bash ubuntu/configuration/git/config.sh

config-git-aliases-ubuntu:
	@echo "$(BOLD)Configuring git aliases...$(RESET)"
	@bash ubuntu/configuration/git/aliases.sh

config-fzf-ubuntu:
	@echo "$(BOLD)Configuring fzf...$(RESET)"
	@bash ubuntu/configuration/fzf/aliases.sh

# ── Arch ────────────────────────────────────────────────────────────

setup-arch: install-packages-arch setup-zsh-arch setup-keyboard-bindings-arch config-zsh-arch config-git-arch config-git-aliases-arch config-fzf-arch

install-packages-arch:
	@echo "$(BOLD)Installing packages...$(RESET)"
	@bash arch/packages/installPackages.sh

setup-zsh-arch:
	@echo "$(BOLD)Setting up zsh...$(RESET)"
	@bash arch/shell/zsh/setupZsh.sh

setup-keyboard-bindings-arch:
	@echo "$(BOLD)Setting up keyboard bindings...$(RESET)"
	@bash arch/keyboard-shortcuts/setCustomBindings.sh

config-zsh-arch:
	@echo "$(BOLD)Configuring zsh...$(RESET)"
	@bash arch/configuration/zsh/config.sh

config-git-arch:
	@echo "$(BOLD)Configuring git...$(RESET)"
	@bash arch/configuration/git/config.sh

config-git-aliases-arch:
	@echo "$(BOLD)Configuring git aliases...$(RESET)"
	@bash arch/configuration/git/aliases.sh

config-fzf-arch:
	@echo "$(BOLD)Configuring fzf...$(RESET)"
	@bash arch/configuration/fzf/aliases.sh

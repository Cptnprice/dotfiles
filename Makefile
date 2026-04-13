SHELL := /bin/bash
BOLD  := $(shell tput bold)
RESET := $(shell tput sgr0)

setup: install-packages setup-zsh setup-keyboard-bindings setup-git-config setup-git-aliases setup-fzf

install-packages:
	@echo "$(BOLD)Installing packages...$(RESET)"
	@bash packages/installPackages.sh

setup-zsh:
	@echo "$(BOLD)Setting up zsh...$(RESET)"
	@bash shell/zsh/setupZsh.sh

setup-keyboard-bindings:
	@echo "$(BOLD)Setting up keyboard bindings...$(RESET)"
	@bash keyboard-shortcuts/setCustomShortcuts.sh

setup-git-config:
	@echo "$(BOLD)Configuring git...$(RESET)"
	@bash configuration/git/config.sh

setup-git-aliases:
	@echo "$(BOLD)Setting up git aliases...$(RESET)"
	@bash configuration/git/aliases.sh

setup-fzf:
	@echo "$(BOLD)Setting up fzf...$(RESET)"
	@bash configuration/fzf/aliases.sh

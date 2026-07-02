SHELL := /bin/bash
BOLD  := $(shell tput bold)
RESET := $(shell tput sgr0)

setup: install-packages setup-zsh setup-keyboard-bindings config-zsh config-git config-git-aliases config-fzf

install-packages:
	@echo "$(BOLD)Installing packages...$(RESET)"
	@bash packages/installPackages.sh

setup-zsh:
	@echo "$(BOLD)Setting up zsh...$(RESET)"
	@bash shell/zsh/setupZsh.sh

setup-keyboard-bindings:
	@echo "$(BOLD)Setting up keyboard bindings...$(RESET)"
	@bash keyboard-shortcuts/setCustomBindings.sh

config-zsh:
	@echo "$(BOLD)Configuring zsh...$(RESET)"
	@bash configuration/zsh/config.sh

config-git:
	@echo "$(BOLD)Configuring git...$(RESET)"
	@bash configuration/git/config.sh

config-git-aliases:
	@echo "$(BOLD)Configuring git aliases...$(RESET)"
	@bash configuration/git/aliases.sh

config-fzf:
	@echo "$(BOLD)Configuring fzf...$(RESET)"
	@bash configuration/fzf/aliases.sh

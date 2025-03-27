#!/usr/bin/env bash

BASE_PATH=$(dirname "$0")

# Upgrade system & Add some useful packages
sudo apt-get update -y && sudo apt-get full-upgrade -y && \
sudo apt-get install -y \
    build-essential \
    tcpreplay \
    lsd \
    ripgrep \
    python-is-python3 \
    python3.12-venv \
    python3.12-dev \
    libreadline-dev \
    npm \
    tmux \
    zsh \
    zoxide \
    direnv

# JFrog CLI
source "$BASE_PATH"/jfrog-cli-install.sh

# Fast Python package manager (uv)
command -v uv > /dev/null || curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install bump-my-version
uv tool install basedpyright

# Install neovim 0.10.4
command -v nvim > /dev/null || ( \
    wget https://github.com/neovim/neovim-releases/releases/download/v0.10.4/nvim-linux-x86_64.deb && \
    sudo apt install -y ./nvim-linux-x86_64.deb && \
    rm ./nvim-linux-x86_64.deb \
)

# Change default shell to zsh
sudo usermod -s $(which zsh) "$USER"

# Install custom user systemd services
SYSTEMD_USER_PATH="$HOME"/.config/systemd/user

mkdir -p "$SYSTEMD_USER_PATH"
cp -r "$BASE_PATH"/services/* "$SYSTEMD_USER_PATH"
systemctl --user enable ssh-agent
systemctl --user start ssh-agent

NVIM_CONFIG_PATH="$HOME"/.config/nvim
TMUX_CONFIG_PATH="$HOME"/.config/tmux
ZSH_CONFIG_PATH="$HOME"/.config/zsh

[ ! -d $NVIM_CONFIG_PATH ] && \
    git clone https://github.com/RCX777/neovim-config "$NVIM_CONFIG_PATH"

[ ! -d $ZSH_CONFIG_PATH ] && \
    git clone https://github.com/RCX777/zsh-config "$BASE_PATH"/.temp-zsh-config && \
    . "$BASE_PATH"/.temp-zsh-config/install.sh && \
    rm -rf "$BASE_PATH"/.temp-zsh-config

[ ! -d $TMUX_CONFIG_PATH ] && \
    git clone https://github.com/RCX777/tmux-config "$BASE_PATH"/.temp-tmux-config && \
    . "$BASE_PATH"/.temp-tmux-config/install.sh && \
    rm -rf "$BASE_PATH"/.temp-tmux-config


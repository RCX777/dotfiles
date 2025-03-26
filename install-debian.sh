#!/usr/bin/env bash

BASE_PATH=$(dirname "$0")

# Upgrade system & Add some useful packages
sudo apt-get update -y && sudo apt-get upgrade -y && \
sudo apt-get install -y \
    build-essential \
    tcpreplay \
    lsd \
    ripgrep \
    python3.12-venv \
    python3.12-dev \
    libreadline-dev \
    npm \
    tmux \
    zsh \
    zoxide \
    direnv

# Fast Python package manager (uv)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv tool install bump-my-version

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
    git clone https://github.com/RCX777/zsh-config && \
    cd zsh-config && \
    . ./install.sh && \
    cd .. && \
    rm -rf zsh-config

[ ! -d $TMUX_CONFIG_PATH ] && \
    git clone https://github.com/RCX777/tmux-config && \
    cd tmux-config && \
    . ./install.sh && \
    cd .. && \
    rm -rf zsh-config


#!/bin/bash

# ========================================
# 环境初始化脚本 (Zsh、插件、字体、配置)
# ========================================

# 设置家目录
HOME_DIR="$HOME"

# -------------------------------
# 安装必要软件
# -------------------------------
sudo apt update && sudo apt upgrade -y

sudo apt install -y curl build-essential golang-go nodejs npm tree
# 基本工具
sudo apt install -y \
    zsh \
    fzf \
    lsd \
    ripgrep \
    duf \
    fd-find \
    tldr \
    fastfetch \
    cpufetch

# -------------------------------
# Zsh 配置
# -------------------------------
ZSH_PLUGINS_DIR="$HOME_DIR/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

# 复制本地配置文件到家目录
cp -r .zshrc "$HOME_DIR/"
cp -r .zsh "$HOME_DIR/"

# 安装 Zsh 插件
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"

# -------------------------------
# 配置文件
# -------------------------------
CONFIG_DIR="$HOME_DIR/.config"
mkdir -p "$CONFIG_DIR"
cp -r ./config/* "$CONFIG_DIR/"

# -------------------------------
# 字体安装
# -------------------------------
FONTS_DIR="$HOME_DIR/.local/share/fonts"
mkdir -p "$FONTS_DIR"
cp -r ./fonts/* "$FONTS_DIR/"

# 更新字体缓存
fc-cache -fv

# -------------------------------
# IBus Rime 输入法
# -------------------------------
IBUS_DIR="$HOME_DIR/.config/ibus"
mkdir -p "$IBUS_DIR"

git clone --depth 1 https://github.com/iDvel/rime-ice "$IBUS_DIR/rime"



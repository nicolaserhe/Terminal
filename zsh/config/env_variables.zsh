# ========================================
# 环境变量配置
# ========================================
# PATH 和其他环境变量设置
# ========================================

# -------------------------------
# PATH 设置
# -------------------------------
# Go 语言环境
export PATH="/usr/local/go/bin:$HOME/go/bin:$PATH"

# Rust 环境
export PATH="$HOME/.cargo/bin:$PATH"

# Node.js 全局包
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# -------------------------------
# 编辑器设置
# -------------------------------
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'

# -------------------------------
# 语言和编码
# -------------------------------
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# -------------------------------
# Less 配置（更好的分页器）
# -------------------------------
export LESS='-R -F -X'
export LESSHISTFILE='-'  # 不保存 less 历史

# -------------------------------
# Man 页面颜色
# -------------------------------
export LESS_TERMCAP_mb=$'\e[1;32m'     # 开始闪烁
export LESS_TERMCAP_md=$'\e[1;32m'     # 开始粗体
export LESS_TERMCAP_me=$'\e[0m'        # 结束模式
export LESS_TERMCAP_se=$'\e[0m'        # 结束突出显示
export LESS_TERMCAP_so=$'\e[01;33m'    # 开始突出显示
export LESS_TERMCAP_ue=$'\e[0m'        # 结束下划线
export LESS_TERMCAP_us=$'\e[1;4;31m'   # 开始下划线

# -------------------------------
# 历史记录
# -------------------------------
export HISTCONTROL=ignoreboth:erasedups  # 忽略重复和空格开头的命令

# -------------------------------
# FZF 默认选项（在 plugins.zsh 中设置）
# -------------------------------
# 这里可以添加额外的 FZF 选项

# -------------------------------
# 代理设置（如需要，取消注释）
# -------------------------------
# export HTTP_PROXY="http://127.0.0.1:7890"
# export HTTPS_PROXY="http://127.0.0.1:7890"
# export NO_PROXY="localhost,127.0.0.1"

# -------------------------------
# 其他自定义环境变量
# -------------------------------
# 在这里添加你的自定义环境变量

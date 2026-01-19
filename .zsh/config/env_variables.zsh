# 将图标目录添加到 XDG_ICON_DIRS 环境变量中
export XDG_ICON_DIRS=$XDG_ICON_DIRS:/usr/share/icons

# 添加 go 的环境变量
export PATH=$PATH:/usr/local/go/bin
# Add yarn to PATH
export PATH=$PATH:~/.yarn/bin


. "$HOME/.local/bin/env"

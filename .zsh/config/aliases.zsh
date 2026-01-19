# 列出文件的常用命令别名
alias ll='ls -l'            # 列出文件详细信息
alias la='ls -A'            # 列出所有文件，包括隐藏文件
alias l='ls -CF'            # 简化列出文件的命令

# 传统工具替换为现代工具
alias ls='lsd'               # 使用 lsd 替代 ls （更强大的文件列出工具）
alias grep='rg'              # 使用 ripgrep 替代 grep（更快的搜索工具）
alias df='duf'               # 使用 duf 替代 df（更强大的磁盘查看工具）
alias fd='fdfind'            # 使用 fd 替代 find（更强大的查找文件的工具）

# 编辑器设置
export EDITOR="nvim"         # 设置默认编辑器为 Vim


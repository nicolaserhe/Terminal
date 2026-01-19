# ========================================
# 自定义别名
# ========================================
# 提高效率的命令别名
# ========================================

# -------------------------------
# 基础 ls 别名
# -------------------------------
alias ls='lsd'                   # 使用 lsd 替代 ls
alias l='lsd -l'                 # 长格式
alias la='lsd -la'               # 显示所有文件（包括隐藏）
alias ll='lsd -lh'               # 人类可读的长格式
alias lt='lsd --tree'            # 树状显示
alias lta='lsd --tree -a'        # 树状显示所有文件

# -------------------------------
# 现代工具替换
# -------------------------------
alias grep='rg'                  # 使用 ripgrep 替代 grep
alias cat='batcat'               # 使用 bat 替代 cat（如果安装了）
alias df='duf'                   # 使用 duf 替代 df
alias find='fdfind'              # 使用 fd 替代 find
alias top='htop'                 # 使用 htop 替代 top（如果安装了）

# -------------------------------
# 目录导航
# -------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# 常用目录
alias home='cd ~'
alias root='cd /'
alias dl='cd ~/Downloads'
alias docs='cd ~/Documents'
alias desk='cd ~/Desktop'

# -------------------------------
# 安全操作
# -------------------------------
alias rm='rm -i'                 # 删除前确认
alias cp='cp -i'                 # 复制前确认
alias mv='mv -i'                 # 移动前确认
alias mkdir='mkdir -pv'          # 创建目录（递归+详细）

# -------------------------------
# 系统信息
# -------------------------------
alias sysinfo='fastfetch'        # 系统信息
alias cpuinfo='cpufetch'         # CPU 信息
alias meminfo='free -h'          # 内存信息
alias diskinfo='duf'             # 磁盘信息

# -------------------------------
# 网络
# -------------------------------
alias myip='curl ifconfig.me'    # 获取公网 IP
alias localip='ip addr show'     # 本地 IP
alias ports='netstat -tulanp'    # 显示所有端口

# -------------------------------
# 进程管理
# -------------------------------
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e' # 搜索进程
alias psme='ps aux | grep $USER' # 显示当前用户进程

# -------------------------------
# Git 快捷方式（如果使用 git）
# -------------------------------
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# -------------------------------
# 开发工具
# -------------------------------
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server' # 快速启动 HTTP 服务器

# -------------------------------
# 系统维护
# -------------------------------
alias update='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove -y && sudo apt autoclean'
alias install='sudo apt install'
alias remove='sudo apt remove'
alias search='apt search'

# -------------------------------
# 文件操作
# -------------------------------
alias zshconfig='nvim ~/.zshrc'  # 快速编辑 zsh 配置
alias reload='source ~/.zshrc'   # 重新加载配置
alias path='echo $PATH | tr ":" "\n"' # 显示 PATH

# -------------------------------
# 时间和日期
# -------------------------------
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias week='date +%V'
alias timer='echo "Timer started. Stop with Ctrl-C" && date && time cat'

# -------------------------------
# 压缩/解压（使用 extract 插件）
# -------------------------------
# x 命令由 extract 插件提供
alias untar='tar -xvf'
alias targz='tar -czvf'

# -------------------------------
# 快速查找
# -------------------------------
alias ff='fdfind --type f --hidden --exclude .git' # 查找文件
alias fd='fdfind --type d --hidden --exclude .git' # 查找目录

# -------------------------------
# 编辑器
# -------------------------------
export EDITOR='nvim'             # 默认编辑器
export VISUAL='nvim'             # 可视编辑器
alias vim='nvim'                 # 如果安装了 neovim
alias vi='nvim'

# -------------------------------
# 自定义函数
# -------------------------------

# 创建并进入目录
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# 快速备份文件
backup() {
    cp "$1" "$1.backup-$(date +%Y%m%d-%H%M%S)"
}

# 查找并删除
findrm() {
    find . -name "$1" -exec rm -i {} \;
}

# 显示目录大小
dirsize() {
    du -sh "$1" 2>/dev/null || du -sh .
}

# 解压到当前目录
extract_here() {
    x "$1"
}

# 显示帮助
help() {
    cat << 'EOF'
╔════════════════════════════════════════╗
║     自定义命令帮助                     ║
╚════════════════════════════════════════╝

【文件操作】
  ll / la / lt      - 列出文件
  mkcd <dir>        - 创建并进入目录
  backup <file>     - 备份文件
  x <file>          - 解压文件

【导航】
  z <dir>           - 智能跳转（zoxide）
  .. / ... / ....   - 快速返回上级目录

【系统】
  sysinfo           - 系统信息
  update            - 更新系统
  cleanup           - 清理系统

【Git】
  gs / ga / gc      - Git 快捷命令
  glog              - Git 日志树

【网络】
  myip              - 查看公网 IP
  ports             - 查看端口

【快捷键】
  ESC ESC           - 添加 sudo
  Ctrl+R            - 搜索历史
  Ctrl+T            - 搜索文件（fzf）

更多信息: https://github.com/your-repo
EOF
}

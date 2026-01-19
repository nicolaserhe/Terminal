# ========================================
# 默认 Zsh 配置
# ========================================
# 历史记录、补全、快捷键等基础设置
# ========================================

# -------------------------------
# 历史记录设置
# -------------------------------
HISTFILE=~/.zsh_history         # 历史记录文件路径
HISTSIZE=10000                  # 内存中保存的历史条数（增加到 10000）
SAVEHIST=10000                  # 写入文件的历史条数（增加到 10000）

setopt HIST_IGNORE_ALL_DUPS     # 忽略所有重复命令
setopt HIST_FIND_NO_DUPS        # 查找历史时忽略重复
setopt HIST_SAVE_NO_DUPS        # 保存时忽略重复
setopt HIST_REDUCE_BLANKS       # 删除多余空格
setopt SHARE_HISTORY            # 多终端共享历史记录
setopt APPEND_HISTORY           # 追加而非覆盖历史文件
setopt INC_APPEND_HISTORY       # 立即追加到历史文件
setopt HIST_VERIFY              # 执行历史命令前先显示

# -------------------------------
# 目录导航设置
# -------------------------------
setopt AUTO_CD                  # 输入目录名自动 cd
setopt AUTO_PUSHD               # cd 自动 pushd
setopt PUSHD_IGNORE_DUPS        # pushd 忽略重复目录
setopt PUSHD_SILENT             # 静默 pushd/popd

# -------------------------------
# 补全设置
# -------------------------------
setopt ALWAYS_TO_END            # 补全后光标移到末尾
setopt AUTO_MENU                # 连续按 Tab 循环补全
setopt COMPLETE_IN_WORD         # 在单词中间也能补全
setopt NO_MENU_COMPLETE         # 不自动插入第一个补全项

# 加载补全系统
autoload -Uz compinit

# 优化：仅每天检查一次补全文件
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
    compinit
else
    compinit -C
fi

# 补全样式
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # 大小写不敏感
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*' menu select # 高亮选中项

# 补全颜色
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 补全分组
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# kill 命令补全
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# 忽略某些文件
zstyle ':completion:*:*:*:*:*' ignored-patterns '*?.o' '*?.pyc'

# -------------------------------
# 键绑定
# -------------------------------
bindkey -e  # 使用 Emacs 风格键绑定

# 常用快捷键
bindkey '^[[A' history-search-backward  # 上箭头：向上搜索历史
bindkey '^[[B' history-search-forward   # 下箭头：向下搜索历史
bindkey '^[[H' beginning-of-line        # Home：行首
bindkey '^[[F' end-of-line              # End：行尾
bindkey '^[[3~' delete-char             # Delete：删除字符

# -------------------------------
# 其他选项
# -------------------------------
setopt NO_BEEP                  # 禁用蜂鸣声
setopt INTERACTIVE_COMMENTS     # 允许命令行注释
setopt LONG_LIST_JOBS           # 显示详细的后台任务信息
setopt NOTIFY                   # 立即报告后台任务状态

# -------------------------------
# 性能优化
# -------------------------------
# 禁用不需要的功能以提高性能
DISABLE_AUTO_UPDATE="true"
DISABLE_UPDATE_PROMPT="true"

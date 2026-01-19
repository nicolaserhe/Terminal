# -------------------------------
# 历史记录设置
# -------------------------------
setopt histignorealldups        # 忽略重复命令
setopt sharehistory             # 多终端共享历史记录
HISTSIZE=1000                   # 内存中保存的历史条数
SAVEHIST=1000                   # 写入文件的历史条数
HISTFILE=~/.zsh_history         # 历史记录文件路径

# -------------------------------
# 编辑器快捷键
# -------------------------------
bindkey -e                      # 强制使用 Emacs 风格键绑定，即使 $EDITOR 是 vi

# -------------------------------
# 自动补全设置
# -------------------------------
autoload -Uz compinit            # 初始化自动补全系统（必须先加载 compinit）
compinit                        

# 补全顺序：_expand 扩展别名/路径，_complete 普通补全，_correct 拼写纠正，_approximate 近似匹配
zstyle ':completion:*' completer _expand _complete _correct _approximate  
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'                     # 忽略大小写匹配，例如输入 "LS" 也能补全 "ls"
zstyle ':completion:*' use-compctl false                                # 禁用旧的 compctl 系统，只使用 compinit 补全
zstyle ':completion:*' verbose true                                     # 显示详细补全信息，包括候选来源和匹配类型

# -------------------------------
# kill 命令补全
# -------------------------------
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'  # 设置 kill 命令进程列表颜色，PID 显示为红色
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'   # 定义 kill 补全命令，显示当前用户的进程信息


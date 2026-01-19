# ========================================
# 插件配置
# ========================================
# 加载和配置 Zsh 插件
# ========================================

# -------------------------------
# Zsh 插件目录
# -------------------------------
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"

# -------------------------------
# zsh-autosuggestions
# -------------------------------
# 基于历史的自动建议
if [ -f "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    
    # 自定义建议颜色（灰色）
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'
    
    # 建议策略：优先使用历史记录，其次使用补全
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# -------------------------------
# zsh-syntax-highlighting
# -------------------------------
# 命令语法高亮（必须在最后加载）

# 先加载 Dracula 主题配置
if [ -f "$HOME/.zsh/config/plugins/zsh-syntax-highlighting.zsh" ]; then
    source "$HOME/.zsh/config/plugins/zsh-syntax-highlighting.zsh"
fi

# 再加载插件本身
if [ -f "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# -------------------------------
# extract 插件
# -------------------------------
# 万能解压命令：x <file>
if [ -f "$ZSH_PLUGINS_DIR/extract/extract.zsh" ]; then
    source "$ZSH_PLUGINS_DIR/extract/extract.zsh"
fi

# -------------------------------
# sudo 插件
# -------------------------------
# 双击 ESC 在命令前添加 sudo
if [ -f "$ZSH_PLUGINS_DIR/sudo/sudo.plugin.zsh" ]; then
    source "$ZSH_PLUGINS_DIR/sudo/sudo.plugin.zsh"
fi

# -------------------------------
# FZF 配置
# -------------------------------
# 模糊查找器配置（Dracula 主题）
if command -v fzf &> /dev/null; then
    # FZF 主题（Dracula）
    export FZF_DEFAULT_OPTS='
        --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
        --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
        --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
        --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
        --height 40%
        --layout=reverse
        --border
        --preview-window=right:60%
    '
    
    # FZF 默认命令（使用 fd）
    if command -v fdfind &> /dev/null; then
        export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fdfind --type d --hidden --follow --exclude .git'
    fi
    
    # FZF 预览命令（使用 bat 如果可用）
    if command -v batcat &> /dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'batcat --color=always --line-range :500 {}'"
    fi
    
    # 启用 FZF 键绑定
    if [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
        source /usr/share/doc/fzf/examples/key-bindings.zsh
    fi
    
    # 启用 FZF 补全
    if [ -f /usr/share/doc/fzf/examples/completion.zsh ]; then
        source /usr/share/doc/fzf/examples/completion.zsh
    fi
fi

# -------------------------------
# Zoxide 初始化
# -------------------------------
# 智能 cd 替代品
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# -------------------------------
# 其他工具初始化
# -------------------------------

# direnv（如果安装了）
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# nvm（Node Version Manager，如果安装了）
if [ -d "$HOME/.nvm" ]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# pyenv（Python Version Manager，如果安装了）
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

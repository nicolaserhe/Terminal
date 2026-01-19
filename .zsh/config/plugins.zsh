# 加载 Zsh 插件
# 自动补全建议
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# 命令高亮
source ~/.zsh/config/plugins/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


# 配置 fzf 主题
export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

# Init zoxide (smart cd replacement)
eval "$(zoxide init zsh)"

# extract 插件
source ~/.zsh/plugins/extract/extract.zsh

# sudo 插件
source ~/.zsh/plugins/sudo/sudo.plugin.zsh


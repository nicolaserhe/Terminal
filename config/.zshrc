# 加载默认~/.zshrc文件
source ~/.zsh/config/default.zsh

# 加载自定义别名
source ~/.zsh/config/aliases.zsh

# 加载插件配置
source ~/.zsh/config/plugins.zsh

# 加载环境变量配置
source ~/.zsh/config/env_variables.zsh


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


[[ -s "/home/gcy/.gvm/scripts/gvm" ]] && source "/home/gcy/.gvm/scripts/gvm"

eval "$(starship init zsh)"

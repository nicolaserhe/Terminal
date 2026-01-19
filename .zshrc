# 加载默认~/.zshrc文件
source ~/.zsh/config/default.zsh

# 加载自定义别名
source ~/.zsh/config/aliases.zsh

# 加载插件配置
source ~/.zsh/config/plugins.zsh

# 加载环境变量配置
source ~/.zsh/config/env_variables.zsh

# 初始化 Starship 提示符
eval "$(starship init zsh)"

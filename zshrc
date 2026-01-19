# ========================================
# Zsh Configuration
# ========================================
# 现代化的 Zsh 配置
# ========================================

# 加载默认配置（历史记录、补全等）
source ~/.zsh/config/default.zsh

# 加载自定义别名
source ~/.zsh/config/aliases.zsh

# 加载环境变量配置
source ~/.zsh/config/env_variables.zsh

# 加载插件配置
source ~/.zsh/config/plugins.zsh

# 初始化 Starship 提示符
eval "$(starship init zsh)"

# 欢迎信息（可选，取消注释以启用）
# echo "Welcome to your modern terminal! 🚀"
# echo "Type 'help' for custom commands"

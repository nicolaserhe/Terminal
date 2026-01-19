# 🚀 Modern Terminal Configuration

一个现代化、美观且高效的 Zsh 终端配置方案，包含精心挑选的插件、主题和工具。

## ✨ 特性

### 🎨 美观的界面
- **Starship** - 快速、可定制的跨 Shell 提示符
- **Dracula 主题** - 为语法高亮定制的配色方案
- **现代化工具** - 使用 `lsd`、`bat`、`ripgrep` 等替代传统命令

### ⚡ 高效的工作流
- **智能补全** - 自动建议和语法高亮
- **模糊搜索** - 使用 `fzf` 快速查找文件和历史命令
- **快速导航** - `zoxide` 智能目录跳转
- **一键解压** - 支持所有常见压缩格式
- **快捷键** - `ESC ESC` 快速添加 sudo

### 🛠️ 包含的工具

| 工具 | 替代 | 描述 |
|------|------|------|
| `lsd` | `ls` | 现代化的文件列表工具 |
| `ripgrep (rg)` | `grep` | 超快的文本搜索 |
| `duf` | `df` | 友好的磁盘使用显示 |
| `fd` | `find` | 简单快速的文件查找 |
| `zoxide` | `cd` | 智能目录跳转 |
| `fzf` | - | 命令行模糊查找器 |
| `bat` | `cat` | 带语法高亮的文件查看 |
| `tldr` | `man` | 简化的命令帮助 |
| `fastfetch` | `neofetch` | 快速系统信息显示 |

### 🔌 Zsh 插件
- **zsh-autosuggestions** - 基于历史的命令建议
- **zsh-syntax-highlighting** - 实时语法高亮
- **extract** - 万能解压命令 `x <file>`
- **sudo** - 双击 ESC 添加 sudo

## 📦 安装

### 前置要求
- Ubuntu/Debian 系统
- 需要 sudo 权限

### 快速安装

```bash
# 克隆项目
git clone https://github.com/nicolaserhe/Terminal ~/terminal-config
cd ~/terminal-config

# 运行安装脚本
chmod +x install.sh
./install.sh
source ~/.zshrc
```

## 🎯 使用

### 常用别名

```bash
# 文件操作
ll              # 详细列表
la              # 显示隐藏文件
l               # 紧凑列表

# 现代工具别名
ls → lsd        # 更好的 ls
grep → rg       # 更快的 grep
df → duf        # 更友好的 df
find → fd       # 更简单的 find

# 解压任意格式
x <file>        # 自动识别格式并解压
x -r <file>     # 解压后删除源文件
```

### 快捷键

| 快捷键 | 功能 |
|--------|------|
| `ESC ESC` | 在命令前添加 sudo |
| `Ctrl + R` | 模糊搜索历史命令 (fzf) |
| `Ctrl + T` | 模糊搜索文件 (fzf) |
| `Alt + C` | 模糊搜索并切换目录 (fzf) |

### Zoxide 使用

```bash
# 智能跳转（会记住你访问过的目录）
z <部分目录名>

# 示例
z downloads     # 跳转到 ~/Downloads
z proj          # 跳转到最常访问的包含 "proj" 的目录
```

## 🔧 自定义配置

### 目录结构

```
~/.zsh/
├── config/
│   ├── default.zsh          # 历史记录、补全等基础配置
│   ├── aliases.zsh          # 命令别名
│   ├── plugins.zsh          # 插件加载
└── └── env_variables.zsh    # 环境变量
```

### 修改配置

1. **添加自定义别名**
   编辑 `~/.zsh/config/aliases.zsh`

2. **修改环境变量**
   编辑 `~/.zsh/config/env_variables.zsh`

3. **调整 Starship 提示符**
   编辑 `~/.config/starship.toml`

4. **更改 FZF 主题**
   编辑 `~/.zsh/config/plugins.zsh` 中的 `FZF_DEFAULT_OPTS`

## 🐛 故障排除

### Zsh 不是默认 Shell
```bash
chsh -s $(which zsh)
# 然后重新登录
```

### Starship 未显示
```bash
# 检查 Starship 是否安装
which starship

# 如果未安装，手动安装
curl -sS https://starship.rs/install.sh | sh
```

### 字体显示问题
安装 Nerd Fonts 以获得最佳体验：
```bash
# 推荐字体
# - Maple Font Nerd Font
```

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可证

MIT License

## 🙏 致谢

- [Dracula Theme](https://draculatheme.com/) - 配色方案
- [Starship](https://starship.rs/) - 终端提示符
- [Zsh](https://www.zsh.org/) - 强大的 Shell

---

**享受你的现代化终端体验！** 🎉

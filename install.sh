#!/usr/bin/env bash

# ============================================================================
# Modular Installation Script Example
# ============================================================================
# 展示如何使用模块化设计组织安装脚本
# ============================================================================

set -euo pipefail

# ============================================================================
# 脚本路径
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ============================================================================
# 加载通用库
# ============================================================================

# shellcheck source=lib_common.sh
source "${SCRIPT_DIR}/lib_common.sh"

# ============================================================================
# 加载模块 (示例)
# ============================================================================

# 如果你将安装逻辑拆分到多个文件,可以这样加载:
# source "${SCRIPT_DIR}/modules/system.sh"
# source "${SCRIPT_DIR}/modules/fonts.sh"
# source "${SCRIPT_DIR}/modules/dev_tools.sh"
# source "${SCRIPT_DIR}/modules/terminal.sh"
# source "${SCRIPT_DIR}/modules/zsh.sh"

# ============================================================================
# 配置变量
# ============================================================================

readonly HOME_DIR="${HOME}"
readonly ZSH_DIR="${HOME_DIR}/.zsh"
readonly CONFIG_DIR="${HOME_DIR}/.config"

# 版本配置 (可以从配置文件加载)
readonly GO_VERSION="1.22.5"
readonly RUST_VERSION="stable"
readonly NODE_VERSION="lts"
readonly LSD_VERSION="1.1.5"
readonly MAPLE_FONT_VERSION="NL-NF-CN"

# ============================================================================
# 安装组件定义
# ============================================================================

declare -A COMPONENTS=(
    [system]="系统工具和依赖"
    [fonts]="Maple Mono 字体"
    [dev_tools]="开发工具链 (Rust/Go/Node.js)"
    [terminal]="终端工具 (Starship/Zoxide/Neovim)"
    [zsh]="Zsh 配置和插件"
    [extras]="额外工具 (Kanata/输入法)"
)

# ============================================================================
# 系统模块
# ============================================================================

install_system_packages() {
    log_info "=== 安装系统包 ==="
    
    print_step "更新系统包列表..."
    run_silent sudo apt update
    print_success "系统包列表已更新"
    
    print_step "安装基础工具..."
    local base_packages=(
        curl wget build-essential cmake pkg-config
        python3 libfreetype6-dev libfontconfig1-dev
        libxcb-xfixes0-dev libxkbcommon-dev
    )
    run_silent sudo apt install -y "${base_packages[@]}"
    print_success "基础工具安装完成"
    
    print_step "安装命令行工具..."
    local cli_packages=(
        zsh alacritty fzf ripgrep duf fd-find tldr tree
    )
    run_silent sudo apt install -y "${cli_packages[@]}"
    print_success "命令行工具安装完成"
}

install_lsd() {
    if command_exists lsd; then
        print_warning "lsd 已安装,跳过"
        return 0
    fi
    
    print_step "安装 lsd..."
    local download_url="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/lsd_${LSD_VERSION}_amd64.deb"
    local deb_file="/tmp/lsd.deb"
    
    download_file "$download_url" "$deb_file"
    run_silent sudo dpkg -i "$deb_file" || run_silent sudo apt-get install -f -y
    safe_remove "$deb_file"
    
    print_success "lsd 安装完成"
}

# ============================================================================
# 字体模块
# ============================================================================

install_fonts() {
    log_info "=== 安装字体 ==="
    
    print_step "安装 Maple Mono ${MAPLE_FONT_VERSION}..."
    
    local font_dir="${HOME}/.local/share/fonts"
    local temp_dir="/tmp/maple_mono_install"
    
    ensure_dir "$font_dir"
    safe_remove "$temp_dir"
    mkdir -p "$temp_dir"
    
    local download_url="https://github.com/subframe7536/maple-font/releases/latest/download/MapleMono${MAPLE_FONT_VERSION}.zip"
    local zip_file="${temp_dir}/maple.zip"
    
    download_file "$download_url" "$zip_file"
    
    print_step "解压字体文件..."
    unzip -q "$zip_file" -d "${temp_dir}/maple"
    
    find "${temp_dir}/maple" -type f \( -name "*.ttf" -o -name "*.otf" \) \
        -exec cp {} "$font_dir/" \;
    
    print_success "Maple Mono ${MAPLE_FONT_VERSION} 安装完成"
    
    print_step "刷新字体缓存..."
    run_silent fc-cache -fv
    print_success "字体缓存完成"
    
    safe_remove "$temp_dir"
}

# ============================================================================
# 开发工具链模块
# ============================================================================

install_dev_tools() {
    log_info "=== 安装开发工具链 ==="
    
    # Rust
    if command_exists cargo; then
        print_warning "Rust 已安装,跳过"
    else
        print_step "安装 Rust ${RUST_VERSION}..."
        run_silent curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # shellcheck disable=SC1091
        source "${HOME}/.cargo/env" 2>/dev/null || true
        print_success "Rust 安装完成"
    fi
    
    # Go
    if command_exists go; then
        print_warning "Go 已安装,跳过"
    else
        print_step "安装 Go ${GO_VERSION}..."
        local download_url="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
        local tar_file="/tmp/go.tar.gz"
        
        download_file "$download_url" "$tar_file"
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf "$tar_file"
        safe_remove "$tar_file"
        
        export PATH="/usr/local/go/bin:${HOME}/go/bin:${PATH}"
        print_success "Go 安装完成"
    fi
    
    # Node.js
    if command_exists node; then
        print_warning "Node.js 已安装,跳过"
    else
        print_step "安装 Node.js ${NODE_VERSION}..."
        local nvm_dir="${HOME}/.nvm"
        export NVM_DIR="$nvm_dir"
        
        if [[ ! -d "$nvm_dir" ]]; then
            run_silent curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        fi
        
        # shellcheck disable=SC1091
        [[ -s "$nvm_dir/nvm.sh" ]] && source "$nvm_dir/nvm.sh"
        
        run_silent nvm install --lts
        run_silent nvm use --lts
        
        print_success "Node.js (LTS) 安装完成"
    fi
}

# ============================================================================
# 终端工具模块
# ============================================================================

install_terminal_tools() {
    log_info "=== 安装终端工具 ==="

    # Alacritty 配置
    ensure_dir "${CONFIG_DIR}/alacritty"
    cp -r "${SCRIPT_DIR}/alacritty/"* "${CONFIG_DIR}/alacritty/"
    
    # Starship
    if command_exists starship; then
        print_warning "Starship 已安装,跳过"
    else
        print_step "安装 Starship..."
        run_silent curl -sS https://starship.rs/install.sh | sh -s -- -y
        print_success "Starship 安装完成"
    fi
    
    ensure_dir "$CONFIG_DIR"
    cp "${SCRIPT_DIR}/starship.toml" "$CONFIG_DIR/starship.toml"
    
    # Zoxide
    if command_exists zoxide; then
        print_warning "Zoxide 已安装,跳过"
    else
        print_step "安装 Zoxide..."
        run_silent curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        print_success "Zoxide 安装完成"
    fi
    
    # Neovim
    if command_exists nvim; then
        print_warning "Neovim 已安装,跳过"
    else
        print_step "安装 Neovim..."
        local nvim_url="https://github.com/neovim/neovim/releases/download/latest/nvim-linux-x86_64.tar.gz"
        local tar_file="/tmp/nvim.tar.gz"
        
        download_file "$nvim_url" "$tar_file"
        sudo mkdir -p /opt/nvim
        sudo tar -xzf "$tar_file" -C /opt/nvim --strip-components=1
        sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
        safe_remove "$tar_file"
        
        print_success "Neovim 安装完成"
    fi
    
    if [[ ! -d "$CONFIG_DIR/nvim" ]]; then
        run_silent git clone https://github.com/nicolaserhe/nvim "$CONFIG_DIR/nvim"
    fi
}

# ============================================================================
# Zsh 配置模块
# ============================================================================

install_zsh_config() {
    log_info "=== 配置 Zsh ==="
    
    print_step "创建配置目录..."
    ensure_dir "$ZSH_DIR/config"
    ensure_dir "$ZSH_DIR/plugins"
    ensure_dir "$ZSH_DIR/config/plugins"
    
    print_step "复制配置文件..."
    cp "${SCRIPT_DIR}/zshrc" "${HOME_DIR}/.zshrc"
    cp -r "${SCRIPT_DIR}/zsh/config/"* "${ZSH_DIR}/config/"
    print_success "配置文件已复制"
    
    print_step "安装 Zsh 插件..."
    local plugins_dir="${ZSH_DIR}/plugins"
    
    # zsh-autosuggestions
    if [[ ! -d "${plugins_dir}/zsh-autosuggestions" ]]; then
        run_silent git clone https://github.com/zsh-users/zsh-autosuggestions \
            "${plugins_dir}/zsh-autosuggestions"
        print_success "  zsh-autosuggestions 安装完成"
    fi
    
    # zsh-syntax-highlighting
    if [[ ! -d "${plugins_dir}/zsh-syntax-highlighting" ]]; then
        run_silent git clone https://github.com/zsh-users/zsh-syntax-highlighting \
            "${plugins_dir}/zsh-syntax-highlighting"
        print_success "  zsh-syntax-highlighting 安装完成"
    fi
    
    # 本地插件
    cp -r "${SCRIPT_DIR}/zsh/plugins/extract" "${plugins_dir}/"
    cp -r "${SCRIPT_DIR}/zsh/plugins/sudo" "${plugins_dir}/"
    print_success "  本地插件安装完成"
    
    # 设置默认 shell
    if [[ "$(basename "$SHELL")" != "zsh" ]]; then
        print_step "设置 Zsh 为默认 Shell..."
        chsh -s "$(which zsh)"
        print_success "Zsh 已设置为默认 Shell (重新登录后生效)"
    fi
}

# ============================================================================
# 额外工具模块
# ============================================================================

install_extras() {
    log_info "=== 安装额外工具 ==="
    
    # Kanata
    if command_exists kanata; then
        print_warning "Kanata 已安装,跳过"
    else
        print_step "安装 Kanata..."
        local download_url="https://github.com/jtroo/kanata/releases/download/latest/linux-binaries-x64.zip"
        local zip_file="/tmp/kanata.zip"
        local extract_dir="/tmp/kanata"
        
        download_file "$download_url" "$zip_file"
        unzip -q "$zip_file" -d "$extract_dir"
        
        sudo cp "${extract_dir}/kanata_linux_x64" /usr/local/bin/kanata
        sudo chmod +x /usr/local/bin/kanata
        
        safe_remove "$zip_file"
        safe_remove "$extract_dir"
        
        print_success "Kanata 安装完成"
    fi
    
    ensure_dir "${CONFIG_DIR}/kanata"
    cp -r "${SCRIPT_DIR}/kanata/"* "${CONFIG_DIR}/kanata/"
    
    # 输入法 (可选)
    if ask_yes_no "是否安装输入法 (ibus-rime)?" "n"; then
        print_step "安装输入法..."
        run_silent sudo apt install -y ibus-rime
        
        ensure_dir "${CONFIG_DIR}/ibus/rime"
        if [[ ! -d "${CONFIG_DIR}/ibus/rime/.git" ]]; then
            run_silent git clone --depth 1 https://github.com/iDvel/rime-ice \
                "${CONFIG_DIR}/ibus/rime"
        fi
        
        print_success "输入法安装完成"
        
        if command_exists ibus; then
            ibus restart 2>/dev/null || {
                killall ibus-daemon 2>/dev/null || true
                ibus-daemon -drx &>/dev/null &
            }
        fi
        
        echo ""
        echo "👉 请手动设置："
        echo "   Settings → Region & Language → Input Sources"
        echo "   添加：Chinese (Rime)"
    fi
}

# ============================================================================
# 交互式菜单
# ============================================================================

show_menu() {
    echo ""
    echo "请选择要安装的组件："
    echo ""
    
    local i=1
    for key in "${!COMPONENTS[@]}"; do
        echo "  $i) ${COMPONENTS[$key]}"
        ((i++))
    done
    
    echo "  $i) 全部安装"
    echo "  0) 退出"
    echo ""
}

interactive_install() {
    while true; do
        show_menu
        read -r -p "请输入选项 [0-6]: " choice
        
        case "$choice" in
            1) install_system_packages && install_lsd ;;
            2) install_fonts ;;
            3) install_dev_tools ;;
            4) install_terminal_tools ;;
            5) install_zsh_config ;;
            6) install_extras ;;
            7) install_all ;;
            0) break ;;
            *) print_error "无效选项" ;;
        esac
        
        echo ""
        read -r -p "按回车键继续..."
    done
}

# ============================================================================
# 完整安装
# ============================================================================

install_all() {
    install_system_packages
    install_lsd
    echo ""
    
    install_fonts
    echo ""
    
    install_dev_tools
    echo ""
    
    install_terminal_tools
    echo ""
    
    install_zsh_config
    echo ""
    
    install_extras
}

# ============================================================================
# 显示完成信息
# ============================================================================

show_completion() {
    echo ""
    echo -e "${COLOR_GREEN}╔════════════════════════════════════════════════════╗${COLOR_RESET}"
    echo -e "${COLOR_GREEN}║            安装完成！                              ║${COLOR_RESET}"
    echo -e "${COLOR_GREEN}╚════════════════════════════════════════════════════╝${COLOR_RESET}"
    echo ""
    echo -e "${COLOR_BLUE}下一步操作：${COLOR_RESET}"
    echo -e "  1. 重新打开终端,或运行: ${COLOR_YELLOW}source ~/.zshrc${COLOR_RESET}"
    echo -e "  2. 如果 Shell 未切换,运行: ${COLOR_YELLOW}exec zsh${COLOR_RESET}"
    echo ""
    echo -e "${COLOR_BLUE}日志文件：${COLOR_RESET}${LOG_FILE}"
    echo ""
}

# ============================================================================
# 主函数
# ============================================================================

main() {
    # 初始化日志
    init_log "/tmp" "terminal-setup"
    
    print_header
    
    # 前置检查
    check_not_root
    check_os || exit 1
    
    # 检查网络 (仅警告,不退出)
    check_network || true
    
    # 解析命令行参数
    if [[ $# -eq 0 ]]; then
        # 无参数,显示交互式菜单
        interactive_install
    else
        # 有参数,执行对应组件安装
        case "$1" in
            --all|-a)
                install_all
                ;;
            --system|-s)
                install_system_packages
                install_lsd
                ;;
            --fonts|-f)
                install_fonts
                ;;
            --dev|-d)
                install_dev_tools
                ;;
            --terminal|-t)
                install_terminal_tools
                ;;
            --zsh|-z)
                install_zsh_config
                ;;
            --extras|-e)
                install_extras
                ;;
            --help|-h)
                echo "用法: $0 [选项]"
                echo ""
                echo "选项:"
                echo "  -a, --all        安装所有组件"
                echo "  -s, --system     仅安装系统包"
                echo "  -f, --fonts      仅安装字体"
                echo "  -d, --dev        仅安装开发工具"
                echo "  -t, --terminal   仅安装终端工具"
                echo "  -z, --zsh        仅配置 Zsh"
                echo "  -e, --extras     仅安装额外工具"
                echo "  -h, --help       显示帮助信息"
                echo ""
                echo "无参数时显示交互式菜单"
                exit 0
                ;;
            *)
                print_error "未知选项: $1"
                echo "使用 --help 查看帮助"
                exit 1
                ;;
        esac
    fi
    
    show_completion
}

# 运行主函数
main "$@"

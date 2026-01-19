#!/usr/bin/env bash

# ============================================================================
# Common Library Functions
# ============================================================================
# 通用工具函数库 - 可以被其他脚本 source 使用
# ============================================================================

# 防止重复加载
[[ -n "${_COMMON_LIB_LOADED:-}" ]] && return 0
readonly _COMMON_LIB_LOADED=1

# ============================================================================
# 颜色常量
# ============================================================================

readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[1;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_MAGENTA='\033[0;35m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_RESET='\033[0m'

# ============================================================================
# 日志级别
# ============================================================================

readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3

# 默认日志级别
: "${LOG_LEVEL:=$LOG_LEVEL_INFO}"

# ============================================================================
# 日志函数
# ============================================================================

# 初始化日志文件
init_log() {
    local log_dir="${1:-/tmp}"
    local log_name="${2:-terminal-setup}"
    
    readonly LOG_FILE="${log_dir}/${log_name}-$(date +%Y%m%d-%H%M%S).log"
    
    # 创建日志目录
    mkdir -p "$log_dir"
    
    # 写入日志头
    {
        echo "========================================"
        echo "Installation Log"
        echo "Started: $(date)"
        echo "User: $USER"
        echo "System: $(uname -a)"
        echo "========================================"
        echo ""
    } > "$LOG_FILE"
    
    log_info "Log file: $LOG_FILE"
}

# 通用日志函数
_log() {
    local level="$1"
    local level_num="$2"
    local color="$3"
    shift 3
    
    # 检查日志级别
    if [[ $level_num -lt $LOG_LEVEL ]]; then
        return 0
    fi
    
    local timestamp
    timestamp="$(date +'%Y-%m-%d %H:%M:%S')"
    
    local message="$*"
    
    # 输出到终端 (带颜色)
    echo -e "${color}[${level}]${COLOR_RESET} $message"
    
    # 写入日志文件 (无颜色)
    if [[ -n "${LOG_FILE:-}" ]]; then
        echo "[${timestamp}] [${level}] $message" >> "$LOG_FILE"
    fi
}

log_debug() {
    _log "DEBUG" "$LOG_LEVEL_DEBUG" "$COLOR_CYAN" "$@"
}

log_info() {
    _log "INFO" "$LOG_LEVEL_INFO" "$COLOR_BLUE" "$@"
}

log_success() {
    _log "SUCCESS" "$LOG_LEVEL_INFO" "$COLOR_GREEN" "$@"
}

log_warn() {
    _log "WARN" "$LOG_LEVEL_WARN" "$COLOR_YELLOW" "$@"
}

log_error() {
    _log "ERROR" "$LOG_LEVEL_ERROR" "$COLOR_RED" "$@" >&2
}

# ============================================================================
# 打印函数 (保持原有风格)
# ============================================================================

print_header() {
    echo -e "${COLOR_BLUE}╔════════════════════════════════════════╗${COLOR_RESET}"
    echo -e "${COLOR_BLUE}║   Modern Terminal Configuration        ║${COLOR_RESET}"
    echo -e "${COLOR_BLUE}╚════════════════════════════════════════╝${COLOR_RESET}"
    echo ""
}

print_step() {
    echo -e "${COLOR_GREEN}▶${COLOR_RESET} $1"
    log_info "STEP: $1"
}

print_success() {
    echo -e "${COLOR_GREEN}✓${COLOR_RESET} $1"
    log_success "$1"
}

print_warning() {
    echo -e "${COLOR_YELLOW}⚠${COLOR_RESET} $1"
    log_warn "$1"
}

print_error() {
    echo -e "${COLOR_RED}✗${COLOR_RESET} $1" >&2
    log_error "$1"
}

# ============================================================================
# 系统检查函数
# ============================================================================

# 检查命令是否存在
command_exists() {
    command -v "$1" &>/dev/null
}

# 检查是否为 root 用户
is_root() {
    [[ "${EUID}" -eq 0 ]]
}

# 检查不是 root 用户 (用于安装脚本)
check_not_root() {
    if is_root; then
        print_error "请不要以 root 用户运行此脚本"
        exit 1
    fi
}

# 检查操作系统
check_os() {
    if [[ ! -f /etc/os-release ]]; then
        print_error "无法识别操作系统"
        return 1
    fi
    
    # shellcheck disable=SC1091
    source /etc/os-release
    
    case "$ID" in
        ubuntu|debian)
            log_info "检测到 $NAME $VERSION_ID"
            return 0
            ;;
        *)
            print_error "不支持的操作系统: $NAME"
            return 1
            ;;
    esac
}

# 检查网络连接
check_network() {
    local test_urls=(
        "https://github.com"
        "https://google.com"
    )
    
    for url in "${test_urls[@]}"; do
        if curl -s --head --max-time 5 "$url" >/dev/null 2>&1; then
            log_debug "网络连接正常: $url"
            return 0
        fi
    done
    
    print_warning "网络连接可能存在问题"
    return 1
}

# ============================================================================
# 文件和目录操作
# ============================================================================

# 确保目录存在
ensure_dir() {
    local dir="$1"
    
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_debug "Created directory: $dir"
    fi
}

# 安全删除文件
safe_remove() {
    local path="$1"
    
    if [[ -e "$path" ]]; then
        rm -rf "$path"
        log_debug "Removed: $path"
    fi
}

# 备份文件
backup_file() {
    local file="$1"
    local backup_suffix="${2:-.backup-$(date +%Y%m%d-%H%M%S)}"
    
    if [[ -f "$file" ]]; then
        local backup_file="${file}${backup_suffix}"
        cp "$file" "$backup_file"
        log_info "Backed up: $file -> $backup_file"
        echo "$backup_file"
    fi
}

# 创建符号链接
create_symlink() {
    local source="$1"
    local target="$2"
    local force="${3:-false}"
    
    if [[ ! -e "$source" ]]; then
        print_error "Source does not exist: $source"
        return 1
    fi
    
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ "$force" == "true" ]]; then
            rm -f "$target"
        else
            print_warning "Target already exists: $target"
            return 1
        fi
    fi
    
    ln -s "$source" "$target"
    log_info "Created symlink: $target -> $source"
}

# ============================================================================
# 命令执行函数
# ============================================================================

# 静默运行命令
run_silent() {
    local cmd=("$@")
    
    log_debug "Running: ${cmd[*]}"
    
    if "${cmd[@]}" &>>"${LOG_FILE:-/dev/null}"; then
        log_debug "Command succeeded: ${cmd[*]}"
        return 0
    else
        local exit_code=$?
        log_error "Command failed (exit $exit_code): ${cmd[*]}"
        return $exit_code
    fi
}

# 运行命令并显示输出
run_verbose() {
    local cmd=("$@")
    
    log_info "Running: ${cmd[*]}"
    
    if "${cmd[@]}"; then
        log_success "Command succeeded: ${cmd[*]}"
        return 0
    else
        local exit_code=$?
        log_error "Command failed (exit $exit_code): ${cmd[*]}"
        return $exit_code
    fi
}

# 带重试的命令执行
run_with_retry() {
    local max_attempts="${1:-3}"
    local delay="${2:-2}"
    shift 2
    local cmd=("$@")
    
    local attempt=1
    while [[ $attempt -le $max_attempts ]]; do
        log_info "Attempt $attempt/$max_attempts: ${cmd[*]}"
        
        if "${cmd[@]}"; then
            log_success "Command succeeded on attempt $attempt"
            return 0
        fi
        
        if [[ $attempt -lt $max_attempts ]]; then
            log_warn "Command failed, retrying in ${delay}s..."
            sleep "$delay"
        fi
        
        ((attempt++))
    done
    
    log_error "Command failed after $max_attempts attempts: ${cmd[*]}"
    return 1
}

# ============================================================================
# 下载函数
# ============================================================================

# 下载文件
download_file() {
    local url="$1"
    local output="$2"
    local max_attempts="${3:-3}"
    
    log_info "Downloading: $url"
    
    if run_with_retry "$max_attempts" 2 wget -q "$url" -O "$output"; then
        log_success "Downloaded: $output"
        return 0
    else
        print_error "Failed to download: $url"
        return 1
    fi
}

# ============================================================================
# 用户交互函数
# ============================================================================

# 询问 Yes/No 问题
ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    
    local prompt
    if [[ "$default" == "y" ]] || [[ "$default" == "Y" ]]; then
        prompt="[Y/n]"
    else
        prompt="[y/N]"
    fi
    
    read -r -p "$question $prompt " response
    
    # 如果用户直接回车,使用默认值
    response="${response:-$default}"
    
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 显示进度条
show_progress() {
    local current="$1"
    local total="$2"
    local width=50
    
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))
    
    printf "\r[%${filled}s%${empty}s] %d%%" \
        "$(printf '#%.0s' $(seq 1 $filled))" \
        "" \
        "$percentage"
    
    if [[ $current -eq $total ]]; then
        echo ""
    fi
}

# ============================================================================
# 版本比较函数
# ============================================================================

# 比较版本号
version_gt() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"
}

version_ge() {
    test "$(printf '%s\n' "$@" | sort -V | head -n 1)" == "$2" || test "$1" == "$2"
}

# ============================================================================
# 清理函数
# ============================================================================

# 注册清理函数
_cleanup_functions=()

register_cleanup() {
    _cleanup_functions+=("$1")
}

# 执行所有清理函数
run_cleanup() {
    log_info "Running cleanup functions..."
    
    for cleanup_fn in "${_cleanup_functions[@]}"; do
        if declare -f "$cleanup_fn" >/dev/null; then
            log_debug "Running cleanup: $cleanup_fn"
            "$cleanup_fn" || log_warn "Cleanup failed: $cleanup_fn"
        fi
    done
}

# 设置 trap 以在退出时执行清理
trap run_cleanup EXIT INT TERM

# ============================================================================
# 导出函数 (可选)
# ============================================================================

# 如果需要在子 shell 中使用这些函数,可以导出
# export -f command_exists
# export -f log_info
# ... 等等

log_debug "Common library loaded"

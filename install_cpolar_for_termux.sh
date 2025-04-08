#!/data/data/com.termux/files/usr/bin/bash
# cpolar安装脚本 - Ver.0.5

# 定义颜色变量
GREEN='\e[1;32m'   # 绿色
BLUE='\e[1;34m'    # 蓝色
RED='\e[1;31m'     # 红色
YELLOW='\e[1;33m'  # 黄色
RESET='\e[0m'      # 重置

# 定义信息类型变量
SUCCESS="${GREEN}[+]${RESET}"  # 成功信息
INFO="${BLUE}[*]${RESET}"      # 普通信息
WARNING="${YELLOW}[!]${RESET}" # 警告信息
ERROR="${RED}[-]${RESET}"      # 错误信息
FATAL="${RED}[×]${RESET}"      # 失败信息

# 欢迎信息函数
welcome_message() {
    echo -e "${SUCCESS} 欢迎使用cpolar安装脚本"
    sleep 1
}

# 检查cpolar是否已安装
check_installed() {
    # 捕获 pkg list-installed 的输出
    output=$(pkg list-installed cpolar 2>&1)

    # 检查输出是否包含 "cpolar"
    if echo "$output" | grep -q "cpolar"; then
        echo -e "${INFO} 检测到cpolar已安装，将更新cpolar"
        is_installed=true
    else
        is_installed=false
    fi
}

# 检查APT源是否已配置
check_apt_source() {
    if [ -f "$PREFIX/etc/apt/sources.list.d/cpolar.list" ]; then
        echo -e "${INFO} 检测到cpolar的APT源已配置，跳过配置步骤"
        apt_source_configured=true
    else
        apt_source_configured=false
    fi
}

# 配置APT源
configure_apt_source() {
    mkdir -p "$PREFIX/etc/apt/sources.list.d"
    echo -e "${INFO} 配置cpolar的APT源"
    echo "deb [trusted=yes] http://termux.cpolar.com termux extras" > "$PREFIX/etc/apt/sources.list.d/cpolar.list"
    
    if [ $? -ne 0 ]; then
        echo -e "${ERROR} 配置APT源失败，请检查网络连接或权限"
        exit 1
    fi
    
    echo -e "${SUCCESS} APT源配置完成"
}

# 更新包列表
update_package_list() {
    echo -e "${INFO} 更新软件包列表"
    pkg update -y
    
    if [ $? -ne 0 ]; then
        echo -e "${ERROR} 更新软件包列表失败，请检查网络连接或权限"
        exit 1
    fi
}

# 安装或更新cpolar和termux-services
install_or_update_cpolar() {
    if [ "$is_installed" = true ]; then
        echo -e "${INFO} 更新cpolar和termux-services"
        pkg upgrade cpolar termux-services -y
        
        if [ $? -ne 0 ]; then
            echo -e "${ERROR} 更新cpolar和termux-services失败"
            exit 1
        fi
        
        echo -e "${SUCCESS} 更新完成！"
    else
        echo -e "${INFO} 安装cpolar和termux-services"
        pkg install cpolar termux-services -y
        
        if [ $? -ne 0 ]; then
            echo -e "${ERROR} 安装cpolar和termux-services失败"
            exit 1
        fi
        
        echo -e "${SUCCESS} 安装完成！"
    fi
}

# 安装完成提示
completion_message() {
    echo -e "${INFO} 现在需要重新启动Termux，可以执行 'exit' 退出。"
    echo -e "${INFO} 重启Termux完成后，可以使用 'sv up cpolar' 启动cpolar。"
    echo -e "${INFO} 也可以使用 'sv-enable cpolar' 开启cpolar自启动。"
    echo -e "${INFO} 项目地址：github.com/wanfeng233/termux-cpolar-installer"
}

# Ctrl+C中断处理
handle_interrupt() {
    echo -e "\n${FATAL} 安装过程被用户中断，退出安装脚本"
    exit 1
}

# 主函数
main() {
    # 捕获Ctrl+C中断
    trap handle_interrupt SIGINT
    
    welcome_message
    check_installed
    check_apt_source
    
    if [ "$apt_source_configured" = false ]; then
        configure_apt_source
    fi
    
    update_package_list
    install_or_update_cpolar
    completion_message
}

# 执行主函数
main

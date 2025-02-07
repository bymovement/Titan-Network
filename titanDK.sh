#!/bin/bash

# ----------------------------
# Color and Icon Definitions
# ----------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

CHECKMARK="✅"
ERROR="❌"
PROGRESS="⏳"
INSTALL="🛠️"
STOP="⏹️"
RESTART="🔄"
LOGS="📄"
EXIT="🚪"
INFO="ℹ️"

# ----------------------------
# Install Docker
# ----------------------------
install_docker() {
    echo -e "${INSTALL} Installing Docker...${RESET}"
    
    sudo apt-get update
    sudo apt-get install -y ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    echo -e "${CHECKMARK} Docker installed successfully.${RESET}"
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Start Titan Node
# ----------------------------
start_titan_node() {
    echo -e "${INSTALL} Setting up Titan Node...${RESET}"
    read -p "Enter the HASH value for the Titan Node: " HASH
    echo "HASH=$HASH" > .env

    docker run --network=host -d -v ~/.titanedge:/root/.titanedge bymovement/titan-edge
    sleep 10

    docker run --rm -it -v ~/.titanedge:/root/.titanedge bymovement/titan-edge bind --hash=$HASH https://api-test1.container1.titannet.io/api/v2/device/binding
    echo -e "${CHECKMARK} Titan Node started and bound successfully.${RESET}"
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# View All Containers
# ----------------------------
view_containers() {
    echo -e "${INFO} Viewing all containers...${RESET}"
    docker ps -a
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# View Logs for a Container
# ----------------------------
view_logs() {
    read -p "Enter the container ID to view logs: " container_id
    echo -e "${LOGS} Fetching logs for container $container_id...${RESET}"
    docker logs $container_id
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Manage Containers (Stop & Remove)
# ----------------------------
manage_container() {
    read -p "Enter the container ID to stop and remove: " container_id
    echo -e "${STOP} Stopping container $container_id...${RESET}"
    docker stop $container_id
    echo -e "${STOP} Removing container $container_id...${RESET}"
    docker rm $container_id
    echo -e "${CHECKMARK} Container $container_id stopped and removed successfully.${RESET}"
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Restart Container
# ----------------------------
restart_container() {
    read -p "Enter the container ID to restart: " container_id
    echo -e "${RESTART} Restarting container $container_id...${RESET}"
    docker restart $container_id
    echo -e "${CHECKMARK} Container $container_id restarted successfully.${RESET}"
    read -p "Press Enter to return to the main menu."
}

# ----------------------------
# Display ASCII Art and Welcome Message
# ----------------------------
display_ascii() {
    clear
    echo -e "${RED}    ____  __ __    _   ______  ____  ___________${RESET}"
    echo -e "${GREEN}   / __ \/ //_/   / | / / __ \/ __ \/ ____/ ___/${RESET}"
    echo -e "${BLUE}  / / / / ,<     /  |/ / / / / / / / __/  \\__ \\ ${RESET}"
    echo -e "${YELLOW} / /_/ / /| |   / /|  / /_/ / /_/ / /___ ___/ / ${RESET}"
    echo -e "${MAGENTA}/_____/_/ |_|  /_/ |_/\____/_____/_____//____/  ${RESET}"
    echo -e ""
    echo -e "${MAGENTA}🚀 Follow bymovement on Telegram: https://t.me/bymovent${RESET}"
    echo -e "${MAGENTA}📢 Follow bymovement on Twitter: https://x.com/bymoveement${RESET}"
    echo -e ""
    echo -e "${GREEN}Welcome to the Titan Node Installation Wizard!${RESET}"
    echo -e ""
}

# ----------------------------
# Main Menu
# ----------------------------
show_menu() {
    clear
    display_ascii
    echo -e "    ${YELLOW}Choose an option:${RESET}"
    echo -e "    ${CYAN}1.${RESET} ${INSTALL} Install Docker"
    echo -e "    ${CYAN}2.${RESET} ${INSTALL} Start Titan Node"
    echo -e "    ${CYAN}3.${RESET} ${INFO} View All Containers"
    echo -e "    ${CYAN}4.${RESET} ${LOGS} View Logs for a Container"
    echo -e "    ${CYAN}5.${RESET} ${STOP} Manage Containers (Stop & Remove)"
    echo -e "    ${CYAN}6.${RESET} ${RESTART} Restart a Container"
    echo -e "    ${CYAN}7.${RESET} ${EXIT} Exit"
    echo -ne "    ${YELLOW}Enter your choice [1-7]: ${RESET}"
}

# ----------------------------
# Main Loop
# ----------------------------
while true; do
    show_menu
    read choice
    case $choice in
        1)
            install_docker
            ;;
        2)
            start_titan_node
            ;;
        3)
            view_containers
            ;;
        4)
            view_logs
            ;;
        5)
            manage_container
            ;;
        6)
            restart_container
            ;;
        7)
            echo -e "${EXIT} Exiting...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${ERROR} Invalid option. Please try again.${RESET}"
            read -p "Press Enter to continue..."
            ;;
    esac
done

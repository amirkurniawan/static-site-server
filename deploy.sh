#!/bin/bash

#===============================================================================
# Deploy Script - Static Site Server
# Description: Deploy static website to remote server using rsync
# Usage: ./deploy.sh
#
# Project: https://roadmap.sh/projects/static-site-server
#===============================================================================

# Configuration - SESUAIKAN DENGAN SERVER KAMU
SERVER_USER="gitlabadmin"
SERVER_IP="192.168.246.30"
SERVER_PATH="/var/www/google-kw"
LOCAL_PATH="."
SSH_KEY="~/.ssh/id_work"  # Sesuaikan dengan SSH key kamu

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo ""
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════${NC}"
echo -e "${CYAN}${BOLD}           DEPLOYING GOOGLE KW TO SERVER               ${NC}"
echo -e "${CYAN}${BOLD}═══════════════════════════════════════════════════════${NC}"
echo ""

# Check if rsync is installed
if ! command -v rsync &> /dev/null; then
    echo -e "${RED}Error: rsync is not installed${NC}"
    echo "Install with: sudo apt install rsync"
    exit 1
fi

echo -e "${YELLOW}→ Target: ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}${NC}"
echo -e "${YELLOW}→ Source: ${LOCAL_PATH}${NC}"
echo ""

# Create remote directory if not exists
echo -e "${CYAN}[1/3] Creating remote directory...${NC}"
ssh -i ${SSH_KEY} ${SERVER_USER}@${SERVER_IP} "sudo mkdir -p ${SERVER_PATH} && sudo chown -R ${SERVER_USER}:${SERVER_USER} ${SERVER_PATH}"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to create remote directory${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Remote directory ready${NC}"
echo ""

# Sync files using rsync
echo -e "${CYAN}[2/3] Syncing files with rsync...${NC}"
rsync -avz --progress \
    --exclude '.git' \
    --exclude 'deploy.sh' \
    --exclude 'README.md' \
    --exclude '.DS_Store' \
    --exclude '*.log' \
    -e "ssh -i ${SSH_KEY}" \
    ${LOCAL_PATH}/ ${SERVER_USER}@${SERVER_IP}:${SERVER_PATH}/

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to sync files${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Files synced successfully${NC}"
echo ""

# Set correct permissions
echo -e "${CYAN}[3/3] Setting permissions...${NC}"
ssh -i ${SSH_KEY} ${SERVER_USER}@${SERVER_IP} "sudo chown -R www-data:www-data ${SERVER_PATH} && sudo chmod -R 755 ${SERVER_PATH}"

if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to set permissions${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Permissions set${NC}"
echo ""

echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}           DEPLOYMENT SUCCESSFUL! 🚀                   ${NC}"
echo -e "${GREEN}${BOLD}═══════════════════════════════════════════════════════${NC}"
echo ""
echo -e "Website URL: ${BOLD}http://${SERVER_IP}${NC}"
echo ""

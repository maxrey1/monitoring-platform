#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/hyperdxio/hyperdx.git"
INSTALL_DIR="/opt/hyperdx"
RUN_USER="hyperdx"

# Проверки

if ! command -v apt-get >/dev/null 2>&1; then
echo "This script is intended for Ubuntu/Debian systems."
exit 1
fi

if [[ "${EUID}" -ne 0 ]]; then
echo "Run as root."
exit 1
fi

export DEBIAN_FRONTEND=noninteractive

# Update system and install required packages

apt-get update
apt-get -y upgrade
apt-get -y install ca-certificates curl git sed

# Create dedicated user

if id -u "${RUN_USER}" >/dev/null 2>&1; then
echo "User '${RUN_USER}' already exists."
else
useradd -m -s /bin/bash "${RUN_USER}"
echo "User '${RUN_USER}' created."
fi

# Docker group access

if id -nG "${RUN_USER}" | grep -qw docker; then
echo "User '${RUN_USER}' is already in docker group."
else
usermod -aG docker "${RUN_USER}"
echo "User '${RUN_USER}' added to docker group."
fi

# Request HyperDX server IP

echo "Enter HyperDX server IP address:"
read -r SERVER_IP

if ! [[ "$SERVER_IP" =~ ^([0-9]{1,3}.){3}[0-9]{1,3}$ ]]; then
echo "Invalid IPv4 address."
exit 1
fi

# Clone repository

if [[ -e "${INSTALL_DIR}" ]]; then
echo "Path '${INSTALL_DIR}' already exists."
exit 1
fi

mkdir -p "$(dirname "${INSTALL_DIR}")"

git clone "${REPO_URL}" "${INSTALL_DIR}"
chown -R "${RUN_USER}:${RUN_USER}" "${INSTALL_DIR}"

cd "${INSTALL_DIR}"

if [[ ! -f docker-compose.yml ]]; then
echo "docker-compose.yml not found."
exit 1
fi

if [[ ! -f .env ]]; then
echo ".env not found."
exit 1
fi

# Update URLs

sed -i.bak -E 
"s|^(\s*SERVER_URL:\s*)http://127\.0\.0\.1(:\$\{HYPERDX_API_PORT\})\s*$|\1http://${SERVER_IP}\2|g" 
docker-compose.yml

sed -i.bak -E 
"s|^(HYPERDX_APP_URL=)http://localhost\s*$|\1http://${SERVER_IP}|g" 
.env

chown "${RUN_USER}:${RUN_USER}" 
docker-compose.yml docker-compose.yml.bak 
.env .env.bak

# Start services

sudo -u "${RUN_USER}" -H bash -lc 
"cd '${INSTALL_DIR}' && docker compose up -d"

echo ""
echo "HyperDX deployment completed."
echo "UI:  http://${SERVER_IP}:8080"
echo "API: http://${SERVER_IP}:8000"
echo ""
echo "Management commands:"
echo "sudo -u ${RUN_USER} -H bash -lc "cd '${INSTALL_DIR}' && docker compose ps""
echo "sudo -u ${RUN_USER} -H bash -lc "cd '${INSTALL_DIR}' && docker compose logs -f""
echo "sudo -u ${RUN_USER} -H bash -lc "cd '${INSTALL_DIR}' && docker compose down""

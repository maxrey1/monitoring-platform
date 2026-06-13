#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/hyperdxio/hyperdx.git"
INSTALL_DIR="/opt/hyperdx"
RUN_USER="hyperdx"

echo "=== HyperDX Production Deployment ==="

if [[ "${EUID}" -ne 0 ]]; then
echo "Run script as root."
exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
echo "Docker is not installed."
exit 1
fi

if ! command -v git >/dev/null 2>&1; then
echo "Git is not installed."
exit 1
fi

echo ""
echo "Enter HyperDX hostname (example: logs.example.com)"
read -r SERVER_HOST

if [[ -z "${SERVER_HOST}" ]]; then
echo "Hostname cannot be empty."
exit 1
fi

if ! id -u "${RUN_USER}" >/dev/null 2>&1; then
useradd -m -s /bin/bash "${RUN_USER}"
fi

mkdir -p "$(dirname "${INSTALL_DIR}")"

if [[ ! -d "${INSTALL_DIR}" ]]; then
git clone "${REPO_URL}" "${INSTALL_DIR}"
fi

chown -R "${RUN_USER}:${RUN_USER}" "${INSTALL_DIR}"

cd "${INSTALL_DIR}"

if [[ ! -f .env ]]; then
cp .env.example .env
fi

sed -i 
"s|[http://localhost|https://${SERVER_HOST}|g](http://localhost|https://${SERVER_HOST}|g)" 
.env

if grep -q "SERVER_URL:" docker-compose.yml; then
sed -i 
"s|SERVER_URL:.*|SERVER_URL: https://${SERVER_HOST}|g" 
docker-compose.yml
fi

echo ""
echo "Starting HyperDX..."

sudo -u "${RUN_USER}" -H bash -c "
cd ${INSTALL_DIR}
docker compose pull
docker compose up -d
"

echo ""
echo "Waiting for services..."
sleep 15

echo ""
echo "Container status:"
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'

echo ""
echo "===================================="
echo "HyperDX deployment completed"
echo "URL: https://${SERVER_HOST}"
echo "===================================="
echo ""
echo "Useful commands:"
echo "docker compose ps"
echo "docker compose logs -f"
echo "docker compose restart"
echo "docker compose down"

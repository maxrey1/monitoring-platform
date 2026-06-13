#!/bin/bash

install-pm2collector.sh

set -e

OTEL_DIR="/opt/otel-collector"

mkdir -p "$OTEL_DIR"
cd "$OTEL_DIR"

cat > docker-compose-pm2.yml << 'EOF'
version: '3.8'

services:
otel-collector-pm2:
image: otel/opentelemetry-collector-contrib
container_name: otel-pm2-local
command: ["--config=/etc/otelcol/config.yaml"]

volumes:
  - /var/tmp/pm2:/var/tmp/pm2:ro
  - /opt/otel-collector/otel-pm2-local.yaml:/etc/otelcol/config.yaml:ro

restart: always

EOF

cat > otel-pm2-local.yaml << 'EOF'
receivers:
filelog/pm2:
include:
- /var/tmp/pm2/.log
- /var/tmp/pm2/.out.log
- /var/tmp/pm2/*.err.log

start_at: beginning
poll_interval: 500ms
include_file_name: true

operators:
  - type: json_parser
    parse_to: attributes

processors:
batch: {}

exporters:
otlphttp/hyperdx:
endpoint: "${HYPERDX_ENDPOINT}"
headers:
authorization: "${HYPERDX_API_KEY}"

service:
pipelines:
logs:
receivers: [filelog/pm2]
processors: [batch]
exporters: [otlphttp/hyperdx]
EOF

docker compose -f docker-compose-pm2.yml up -d

echo "PM2 collector started"
EOF

#!/bin/bash

# install-netcollector-otel.sh

set -e

OTEL_DIR="/opt/otel-collector"
mkdir -p "$OTEL_DIR"
cd "$OTEL_DIR"

cat > docker-compose-net.yml << 'EOF'
version: '3.8'

services:
otel-collector:
image: otel/opentelemetry-collector-contrib:latest
container_name: otel-collector-local

```
command:
  - "--config=/etc/otel/config.yaml"

volumes:
  - ./config.yaml:/etc/otel/config.yaml:ro

  - /opt/apps/app1/logs:/var/log/app1:ro
  - /opt/apps/app2/logs:/var/log/app2:ro
  - /opt/apps/app3/logs:/var/log/app3:ro

restart: unless-stopped
```

EOF

cat > config.yaml << 'EOF'

receivers:
filelog/net:
include:
- /var/log/app1/*.log
- /var/log/app2/*.log
- /var/log/app3/*.log

```
start_at: end
poll_interval: 500ms
include_file_name: true

operators:
  - type: json_parser
    parse_to: attributes
```

processors:
batch: {}

exporters:
otlphttp/hyperdx:
endpoint: "${HYPERDX_ENDPOINT}"

```
headers:
  authorization: "${HYPERDX_API_KEY}"
```

service:
pipelines:
logs:
receivers: [filelog/net]
processors: [batch]
exporters: [otlphttp/hyperdx]

EOF

docker compose -f docker-compose-net.yml up -d

echo "OpenTelemetry Collector started"
EOF

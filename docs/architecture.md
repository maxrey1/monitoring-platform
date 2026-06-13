# Monitoring Platform Architecture

## Overview

This repository contains monitoring, logging and observability configurations used for centralized telemetry collection and analysis.

The platform combines:

* Prometheus for metrics collection
* Grafana for visualization
* Loki for log aggregation
* OpenTelemetry Collector for telemetry processing
* HyperDX for centralized observability

---

## Architecture

```text
REMOTE APPLICATION SERVER

Applications
    │
    ├── OpenTelemetry Collector ───────────────┐
    │                                           │
    └── Promtail ───────────────────────────────┤
                                                │
                                                ▼

CENTRAL OBSERVABILITY SERVER

OpenTelemetry Collector ───────► HyperDX

Promtail ──────────────────────► Loki ───────► Grafana
                                              ▲
                                              │
Prometheus ───────────────────────────────────┘
```

---

## Components

### Prometheus

Responsibilities:

* Metrics collection
* Service discovery
* Time-series storage
* Alert rule evaluation

Configuration:

```text
prometheus/prometheus.yml
```

---

### Grafana

Responsibilities:

* Infrastructure dashboards
* Application dashboards
* Observability visualization

Dashboard examples:

* Infrastructure Overview
* Linux Server Monitoring
* Application Logs
* OpenTelemetry Metrics

Location:

```text
grafana/dashboards/
```

---

### Loki

Responsibilities:

* Centralized log storage
* Log indexing
* Log querying

Configuration:

```text
logging/loki-config.yaml
```

---

### OpenTelemetry Collector

Responsibilities:

* Log ingestion
* Telemetry processing
* Attribute enrichment
* Export to observability platforms

Implemented collectors:

#### PM2 Collector

Features:

* PM2 log collection
* JSON log parsing
* OTLP export
* HyperDX integration

Location:

```text
otel/pm2/
```

#### .NET Collector

Features:

* .NET application log collection
* JSON parsing
* OTLP export
* Centralized log aggregation

Location:

```text
otel/dotnet/
```

---

### HyperDX

Responsibilities:

* Centralized observability
* Log analysis
* Trace visualization
* Incident investigation

Deployment automation:

```text
automation/hyperdx/
```

---

## Deployment Flow

1. Deploy HyperDX
2. Deploy Loki
3. Configure Prometheus
4. Configure OpenTelemetry Collectors
5. Connect Grafana dashboards
6. Validate telemetry ingestion

---

## Repository Structure

```text
monitoring-platform/

├── automation/
│   └── hyperdx/

├── docs/

├── grafana/
│   └── dashboards/

├── logging/
│   └── loki-config.yaml

├── otel/
│   ├── dotnet/
│   └── pm2/

├── prometheus/
│   └── prometheus.yml
```

---

## Future Improvements

* Alertmanager integration
* Kubernetes monitoring
* Node Exporter deployment
* Blackbox Exporter checks
* OpenTelemetry traces
* Infrastructure as Code automation

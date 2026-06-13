# Monitoring Platform

Monitoring, logging and observability engineering project.

## Overview

Repository containing automation scripts, OpenTelemetry configurations and observability stack setup for centralized log collection, metrics and traces.

The project was tested on real PM2-based applications generating HTTP access logs, application errors and runtime exceptions.

## Implemented

### OpenTelemetry

#### PM2 Collector

* PM2 log collection from multiple Node.js applications
* JSON log parsing and normalization
* OTLP export
* HyperDX integration

**Data sources:**

* teacher-client (frontend application)
* backoffice (admin panel)
* cms-web (CMS system)
* Next.js / PM2 based services

**Collected log types:**

* HTTP access logs
* Application errors
* Runtime exceptions
* Process lifecycle events (restart, shutdown)

#### .NET Collector

* .NET application log collection via OTLP
* Centralized log aggregation pipeline
* Structured logging support
* HyperDX integration

### HyperDX

* Automated deployment
* Docker-based installation
* Production-ready installation scripts
* Environment-based configuration
* OTLP ingestion support

## Observability Stack

The system provides unified observability across:

* Logs (Loki / HyperDX)
* Metrics (Prometheus)
* Dashboards (Grafana)
* Traces (OpenTelemetry)

## Repository Structure

```text
automation/
└── hyperdx/

otel/
├── pm2/
└── dotnet/

grafana/
logging/
prometheus/
docs/
```

## Technologies

* OpenTelemetry
* HyperDX
* Grafana
* Loki
* Prometheus
* Docker
* Linux
* PM2
* .NET
* Bash

## Status

Active personal observability and monitoring engineering project based on real-world application logs and distributed telemetry pipelines.

# PM2 OpenTelemetry Collector

Сбор логов PM2-приложений через OpenTelemetry Collector.

Функции:

* чтение логов из каталога PM2;
* JSON-парсинг записей;
* добавление атрибутов;
* отправка логов через OTLP;
* интеграция с HyperDX.

Основные компоненты:

* OpenTelemetry Collector
* filelog receiver
* batch processor
* OTLP HTTP exporter


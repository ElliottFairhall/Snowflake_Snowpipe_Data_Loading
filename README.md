# 🚀 Snowflake Snowpipe & Data Loading

> Architecture and design rationale: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)

[![Snowflake](https://img.shields.io/badge/Snowflake-Cloud%20Data%20Platform-29B5E8?style=flat&logo=snowflake)](https://www.snowflake.com/)
[![SQL](https://img.shields.io/badge/SQL-Snowflake%20Dialect-lightgrey)](https://docs.snowflake.com/)
[![Status](https://img.shields.io/badge/Status-Educational-success)](https://github.com/ElliottFairhall/Snowflake_Snowpipe_Data_Loading)

A hands-on project for mastering **Data Loading** in Snowflake, featuring both bulk loading with `COPY INTO` and
near-real-time ingestion with **Snowpipe**. Learn to configure stages, file formats, and automated pipelines from cloud
storage.

______________________________________________________________________

## Key Features

- **Bulk Loading**: Mastering idempotent `COPY INTO` for batch workloads.
- **Snowpipe**: Implementing auto-ingest, event-driven pipelines.
- **Governance**: Secure stage and file format management.
- **Monitoring**: Tracking load performance and troubleshooting `COPY_HISTORY`.

______________________________________________________________________

## Project Structure

```text
Snowflake_Snowpipe_Data_Loading/
├── README.md               # You are here
├── Tutorial/
│   └── SNOWPIPE_TUTORIAL.md # Step-by-step walkthrough
├── scripts/                # Extracted SQL loading scripts
│   ├── 01_stage_setup.sql
│   ├── 02_file_format_definition.sql
│   ├── 03_bulk_loading_copy.sql
│   ├── 04_snowpipe_definition.sql
│   ├── 05_pipe_management.sql
│   └── 06_load_monitoring.sql
└── data/                   # Sample CSV/JSON schemas
```

______________________________________________________________________

## Getting Started

> **Environment Setup:** Before beginning, execute `scripts/00_setup_environment.sql` to provision the necessary
> databases, schemas, and sample data for this project.

1. Navigate to the **[Data Loading Tutorial](Tutorial/SNOWPIPE_TUTORIAL.md)**.
2. Follow the sequence in `scripts/` to build your ingestion pipeline.

______________________________________________________________________

## Author

**Elliott Fairhall** *Data Engineering Educational Series*

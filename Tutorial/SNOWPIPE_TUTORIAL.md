# 🚀 Snowflake Snowpipe & Data Loading Tutorial

## 🎯 Learning Objectives

1. 🧠 Understand the concept of Snowpipe and its role in continuous data loading within Snowflake.

2. 🛠️ Master the creation and management of stages, file formats, and pipes for automated data ingestion.

3. 🔗 Learn the differences between bulk loading with COPY INTO and continuous loading with Snowpipe.

## 📚 Table of Contents

- [🚀 Snowflake Snowpipe & Data Loading Tutorial](#-snowflake-snowpipe--data-loading-tutorial)
  - [🎯 Learning Objectives](#-learning-objectives)
  - [📚 Table of Contents](#-table-of-contents)
    - [🎉 Introduction](#-introduction)
    - [📝 Introduction to Data Loading in Snowflake](#-introduction-to-data-loading-in-snowflake)
    - [📂 Stages — Where Your Files Land](#-stages--where-your-files-land)
    - [📄 File Formats](#-file-formats)
    - [📦 Bulk Loading with COPY INTO](#-bulk-loading-with-copy-into)
    - [🔄 Continuous Loading with Snowpipe](#-continuous-loading-with-snowpipe)
    - [📊 Monitoring and Troubleshooting](#-monitoring-and-troubleshooting)
  - [💡 Tutorial](#-tutorial)
  - [🎈 Conclusion](#-conclusion)
  - [📖 Additional Resources](#-additional-resources)
  - [⚠️ Disclaimer](#%EF%B8%8F-disclaimer)

### 🎉 Introduction

Welcome to this tutorial on Snowpipe and Data Loading within Snowflake! This tutorial is designed to help you understand
and implement both bulk and continuous data loading patterns in your Snowflake environment. By the end of this tutorial,
you'll be able to confidently load data from cloud storage into Snowflake tables using both manual and automated
approaches. So, let's dive in! 🏊‍♀️

### 📝 Introduction to Data Loading in Snowflake

Data loading is the process of ingesting data from external sources — such as Amazon S3, Azure Blob Storage, or Google
Cloud Storage — into Snowflake tables. Snowflake provides two primary loading methods:

| Method        | Model                     | Compute                        | Best For                         |
| ------------- | ------------------------- | ------------------------------ | -------------------------------- |
| **COPY INTO** | Bulk / batch loading      | User-managed warehouse         | Scheduled batch loads, backfills |
| **Snowpipe**  | Continuous / event-driven | Serverless (Snowflake-managed) | Near-real-time streaming         |

Both methods read data from **stages** and use **file formats** to parse incoming files.

### 📂 Stages — Where Your Files Land

A stage is a named location that references a storage area where data files are held before loading. Snowflake supports
three types of stages:

| Stage Type         | Description                                        | Example                           |
| ------------------ | -------------------------------------------------- | --------------------------------- |
| **Internal**       | Storage managed by Snowflake (table or user stage) | `@~` (user), `@%my_table` (table) |
| **Named Internal** | Explicitly created internal stage                  | `@my_internal_stage`              |
| **External**       | References cloud storage (S3, Azure, GCS)          | `@my_s3_stage`                    |

```sql
-- Create an external stage pointing to S3
CREATE OR REPLACE STAGE raw_data_stage
    URL = 's3://my-bucket/raw/'
    STORAGE_INTEGRATION = my_s3_integration
    FILE_FORMAT = (TYPE = 'CSV');

-- List files in a stage
LIST @raw_data_stage;
```

### 📄 File Formats

File format objects define how Snowflake interprets incoming data files. They can be reused across multiple COPY
commands and pipes.

```sql
-- CSV file format
CREATE OR REPLACE FILE FORMAT csv_format
    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    NULL_IF = ('NULL', 'null', '')
    EMPTY_FIELD_AS_NULL = TRUE
    FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- JSON file format
CREATE OR REPLACE FILE FORMAT json_format
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = TRUE;

-- Parquet file format
CREATE OR REPLACE FILE FORMAT parquet_format
    TYPE = 'PARQUET'
    SNAPPY_COMPRESSION = TRUE;
```

### 📦 Bulk Loading with COPY INTO

The `COPY INTO` command is the primary method for bulk loading data from a stage into a Snowflake table. It is
idempotent — re-running the same COPY command will not reload files that have already been processed (within a 64-day
window).

```sql
-- Basic COPY INTO
COPY INTO snowpipe_raw.staging.customers
FROM @raw_data_stage/customers/
FILE_FORMAT = (FORMAT_NAME = 'csv_format')
ON_ERROR = 'CONTINUE';

-- COPY with transformation
COPY INTO snowpipe_raw.staging.orders (order_id, customer_id, order_date, amount)
FROM (
    SELECT
        $1::INTEGER,
        $2::INTEGER,
        $3::DATE,
        $4::DECIMAL(10,2)
    FROM @raw_data_stage/orders/
)
FILE_FORMAT = (FORMAT_NAME = 'csv_format');

-- COPY with pattern matching
COPY INTO snowpipe_raw.staging.events
FROM @raw_data_stage/events/
FILE_FORMAT = (FORMAT_NAME = 'json_format')
PATTERN = '.*2026-03.*\.json';
```

### 🔄 Continuous Loading with Snowpipe

Snowpipe enables continuous, event-driven data loading. When a new file arrives in your cloud storage, Snowpipe
automatically detects it and loads it into the target table within minutes. It uses a **serverless** compute model,
meaning you do not need to manage a warehouse.

```sql
-- Create a pipe for auto-ingest
CREATE OR REPLACE PIPE snowpipe_raw.pipes.customer_pipe
    AUTO_INGEST = TRUE
AS
    COPY INTO snowpipe_raw.staging.customers
    FROM @raw_data_stage/customers/
    FILE_FORMAT = (FORMAT_NAME = 'csv_format');

-- View the notification channel (for cloud event configuration)
SHOW PIPES LIKE 'customer_pipe';
```

After creating the pipe, you must configure your cloud storage to send notifications to the Snowflake-provided SQS queue
(for AWS), Event Grid subscription (for Azure), or Pub/Sub subscription (for GCS). This enables auto-ingest.

You can also trigger Snowpipe manually using the REST API or the Snowflake `SYSTEM$PIPE_STATUS` function:

```sql
-- Check pipe status
SELECT SYSTEM$PIPE_STATUS('snowpipe_raw.pipes.customer_pipe');

-- Force a manual refresh of the pipe
ALTER PIPE snowpipe_raw.pipes.customer_pipe REFRESH;
```

### 📊 Monitoring and Troubleshooting

```sql
-- Check COPY history for a table
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'CUSTOMERS',
    START_TIME => DATEADD('hour', -24, CURRENT_TIMESTAMP())
))
ORDER BY last_load_time DESC;

-- Check Snowpipe load history
SELECT *
FROM TABLE(INFORMATION_SCHEMA.PIPE_USAGE_HISTORY(
    DATE_RANGE_START => DATEADD('day', -7, CURRENT_TIMESTAMP())
))
ORDER BY start_time DESC;

-- Identify failed loads
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'CUSTOMERS',
    START_TIME => DATEADD('day', -1, CURRENT_TIMESTAMP())
))
WHERE status = 'LOAD_FAILED';
```

## 💡 Tutorial

In this tutorial, we'll be exploring how to set up a complete data loading pipeline in Snowflake. We'll create stages,
define file formats, perform bulk loading with COPY INTO, and configure Snowpipe for continuous, event-driven ingestion
from cloud storage.

By the end of this tutorial, you'll have gained a comprehensive understanding of how to leverage Snowflake's data
loading capabilities to build reliable, automated ingestion pipelines for both batch and real-time workloads.

## 🎈 Conclusion

In conclusion, Snowflake provides flexible and powerful data loading capabilities through both bulk COPY INTO commands
and continuous Snowpipe ingestion. By combining stages, file formats, and pipes, you can build robust data ingestion
pipelines that scale from simple batch loads to near-real-time streaming. Snowpipe's serverless compute model makes
continuous loading particularly cost-effective, as you only pay for the compute resources consumed during actual file
processing.

## 📖 Additional Resources

- [Data Loading Documentation](https://docs.snowflake.com/en/user-guide/data-load-overview)
- [Snowpipe Documentation](https://docs.snowflake.com/en/user-guide/data-load-snowpipe-intro)
- [Quick Start - Data Loading](https://quickstarts.snowflake.com/guide/data_loading/)
- [COPY INTO Command Reference](https://docs.snowflake.com/en/sql-reference/sql/copy-into-table)

## ⚠️ Disclaimer

Please note that whilst we strive to keep this tutorial up-to-date, Snowflake's features and capabilities may change
over time. Always refer to the [official Snowflake documentation](https://docs.snowflake.com/) for the most accurate and
current information.

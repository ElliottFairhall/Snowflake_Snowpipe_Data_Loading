-- Create a pipe for auto-ingest
CREATE OR REPLACE PIPE snowpipe_raw.pipes.customer_pipe
    AUTO_INGEST = TRUE
AS
    COPY INTO snowpipe_raw.staging.customers
    FROM @raw_data_stage/customers/
    FILE_FORMAT = (FORMAT_NAME = 'csv_format');

-- View the notification channel (for cloud event configuration)
SHOW PIPES LIKE 'customer_pipe';

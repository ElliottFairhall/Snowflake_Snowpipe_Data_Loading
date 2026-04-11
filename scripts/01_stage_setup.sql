-- Create an external stage pointing to S3
CREATE OR REPLACE STAGE raw_data_stage
    URL = 's3://my-bucket/raw/'
    STORAGE_INTEGRATION = my_s3_integration
    FILE_FORMAT = (TYPE = 'CSV');

-- List files in a stage
-- LIST @raw_data_stage;

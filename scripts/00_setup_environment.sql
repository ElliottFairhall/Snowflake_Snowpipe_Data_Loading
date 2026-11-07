-- =============================================================================
-- 00_SETUP_ENVIRONMENT
-- =============================================================================
-- Purpose:    Provision the necessary databases, schemas, and target tables
--             to serve as the foundation for the Data Loading tutorial.
-- =============================================================================

-- WARNING: this script uses CREATE OR REPLACE TABLE as a reset-to-sample-data step. It replaces the tables below,
-- so re-running it discards changes you made to them (Time Travel keeps the old version only while retention
-- allows). The database names carry the tutorial prefix SNOWPIPE_, so it does not touch another tutorial's tables.

USE ROLE SYSADMIN;

-- 1. Create base DBs and Schemas
CREATE DATABASE IF NOT EXISTS SNOWPIPE_RAW;
CREATE SCHEMA IF NOT EXISTS SNOWPIPE_RAW.STAGING;
CREATE SCHEMA IF NOT EXISTS SNOWPIPE_RAW.PIPES;

-- 2. Create Target Tables for Loading
CREATE OR REPLACE TABLE SNOWPIPE_RAW.STAGING.CUSTOMERS (
    CUSTOMER_ID INT,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    SIGNUP_DATE DATE
);

CREATE OR REPLACE TABLE SNOWPIPE_RAW.STAGING.ORDERS (
    ORDER_ID INT,
    CUSTOMER_ID INT,
    ORDER_DATE DATE,
    AMOUNT NUMBER(10, 2)
);

CREATE OR REPLACE TABLE SNOWPIPE_RAW.STAGING.EVENTS (
    EVENT_ID INT,
    EVENT_PAYLOAD VARIANT,
    EVENT_TIME TIMESTAMP_NTZ
);

-- =============================================================================
-- 00_SETUP_ENVIRONMENT
-- =============================================================================
-- Purpose:    Provision the necessary databases, schemas, and target tables
--             to serve as the foundation for the Data Loading tutorial.
-- =============================================================================

USE ROLE SYSADMIN;

-- 1. Create base DBs and Schemas
CREATE DATABASE IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS RAW.STAGING;
CREATE SCHEMA IF NOT EXISTS RAW.PIPES;

-- 2. Create Target Tables for Loading
CREATE OR REPLACE TABLE RAW.STAGING.CUSTOMERS (
    CUSTOMER_ID INT,
    CUSTOMER_NAME VARCHAR,
    EMAIL VARCHAR,
    SIGNUP_DATE DATE
);

CREATE OR REPLACE TABLE RAW.STAGING.ORDERS (
    ORDER_ID INT,
    CUSTOMER_ID INT,
    ORDER_DATE DATE,
    AMOUNT NUMBER(10, 2)
);

CREATE OR REPLACE TABLE RAW.STAGING.EVENTS (
    EVENT_ID INT,
    EVENT_PAYLOAD VARIANT,
    EVENT_TIME TIMESTAMP_NTZ
);

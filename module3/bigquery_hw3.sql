-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `wide-saga-485120-u7.module3hw_dataset.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://module3hw_bucket/yellow/yellow_tripdata_2024-*.parquet']
);

-- Question 1
-- 20332093
SELECT COUNT(*) FROM wide-saga-485120-u7.module3hw_dataset.external_yellow_tripdata;

-- Question 2
-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_non_partitioned AS
SELECT * FROM wide-saga-485120-u7.module3hw_dataset.external_yellow_tripdata;

-- Count from external table
-- This query will process 0 B when run.
SELECT COUNT(DISTINCT PULocationID) FROM wide-saga-485120-u7.module3hw_dataset.external_yellow_tripdata;

-- Count from non partitioned materialized table
-- This query will process 155.12 MB when run.
SELECT COUNT(DISTINCT PULocationID) FROM wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_non_partitioned;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_partitioned
PARTITION BY
    DATE(tpep_dropoff_datetime)
CLUSTER BY
  VendorID
AS
SELECT * FROM wide-saga-485120-u7.module3hw_dataset.external_yellow_tripdata;

-- Question 3
-- Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery.
-- Now write a query to retrieve the PULocationID and DOLocationID on the same table.

-- This query will process 155.12 MB when run.
SELECT PULocationID FROM wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_non_partitioned;

-- This query will process 310.24 MB when run.
SELECT PULocationID, DOLocationID FROM wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_non_partitioned;


-- Question 4
-- 8333
SELECT COUNT(*) FROM wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_non_partitioned
WHERE
fare_amount = 0;


-- Question 6
-- non-partitioned
-- This query will process 310.24 MB when run.
SELECT DISTINCT VendorID FROM wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_non_partitioned
WHERE
tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

-- partitioned query
-- This query will process 26.84 MB when run.
SELECT DISTINCT VendorID FROM wide-saga-485120-u7.module3hw_dataset.yellow_tripdata_partitioned
WHERE
tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
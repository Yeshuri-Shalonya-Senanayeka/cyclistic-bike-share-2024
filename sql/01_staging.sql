/*
Project: Cyclistic Bike-Share Analysis (2024)
Goal: Build a clean analytics pipeline to compare Member vs Casual rider behavior
Author: Yeshuri Shalonaya Senanayeka

FILE: 01_staging.sql
Purpose:
  1) Create database (optional)
  2) Create staging table (all columns as text)
  3) Bulk load 12 monthly cleaned CSV files into staging
*/

--Create project database 
CREATE DATABASE BikeShareAnalysis;

-- Use the database
USE BikeShareAnalysis;
GO

-- Create staging table

CREATE TABLE dbo.bike_trips_stage
(
    ride_id              VARCHAR(100)  NULL,
    rideable_type        VARCHAR(50)   NULL,

    started_at           VARCHAR(100)  NULL,   
    ended_at             VARCHAR(100)  NULL,   

    start_station_name   NVARCHAR(MAX) NULL,
    start_station_id     VARCHAR(100)  NULL,
    end_station_name     NVARCHAR(MAX) NULL,
    end_station_id       VARCHAR(100)  NULL,

    start_lat            VARCHAR(100)  NULL,
    start_lng            VARCHAR(100)  NULL,
    end_lat              VARCHAR(100)  NULL,
    end_lng              VARCHAR(100)  NULL,

    member_casual        VARCHAR(50)   NULL
);

-- Bulk load monthly files into staging
-- jan
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_01_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

-- feb
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_02_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

-- mar
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_03_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

SELECT * FROM dbo.bike_trips_stage;
SELECT COUNT(*) FROM dbo.bike_trips_stage;

--apr
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_04_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--may
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_05_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--jun
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_06_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--july
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_07_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--aug
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_08_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--sep
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_09_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--oct
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_10_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--nov
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_11_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

--dec
BULK INSERT dbo.bike_trips_stage
FROM 'D:\Data analysis\Cyclistic_Project\processed_clean_csv\bike_trips_2024_12_clean.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK,
    CODEPAGE = '65001'
);

-- Quick load check
SELECT COUNT(*) AS stage_total_rows
FROM dbo.bike_trips_stage;

SELECT TOP 50 *
FROM dbo.bike_trips_stage;
GO

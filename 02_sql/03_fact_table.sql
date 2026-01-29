/*
PROJECT: Cyclistic / Bike Share Case Study (Google Data Analytics)
AUTHOR:  Yeshuri Shalonaya Senanayeka

FILE: 03_fact_table.sql
Purpose:
  1) Create final typed fact table (bike_trips_clean)
  2) Transform + load data from staging using TRY_CONVERT
  3) Create derived features for analysis
  4) Remove invalid durations (<=0 or >24 hours)
  5) Add indexes for faster Power BI filtering
*/

USE BikeShareAnalysis;
GO

-- Create final clean fact table
CREATE TABLE dbo.bike_trips_clean
(
    ride_id             VARCHAR(50)  NOT NULL,
    rideable_type       VARCHAR(50),
    started_at          DATETIME2,
    ended_at            DATETIME2,

    start_station_name  NVARCHAR(MAX),
    start_station_id    VARCHAR(50),
    end_station_name    NVARCHAR(MAX),
    end_station_id      VARCHAR(50),

    start_lat           DECIMAL(18,10),
    start_lng           DECIMAL(18,10),
    end_lat             DECIMAL(18,10),
    end_lng             DECIMAL(18,10),

    member_casual       VARCHAR(20),

    -- Derived columns
    ride_length_minutes INT,
    day_of_week         INT,
    day_name            VARCHAR(15),
    ride_hour           INT,
    ride_month          INT,
    is_weekend          BIT
);

-- Transform + load from staging
INSERT INTO dbo.bike_trips_clean
(
    ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual,
    ride_length_minutes,
    day_of_week,
    day_name,
    ride_hour,
    ride_month,
    is_weekend
)
SELECT
    ride_id,
    rideable_type,

    TRY_CONVERT(DATETIME2, started_at) AS started_at,
    TRY_CONVERT(DATETIME2, ended_at)   AS ended_at,

    NULLIF(start_station_name, '') AS start_station_name,
    NULLIF(start_station_id, '')   AS start_station_id,
    NULLIF(end_station_name, '')   AS end_station_name,
    NULLIF(end_station_id, '')     AS end_station_id,

    TRY_CONVERT(DECIMAL(18,10), start_lat) AS start_lat,
    TRY_CONVERT(DECIMAL(18,10), start_lng) AS start_lng,
    TRY_CONVERT(DECIMAL(18,10), end_lat)   AS end_lat,
    TRY_CONVERT(DECIMAL(18,10), end_lng)   AS end_lng,

    member_casual,

    -- Ride length in minutes
    DATEDIFF(MINUTE,
        TRY_CONVERT(DATETIME2, started_at),
        TRY_CONVERT(DATETIME2, ended_at)
    ) AS ride_length_minutes,

    -- Day of week (1 = Sunday)
    DATEPART(WEEKDAY, TRY_CONVERT(DATETIME2, started_at)) AS day_of_week,

    -- Day name
    DATENAME(WEEKDAY, TRY_CONVERT(DATETIME2, started_at)) AS day_name,

    -- Hour of day
    DATEPART(HOUR, TRY_CONVERT(DATETIME2, started_at)) AS ride_hour,

    -- Month number
    DATEPART(MONTH, TRY_CONVERT(DATETIME2, started_at)) AS ride_month,

    -- Weekend flag
    CASE 
        WHEN DATEPART(WEEKDAY, TRY_CONVERT(DATETIME2, started_at)) IN (1,7) THEN 1
        ELSE 0
    END AS is_weekend

FROM dbo.bike_trips_stage
WHERE 
    TRY_CONVERT(DATETIME2, started_at) IS NOT NULL
    AND TRY_CONVERT(DATETIME2, ended_at) IS NOT NULL;

-- Row count + quick sample
SELECT COUNT(*) FROM dbo.bike_trips_clean;

SELECT TOP 20 * FROM dbo.bike_trips_clean;

SELECT is_weekend, COUNT(*)
FROM dbo.bike_trips_clean
GROUP BY is_weekend;

-- Remove invalid rides (duration <= 0 OR duration > 24 hours)
SELECT 
    COUNT(*) AS bad_rows
FROM dbo.bike_trips_clean
WHERE ride_length_minutes <= 0
   OR ride_length_minutes > 1440;

SELECT TOP 50 *
FROM dbo.bike_trips_clean
WHERE ride_length_minutes <= 0
   OR ride_length_minutes > 1440
ORDER BY ride_length_minutes;

DELETE
FROM dbo.bike_trips_clean
WHERE ride_length_minutes <= 0
   OR ride_length_minutes > 1440;

-- Post-cleaning checks
SELECT
    MIN(ride_length_minutes) AS min_ride_minutes,
    MAX(ride_length_minutes) AS max_ride_minutes,
    AVG(CAST(ride_length_minutes AS FLOAT)) AS avg_ride_minutes
FROM dbo.bike_trips_clean;

SELECT day_name, COUNT(*) AS rides
FROM dbo.bike_trips_clean
GROUP BY day_name
ORDER BY rides DESC;


-- Indexes to improve Power BI slicing performance
CREATE INDEX idx_bike_member      ON dbo.bike_trips_clean(member_casual);
CREATE INDEX idx_bike_started_at  ON dbo.bike_trips_clean(started_at);
CREATE INDEX idx_bike_ride_month  ON dbo.bike_trips_clean(ride_month);
CREATE INDEX idx_bike_day_of_week ON dbo.bike_trips_clean(day_of_week);
CREATE INDEX idx_bike_ride_hour   ON dbo.bike_trips_clean(ride_hour);
CREATE INDEX idx_bike_is_weekend  ON dbo.bike_trips_clean(is_weekend);


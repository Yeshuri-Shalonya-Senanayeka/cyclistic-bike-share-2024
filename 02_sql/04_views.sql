/*
PROJECT: Cyclistic / Bike Share Case Study (Google Data Analytics)
AUTHOR:  Yeshuri Shalonaya Senanayeka

FILE: 04_views.sql
Purpose:
  Create Power BI-ready views on top of dbo.bike_trips_clean.
*/

USE BikeShareAnalysis;
GO

-- DIMENSION VIEWS (USED FOR SLICERS IN POWER BI)
-- Customer Type Dimension (Member vs Casual)
CREATE OR ALTER VIEW dbo.vw_dim_customer_type AS
SELECT DISTINCT
    member_casual
FROM dbo.bike_trips_clean
WHERE member_casual IS NOT NULL;
GO


-- Bike Type Dimension
CREATE OR ALTER VIEW dbo.vw_dim_bike_type AS
SELECT DISTINCT
    rideable_type
FROM dbo.bike_trips_clean
WHERE rideable_type IS NOT NULL;
GO


-- Month Dimension
CREATE OR ALTER VIEW dbo.vw_dim_month AS
SELECT DISTINCT
    ride_month,
    DATENAME(MONTH, DATEFROMPARTS(2024, ride_month, 1)) AS month_name,
    ride_month AS month_sort
FROM dbo.bike_trips_clean
WHERE ride_month BETWEEN 1 AND 12;
GO


-- Day of Week Dimension 
CREATE OR ALTER VIEW dbo.vw_dim_day_of_week AS
SELECT DISTINCT
    day_of_week,
    day_name
FROM dbo.bike_trips_clean
WHERE day_of_week BETWEEN 1 AND 7;
GO

-- KPI SUMMARY VIEW
CREATE OR ALTER VIEW dbo.vw_kpi_summary AS
WITH base AS (
    SELECT
        member_casual,
        rideable_type,
        ride_month,
        day_of_week,
        day_name,
        ride_hour,
        ride_length_minutes,
        start_station_name
    FROM dbo.bike_trips_clean
    WHERE member_casual IS NOT NULL
      AND ride_length_minutes IS NOT NULL
      AND ride_length_minutes > 0
),

-- KPI: Total rides and average duration
kpi AS (
    SELECT
        member_casual,
        COUNT(*) AS total_rides,
        AVG(CAST(ride_length_minutes AS FLOAT)) AS avg_ride_minutes
    FROM base
    GROUP BY member_casual
),

-- Peak Month: month with highest ride count per rider type
peak_month AS (
    SELECT
        member_casual,
        ride_month,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC, ride_month ASC
        ) AS rn
    FROM base
    GROUP BY member_casual, ride_month
),

-- Peak Day: day of week with highest ride count per rider type
peak_day AS (
    SELECT
        member_casual,
        day_of_week,
        day_name,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC, day_of_week ASC
        ) AS rn
    FROM base
    GROUP BY member_casual, day_of_week, day_name
),

-- Peak Hour: hour with highest ride count per rider type
peak_hour AS (
    SELECT
        member_casual,
        ride_hour,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC, ride_hour ASC
        ) AS rn
    FROM base
    GROUP BY member_casual, ride_hour
),

-- Most Used Bike Type: bike type with highest ride count per rider type
top_bike AS (
    SELECT
        member_casual,
        rideable_type,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC, rideable_type ASC
        ) AS rn
    FROM base
    GROUP BY member_casual, rideable_type
),

-- Most Popular Start Station: station with highest ride count per rider type
top_station AS (
    SELECT
        member_casual,
        start_station_name,
        ROW_NUMBER() OVER (
            PARTITION BY member_casual
            ORDER BY COUNT(*) DESC, start_station_name ASC
        ) AS rn
    FROM base
    WHERE start_station_name IS NOT NULL
      AND LTRIM(RTRIM(start_station_name)) <> ''
    GROUP BY member_casual, start_station_name
)

SELECT
    k.member_casual,
    k.total_rides,
    k.avg_ride_minutes,

    ph.ride_hour AS peak_hour,

    pd.day_of_week AS peak_day_of_week,
    pd.day_name    AS peak_day_name,

    pm.ride_month AS peak_month,
    DATENAME(MONTH, DATEFROMPARTS(2024, pm.ride_month, 1)) AS peak_month_name,

    tb.rideable_type AS most_used_bike_type,
    ts.start_station_name AS most_popular_start_station

FROM kpi k
LEFT JOIN peak_hour   ph ON ph.member_casual = k.member_casual AND ph.rn = 1
LEFT JOIN peak_day    pd ON pd.member_casual = k.member_casual AND pd.rn = 1
LEFT JOIN peak_month  pm ON pm.member_casual = k.member_casual AND pm.rn = 1
LEFT JOIN top_bike    tb ON tb.member_casual = k.member_casual AND tb.rn = 1
LEFT JOIN top_station ts ON ts.member_casual = k.member_casual AND ts.rn = 1;
GO

-- ANALYSIS VIEWS
-- Rider comparison
CREATE OR ALTER VIEW dbo.vw_rider_comparison AS
SELECT
    member_casual,
    rideable_type,
    ride_month,
    day_of_week,
    day_name,
    COUNT(*) AS total_rides,
    AVG(CAST(ride_length_minutes AS FLOAT)) AS avg_ride_minutes
FROM dbo.bike_trips_clean
WHERE ride_length_minutes > 0
GROUP BY
    member_casual, rideable_type, ride_month, day_of_week, day_name;
GO


-- Bike type behavior
CREATE OR ALTER VIEW dbo.vw_bike_type_behavior AS
SELECT
    rideable_type,
    member_casual,
    ride_month,
    day_of_week,
    day_name,
    COUNT(*) AS total_rides,
    AVG(CAST(ride_length_minutes AS FLOAT)) AS avg_duration
FROM dbo.bike_trips_clean
WHERE ride_length_minutes > 0
GROUP BY
    rideable_type, member_casual, ride_month, day_of_week, day_name;
GO


-- Rides by hour 
CREATE OR ALTER VIEW dbo.vw_rides_by_hour AS
SELECT
    ride_hour,
    member_casual,
    rideable_type,
    ride_month,
    day_of_week,
    day_name,
    COUNT(*) AS total_rides,
    AVG(CAST(ride_length_minutes AS FLOAT)) AS avg_duration
FROM dbo.bike_trips_clean
WHERE ride_length_minutes > 0
GROUP BY
    ride_hour, member_casual, rideable_type, ride_month, day_of_week, day_name;
GO


-- Ride duration segments
CREATE OR ALTER VIEW dbo.vw_ride_duration_segments AS
SELECT
    CASE 
        WHEN ride_length_minutes < 10 THEN 'Short (<10m)'
        WHEN ride_length_minutes BETWEEN 10 AND 30 THEN 'Medium (10�30m)'
        ELSE 'Long (30m+)'
    END AS duration_segment,
    member_casual,
    rideable_type,
    ride_month,
    day_of_week,
    day_name,
    COUNT(*) AS total_rides
FROM dbo.bike_trips_clean
WHERE ride_length_minutes > 0
GROUP BY
    CASE 
        WHEN ride_length_minutes < 10 THEN 'Short (<10m)'
        WHEN ride_length_minutes BETWEEN 10 AND 30 THEN 'Medium (10�30m)'
        ELSE 'Long (30m+)'
    END,
    member_casual, rideable_type, ride_month, day_of_week, day_name;
GO


-- Seasonal trends
CREATE OR ALTER VIEW dbo.vw_seasonal_trends AS
SELECT
    ride_month,
    member_casual,
    rideable_type,
    day_of_week,
    day_name,
    COUNT(*) AS total_rides,
    AVG(CAST(ride_length_minutes AS FLOAT)) AS avg_duration
FROM dbo.bike_trips_clean
WHERE ride_length_minutes > 0
GROUP BY
    ride_month, member_casual, rideable_type, day_of_week, day_name;
GO

-- Top start stations by rider type
CREATE OR ALTER VIEW dbo.vw_top_stations_by_rider AS
SELECT
    start_station_name,
    member_casual,
    rideable_type,
    ride_month,
    day_of_week,
    day_name,
    COUNT(*) AS total_rides,
    AVG(CAST(ride_length_minutes AS FLOAT)) AS avg_duration
FROM dbo.bike_trips_clean
WHERE start_station_name IS NOT NULL
  AND LTRIM(RTRIM(start_station_name)) <> ''
  AND ride_length_minutes > 0
GROUP BY
    start_station_name, member_casual, rideable_type, ride_month, day_of_week, day_name;
GO


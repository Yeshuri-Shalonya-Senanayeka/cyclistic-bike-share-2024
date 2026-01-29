/*
PROJECT: Cyclistic / Bike Share Case Study (Google Data Analytics)
AUTHOR:  Yeshuri Shalonaya Senanayeka

FILE: 02_cleaning.sql
Purpose:
  Validate staging data quality before transforming into typed fact table.
  This file contains checks only (no transformations).
*/

USE BikeShareAnalysis;
GO

-- Basic volume checks
SELECT COUNT(*) AS stage_total_rows
FROM dbo.bike_trips_stage;

SELECT TOP 100 *
FROM dbo.bike_trips_stage;

-- Null profiling
SELECT
    SUM(CASE WHEN ride_id IS NULL THEN 1 ELSE 0 END) AS null_ride_id,
    SUM(CASE WHEN rideable_type IS NULL THEN 1 ELSE 0 END) AS null_rideable_type,
    SUM(CASE WHEN started_at IS NULL THEN 1 ELSE 0 END) AS null_started_at,
    SUM(CASE WHEN ended_at IS NULL THEN 1 ELSE 0 END) AS null_ended_at,
    SUM(CASE WHEN member_casual IS NULL THEN 1 ELSE 0 END) AS null_member,
    SUM(CASE WHEN start_station_name IS NULL THEN 1 ELSE 0 END) AS null_start_station,
    SUM(CASE WHEN end_station_name IS NULL THEN 1 ELSE 0 END) AS null_end_station,
    SUM(CASE WHEN start_lat IS NULL THEN 1 ELSE 0 END) AS null_start_lat,
    SUM(CASE WHEN start_lng IS NULL THEN 1 ELSE 0 END) AS null_start_lng,
    SUM(CASE WHEN end_lat IS NULL THEN 1 ELSE 0 END) AS null_end_lat,
    SUM(CASE WHEN end_lng IS NULL THEN 1 ELSE 0 END) AS null_end_lng
FROM dbo.bike_trips_stage;

-- duplicate check on ride_id
SELECT ride_id, COUNT(*) AS cnt
FROM dbo.bike_trips_stage
WHERE ride_id IS NOT NULL
GROUP BY ride_id
HAVING COUNT(*) > 1
ORDER BY cnt DESC;
GO

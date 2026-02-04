
/*
---================================================================
--Gold Layer: Divvy Trips 2025
--=================================================================
  Purpose: 
  This layer presents the views for Business logic and reporting
  of some different frames in the Cyclista - Divvy Trips case study
  */
--==================================================================

CREATE VIEW gold.avg_ride_time_by_dow AS

WITH day_of_week_avg AS(
		SELECT 
			member_casual, 
			rideable_type, 
			day_of_week, 
			day,
			AVG(CAST(ride_length_seconds AS FLOAT)) AS avg_trip_sec
		FROM silver.divvy_trips_2025
		WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
		GROUP BY member_casual, rideable_type, day_of_week, day
		),
	totals AS(
		SELECT 
			*, 
			SUM(avg_trip_sec) OVER(PARTITION BY rideable_type) AS total_avg_by_ride_type,
			SUM(avg_trip_sec) OVER() AS grand_total_avg	
		FROM day_of_week_avg
		)
SELECT  member_casual, 
		rideable_type,
		day_of_week,
		day,
		avg_trip_sec,
		avg_trip_sec/total_avg_by_ride_type AS pct_within_ride_type,
		avg_trip_sec/grand_total_avg AS pct_of_all_time
FROM totals; 

-- This is the percent distribution of trips in a day_of_week frame relative to ride types, rider types
-- expressed as proportions

--=====================================================================================
CREATE VIEW gold.avg_ride_time_by_month AS
SELECT 
    member_casual,
    rideable_type,
    DATENAME(MONTH, started_at) AS trip_month,
    MONTH(started_at) AS trip_month_num,
    AVG(CAST(ride_length_seconds AS FLOAT)) AS avg_trip_sec
FROM silver.divvy_trips_2025
WHERE ride_length_seconds BETWEEN 1 AND 90000
GROUP BY 
    member_casual,
    rideable_type,
    DATENAME(MONTH, started_at),
    MONTH(started_at);

-- this shows the monthly to seasonal trends of average ride lengths or duration
--===================================================================================
CREATE VIEW gold.ride_composition_by_rider_and_bike AS
WITH BaseAgg AS (
    SELECT 
        member_casual,
        rideable_type,
        COUNT(*) AS ride_count_per_group,
        AVG(CAST(ride_length_seconds AS FLOAT)) AS avg_ride_seconds
    FROM silver.divvy_trips_2025
    WHERE ride_length_seconds BETWEEN 1 AND 90000
    GROUP BY member_casual, rideable_type
),
MetricNorm AS (
    SELECT 
        member_casual,
        rideable_type,
        ride_count_per_group,
        avg_ride_seconds,
        SUM(ride_count_per_group) OVER (PARTITION BY rideable_type) AS rideable_type_total,
        SUM(ride_count_per_group) OVER () AS grand_total
    FROM BaseAgg

)
SELECT 
    member_casual,
    rideable_type,
    ride_count_per_group,
    ride_count_per_group * 1.0 / grand_total AS count_pct_of_all_rides,
    ride_count_per_group * 1.0 / rideable_type_total AS count_pct_within_ride_type,
    avg_ride_seconds
FROM MetricNorm;

--This shows a ride count view per group along with duration
--=========================================================================

CREATE VIEW gold.ride_count_per_trip_diversity AS

WITH 
trip_diversity AS 
    (
     SELECT
        member_casual,
        start_station_name,
           CASE
                WHEN start_station_name = end_station_name
                THEN 'round_trip'
                ELSE 'another_destination'
            END AS trip_diversity
    FROM silver.divvy_trips_2025
    WHERE start_station_name IS NOT NULL
      AND end_station_name IS NOT NULL
    )
SELECT
        member_casual,
        start_station_name,
        trip_diversity,
        COUNT(*)  AS ride_count
FROM trip_diversity
GROUP BY member_casual, start_station_name, trip_diversity;

-- Shows the count of trips of rider, ride and trip diversity
--======================================================================

CREATE VIEW gold.net_flow_between_stations AS

WITH station_flows AS (
    SELECT
        member_casual,
        start_station_name AS station_name,
        COUNT(*) AS start_count,
        0 AS end_count
    FROM silver.divvy_trips_2025
    WHERE start_station_name IS NOT NULL
    GROUP BY member_casual, start_station_name

    UNION ALL -- no distinct groups, start_station and end_station become uniform
			  -- aggregate counts

    SELECT
        member_casual,
        end_station_name AS station_name,
        0 AS start_count,
        COUNT(*) AS end_count
    FROM silver.divvy_trips_2025
    WHERE end_station_name IS NOT NULL
    GROUP BY member_casual, end_station_name
),
station_balance AS (
    SELECT
        member_casual,
        station_name, 
		-- station based, made uniform, determining the unique counts of each rider's trip at each station
        SUM(start_count) AS start_st_count,
        SUM(end_count) AS end_st_count
    FROM station_flows
    WHERE station_name IS NOT NULL
    GROUP BY member_casual, station_name
)
SELECT
    member_casual,
    station_name,
    start_st_count,
    end_st_count,
    end_st_count - start_st_count AS net_inflow,
	--the net_inflow focuses on count based on rider type at each station
	 CASE
        WHEN end_st_count > start_st_count THEN 'net_inflow'
        WHEN end_st_count < start_st_count THEN 'net_outflow'
        ELSE 'balanced'
    END AS flow_type
FROM station_balance;

-- ====================================================================
CREATE VIEW gold.divvy_story_summary AS
WITH base_metrics AS (
    SELECT 
        member_casual,
        rideable_type,
        DATENAME(MONTH, started_at) AS trip_month,
        DATEPART(MONTH, started_at) AS month_num,
        day,
        day_of_week,
        COUNT(*) AS trip_count,
        AVG(CAST(ride_length_seconds AS FLOAT)) AS avg_ride_sec
    FROM silver.divvy_trips_2025
    WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
    GROUP BY member_casual, rideable_type, DATENAME(MONTH, started_at), DATEPART(MONTH, started_at), day, day_of_week
)
SELECT 
    *,
    AVG(avg_ride_sec) OVER(PARTITION BY member_casual) AS member_global_avg,
    RANK() OVER(PARTITION BY trip_month ORDER BY trip_count DESC) AS popularity_rank
FROM base_metrics;

/* Next Steps: Prepare data for visualization */

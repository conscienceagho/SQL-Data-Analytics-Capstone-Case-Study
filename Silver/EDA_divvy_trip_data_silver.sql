/*
-------------------------------------------------------------
Silver Layer Exploratory Data Analysis
-------------------------------------------------------------
Purpose: 
This folder contains analysis queries, cleaned, typed, divvy
trip data. It answere questions about ride patterns, rider behaviour,
trip duration, and station flows.
Note: The 'rider' or 'biker' are of the member_casual group
and the 'ride' is of the rideable_type group
-----------------------------------------------------------
*/
-- ========================================================
-- Total Rider Count
-- ========================================================

SELECT COUNT (*) AS total_rider_count
FROM silver.divvy_trips_2025
--total_rider_count 5354697

-- ========================================================
-- Total Riders by Membership Type
-- ========================================================

SELECT member_casual, COUNT (*) AS rider_count
FROM silver.divvy_trips_2025
GROUP BY member_casual;

--member 	3446072
--casual 	1908625

-- ========================================================
-- Total Riders by Membership Type and Ride
-- ========================================================

SELECT rideable_type, member_casual, COUNT(*) AS ride_type_count
FROM silver.divvy_trips_2025
GROUP BY rideable_type, member_casual
ORDER BY ride_type_count DESC

--rideable_type	member_casual	ride_type_count
--electric_bike	member			2173998
--classic_bike	member			1272074
--electric_bike	casual			1241648
--classic_bike	casual			666977

--Electric bikes are more popular or preferred than classic bikes among members as well as casual riders

-- ========================================================
-- Descriptive statistics
-- ========================================================  
*Deliverable: HH:MM:ss date format*
-- ========================================================
-- Earliest start and stop times by biker
-- ========================================================
 
SELECT	
		member_casual,
		MIN(started_at) AS earliest_start, 
		MIN(ended_at) AS earliest_end, 
		MAX(started_at) AS latest_start,
		MAX(ended_at) AS latest_end
FROM silver.divvy_trips_2025
GROUP BY member_casual

-- member_casual	earliest_start		      earliest_end		      latest_start		      latest_end
-- member 			  2024-12-31 23:21:00	    2025-01-01 00:00:00	  2025-12-31 23:53:00	  2025-12-31 23:57:00
-- casual 			  2024-12-31 18:54:00	    2025-01-01 00:00:00	  2025-12-31 23:49:00	  2025-12-31 23:58:00

-- casual riders had over 5hrs head start compared to member riders who can start riding late

-- ========================================================
-- Earliest start and stop times by biker and ride type
-- ========================================================
SELECT	
		member_casual,
		rideable_type,
		MIN(started_at) AS earliest_start, 
		MIN(ended_at) AS earliest_end, 
		MAX(started_at) AS latest_start,
		MAX(ended_at) AS latest_end
FROM silver.divvy_trips_2025
GROUP BY member_casual, rideable_type;

--member_casual	    rideable_type	                earliest_start	      earliest_end		      latest_start	      	latest_end
--casual 		        classic_bike	                2024-12-31 18:54:00	  2025-01-01 00:04:00	  2025-12-31 23:46:00	  2025-12-31 23:55:00
--casual 		        electric_bike	                2024-12-31 23:13:00	  2025-01-01 00:00:00	  2025-12-31 23:49:00	  2025-12-31 23:58:00
--member 	        	classic_bike	                2024-12-31 23:33:00	  2025-01-01 00:06:00	  2025-12-31 23:53:00	  2025-12-31 23:55:00
--member 		        electric_bike	                2024-12-31 23:21:00	  2025-01-01 00:00:00	  2025-12-31 23:53:00	  2025-12-31 23:57:00

-- The casual-classic bike ride group have the earliest starts refractory to all rideable type groups
-- ========================================================
-- Maximum and Minimum Trip Duration 
-- ========================================================

SELECT Max (ride_length_seconds) max_ride_seconds,
		Max (ride_length_seconds)/3600.0 max_ride_hour,                
		Min (ride_length_seconds) min_ride_seconds,
		Min (ride_length_seconds)/3600.0 min_ride_hour
FROM silver.divvy_trips_2025;

-- filtering for rides > 0secs and < 25 hrs or 90000 seconds

SELECT Max (ride_length_seconds) max_ride_seconds,
		Max (ride_length_seconds)/3600.0 max_ride_hour,
		Min (ride_length_seconds) min_ride_seconds,
		Min (ride_length_seconds)/3600.0 min_ride_hour
FROM silver.divvy_trips_2025
WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000;
-- max_ride_seconds		max_ride_hours	min_ride_seconds	min_ride_hour
-- 89940				24.983333		1					0.000277
 
-- ========================================================
-- Average Trip Duration per member or casual groups
-- ========================================================

SELECT 
	member_casual, 
	AVG (CAST(ride_length_seconds AS FLOAT))/ 60.0 AS average_ride_minutes,
	CONVERT(VARCHAR, DATEADD(SECOND, CAST(AVG (CAST(ride_length_seconds AS FLOAT)) AS INT), 0 ), 108) AS formatted_avg_rl
FROM silver.divvy_trips_2025
WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
GROUP BY member_casual                                                 

--member_casual	    average_ride_minutes	formatted_avg_rl
--member 		        12.488990031074			  00:12:29	
--casual 		        19.0807984232874		  00:19:04	

	-- casual riders ride 6 mins 35 seconds more than members

-- ========================================================
-- Average Trip Duration per biker and ride groups
-- ========================================================

SELECT 
	member_casual, 
	rideable_type,
	AVG (CAST(ride_length_seconds AS FLOAT))/ 60.0 AS Average_ride_minutes,            
	CONVERT(VARCHAR, DATEADD(SECOND, CAST(AVG(CAST (ride_length_seconds AS FLOAT)) AS INT), 0), 108) AS formatted_avg_rl
FROM silver.divvy_trips_2025
WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
GROUP BY member_casual, rideable_type
ORDER BY formatted_avg_rl DESC

--member_casual	rideable_type	    Average_ride_minutes	  formatted_avg_rl
--casual		classic_bike	        27.2736192306846			  00:27:16
--casual		electric_bike	        14.5461500917185				00:14:32
--member		classic_bike	        13.9961755614446				00:13:59
--member		electric_bike	        11.5917992777466				00:11:35

--Casual classic bike riders have an average trip duration of almost twice the casual-electric bike riders even with the 
----preference for electric bikes. 

-- ========================================================
-- Weekly Trends
-- ========================================================
-- ========================================================
-- Average ride duration per day of week
-- ========================================================
SELECT AVG(ride_length_seconds) AS average_trips_per_dow, day_of_week, day
FROM silver.divvy_trips_2025
GROUP BY day_of_week, day
ORDER BY average_trips_per_dow DESC

-- average_trips_per_dow	day_of_week		day
--	1053					        1				      Sunday
--	1032					        7				      Saturday
--	877						        6				      Friday
--	837						        2				      Monday
--	795						        3				      Tuesday
--	793					        	5				      Thursday
--	762					        	4				      Wednesday
 
--In that order, Sunday and Saturday are weekend days serving as the days in which the most trips are travelled
  
-- ========================================================
-- Average ride seconds per day of week foir members
-- ========================================================

SELECT CONCAT(AVG(ride_length_seconds), 'sec') AS member_average_rl, day_of_week, day
FROM silver.divvy_trips_2025
WHERE member_casual = 'member' 
	AND ride_length_seconds > 0 
	AND ride_length_seconds < 90000
GROUP BY day_of_week, day
ORDER BY  AVG(ride_length_seconds) DESC


--member_average_rl	day_of_week	day
--847sec	          1	          Sunday
--837sec	          7	          Saturday
--744sec	          6	          Friday
--721sec	          3	          Tuesday
--721sec	          2	          Monday
--713sec	          5	          Thursday
--702sec	          4          	Wednesday

-- ========================================================
-- Average ride duration by riders by weekend groups
-- ========================================================

WITH  daily_trip_sec_avg AS
	(
	SELECT 
		member_casual, 
		AVG(ride_length_seconds) AS average_rl, 
		day_of_week, 
		day   
	FROM silver.divvy_trips_2025
	WHERE ride_length_seconds > 0 
		AND ride_length_seconds < 90000
	GROUP BY day_of_week, day, member_casual
	)
SELECT
	SUM(average_rl) AS total_weekend_seconds, member_casual,
	CONVERT(VARCHAR, DATEADD(SECOND, CAST(SUM(average_rl) AS INT), 0), 108) AS weekend_seconds_f
	FROM daily_trip_sec_avg
	WHERE day in ('Sunday', 'Saturday')
	GROUP BY member_casual

	-- weekend_seconds	member_casual	weekend_seconds_f
	-- 2639				      casual			00:43:59
	-- 1684				      member			00:28:04
  
-- ========================================================
-- Average ride duration by riders by weekday groups
-- ========================================================

WITH  daily_trip_sec_avg AS (
	SELECT member_casual, AVG(ride_length_seconds) AS average_rl, day_of_week, day
	FROM silver.divvy_trips_2025
	WHERE ride_length_seconds > 0 
		AND ride_length_seconds < 90000
	GROUP BY day_of_week, day, member_casual
	)
SELECT
	SUM(average_rl) AS weekday_seconds, member_casual,
	CONVERT(VARCHAR, DATEADD(SECOND, CAST(SUM(average_rl) AS INT), 0), 108) AS formated_weekday_seconds
	FROM daily_trip_sec_avg
	GROUP BY member_casual

	-- weekday_seconds	member_casual	formated_weekday_seconds
	-- 4072				      casual		  	01:07:52
	-- 2857				      member		  	00:47:37
  
-- ========================================================
-- Average ride duration by riders by weekend groups framed as percentages
-- ========================================================
WITH  daily_trip_sec_avg AS (
	SELECT 
		member_casual, 
		AVG(CAST(ride_length_seconds AS FLOAT)) AS average_rl,
		day_of_week, 
		day
	FROM silver.divvy_trips_2025
	WHERE ride_length_seconds > 0 
		AND ride_length_seconds < 90000
	GROUP BY day_of_week, day, member_casual
	),
total_trip_time_avg AS (
	SELECT *,
		SUM(average_rl) OVER () AS total_average_rl
	FROM daily_trip_sec_avg
	)
SELECT 
		member_casual,
		day, 
		CONCAT(CAST(average_rl * 100.0/ total_average_rl AS DECIMAL(10,2)), '%') AS weekend_rl_perc_of_sum
	FROM total_trip_time_avg 
	WHERE day IN ('Saturday', 'Sunday')
	ORDER BY member_casual, average_rl DESC;

	--member_casual		day			weekend_rl_perc_of_sum
	--casual			  Sunday		10.20%
	--casual			  Saturday	9.89%
	--member			  Sunday		6.45%
	--member			  Saturday	6.37%

-- ========================================================
-- Average ride duration by riders by weekday groups as percentages
-- ========================================================

	WITH  daily_trip_sec_avg AS (
	SELECT 
		member_casual, 
		AVG(CAST(ride_length_seconds AS FLOAT)) AS average_rl,
		day_of_week, 
		day
	FROM silver.divvy_trips_2025
	WHERE ride_length_seconds > 0 
		AND ride_length_seconds < 90000
	GROUP BY day_of_week, day, member_casual
	),
total_trip_time_avg AS (
	SELECT *,
		SUM(average_rl) OVER () AS total_average_rl
	FROM daily_trip_sec_avg
	)
SELECT 
		member_casual,
		day, 
		CONCAT(CAST(average_rl * 100.0/ total_average_rl AS DECIMAL(10,2)), '%') AS weekday_rl_perc_of_sum
	FROM total_trip_time_avg 
	WHERE day IN ('Monday', 'Tuesday', 'Thursday','Wednesday' )
	ORDER BY member_casual, average_rl DESC;

--member_casual		day				weekday_rl_perc_of_sum
--casual				Monday			8.51%
--casual				Tuesday			7.68%
--casual				Thursday		7.64%
--casual				Wednesday		7.18%
--member				Monday			5.49%
--member				Tuesday			5.49%
--member				Thursday		5.43%
--member				Wednesday		5.35%

-- ========================================================
-- Framing the ride time percentages as a percent of the ride group and the 
----total sum-average trip duration
-- ========================================================


WITH day_of_week_avg AS(
		SELECT 
			member_casual, 
			rideable_type, 
			AVG(CAST(ride_length_seconds AS FLOAT)) AS daily_trip_sec_avg, 
			-- each avg ride_length for rider type, rideable type and day_of_week grouping
			day_of_week, 
			day
		FROM silver.divvy_trips_2025
		WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
		GROUP BY member_casual, rideable_type, day_of_week, day
		),
	totals AS(
		SELECT 
			*, 
			SUM(daily_trip_sec_avg) OVER(PARTITION BY rideable_type) AS total_avg_sum_by_ride,
			-- Sum average of all rider types grouped by by rideable_type for the year
			SUM(daily_trip_sec_avg) OVER() AS grand_total_avg				
			-- sum average  of all groups for the year 
		FROM day_of_week_avg
		)
SELECT  member_casual, 
		rideable_type,
		day,
		CONVERT(VARCHAR, DATEADD(SECOND, CAST(daily_trip_sec_avg AS INT), 0), 108) AS avg_duration_clock,
		CONCAT(CAST(daily_trip_sec_avg * 100.0 / total_avg_sum_by_ride AS DECIMAL(10,2)), '%') AS ride_time_per_rideable_type,
		CONCAT(CAST(daily_trip_sec_avg * 100.0/ grand_total_avg AS DECIMAL(10,2)), '%') AS ride_time_per_grand_total_avg
FROM totals
ORDER BY daily_trip_sec_avg DESC;

-- member_casual	rideable_type	day		avg_duration_clock     ride_time_per_rideable_type ride_time_per_grand_total_avg
--casual 			classic_bike	Sunday		00:30:47	             10.80%                      	6.59%
--casual 			classic_bike	Saturday	00:29:52	             10.48%                      	6.39%
--casual 			classic_bike	Friday		00:27:23	              9.61%	                      5.86%
--casual 			classic_bike	Monday		00:26:26              	9.28%	                      5.66%
--casual 			classic_bike	Tuesday		00:24:33              	8.62%	                      5.26%
--casual 			classic_bike	Thursday	00:24:28	              8.59%                      	5.24%
--casual 			classic_bike	Wednesday	00:22:47	              7.99%                      	4.88%
-- ...

--9 out of 28 times, the casual classic bike rider shows up more throughout the week more than any other bike groups

-- ========================================================
-- Monthly Trends
-- ========================================================
-- ========================================================
-- Trip count by month
-- ========================================================

SELECT DATENAME(MONTH, started_at) AS Trip_month, COUNT(*) AS trips_per_month
FROM silver.divvy_trips_2025
WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
GROUP BY DATENAME(MONTH, started_at)
ORDER BY trips_per_month DESC

--Trip_month	trips_per_month
--July			  747495
--September		702214
--June			  664355
--October		  635076
--August	  	599500
--May			    494007
--April		  	365784
--November		350409
--March		  	293667
--February		150141
--December		137876
--January		  136870

-- ========================================================
-- Trip Duration by month
-- ========================================================

SELECT DATENAME(MONTH, started_at) AS Trip_month, 
	CONVERT(VARCHAR, DATEADD(SECOND, CAST(AVG(ride_length_seconds)AS INT), 0), 108) AS  avg_rl_per_month
FROM silver.divvy_trips_2025
WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
GROUP BY DATENAME(MONTH, started_at)
ORDER BY avg_rl_per_month DESC

--Trip_month	  avg_rl_per_month
--August		    00:17:19
--June			    00:16:31
--July			    00:16:27
--September	  	00:15:02
--May			      00:15:00
--October	    	00:14:03
--April		    	00:13:20
--March			    00:12:57
--November	  	00:12:31
--December	  	00:11:50
--February	  	00:10:20
--January		    00:10:17
  
-- ========================================================
-- Trip Duration by rider group and month
-- ========================================================

WITH month_avg AS
	(
	SELECT 
		   member_casual,
		   DATENAME(MONTH, started_at) AS Trip_month, 
		   AVG(CAST (ride_length_seconds AS FLOAT)) AS avg_rl_per_month
		FROM silver.divvy_trips_2025
		WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
		GROUP BY member_casual,  DATENAME(MONTH, started_at)
	)
SELECT 
	member_casual,
	Trip_month,
	CONVERT(NVARCHAR, DATEADD (SECOND,CAST(SUM(avg_rl_per_month) AS INT), 0), 108)  AS group_avg_rl_per_month
FROM month_avg
GROUP BY member_casual, Trip_month
ORDER BY group_avg_rl_per_month DESC
  
--member_casual	Trip_month	group_avg_rl_per_month
--casual		     August		  00:23:14
--casual		     July		    00:21:07
--casual		     May		  	00:20:33
--casual		     September	00:19:19
--casual		     April	  	00:18:29
--casual		     October		00:17:51
--casual	       March		  00:17:41
--casual	       June		    00:16:50
--member		     June		    00:16:17
--casual		     November  	00:14:53
--member		     July		    00:13:05
--member		     August	  	00:13:02
--casual		     December  	00:12:45
--member		     September	00:12:32
--casual		     February  	00:12:16
--member		     October		00:12:04
--casual		     January		00:11:59
--member	       May			  00:11:52
--member		     November	  00:11:37
--member		     December	  00:11:36
--member		     April		  00:11:13
--member		     March		  00:11:04
--member	     	January		  00:09:55
--member	     	February	  00:09:54

-- ========================================================
-- 1st quarter sample filter
-- ========================================================

WITH month_avg AS
	(
	SELECT 
		   member_casual,
		   DATENAME(MONTH, started_at) AS Trip_month, 
		   AVG(CAST (ride_length_seconds AS FLOAT)) AS avg_rl_per_month
		--CONVERT(VARCHAR, (DATEADD(SECOND, CAST(AVG(ride_length_seconds)AS INT), 0), 108) AS  avg_rl_per_month
		FROM silver.divvy_trips_2025
		WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
		GROUP BY member_casual,  DATENAME(MONTH, started_at)
	)
SELECT 
	member_casual,
	Trip_month,
	CONVERT(NVARCHAR, DATEADD (SECOND,CAST(SUM(avg_rl_per_month) AS INT), 0), 108)  AS group_avg_rl_per_month
FROM month_avg
	WHERE Trip_month in ('January','February', 'March')
GROUP BY member_casual, Trip_month
ORDER BY group_avg_rl_per_month DESC

--member_casual	  Trip_month	group_avg_rl_per_month
--casual		      March		    00:17:27
--casual		      February  	00:12:07
--casual		      January	  	00:11:49
--member		      March		    00:10:58
--member		      January	  	00:09:51
--member	      	February  	00:09:49
-- ========================================================
-- Monthly Trip Duration by ride type of rideable group
-- ========================================================
	WITH month_avg AS
	(
	SELECT 
		   member_casual,
		   rideable_type,
		   DATENAME(MONTH, started_at) AS Trip_month, 
		   AVG(CAST (ride_length_seconds AS FLOAT)) AS avg_rl_per_rt
		FROM silver.divvy_trips_2025
		WHERE ride_length_seconds > 0 AND ride_length_seconds < 90000
		GROUP BY member_casual,  DATENAME(MONTH, started_at), rideable_type
	)
SELECT 
	member_casual,
	Trip_month,
	rideable_type,
	CONVERT(VARCHAR, DATEADD (SECOND,CAST(avg_rl_per_rt AS INT), 0), 108)  AS group_avg_rl_per_rt_per_month
FROM month_avg
ORDER BY group_avg_rl_per_rt_per_month DESC
--member_casual	Trip_month	rideable_type	group_avg_rl_per_rt_per_month
--casual			    January		classic_bike	00:19:53
--casual			    June		  classic_bike	00:18:19
--member			    June		  classic_bike	00:17:13
--casual			    August		electric_bike	00:16:48
--casual		    	June		  electric_bike	00:15:56
--casual		    	July		  electric_bike	00:15:55
--member		    	June		  electric_bike	00:15:43
-...

-- ========================================================
--Total count of rides to count of start stations
-- ========================================================
SELECT
    COUNT(*) AS total_rides,
    COUNT(DISTINCT start_station_name) AS unique_stations
FROM silver.divvy_trips_2025

--total_rides	unique_stations
--5354697		1098330
-- ========================================================
-- Spatial Behaviour by start and stop destinations
-- ========================================================
-- ========================================================
-- Top 5 start stations by biker trip counts
-- ========================================================

SELECT TOP (5)
  member_casual, start_station_name, COUNT(*) AS ride_count
   --CAST(AVG(ride_length) AS FLOAT) OVER(PARTITION BY member_type) AS tl_station_att
FROM silver.divvy_trips_2025
WHERE start_station_name IS NOT NULL
GROUP BY  member_casual, start_station_name
ORDER BY  ride_count DESC

--member_casual	start_station_name					      ride_count
--casual	    	DuSable Lake Shore Dr & Monroe St	30644
--member	    	Kingsbury St & Kinzie St			    30612
--casual	    	Navy Pier							            26498
--member	    	Clinton St & Washington Blvd	  	25220
--casual	    	Streeter Dr & Grand Ave				    23595

-- ========================================================
-- Total ount of trips by rider_type in end_station
-- ========================================================

SELECT
   member_casual, end_station_name, COUNT(*) AS ride_count
   --CAST(AVG(ride_length) AS FLOAT) OVER(PARTITION BY member_type) AS tl_station_att
FROM silver.divvy_trips_2025
WHERE start_station_name IS NOT NULL
GROUP BY  member_casual, end_station_name
ORDER BY ride_count DESC
  
--member_casual		end_station_name		      ride_count
--member	Kingsbury St & Kinzie St			    31347
--casual	DuSable Lake Shore Dr & Monroe St	29119
--casual	Navy Pier						            	28099
--member	Clinton St & Washington Blvd	  	24842
--casual	Streeter Dr & Grand Ave			    	24514

-- ========================================================
-- Total ount of trips by rider_type in end_station
-- ========================================================

WITH trips AS (
    SELECT
        member_casual,
        start_station_name,
        CASE
            WHEN start_station_name = end_station_name
            THEN 'round_trip'
            ELSE 'another_destination'
        END AS trip_versity
    FROM silver.divvy_trips_2025
    WHERE start_station_name IS NOT NULL
      AND end_station_name IS NOT NULL
)
SELECT TOP (5)
    member_casual,
    start_station_name,
    COUNT(*) AS round_trip_ride_count
FROM trips
WHERE trip_versity = 'round_trip'
GROUP BY member_casual, start_station_name
ORDER BY ride_count DESC;

--Of 158801 round_trippers, top 5 locations:

--member_casual	start_station_name					      round_trip_ride_count
--casual	    	DuSable Lake Shore Dr & Monroe St	6302
--casual	    	Navy Pier							            5366
--casual	    	Streeter Dr & Grand Ave		    		4025
--casual	    	Michigan Ave & Oak St			      	3947
--casual	    	Millennium Park						        2729


--differences in trips between count at end_station and count at start_station for each 
--member_casual group

-- ========================================================
-- Busiest day of the week for the top 5 stations
-- ========================================================
SELECT
   TOP (5) member_casual, start_station_name,day, COUNT(*) AS ride_count
FROM silver.divvy_trips_2025
WHERE start_station_name IS NOT NULL
GROUP BY  member_casual, start_station_name,day
ORDER BY  ride_count DESC

--member_casual		start_station_name					      day		    ride_count
--casual			    DuSable Lake Shore Dr & Monroe St	Saturday	7258
--casual		    	Navy Pier						            	Saturday	6925
--casual			    DuSable Lake Shore Dr & Monroe St	Sunday		5841
--member		    	Clinton St & Washington Blvd	  	Tuesday		5609
--casual			    Streeter Dr & Grand Ave				    Saturday	5372

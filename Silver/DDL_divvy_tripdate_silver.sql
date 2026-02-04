/* 
---------------------------------------------------------

Silver Layer - Divvy Trips 2025
Medallion Architecture: Bronze -> Silver -> Gold

---------------------------------------------------------
Purpose: To maintain data integrity whilst moving data from the bronze frame
In the silver layer, the datatypes are transformed from the portability stage to the appropriate forms necessary
for cleaning and exploration.

The data analyst also applies the "Alter" DDL function to make changes and add new analytical columns

*/

IF OBJECT_ID ('silver.divvy_trips_2025') IS NOT NULL
BEGIN
    DROP TABLE silver.divvy_trips_2025
END
    CREATE TABLE silver.divvy_trips_2025 (

      ride_id                NVARCHAR(255) PRIMARY KEY,
      rideable_type          NVARCHAR(100), 
      started_at             DATETIME2,
      ended_at               DATETIME2, 
      start_station_name     NVARCHAR(500),  
      start_station_id       NVARCHAR(255),
      end_station_name       NVARCHAR(500),
      end_station_id         NVARCHAR(255),
      start_lat              DECIMAL(13,8),
      start_lng              DECIMAL(13,8),
      end_lat                DECIMAL(13,8),
      end_lng                DECIMAL(13,8),
      member_casual          NVARCHAR(100),
      DWH_create_date        DATETIME2 DEFAULT GETDATE()
  
      );
GO 

--Alterations

-- After the bronze table cleaning and exploration
-- Adding new columns
ALTER TABLE silver.divvy_trips_2025
ADD
    ride_length NVARCHAR(20),
    ride_length_seconds INT,
    day_of_week INT,
    day NVARCHAR(20);
GO

-- After the silver table cleaning and during data validation
-- Converting the dates from one form of datetime to another

ALTER TABLE silver.divvy_trips_2025
ALTER COLUMN started_at  DATETIME2(0);

ALTER TABLE silver.divvy_trips_2025
ALTER COLUMN ended_at    DATETIME2(0)

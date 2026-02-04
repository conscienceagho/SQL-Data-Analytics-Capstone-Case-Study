/*
------------------------------------------------------------------------------------
DDL Bronze Layer: The first step of the **Medallion Data Architecyure**
------------------------------------------------------------------------------------
Script Purpose:

In this stage, the schema is defined, data from *Excel* is migrated

using appropriate Data Definition Language (DDL), the datatype is aligned for portability,

and the source data's integrity  is preserved
------------------------------------------------------------------------------------
Note:  

No business logic or analytical transformations are done in this stage. End of entry to clarify the folder as normal. I am making subfolders the extension for the bronze, silver, and gold in the main branch is from "main" but when I open and attempt to edit by adding a "/Bronze/DDL...title, it says the folder already exists
----------------------------------------------------------------------------------------
*/

USE CyclistWarehouse;
GO

DROP TABLE IF EXISTS bronze.divvy2025;

CREATE TABLE bronze.divvy2025
(
	ride_id			NVARCHAR (100),
	rideable_type	NVARCHAR (100),
	started_at		NVARCHAR (100),
	ended_at		NVARCHAR (100),
	start_station_name	NVARCHAR (200),
	start_station_id	NVARCHAR (100),
	end_station_name	NVARCHAR (200),
	end_station_id		NVARCHAR (100),
	start_lat		NVARCHAR (100),
	start_lng		NVARCHAR (100),
	end_lat			NVARCHAR (100),
	end_lng			NVARCHAR (100),
	member_casual   NVARCHAR (100)
);
GO

 --   ROWTERMINATOR = '0x0a', -- Specifically targets the NewLine character
 --   FORMAT = 'CSV',         -- Helps handle quotes around text
 --   CODEPAGE = '65001',     -- UTF-8 encoding

BULK INSERT bronze.divvy2025 
FROM 'C:\sql_data\divvy_2025_01.csv' 
WITH (
      FIRSTROW = 2, 
      FIELDTERMINATOR = ',', 
      ROWTERMINATOR = '0x0a', 
      FORMAT = 'CSV', 
      TABLOCK);


BULK INSERT bronze.divvy2025 
FROM 'C:\sql_data\divvy_2025_02.csv' 
WITH (
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a', 
    FORMAT = 'CSV', 
    TABLOCK);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_03.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    FORMAT = 'CSV',         
    TABLOCK 
	);



BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_04.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FORMAT = 'CSV', 
    TABLOCK
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_05.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FORMAT = 'CSV',  
    TABLOCK 
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_06.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    FORMAT = 'CSV',  
    TABLOCK
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_07.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    FORMAT = 'CSV',  
    TABLOCK
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_08.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    FORMAT = 'CSV',      
    TABLOCK
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_09.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FORMAT = 'CSV',  
    TABLOCK
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_10.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    FORMAT = 'CSV',    
    TABLOCK
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_11.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    FORMAT = 'CSV',
    TABLOCK
	);


BULK INSERT bronze.divvy2025
FROM 'C:/sql_data/divvy_2025_12.csv'
WITH (
	FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a', 
    FORMAT = 'CSV',  
    TABLOCK
	);

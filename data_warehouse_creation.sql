/*
Data warehouse creation: This DDL creates a warehouse by removing other warehouses with the same 
name.
This DDL also creates schemas for each Medallion Layer
*/

USE MASTER;
GO
IF EXISTS (SELECT 1 FROM sys.databases
			WHERE name = 'CyclistWarehouse')
	BEGIN
		ALTER DATABASE CyclistWarehouse
		SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE CyclistWarehouse
	END
GO

	CREATE DATABASE CyclistWarehouse
GO


USE CyclistWarehouse;
GO
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;

--CREATE DATABASE
CREATE DATABASE [BitemporalExample]
GO

USE [BitemporalExample]

--CREATE TABLES
CREATE TABLE dbo.Employee
(
    [EmployeeID] int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED
  , [Name] nvarchar(100) NOT NULL
  , [Position] varchar(100) NOT NULL
  , [SysStart] datetime2 GENERATED ALWAYS AS ROW START
  , [SysEnd] datetime2 GENERATED ALWAYS AS ROW END
  , PERIOD FOR SYSTEM_TIME (SysStart, SysEnd)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.EmployeeHistory));
GO

CREATE TABLE dbo.HourlyRate
(
    [HourlyRateID] int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED
  , [EmployeeID] int NOT NULL FOREIGN KEY REFERENCES Employee(EmployeeID)
  , [HourlyRate] decimal (10,2) NOT NULL
  , [EffectiveFrom] datetime2 NOT NULL
  , [EffectiveTo] datetime2 NOT NULL
  , [SysStart] datetime2 GENERATED ALWAYS AS ROW START
  , [SysEnd] datetime2 GENERATED ALWAYS AS ROW END
  , PERIOD FOR SYSTEM_TIME (SysStart, SysEnd)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.HourlyRateHistory));
GO

CREATE TABLE dbo.WorkLog
(
    [WorkLogID] int IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED
  , [EmployeeID] int NOT NULL FOREIGN KEY REFERENCES Employee(EmployeeID)
  , [WorkDate] datetime2 NOT NULL
  , [MinutesWorked] int NOT NULL
  , [SysStart] datetime2 GENERATED ALWAYS AS ROW START
  , [SysEnd] datetime2 GENERATED ALWAYS AS ROW END
  , PERIOD FOR SYSTEM_TIME (SysStart, SysEnd)
 )
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.WorkLogHistory));
GO

--CREATE FUNCTIONS
CREATE FUNCTION ConvertMinutesToHours
(
	@minutes INT
)
RETURNS FLOAT
AS
BEGIN
	DECLARE @result FLOAT

	SELECT @result = ( CAST (@minutes AS FLOAT) / CAST (60 AS FLOAT) ) 

	RETURN @result
END
GO

--CREATE SPROCS
CREATE PROCEDURE PayrollReport
	@asAtDate DATETIME2
AS
BEGIN
	SELECT e.[Name], wl.WorkDate, dbo.ConvertMinutesToHours(wl.MinutesWorked) HoursWorked, hr.HourlyRate, dbo.ConvertMinutesToHours(wl.MinutesWorked) * hr.HourlyRate Pay
	FROM dbo.Employee FOR SYSTEM_TIME AS OF @asAtDate e
		INNER JOIN dbo.WorkLog FOR SYSTEM_TIME AS OF @asAtDate wl ON wl.EmployeeId = e.EmployeeId
		INNER JOIN dbo.HourlyRate FOR SYSTEM_TIME AS OF @asAtDate hr ON hr.EmployeeId = e.EmployeeId AND (hr.EffectiveFrom <= wl.WorkDate AND hr.EffectiveTo >= wl.WorkDate)
	ORDER BY e.[Name], wl.WorkDate
END
GO

--CREATE INITIAL ROWS
INSERT INTO dbo.Employee ([Name],[Position]) VALUES ('David Smith', 'Store Manager')
INSERT INTO dbo.Employee ([Name],[Position]) VALUES ('Laura Brown', 'Sales Assistant')
INSERT INTO dbo.Employee ([Name],[Position]) VALUES ('Paul Jones', 'Cashier')
GO

INSERT INTO dbo.HourlyRate ([EmployeeID],[HourlyRate],[EffectiveFrom],[EffectiveTo]) VALUES (1, 15, '1/1/2018', '12/31/2018')
INSERT INTO dbo.HourlyRate ([EmployeeID],[HourlyRate],[EffectiveFrom],[EffectiveTo]) VALUES (2, 12.50, '1/1/2018', '12/31/2018')
INSERT INTO dbo.HourlyRate ([EmployeeID],[HourlyRate],[EffectiveFrom],[EffectiveTo]) VALUES (3, 10, '1/1/2018', '12/31/2018')
INSERT INTO dbo.HourlyRate ([EmployeeID],[HourlyRate],[EffectiveFrom],[EffectiveTo]) VALUES (1, 16, '1/1/2019', '12/31/2019')
INSERT INTO dbo.HourlyRate ([EmployeeID],[HourlyRate],[EffectiveFrom],[EffectiveTo]) VALUES (2, 13.50, '1/1/2019', '12/31/2019')
INSERT INTO dbo.HourlyRate ([EmployeeID],[HourlyRate],[EffectiveFrom],[EffectiveTo]) VALUES (3, 11, '1/1/2019', '12/31/2019')
GO

INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (1,'1/2/2018', 240)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (2,'1/2/2018', 300)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (3,'1/2/2018', 270)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (1,'1/3/2018', 300)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (2,'1/3/2018', 360)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (3,'1/3/2018', 300)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (1,'1/2/2019', 240)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (2,'1/2/2019', 300)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (3,'1/2/2019', 270)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (1,'1/3/2019', 300)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (2,'1/3/2019', 360)
INSERT INTO dbo.WorkLog ([EmployeeID],[WorkDate],[MinutesWorked]) VALUES (3,'1/3/2019', 300)
GO
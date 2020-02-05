# Bitemporal example using SQL Server and EF Core

Payroll system use case

Run DatabaseSetup.sql to setup database and tables etc

Update BitemporalExampleContext.cs file, line 27, to match your connection database string

## Things demonstrated

-Setting up temporal and bitemporal tables in SQL Server 2016 and later, or Azure SQL Database
-Quering data (PayrollReport sproc)
-Quering using AsAtDate in EF Core
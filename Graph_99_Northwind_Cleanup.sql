/*
Adding Graph Structures

Cleanup

*/
USE Northwind
GO
DROP TABLE IF EXISTS dbo.CoWorker
GO
UPDATE dbo.Employees 
SET ReportsTo = NULL
WHERE EmployeeID = 2
DELETE Employees
WHERE EmployeeID > 9;
GO
DROP TABLE IF EXISTS dbo.WorksWith
DROP TABLE IF EXISTS dbo.ReportsTo
DROP TABLE IF EXISTS dbo.GraphEmployees;
GO
DBCC CHECKIDENT(Employees, RESEED, 9)

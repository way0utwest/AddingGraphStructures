/*
Adding Graph Structures

Add Graph for Employee hierarchy
*/
USE Northwind
GO
DROP TABLE IF EXISTS GraphEmployees;
GO
CREATE TABLE GraphEmployees (
  EmpID INT IDENTITY PRIMARY KEY,
  FirstName NVARCHAR(50) NOT NULL,
  LastName NVARCHAR(50) NOT NULL,
  Title VARCHAR(50)
) AS NODE;

INSERT INTO GraphEmployees (FirstName, LastName, Title)
 SELECT FirstName,
        LastName,
        Title
  FROM dbo.Employees

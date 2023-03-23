/*
Adding Graph Structures - Northwind Hierarchy Modeling in a relational structure

This code implements a hierarchy and the works with structure using relational tables
and modeling techniques.

Steve Jones, copyright 2022

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.
*/
USE Northwind
GO

-- Basic query of employees reporting to others
SELECT e.EmployeeID,
       e.FirstName + ' ' + e.LastName + ', ' + e.Title AS Employee,
       e2.FirstName + ' ' + e2.LastName + ', ' + e2.Title AS ReportsTo
FROM Employees e
    INNER JOIN dbo.Employees e2
        ON e.ReportsTo = e2.EmployeeID;
GO
        
-- Let's add another layer
INSERT dbo.Employees
(
    LastName,
    FirstName,
    Title,
    ReportsTo
	)
VALUES
(   N'Jones',	-- LastName - nvarchar(20)
    N'Steve',	-- FirstName - nvarchar(10)
    'President', -- Title - nvarchar(30)
    NULL		 -- ReportsTo - int
    )
, (   N'Jones',  -- LastName - nvarchar(20)
    N'Tia',  -- FirstName - nvarchar(10)
    'CEO',	-- Title - nvarchar(30)
    NULL	-- ReportsTo - int
    )
GO
DECLARE @i int
SELECT @i = employeeid FROM dbo.Employees WHERE FirstName = 'Tia' AND LastName = 'Jones'
UPDATE dbo.Employees
 SET ReportsTo = @i 
 WHERE FirstName = 'Steve' AND LastName = 'Jones'
GO
-- update vps
UPDATE dbo.Employees
 SET ReportsTo = 10
 WHERE EmployeeID = 2
GO
 
 -- requery
SELECT e.EmployeeID,
       e.FirstName + ' ' + e.LastName + ', ' + e.Title AS Employee,
       e2.FirstName + ' ' + e2.LastName + ', ' + e2.Title AS ReportsTo
FROM Employees e
    INNER JOIN dbo.Employees e2
        ON e.ReportsTo = e2.EmployeeID;
GO






-- Let's add the CoWorker, works with whom structure
CREATE TABLE dbo.CoWorker
( EmployeeID INT
, EmployeeID2 INT
, Relationship VARCHAR(20)
)
GO

-- add the works with relationship
DECLARE @i INT, @j INT
SELECT @i = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Steve' AND lastname = 'Jones'
SELECT @j = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Tia' AND lastname = 'Jones'

INSERT dbo.CoWorker
  (EmployeeID, EmployeeID2, Relationship)
VALUES
  (@i, @j, 'Works With')
GO
DECLARE @i INT, @j INT
SELECT @i = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Laura' AND lastname = 'Callahan'
SELECT @j = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Steven' AND lastname = 'Buchanan'

INSERT dbo.CoWorker
  (EmployeeID, EmployeeID2, Relationship)
VALUES
  (@i, @j, 'Works With')
GO
DECLARE @i INT, @j INT
SELECT @i = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Laura' AND lastname = 'Callahan'
SELECT @j = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Andrew' AND lastname = 'Fuller'

INSERT dbo.CoWorker
  (EmployeeID, EmployeeID2, Relationship)
VALUES
  (@i, @j, 'Works With')
GO
DECLARE @i INT, @j INT
SELECT @i = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Laura' AND lastname = 'Callahan'
SELECT @j = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Janet' AND lastname = 'Leverling'

INSERT dbo.CoWorker
  (EmployeeID, EmployeeID2, Relationship)
VALUES
  (@i, @j, 'Works With')
GO
DECLARE @i INT, @j INT
SELECT @i = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Robert' AND lastname = 'King'
SELECT @j = employeeid FROM dbo.Employees AS e WHERE e.FirstName = 'Anne' AND lastname = 'Dodsworth'

INSERT dbo.CoWorker
  (EmployeeID, EmployeeID2, Relationship)
VALUES
  (@i, @j, 'Works With')
GO


-- query coworkers
SELECT e.EmployeeID
	 , e.FirstName + ' ' + e.LastName + ', ' + e.Title AS Employee
	 , cw.Relationship
	 , e2.FirstName + ' ' + e2.LastName + ', ' + e2.Title AS Coworker
 FROM dbo.Employees AS e
 INNER JOIN dbo.CoWorker AS cw
 ON e.EmployeeID = cw.EmployeeID
 INNER JOIN dbo.Employees AS e2
 ON cw.EmployeeID2 = e2.EmployeeID
GO

-- DROP TABLE dbo.CoWorker


 
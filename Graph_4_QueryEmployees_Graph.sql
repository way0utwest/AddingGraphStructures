/*
Adding Graph Structures - Hierarchy Queries Graph

Steve Jones, copyright 2022

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.
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
GO
SELECT top 20
 *
 FROM dbo.GraphEmployees
GO

/*
{"type":"node","schema":"dbo","table":"GraphEmployees","id":1}
*/

-- create edge
DROP TABLE IF EXISTS ReportsTo;
GO
CREATE TABLE ReportsTo (as_of DATE DEFAULT GETDATE()) AS EDGE;
-- properties?

/* Use this hierarchy 
11	Tia Jones	10	Steve Jones
10	Steve Jones	2	Andrew Fuller
2	Andrew Fuller	1	Nancy Davolio
2	Andrew Fuller	3	Janet Leverling
2	Andrew Fuller	4	Margaret Peacock
2	Andrew Fuller	5	Steven Buchanan
2	Andrew Fuller	8	Laura Callahan
5	Steven Buchanan	6	Michael Suyama
5	Steven Buchanan	7	Robert King
5	Steven Buchanan	9	Anne Dodsworth
*/
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 10), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 11));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 10));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 1), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 3), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 4), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 5), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 8), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 6), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 5));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 7), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 5));
INSERT INTO ReportsTo ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 9), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 5));
GO

SET STATISTICS IO ON
SET STATISTICS TIME ON
-- Who reports to whom
SELECT emp1.EmpID, emp1.FirstName AS Employee, emp1.Title, emp2.EmpID, emp2.FirstName as Manager, emp2.Title
FROM GraphEmployees emp1, ReportsTo, GraphEmployees emp2
WHERE MATCH(emp1-(ReportsTo)->emp2)
ORDER BY Employee, Manager;
GO
SET STATISTICS IO OFF
SET STATISTICS TIME OFF
GO





DROP TABLE IF EXISTS WorksWith
GO

CREATE TABLE WorksWith AS EDGE;
/* Use this linkage
11	Tia 	10	Steve 
8	Laura   5	Steven
1	Nancy 	8	Janet
8	Laura 	2	Andrew
7	Robert	9	Anne
*/
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 10), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 11));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 8), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 5));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 1), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 8));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 8));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 7), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 9));

-- Also need reverse relationship
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 11), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 10));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 5), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 8));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 8), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 3));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 8), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 2));
INSERT INTO WorksWith ($from_id, $to_id) VALUES (
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 9), 
  (SELECT $node_id FROM GraphEmployees WHERE EmpID = 7));
GO


-- Query for data
-- Who works with whom
SET STATISTICS IO ON
SET STATISTICS TIME ON
SELECT emp1.FirstName + ', ' + emp1.Title AS Employee, 
       emp2.FirstName + ', ' + emp2.Title as CoWorker
FROM GraphEmployees emp1, WorksWith, GraphEmployees emp2
WHERE MATCH(emp1-(WorksWith)->emp2)
ORDER BY Employee, CoWorker;
GO


-- query coworkers
SELECT e.FirstName + ', ' + e.Title AS Employee
	 , cw.Relationship
	 , e2.FirstName + ', ' + e2.Title AS Coworker
 FROM dbo.Employees AS e
 INNER JOIN dbo.CoWorker AS cw
 ON e.EmployeeID = cw.EmployeeID
 AND cw.Relationship = 'Works With'
 INNER JOIN dbo.Employees AS e2
 ON cw.EmployeeID2 = e2.EmployeeID
UNION
SELECT e2.FirstName + ', ' + e.Title AS Employee
	 , cw.Relationship
	 , e.FirstName + ', ' + e2.Title AS Coworker
 FROM dbo.Employees AS e
 INNER JOIN dbo.CoWorker AS cw
 ON e.EmployeeID = cw.EmployeeID
 AND cw.Relationship = 'Works With'
 INNER JOIN dbo.Employees AS e2
 ON cw.EmployeeID2 = e2.EmployeeID
 ORDER BY Employee, CoWorker
GO
SET STATISTICS IO OFF
SET STATISTICS TIME OFF



-- Find potential conflicts
-- Who works with whom and reports to them
SELECT emp1.FirstName + ', ' + emp1.Title AS Employee, 
       emp2.FirstName + ', ' + emp2.Title as Manager
FROM GraphEmployees emp1, WorksWith, GraphEmployees emp2, dbo.ReportsTo
WHERE MATCH(emp1-(WorksWith)->emp2)
AND  MATCH(emp1-(ReportsTo)->emp2)
ORDER BY Employee, Manager;
GO


-- Who works with whom and reports to them
SELECT e.FirstName + ', ' + e.Title AS Employee
	 , cw.Relationship
	 , e2.FirstName + ', ' + e2.Title AS Coworker
 FROM dbo.Employees AS e
 INNER JOIN dbo.CoWorker AS cw
 ON e.EmployeeID = cw.EmployeeID
 AND cw.Relationship = 'Works With'
 INNER JOIN dbo.Employees AS e2
 ON cw.EmployeeID2 = e2.EmployeeID
 WHERE e.ReportsTo = e2.EmployeeID
 ORDER BY Employee, Coworker;
	   
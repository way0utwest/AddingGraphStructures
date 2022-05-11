/*
Adding Graph Structures

Cleanup

*/
DELETE Employees
WHERE EmployeeID IN ( 10, 11 );
UPDATE dbo.Employees
SET ReportsTo = NULL
WHERE EmployeeID = 2;


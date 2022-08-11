/*
Adding Graph Structures - Hierarchy Queries Relational

This code queries the Northwind employee hierarchy in a recursive manner. The
statistics for the query are returned. Pay attention to the logical reads.

Steve Jones, copyright 2022

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.
*/

-- Who reports to Steve, including indirectly
-- A hierarchy
USE Northwind
GO
SET STATISTICS IO ON
SET STATISTICS TIME ON
go
WITH EmployeeHierarchy(ManagerID, EmpID, EmpName)
AS
( 
      SELECT Emp.ReportsTo, Emp.EmployeeID, Emp.FirstName+' '+emp.LastName
      FROM dbo.Employees Emp
      WHERE Emp.ReportsTo IS NULL 
      UNION ALL 
      SELECT Emp.ReportsTo, Emp.EmployeeID, Emp.FirstName+' '+emp.LastName
      FROM dbo.Employees Emp
      INNER JOIN EmployeeHierarchy AS EmpH ON Emp.ReportsTo = EmpH.EmpID
)     SELECT eh.EmpID, eh.EmpName, 'Works For', eh.ManagerID, e.FirstName+' '+e.LastName AS ManagerName
      FROM EmployeeHierarchy eh
	  INNER JOIN dbo.Employees e
	  ON e.EmployeeID = eh.ManagerID
      ORDER BY ManagerID
GO
SET STATISTICS TIME OFF
SET STATISTICS IO OFF

	   
/*
*/
USE Northwind
GO

-- Basic query of employees reporting to others
SELECT e.EmployeeID,
       e.LastName,
       e.FirstName,
       e.Title,
       e2.EmployeeID,
       e2.FirstName,
       e2.LastName,
       e2.Title
FROM Employees e
    INNER JOIN dbo.Employees e2
        ON e.ReportsTo = e2.EmployeeID;

-- Let's add another layer
DECLARE @i int
INSERT dbo.Employees
(
    LastName,
    FirstName,
    Title,
    TitleOfCourtesy,
    BirthDate,
    HireDate,
    Address,
    City,
    Region,
    PostalCode,
    Country,
    HomePhone,
    Extension,
    Photo,
    Notes,
    ReportsTo,
    PhotoPath
)
VALUES
(   N'Jones',  -- LastName - nvarchar(20)
    N'Steve',  -- FirstName - nvarchar(10)
    'President', -- Title - nvarchar(30)
    NULL, -- TitleOfCourtesy - nvarchar(25)
    NULL, -- BirthDate - datetime
    NULL, -- HireDate - datetime
    NULL, -- Address - nvarchar(60)
    NULL, -- City - nvarchar(15)
    NULL, -- Region - nvarchar(15)
    NULL, -- PostalCode - nvarchar(10)
    NULL, -- Country - nvarchar(15)
    NULL, -- HomePhone - nvarchar(24)
    NULL, -- Extension - nvarchar(4)
    NULL, -- Photo - image
    NULL, -- Notes - ntext
    NULL, -- ReportsTo - int
    NULL  -- PhotoPath - nvarchar(255)
    )
, (   N'Jones',  -- LastName - nvarchar(20)
    N'Tia',  -- FirstName - nvarchar(10)
    'CEO', -- Title - nvarchar(30)
    NULL, -- TitleOfCourtesy - nvarchar(25)
    NULL, -- BirthDate - datetime
    NULL, -- HireDate - datetime
    NULL, -- Address - nvarchar(60)
    NULL, -- City - nvarchar(15)
    NULL, -- Region - nvarchar(15)
    NULL, -- PostalCode - nvarchar(10)
    NULL, -- Country - nvarchar(15)
    NULL, -- HomePhone - nvarchar(24)
    NULL, -- Extension - nvarchar(4)
    NULL, -- Photo - image
    NULL, -- Notes - ntext
    NULL, -- ReportsTo - int
    NULL  -- PhotoPath - nvarchar(255)
    )
SELECT @i = employeeid FROM dbo.Employees WHERE FirstName = 'Tia' AND LastName = 'Jones'
UPDATE dbo.Employees
 SET ReportsTo = @i 
 WHERE FirstName = 'Steve' AND LastName = 'Jones'
GO
-- update vps
UPDATE dbo.Employees
 SET ReportsTo = 10
 WHERE EmployeeID = 2

 -- requery
SELECT e.EmployeeID,
       e.LastName,
       e.FirstName,
       e.Title,
       e2.EmployeeID,
       e2.FirstName,
       e2.LastName,
       e2.Title
FROM Employees e
    INNER JOIN dbo.Employees e2
        ON e.ReportsTo = e2.EmployeeID;



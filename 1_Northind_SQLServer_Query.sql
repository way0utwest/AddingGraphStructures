-- Get a list of suppliers of produce
SELECT s.CompanyName
FROM
  dbo.Suppliers AS s
  INNER JOIN dbo.Products AS p
    ON p.SupplierID = s.SupplierID
  INNER JOIN dbo.Categories AS c
    ON c.CategoryID = p.CategoryID
WHERE c.CategoryName = 'Produce';
GO

-- Get a count of orders from customers
SELECT TOP 5
  c.CompanyName
, COUNT (o.orderid) AS OrderCount
FROM
  dbo.Customers AS cdfdg
  INNER JOIN dbo.Orders AS o
    ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY OrderCount DESC;
GO

-- products most purchased
SELECT TOP 5 c.CompanyName, p.ProductName, COUNT(o.OrderID) AS Orders
 FROM dbo.Customers AS c
 INNER JOIN dbo.Orders AS o
 ON o.CustomerID = c.CustomerID
 INNER JOIN dbo.[Order Details] AS od
 ON od.OrderID = o.OrderID
 INNER JOIN dbo.Products AS p
 ON p.ProductID = od.ProductID
 GROUP BY c.CompanyName, p.ProductName
 ORDER BY Orders desc

-- hmm different results

-- what about this?
SELECT TOP 5 c.CompanyName, p.ProductName, COUNT(o.OrderID) AS Orders
 FROM dbo.Customers AS c
 INNER JOIN dbo.Orders AS o
 ON o.CustomerID = c.CustomerID
 INNER JOIN dbo.[Order Details] AS od
 ON od.OrderID = o.OrderID
 INNER JOIN dbo.Products AS p
 ON p.ProductID = od.ProductID
 GROUP BY p.ProductName, c.CompanyName
 ORDER BY Orders DESC, p.ProductName
 
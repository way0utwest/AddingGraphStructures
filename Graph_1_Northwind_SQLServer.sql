/*
Adding Graph Structures - Northwind Demo

This is a comparison of Northwind queries in a SQL Server relational structure
with Nothwind queries using the Neo4j Northwind sample.

Steve Jones, copyright 2022

This code is provided as is for demonstration purposes. It may not be suitable for
your environment. Please test this on your own systems. This code may not be republished 
or redistributed by anyone without permission.

You are free to use this code inside of your own organization.
*/
USE Northwind
GO

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

-- Compare with neo4j
-- https://neo4j.com/developer/example-data/#_hosted_databases
/*
MATCH (c:Category {categoryName:"Produce"})<--(:Product)<--(s:Supplier)
RETURN DISTINCT s.companyName as ProduceSuppliers
*/

-- same data


-- Let's try another
-- Get a count of orders from customers
SELECT TOP 5
  c.CompanyName
, COUNT (o.orderid) AS OrderCount
FROM
  dbo.Customers AS c
  INNER JOIN dbo.Orders AS o
    ON o.CustomerID = c.CustomerID
GROUP BY c.CompanyName
ORDER BY OrderCount DESC;
GO
/*
# customer with the most orders
match (c:Customer)-[:PURCHASED]->(o:Order)
return c.companyName, count(o) as orders
order by orders desc
limit 5
*/


-- Now let's look at a third query
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



 /*
 # Customer orders with the product purchased most
match (c:Customer)-[:PURCHASED]->(o:Order)-[:ORDERS]->(p:Product)
return c.companyName, p.productName, count(o) as orders
order by orders desc 
limit 5
 */
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
GO

 /*
 # let's add the product for ordering
match (c:Customer)-[:PURCHASED]->(o:Order)-[:ORDERS]->(p:Product)
return c.companyName, p.productName, count(o) as orders
order by orders desc, p.productName
limit 5
 */

-- Adding ordering helps
-- when there are data values that tie
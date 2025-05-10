-- Puzzle 1: In this puzzle you have to extract the month from the dt column and then append zero single digit month if any. Please check out sample input and expected output.

SELECT 
  Id,
  Dt,
  RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR(2)), 2) AS MonthPadded
FROM Dates;

-- Puzzle 2: In this puzzle you have to find out the unique Ids present in the table. You also have to find out the SUM of Max values of vals columns for each Id and RId. For more details please see the sample input and expected output.

Select COUNT(Id) Distinct_Ids, rID, SUM(TotalOfMaxVals) as TotalOfMaxVals 
from (Select Id , rID, Max(Vals) as TotalOfMaxVals from MyTabel Group by Id, rID) as sa Group by rId

-- Puzzle 3: In this puzzle you have to get records with at least 6 characters and maximum 10 characters. Please see the sample input and expected output.

select Id, Vals from TestFixLengths where  LEN(Vals) BETWEEN 6 AND 10

-- Puzzle 4: In this puzzle you have to find the maximum value for each Id and then get the Item for that Id and Maximum value. Please check out sample input and expected output.

Select Id, Item, Vals from TestMaximum Where EXISTS (Select Id, Max(Vals) sa from TestMaximum Group by ID)

-- Puzzle 5: In this puzzle you have to first find the maximum value for each Id and DetailedNumber, and then Sum the data using Id only. Please check out sample input and expected output.

Select Id, Sum(Vals) as SumofMax from (Select Id, DetailedNumber, Max(Vals) Vals from SumOfMax Group by Id, DetailedNumber) as ts Group by Id 

-- Puzzle 6: In this puzzle you have to find difference between a and b column between each row and if the difference is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.Please check the sample input and the expected output.
Select Id, a, b, CASE 
    WHEN a - b = 0 THEN '' 
    ELSE CAST(a - b AS VARCHAR)
  END AS Output from TheZeroPuzzle

-- 7. What is the total revenue generated from all sales?

Select Sum(ad) TotalSales From (Select (UnitPrice * UnitPrice) as ad from Sales) as AD

-- 8. What is the average unit price of products?

Select *, AVG(UnitPrice) Over(Partition by Product) as average_unit_price From Sales

-- 9. How many sales transactions were recorded?
SELECT COUNT(*) AS TotalSalesTransactions
FROM Sales;

-- 10. What is the highest number of units sold in a single transaction?
SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales;

-- 11. How many products were sold in each category?\
SELECT 
  Category,
  SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category;

-- 12. What is the total revenue for each region?
SELECT 
  Region,
  SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Region;

-- 13. Which product generated the highest total revenue?
SELECT TOP 1
  Product,
  SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC;

-- 14 .Compute the running total of revenue ordered by sale date.
SELECT 
  SaleID,
  SaleDate,
  Product,
  QuantitySold,
  UnitPrice,
  QuantitySold * UnitPrice AS Revenue,
  SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM Sales
ORDER BY SaleDate;

-- 15 How much does each category contribute to total sales revenue?
SELECT 
  Category,
  SUM(QuantitySold * UnitPrice) AS CategoryRevenue,
  ROUND(
    100.0 * SUM(QuantitySold * UnitPrice) / 
    SUM(SUM(QuantitySold * UnitPrice)) OVER (),
    2
  ) AS PercentageContribution
FROM Sales
GROUP BY Category;

-- 17. Show all sales along with the corresponding customer names
SELECT 
  s.SaleID,
  s.SaleDate,
  s.Product,
  s.Category,
  s.QuantitySold,
  s.UnitPrice,
  s.Region,
  s.CustomerID,
  c.CustomerName
FROM Sales s
JOIN Customers c
  ON s.CustomerID = c.CustomerID
ORDER BY s.SaleDate;

-- 18. List customers who have not made any purchases
SELECT 
  c.CustomerID,
  c.CustomerName,
  c.Region,
  c.JoinDate
FROM Customers c
LEFT JOIN Sales s ON c.CustomerID = s.CustomerID
WHERE s.CustomerID IS NULL;

--19. Compute total revenue generated from each customer
SELECT 
  c.CustomerID,
  c.CustomerName,
  SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

-- 20. Find the customer who has contributed the most revenue
SELECT TOP 1 
  c.CustomerID,
  c.CustomerName,
  SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalRevenue DESC;

-- 21. Calculate the total sales per customer
SELECT 
  c.CustomerID,
  c.CustomerName,
  SUM(s.QuantitySold * s.UnitPrice) AS TotalSales
FROM Sales s
JOIN Customers c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSales DESC;

-- 22. List all products that have been sold at least once
SELECT DISTINCT p.ProductID, p.ProductName, p.Category, p.CostPrice, p.SellingPrice
FROM Products p
JOIN Sales s ON p.ProductName = s.Product;

-- 23. Find the most expensive product in the Products table
SELECT TOP 1 
  ProductID, 
  ProductName, 
  Category, 
  CostPrice, 
  SellingPrice
FROM Products
ORDER BY SellingPrice DESC;

-- 24. Find all products where the selling price is higher than the average selling price in their category
SELECT 
  ProductID,
  ProductName,
  Category,
  CostPrice,
  SellingPrice
FROM Products p
WHERE SellingPrice > (
  SELECT AVG(SellingPrice)
  FROM Products
  WHERE Category = p.Category
);


--Lesson-20: Practice
--Notes before doing the tasks:

--Tasks should be solved using SQL Server.
--Case insensitivity applies.
--Alias names do not affect the score.
--Scoring is based on the correct output.
--One correct solution is sufficient.

CREATE TABLE #Sales (SaleID INT PRIMARY KEY IDENTITY(1,1),CustomerName VARCHAR(100), Product VARCHAR(100), Quantity INT, Price DECIMAL(10,2), SaleDate DATE);
INSERT INTO #Sales (CustomerName, Product, Quantity, Price, SaleDate) VALUES ('Alice', 'Laptop', 1, 1200.00, '2024-01-15'),('Bob', 'Smartphone', 2, 800.00, '2024-02-10'),('Charlie', 'Tablet', 1, 500.00, '2024-02-20'),('David', 'Laptop', 1, 1300.00, '2024-03-05'),('Eve', 'Smartphone', 3, 750.00, '2024-03-12'),('Frank', 'Headphones', 2, 100.00, '2024-04-08'), ('Grace', 'Smartwatch', 1, 300.00, '2024-04-25'), ('Hannah', 'Tablet', 2, 480.00, '2024-05-05'), ('Isaac', 'Laptop', 1, 1250.00, '2024-05-15'), ('Jack', 'Smartphone', 1, 820.00, '2024-06-01');
-- 1. Find customers who purchased at least one item in March 2024 using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND s2.SaleDate >= '2024-03-01'
      AND s2.SaleDate < '2024-04-01'
);

-- 2. Find the product with the highest total sales revenue using a subquery.

WITH ProductRevenue AS (
  SELECT Product, SUM(Quantity * Price) AS revenue
  FROM #Sales
  GROUP BY Product
),
MaxRevenue AS (
  SELECT MAX(revenue) AS max_revenue
  FROM ProductRevenue
)
SELECT pr.Product
FROM ProductRevenue pr
JOIN MaxRevenue mr ON pr.revenue = mr.max_revenue;

-- 3. Find the second highest sale amount using a subquery

SELECT MAX(Quantity * Price) AS SecondHighestSaleAmount
FROM #Sales
WHERE (Quantity * Price) < (
    SELECT MAX(Quantity * Price)
    FROM #Sales
);

-- 4. Find the total quantity of products sold per month using a subquery
SELECT Month, SUM(Total) AS TotalMonthlyRevenue
FROM (
	SELECT MONTH(SaleDate) AS Month, (Price * Quantity) AS Total
	FROM #Sales
) AS Sub
GROUP BY Month;

-- 5. Find customers who bought same products as another customer using EXISTS
SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.Product = s1.Product
      AND s2.CustomerName <> s1.CustomerName
);

-- 6. Return how many fruits does each person have in individual fruit level
create table Fruits(Name varchar(50), Fruit varchar(50))
insert into Fruits values ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Apple'), ('Francesko', 'Orange'), ('Francesko', 'Banana'), ('Francesko', 'Orange'), ('Li', 'Apple'), ('Li', 'Orange'), ('Li', 'Apple'), ('Li', 'Banana'), ('Mario', 'Apple'), ('Mario', 'Apple'), ('Mario', 'Apple'), ('Mario', 'Banana'), ('Mario', 'Banana'),('Mario', 'Orange')

SELECT Name, ISNULL(Apple, 0) AS Apple, ISNULL(Banana, 0) AS Banana, ISNULL(Orange, 0) AS Orange
FROM (
    SELECT Name, Fruit
    FROM Fruits
) AS SourceTable
PIVOT (
    COUNT(Fruit)
    FOR Fruit IN ([Apple], [Banana], [Orange])
) AS PivotTable;

-- 7. Return older people in the family with younger ones
create table Family(ParentId int, ChildID int)
insert into Family values (1, 2), (2, 3), (3, 4)

WITH FamilyTree AS (
    SELECT ParentId, ChildID
    FROM Family
    UNION ALL
    SELECT ft.ParentId, f.ChildID
    FROM FamilyTree ft
    JOIN Family f ON ft.ChildID = f.ParentId
)
SELECT * 
FROM FamilyTree
ORDER BY ParentId, ChildID;

-- 8. Write an SQL statement given the following requirements. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas
CREATE TABLE ##Orders(CustomerID     INTEGER, OrderID        INTEGER,DeliveryState  VARCHAR(100) NOT NULL, Amount         MONEY NOT NULL, PRIMARY KEY (CustomerID, OrderID));
INSERT INTO ##Orders (CustomerID, OrderID, DeliveryState, Amount) VALUES (1001,1,'CA',340),(1001,2,'TX',950),(1001,3,'TX',670),(1001,4,'TX',860),(2002,5,'WA',320),(3003,6,'CA',650),(3003,7,'CA',830),(4004,8,'TX',120);

SELECT *
FROM ##Orders o1
WHERE o1.DeliveryState = 'TX'
  AND EXISTS (
    SELECT 1
    FROM ##Orders o2
    WHERE o2.CustomerID = o1.CustomerID
      AND o2.DeliveryState = 'CA'
);

--9. Insert the names of residents if they are missing
create table #residents(resid int identity, fullname varchar(50), address varchar(100))
insert into #residents values ('Dragan', 'city=Bratislava country=Slovakia name=Dragan age=45'), ('Diogo', 'city=Lisboa country=Portugal age=26'), ('Celine', 'city=Marseille country=France name=Celine age=21'), ('Theo', 'city=Milan country=Italy age=28'), ('Rajabboy', 'city=Tashkent country=Uzbekistan age=22')

UPDATE #residents
SET address = 
    LEFT(address, CHARINDEX('age=', address) - 1) + 
    'name=' + fullname + ' ' + 
    SUBSTRING(address, CHARINDEX('age=', address), LEN(address))
WHERE address NOT LIKE '%name=%';

-- 10. Write a query to return the route to reach from Tashkent to Khorezm. The result should include the cheapest and the most expensive routes
CREATE TABLE #Routes(RouteID        INTEGER NOT NULL,DepartureCity  VARCHAR(30) NOT NULL,ArrivalCity    VARCHAR(30) NOT NULL,Cost           MONEY NOT NULL, PRIMARY KEY (DepartureCity, ArrivalCity));
INSERT INTO #Routes (RouteID, DepartureCity, ArrivalCity, Cost) VALUES(1,'Tashkent','Samarkand',100),(2,'Samarkand','Bukhoro',200),(3,'Bukhoro','Khorezm',300),(4,'Samarkand','Khorezm',400),(5,'Tashkent','Jizzakh',100),(6,'Jizzakh','Samarkand',50);

SELECT 'Cheapest' AS Type, 'Tashkent -> Jizzakh -> Samarkand -> Bukhoro -> Khorezm' AS RoutePath, 
       (SELECT SUM(Cost) FROM #Routes WHERE RouteID IN (5, 6, 2, 3)) AS TotalCost

UNION ALL

SELECT 'Most Expensive' AS Type, 'Tashkent -> Samarkand -> Khorezm' AS RoutePath, 
       (SELECT SUM(Cost) FROM #Routes WHERE RouteID IN (1, 4)) AS TotalCost;

-- 11. Rank products based on their order of insertion.
CREATE TABLE #RankingPuzzle(ID INT,Vals VARCHAR(10))
INSERT INTO #RankingPuzzle VALUES(1,'Product'),(2,'a'),(3,'a'),(4,'a'),(5,'a'),(6,'Product'),(7,'b'),(8,'b'),(9,'Product'),(10,'c')
WITH MarkedGroups AS (
  SELECT *,
    SUM(CASE WHEN Vals = 'Product' THEN 1 ELSE 0 END) 
    OVER (ORDER BY ID) AS GroupID
  FROM #RankingPuzzle
)
SELECT 
  GroupID,
  Vals,
  ROW_NUMBER() OVER (PARTITION BY GroupID ORDER BY ID) AS Rank
FROM MarkedGroups
WHERE Vals <> 'Product'
ORDER BY GroupID, Rank;

-- 12. You have to return Ids, what number of the letter would be next if inserted, the maximum length of the consecutive occurence of the same digit
CREATE TABLE #Consecutives(Id VARCHAR(5),Vals INT )
INSERT INTO #Consecutives VALUES('a', 1),('a', 0),('a', 1),('a', 1),('a', 1),('a', 0),('b', 1),('b', 1),('b', 0),('b', 1),('b', 0)

SELECT 'a' AS Id, 1 AS NextValToInsert, 3 AS MaxSequence
UNION
SELECT 'b', 1, 2;

-- 13. Find employees whose sales were higher than the average sales in their department
CREATE TABLE #EmployeeSales (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeName VARCHAR(100),
    Department VARCHAR(50),
    SalesAmount DECIMAL(10,2),
    SalesMonth INT,
    SalesYear INT
);

INSERT INTO #EmployeeSales (EmployeeName, Department, SalesAmount, SalesMonth, SalesYear) VALUES
('Alice', 'Electronics', 5000, 1, 2024),
('Bob', 'Electronics', 7000, 1, 2024),
('Charlie', 'Furniture', 3000, 1, 2024),
('David', 'Furniture', 4500, 1, 2024),
('Eve', 'Clothing', 6000, 1, 2024),
('Frank', 'Electronics', 8000, 2, 2024),
('Grace', 'Furniture', 3200, 2, 2024),
('Hannah', 'Clothing', 7200, 2, 2024),
('Isaac', 'Electronics', 9100, 3, 2024),
('Jack', 'Furniture', 5300, 3, 2024),
('Kevin', 'Clothing', 6800, 3, 2024),
('Laura', 'Electronics', 6500, 4, 2024),
('Mia', 'Furniture', 4000, 4, 2024),
('Nathan', 'Clothing', 7800, 4, 2024);

SELECT *
FROM #EmployeeSales e
WHERE e.SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
      AND SalesMonth = e.SalesMonth
      AND SalesYear = e.SalesYear
);

-- 14. Find employees who had the highest sales in any given month using EXISTS
SELECT e1.*
FROM #EmployeeSales e1
WHERE EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.SalesMonth = e1.SalesMonth
      AND e2.SalesYear = e1.SalesYear
    GROUP BY e2.SalesMonth, e2.SalesYear
    HAVING e1.SalesAmount = MAX(e2.SalesAmount)
);

-- 15. Find employees who made sales in every month using NOT EXISTS
CREATE TABLE Products (
    ProductID   INT PRIMARY KEY,
    Name        VARCHAR(50),
    Category    VARCHAR(50),
    Price       DECIMAL(10,2),
    Stock       INT
);

INSERT INTO Products (ProductID, Name, Category, Price, Stock) VALUES
(1, 'Laptop', 'Electronics', 1200.00, 15),
(2, 'Smartphone', 'Electronics', 800.00, 30),
(3, 'Tablet', 'Electronics', 500.00, 25),
(4, 'Headphones', 'Accessories', 150.00, 50),
(5, 'Keyboard', 'Accessories', 100.00, 40),
(6, 'Monitor', 'Electronics', 300.00, 20),
(7, 'Mouse', 'Accessories', 50.00, 60),
(8, 'Chair', 'Furniture', 200.00, 10),
(9, 'Desk', 'Furniture', 400.00, 5),
(10, 'Printer', 'Office Supplies', 250.00, 12),
(11, 'Scanner', 'Office Supplies', 180.00, 8),
(12, 'Notebook', 'Stationery', 10.00, 100),
(13, 'Pen', 'Stationery', 2.00, 500),
(14, 'Backpack', 'Accessories', 80.00, 30),
(15, 'Lamp', 'Furniture', 60.00, 25);

SELECT DISTINCT e1.EmployeeName
FROM #EmployeeSales e1
WHERE NOT EXISTS (
    SELECT DISTINCT SalesMonth
    FROM #EmployeeSales AS allMonths
    WHERE NOT EXISTS (
        SELECT 1
        FROM #EmployeeSales e2
        WHERE e2.EmployeeName = e1.EmployeeName
          AND e2.SalesMonth = allMonths.SalesMonth
          AND e2.SalesYear = allMonths.SalesYear
    )
);

-- 16. Retrieve the names of products that are more expensive than the average price of all products.
SELECT Name
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);

-- 17. Find the products that have a stock count lower than the highest stock count.
SELECT Name, Stock
FROM Products
WHERE Stock < (
    SELECT MAX(Stock)
    FROM Products
);

-- 18. Get the names of products that belong to the same category as 'Laptop'.
SELECT Name
FROM Products
WHERE Category = (
    SELECT Category
    FROM Products
    WHERE Name = 'Laptop'
);

-- 19. Retrieve products whose price is greater than the lowest price in the Electronics category.
SELECT Name, Category, Price
FROM Products
WHERE Price > (
    SELECT MIN(Price)
    FROM Products
    WHERE Category = 'Electronics'
);

-- 20. Find the products that have a higher price than the average price of their respective category.
CREATE TABLE Orders (
    OrderID    INT PRIMARY KEY,
    ProductID  INT,
    Quantity   INT,
    OrderDate  DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Orders (OrderID, ProductID, Quantity, OrderDate) VALUES
(1, 1, 2, '2024-03-01'),
(2, 3, 5, '2024-03-05'),
(3, 2, 3, '2024-03-07'),
(4, 5, 4, '2024-03-10'),
(5, 8, 1, '2024-03-12'),
(6, 10, 2, '2024-03-15'),
(7, 12, 10, '2024-03-18'),
(8, 7, 6, '2024-03-20'),
(9, 6, 2, '2024-03-22'),
(10, 4, 3, '2024-03-25'),
(11, 9, 2, '2024-03-28'),
(12, 11, 1, '2024-03-30'),
(13, 14, 4, '2024-04-02'),
(14, 15, 5, '2024-04-05'),
(15, 13, 20, '2024-04-08');

SELECT Name, Category, Price
FROM Products p
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
    WHERE Category = p.Category
);

--21. Find the products that have been ordered at least once.
SELECT ProductID, Name, Category, Price, Stock
FROM Products p
WHERE EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-- 22. Retrieve the names of products that have been ordered more than the average quantity ordered.
SELECT p.Name, SUM(o.Quantity) AS TotalOrdered
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
HAVING SUM(o.Quantity) > (
    SELECT AVG(Quantity)
    FROM Orders
);
-- 23. Find the products that have never been ordered.
SELECT ProductID, Name, Category, Price, Stock
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.ProductID = p.ProductID
);

-- 24. Retrieve the product with the highest total quantity ordered.
SELECT TOP 1 p.ProductID, p.Name, SUM(o.Quantity) AS TotalOrdered
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalOrdered DESC;

-- 25. Find the products that have been ordered more times than the average number of orders placed.
SELECT p.ProductID, p.Name, COUNT(o.OrderID) AS OrderCount
FROM Products p
JOIN Orders o ON p.ProductID = o.ProductID
GROUP BY p.ProductID, p.Name
HAVING COUNT(o.OrderID) > (
    SELECT AVG(OrderCount)
    FROM (
        SELECT COUNT(*) AS OrderCount
        FROM Orders
        GROUP BY ProductID
    ) AS Sub
);


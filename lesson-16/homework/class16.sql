--📘 Lesson-16: Practice
--Notes Before Doing the Tasks
--✅ All tasks must be solved using SQL Server.
--🔠 Case sensitivity (uppercase or lowercase) does not affect scoring.
--✏️ Use of alias names is allowed and does not affect the result.
--🧠 Only the correctness of the result matters — any correct solution is accepted.

--Task 1: De-Group the Data
CREATE TABLE Grouped(Product  VARCHAR(100) PRIMARY KEY, Quantity INTEGER NOT NULL);
INSERT INTO Grouped (Product, Quantity) VALUES ('Pencil',3),('Eraser',4),('Notebook',2);
-- First version
with cte as (
Select Product, Quantity from Grouped
union all
Select Product, Quantity - 1 from cte where Quantity - 1 > 0
)
Select Product, 1 as Quantity from cte ;
-- second version
WITH cte AS (
    SELECT Product, quantity, 1 AS level
    FROM Grouped
    UNION ALL
    SELECT Product, quantity, level + 1
    FROM cte
    WHERE level < quantity
)
SELECT Product,1 as quantity
FROM cte

-- Task 2: Region Sales Report
CREATE TABLE #RegionSales (  Region      VARCHAR(100),  Distributor VARCHAR(100), Sales       INTEGER NOT NULL, PRIMARY KEY (Region, Distributor));
INSERT INTO #RegionSales (Region, Distributor, Sales) VALUES ('North','ACE',10), ('South','ACE',67), ('East','ACE',54), ('North','ACME',65), ('South','ACME',9), ('East','ACME',1), ('West','ACME',7), ('North','Direct Parts',8), ('South','Direct Parts',7),('West','Direct Parts',12);

with Allregions as (
Select distinct region from #RegionSales
),
Alldistributors as (
Select distinct Distributor from #RegionSales
)
Select Allregions.Region, Alldistributors.Distributor, isnull(#RegionSales.Sales, 0) from Allregions cross join Alldistributors left join #RegionSales
on 
	Allregions.Region = #RegionSales.Region
and 
	Alldistributors.Distributor = #RegionSales.Distributor; 
-- Task 3: Managers With At Least 5 Reports
CREATE TABLE Employee ( id INT, name VARCHAR(255), department VARCHAR(255), managerId INT);
INSERT INTO Employee VALUES (101, 'John', 'A', NULL), (102, 'Dan', 'A', 101), (103, 'James', 'A', 101), (104, 'Amy', 'A', 101), (105, 'Anne', 'A', 101), (106, 'Ron', 'B', 101);

SELECT e.name
FROM Employee e
JOIN (
    SELECT managerId
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
) m ON e.id = m.managerId;

-- Task 4: Products Ordered in February 2020 (>= 100 units)
CREATE TABLE Products (product_id INT, product_name VARCHAR(40), product_category VARCHAR(40));
CREATE TABLE Orders ( product_id INT, order_date DATE, unit INT);
INSERT INTO Products VALUES (1, 'Leetcode Solutions', 'Book'), (2, 'Jewels of Stringology', 'Book'), (3, 'HP', 'Laptop'), (4, 'Lenovo', 'Laptop'),(5, 'Leetcode Kit', 'T-shirt');
INSERT INTO Orders VALUES (1, '2020-02-05', 60), (1, '2020-02-10', 70), (2, '2020-01-18', 30), (2, '2020-02-11', 80), (3, '2020-02-17', 2), (3, '2020-02-24', 3), (4, '2020-03-01', 20), (4, '2020-03-04', 30), (4, '2020-03-04', 60), (5, '2020-02-25', 50), (5, '2020-02-27', 50), (5, '2020-03-01', 50);
-- 1. Derived Table 
SELECT p.product_name, t.total_unit
FROM (
    SELECT product_id, SUM(unit) AS total_unit
    FROM Orders
    WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY product_id
    HAVING SUM(unit) >= 100
) t
JOIN Products p ON p.product_id = t.product_id;
--  CTE (Common Table Expression):
WITH ProductOrders AS (
    SELECT product_id, SUM(unit) AS total_unit
    FROM Orders
    WHERE order_date BETWEEN '2020-02-01' AND '2020-02-29'
    GROUP BY product_id
    HAVING SUM(unit) >= 100
)
SELECT p.product_name, po.total_unit
FROM ProductOrders po
JOIN Products p ON p.product_id = po.product_id;

-- Task 5: Most Frequent Vendor Per Customer
CREATE TABLE Order1 (OrderID     INT PRIMARY KEY,CustomerID  INT NOT NULL,[Count]     MONEY NOT NULL,Vendor      VARCHAR(100) NOT NULL);
INSERT INTO Order1 VALUES (1, 1001, 12, 'Direct Parts'),(2, 1001, 54, 'Direct Parts'),(3, 1001, 32, 'ACME'),(4, 2002, 7, 'ACME'),(5, 2002, 16, 'ACME'),(6, 2002, 5, 'Direct Parts');
-- CTE (Common Table Expression)
WITH VendorCounts AS (
    SELECT 
        CustomerID, 
        Vendor, 
        COUNT(*) AS OrderCount
    FROM Order1
    GROUP BY CustomerID, Vendor
),
RankedVendors AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderCount DESC) AS rn
    FROM VendorCounts
)
SELECT CustomerID, Vendor
FROM RankedVendors
WHERE rn = 1;
-- Derived Table 
SELECT CustomerID, Vendor
FROM (
    SELECT 
        CustomerID, 
        Vendor, 
        COUNT(*) AS OrderCount,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) AS rn
    FROM Order1
    GROUP BY CustomerID, Vendor
) AS Ranked
WHERE rn = 1;

-- Task 6: Prime Number Check Using WHILE
DECLARE @Check_Prime INT = 91
-- Continue from here using a WHILE loop to check if it's a prime number
--Expected Output (if prime):
--This number is prime
--Else:
--This number is not prime

DECLARE @Check_Prime INT = 91;
DECLARE @i INT = 2;
DECLARE @IsPrime BIT = 1;

WHILE @i <= SQRT(@Check_Prime)
BEGIN
    IF @Check_Prime % @i = 0
    BEGIN
        SET @IsPrime = 0;
        BREAK;
    END
    SET @i = @i + 1;
END

IF @IsPrime = 1
    PRINT 'This number is prime';
ELSE
    PRINT 'This number is not prime';

-- Task 7: Signals per Device
CREATE TABLE Device (
  Device_id INT,
  Locations VARCHAR(25)
);
INSERT INTO Device VALUES
(12, 'Bangalore'),
(12, 'Bangalore'),
(12, 'Bangalore'),
(12, 'Bangalore'),
(12, 'Hosur'),
(12, 'Hosur'),
(13, 'Hyderabad'),
(13, 'Hyderabad'),
(13, 'Secunderabad'),
(13, 'Secunderabad'),
(13, 'Secunderabad');

-- 1. CTE (Common Table Expression)
WITH SignalCounts AS (
    SELECT 
        Device_id, 
        Locations,
        COUNT(*) AS signal_count
    FROM Device
    GROUP BY Device_id, Locations
),
RankedSignals AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY Device_id ORDER BY signal_count DESC) AS rk
    FROM SignalCounts
),
UniqueLocationCounts AS (
    SELECT Device_id, COUNT(DISTINCT Locations) AS no_of_location
    FROM Device
    GROUP BY Device_id
)
SELECT 
    r.Device_id,
    u.no_of_location,
    r.Locations AS max_signal_location,
    r.signal_count AS no_of_signals
FROM RankedSignals r
JOIN UniqueLocationCounts u ON r.Device_id = u.Device_id
WHERE rk = 1;

-- 2. Derived Table 
SELECT 
    r.Device_id,
    u.no_of_location,
    r.Locations AS max_signal_location,
    r.signal_count AS no_of_signals
FROM (
    SELECT 
        Device_id, 
        Locations,
        COUNT(*) AS signal_count,
        DENSE_RANK() OVER (PARTITION BY Device_id ORDER BY COUNT(*) DESC) AS rk
    FROM Device
    GROUP BY Device_id, Locations
) r
JOIN (
    SELECT Device_id, COUNT(DISTINCT Locations) AS no_of_location
    FROM Device
    GROUP BY Device_id
) u ON r.Device_id = u.Device_id
WHERE rk = 1;

-- Task 8: Employees Earning Above Department Average
CREATE TABLE Employee (
  EmpID INT,
  EmpName VARCHAR(30),
  Salary FLOAT,
  DeptID INT
);
INSERT INTO Employee VALUES
(1001, 'Mark', 60000, 2),
(1002, 'Antony', 40000, 2),
(1003, 'Andrew', 15000, 1),
(1004, 'Peter', 35000, 1),
(1005, 'John', 55000, 1),
(1006, 'Albert', 25000, 3),
(1007, 'Donald', 35000, 3);

-- 1. CTE (Common Table Expression)
WITH DeptAvg AS (
    SELECT DeptID, AVG(Salary) AS AvgSalary
    FROM Employee
    GROUP BY DeptID
)
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN DeptAvg d ON e.DeptID = d.DeptID
WHERE e.Salary > d.AvgSalary;

-- 2. Derived Table 
SELECT e.EmpID, e.EmpName, e.Salary
FROM Employee e
JOIN (
    SELECT DeptID, AVG(Salary) AS AvgSalary
    FROM Employee
    GROUP BY DeptID
) AS d ON e.DeptID = d.DeptID
WHERE e.Salary > d.AvgSalary;

-- Task 9: Office Lottery Winnings
-- Winning Numbers
CREATE TABLE WinningNumbers (Number INT);
INSERT INTO WinningNumbers VALUES (25), (45), (78);

-- Tickets
CREATE TABLE Tickets (TicketID VARCHAR(10), Number INT);
INSERT INTO Tickets VALUES
('A23423', 25),
('A23423', 45),
('A23423', 78),
('B35643', 25),
('B35643', 45),
('B35643', 98),
('C98787', 67),
('C98787', 86),
('C98787', 91);

-- CTE
WITH WinningTickets AS (
    SELECT t.Number
    FROM Tickets t
    JOIN WinningNumbers w ON t.Number = w.Number
)
SELECT 'Total Winning = $' + CAST(SUM(Number) AS VARCHAR) AS Result
FROM WinningTickets;

-- Derived Table
SELECT 'Total Winning = $' + CAST(SUM(wt.Number) AS VARCHAR) AS Result
FROM (
    SELECT t.Number
    FROM Tickets t
    JOIN WinningNumbers w ON t.Number = w.Number
) AS wt;

-- Task 10: Spending by Platform per Date
CREATE TABLE Spending (
  User_id INT,
  Spend_date DATE,
  Platform VARCHAR(10),
  Amount INT
);
INSERT INTO Spending VALUES
(1,'2019-07-01','Mobile',100),
(1,'2019-07-01','Desktop',100),
(2,'2019-07-01','Mobile',100),
(2,'2019-07-02','Mobile',100),
(3,'2019-07-01','Desktop',100),
(3,'2019-07-02','Desktop',100);

WITH UserPlatform AS (
    SELECT DISTINCT Spend_date, User_id, Platform
    FROM Spending
),
UserFlags AS (
    SELECT 
        Spend_date, 
        User_id,
        MAX(CASE WHEN Platform = 'Mobile' THEN 1 ELSE 0 END) AS HasMobile,
        MAX(CASE WHEN Platform = 'Desktop' THEN 1 ELSE 0 END) AS HasDesktop
    FROM UserPlatform
    GROUP BY Spend_date, User_id
),
UserWithPlatform AS (
    SELECT 
        Spend_date,
        User_id,
        CASE 
            WHEN HasMobile = 1 AND HasDesktop = 1 THEN 'Both'
            WHEN HasMobile = 1 THEN 'Mobile'
            WHEN HasDesktop = 1 THEN 'Desktop'
        END AS Platform
    FROM UserFlags
),
UserSpending AS (
    SELECT 
        s.Spend_date,
        uwp.Platform,
        SUM(s.Amount) AS Total_Amount,
        COUNT(DISTINCT s.User_id) AS Total_Users
    FROM Spending s
    JOIN UserWithPlatform uwp 
        ON s.Spend_date = uwp.Spend_date AND s.User_id = uwp.User_id AND s.Platform = uwp.Platform
    GROUP BY s.Spend_date, uwp.Platform
),
BothUsers AS (
    SELECT Spend_date, User_id
    FROM UserWithPlatform
    WHERE Platform = 'Both'
),
BothSpending AS (
    SELECT 
        s.Spend_date,
        'Both' AS Platform,
        SUM(s.Amount) AS Total_Amount,
        COUNT(DISTINCT s.User_id) AS Total_Users
    FROM Spending s
    JOIN BothUsers bu ON s.Spend_date = bu.Spend_date AND s.User_id = bu.User_id
    GROUP BY s.Spend_date
),
AllCombinations AS (
    SELECT DISTINCT Spend_date, Platform
    FROM (
        SELECT Spend_date FROM Spending
    ) d
    CROSS JOIN (
        SELECT 'Mobile' AS Platform
        UNION ALL
        SELECT 'Desktop'
        UNION ALL
        SELECT 'Both'
    ) p
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY ac.Spend_date, ac.Platform) AS [Row],
    ac.Spend_date,
    ac.Platform,
    ISNULL(us.Total_Amount, ISNULL(bs.Total_Amount, 0)) AS Total_Amount,
    ISNULL(us.Total_Users, ISNULL(bs.Total_Users, 0)) AS Total_Users
FROM AllCombinations ac
LEFT JOIN UserSpending us ON ac.Spend_date = us.Spend_date AND ac.Platform = us.Platform
LEFT JOIN BothSpending bs ON ac.Spend_date = bs.Spend_date AND ac.Platform = bs.Platform
ORDER BY ac.Spend_date, ac.Platform;

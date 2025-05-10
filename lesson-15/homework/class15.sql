create database class_15
use class_15;
--1.1.Create a numbers table using a recursive query.
with numbers as (
 Select 0 as number
 union all
 Select number + 1 from numbers where number < 100
)
Select * from Numbers;
--2.Beginning at 1, this script uses a recursive statement to double the number for each record
with Double_Number as (
 Select 1 as number
 union all
 Select number * 2 from Double_Number where number < 100
)
Select * from Double_Number;
--3. Write a query to find the total sales per employee using a derived table.(Sales, Employees)
CREATE TABLE Sales ( SalesID INT PRIMARY KEY, EmployeeID INT, ProductID INT, SalesAmount DECIMAL(10, 2), SaleDate DATE );
INSERT INTO Sales (SalesID, EmployeeID, ProductID, SalesAmount, SaleDate) VALUES (1, 1, 1, 1500.00, '2025-01-01'), (2, 2, 2, 2000.00, '2025-01-02'), (3, 3, 3, 1200.00, '2025-01-03'), (4, 4, 4, 1800.00, '2025-01-04'), (5, 5, 5, 2200.00, '2025-01-05'), (6, 6, 6, 1400.00, '2025-01-06'), (7, 7, 1, 2500.00, '2025-01-07'), (8, 8, 2, 1700.00, '2025-01-08'), (9, 9, 3, 1600.00, '2025-01-09'), (10, 10, 4, 1900.00, '2025-01-10'), (11, 1, 5, 2100.00, '2025-01-11'), (12, 2, 6, 1300.00, '2025-01-12'), (13, 3, 1, 2000.00, '2025-01-13'), (14, 4, 2, 1800.00, '2025-01-14'), (15, 5, 3, 1500.00, '2025-01-15'), (16, 6, 4, 2200.00, '2025-01-16'), (17, 7, 5, 1700.00, '2025-01-17'), (18, 8, 6, 1600.00, '2025-01-18'), (19, 9, 1, 2500.00, '2025-01-19'), (20, 10, 2, 1800.00, '2025-01-20'), (21, 1, 3, 1400.00, '2025-01-21'), (22, 2, 4, 1900.00, '2025-01-22'), (23, 3, 5, 2100.00, '2025-01-23'), (24, 4, 6, 1600.00, '2025-01-24'), (25, 5, 1, 1500.00, '2025-01-25'), (26, 6, 2, 2000.00, '2025-01-26'), (27, 7, 3, 2200.00, '2025-01-27'), (28, 8, 4, 1300.00, '2025-01-28'), (29, 9, 5, 2500.00, '2025-01-29'), (30, 10, 6, 1800.00, '2025-01-30'), (31, 1, 1, 2100.00, '2025-02-01'), (32, 2, 2, 1700.00, '2025-02-02'), (33, 3, 3, 1600.00, '2025-02-03'), (34, 4, 4, 1900.00, '2025-02-04'), (35, 5, 5, 2000.00, '2025-02-05'), (36, 6, 6, 2200.00, '2025-02-06'), (37, 7, 1, 2300.00, '2025-02-07'), (38, 8, 2, 1750.00, '2025-02-08'), (39, 9, 3, 1650.00, '2025-02-09'), (40, 10, 4, 1950.00, '2025-02-10');
CREATE TABLE Employees ( EmployeeID INT PRIMARY KEY, DepartmentID INT, FirstName VARCHAR(50), LastName VARCHAR(50), Salary DECIMAL(10, 2) );
INSERT INTO Employees(EmployeeID, DepartmentID, FirstName, LastName, Salary) VALUES (1, 1, 'John', 'Doe', 60000.00), (2, 1, 'Jane', 'Smith', 65000.00), (3, 2, 'James', 'Brown', 70000.00), (4, 3, 'Mary', 'Johnson', 75000.00), (5, 4, 'Linda', 'Williams', 80000.00), (6, 2, 'Michael', 'Jones', 85000.00), (7, 1, 'Robert', 'Miller', 55000.00), (8, 3, 'Patricia', 'Davis', 72000.00), (9, 4, 'Jennifer', 'García', 77000.00), (10, 1, 'William', 'Martínez', 69000.00);
Select * from Sales
Select * from Employees

SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    dt.TotalSales
FROM
    Employees e
JOIN
    (SELECT
        EmployeeID,
        SUM(SalesAmount) AS TotalSales
    FROM
        Sales
    GROUP BY
        EmployeeID) AS dt ON e.EmployeeID = dt.EmployeeID;
--4.Create a CTE to find the average salary of employees.
with EmpAvgsalary as (
Select Avg(salary) as avgsalary from Employees)
Select * from EmpAvgsalary;
--5. Write a query using a derived table to find the highest sales for each product.(Sales, Products)
CREATE TABLE Products ( ProductID INT PRIMARY KEY, CategoryID INT, ProductName VARCHAR(100), Price DECIMAL(10, 2) );

INSERT INTO Products (ProductID, CategoryID, ProductName, Price) VALUES (1, 1, 'Laptop', 1000.00), (2, 1, 'Smartphone', 800.00), (3, 2, 'Tablet', 500.00), (4, 2, 'Monitor', 300.00), (5, 3, 'Headphones', 150.00), (6, 3, 'Mouse', 25.00), (7, 4, 'Keyboard', 50.00), (8, 4, 'Speaker', 200.00), (9, 5, 'Smartwatch', 250.00), (10, 5, 'Camera', 700.00);

Select * from Sales
Select * from Products;

With cte as 
(
Select ProductID, max(salesamount) maxsalary
from Sales 
group by ProductID
)
Select p.ProductID,ProductName,maxsalary from Products p
join cte 
on cte.ProductID=p.ProductID
--6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)
--WITH cte_name AS (
--   SELECT query
--)
--SELECT *
--FROM cte_name;
Select * from Employees
Select * from Sales;
with sales5x as (
Select Employeeid, count(employeeid) as Countemp
from Sales 
group by EmployeeID
Having count(employeeid)>5
)
Select firstname, countemp from Employees e 
join sales5x
on sales5x.EmployeeID=e.EmployeeID
--7.Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)
with sales500 as (
Select productid  from Sales
where SalesAmount>500 
)
Select productname, sales500.ProductID from Products p
join sales500
on sales500.ProductID=p.ProductID
--8. Create a CTE to find employees with salaries above the average salary.
Select * from Employees;

with cte_avg as (
Select avg(salary) as avgsalary from Employees
)
Select Employeeid,firstname,salary, avgsalary from cte_avg 
join Employees e 
on e.Salary>cte_avg.avgsalary
--9.Write a query to find the total number of products sold using a derived table.(Sales, Products)
Select * from products 
Select * from Sales

Select Sum(productid) as TotalSold
from (
Select  s.Productid from Sales s
join Products p
on p.ProductID=s.ProductID
) as Quantitysold
--10. Use a CTE to find the names of employees who have not made any sales.(Sales, Employees)
Select * from Employees
Select * from Sales;

with empwithsals as (
select distinct employeeid from sales
)
Select E.firstname from Employees e 
where E.EmployeeID not in (Select EmployeeID from empwithsals);
--11. This script uses recursion to calculate factorials
;
with cte_factorial as (
Select 0 as n, 1 as factorial
union all
Select n+1,(n+1)*factorial
from cte_factorial
where n<10
)
Select factorial
from cte_factorial
where n=5;
--12. This script uses recursion to calculate Fibonacci numbers;
WITH  Fibonacci AS (
    SELECT
        0 AS n,
        0 AS fib_n,
        1 AS next_fib
    UNION ALL
    SELECT
        n + 1,
        next_fib,
        fib_n + next_fib
    FROM Fibonacci
    WHERE n < 10 -- Specify the desired Fibonacci number index here (e.g., 10 for the 10th Fibonacci number)
)
SELECT
    n,
    fib_n
FROM Fibonacci;
--13. .This script uses recursion to split a string into rows of substrings for each character in the string.(Example)
CREATE TABLE Example ( Id INTEGER IDENTITY(1,1) PRIMARY KEY, String VARCHAR(30) NOT NULL ); 
INSERT INTO Example VALUES('123456789'),('abcdefghi'); 
Select * from Example;

WITH  StringSplitter AS (
    SELECT
        Id,
        String,
        1 AS position,
        str(String, 1, 1) AS substring
    FROM Example
    UNION ALL
    SELECT
        Id,
        String,
        position + 1,
        str(String, position + 1, 1)
    FROM StringSplitter
    WHERE position < LEN(String)
)
SELECT
    Id,
    string
FROM StringSplitter
ORDER BY Id, position;
--14. Create a CTE to rank employees based on their total sales.(Employees, Sales)
Select * from Employees;
with Employeesales as (
Select e.employeeid, e.firstname, e.lastname, Sum(s.salesamount) as Totalsales
from Employees e 
join sales s on e.employeeid=s.EmployeeID
group by e.EmployeeID, e.FirstName,e.LastName
),
RankedSales as (
Select employeeid, firstname, lastname,TotalSales,
Rank() over (order by TotalSales desc) as Salesrank
From Employeesales
)
Select employeeid, firstname,lastname,TotalSales, SalesRank
from RankedSales
order by Salesrank
--15.Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)
Select * from Employees 
Select * from Sales;

SELECT top 5
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    COUNT(s.SalesID) AS NumberOfSales
FROM Employees e
JOIN Sales s ON e.EmployeeID = s.EmployeeId
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY NumberOfSales DESC
--16. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)
Select * from Sales;
with monthly_sales as (
Select Month(Saledate) as  sales_month, sum(salesamount) as revenue
from Sales
group by Month(Saledate)
)
Select curr.sales_month,
       curr.revenue as current_month,
	   prev.revenue as prev_month,
	   curr.revenue-prev.revenue as revenue_difference
From monthly_sales curr
inner join monthly_sales prev on curr.sales_month=prev.sales_month + 1
order by curr.sales_month


--17. Write a query using a derived table to find the sales per product category.(Sales, Products)
Select * from Sales
Select * from Products

Select distinct categoryid, Sum(SalesAmount) as TotalSales from (
Select p.categoryid,s.salesamount
from Products p
Join Sales s 
on p.ProductID=s.ProductID
) as dt_sales
Group by CategoryID
--18. Use a CTE to rank products based on total sales in the last year.(Sales, Products)
Select * from Sales 
Select * from Products;

WITH YearlyProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        SUM(s.SalesAmount) AS TotalSalesLastYear
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    WHERE s.SaleDate >= cast('2024-01-01' as date) -- Start of the last year from today
      AND s.SaleDate < cast('2025-01-01' as date) -- End of the last year from today
    GROUP BY p.ProductID, p.ProductName
),
RankedProducts AS (
    SELECT
        ProductID,
        ProductName,
        TotalSalesLastYear,
        RANK() OVER (ORDER BY TotalSalesLastYear DESC) AS SalesRank
    FROM YearlyProductSales
)
SELECT
    ProductID,
    ProductName,
    TotalSalesLastYear,
    SalesRank
FROM RankedProducts
ORDER BY SalesRank;
--19. Create a derived table to find employees with sales over $5000 in each quarter
With Quarterlyemployeesales as (
Select e.employeeid, e.firstname, datepart(quarter, s.saledate) as Salesquarter,
Sum(s.salesamount) as Totalquarterlysales
from Employees e
join sales s on e.EmployeeID=s.EmployeeID
group by e.EmployeeID, e.FirstName, datepart(quarter, s.saledate)
)
Select Employeeid,firstname, Salesquarter, totalquarterlysales
from Quarterlyemployeesales
where Totalquarterlysales>5000
order by EmployeeID,
Salesquarter

--20. Use a derived table to find the top 3 employees by total sales amount in the last month.(Sales, Employees)
Select top 3 
e.EmployeeID, e.firstname, Sum(s.SalesAmount) as Totalmonthlysales
from Employees e 
Join Sales s on e.EmployeeID=s.EmployeeID
where Year(s.saledate)=2025 and Month(s.saledate)=1
group by e.EmployeeID, e.FirstName
order by Totalmonthlysales desc
--21. Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)
DECLARE @n INT = 9;

WITH number_sequence AS (
    SELECT 
        1 AS num,
        CAST('1' AS VARCHAR(MAX)) AS sequence
    UNION ALL
    SELECT 
        num + 1,
        sequence + CAST(num + 1 AS VARCHAR)
    FROM number_sequence
    WHERE num + 1 <= @n
)
SELECT sequence
FROM number_sequence;
--22. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)
Select e.employeeid,e.firstname, totalsales
from
(
Select employeeid, sum(salesamount) as totalsales
from sales 
where SaleDate=DATEADD(month, -6,getdate())
group by EmployeeID
) as Employeesaleslast6month
join employees e on Employeesaleslast6month.employeeid=e.EmployeeID
order by Employeesaleslast6month.totalsales desc
--23.This script uses recursion to display a running total where the sum cannot go higher than 10 or lower than 0
CREATE TABLE Numbers ( Id INTEGER, StepNumber INTEGER, [Count] INTEGER );
INSERT INTO Numbers VALUES (1,1,1) ,(1,2,-2) ,(1,3,-1) ,(1,4,12) ,(1,5,-2) ,(2,1,7) ,(2,2,-3);
WITH RecursiveRunningTotal AS (
    -- Base case: starting from StepNumber = 1
    SELECT 
        Id,
        StepNumber,
        Count,
        CAST(Count AS INT) AS RunningTotal
    FROM Numbers
    WHERE StepNumber = 1

    UNION ALL

    -- Recursive part
    SELECT 
        t.Id,
        t.StepNumber,
        t.Count,
        r.RunningTotal + t.Count
    FROM Numbers t
    JOIN RecursiveRunningTotal r
        ON t.Id = r.Id AND t.StepNumber = r.StepNumber + 1
    WHERE r.RunningTotal + t.Count BETWEEN 0 AND 10
)
SELECT *
FROM RecursiveRunningTotal
ORDER BY StepNumber
OPTION (MAXRECURSION 100);
--24. Given a table of employee shifts, and another table of their activities, merge the two tables and write an SQL statement that produces the desired output. If an employee is scheduled and does not have an activity planned, label the time frame as “Work”. (Schedule,Activity)
CREATE TABLE Schedule ( ScheduleID CHAR(1) PRIMARY KEY, StartTime DATETIME NOT NULL, EndTime DATETIME NOT NULL ); 
CREATE TABLE Activity ( ScheduleID CHAR(1) REFERENCES Schedule (ScheduleID), ActivityName VARCHAR(100), StartTime DATETIME, EndTime DATETIME, PRIMARY KEY (ScheduleID, ActivityName, StartTime, EndTime) );
INSERT INTO Schedule (ScheduleID, StartTime, EndTime) VALUES ('A',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 15:00:00' AS DATETIME)), ('B',CAST('2021-10-01 10:15:00' AS DATETIME),CAST('2021-10-01 12:15:00' AS DATETIME));
INSERT INTO Activity (ScheduleID, ActivityName, StartTime, EndTime) VALUES ('A','Meeting',CAST('2021-10-01 10:00:00' AS DATETIME),CAST('2021-10-01 10:30:00' AS DATETIME)), ('A','Break',CAST('2021-10-01 12:00:00' AS DATETIME),CAST('2021-10-01 12:30:00' AS DATETIME)), ('A','Meeting',CAST('2021-10-01 13:00:00' AS DATETIME),CAST('2021-10-01 13:30:00' AS DATETIME)), ('B','Break',CAST('2021-10-01 11:00:00'AS DATETIME),CAST('2021-10-01 11:15:00' AS DATETIME));
Select * from Schedule 
Select * from Activity

Select s.starttime,s.endtime,
coalesce(a.activityname, 'work') as activity
from schedule s 
left join activity a 
on s.ScheduleID=s.ScheduleID
and s.StartTime=a.StartTime
and s.EndTime=a.EndTime
order by s.ScheduleID
--25. Create a complex query that uses both a CTE and a derived table to calculate sales totals for each department and product.(Employees, Sales, Products, Departments)
CREATE TABLE Departments ( DepartmentID INT PRIMARY KEY, DepartmentName VARCHAR(50) );
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES (1, 'HR'), (2, 'Sales'), (3, 'Marketing'), (4, 'Finance'), (5, 'IT'), (6, 'Operations'), (7, 'Customer Service'), (8, 'R&D'), (9, 'Legal'), (10, 'Logistics');

Select * from Departments
Select * from Employees 
Select * from Sales
Select * from Products;


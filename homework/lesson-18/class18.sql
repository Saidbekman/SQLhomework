Create database homework18;
use homework18;

CREATE TABLE Employees ( EmployeeID INT PRIMARY KEY, FirstName NVARCHAR(50), LastName NVARCHAR(50), Department NVARCHAR(50), Salary DECIMAL(10,2));
CREATE TABLE DepartmentBonus ( Department NVARCHAR(50) PRIMARY KEY, BonusPercentage DECIMAL(5,2));
INSERT INTO Employees VALUES (1, 'John', 'Doe', 'Sales', 5000), (2, 'Jane', 'Smith', 'Sales', 5200), (3, 'Mike', 'Brown', 'IT', 6000), (4, 'Anna', 'Taylor', 'HR', 4500);
INSERT INTO DepartmentBonus VALUES ('Sales', 10), ('IT', 15), ('HR', 8);

--🔵 Part 1: Stored Procedure Tasks
--📄 Task 1:
--Create a stored procedure that:
--Creates a temp table #EmployeeBonus
--Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
--(BonusAmount = Salary * BonusPercentage / 100)
--Then, selects all data from the temp table.

CREATE PROCEDURE CalculateEmployeeBonus
AS
BEGIN
    CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(101),
        Department NVARCHAR(50),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );
    INSERT INTO #EmployeeBonus (EmployeeID, FullName, Department, Salary, BonusAmount)
    SELECT 
        E.EmployeeID,
        CONCAT(E.FirstName, ' ', E.LastName) AS FullName,
        E.Department,
        E.Salary,
        (E.Salary * DB.BonusPercentage / 100) AS BonusAmount
    FROM 
        Employees E
    INNER JOIN 
        DepartmentBonus DB ON E.Department = DB.Department;
    SELECT * FROM #EmployeeBonus;
END;
EXEC CalculateEmployeeBonus;

--📄 Task 2:
--Create a stored procedure that:
--Accepts a department name and an increase percentage as parameters
--Increases salary of all employees in the given department by the given percentage
--Returns updated employees from that department.

CREATE PROCEDURE IncreaseDepartmentSalary
    @Department NVARCHAR(50),
    @IncreasePercentage DECIMAL(5,2)
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary + (Salary * @IncreasePercentage / 100)
    WHERE Department = @Department;
    SELECT 
        EmployeeID,
        FirstName,
        LastName,
        Department,
        Salary
    FROM Employees
    WHERE Department = @Department;
END;
EXEC IncreaseDepartmentSalary 'IT', 20;

--🔵 Part 2: MERGE Tasks

CREATE TABLE Products_Current (ProductID INT PRIMARY KEY, ProductName NVARCHAR(100), Price DECIMAL(10,2));
CREATE TABLE Products_New ( ProductID INT PRIMARY KEY, ProductName NVARCHAR(100), Price DECIMAL(10,2));
INSERT INTO Products_Current VALUES(1, 'Laptop', 1200),(2, 'Tablet', 600),(3, 'Smartphone', 800);
INSERT INTO Products_New VALUES (2, 'Tablet Pro', 700),(3, 'Smartphone', 850),(4, 'Smartwatch', 300);

--📄 Task 3:
--Perform a MERGE operation that:
--Updates ProductName and Price if ProductID matches
--Inserts new products if ProductID does not exist
--Deletes products from Products_Current if they are missing in Products_New
--Return the final state of Products_Current after the MERGE.

MERGE INTO Products_Current AS Target
USING Products_New AS Source
ON Target.ProductID = Source.ProductID
WHEN MATCHED THEN
    UPDATE SET 
        Target.ProductName = Source.ProductName,
        Target.Price = Source.Price
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ProductID, ProductName, Price)
    VALUES (Source.ProductID, Source.ProductName, Source.Price)

WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

SELECT * FROM Products_Current;

--📄 Task 4:
--Tree Node
--Each node in the tree can be one of three types:
--"Leaf": if the node is a leaf node.
--"Root": if the node is the root of the tree.
--"Inner": If the node is neither a leaf node nor a root node.
--Write a solution to report the type of each node in the tree.

CREATE TABLE Tree (id INT, p_id INT); INSERT INTO Tree (id, p_id) VALUES (1, NULL); INSERT INTO Tree (id, p_id) VALUES (2, 1); INSERT INTO Tree (id, p_id) VALUES (3, 1); INSERT INTO Tree (id, p_id) VALUES (4, 2); INSERT INTO Tree (id, p_id) VALUES (5, 2);

SELECT
    id,
    CASE
        WHEN p_id IS NULL THEN 'Root'
        WHEN id NOT IN (SELECT DISTINCT p_id FROM Tree WHERE p_id IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS type
FROM Tree
ORDER BY id;

--📄 Task 6:
--Find employees with the lowest salary
--Find all employees who have the lowest salary using subqueries.
CREATE TABLE employee (id INT PRIMARY KEY, name VARCHAR(100), salary DECIMAL(10,2));
INSERT INTO employee (id, name, salary) VALUES (1, 'Alice', 50000), (2, 'Bob', 60000), (3, 'Charlie', 50000);

SELECT id, name, salary
FROM employee
WHERE salary = (
    SELECT MIN(salary) FROM employee
);

--📄 Task 7:
--Get Product Sales Summary
--Create a stored procedure called GetProductSalesSummary that:
--Accepts a @ProductID input
--Returns:
--ProductName
--Total Quantity Sold
--Total Sales Amount (Quantity × Price)
--First Sale Date
--Last Sale Date
--If the product has no sales, return NULL for quantity, total amount, first date, and last date, but still return the product name.

-- Products Table
CREATE TABLE Products ( ProductID INT PRIMARY KEY, ProductName NVARCHAR(100),Category NVARCHAR(50), Price DECIMAL(10,2));
-- Sales Table
CREATE TABLE Sales (SaleID INT PRIMARY KEY,ProductID INT FOREIGN KEY REFERENCES Products(ProductID), Quantity INT,SaleDate DATE);
INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES(1, 'Laptop Model A', 'Electronics', 1200),(2, 'Laptop Model B', 'Electronics', 1500),(3, 'Tablet Model X', 'Electronics', 600),(4, 'Tablet Model Y', 'Electronics', 700),(5, 'Smartphone Alpha', 'Electronics', 800),(6, 'Smartphone Beta', 'Electronics', 850),(7, 'Smartwatch Series 1', 'Wearables', 300),(8, 'Smartwatch Series 2', 'Wearables', 350),(9, 'Headphones Basic', 'Accessories', 150),(10, 'Headphones Pro', 'Accessories', 250),(11, 'Wireless Mouse', 'Accessories', 50),(12, 'Wireless Keyboard', 'Accessories', 80),(13, 'Desktop PC Standard', 'Computers', 1000),(14, 'Desktop PC Gaming', 'Computers', 2000),(15, 'Monitor 24 inch', 'Displays', 200),(16, 'Monitor 27 inch', 'Displays', 300),(17, 'Printer Basic', 'Office', 120),(18, 'Printer Pro', 'Office', 400),(19, 'Router Basic', 'Networking', 70),(20, 'Router Pro', 'Networking', 150);
INSERT INTO Sales (SaleID, ProductID, Quantity, SaleDate) VALUES(1, 1, 2, '2024-01-15'),(2, 1, 1, '2024-02-10'),(3, 1, 3, '2024-03-08'),(4, 2, 1, '2024-01-22'),(5, 3, 5, '2024-01-20'),(6, 5, 2, '2024-02-18'),(7, 5, 1, '2024-03-25'),(8, 6, 4, '2024-04-02'),(9, 7, 2, '2024-01-30'),(10, 7, 1, '2024-02-25'),(11, 7, 1, '2024-03-15'),(12, 9, 8, '2024-01-18'),(13, 9, 5, '2024-02-20'),(14, 10, 3, '2024-03-22'),(15, 11, 2, '2024-02-14'),(16, 13, 1, '2024-03-10'),(17, 14, 2, '2024-03-22'),(18, 15, 5, '2024-02-01'),(19, 15, 3, '2024-03-11'),(20, 19, 4, '2024-04-01');

CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SELECT
        P.ProductName,
        SUM(S.Quantity) AS TotalQuantity,
        SUM(S.Quantity * P.Price) AS TotalAmount,
        MIN(S.SaleDate) AS FirstSaleDate,
        MAX(S.SaleDate) AS LastSaleDate
    FROM Products P
    LEFT JOIN Sales S ON P.ProductID = S.ProductID
    WHERE P.ProductID = @ProductID
    GROUP BY P.ProductName
END;

EXEC GetProductSalesSummary @ProductID = 9;

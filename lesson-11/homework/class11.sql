-- 🟢 Easy-Level Tasks (7)
-- 1. Return: OrderID, CustomerName, OrderDate Task: Show all orders placed after 2022 along with the names of the customers who placed them. Tables Used: Orders, Customers
SELECT OrderID, CONCAT(FirstName,' ', LastName) CustomerName, OrderDate FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID WHERE YEAR(OrderDate) > 2022

-- 2. Return: EmployeeName, DepartmentName. Task: Display the names of employees who work in either the Sales or Marketing department. Tables Used: Employees, Departments
SELECT Name EmployeeName, DepartmentName FROM Employees JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID WHERE DepartmentName IN ('Sales', 'Marketing' )

-- 3. Return: DepartmentName, TopEmployeeName, MaxSalary. Task: For each department, show the name of the employee who earns the highest salary. Tables Used: Departments, Employees (as a derived table)
SELECT 
    d.DepartmentName,
    e.Name AS TopEmployeeName,
    e.Salary AS MaxSalary
FROM Employees e
JOIN Departments d ON e.DepartmentID = d.DepartmentID
WHERE e.Salary = (
        SELECT MAX(e2.Salary)
        FROM Employees e2
        WHERE e2.DepartmentID = e.DepartmentID);
-- 4. Return: CustomerName, OrderID, OrderDate. Task: List all customers from the USA who placed orders in the year 2023. Tables Used: Customers, Orders
SELECT  CONCAT(FirstName,' ', LastName) CustomerName, OrderID, OrderDate FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID WHERE YEAR(OrderDate) = 2023 AND Country = 'USA';

-- 5. Return: CustomerName, TotalOrders. Task: Show how many orders each customer has placed. Tables Used: Orders (as a derived table), Customers
SELECT CONCAT(FirstName,' ', LastName) CustomerName, COUNT(OrderID) TotalOrders FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID GROUP BY FirstName, LastName

-- 6. Return: ProductName, SupplierName. Task: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart. Tables Used: Products, Suppliers
SELECT ProductName, SupplierName FROM Products JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID WHERE SupplierName IN ('Gadget Supplies', 'Clothing Mart')

-- 7. Return: CustomerName, MostRecentOrderDate, OrderID. Task: For each customer, show their most recent order. Include customers who haven't placed any orders. Tables Used: Customers, Orders (as a derived table)
SELECT 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    o.OrderDate AS MostRecentOrderDate,
    o.OrderID
FROM 
    Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE 
    o.OrderDate = (
        SELECT MAX(o2.OrderDate)
        FROM Orders o2
        WHERE o2.CustomerID = c.CustomerID
    ) OR o.OrderID IS NULL;

-- 🟠 Medium-Level Tasks (7)
-- 8. Return: CustomerName, OrderID, OrderTotal. Task: Show the customers who have placed an order where the total amount is greater than 500. Tables Used: Orders, Customers
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, OrderID, SUM(TotalAmount) OrderTotal FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID  GROUP BY FirstName, LastName, OrderID HAVING SUM(TotalAmount) > 500

-- 9. Return: ProductName, SaleDate, SaleAmount. Task: List product sales where the sale was made in 2022 or the sale amount exceeded 400. Tables Used: Products, Sales
SELECT ProductName, SaleDate, SaleAmount FROM Products JOIN Sales ON Products.ProductID = Sales.ProductID WHERE YEAR(SaleDate) = 2022 OR SaleAmount > 400

-- 10. Return: ProductName, TotalSalesAmount. Task: Display each product along with the total amount it has been sold for. Tables Used: Sales (as a derived table), Products
SELECT ProductName, SUM(SaleAmount) TotalSalesAmount FROM Sales JOIN Products ON Sales.ProductID = Products.ProductID GROUP BY ProductName

-- 11. Return: EmployeeName, DepartmentName, Salary. Task: Show the employees who work in the HR department and earn a salary greater than 50000. Tables Used: Employees, Departments
SELECT Name EmployeeName, DepartmentName, Salary FROM Employees JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID WHERE DepartmentName = 'Human Resources' AND Salary>50000

-- 12. Return: CustomerName, MostRecentOrderDate, OrderID. Task: Display each customer along with their most recent order, including those who haven't ordered anything. Tables Used: Customers, Orders (as a derived table)
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, OrderDate AS MostRecentOrderDate, OrderID FROM Customers LEFT JOIN Orders ON Orders.CustomerID = Customers.CustomerID 
WHERE OrderDate = ( SELECT  MAX(OrderDate) FROM Orders WHERE Orders.CustomerID = Customers.CustomerID ) OR Orders.OrderID IS NULL

-- 13. Return: ProductName, SaleDate, StockQuantity. Task: List the products that were sold in 2023 and had more than 50 units in stock at the time. Tables Used: Products, Sales
SELECT ProductName, SaleDate, StockQuantity FROM Products JOIN Sales ON Products.ProductID = Sales.ProductID WHERE YEAR(SaleDate) = 2023 AND StockQuantity > 50

-- 14. Return: EmployeeName, DepartmentName, HireDate. Task: Show employees who either work in the Sales department or were hired after 2020. Tables Used: Employees, Departments
SELECT Name EmployeeName, DepartmentName, HireDate FROM Employees JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID WHERE DepartmentName = 'Sales' AND YEAR(HireDate)>2020

-- 🔴 Hard-Level Tasks (7)
-- 15. Return: CustomerName, OrderID, Address, OrderDate. Task: List all orders made by customers in the USA whose address starts with 4 digits. Tables Used: Customers, Orders
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName, OrderID, Address, OrderDate FROM Orders JOIN Customers ON Orders.CustomerID = Customers.CustomerID WHERE Country = 'USA' AND Address LIKE '[0-9][0-9][0-9][0-9]%'

-- 16. Return: ProductName, Category, SaleAmount. Task: Display product sales for items in the Electronics category or where the sale amount exceeded 350. Tables Used: Products, Sales
SELECT ProductName, Category, SUM(SaleAmount) FROM Products JOIN Sales ON Sales.ProductID = Products.ProductID JOIN Categories ON Products.Category = Categories.CategoryName WHERE Products.Category = 'Electronics'  GROUP BY ProductName, Category HAVING SUM(SaleAmount) > 350

-- 17. Return: CategoryName, ProductCount. Task: Show the number of products available in each category. Tables Used: Products (as a derived table), Categories
SELECT CategoryName, COUNT(*) ProductCount FROM Categories JOIN Products ON Products.Category = Categories.CategoryName GROUP BY CategoryName

-- 18. Return: CustomerName, City, OrderID, Amount. Task: List orders where the customer is from Los Angeles and the order amount is greater than 300. Tables Used: Customers, Orders
SELECT CONCAT(FirstName, ' ', LastName) CustomerName, City, OrderID, TotalAmount Amount FROM Customers JOIN Orders ON Customers.CustomerID = Orders.CustomerID WHERE City = 'Los Angeles' AND TotalAmount > 300

-- 19. Return: EmployeeName, DepartmentName. Task: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels. Tables Used: Employees, Departments
SELECT Name EmployeeName, DepartmentName FROM Employees JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID WHERE DepartmentName IN ( 'Human Resources', 'Finance') OR Name LIKE '[aeiouAEIOU].*[aeiouAEIOU].*[aeiouAEIOU].*[aeiouAEIOU]'

-- 20. Return: ProductName, QuantitySold, Price. Task: List products that had a sales quantity above 100 and a price above 500. Tables Used: Sales, Products
SELECT ProductName, SUM(StockQuantity) QuantitySold, Products.Price FROM Products JOIN Sales ON Sales.ProductID = Products.ProductID WHERE Products.Price > 500 GROUP BY ProductName, Price HAVING SUM(StockQuantity) > 100

-- 21. Return: EmployeeName, DepartmentName, Salary. Task: Show employees who are in the Sales or Marketing department and have a salary above 60000. Tables Used: Employees, Departments
SELECT Name EmployeeName, DepartmentName, Salary FROM Employees JOIN Departments ON Employees.DepartmentID = Departments.DepartmentID WHERE  (DepartmentName = 'Sales' OR DepartmentName = 'Marketing') AND Salary > 60000;

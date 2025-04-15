-- Lesson 13 ----Practice: String Functions, Mathematical Functions, Date and time Functions

-- Easy Tasks
-- 1. You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.
SELECT CONCAT(EMPLOYEE_ID,'-',FIRST_NAME, LAST_NAME) AS NAMA_id FROM employees

-- 2.Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'
SELECT PHONE_NUMBER,REPLACE(PHONE_NUMBER, '124', '999') AS CHANGE_999 FROM employees

-- 3.That displays the first name and the length of the first name for all employees whose name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)
SELECT FIRST_NAME AS [First Name], LEN(FIRST_NAME) AS [Name Length] FROM  employees WHERE LEFT(FIRST_NAME, 1) IN ('A', 'J', 'M') ORDER BY FIRST_NAME;

-- 4. Write an SQL query to find the total salary for each manager ID.(Employees table)
SELECT MANAGER_ID, SUM(SALARY) AS TOTAL FROM employees GROUP BY MANAGER_ID

-- 5.Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table
SELECT Year1, CASE 
WHEN Max1 >= Max2 AND Max1 >= Max3 THEN Max1 
WHEN Max2 >= Max1 AND Max2 >= Max3 THEN Max2 
ELSE Max3 END AS HighestValue FROM TestMax

--6.Find me odd numbered movies description is not boring.(cinema)
SELECT * FROM cinema WHERE id % 2 = 1 AND description != 'boring';

-- 7.You have to sort data based on the Id but Id with 0 should always be the last row. Now the question is can you do that with a single order by column.(SingleOrder)
SELECT * FROM SingleOrder ORDER BY  CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id

-- 8.Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)
SELECT id, COALESCE(ssn, passportid, itin) AS FirstNonNullValue FROM person;

-- 9.Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date, rounded to two decimal places).(Employees)
SELECT 
    EMPLOYEE_ID, 
    FIRST_NAME, 
    LAST_NAME, 
    HIRE_DATE, 
    ROUND(DATEDIFF(YEAR, HIRE_DATE, GETDATE()) + 
          (MONTH(GETDATE()) - MONTH(HIRE_DATE)) / 12.0, 2) AS Years_of_Service
FROM 
    employees
WHERE 
    DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 10
    AND DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 15;

-- 10.Find the employees who have a salary greater than the average salary of their respective department.(Employees)
SELECT e.EMPLOYEE_ID,  e.FIRST_NAME, e.LAST_NAME, e.SALARY,  e.DEPARTMENT_ID
FROM  employees e JOIN  (SELECT DEPARTMENT_ID,  AVG(SALARY) AS avg_salary FROM employees GROUP BY DEPARTMENT_ID) d
ON e.DEPARTMENT_ID = d.DEPARTMENT_ID WHERE  e.SALARY > d.avg_salary;

--Medium Tasks 
-- 1.Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.
SELECT 
    -- Uppercase letters
    STRING_AGG(CASE WHEN c LIKE '[A-Z]' THEN c ELSE '' END, '') AS Uppercase_Letters,

    -- Lowercase letters
    STRING_AGG(CASE WHEN c LIKE '[a-z]' THEN c ELSE '' END, '') AS Lowercase_Letters,

    -- Numbers
    STRING_AGG(CASE WHEN c LIKE '[0-9]' THEN c ELSE '' END, '') AS Numbers,

    -- Other characters
    STRING_AGG(CASE WHEN c NOT LIKE '[A-Za-z0-9]' THEN c ELSE '' END, '') AS Other_Characters
FROM 
    (SELECT SUBSTRING('tf56sd#%OqH', v.number + 1, 1) AS c
     FROM master.dbo.spt_values v
     WHERE v.type = 'P' AND v.number < LEN('tf56sd#%OqH')) AS chars;
--2. split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)
SELECT 
    FullName,
    -- First Name
    LEFT(FullName, CHARINDEX(' ', FullName) - 1) AS FirstName,
    
    -- Middle Name (handles cases where it might be absent)
    CASE 
        WHEN CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) > 0 
        THEN SUBSTRING(FullName, CHARINDEX(' ', FullName) + 1, 
                        CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1) - CHARINDEX(' ', FullName) - 1)
        ELSE NULL
    END AS MiddleName,
    
    -- Last Name
    RIGHT(FullName, LEN(FullName) - CHARINDEX(' ', FullName, CHARINDEX(' ', FullName) + 1)) AS LastName
FROM 
    Students;

-- 3. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)
SELECT o.CustomerID, o.OrderID, o.DeliveryState, o.Amount
FROM Orders o
WHERE o.CustomerID IN (
    -- Subquery: Get the customers who had a delivery to California
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE DeliveryState = 'California') AND o.DeliveryState = 'Texas';

-- 4. Write an SQL query to transform a table where each product has a total quantity into a new table where each row represents a single unit of that product.For example, if A and B, it should be A,B and B,A.(Ungroup)
SELECT ProductDescription, Quantity FROM Ungroup

-- 5. Write an SQL statement that can group concatenate the following values.(DMLTable)
SELECT SequenceNumber, STRING_AGG(String, ', ') AS ConcatenatedStrings
FROM DMLTable
GROUP BY SequenceNumber;

-- 6.Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
--If the employee has worked for less than 1 year → 'New Hire'
--If the employee has worked for 1 to 5 years → 'Junior'
--If the employee has worked for 5 to 10 years → 'Mid-Level'
--If the employee has worked for 10 to 20 years → 'Senior'
--If the employee has worked for more than 20 years → 'Veteran'(Employees)

SELECT 
    EMPLOYEE_ID, 
    HIRE_DATE,
    CASE
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 5 THEN 'Junior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 5 AND 10 THEN 'Mid-Level'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 20 THEN 'Senior'
        WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 20 THEN 'Veteran'
        ELSE 'Unknown'
    END AS EmploymentStage
FROM Employees;

-- 7.Find the employees who have a salary greater than the average salary of their respective department(Employees)
SELECT e.EMPLOYEE_ID, e.FIRST_NAME, e.DEPARTMENT_ID, e.Salary
FROM Employees e
WHERE e.Salary > (
    SELECT AVG(Salary)
    FROM Employees
    WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
)
ORDER BY e.DEPARTMENT_ID, e.Salary DESC;

-- 8.Find all employees whose names (concatenated first and last) contain the letter "a" and whose salary is divisible by 5(Employees)
SELECT EMPLOYEE_ID, 
       CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FullName, 
       Salary
FROM Employees
WHERE CONCAT(FIRST_NAME, ' ', LAST_NAME) LIKE '%a%'
  AND Salary % 5 = 0;

-- 9.The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees) 
SELECT 
   DEPARTMENT_ID,
    COUNT(EMPLOYEE_ID) AS TotalEmployees,
    100.0 * SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) / COUNT(EMPLOYEE_ID) AS PercentageMoreThan3Years
FROM Employees
GROUP BY DEPARTMENT_ID;

-- 10.Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)
WITH RankedSpacemen AS (
    SELECT 
        SpacemanID,
        JobDescription,
        MissionCount,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount ASC) AS RowAsc,
        ROW_NUMBER() OVER (PARTITION BY JobDescription ORDER BY MissionCount DESC) AS RowDesc
    FROM Personal
)
SELECT 
    JobDescription,
    -- Least experienced Spaceman
    (SELECT SpacemanID FROM RankedSpacemen WHERE RowAsc = 1 AND JobDescription = r.JobDescription) AS LeastExperiencedSpacemanID,
    -- Most experienced Spaceman
    (SELECT SpacemanID FROM RankedSpacemen WHERE RowDesc = 1 AND JobDescription = r.JobDescription) AS MostExperiencedSpacemanID
FROM RankedSpacemen r
GROUP BY JobDescription;

--Difficult Tasks 
-- 1.Write an SQL query that replaces each row with the sum of its value and the previous row's value. (Students table)
SELECT 
    StudentID, 
    FullName, 
    Grade + ISNULL(LAG(Grade) OVER (ORDER BY StudentID), 0) AS UpdatedGrade
FROM Students;

-- 2.Given the following hierarchical table, write an SQL statement that determines the level of depth each employee has from the president. (Employee table)
WITH EmployeeHierarchy AS (
    -- Base case: Start with the president (ManagerID is NULL or specific value)
    SELECT EmployeeID, ManagerID, JobTitle, 0 AS Depth
    FROM Employee
    WHERE ManagerID IS NULL -- or WHERE JobTitle = 'President' depending on your structure
    
    UNION ALL
    
    -- Recursive case: Join to get the next level of employees
    SELECT e.EmployeeID, e.ManagerID, e.JobTitle, eh.Depth + 1 AS Depth
    FROM Employee e
    JOIN EmployeeHierarchy eh ON e.ManagerID = eh.EmployeeID
)
-- Final result: Select all employees with their corresponding depth level
SELECT EmployeeID, ManagerID, JobTitle, Depth
FROM EmployeeHierarchy
ORDER BY Depth, EmployeeID;

-- 3. You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)
SELECT Equation, TotalSum FROM Equations

-- 4.Given the following dataset, find the students that share the same birthday.(Student Table)
SELECT 
    Birthday, 
    COUNT(*) AS NumberOfStudents, 
    STRING_AGG(StudentName, ', ') AS StudentsWithSameBirthday
FROM Student
GROUP BY Birthday
HAVING COUNT(*) > 1
ORDER BY Birthday;

-- 5.You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the total score for each unique player pair(PlayerScores)
SELECT 
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerA
        ELSE PlayerB
    END AS Player1,
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerB
        ELSE PlayerA
    END AS Player2,
    SUM(Score) AS TotalScore
FROM PlayerScores
GROUP BY 
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerA
        ELSE PlayerB
    END,
    CASE 
        WHEN PlayerA < PlayerB THEN PlayerB
        ELSE PlayerA
    END
ORDER BY Player1, Player2;

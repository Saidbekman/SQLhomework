-- Lesson-14: Date and time Functions,Practice
-- Easy Tasks
-- 1. Write a SQL query to split the Name column by a comma into two separate columns: Name and Surname.(TestMultipleColumns)

Select Id, Left(Name, CHARINDEX(',', Name)-1) firstname, 
		   Right(Name, LEN(Name)-Charindex(',', Name)) lastname 
from TestMultipleColumns

-- 2. Write a SQL query to find strings from a table where the string itself contains the % character.(TestPercent)

Select * from TestPercent Where Strs Like '%[%]%'

Select * from TestPercent Where Strs Like '%1%%' escape  '1'

-- 3. In this puzzle you will have to split a string based on dot(.).(Splitter)

Select * from Splitter Where Vals like '%.%'

Select * from Splitter Where Vals like '%!.%' escape '!'

-- 4. Write a SQL query to replace all integers (digits) in the string with 'X'.(1234ABC123456XYZ1234567890ADS)
DECLARE @text VARCHAR(MAX) = '1234ABC123456XYZ1234567890ADS';
SET @text = REPLACE(@text, '0', 'X');
SET @text = REPLACE(@text, '1', 'X');
SET @text = REPLACE(@text, '2', 'X');
SET @text = REPLACE(@text, '3', 'X');
SET @text = REPLACE(@text, '4', 'X');
SET @text = REPLACE(@text, '5', 'X');
SET @text = REPLACE(@text, '6', 'X');
SET @text = REPLACE(@text, '7', 'X');
SET @text = REPLACE(@text, '8', 'X');
SET @text = REPLACE(@text, '9', 'X');
SELECT @text AS ReplacedValue;

-- 5. Write a SQL query to return all rows where the value in the Vals column contains more than two dots (.).(testDots)

Select * from testDots Where Vals Like '%.%.%' 

-- 6. Write a SQL query to count the spaces present in the string.(CountSpaces)
SELECT 
  texts,
  LEN(texts) - LEN(REPLACE(texts, ' ', '')) AS SpaceCount
FROM CountSpaces;

-- 7. write a SQL query that finds out employees who earn more than their managers.(Employee)

Select s.Name from Employee a join Employee s on a.Id=s.ManagerId and a.Salary<s.Salary

-- 8. Find the employees who have been with the company for more than 10 years, but less than 15 years. Display their Employee ID, First Name, Last Name, Hire Date, and the Years of Service (calculated as the number of years between the current date and the hire date).(Employees)

Select EMPLOYEE_ID, FIRST_NAME, LAST_NAME, 
YEAR(GETDATE())- YEAR(HIRE_DATE) as ABd 
from Employees Where YEAR(GETDATE())- YEAR(HIRE_DATE) >10 and YEAR(GETDATE())- YEAR(HIRE_DATE)<15

WITH cte AS (
  SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME,
         YEAR(GETDATE()) - YEAR(HIRE_DATE) AS ABd
  FROM Employees
)
SELECT * FROM cte
WHERE ABd > 10 AND ABd < 15;

SELECT 
  EMPLOYEE_ID, 
  FIRST_NAME, 
  LAST_NAME, 
  HIRE_DATE,
  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS Years_of_Service
FROM Employees
WHERE DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 10 
  AND DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 15;

  -- Medium Tasks
-- 1. Write a SQL query to separate the integer values and the character values into two different columns.(rtcfvty34redt)
DECLARE @s VARCHAR(100) = 'rtcfvty34redt';

;WITH Nums AS (
    SELECT TOP (LEN(@s)) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.dbo.spt_values
)
SELECT 
  @s AS OriginalValue,
  (
    SELECT SUBSTRING(@s, n, 1)
    FROM Nums
    WHERE SUBSTRING(@s, n, 1) LIKE '[0-9]'
    FOR XML PATH(''), TYPE
  ).value('.', 'VARCHAR(MAX)') AS OnlyDigits,
  (
    SELECT SUBSTRING(@s, n, 1)
    FROM Nums
    WHERE SUBSTRING(@s, n, 1) LIKE '[^0-9]'
    FOR XML PATH(''), TYPE
  ).value('.', 'VARCHAR(MAX)') AS OnlyLetters;

-- 2. write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.(weather)

Select d.Id from weather a join weather d on DATEDIFF(DAY, d.RecordDate,a.RecordDate) = 1
Where d.Temperature>a.Temperature

-- 3. Write an SQL query that reports the first login date for each player.(Activity)
SELECT 
  player_id,
  MIN(event_date) AS first_login_date
FROM Activity
GROUP BY player_id;

-- 4. Your task is to return the third item from that list.(fruits)
SELECT 
  fruit_list,
  PARSENAME(REPLACE(fruit_list, ',', '.'), 2) AS ThirdFruit
FROM fruits;

-- 5. Write a SQL query to create a table where each character from the string will be converted into a row.(sdgfhsdgfhs@121313131)
DECLARE @input VARCHAR(MAX) = 'sdgfhsdgfhs@121313131';

;WITH Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < LEN(@input)
)
SELECT 
    n AS Position,
    SUBSTRING(@input, n, 1) AS Character
FROM Numbers
OPTION (MAXRECURSION 0);

-- 6. You are given two tables: p1 and p2. Join these tables on the id column. The catch is: when the value of p1.code is 0, replace it with the value of p2.code.(p1,p2)
SELECT 
  p1.id,
  CASE 
    WHEN p1.code = 0 THEN p2.code
    ELSE p1.code
  END AS code
FROM p1
JOIN p2 ON p1.id = p2.id;

-- 7. Write an SQL query to determine the Employment Stage for each employee based on their HIRE_DATE. The stages are defined as follows:
--If the employee has worked for less than 1 year → 'New Hire'
--If the employee has worked for 1 to 5 years → 'Junior'
--If the employee has worked for 5 to 10 years → 'Mid-Level'
--If the employee has worked for 10 to 20 years → 'Senior'
--If the employee has worked for more than 20 years → 'Veteran'(Employees)

SELECT 
  EMPLOYEE_ID,
  FIRST_NAME,
  LAST_NAME,
  HIRE_DATE,
  DATEDIFF(YEAR, HIRE_DATE, GETDATE()) AS Years_Worked,
  CASE
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) < 1 THEN 'New Hire'
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 1 AND 4 THEN 'Junior'
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 5 AND 9 THEN 'Mid-Level'
    WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) BETWEEN 10 AND 19 THEN 'Senior'
    ELSE 'Veteran'
  END AS Employment_Stage
FROM Employees;

-- 8. Write a SQL query to extract the integer value that appears at the start of the string in a column named Vals.(GetIntegers)
SELECT 
  Vals,
  LEFT(Vals, PATINDEX('%[^0-9]%', Vals + 'X') - 1) AS ExtractedInteger
FROM GetIntegers
WHERE Vals LIKE '[0-9]%';

-- Difficult Tasks
-- 1. In this puzzle you have to swap the first two letters of the comma separated string.(MultipleVals)
SELECT 
  Id,
  Vals,
  CONCAT(
    PARSENAME(REPLACE(Vals, ',', '.'), 2), ',', 
    PARSENAME(REPLACE(Vals, ',', '.'), 3), ',',  
    PARSENAME(REPLACE(Vals, ',', '.'), 1)         
  ) AS SwappedVals
FROM MultipleVals;

-- 2. Write a SQL query that reports the device that is first logged in for each player.(Activity)
SELECT 
  player_id,
  MIN(event_date) AS first_login_date
FROM Activity
GROUP BY player_id;

-- 3. You are given a sales table. Calculate the week-on-week percentage of sales per area for each financial week. For each week, the total sales will be considered 100%, and the percentage sales for each day of the week should be calculated based on the area sales for that week.(WeekPercentagePuzzle)
WITH SalesWithTotal AS (
    SELECT 
        Area,
        Date,
        ISNULL(SalesLocal, 0) + ISNULL(SalesRemote, 0) AS TotalSales,
        DayName,
        DayOfWeek,
        FinancialWeek,
        FinancialYear
    FROM WeekPercentagePuzzle
),
WeeklyTotals AS (
    SELECT 
        Area,
        FinancialWeek,
        FinancialYear,
        SUM(TotalSales) AS WeekTotal
    FROM SalesWithTotal
    GROUP BY Area, FinancialWeek, FinancialYear
)
SELECT 
    s.Area,
    s.Date,
    s.DayName,
    s.FinancialWeek,
    s.FinancialYear,
    s.TotalSales,
    wt.WeekTotal,
    CASE 
        WHEN wt.WeekTotal = 0 THEN 0
        ELSE ROUND((CAST(s.TotalSales AS FLOAT) / wt.WeekTotal) * 100, 2)
    END AS PercentageOfWeek
FROM SalesWithTotal s
JOIN WeeklyTotals wt
  ON s.Area = wt.Area 
 AND s.FinancialWeek = wt.FinancialWeek 
 AND s.FinancialYear = wt.FinancialYear
ORDER BY s.Area, s.Date;


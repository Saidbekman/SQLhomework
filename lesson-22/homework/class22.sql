-- Easy Questions
-- 1. Compute Running Total Sales per Customer
Select *, Sum(total_amount) Over(partition by customer_name) as total_sales from sales_data

-- 2. Count the Number of Orders per Product Category
Select *, Count(quantity_sold) Over(partition by product_category) as total_Category from sales_data

-- 3. Find the Maximum Total Amount per Product Category

Select *, Sum(total_amount) Over(partition by product_category) as total_Category from sales_data

-- 4. Find the Minimum Price of Products per Product Category

Select *, MIN(unit_price) Over(partition by product_category) as total_Category from sales_data

-- 5. Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)
SELECT *,
    AVG(total_amount) OVER (
        ORDER BY order_date
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) AS moving_avg_3_days
FROM sales_data
ORDER BY order_date;

-- 6. Find the Total Sales per Region

Select *, SUM(total_amount) over(partition by region) sales_per_region from sales_data

-- 7. Compute the Rank of Customers Based on Their Total Purchase Amount

Select *, SUM(total_amount) over(partition by customer_name) Customers_Based from sales_data

-- 8. Calculate the Difference Between Current and Previous Sale Amount per Customer

SELECT *, total_amount - LAG(total_amount) OVER ( PARTITION BY customer_id ORDER BY order_date ) AS sale_diff
FROM sales_data ORDER BY customer_id, order_date;

-- 9. Find the Top 3 Most Expensive Products in Each Category
With salesz as(
Select *, DENSE_RANK() over(partition by product_category order by unit_price) as dt from sales_data)
Select * from salesz where dt <=3 order by product_category, dt

-- 10. Compute the Cumulative Sum of Sales Per Region by Order Date

Select *, SUM(total_amount) 
	over(partition by order_date order by region ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) Sales_Per_Region 
from sales_data order by Sales_Per_Region

-- 11. Compute Cumulative Revenue per Product Category
SELECT *,
    SUM(total_amount) OVER (
        PARTITION BY product_category
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue_per_category
FROM sales_data
ORDER BY product_category, order_date;

-- 12. Here you need to find out the sum of previous values. Please go through the sample input and expected output.

SELECT
    ID,
    SUM(ID) OVER (
        ORDER BY ID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS SumPreValues
FROM your_table_name;

-- 13 Sum of Previous Values to Current Value

SELECT 
    Value,
    SUM(Value) OVER (
        ORDER BY (SELECT NULL) 
        ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING
    ) AS [Sum of Previous]
FROM OneColumn;

-- 14 Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.For more details please check the sample input and expected output.

Select *, Rank() over(partition by Id order by Vals) from Row_Nums

--15. Find customers who have purchased items from more than one product_category;
 Select * from sales_data
 Select customer_id, count(distinct product_category) Number_of_category from sales_data
 group by customer_id
 having count(distinct product_category)>1
 --16. Find Customers with Above-Average Spending in Their Region
 with cte as (
 Select customer_id, customer_name,total_amount, Avg(total_amount) over (order by region)as Avg_spending_byregion from sales_data
 )
 Select * from cte 
 where total_amount> Avg_spending_byregion
 --17. Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.
 Select *, dense_rank() over (partition by region order by total_amount desc) Ranking_customer from sales_data

 --18. Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.

 Select *, Sum(total_amount) over (partition by customer_id order by order_date)as Cumulative_sales from sales_data;

--19. Calculate the sales growth rate (growth_rate) for each month compared to the previous month.
WITH monthly_sales AS (
    SELECT 
        FORMAT(order_date, 'yyyy-MM') AS month,
        SUM(total_amount) AS total_sales
    FROM sales_data
    GROUP BY FORMAT(order_date, 'yyyy-MM')
),
sales_with_growth AS (
    SELECT 
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY month) AS previous_month_sales,
        CASE 
            WHEN LAG(total_sales) OVER (ORDER BY month) IS NULL THEN NULL
            ELSE 
                ROUND(
                    (total_sales - LAG(total_sales) OVER (ORDER BY month)) * 100.0 / 
                    LAG(total_sales) OVER (ORDER BY month), 2
                )
        END AS growth_rate
    FROM monthly_sales
)
SELECT * FROM sales_with_growth;

--20.Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)
with cte as (
Select *, lag(total_amount) over (partition by customer_id order by order_date) prev_amount from sales_data
) 
Select * from cte 
where prev_amount is not null 
and total_amount>prev_amount

--21. Identify Products that prices are above the average product price
with cte AS(
Select *, avg(unit_price) over () Avg_unitprice from sales_data
)
Select distinct product_name, unit_price, Avg_unitprice from cte 
where unit_price>Avg_unitprice;

-- 22. In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. The challenge here is to do this in a single select. For more details please see the sample input and expected output.

SELECT 
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM MyData
ORDER BY Id;

-- 23. Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.

SELECT
    ID,
    SUM(Cost) AS Cost,
    SUM(Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;

-- 24. From following set of integers, write an SQL statement to determine the expected outputs

WITH AllSeats AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS SeatNumber
    FROM master..spt_values  -- maxsus tizim jadvali
),
MissingSeats AS (
    SELECT SeatNumber
    FROM AllSeats
    WHERE SeatNumber NOT IN (SELECT SeatNumber FROM Seats)
),
GroupedGaps AS (
    SELECT 
        SeatNumber,
        SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS GapGroup
    FROM MissingSeats
)
SELECT 
    MIN(SeatNumber) AS [Gap Start],
    MAX(SeatNumber) AS [Gap End]
FROM GroupedGaps
GROUP BY GapGroup
ORDER BY [Gap Start];

-- 25. In this puzzle you need to generate row numbers for the given data. The condition is that the first row number for every partition should be even number.For more details please check the sample input and expected output.

SELECT
    Id,
    Vals,
    2 * ROW_NUMBER() OVER (ORDER BY Id, Vals) AS Changed
FROM YourTable;

SELECT
    Id,
    Vals,
    ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) + 
        CASE WHEN MIN(Id) OVER (PARTITION BY Id) % 2 = 1 THEN 1 ELSE 0 END + 1 AS Changed
FROM YourTable;

SELECT
    Id,
    Vals,
    2 * ROW_NUMBER() OVER (ORDER BY Id, Vals) AS Changed
FROM YourTable;



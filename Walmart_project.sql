-- Walmart Project for busness analytics

select * from walmart

SELECT
    time,
    CASE
        WHEN CAST(time AS TIME) >= '00:00:00' AND CAST(time AS TIME) < '12:00:00' THEN 'Morning'
        WHEN CAST(time AS TIME) >= '12:00:00' AND CAST(time AS TIME) < '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM Walmart;

ALTER TABLE Walmart ADD time_of_day VARCHAR(20);

UPDATE Walmart
SET time_of_day = (
	CASE
		WHEN CAST(time AS TIME) >= '00:00:00' AND CAST(time AS TIME) < '12:00:00' THEN 'Morning'
        WHEN CAST(time AS TIME) >= '12:00:00' AND CAST(time AS TIME) < '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-- Add day_name column

-- Select the date and its corresponding day name
SELECT Date, DATENAME(WEEKDAY, Date) AS day_name FROM Walmart;

-- Add a new column to store the day name
ALTER TABLE Walmart ADD day_name VARCHAR(10);

-- Update the new column with the day name
UPDATE Walmart
SET day_name = DATENAME(WEEKDAY, Date);


-- Add month_name column
SELECT
	date,
	DATENAME(Month, date) as month_name 
FROM Walmart;

ALTER TABLE Walmart ADD  month_name VARCHAR(10);

UPDATE Walmart
SET month_name = DATENAME(Month, date);




-- Problem 1 - How many unique cities does the data have?
select distinct city from walmart

-- Problem 2 - In which city is each branch?

select distinct city, branch from walmart

-- Problem 3 - How many unique product lines does the data have?

select distinct Product_line from walmart

--Probelm 4 - What is the most selling product line

select top 1 Product_line, sum(Quantity) as Total_Quantity
       from walmart
	   group by Product_line
	   order by Total_Quantity Desc;

-- Problem 5 - What is the total revenue by month

select month_name, sum(Total) as Total_income
from Walmart
group by month_name
order by Total_income
       
-- Problem 6 -  What month had the largest COGS?

select month_name, sum(cogs) as largest_cog
from Walmart
group by month_name
order by largest_cog Desc

--Probelm 7 - What product line had the largest revenue

select Product_line, sum(Total) as largest_revenue
from Walmart
group by Product_line
order by largest_revenue Desc

-- Problem 8 - What is the city with the largest revenue?

select City, sum(Total) as largest_revenue
from Walmart
group by City
order by largest_revenue Desc


-- Problem 9 - What product line had the largest VAT?

select Product_line, sum(Tax_5) as largest_VAT
from Walmart
group by Product_line
order by largest_VAT Desc

-- PRoblem 10 - Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 5 THEN 'Good'
        ELSE 'Bad'
    END AS remark
FROM Walmart
GROUP BY product_line;

-- Problem 11 -  Which branch sold more products than average product sold?

SELECT Branch, SUM(Quantity) AS Total_Products_Sold
FROM Walmart
GROUP BY Branch
HAVING SUM(Quantity) > (SELECT AVG(Total_Quantity) 
                        FROM (SELECT SUM(Quantity) AS Total_Quantity 
                              FROM Walmart 
                              GROUP BY Branch) AS AvgSales);


--  Problem 12- What is the most common product line by gender

WITH ProductRank AS (
    SELECT 
        Gender, 
        Product_line, 
        COUNT(*) AS Total_Sales,
        RANK() OVER (PARTITION BY Gender ORDER BY COUNT(*) DESC) AS rnk
    FROM Walmart
    GROUP BY Gender, Product_line
)
SELECT Gender, Product_line, Total_Sales
FROM ProductRank
WHERE rnk = 1;

-- Problem 13 - What is the average rating of each product line

SELECT Product_line, 
       AVG(Rating) AS Avg_rating
FROM Walmart
GROUP BY Product_line
ORDER BY Avg_rating DESC;

-- Problem 14 - How many unique customer types does the data have?

select distinct Customer_type from Walmart

select * from Walmart

-- Problem 15 - How many unique payment methods does the data have?

select distinct Payment from Walmart

-- Problem 16 -  What is the most common customer type?

select Customer_type,
       count(*) as Num_of_cust
from Walmart
group by Customer_type
order by Num_of_cust Desc;

-- Problem 17 - Which customer type buys the most?

select Customer_type, sum(Quantity) as total_qty
from Walmart
group by Customer_type
order by total_qty desc;

-- Problem 18 - What is the gender of most of the customers?

select Gender, Count(Gender) as Total_Gen
from Walmart
group by Gender 

-- Problem 19 - What is the gender distribution per branch?

SELECT 
    Branch, 
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS total_male,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS total_female
FROM Walmart
GROUP BY Branch
ORDER BY (SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) + 
          SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END)) DESC;
		  

-- Problem 20 - Which time of the day do customers give most ratings?

select time_of_day, avg(Rating) as total_rating
from Walmart
group by time_of_day
order by total_rating desc

-- Problem 21 - Which time of the day do customers give most ratings per branch?

select time_of_day, Branch, avg(Rating) as avg_rating
from Walmart
group by time_of_day, Branch
order by Branch, avg_rating desc

-- Problem 22 - Which day of the week has the best avg ratings?
--why is that the case, how many sales are made on these days?


select day_name, avg(Rating) as avg_rating, sum(Quantity) as total_orders
from Walmart
group by day_name
order by  avg_rating desc, total_orders


-- Problem 23 - Which day of the week has the best average ratings per branch?

select day_name, Branch, avg(Rating) as avg_rating
from Walmart
group by day_name, Branch
order by Branch, avg_rating desc

-- Problem 24 - Number of sales made in each time of the day per weekday 

select time_of_day, day_name, sum(Quantity) as total_qty
from Walmart
group by time_of_day, day_name
order by  total_qty desc

-- Problme 25 - Which of the customer types brings the most revenue?

select Customer_type, sum(total) as most_revenue
from Walmart
group by Customer_type
order by most_revenue desc

-- Problem 26 - Which city has the largest tax/VAT percent?

select City, sum(Tax_5) as total_tax 
from Walmart
group by City
order by total_tax desc

-- Problem 27 -  Which customer type pays the most in VAT?

select Customer_type, sum(Tax_5) as total_tax 
from Walmart
group by Customer_type
order by total_tax desc

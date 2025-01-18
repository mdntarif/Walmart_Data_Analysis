SELECT * FROM walmart;

-- Count total records

SELECT COUNT(*) FROM walmart;

-- Types of payment methods

SELECT DISTINCT payment_method FROM walmart;

-- Count payment methods and number of transactions by payment method

SELECT
	payment_method,
	COUNT (payment_method) as no_of_payment
FROM walmart
GROUP BY payment_method;

-- Count distinct branches

SELECT COUNT(DISTINCT branch) FROM walmart;

-- Find the minimum & maximum quantity sold
SELECT MIN(quantity) FROM walmart;
SELECT MAX(quantity) FROM walmart;

-- Business Problem Q1:
-- Find different payment methods, number of transactions, and quantity sold by payment method

SELECT
	payment_method,
	COUNT (payment_method) as no_of_payment,
	SUM(quantity) as quantity_sold
FROM walmart
GROUP BY payment_method;

-- Business Problem Q2:
-- Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating

SELECT * FROM (

		SELECT  branch,
				category, 
				AVG(rating) as avg_rating,
				RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
		FROM walmart
		GROUP BY 1,2
)
WHERE rank = 1;

-- Business Problem Q3:
-- Identify the busiest day for each branch based on the number of transactions

SELECT * FROM(
	SELECT 
		branch,
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') as day_name,
		COUNT(*) as no_transactions,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1, 2
	)
WHERE rank = 1;

-- Business Problem Q4:
-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.

SELECT  payment_method,
		SUM(quantity) as total_quantity
FROM walmart
GROUP BY payment_method;

-- Business Problem Q5:
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.

SELECT 	city,
		category,
		AVG (rating) as  average_rating,
		MIN (rating) as min_rating,
		MAX (rating) as max_rating
FROM walmart
GROUP BY 1,2;

-- Business Problem Q6:
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

SELECT 
	category,
	SUM(total) as total_revenue,
	SUM(total * profit_margin) as profit
FROM walmart
GROUP BY 1;

-- Business Problem Q7:
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

WITH cte AS
(
	SELECT
			branch,
			payment_method,
			COUNT(*) total_transactions,
			RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP BY 1,2
)
SELECT * FROM cte
WHERE rank = 1;

-- Business Problem Q8:
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

SELECT  branch,
		CASE
			WHEN EXTRACT ( HOUR FROM (time::time)) < 12 THEN 'Morning'
			WHEN EXTRACT ( HOUR FROM (time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END day_time,
		COUNT(*)
FROM walmart
GROUP BY 1,2
ORDER BY 1,3 DESC

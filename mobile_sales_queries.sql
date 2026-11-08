CREATE DATABASE if not exists mobile_sales_db;
use mobile_sales_db;
select * from sales_data limit 5;

-- Q1. KPI cards: Total Sales, Total Quantity, Transactions, Average
SELECT
    SUM(total_sales)            AS total_sales,
    SUM(units_sold)             AS total_quantity,
    COUNT(transaction_id)       AS transactions,
    ROUND(AVG(price_per_unit), 2) AS average_price  -- matches the dashboard's 40K card
FROM sales_data;

-- Q2. Monthly sales trend (line chart + month buttons)
SELECT
    month_no,
    month_name,
    SUM(total_sales) AS total_sales,
    COUNT(*)         AS transactions
FROM sales_data
GROUP BY month_no, month_name
ORDER BY month_no;

-- Q3. Total sales by city (map visual)
SELECT
    city,
    SUM(total_sales) AS total_sales,
    SUM(units_sold)  AS total_quantity
FROM sales_data
GROUP BY city
ORDER BY total_sales DESC;

-- Q4. Top 10 mobile models by sales (bar chart)

SELECT
    mobile_model,
    brand,
    SUM(total_sales) AS total_sales,
    SUM(units_sold)  AS units_sold
FROM sales_data
GROUP BY mobile_model, brand
ORDER BY total_sales DESC
LIMIT 10;

-- Q5. Payment method share with percentage (pie chart)
SELECT
    payment_method,
    COUNT(*) AS transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_share
FROM sales_data
GROUP BY payment_method
ORDER BY transactions DESC;

-- Q6. Brand summary table (Brand | Total Sales | Total Qty | Transactions)
SELECT
    brand,
    SUM(total_sales) AS total_sales,
    SUM(units_sold)  AS total_quantity,
    COUNT(*)         AS transactions
FROM sales_data
GROUP BY brand
ORDER BY total_sales DESC;

-- Q7. Customer ratings distribution (funnel chart)
SELECT
    customer_rating,
    COUNT(*) AS rating_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct
FROM sales_data
GROUP BY customer_rating
ORDER BY customer_rating DESC;

-- Q8. Total sales by day of week (area chart)
SELECT
    day,
    SUM(total_sales) AS total_sales
FROM sales_data
GROUP BY day
ORDER BY total_sales DESC;


-- Q9. Month-over-month growth % (LAG window function)
WITH monthly AS (
    SELECT month_no, month_name, SUM(total_sales) AS sales
    FROM sales_data
    GROUP BY month_no, month_name
)
SELECT
    month_name,
    sales,
    LAG(sales) OVER (ORDER BY month_no) AS prev_month_sales,
    ROUND(
        (sales - LAG(sales) OVER (ORDER BY month_no))
        * 100.0 / LAG(sales) OVER (ORDER BY month_no), 2
    ) AS mom_growth_pct
FROM monthly
ORDER BY month_no;

-- Q10. Best-selling model inside each brand (RANK)
SELECT *
FROM (
    SELECT
        brand,
        mobile_model,
        SUM(total_sales) AS total_sales,
        RANK() OVER (PARTITION BY brand ORDER BY SUM(total_sales) DESC) AS rnk
    FROM sales_data
    GROUP BY brand, mobile_model
) t
WHERE rnk = 1;

-- Q11. Sales by customer age group
SELECT
    CASE
        WHEN customer_age < 25 THEN '18-24'
        WHEN customer_age BETWEEN 25 AND 34 THEN '25-34'
        WHEN customer_age BETWEEN 35 AND 44 THEN '35-44'
        WHEN customer_age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*)         AS customers,
    SUM(total_sales) AS total_sales,
    ROUND(AVG(customer_rating), 2) AS avg_rating
FROM sales_data
GROUP BY age_group
ORDER BY age_group;


--Day 3: CTEs (Common Table Expressions).
/*
WITH cte_name AS (
    -- your query here
)
SELECT * FROM cte_name;


WITH 
cte_one AS (
    -- first query
),
cte_two AS (
    -- second query, can reference cte_one
)
SELECT * FROM cte_two;
*/

WITH
category_revenue AS(
SELECT p.category, SUM(s.quantity * p.unit_price_usd) AS total_revenue
    FROM products p
    LEFT JOIN sales s ON p.product_key = s.product_key
    GROUP BY p.category
)
SELECT category, total_revenue
FROM category_revenue
WHERE total_revenue > 5000000;

--Challenge 2
--"Show me brands where total revenue is above average brand revenue."
WITH 
brand_revenue AS(
	SELECT 
		p.brand, 
		SUM(s.quantity * p.unit_price_usd) AS brand_revenue
	FROM products as p
	LEFT JOIN sales as s ON p.product_key = s.product_key
	GROUP BY p.brand
),
average_revenue AS(
	SELECT
		AVG(brand_revenue)AS average_revenue
	FROM brand_revenue
)
SELECT
	brand, brand_revenue
FROM brand_revenue, average_revenue
WHERE brand_revenue > average_revenue;

--Challenge 3 
--"Show me the top 3 customers by total spending, 
--along with their country and how many orders they've made."

WITH
customer_spending_and_order AS(
	SELECT 
		c.name AS customer,
		c.country AS country,
		SUM(s.quantity * p.unit_price_usd) AS total_spending,
		COUNT(s.order_number) AS order_count
	FROM customers AS c
	INNER JOIN sales AS s
		ON c.customer_key = s.customer_key
	INNER JOIN products AS p
		ON p.product_key = s.product_key
	GROUP BY c.name, c.country
)
SELECT
	customer,
	country,
	total_spending,
	order_count
FROM customer_spending_and_order
ORDER BY total_spending DESC
LIMIT 3;

--challenge 4
--"Show me the top 3 stores by total revenue, 
--along with the store's country, state, and number of unique products sold."

WITH store_revenue_and_unique_products_sold AS (
    SELECT 
        st.store_key AS store,
        st.country AS store_country,
        st.state AS store_state,
        SUM(p.unit_price_usd * s.quantity) AS revenue,
        COUNT(DISTINCT p.product_key) AS unique_products_sold
    FROM stores AS st
    INNER JOIN sales AS s ON s.store_key = st.store_key
    INNER JOIN products AS p ON p.product_key = s.product_key
    GROUP BY st.store_key, st.country, st.state
)
SELECT
    store,
    store_country,
    store_state,
    revenue,
    unique_products_sold
FROM store_revenue_and_unique_products_sold
ORDER BY revenue DESC
LIMIT 3;


--DAY 2
/*
By end of today you'll be comfortable with:

Multiple aggregates in one query (SUM, COUNT, AVG, MIN, MAX)
HAVING clause (filtering after grouping)
The difference between WHERE and HAVING

*/
/*
Challenge 1
"Show me total revenue, total quantity sold, average
quantity per order, and number of orders - broken down
by product category"
*/

SELECT
	p.category AS category,
	SUM(s.quantity * p.unit_price_usd) AS Revenue,
	SUM(s.quantity) AS Total_quantity_sold,
	ROUND(AVG(s.quantity), 2) AS Average_quantity_per_order,
	COUNT(s.order_number) AS Number_of_orders
FROM sales AS s
LEFT JOIN products AS p
	ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY SUM(s.quantity * p.unit_price_usd) DESC;

/*Challenge 2
"Show me only the product categories where total revenue exceeds $5,000,000."
*/

SELECT
	p.category AS Product_Category,
	SUM(s.quantity*p.unit_price_usd) AS Revenue
FROM products as p
LEFT JOIN sales as s
	ON p.product_key = s.product_key
GROUP BY p.category
HAVING SUM(s.quantity*p.unit_price_usd) > 5000000;

--Challenge 3
--"Show me only categories where total revenue exceeds $5,000,000
--but only count sales that happend after january 1, 2018"
SELECT
	p.category AS Product_Category,
	SUM(s.quantity*p.unit_price_usd) AS Revenue
FROM products as p
LEFT JOIN sales as s
	ON p.product_key = s.product_key
WHERE s.order_date > '01-01-2018'
GROUP BY p.category
HAVING SUM(s.quantity*p.unit_price_usd) > 5000000;

--Challenge 4
--""Show me the top 5 brands by total revenue, 
--but only include brands that have sold more than 500 orders.""

SELECT
	p.brand AS Brand,
	SUM(s.quantity*p.unit_price_usd) AS Revenue
FROM products AS p
LEFT JOIN sales AS s
	ON p.product_key = s.product_key
GROUP BY p.brand
HAVING COUNT(s.order_number) > 500
ORDER BY SUM(s.quantity*p.unit_price_usd) DESC
LIMIT 5;

--Challenge 5
--Show me each store's country, number of orders, total revenue,\
--and average order value - ordered by average order value descending."

SELECT
	st.store_key AS Store_Key,
	st.country AS Country,
	COUNT(s.order_number) as Number_of_orders,
	SUM(s.quantity*p.unit_price_usd) AS Revenue,
	ROUND(SUM(s.quantity*p.unit_price_usd)/COUNT(order_number), 2) AS Average_order_value
FROM stores AS st
LEFT JOIN sales AS s
	ON s.store_key = st.store_key
LEFT JOIN products as p
	ON p.product_key = s.product_key
WHERE s.order_number IS NOT NULL
GROUP BY st.store_key, st.country
ORDER BY SUM(s.quantity*p.unit_price_usd)/COUNT(order_number) DESC;

	
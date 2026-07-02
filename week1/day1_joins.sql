-- Week 1 Day 1: Joins
-- Dataset: Global Electronics Retailer (Maven Analytics)

-- Challenge 1: Every product with its category and supplier name
SELECT 
    p.product_name,
    c.category_name,
    s.supplier_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id;

-- Challenge 2: Anti-join — suppliers who have never had a product sold
SELECT s.supplier_name AS supplier_name
FROM suppliers AS s
LEFT JOIN products AS p ON p.supplier_id = s.supplier_id
LEFT JOIN transactions AS t ON t.product_id = p.product_id
WHERE t.transaction_id IS NULL;

-- Challenge 3: Anti-join — products that have never been sold
SELECT
    p.product_name AS product
FROM products AS p
LEFT JOIN sales AS s ON p.product_key = s.product_key
WHERE s.order_number IS NULL;

-- Challenge 4: Each sale with customer name, product name, quantity
SELECT
    s.order_number AS order_id,
    c.name AS full_name,
    p.product_name AS product_name,
    s.quantity AS quantity
FROM sales AS s
LEFT JOIN customers AS c ON s.customer_key = c.customer_key
LEFT JOIN products AS p ON p.product_key = s.product_key;

-- Challenge 5: Total quantity sold per category, highest to lowest
SELECT 
    p.category AS category,
    SUM(s.quantity) AS quantity
FROM products AS p
LEFT JOIN sales AS s ON s.product_key = p.product_key
GROUP BY p.category
ORDER BY SUM(s.quantity) DESC;

-- Challenge 6: Anti-join — customers who have never made a purchase
SELECT c.name AS customer_no_purchase
FROM customers AS c
LEFT JOIN sales AS s ON s.customer_key = c.customer_key
WHERE s.order_number IS NULL;
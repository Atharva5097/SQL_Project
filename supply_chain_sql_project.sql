

# 1. What is the total revenue from delivered orders?

SELECT SUM(total_amount) AS revenue
FROM orders
WHERE order_status = 'Delivered';

# 1. What are the top 5 selling products by quantity?

SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 5;

# 3. What is the average order value by region?

SELECT s.region, ROUND(AVG(o.total_amount), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE o.order_status = 'Delivered'
GROUP BY s.region;

# 4. Which products are supplied by more than one supplier?

SELECT product_name
FROM products
GROUP BY product_name
HAVING COUNT(DISTINCT supplier_id) > 1;

# 5. Monthly sales trend by region

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date) AS month,
        s.region,
        SUM(oi.quantity * oi.unit_price) AS sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN suppliers s ON p.supplier_id = s.supplier_id
    WHERE o.order_status = 'Delivered'
    GROUP BY DATE_TRUNC('month', o.order_date), s.region
)
SELECT * FROM monthly_sales
ORDER BY month, region;

# 6. Rank products by revenue within each category

SELECT *,
    RANK() OVER (PARTITION BY p.category ORDER BY revenue DESC) AS rank_in_category
FROM (
    SELECT p.product_name, p.category, SUM(oi.quantity * oi.unit_price) AS revenue
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.product_name, p.category
) ranked;

# 7. What is the running total of sales for each customer?

SELECT 
    customer_id, 
    order_date,
    total_amount,
    SUM(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS running_total
FROM orders
WHERE order_status = 'Delivered';

# 8. What are the top 3 suppliers by revenue contribution?

SELECT s.supplier_name, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_name
ORDER BY total_revenue DESC
LIMIT 3;

# 9. Which month had the highest order volume?

SELECT DATE_TRUNC('month', order_date) AS order_month, COUNT(*) AS order_count
FROM orders
GROUP BY order_month
ORDER BY order_count DESC
LIMIT 1;

# 10. which are the high value customers? (>10000)

SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
WHERE order_status = 'Delivered'
GROUP BY customer_id
HAVING SUM(total_amount) > 10000;

# 11. Find suppliers with no delivered orders?

SELECT s.supplier_name
FROM suppliers s
LEFT JOIN products p ON s.supplier_id = p.supplier_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.order_id AND o.order_status = 'Delivered'
WHERE o.order_id IS NULL;

# 12. Find Compare delivered vs cancelled orders per region?

SELECT s.region, o.order_status, COUNT(*) AS total_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY s.region, o.order_status
ORDER BY s.region;

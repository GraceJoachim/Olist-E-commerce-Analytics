-- Delivered orders only 
WITH delivered_orders AS (
    SELECT *
    FROM olist_orders_dataset
    WHERE order_status = 'delivered'
)
SELECT COUNT(*) AS delivered_orders_count
FROM delivered_orders;


-- Total revenue
SELECT
    ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM olist_order_items_dataset;


--Orders per customer
SELECT
    ROUND(COUNT(DISTINCT order_id)::NUMERIC /
          COUNT(DISTINCT customer_id), 2) AS orders_per_customer
FROM olist_orders_dataset;


--Average order value (AOV)
WITH order_revenue AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS order_total
    FROM olist_order_items_dataset
    GROUP BY order_id
)
SELECT
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM order_revenue;


--Customer lifetime value (revenue per customer)
WITH customer_spend AS (
    SELECT
        o.customer_id,
        SUM(oi.price + oi.freight_value) AS total_spent
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY o.customer_id
)
SELECT
    ROUND(AVG(total_spent), 2) AS avg_customer_ltv,
    ROUND(MAX(total_spent), 2) AS max_customer_ltv
FROM customer_spend;


-- Revenue concentration (top customers)
WITH ranked_customers AS (
    SELECT
        customer_id,
        SUM(oi.price) AS revenue,
        NTILE(5) OVER (ORDER BY SUM(oi.price) DESC) AS revenue_group
    FROM olist_orders_dataset o
    JOIN olist_order_items_dataset oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY customer_id
)
SELECT
    revenue_group,
    ROUND(SUM(revenue), 2) AS group_revenue
FROM ranked_customers
GROUP BY revenue_group
ORDER BY revenue_group;


--Top categories by revenue
SELECT
    t.product_category_name_english AS category,
    ROUND(SUM(oi.price), 2) AS revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY revenue DESC
LIMIT 10;


--Low-volume but high-value products
SELECT
    oi.product_id,
    COUNT(*) AS units_sold,
    ROUND(AVG(oi.price), 2) AS avg_price
FROM olist_order_items_dataset oi
GROUP BY oi.product_id
HAVING COUNT(*) < 50
ORDER BY avg_price DESC;


--Top 10 sellers by revenue
SELECT
    seller_id,
    ROUND(SUM(price), 2) AS revenue
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;


--Sellers with high freight cost impact
SELECT
    seller_id,
    ROUND(AVG(freight_value / price), 2) AS freight_ratio
FROM olist_order_items_dataset
GROUP BY seller_id
HAVING AVG(freight_value / price) > 0.5;

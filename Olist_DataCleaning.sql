--Check row counts for each table
--This allows us to know how big the dataset we are working with
SELECT 'customers' AS table_name, COUNT(*) FROM olist_customers_dataset
UNION ALL
SELECT 'orders', COUNT(*) FROM olist_orders_dataset
UNION ALL
SELECT 'order_items', COUNT(*) FROM olist_order_items_dataset
UNION ALL
SELECT 'payments', COUNT(*) FROM olist_order_payments_dataset
UNION ALL
SELECT 'reviews', COUNT(*) FROM olist_order_reviews_dataset
UNION ALL
SELECT 'products', COUNT(*) FROM olist_products_dataset
UNION ALL
SELECT 'sellers', COUNT(*) FROM olist_sellers_dataset;

-- Check for missing critical keys
SELECT COUNT(*) AS orders_without_customers
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) AS order_items_without_orders
FROM olist_order_items_dataset oi
LEFT JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

--Check duplicate customer records
SELECT customer_unique_id, COUNT(*) AS occurrences
FROM olist_customers_dataset
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;

--Delete the duplicated rows using a CTE
WITH duplicates AS (
    SELECT customer_id
    FROM (
        SELECT
            customer_id,
            ROW_NUMBER() OVER (
                PARTITION BY customer_unique_id
                ORDER BY customer_id DESC
            ) AS rn
        FROM olist_customers_dataset
    ) t
    WHERE rn > 1
)
DELETE FROM olist_customers_dataset
WHERE customer_id IN (SELECT customer_id FROM duplicates);

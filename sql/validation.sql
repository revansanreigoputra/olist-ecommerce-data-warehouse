USE olist_dw;


-- =========================================================
-- 1. ROW COUNT VALIDATION
-- =========================================================

SELECT 'dim_customer' AS table_name, COUNT(*) AS row_count
FROM dim_customer

UNION ALL

SELECT 'dim_product', COUNT(*)
FROM dim_product

UNION ALL

SELECT 'dim_seller', COUNT(*)
FROM dim_seller

UNION ALL

SELECT 'dim_date', COUNT(*)
FROM dim_date

UNION ALL

SELECT 'fact_sales', COUNT(*)
FROM fact_sales;


-- =========================================================
-- 2. CUSTOMER UNIQUENESS
-- =========================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_unique_id) AS distinct_customers
FROM dim_customer;


-- =========================================================
-- 3. NULL CUSTOMER BUSINESS KEY
-- =========================================================

SELECT COUNT(*) AS null_customer_unique_id
FROM dim_customer
WHERE customer_unique_id IS NULL;


-- =========================================================
-- 4. ORPHAN CUSTOMER CHECK
-- =========================================================

SELECT COUNT(*) AS orphan_customer
FROM fact_sales f
LEFT JOIN dim_customer c
    ON f.customer_sk = c.customer_sk
WHERE f.customer_sk IS NOT NULL
  AND c.customer_sk IS NULL;


-- =========================================================
-- 5. ORPHAN PRODUCT CHECK
-- =========================================================

SELECT COUNT(*) AS orphan_product
FROM fact_sales f
LEFT JOIN dim_product p
    ON f.product_sk = p.product_sk
WHERE f.product_sk IS NOT NULL
  AND p.product_sk IS NULL;


-- =========================================================
-- 6. ORPHAN SELLER CHECK
-- =========================================================

SELECT COUNT(*) AS orphan_seller
FROM fact_sales f
LEFT JOIN dim_seller s
    ON f.seller_sk = s.seller_sk
WHERE f.seller_sk IS NOT NULL
  AND s.seller_sk IS NULL;


-- =========================================================
-- 7. SALES METRICS
-- =========================================================

SELECT
    SUM(price) AS total_revenue,
    SUM(freight_value) AS total_freight,
    SUM(total_item_value) AS total_sales
FROM fact_sales;


-- =========================================================
-- 8. ORDER AND ITEM METRICS
-- =========================================================

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(*) AS total_items
FROM fact_sales;


-- =========================================================
-- 9. DELIVERY STATUS
-- =========================================================

SELECT
    is_late,
    COUNT(*) AS item_count
FROM fact_sales
GROUP BY is_late
ORDER BY is_late;


-- =========================================================
-- 10. DELIVERY PERFORMANCE
-- =========================================================

SELECT
    COUNT(*) AS delivered_items,
    SUM(CASE WHEN is_late = 1 THEN 1 ELSE 0 END) AS late_items,
    ROUND(
        SUM(CASE WHEN is_late = 1 THEN 1 ELSE 0 END)
        / COUNT(*) * 100,
        2
    ) AS late_percentage
FROM fact_sales
WHERE is_late IS NOT NULL;


-- =========================================================
-- 11. MONTHLY SALES
-- =========================================================

SELECT
    d.year,
    d.month,
    SUM(f.total_item_value) AS total_sales
FROM fact_sales f
JOIN dim_date d
    ON f.order_date_sk = d.date_sk
GROUP BY
    d.year,
    d.month
ORDER BY
    d.year,
    d.month;
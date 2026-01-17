-- Example Snowflake SQL queries for testing transpilation

-- Simple SELECT with filtering
SELECT 
    id,
    name,
    email,
    created_at
FROM users
WHERE active = TRUE
  AND created_at >= '2024-01-01'
ORDER BY created_at DESC
LIMIT 100;

-- String concatenation and formatting
SELECT 
    user_id,
    first_name || ' ' || last_name AS full_name,
    email || '@company.com' AS company_email
FROM users
WHERE last_name IS NOT NULL;

-- Date arithmetic
SELECT 
    order_id,
    user_id,
    amount,
    created_at,
    DATEADD(day, -7, created_at) AS week_ago,
    DATEDIFF(day, created_at, CURRENT_DATE()) AS days_old
FROM orders
WHERE created_at >= DATEADD(month, -3, CURRENT_DATE());

-- Window functions
SELECT 
    id,
    user_id,
    amount,
    created_at,
    ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at DESC) AS rn,
    SUM(amount) OVER (PARTITION BY user_id) AS user_total,
    AVG(amount) OVER (ORDER BY created_at ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg
FROM orders;

-- CTEs with JOINs
WITH active_users AS (
    SELECT id, email, created_at
    FROM users
    WHERE active = TRUE
),
recent_orders AS (
    SELECT user_id, SUM(amount) AS total_amount, COUNT(*) AS order_count
    FROM orders
    WHERE created_at >= DATEADD(day, -30, CURRENT_DATE())
    GROUP BY user_id
)
SELECT 
    u.id,
    u.email,
    COALESCE(o.total_amount, 0) AS order_total,
    COALESCE(o.order_count, 0) AS order_count
FROM active_users u
LEFT JOIN recent_orders o ON u.id = o.user_id
ORDER BY order_total DESC;

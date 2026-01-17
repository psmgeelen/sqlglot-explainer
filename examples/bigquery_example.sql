-- Example BigQuery SQL (transpiled from Snowflake examples)
-- These are the expected outputs after transpilation

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
  CONCAT(first_name, ' ', last_name) AS full_name,
  CONCAT(email, '@company.com') AS company_email
FROM users
WHERE last_name IS NOT NULL;

-- Date arithmetic
SELECT
  order_id,
  user_id,
  amount,
  created_at,
  DATE_SUB(created_at, INTERVAL 7 DAY) AS week_ago,
  DATE_DIFF(CURRENT_DATE(), created_at, DAY) AS days_old
FROM orders
WHERE created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 MONTH);

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
  WHERE created_at >= DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY)
  GROUP BY user_id
)
SELECT
  u.id,
  u.email,
  COALESCE(o.total_amount, 0) AS order_total,
  COALESCE(o.order_count, 0) AS order_count
FROM active_users AS u
LEFT JOIN recent_orders AS o ON u.id = o.user_id
ORDER BY order_total DESC;

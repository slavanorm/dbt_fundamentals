WITH customer_orders AS (
  SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS most_recent_order_date,
    COUNT(order_id) AS number_of_orders,
    SUM(amount) AS lifetime_value
  FROM {{ ref('fct_orders')}}
  GROUP BY 1
),
  final AS (
    SELECT
      a.customer_id,
      a.first_name,
      a.last_name,
      b.first_order_date,
      b.most_recent_order_date,
      COALESCE(b.number_of_orders, 0) AS number_of_orders,
      b.lifetime_value
    FROM {{ ref('stg_customers')}} a
      LEFT JOIN customer_orders b USING (customer_id)
  )
SELECT *
FROM final

WITH order_payments AS (
  SELECT
    order_id,
    SUM(amount) AS amount

  FROM {{ ref('stg_payments') }}
  WHERE status = 'success'
  GROUP BY 1
),
  final AS (
    SELECT
      a.order_id,
      a.customer_id,
      a.order_date,
      COALESCE(b.amount, 0) AS amount

    FROM {{ ref('stg_orders')}} a
  LEFT JOIN order_payments b
  USING (order_id)
  )
SELECT *
FROM final

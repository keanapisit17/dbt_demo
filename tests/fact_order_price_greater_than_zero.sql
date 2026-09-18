SELECT *
FROM {{ ref('fact_order') }}
WHERE item_price_after_discount < 0
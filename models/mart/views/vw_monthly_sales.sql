WITH 
    orders AS (
        SELECT
            MASTER_PRODUCT_ID,
            PLATFORM,
            REGION,
            ORDER_ID,
            PRODUCT_ID,
            SKU_ID,
            ORDER_AT,
            TO_CHAR(ORDER_AT, 'YYYY-MM') AS ORDER_YEAR_MONTH,
            QUANTITY,
            ITEM_PRICE,
            ITEM_PLATFORM_DISCOUNT,
            ITEM_SELLER_DISCOUNT,
            ITEM_SHIPPING_FEE,
            ITEM_PRICE_AFTER_DISCOUNT,
            ORDER_STATUS,
            ORDER_KEY
        FROM {{ ref('fact_order') }}
    )

SELECT
    ORDER_YEAR_MONTH,
    PLATFORM,
    REGION,
    COUNT(DISTINCT ORDER_KEY) AS TOTAL_ORDERS,
    COALESCE(SUM(QUANTITY),0) AS TOTAL_UNITS,
    COALESCE(SUM(ITEM_PRICE_AFTER_DISCOUNT),0) AS TOTAL_REVENUE
FROM orders o
GROUP BY 1,2,3
ORDER BY 1,2,3




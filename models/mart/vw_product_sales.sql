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
            QUANTITY,
            ITEM_PRICE,
            ITEM_PLATFORM_DISCOUNT,
            ITEM_SELLER_DISCOUNT,
            ITEM_SHIPPING_FEE,
            ITEM_PRICE_AFTER_DISCOUNT,
            ORDER_STATUS,
            ORDER_KEY
        FROM {{ ref('fact_order') }}
        WHERE ORDER_STATUS = 'COMPLETED'
    ),
    product AS (
        SELECT
            MASTER_PRODUCT_ID,
            PLATFORM,
            REGION,
            PRODUCT_ID,
            SKU_ID,
            PRODUCT_NAME,
            SHOP_NAME,
            RATING,
            PRODUCT_KEY
        FROM {{ ref('dim_product') }}
    )

SELECT
    p.MASTER_PRODUCT_ID,
    p.PLATFORM,
    p.REGION,
    p.PRODUCT_NAME,
    COUNT(DISTINCT o.ORDER_KEY) AS TOTAL_ORDERS,
    SUM(o.QUANTITY) AS TOTAL_UNITS,
    SUM(o.ITEM_PRICE_AFTER_DISCOUNT) AS TOTAL_REVENUE,
    AVG(o.ITEM_PRICE_AFTER_DISCOUNT) AS AVG_ORDER_VALUE,
    MIN(o.ORDER_AT) AS FIRST_ORDER_AT,
    MAX(o.ORDER_AT) AS LAST_ORDER_AT
FROM product p
LEFT JOIN orders o
    ON p.PLATFORM = o.PLATFORM
    AND p.REGION = o.REGION
    AND p.PRODUCT_ID = o.PRODUCT_ID
    AND p.SKU_ID = o.SKU_ID
GROUP BY 1,2,3,4
ORDER BY TOTAL_REVENUE DESC, PLATFORM, REGION






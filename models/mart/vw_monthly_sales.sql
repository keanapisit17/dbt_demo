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
            MONTH(ORDER_AT) AS ORDER_MONTH,
            QUANTITY,
            ITEM_PRICE,
            ITEM_PLATFORM_DISCOUNT,
            ITEM_SELLER_DISCOUNT,
            ITEM_SHIPPING_FEE,
            ITEM_PRICE_AFTER_DISCOUNT,
            ORDER_STATUS,
            ORDER_KEY
        FROM {{ ref('fact_order') }}
        WHERE YEAR(ORDER_AT) = YEAR(CURRENT_DATE)
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
            CATEGORY,
            BRAND,
            RATING,
            PRODUCT_KEY
        FROM {{ ref('dim_product') }}
    )

SELECT
    o.ORDER_MONTH AS MONTH,
    o.PLATFORM,
    o.REGION,
    COUNT(DISTINCT o.ORDER_KEY) AS TOTAL_ORDERS,
    SUM(o.QUANTITY) AS TOTAL_UNITS,
    SUM(o.ITEM_PRICE_AFTER_DISCOUNT) AS TOTAL_REVENUE
FROM product p
LEFT JOIN orders o
    ON p.PLATFORM = o.PLATFORM
    AND p.REGION = o.REGION
    AND p.PRODUCT_ID = o.PRODUCT_ID
    AND p.SKU_ID = o.SKU_ID
GROUP BY 1,2,3
ORDER BY 1,2,3







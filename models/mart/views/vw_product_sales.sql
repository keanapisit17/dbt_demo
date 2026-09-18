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
            ORDER_STATUS
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
            RATING
        FROM {{ ref('dim_product') }}
    ),

    month_sales AS (
        SELECT
            p.PLATFORM,
            p.REGION,
            p.MASTER_PRODUCT_ID,
            p.PRODUCT_NAME,
            o.ORDER_YEAR_MONTH,
            COUNT(DISTINCT o.ORDER_ID) AS TOTAL_ORDERS,
            COALESCE(SUM(o.QUANTITY), 0) AS TOTAL_UNITS,
            COALESCE(SUM(o.ITEM_PRICE_AFTER_DISCOUNT), 0) AS TOTAL_REVENUE,
            COALESCE(
                SUM(o.ITEM_PRICE_AFTER_DISCOUNT)/ NULLIF(COUNT(DISTINCT o.ORDER_ID), 0),
                0
            ) AS AVG_ORDER_VALUE,
            MIN(o.ORDER_AT) AS FIRST_ORDER_AT,
            MAX(o.ORDER_AT) AS LAST_ORDER_AT
        FROM product p
        LEFT JOIN orders o
            ON p.PLATFORM = o.PLATFORM
            AND p.REGION = o.REGION
            AND p.PRODUCT_ID = o.PRODUCT_ID
            AND p.SKU_ID = o.SKU_ID
        GROUP BY 1,2,3,4,5
    ),
    
    previous_month_sales AS (
        SELECT
            *,
            LAG(TOTAL_REVENUE) OVER (
                PARTITION BY MASTER_PRODUCT_ID, PLATFORM, REGION
                ORDER BY ORDER_YEAR_MONTH
            ) AS PREV_MONTH_REVENUE
        FROM month_sales
    )

SELECT
    *,
    TOTAL_REVENUE - PREV_MONTH_REVENUE AS MOM_REVENUE_CHANGE,
    (TOTAL_REVENUE / NULLIF(PREV_MONTH_REVENUE, 0)) - 1 AS MOM_REVENUE_GROWTH
FROM previous_month_sales
ORDER BY
    PLATFORM,
    REGION,
    MASTER_PRODUCT_ID,
    ORDER_YEAR_MONTH
    









WITH 
    orders AS (
        SELECT
            upper(PLATFORM) AS PLATFORM,
            upper(REGION) AS REGION,
            upper(ORDER_SN) AS ORDER_ID,
            upper(ITEM_ID) AS PRODUCT_ID,
            upper(MODEL_ID) AS SKU_ID,
            ORDER_DATE AS ORDER_AT,
            QUANTITY,
            ITEM_PRICE,
            PLATFORM_DISCOUNT AS ITEM_PLATFORM_DISCOUNT,
            SELLER_DISCOUNT AS ITEM_SELLER_DISCOUNT,
            SHIPPING_FEE AS ITEM_SHIPPING_FEE,
            BUYER_PAYMENT AS ITEM_PRICE_AFTER_DISCOUNT,
            upper(ORDER_STATUS) AS ORDER_STATUS
        FROM  {{ source('raw_data', 'order_shopee') }}
        ORDER BY ORDER_AT DESC
    ),

    mapping AS (
        SELECT 
            MASTER_PRODUCT_ID,
            PLATFORM,
            REGION,
            PRODUCT_ID,
            SKU_ID
        FROM {{ source('blue_reference', 'master_product_mapping') }}
    )

SELECT
    m.MASTER_PRODUCT_ID,
    o.PLATFORM,
    o.REGION,
    o.ORDER_ID,
    o.PRODUCT_ID,
    o.SKU_ID,
    o.ORDER_AT,
    o.QUANTITY,
    o.ITEM_PRICE,
    o.ITEM_PLATFORM_DISCOUNT,
    o.ITEM_SELLER_DISCOUNT,
    o.ITEM_SHIPPING_FEE,
    o.ITEM_PRICE_AFTER_DISCOUNT,
    o.ORDER_STATUS
FROM orders o
LEFT JOIN mapping m
    ON o.PLATFORM = m.PLATFORM
    AND o.REGION = m.REGION
    AND o.PRODUCT_ID = m.PRODUCT_ID
    AND o.SKU_ID = m.SKU_ID


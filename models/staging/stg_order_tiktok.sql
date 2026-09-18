WITH 
    orders AS (
        SELECT
            upper(PLATFORM) AS PLATFORM,
            upper(REGION) AS REGION,
            upper(ORDER_ID) AS ORDER_ID,
            upper(PRODUCT_ID) AS PRODUCT_ID,
            upper(SKU_ID) AS SKU_ID,
            CREATED_TIME AS ORDER_AT,
            QUANTITY,
            SALE_PRICE AS ITEM_PRICE,
            PLATFORM_DISCOUNT AS ITEM_PLATFORM_DISCOUNT,
            SELLER_DISCOUNT AS ITEM_SELLER_DISCOUNT,
            SHIPPING_FEE AS ITEM_SHIPPING_FEE,
            SETTLEMENT_AMOUNT AS ITEM_PRICE_AFTER_DISCOUNT,
            upper(STATUS) AS ORDER_STATUS,
            CONCAT_WS(
                '_',
                UPPER(REGION),
                UPPER(PRODUCT_ID),
                UPPER(SKU_ID),
                UPPER(ORDER_ID)
            ) AS ORDER_KEY
        FROM  {{ source('raw_data', 'order_tiktok') }}
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
    o.ORDER_STATUS,
    CONCAT_WS(
        '_',
        m.MASTER_PRODUCT_ID,
        UPPER(o.ORDER_ID)
    ) AS ORDER_KEY  -- unique key
FROM orders o
LEFT JOIN mapping m
    ON o.PLATFORM = m.PLATFORM
    AND o.REGION = m.REGION
    AND o.PRODUCT_ID = m.PRODUCT_ID
    AND o.SKU_ID = m.SKU_ID



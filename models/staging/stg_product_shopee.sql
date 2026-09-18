WITH 
    product AS (
        SELECT
            upper(PLATFORM) AS PLATFORM,
            upper(REGION) AS REGION,
            upper(ITEM_ID) AS PRODUCT_ID,
            upper(MODEL_ID) AS SKU_ID,
            ITEM_NAME AS PRODUCT_NAME,
            SHOP_NAME,
            CATEGORY,
            BRAND,
            PRICE,
            STOCK,
            RATING,
            SOLD_COUNT AS UNITS_SOLD
        FROM {{ source('raw_data', 'product_shopee') }}
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
    p.PLATFORM,
    p.REGION,
    p.PRODUCT_ID,
    p.SKU_ID,
    p.PRODUCT_NAME,
    p.SHOP_NAME,
    p.CATEGORY,
    p.BRAND,
    p.PRICE,
    p.STOCK,
    p.RATING,
    p.UNITS_SOLD,
    CONCAT_WS(
        '_',
        p.PLATFORM,
        p.REGION,
        p.PRODUCT_ID,
        p.SKU_ID
    ) AS PRODUCT_KEY  -- unique key
FROM product p
LEFT JOIN mapping m
    ON p.PLATFORM = m.PLATFORM
    AND p.REGION = m.REGION
    AND p.PRODUCT_ID = m.PRODUCT_ID
    AND p.SKU_ID = m.SKU_ID



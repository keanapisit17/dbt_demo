WITH 
    product AS (
        SELECT
            upper(PLATFORM) AS PLATFORM,
            upper(REGION) AS REGION,
            upper(PRODUCT_ID) AS PRODUCT_ID,
            upper(SKU_ID) AS SKU_ID,
            PRODUCT_NAME,
            SHOP_NAME,
            PRODUCT_CATEGORY AS CATEGORY,
            BRAND,
            LISTING_PRICE AS PRICE,
            AVAILABLE_STOCK AS STOCK,
            RATING,
            ORDERS AS UNITS_SOLD
        FROM {{ source('raw_data', 'product_tiktok') }}
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
    m.MASTER_PRODUCT_ID, -- unique key
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
    p.UNITS_SOLD
FROM product p
LEFT JOIN mapping m
    ON p.PLATFORM = m.PLATFORM
    AND p.REGION = m.REGION
    AND p.PRODUCT_ID = m.PRODUCT_ID
    AND p.SKU_ID = m.SKU_ID



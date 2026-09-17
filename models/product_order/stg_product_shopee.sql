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
    SOLD_COUNT AS UNITS_SOLD,
    CONCAT_WS(
        '_',
        UPPER(REGION),
        UPPER(PLATFORM),
        UPPER(PRODUCT_ID),
        UPPER(SKU_ID)
    ) AS PRODUCT_KEY
FROM {{ source('raw_data', 'product_shopee') }}
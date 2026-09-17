SELECT
    upper(PLATFORM) AS PLATFORM,
    upper(REGION) AS REGION,
    upper(ORDER_ID) AS ORDER_ID,
    CREATED_TIME AS ORDER_AT,
    SHOP_NAME,
    STATUS AS ORDER_STATUS,
    GROSS_SALES AS TOTAL_AMOUNT,
    TOTAL_DISCOUNT,
    SHIPPING_FEE,
    CONCAT_WS(
        '_',
        UPPER(REGION),
        UPPER(PLATFORM),
        UPPER(ORDER_ID)
    ) AS ORDER_KEY
FROM {{ source('raw_data', 'order_tiktok') }}


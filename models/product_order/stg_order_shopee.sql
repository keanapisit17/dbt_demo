SELECT
    upper(PLATFORM) AS PLATFORM,
    upper(REGION) AS REGION,
    upper(ORDER_SN) AS ORDER_ID,
    ORDER_DATE AS ORDER_AT,
    SHOP_NAME,
    ORDER_STATUS,
    TOTAL_AMOUNT,
    TOTAL_DISCOUNT,
    SHIPPING_FEE,
    CONCAT_WS(
        '_',
        UPPER(REGION),
        UPPER(PLATFORM),
        UPPER(ORDER_ID)
    ) AS ORDER_KEY
FROM {{ source('raw_data', 'order_shopee') }}
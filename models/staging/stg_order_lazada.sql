WITH
    orders AS (
        SELECT
            upper(platform) AS platform,
            upper(region) AS region,
            upper(order_number) AS order_id,
            upper(product_code) AS product_id,
            upper(seller_sku) AS sku_id,
            created_at AS order_at,
            qty AS quantity,
            unit_price AS item_price,
            seller_discount AS item_platform_discount,
            voucher_amount AS item_seller_discount,
            shipping_cost AS item_shipping_fee,
            paid_amount AS item_price_after_discount,
            upper(status) AS order_status
        FROM  {{ source('raw_data', 'order_lazada') }}
    ),

    mapping AS (
        SELECT
            master_product_id,
            platform,
            region,
            product_id,
            sku_id
        FROM {{ source('blue_reference', 'master_product_mapping') }}
    )

SELECT
    m.master_product_id,
    o.platform,
    o.region,
    o.order_id,
    o.product_id,
    o.sku_id,
    o.order_at,
    o.quantity,
    o.item_price,
    o.item_platform_discount,
    o.item_seller_discount,
    o.item_shipping_fee,
    o.item_price_after_discount,
    o.order_status
FROM orders o
LEFT JOIN mapping m
    ON o.platform = m.platform
    AND o.region = m.region
    AND o.product_id = m.product_id
    AND o.sku_id = m.sku_id


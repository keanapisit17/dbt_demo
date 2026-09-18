WITH
    product AS (
        SELECT
            upper(platform) AS platform,
            upper(region) AS region,
            upper(item_id) AS product_id,
            upper(model_id) AS sku_id,
            item_name AS product_name,
            shop_name,
            category,
            brand,
            price,
            stock,
            rating,
            sold_count AS units_sold
        FROM {{ source('raw_data', 'product_shopee') }}
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
    p.platform,
    p.region,
    p.product_id,
    p.sku_id,
    p.product_name,
    p.shop_name,
    p.category,
    p.brand,
    p.price,
    p.stock,
    p.rating,
    p.units_sold
FROM product p
LEFT JOIN mapping m
    ON p.platform = m.platform
    AND p.region = m.region
    AND p.product_id = m.product_id
    AND p.sku_id = m.sku_id


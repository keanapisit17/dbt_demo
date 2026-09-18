WITH
    product AS (
        SELECT
            upper(platform) AS platform,
            upper(region) AS region,
            upper(product_code) AS product_id,
            upper(seller_sku) AS sku_id,
            product_title AS product_name,
            seller_name AS shop_name,
            category_name AS category,
            brand_name AS brand,
            selling_price AS price,
            inventory AS stock,
            review_score AS rating,
            units_sold
        FROM {{ source('raw_data', 'product_lazada') }}
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


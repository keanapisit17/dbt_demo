WITH
    orders AS (
        SELECT
            master_product_id,
            platform,
            region,
            order_id,
            product_id,
            sku_id,
            order_at,
            TO_CHAR(order_at, 'YYYY-MM') AS order_year_month,
            quantity,
            item_price,
            item_platform_discount,
            item_seller_discount,
            item_shipping_fee,
            item_price_after_discount,
            order_status
        FROM {{ ref('fact_order') }}
        WHERE order_status = 'COMPLETED'
    ),

    product AS (
        SELECT
            master_product_id,
            platform,
            region,
            product_id,
            sku_id,
            product_name,
            shop_name,
            rating
        FROM {{ ref('dim_product') }}
    ),

    month_sales AS (
        SELECT
            p.platform,
            p.region,
            p.master_product_id,
            p.product_name,
            o.order_year_month,
            COUNT(DISTINCT o.order_id) AS total_orders,
            COALESCE(SUM(o.quantity), 0) AS total_units,
            COALESCE(SUM(o.item_price_after_discount), 0) AS total_revenue,
            COALESCE(
                SUM(o.item_price_after_discount)/ NULLIF(COUNT(DISTINCT o.order_id), 0),
                0
            ) AS avg_order_value,
            MIN(o.order_at) AS first_order_at,
            MAX(o.order_at) AS last_order_at
        FROM product p
        LEFT JOIN orders o
            ON p.platform = o.platform
            AND p.region = o.region
            AND p.product_id = o.product_id
            AND p.sku_id = o.sku_id
        GROUP BY 1,2,3,4,5
    ),

    previous_month_sales AS (
        SELECT
            *,
            LAG(total_revenue) OVER (
                PARTITION BY master_product_id, platform, region
                ORDER BY order_year_month
            ) AS prev_month_revenue
        FROM month_sales
    )

SELECT
    *,
    total_revenue - prev_month_revenue AS mom_revenue_change,
    (total_revenue / NULLIF(prev_month_revenue, 0)) - 1 AS mom_revenue_growth
FROM previous_month_sales
ORDER BY
    platform,
    region,
    master_product_id,
    order_year_month










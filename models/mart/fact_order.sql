{{ config(
    materialized='incremental',
    unique_key='order_key'
) }}

WITH 
lazada AS (
    SELECT *
    FROM {{ ref('stg_order_lazada') }}
),

shopee AS (
    SELECT *
    FROM {{ ref('stg_order_shopee') }}
),

tiktok AS (
    SELECT *
    FROM {{ ref('stg_order_tiktok') }}
)

SELECT * FROM lazada
UNION ALL
SELECT * FROM shopee
UNION ALL
SELECT * FROM tiktok



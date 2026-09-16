with 

source as (
    select *, 
    concat_ws(
        region,
        platform,
        product_id,
        sku_id
    ) as product_key
    from {{ source('raw_data', 'product_shopee') }}
)

select * from source
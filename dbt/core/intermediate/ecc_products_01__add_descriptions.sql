{{ config(materialized = 'ephemeral') }}

with

-- get finished products
finished_products as (

    select * from {{ ref('stg_ecc_finished_products') }}

),

-- get product descriptions
descriptions as (

    select * from {{ ref('stg_ecc_product_descriptions') }}

),

-- get descriptions for finished products
final_cte as (

    select
        finished_products.sku,
        descriptions.product_description 
    
    from finished_products
    inner join descriptions
        on finished_products.sku = descriptions.sku

)

select * from final_cte
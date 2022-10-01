{{ config(materialized = 'ephemeral') }}

with 

orders as (
    
    select * from {{ ref('stg_ecc_orders') }}

),

order_categories as (
    
    select * from {{ ref('stg_ecc_order_category_descriptions') }}

),

final_cte as (

    select
        orders.*,
        order_categories.order_category_description
    
    from orders
    inner join order_categories on orders.order_category = order_categories.order_category

)

select * from final_cte


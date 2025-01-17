{{ config(materialized = 'ephemeral') }}

with 

orders as (

    select * from {{ ref('ecc_orders_01__add_order_category_descriptions') }}

),

order_status as (

    select * from {{ ref('stg_ecc_order_status') }}

),

final_cte as (

    select
        orders.*,
        order_status.overall_status

    from orders
    left join order_status on orders.order_number = order_status.order_number

)

select * from final_cte

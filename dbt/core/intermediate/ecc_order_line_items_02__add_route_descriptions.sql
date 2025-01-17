{{ config(materialized = 'ephemeral') }}

with 

line_items as (

    select * from {{ ref('ecc_order_line_items_01__add_rejection_reason_descriptions') }}

),

route_descriptions as (

    select * from {{ ref('stg_ecc_orders__route_descriptions') }}

),


final_cte as (

    select
        line_items.*,
        route_descriptions.route_description

    from line_items
    left outer join route_descriptions on line_items.route = route_descriptions.route

)

select * from final_cte
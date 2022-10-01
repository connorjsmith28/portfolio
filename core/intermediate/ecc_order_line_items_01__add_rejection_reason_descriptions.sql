{{ config(materialized = 'ephemeral') }}

with 

line_items as (

    select * from {{ ref('stg_ecc_order_line_items') }}

),

rejection_reasons as (

    select * from {{ ref('stg_ecc_order_line_item_rejection_reasons') }}

),


final_cte as (

    select
        line_items.*,
        rejection_reasons.rejection_reason_description

    from line_items
    left outer join rejection_reasons on line_items.rejection_reason_code = rejection_reasons.rejection_reason_code

)

select * from final_cte
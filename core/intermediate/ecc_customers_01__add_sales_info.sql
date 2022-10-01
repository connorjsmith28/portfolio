{{ config(materialized = 'ephemeral') }}

with

general_info as (

    select * from {{ ref('stg_ecc_customers__general_information') }}

),

sales_info as (

    select * from {{ ref('stg_ecc_customers__sales_information') }}

),

final_cte as (

    select
        general_info.*,
        sales_info.sales_org,
        sales_info.price_group,
        sales_info.price_list_type,
        sales_info.special_group
    
    from general_info
    left outer join sales_info on general_info.account_number = sales_info.account_number

)

select * from final_cte

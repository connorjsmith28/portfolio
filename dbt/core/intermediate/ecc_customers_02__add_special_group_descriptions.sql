{{ config(materialized = 'ephemeral') }}

with

customers as (

    select * from {{ ref('ecc_customers_01__add_sales_info') }}

),

special_groups as (

    select * from {{ ref('stg_ecc_customers__special_group_descriptions') }}

),

final_cte as (

    select
        customers.*,
        special_groups.special_group_description
        

    from customers
    left join special_groups on
        customers.special_group = special_groups.special_group and
        customers.language_key = special_groups.language_key
)

select 
    * 

from final_cte
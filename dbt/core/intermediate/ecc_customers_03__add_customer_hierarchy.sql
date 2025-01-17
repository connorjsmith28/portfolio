{{ config(materialized = 'ephemeral') }}

with

customers as (

    select * from {{ ref('ecc_customers_02__add_special_group_descriptions') }}

),

hierarchies as (

    select 
        *
    from {{ ref('stg_ecc_customer_hierarchy') }}
    where valid_to = '99991231'

),

final_cte as (
    select
        customers.*,
        hierarchies.customer_hierarchy_level

    from customers
    left outer join hierarchies on customers.account_number = hierarchies.account_number and
                                    customers.sales_org = hierarchies.sales_org
)

select * from final_cte
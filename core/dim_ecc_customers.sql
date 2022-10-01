{{ config(materialized = 'table') }}

with 

--get general customer information w/ sales org and customer hierarch
customers_01 as (

    select * from {{ ref('ecc_customers_03__add_customer_hierarchy') }}

),

--get customer sales information
sales_info_01 as (

    select * from {{ ref('stg_ecc_customers__sales_information') }}

),


--add new fields
customers_02 as (

    select
        *,
        
        case 
            when customer_class = 'B' then 'BREEDER'
            when customer_class = 'E' then 'ECOMMERCE'
            when customer_class = 'P' then 'VET CHANNEL'
            when customer_class = 'S' then 'PET CHANNEL'
            when customer_class = 'Z' then 'DEFERRED'
            else null
        end as customer_class_description,

        case
            when deletion_flag = 'X' then 0
            else 1
        end as active_flag,

        case
            when sales_org is null then 'NONE'
            else sales_org
        end as sales_organization
    
    from customers_01

),

--add npp program flag
sales_info_02 as (

    select
        *,

        case
            when price_list_type = 'Z3' and sales_org = 'USHD' then 1
            when price_list_type is null and sales_org = 'USHD' then 0
            else null
        end as npp_us_flag
    
    from sales_info_01

),


--join customer general info to sales info
joined as (

    select
        customers_02.account_number,
        customers_02.account_created_on,
        customers_02.customer_name1,
        customers_02.customer_name2,
        customers_02.customer_name3,
        customers_02.customer_name4,
        customers_02.language_key, 
        customers_02.street_address,
        customers_02.city,
        customers_02.state,
        customers_02.postal_code,
        customers_02.country,
        customers_02.phone_number,
        customers_02.fax_number,
        customers_02.active_flag,
        customers_02.industry_sector,
        customers_02.customer_class,
        customers_02.customer_class_description,
        sales_info_02.customer_tier,
        sales_info_02.customer_grade,
        customers_02.sales_organization,
        sales_info_02.distribution_channel,
        sales_info_02.sales_division,
        sales_info_02.sales_region,
        sales_info_02.sales_district,
        sales_info_02.sales_territory,
        sales_info_02.price_group,
        sales_info_02.price_list_type,
        sales_info_02.npp_us_flag,
        sales_info_02.special_group,
        customers_02.special_group_description,
        customers_02.customer_hierarchy_level

    from sales_info_02
    right outer join customers_02 on 
        sales_info_02.account_number = customers_02.account_number and
        sales_info_02.sales_org = customers_02.sales_organization
    
),


--add primary key
final_cte as (

    select
        {{ dbt_utils.surrogate_key(
            ['account_number', 'sales_organization']
        ) }} as customer_sales_id,

        *
    
    from joined

)

select * from final_cte
{{ config(
    materialized ='incremental',
    unique_key ='order_id',
    pre_hook =  "update {{ ref('seed_incremental_fct') }}    
                set prerun_update = (select {{ dbt_utils.current_timestamp() }});",
    post_hook = "update {{ ref('seed_incremental_fct') }}
                set last_update = (select prerun_update from {{ ref('seed_incremental_fct') }})"    
) }}
--the pre_hook updates sets the timestamp when the fact begins it's load. The post hook takes that value and updates the table
--that future runs will base their filter on

with 

orders as (

    select * from {{ ref('ecc_orders_02__add_order_status') }}

),

order_types as (

    select * from {{ ref('stg_ecc_order_type_descriptions') }}

),

sold_to_customers as (

    select * from {{ ref('stg_ecc_order_sold_to_customers') }}

),

ship_to_customers as (

    select * from {{ ref('stg_ecc_order_ship_to_customers') }}

),

contacts as (

    select * from {{ ref('ecc_order_contacts_01__add_account_number') }}

),

line_items as (

    select * from {{ ref('ecc_order_line_items_02__add_route_descriptions') }}

),

joined as (

    select
        orders.order_number,
        orders.order_type,
        order_types.order_type_description,
        orders.order_placed_on,
        orders.order_category,
        orders.order_category_description,
        orders.currency,
        orders.payment_method,
        orders.sales_org,
        orders.dist_channel,
        orders.division,
        orders.sales_group,
        orders.sales_office,
        orders.overall_status,
        sold_to_customers.sold_to_account_number,
        sold_to_customers.sold_to_country,
        ship_to_customers.ship_to_account_number,
        ship_to_customers.ship_to_country,
        contacts.contact_account_number,
        line_items.order_line_item_number,
        line_items.sku,
        line_items.order_qty,
        line_items.selling_unit,
        line_items.net_price,
        line_items.net_weight,
        line_items.net_value,
        line_items.rejection_reason_code,
        line_items.rejection_reason_description,
        line_items.route,
        line_items.route_description

    from orders
    left outer join order_types on orders.order_type = order_types.order_type
    left outer join sold_to_customers on orders.order_number = sold_to_customers.order_number
    left outer join ship_to_customers on orders.order_number = ship_to_customers.order_number
    left outer join contacts on orders.order_number = contacts.order_number
    left outer join line_items on orders.order_number = line_items.order_number

),

final_cte as (

    select
        {{ dbt_utils.surrogate_key(['order_number', 'order_line_item_number']) }} as order_id,
        order_number,
        order_type,
        order_type_description,
        
        case
            when order_type = 'ZEDI' then 'EDI'
            when order_type = 'ZISA' then 'HILLS RETAIL ONLINE'
            when order_type in ('TA', 'ZFAX') then 'MANUAL'
            when order_type = 'ZHTH' then 'HILLS TO HOME'
            when order_type in ('ZY01', 'ZY02', 'ZY03', 'ZY05') then 'AGENCY'
            when order_type = 'ZK01' then 'HILLS ENDORSER FEED'
            when order_type = 'ZSTF' then 'STAFF FEEDING'
            when order_type = 'ZTR' then 'TRUCKLOAD'
            when order_type in ('ZPND', 'ZWC') then 'OTHER'
            else null
        end as order_type_vet_channel_us,

        order_placed_on,
        order_category,
        order_category_description,
        currency,

        case
            when payment_method is null then 'Other'
            else 'Credit'
        end as payment_type,

        sales_org,
        dist_channel,
        division,
        sales_office,
        sales_group,
        overall_status,

        case
            when overall_status is null then 'Not relevant'
            when overall_status = 'A' then 'Not yet processed'
            when overall_status = 'B' then 'Partially processed'
            when overall_status = 'C' then 'Completely processed'
            else null
        end as overall_status_description,

        sold_to_account_number,
        sold_to_country,

        case
            when sold_to_account_number != ship_to_account_number then 'CORPORATE'
            else 'INDEPENDENT'
        end as sold_to_account_type,

        ship_to_account_number,
        ship_to_country,
        contact_account_number,
        order_line_item_number,
        sku,
        order_qty,

        case
            when selling_unit = 'BAL' THEN 'BALE'
            when selling_unit = 'CAS' THEN 'CASE'
            when selling_unit = 'KI' THEN 'KIT'
            when selling_unit = 'PAL' THEN 'PALLET'
            else selling_unit
        end as selling_unit,

        net_Price,
        net_weight,
        net_value,
        rejection_reason_code,
        rejection_reason_description,

        case
            when rejection_reason_code is null then 0
            else 1
        end as rejection_flag,

        route,
        route_description,
        {{ dbt_utils.surrogate_key(['sold_to_account_number', 'sales_org']) }} as customer_sales_id,
        {{ dbt_utils.surrogate_key(['sku', 'sales_org']) }} as product_sales_id

    from joined

)

select * from final_cte

with

base as (

    select * from {{ ref('base_ecc_zhybris_orderlog_merge') }}

),

final_cte as (

    select
        {{ dbt_utils.surrogate_key(
            ['ship_to', 'logno', 'sales_order', 'sales_item', 'sku']
        ) }} as merge_order_id,        
        
        logno as log_number,
        sales_order as order_number,
        sales_item as order_line_item_number,
        sku,
        ship_to as ship_to_account_number,
        rfc_name as function_name,

        case
            when changed_date = '00000000' then null
            else to_date(changed_date, 'YYYYMMDD')
        end as merged_on,

        to_time(changed_time, 'HH24MISS') as merged_on_time
    
    from base
    
)

select * from final_cte
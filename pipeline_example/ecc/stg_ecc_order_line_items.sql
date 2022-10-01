with 

base as (

    select * from {{ ref('base_ecc_vbap') }} 

),

final_cte as (
    
    select
        vbeln as order_number,
        posnr as order_line_item_number,

        {{ dbt_utils.surrogate_key(
            ['vbeln', 'posnr']
        ) }} as order_item_id,
        
        case
            when trim(matnr) = '' then null
            else matnr
        end as sku,
        
        kwmeng as order_qty,

        case
            when trim(vrkme) = '' then null
            else upper(trim(vrkme))
        end as selling_unit,

        netpr as net_price,
        ntgew as net_weight,
        netwr as net_value,

        case
            when trim(abgru) = '' then null
            else abgru
        end as rejection_reason_code,

        case
            when trim(route) = '' then null
            else upper(route)
        end as route

    from base
  
)

select * from final_cte
with 

base as (

    select * from {{ ref('base_ecc_mvke') }}

),

final_cte as (

    select
        {{ dbt_utils.surrogate_key(
            ['matnr', 'vkorg']
        ) }} as product_sales_id,
        
        matnr as sku,
        vkorg as sales_org,
        mvgr2 as product_form,
        
        case
            when trim(vmsta) = '' then null
            else cast(vmsta as integer)
        end as product_status,
        
        case
            when vmstd != '00000000' then to_date(vmstd, 'YYYYMMDD')
            else null
        end as status_valid_from

    from base

)

select * from final_cte
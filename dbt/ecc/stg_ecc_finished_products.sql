with 

base as (

    select * 
    
    from {{ ref('base_ecc_mara') }} 
    where mtart = 'FERT'

),

final_cte as (

    select
        matnr as sku,

        to_date(ersda, 'YYYYMMDD') as sku_created_on,
        
        matkl as product_group,
        meins as base_uom,
        ntgew as net_weight,
        gewei as weight_unit
    
    from base

)

select * from final_cte
with 

base as (

    select *

    from {{ ref('base_ecc_makt') }} 
    -- filter out non-english descriptions and duplicate test SKU
    where 
        spras = 'E' and
        matnr != 'BL65_____________1'

),

final_cte as (

    select
        matnr as sku,
        upper(trim(maktx)) as product_description
    
    from base

)

select * from final_cte
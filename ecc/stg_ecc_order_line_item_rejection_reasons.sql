with 

base as (

    select *

    from {{ ref('base_ecc_tvagt') }} 
    where 
        mandt = 321 and 
        spras = 'E'

),

final_cte as (

    select
        abgru as rejection_reason_code,
        bezei as rejection_reason_description
    
    from base

)

select * from final_cte
with 

base as (

    select * 
    
    from {{ ref('base_ecc_tvakt') }} 
    where 
        mandt = 321 and 
        spras = 'E'

),

final as (

    select
        auart as order_type,
        bezei as order_type_description
    
    from base

)

select * from final
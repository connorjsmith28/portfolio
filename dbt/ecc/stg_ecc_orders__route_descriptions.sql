with 

base as (

    select * 
    
    from {{ ref('base_ecc_tvrot') }} 
    where 
        mandt = 321 and 
        spras = 'E'

),

final as (

    select
        case
            when trim(route) = '' then null
            else upper(trim(route))
        end as route,
        bezei as route_description
    
    from base

)

select * from final
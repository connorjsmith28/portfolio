with 

base as (

    select * from {{ ref('base_ecc_vbak') }}

),

final_cte as (

    select 
        vbeln as order_number,
        netwr as net_value_header

    from base

)

select * from final_cte
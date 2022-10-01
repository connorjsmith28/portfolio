with 

base as (

    select * from {{ ref('base_ecc_vbak') }}

),

final_cte as (

    select 
        vbeln as order_number,
        auart as order_type,

        case
            when erdat = '00000000' then null
            else to_date(erdat, 'YYYYMMDD')
        end as order_placed_on,

        vbtyp as order_category,
        waerk as currency,
        vkorg as sales_org,
        vtweg as dist_channel,
        spart as division,
        vkgrp as sales_group,
        vkbur as sales_office,

        case
            when trim(rplnr) = '' then null
            else rplnr
        end as payment_method

    from base

)

select * from final_cte
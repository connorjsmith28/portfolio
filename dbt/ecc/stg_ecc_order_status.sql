with 

base as (

    select * from {{ ref('base_ecc_vbuk') }}

),

final as (

    select
        vbeln as order_number,

         case
            when trim(gbstk) = '' then null
            else gbstk
         end as overall_status

    from base

)

select * from final
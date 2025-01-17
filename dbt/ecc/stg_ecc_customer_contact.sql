with 

base as (

    select * from {{ ref('base_ecc_adrp') }}

),

final as (

    select
        client as client_id,
        persnumber as person_number,

        case
            when trim(title_aca1) = '' then null
            else title_aca1
        end as title_code_number

    from base

) 

select * from final
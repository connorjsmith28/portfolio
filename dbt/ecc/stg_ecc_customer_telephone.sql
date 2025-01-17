with

base as (

    select * from {{ ref('base_ecc_adr2') }}

),

final as (

    select
        client as client_id,
        persnumber as person_number,

        case
            when trim(tel_number) = '' then null
            else tel_number
        end as contact_telephone_number

    from base

)

select * from final
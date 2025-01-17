with

base as (

    select * from {{ ref('base_ecc_adr6') }}

),

final as (

    select
        client as client_id,
        persnumber as person_number,
        smtp_addr as account_email,
        smtp_addr as contact_email

    from base

)

select * from final
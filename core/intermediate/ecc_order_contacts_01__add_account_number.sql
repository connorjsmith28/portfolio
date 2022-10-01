{{ config(materialized = 'ephemeral') }}

with 

contacts as (

    select * from {{ ref('stg_ecc_order_contacts') }}

),

contact_partner as (

    select * from {{ ref('stg_ecc_customer_master_contact_partner') }} 

),

final as (

    select 
        contacts.order_number,
        contact_partner.account_number as contact_account_number

    from contacts
    left outer join contact_partner on contacts.contact_bp_number = contact_partner.contact_bp_number

)

select * from final

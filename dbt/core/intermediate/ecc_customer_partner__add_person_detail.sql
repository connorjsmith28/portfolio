{{ config(materialized = 'ephemeral') }}

with

customer_master_contact_partner as (

    select * from {{ ref('stg_ecc_customer_master_contact_partner') }}

),

person_detail as (

    select * from {{ ref('ecc_person_title__add_email_phone') }}

),

joined as (

    select
        customer_master_contact_partner.account_number,
        customer_master_contact_partner.client_id,
        customer_master_contact_partner.contact_bp_number,
        customer_master_contact_partner.contact_title,
        customer_master_contact_partner.contact_first_name,
        customer_master_contact_partner.contact_last_name,
        customer_master_contact_partner.del_flag_contact,
        customer_master_contact_partner.contact_creation_date,
        customer_master_contact_partner.contact_address_line_1,
        customer_master_contact_partner.contact_city,
        customer_master_contact_partner.contact_function,
        person_detail.person_number,
        person_detail.account_email,
        person_detail.contact_email,
        person_detail.contact_academic_title,
        person_detail.contact_telephone_number
    from customer_master_contact_partner
    left outer join person_detail on
            customer_master_contact_partner.client_id = person_detail.client_id and
            customer_master_contact_partner.contact_bp_number = person_detail.person_number
)

select * from joined

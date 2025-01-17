{{ config(materialized = 'ephemeral') }}

with 

contacts as (

    select * from {{ ref('stg_ecc_customer_contact') }}

),

titles as (

    select * from {{ ref('stg_ecc_academic_titles') }}

),

final as (
    select
        contacts.client_id,
        contacts.person_number,
        titles.contact_academic_title
    from contacts
    left outer join titles on
            contacts.client_id = titles.client_id and 
            contacts.title_code_number = titles.title_key

)

select * from final
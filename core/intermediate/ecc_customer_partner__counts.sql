{{ config(materialized = 'ephemeral') }}

with

contacts as (

    select * from {{ ref('ecc_customer_partner__add_person_detail') }}

),
--get count of contacts by account number
final as (

    select
        account_number,
        client_id,
        count(*) AS number_of_contacts
    from contacts
    group by 
        1, 2

)

select * from final
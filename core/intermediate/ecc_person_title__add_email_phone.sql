{{ config(materialized = 'ephemeral') }}

with

person_title as (

    select * from {{ ref('ecc_person__add_title') }}

),

email as (

    select * from {{ ref('stg_ecc_customer_email_address') }}

),

telephone as (

    select * from {{ ref('stg_ecc_customer_telephone') }}

),

final as (

    select
        person_title.client_id,
        person_title.person_number,
        email.account_email,
        email.contact_email,
        person_title.contact_academic_title,
        telephone.contact_telephone_number
    from person_title
    left outer join email on
	        person_title.client_id = email.client_id and
    	    person_title.person_number = email.person_number
    left outer join telephone on
    	    person_title.client_id = telephone.client_id and
            person_title.person_number = telephone.person_number
)

select * from final
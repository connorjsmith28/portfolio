with title_code as (
    select
        client as client_id,
        persnumber as person_number, 
        title_aca1 as title_code_number
    from {{ ref('base_ecc_adrp') }}
),

title_text as (
    select
        client as client_id,
        title_key,
        title_text as contact_academic_title
    from {{ ref('base_ecc_tsad2') }}

)

select 
    title_text.client_id,
    title_code.person_number,
    title_text.contact_academic_title 
from  
    title_code
left join 
    title_text
on
    title_code.client_id = title_text.client_id
and 
    title_text.title_key = title_code.title_code_number

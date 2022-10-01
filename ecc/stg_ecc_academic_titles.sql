with 

base as (
    
    select * from {{ ref('base_ecc_tsad2') }}

),

final as (

    select
        client as client_id,
        title_key as title_key,
        title_text as contact_academic_title

    from base

) 

select * from final
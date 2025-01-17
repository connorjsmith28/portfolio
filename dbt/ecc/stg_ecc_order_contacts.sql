with 

base as (

    select * 
    
    from {{ ref('base_ecc_vbpa') }} 
    where 
        posnr = '000000' and 
        parvw = 'AP'

),

final_cte as (

    select
        vbeln as order_number,
        parnr as contact_bp_number,
        land1 as contact_person_country
        
    from base

)

select * from final_cte
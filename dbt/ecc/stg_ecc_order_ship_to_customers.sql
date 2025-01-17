with 

base as (

   select * 
   
   from {{ ref('base_ecc_vbpa') }} 
   where 
      posnr = '000000' and
      parvw = 'WE'

),

final as (

   select
      vbeln as order_number,
      
      case
         when trim(kunnr) = '' then null
         else kunnr
      end as ship_to_account_number,
      
      land1 as ship_to_country

   from base

 )
 
select * from final
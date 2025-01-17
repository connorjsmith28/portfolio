with 

base as (

   select * 
   
   from {{ ref('base_ecc_vbpa') }} 
   where 
      posnr = '000000' and
      parvw = 'AG'

),

final_cte as (
   
   select
      vbeln as order_number,
      kunnr as sold_to_account_number,
      land1 as sold_to_country
   
   from base

 )

select * from final_cte
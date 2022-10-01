with 

base as (

   select * from {{ ref('seed_ecc_order_category_descriptions') }} 

),

final_cte as (

   select
      nvl(order_category, ' ') as order_category,
      order_category_description

   from base

 )

select * from final_cte
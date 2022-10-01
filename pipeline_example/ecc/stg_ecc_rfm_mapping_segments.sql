with 

base as (

   select * from {{ ref('seed_rfm_segment_mapping') }} 

),

final_cte as (

   select
      segment,
      segment_name,
      segment_number      

   from base

 )

select * from final_cte
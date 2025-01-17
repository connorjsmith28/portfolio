with 

base as (

    select * from {{ ref('base_ecc_knvh') }}

),

final as (

    select

        {{ dbt_utils.surrogate_key(['hityp','kunnr','vkorg','vtweg','spart','datab']) }} as customer_hierarchy_id,
        hityp as hierarchy_type,
        kunnr as account_number,
        vkorg as sales_org,
        vtweg as distribution_channel,
        spart as division,
        datab as valid_from,  -- There are nulls and dates in the wrong format (16.01.20 and 12/31/99) so no transformation 
        datbi as valid_to,    -- There are dates in the wrong format (12/31/99) so no transformation
        hkunnr as higher_level_account_number,

        case
            when hzuor = '00' then '05'
            else hzuor
        end as customer_hierarchy_level

    from base

) 

select * from final
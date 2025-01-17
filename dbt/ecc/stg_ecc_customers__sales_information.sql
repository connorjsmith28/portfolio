{%- set column_names = [
    
    ('kunnr', 'account_number'),
    ('kvgr2', 'customer_tier'),
    ('vkbur', 'sales_region'),
    ('vkgrp', 'sales_district'),
    ('bzirk', 'sales_territory'),
    ('konda', 'price_group'),
    ('pltyp', 'price_list_type'),
    ('kvgr3', 'special_group'),
    ('vkorg', 'sales_org'),
    ('vtweg', 'distribution_channel'),
    ('spart', 'sales_division'),
    ('klabc', 'customer_grade')

] -%}

with 

base as (
    
    select * from {{ ref('base_ecc_knvv') }}

),

final_cte as (

    select
        {{ dbt_utils.surrogate_key(
            ['kunnr', 'vkorg', 'vtweg', 'spart']
        ) }} as customer_sales_id,

        {% for column_name in column_names %}
        case
            when trim({{ column_name[0] }}) = '' then null
            else upper(trim({{ column_name[0] }}))
        end as {{ column_name[1] }}
        {% if not loop.last -%} , {%- endif %}
	    {% endfor %}

    from base

)

select * from final_cte
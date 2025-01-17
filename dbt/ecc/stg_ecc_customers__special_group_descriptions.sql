{%- set column_names = [
    
    ('kvgr3', 'special_group'),
    ('spras', 'language_key'),
    ('bezei', 'special_group_description')

] -%}

with

base as (

    select * from {{ ref('base_ecc_tvv3t') }}

),

final_cte as (

    select
        {{ dbt_utils.surrogate_key(
            ['kvgr3', 'spras']
        ) }} as special_group_id,

        {% for column_name in column_names %}
        case
            when trim({{ column_name[0] }}) = '' then null
            else upper({{ column_name[0] }})
        end as {{ column_name[1] }}
        {% if not loop.last -%} , {%- endif %}
	    {% endfor %}
    
    from base

)

select * from final_cte
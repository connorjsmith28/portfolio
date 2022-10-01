{%- set column_names = [

    ('kunnr', 'account_number'),
    ('name1', 'customer_name1'),
    ('name2', 'customer_name2'),
    ('name3', 'customer_name3'),
    ('name4', 'customer_name4'),
    ('spras', 'language_key'),
    ('stras', 'street_address'),
    ('ort01', 'city'),
    ('regio', 'state'),
    ('pstlz', 'postal_code'),
    ('loevm', 'deletion_flag'),
    ('brsch', 'industry_sector'),
    ('kukla', 'customer_class'),
    ('land1', 'country')

] -%}

with 

base as (

    select * from {{ ref('base_ecc_kna1') }}

),

final_cte as (

    select

        case
            when erdat = '00000000' then null
            else to_date(erdat, 'YYYYMMDD')
        end as account_created_on,

        {% for column_name in column_names %}
        case
            when trim({{ column_name[0] }}) = '' then null
            else upper(trim({{ column_name[0] }}))
        end as {{ column_name[1] }}
        {% if not loop.last -%} , {%- endif %}
	    {% endfor %},

        case
            when trim(telf1) = '' then null
            else replace(telf1, ' ', '') 
        end as phone_number,

        case
            when trim(telfx) = '' then null
            else replace(telfx, ' ', '')
        end as fax_number

    from base

)

select * from final_cte
{%- set column_names = [('anred','contact_title'),
                        ('namev','contact_first_name'),
                        ('loevm','del_flag_contact'),
                        ('adrnp','contact_address_line_1'),
                        ('ort01','contact_city'),
                        ('pafkt','contact_function')] -%}



with 

base as (

    select * from {{ ref('base_ecc_knvk') }}

),

final as (

    select
        kunnr as account_number,
        mandt as client_id,
        parnr as contact_bp_number,

       {% for column_name in column_names %}
        case
            when trim({{ column_name[0] }}) = '' then null
            else {{ column_name[0] }}
        end as {{ column_name[1] }},
	    {% endfor %}

        name1 as contact_last_name,
        erdat as contact_creation_date

    from base

)

select * from final
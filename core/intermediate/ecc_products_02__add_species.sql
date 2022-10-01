{{ config(materialized = 'ephemeral') }}

{%- set dog_strings = [
    'Canine',
    'CANINE',
    'Ca ',
    'CA ',
    'Can ',
    'Puppy',
    'Pup ',
    'Dog',
    'K9'
] -%}

{%- set cat_strings = [
    'Feline',
    'FELINE',
    'Felin ',
    'Felline',
    'Fel ',
    'fel '
    'Fel. '
    'Fe ',
    'FE ',
    'Kitten',
    'Ktn',
    'Cat',
    'FelRdCal',
    'PD Fe',
    'SD Fel',
    'SP Fe',
    'PD y/d Fel',
    'PD fel'
] -%}

with

clean_descriptions as (

    select * from {{ ref('ecc_products_01__clean_descriptions') }}

),

final_cte as (

    select
        sku,
        product_description,
        
        case 
            when contains(product_description, 'Canine/Feline') then 'DOG/CAT'

            {% for dog_string in dog_strings -%}
            when contains(product_description, '{{dog_string}}') then 'DOG'
            {% endfor -%}
            
            {% for cat_string in cat_strings -%}
            when contains(product_description, '{{cat_string}}') then 'CAT'
            {% endfor -%}

            else 'OTHER'
        end as species
    
    from clean_descriptions

)

select * from final_cte

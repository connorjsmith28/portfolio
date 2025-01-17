{{ config(materialized = 'ephemeral') }}

{%- set bad_strings = (
    'UNUSED',
    'Unused', 
    'unused', 
    'Not Used', 
    'Disc',
    'RE-USE',
    'UNUSED - RECYCLE',
    'SD DO NOT USE',
    'USED',
    'Do Not Use',
    'Disco - Do not Use',
    'UNUSED - Replaced by 1949J',
    'UNUSED - Replaced by 1950J',
    'DISCONTINUED',
    'disc',
    'UnUsed',
    'SP DO NOT USE',
    'Do not use',
    'Do Not USE',
    'test',
    'Test',
    'test PP',
    'Test SKU',
    'TEST _ EU REGULAR FLOW',
    'Dummy SKU - development team testing',
    'Hills EPH New SKU',
    'TEST HILLS CHI 12x450',
    'DUMMY SKU FOR EDI+PA'
 ) -%}

with

-- get finished products
finished_products as (

    select * from {{ ref('stg_ecc_finished_products') }}

),

-- get product descriptions
descriptions as (

    select * from {{ ref('stg_ecc_product_descriptions') }}

),

-- get descriptions for finished products
joined as (

    select
        finished_products.sku,
        descriptions.product_description 
    
    from finished_products
    inner join descriptions
        on finished_products.sku = descriptions.sku

),

-- filter out "bad" descriptions
final as (

    select * from joined
    where product_description not in {{bad_strings}}

)

select * from final
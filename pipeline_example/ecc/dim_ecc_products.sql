{{ config(materialized = 'table') }}

with

product_availability as (

    select * from {{ ref('stg_ecc_product_status') }}

),

finished_products as (

    select * from {{ ref('stg_ecc_finished_products') }}

),

-- Changed from using the ecc_products_02__add_species model 
product_descriptions as (

    select * from {{ ref('ecc_products_01__add_descriptions') }}

),
 
joined as (

    select
        product_availability.product_sales_id,
        product_availability.sku,
        product_availability.sales_org,
        product_availability.product_status,
        product_availability.status_valid_from,
        product_availability.product_form,
        finished_products.sku_created_on,
        finished_products.product_group,
        finished_products.net_weight,
        finished_products.weight_unit,
        finished_products.base_uom,
--        product_descriptions.species,    -- removing this for now until species determination is reworked.  
        product_descriptions.product_description
    
    from product_availability
    inner join finished_products on product_availability.sku = finished_products.sku
    left outer join product_descriptions on product_availability.sku = product_descriptions.sku

),

final_cte as (

    select
        product_sales_id,
        sku,
        sales_org,
        sku_created_on,
        product_status as status_code,

        case
            when product_status is null then 'ACTIVE'
            when product_status = 2 then 'DISCONTINUED'
            when product_status = 1 then 'INACTIVE'
            when product_status = 14 then 'NEW'
            when product_status in (3, 4) then 'OTHER'
            else null
        end as status_description,

        case 
            when product_status = 2 then status_valid_from
            else null
        end as discontinued_on,
        
        product_description,
        product_group as brand_code,

        case
            when product_group = 'SD' then 'SCIENCE DIET'
            when product_group = 'SP' then 'SCIENCE PLAN'
            when product_group = 'PD' then 'PRESCRIPTION DIET'
            when product_group = 'IB' then 'IDEAL BALANCE'    
            when product_group = 'VE' then 'VET ESSENTIALS'
            when product_group = 'NB' then 'NATURES BEST'
            when product_group = 'HA' then 'HEALTHY ADVANTAGE'
            else 'OTHER'   
        end as brand_name,

        null as species,   -- keeping column but populating with null until species determination is reworked
        net_weight,
        weight_unit,

        case
            when base_uom = 'BAG' then 'BAG'
            when base_uom = 'CAS' then 'CASE'
            when base_uom = 'BAL' then 'BALE'
            when base_uom = 'KI' then 'KIT' --???
            when base_uom = 'PAL' then 'PALLET'
            else 'OTHER'
        end as unit_of_measure,

        case
            when product_form in ('DRY', 'DL', 'DS', 'DT') then 'DRY'
            when product_form in ('WET', 'WC', 'WG', 'WM') then 'WET'
            when product_form in ('TRT', 'ST', 'SB') then 'TREAT'
            when product_form in ('SC', 'SG', 'SP', 'ZZ') then 'OTHER'
            else null
        end as product_form
  
    from joined
)

select * from final_cte
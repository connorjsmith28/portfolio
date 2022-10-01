--This code fetches the max date from fct_ecc_orders that is stored in a transient table. It takes that date as the last refresh date
--then compares any order_numbers from the base table with that date and pulls the most recent values. 
--The last piece of code compiles all the order_numbers from the various tables to create a filter for the
--base table views so they only bring in updated or new data. Eventually, those table values will be inserted/updated in fct_ecc_orders

--If you need to do a full reload and dump the fact to start over, do a 'dbt seed' run. It will reset the timer to 1900 and the filter will grab all values

with
--Get max ingestion_timestamp date
max_timestamp as (
    select
       '2021-11-11 00:00' as last_update
    --from {{ ref('seed_incremental_fct') }}
--This source may need to be updated in the yml file
),
--Get new data for vbak
vbak_new as (
    select distinct
        VBELN                    
    from {{ source('ecc_hup_sd', 'vbak') }}
    where INGESTION_TIMESTAMP > (select last_update from max_timestamp)
),
--Get new data for vbuk
vbuk_new as (
    select distinct
        VBELN
    from {{ source('ecc_hup_sd', 'vbuk') }}
    where INGESTION_TIMESTAMP > (select last_update from max_timestamp)
),
--Get new data for vbpa
vbpa_new as (
    select distinct
        VBELN
    from {{ source('ecc_hup_sd', 'vbpa') }}
    where INGESTION_TIMESTAMP > (select last_update from max_timestamp)
),

--Get new data for vbap
vbap_new as (
    select distinct
        VBELN
    from {{ source('ecc_hup_sd', 'vbap') }}
    where INGESTION_TIMESTAMP > (select last_update from max_timestamp)
),

--Join all order_numbers into single query
updated_order_numbers as (
    select VBELN from vbak_new
    union
    select VBELN from vbuk_new
    union
    select VBELN from vbap_new
    union
    select VBELN from vbpa_new

)

--create final list of order_numbers that have been updated
select VBELN as order_number
from updated_order_numbers
order by 1
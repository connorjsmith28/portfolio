select 
    mandt,
    matnr,
    spras,
    maktx,
    ingestion_timestamp 

from {{ source('ecc_hup_lo', 'makt') }}
select
    mandt,  --multiple values
    spras,
    abgru,
    bezei,
    ingestion_timestamp

from {{ source('ecc_hup_sd', 'tvagt') }}
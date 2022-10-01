select
    mandt,
    spras,
    route,
    bezei,
    ingestion_timestamp

from {{ source('ecc_hup_lo', 'tvrot') }}

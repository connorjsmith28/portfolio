select
    mandt, --multiple values
    spras,
    auart,
    bezei,
    ingestion_timestamp

from {{ source('ecc_hup_sd', 'tvakt') }}
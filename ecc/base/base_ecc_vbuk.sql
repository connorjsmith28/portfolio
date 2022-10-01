select
    mandt,
    vbeln,
    gbstk,
    ingestion_timestamp

from {{ source('ecc_hup_sd', 'vbuk') }}
where vbeln in (select * from {{ref('incremental_fct')}})
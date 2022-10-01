select
    mandt,
    vbeln,
    posnr,
    parvw,
    kunnr,
    parnr,
    land1,
    ingestion_timestamp

from {{ source('ecc_hup_sd', 'vbpa') }}
where vbeln in (select * from {{ref('incremental_fct')}})
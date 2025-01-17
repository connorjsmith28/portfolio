select
    mandt,
    vbeln,
    posnr,
    matnr,
    kwmeng,
    vrkme,
    netpr,
    ntgew,
    netwr,
    abgru,
    route,
    ingestion_timestamp

    
from {{ source('ecc_hup_sd', 'vbap') }}
where vbeln in (select * from {{ref('incremental_fct')}})
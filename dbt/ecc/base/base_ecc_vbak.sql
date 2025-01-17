select
    mandt,
    vbeln,
    auart,
    erdat,
    vbtyp,
    waerk,
    vkorg,
    vtweg,
    spart,
    vkgrp,
    vkbur,
    rplnr,
    netwr,
    ingestion_timestamp

from {{ source('ecc_hup_sd', 'vbak') }}
where vbeln in (select * from {{ref('incremental_fct')}})
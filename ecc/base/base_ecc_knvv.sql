select
    mandt,
    kunnr,
    vtweg,
    spart,
    kvgr2,
    vkorg,
    vkbur,
    vkgrp,
    bzirk,
    klabc,
    konda,
    pltyp,
    kvgr3,
    ingestion_timestamp
    
from {{ source('ecc_hup_lo', 'knvv') }}
select
    mandt,
    hityp,
    kunnr,
    vkorg,
    vtweg,
    spart,
    datab,
    datbi,
    hkunnr,
    hvkorg,
    hvtweg,
    hspart,
    grpno,
    bokre,
    prfre,
    hzuor,
    ingestion_timestamp
    
from {{ source('ecc_hup_lo', 'knvh') }}

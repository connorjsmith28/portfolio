select
    mandt,
    kunnr,
    parnr,
    anred,
    namev,
    name1,
    loevm,
    erdat,
    adrnp,
    ort01,
    pafkt,
    ingestion_timestamp
    
from {{ source('ecc_hup_lo', 'knvk') }}
select
    mandt,
    kunnr,
    erdat,
    name1,
    name2,
    name3,
    name4,
    spras,
    stras,
    ort01,
    pstlz,
    land1,
    loevm,
    telf1,
    telfx,
    brsch,
    regio,
    mcod3,
    lzone,
    kukla,
    ingestion_timestamp
    
from {{ source('ecc_hup_mm', 'kna1') }}
where upper(name1) not like '%DUMMY%'

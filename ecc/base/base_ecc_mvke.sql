select
    mandt,
    matnr,
    vkorg,
    vtweg,
    vmsta,
    vmstd,
    mvgr2,
    ingestion_timestamp

from {{ source('ecc_hup_lo', 'mvke') }}
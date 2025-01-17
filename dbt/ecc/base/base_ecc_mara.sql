select
    mandt,
    matnr,
    ersda,
    mtart,
    ntgew,
    gewei,
    matkl,
    meins,
    zz_prod_cat,
    ingestion_timestamp

from {{ source('ecc_hup_mm', 'mara') }}
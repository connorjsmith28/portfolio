select
    mandt,
    spras,
    kvgr3,
    bezei

from {{ source('ecc_hup_sd', 'tvv3t') }}
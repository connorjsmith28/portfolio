select
    client,
    addrnumber,
    persnumber,
    date_from,
    consnumber,
    tel_number
from {{ source('ecc_huc', 'adr2') }}

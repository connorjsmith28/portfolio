select
    client,
    addrnumber,
    persnumber,
    date_from,
    consnumber,
    smtp_addr
from {{ source('ecc_huc', 'adr6') }}
select
    client,
    persnumber, 
    date_from,
    nation, 
    title_aca1
from {{ source('ecc_huc', 'adrp') }}
select
    client, --two values: 0 and 321
    title_key,
    title_text,
    ingestion_timestamp

from {{ (source('ecc_hup_mm', 'tsad2')) }}

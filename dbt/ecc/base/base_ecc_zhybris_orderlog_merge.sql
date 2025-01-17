select
    mandt,
    logno,
    sales_order,
    sales_item,
    sku,
    ship_to,
    rfc_name,
    changed_date,
    changed_time

from {{ source('ecc_hup_sd', 'zhybris_orderlog') }}
where rfc_name = 'MERGE_SALESORDER'
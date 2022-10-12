/*
Problem:
    Tableau uses parameters to determine how much data to pull in at once. Tableaus paramter is unique to it, and does not function with dbt. Tableau's parameter limits the 3 years of data in the sql statement down to just one month. On the front end, you can togge to choose
    which month that is. DBT cannot enteract with Tableau global parameters so this functionality is lost. Without the use of parameters, dbt is forced to bring in 3 years of data which is too large and crashes the application. 

Solution: 
    Create a single sql script that generates 36 tables, one for each month year combination. Have Tableau use the parameter to point to a particular script instead of filtering a single script. 
*/

--#AvgExchangeRates----------------


--Generate list of dates from three years ago to today in the format of 'Month YYYY'
--this will be used in the for loop to create a table for each month year combo. That way we can keep the parameter that Tableau is using currently
{% call statement('get_month_year', fetch_result= true)%}
WITH recursive CTE(startDt,endDt) AS (
   SELECT  DATEADD(year,-3,current_date) startDt, current_date endDt
   UNION ALL
   SELECT CAST(DATEADD(month,1,startDt) as DATE) ,endDt
   FROM CTE
   WHERE DATEADD(month,1,startDt) < endDt
)
SELECT trim(substring(to_char(startDt, 'YYYY Month'),6)) || ' ' || left(to_char(startDt, 'YYYY Month'),4)
FROM CTE
{% endcall %}

--Create data location variables
{% set date = load_result('get_month_year') %}
{% set current_database = target.database %}
{% set current_schema = target.schema %}

--for loop goes through whole model 36 times and on each iteration adds a month year between now and three years ago.
{% for i in range(36) %}
    {% set month_year = date['data'][i][0] %}
    {% set table_short = '\'dummy_field{}\''.format(month_year)%}
    {% set table_name = '{}.{}.{}'.format(current_database,current_schema,table_short) %}
    {% set drop_query = 'drop table {}'.format(table_name) %}
    {% set add_query = 'create table {}'.format(table_name) %}
    {% set table_check = 'select case when "table" = {} then 1 else 0 end as exist from svv_table_info where schema = \'{}\' and "table" = {}'.format(table_short,current_schema,table_short) %}

--check to see if tables already exists
{% call statement('table_check', fetch_result = true) %}
    select
        case when "table" = {{table_short}} then 1 else 0 end as exist
    from svv_table_info
    where schema = '{{current_schema}}'
    and "table" = {{table_short}}
{% endcall %}

{% set table_exists = load_result('table_check') %}
{% set test = table_exists['data']%}


WITH avgexchangerates as (
    select 
        dummy_field,
        dummy_field,
        dummy_field   as dummy_field,
        avg(dummy_field) as dummy_field
    from dummy_field
    where date_trunc('month',dummy_field::timestamp) = to_date('{{month_year}}', 'Month YYYY')
    group by dummy_field,
          dummy_field
)
--#MonthEndExchangeRates----------
, monthendexchangerates as (
    select 
        dummy_field as dummy_field,
        dummy_field as dummy_field,
        dummy_field as dummy_field
    from dummy_field
    where dummy_field = LAST_DAY(to_date('{{month_year}}', 'Month YYYY'))
)
--#LastAccountingPeriod-----------
, lastaccountingperiod as (
    select 
        dummy_field as dummy_field,
        dummy_field as dummy_field,
        dummy_field as dummy_field
    from dummy_field
    where to_date('{{month_year}}', 'Month YYYY') between dummy_field and dummy_field
    and dummy_field = 1
)

--#RevenueSchedule-----------------
, revenueschedule as (
    select 
        a.dummy_field as dummy_field,
        a.dummy_field as dummy_field,
        b.dummy_field as dummy_field ,
        b.dummy_field as dummy_field,
        case when ap.dummy_field = l.dummy_field then a.dummy_field else 0 end as dummy_field,
        case when ap.dummy_field > l.dummy_field then a.dummy_field else 0 end as dummy_field,
        ap.dummy_field as dummy_field
    from dummy_field l,
        dummy_field a
          inner join dummy_field b
                     on a.dummy_field = b.dummy_field
                     and b.dummy_field = 1
          inner join dummy_field ap
                     on a.dummy_field = ap.dummy_field
                     and ap.dummy_field = 1
    where ap.dummy_field >= l.dummy_field
    and a.dummy_field = 1
)

--#RevenueScheduleAdjustment-----------------
, revenuescheduleadjustment as (
    select a.dummy_field as dummy_field ,
        iia.dummy_field                                                    as dummy_field,
        b.dummy_field as dummy_field,
        b.dummy_field as dummy_field,
        case when ap.dummy_field = l.dummy_field then a.dummy_field else 0 end as dummy_field,
        case when ap.dummy_field > l.dummy_field then a.dummy_field else 0 end as dummy_field,
        ap.dummy_field as dummy_field
    from dummy_field l,
    dummy_fields a
          inner join dummy_field b
                     on a.dummy_field = b.dummy_field
                     and b.dummy_field = 1
          inner join dummy_field ap
                     on a.dummy_field = ap.dummy_field
                     and ap.dummy_field = 1
          inner join dummy_field iia
                     on a.dummy_field = iia.dummy_field
                     and iia.dummy_field = 1
    where ap.dummy_field >= l.dummy_field
    and a.dummy_field = 1
)

--#Charges------------------------
, charges as (
    select 
        i.dummy_field                                                                       as dummy_field,
        ii.dummy_field                                                                      as dummy_field,
        coalesce(di.dummy_field, ii.dummy_field)                                            as dummy_field,
        coalesce(di.dummy_field, ii.dummy_field)                                            as dummy_field,
        'dummy_field'                                                                       as dummy_field,
        ri.dummy_field,
        ri.dummy_field                                                                      as dummy_field,
        case when di.dummy_field is null then ii.dummy_field else 0 end                     as dummy_field,
        case when di.dummy_field is not null then ii.dummy_field else 0 end                 as dummy_field,
        case when di.dummy_field is null then ri.dummy_field else 0 end                     as dummy_field,
        case when di.dummy_field is not null then ri.dummy_field else 0 end                 as dummy_field,
        case when di.dummy_field is null then ri.dummy_field else 0 end                     as dummy_field,
        case when di.dummy_field is not null then ri.dummy_field else 0 end                 as dummy_field
    from dummy_field ii
    inner join dummy_field ri
        on ii.dummy_field = ri.dummy_field
    inner join dummy_field i
        on ii.dummy_field = i.dummy_field
        and i.dummy_field = 1
    left outer join dummy_field di
        on ii.dummy_field = di.dummy_field
        and di.dummy_field = 1
    where ii.dummy_field = 1
)
--#Adjustments------------------------------
, adjustments as (
    select 
        dummy_field                                                             as dummy_field,
        dummy_field                                                             as dummy_field,
        iia.dummy_field                                                         as dummy_field,
        coalesce(di.dummy_field, ii.dummy_field)                                as dummy_field,
        coalesce(di.dummy_field, ii.dummy_field)                                as dummy_field,
        coalesce(di.dummy_field, ii.dummy_field)                                as dummy_field,
        'dummy_field'                                                           as dummy_field,
        case
            when di.dummy_field is null then
                case
                    when dummy_field = 'dummy_field' then iia.dummy_field * -1
                    else iia.dummy_field
                    end
            else 0
            end                                            as dummy_field,
        case
            when di.dummy_field is not null then
                case
                    when dummy_field = 'dummy_field' then iia.dummy_field * -1
                    else iia.dummy_field
                    end
            else 0
            end                                            as dummy_field,
        r.dummy_field,
        r.dummy_field                                      as dummy_field,
        case
            when di.dummy_field is null then r.dummy_field
            else 0
            end                                            as dummy_field,
        case
            when di.dummy_field is null then r.dummy_field
            else 0
            end                                            as dummy_field,
        case
            when di.dummy_field is not null then r.dummy_field
            else 0
            end                                            as dummy_field,
        case
            when di.dummy_field is not null then r.dummy_field
            else 0
            end                                            as dummy_field
    from dummy_field iia
          inner join dummy_field ii
                     on iia.dummy_field = ii.dummy_field
                     and ii.dummy_field = 1
          inner join dummy_field r
                     on iia.dummy_field = r.dummy_field
          left outer join dummy_field di
                          on ii.dummy_field = di.dummy_field
                          and di.dummy_field = 1
    where sourcetype != 'dummy_field'
    and status = 'dummy_field'
    and iia.dummy_field = 1
)

--#RevenueBreakdown---------------------------
, revenuebreakdown as (
 select dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field,
        dummy_field
 from (
          select dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field
          from dummy_field
               ------------------------------------------------------------------------------
          UNION ALL
          ------------------------------------------------------------------------------
          select dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field,
                 dummy_field
          from dummy_field
      ) r
)

--#OpportunityOwner---------------------------------------
, dummy_field as (
 select sc.dummy_field                          as dummy_field,
        u.dummy_field                           as dummy_field,
        u.dummy_field + ' ' + u.dummy_field     as dummy_field
 from dummy_field sc
          inner join dummy_field o
                     on o.dummy_field = sc.dummy_field
                     and o.dummy_field = 1
          left join dummy_field u
                    on o.dummy_field = u.dummy_field
                    and u.dummy_field = 1
          left join dummy_field ur
                    on u.dummy_field = ur.dummy_field
                    and ur.dummy_field = 1
where sc.dummy_field = 1
)

--#RecognitionRule-------------------------------
, recognitionrule as (
select distinct
    a.dummy_field as dummy_field,
    rpc.dummy_field as dummy_field
from dummy_field a
    inner join dummy_field rpc
    on a.dummy_field = rpc.dummy_field
    and rpc.dummy_field = 1
where a.dummy_field = 1
)
--==================================================================================================================
--Step 3: Final Select Statement
--==================================================================================================================
SELECT 
    r.dummy_field
  , r.dummy_field
  , r.dummy_field
  , za.dummy_field                                                                  AS dummy_field
  , ROUND(r.dummy_field, 2)                                                         AS dummy_field
  , ROUND(r.dummy_field, 2)                                                         AS dummy_field
  , ROUND(r.dummy_field + r.dummy_field, 2)                                         AS dummy_field
  , ROUND(r.dummy_field, 2)                                                         AS dummy_field
  , ROUND(r.dummy_field, 2)                                                         AS dummy_field
  , ROUND(r.dummy_field + r.dummy_field, 2)                                         AS dummy_field
  , cc.dummy_field                                                                  AS dummy_field


  , ROUND((r.dummy_field * x.dummy_field), 2)                                       AS dummy_field
  , ROUND((r.dummy_field * x.dummy_field), 2)                                       AS dummy_field
  , ROUND(((r.dummy_field + r.dummy_field) * x.dummy_field),
          2)                                                                        AS dummy_field
  , ROUND((r.dummy_field * mx.dummy_field), 2)                                      AS dummy_field
  , ROUND((r.dummy_field * mx.dummy_field), 2)                                      AS dummy_field
  , ROUND(((r.dummy_field + r.dummy_field) * mx.dummy_field),
          2)                                                                        AS dummy_field


  , sa.dummy_field                                                                  AS dummy_field
  , sa.dummy_field                                                                  AS dummy_field
  , (SELECT dummy_field FROM dummy_field)                                           AS dummy_field
  , (SELECT dummy_field FROM dummy_field)                                           AS dummy_field
  , ap.dummy_field                                                                  AS dummy_field
  , DATE_PART('MONTH', ap.dummy_field)                                              AS dummy_field
  , i.dummy_field                                                                   AS dummy_field
  , i.dummy_field                                                                   AS dummy_field
  , i.dummy_field                                                                   AS dummy_field
  , ii.dummy_field                                                                  AS dummy_field
  , ii.dummy_field                                                                  AS dummy_field
  , ii.dummy_field                                                                  AS dummy_field
  , ii.dummy_field                                                                  AS dummy_field
  , ii.dummy_field                                                                  AS dummy_field
  , p.dummy_field                                                                   AS dummy_field
  , p.dummy_field                                                                   AS dummy_field
  , prp.dummy_field                                                                 AS dummy_field
  , prp.dummy_field                                                                 AS dummy_field
  , prp.dummy_field                                                                 AS dummy_field
  , rii.dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , prpc.dummy_field                                                                AS dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , s.dummy_field                                                                   AS dummy_field
  , s.dummy_field                                                                   AS dummy_field
  , s.dummy_field                                                                   AS dummy_field
  , s.dummy_field                                                                   AS dummy_field
  , s.dummy_field                                                                   AS dummy_field
  , s.dummy_field                                                                   AS dummy_field
  , CASE
        WHEN s.dummy_field = 'dummy_field' THEN '1'
        WHEN s.dummy_field = 1 THEN '1'
        WHEN s.dummy_field BETWEEN 2 AND 3 THEN '3'
        WHEN s.dummy_field BETWEEN 4 AND 10 THEN '6'
        WHEN s.dummy_field >= 11 THEN '12'
 END                                                                                AS dummy_field
  , prp.dummy_field                                                                 AS dummy_field
  , o.dummy_field                                                                   AS dummy_field
  , o.dummy_field                                                                   AS dummy_field
  , rpc.dummy_field                                                                 AS dummy_field
  , c.dummy_field                                                                   AS dummy_field
FROM dummy_field i
      INNER JOIN dummy_field ii
                 ON i.dummy_field = ii.dummy_field
                 and ii.dummy_field = 1
      INNER JOIN dummy_field rpc
                 ON ii.dummy_field = rpc.dummy_field
                 and rpc.dummy_field = 1
      INNER JOIN dummy_field c
                 ON rpc.dummy_field = c.dummy_field
                 and c.dummy_field = 1
      INNER JOIN dummy_field prpc
                 ON prpc.dummy_field = rpc.dummy_field
                 and prpc.dummy_field = 1
      INNER JOIN dummy_field s
                 ON rpc.dummy_field = s.dummy_field
                 and s.dummy_field = 1
      INNER JOIN dummy_field za
                 ON i.dummy_field = za.dummy_field
                 and za.dummy_field = 1
      INNER JOIN dummy_field sa
                 ON sa.dummy_field = za.dummy_field
       LEFT JOIN dummy_field sae
      INNER JOIN dummy_field p
                 ON rpc.dummy_field = p.dummy_field
                 and p.dummy_field = 1
      INNER JOIN dummy_field prp
                 ON rpc.dummy_field = prp.dummy_field
                 and prp.dummy_field = 1
      INNER JOIN dummy_field cc
                 ON cc.dummy_field = prp.dummy_field
                 and cc.dummy_field = 1
      INNER JOIN dummy_field r
                 ON ii.dummy_field = r.dummy_field
      LEFT JOIN dummy_field rii
                ON rii.dummy_field = ii.dummy_field
      INNER JOIN dummy_field ap
                 ON r.dummy_field = ap.dummy_field
      LEFT OUTER JOIN dummy_field o
                      ON o.dummy_field = s.dummy_field
      LEFT OUTER JOIN dummy_field x
                      ON za.dummy_field = x.dummy_field
                          AND cc.dummy_field = x.dummy_field
      LEFT OUTER JOIN dummy_field mx
                      ON za.dummy_field = mx.dummy_field
                          AND cc.dummy_field = mx.dummy_field
WHERE r.dummy_field + r.dummy_field + r.dummy_field +
   r.dummy_field != 0
AND dummy_field <= LAST_DAY(to_date('{{month_year}}', 'Month YYYY'))
AND sae.dummy_field is null
{% endfor %}

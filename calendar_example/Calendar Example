{{ config(
    materialized='view',
    sort='calendar_day_date'
    ) }}

select
    calendar_day_date
    , CASE
        WHEN calendar_day_date BETWEEN date_add('day',-30, current_date) AND current_date THEN 1
        ELSE 0
    END AS current_30_days
    , CASE
        WHEN calendar_day_date BETWEEN date_add('day',-30,date_add('year',-1,current_date)) AND date_add('year',-1,current_date) THEN 1
        ELSE 0
    END as previous_year_30_days
    , CASE
        WHEN calendar_day_date BETWEEN date_add('day',-30,date_add('year',-2,current_date)) AND date_add('year',-2,current_date) THEN 1
        ELSE 0
    END as previous_2_years_30_days
    , CASE
        WHEN calendar_day_date BETWEEN date_add('week',-8,current_date) and
            current_date THEN 1
        ELSE 0
    END AS current_8_weeks
    , CASE
        WHEN calendar_day_date BETWEEN date_add('week',-8, date_add('year',-1,current_date)) AND date_add('year',-1,current_date) THEN 1
        ELSE 0
    END as previous_year_8_weeks
    , CASE
        WHEN calendar_day_date BETWEEN date_add('week',-8, date_add('year',-2,current_date)) AND date_add('year',-2,current_date) THEN 1
        ELSE 0
    END as previous_2_years_8_weeks
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('month',date_add('month',-1,current_date)) and date_add('day',-1,date_trunc('month',current_date)) then 1
        ELSE 0
    END as current_full_month
        , CASE
        WHEN calendar_day_date BETWEEN date_trunc('month',date_add('month',-1,current_date)) and current_date then 1
        ELSE 0
    END as current_full_month_include_current_period
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('month',date_add('year',-1,date_add('month',-1,current_date))) and date_add('year',-1,date_add('day',-1,date_trunc('month',current_date))) then 1
        ELSE 0
    END as previous_year_full_month
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('month',date_add('year',-1,date_add('month',-1,current_date))) and date_add('year',-1,current_date) then 1
        ELSE 0
    END as previous_year_full_month_include_current_period
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('month',date_add('year',-2,date_add('month',-1,current_date))) and date_add('year',-2,date_add('day',-1,date_trunc('month',current_date))) then 1
        ELSE 0
    END as previous_2_years_full_month
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('month',date_add('year',-2,date_add('month',-1,current_date))) and date_add('year',-2,current_date) then 1
        ELSE 0
    END as previous_2_years_full_month_include_current_period
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('quarter',date_add('quarter',-1,current_date)) and date_add('day',-1,date_trunc('quarter',current_date)) then 1
        ELSE 0
    END as current_full_quarter
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('quarter',date_add('quarter',-1,current_date)) and current_date then 1
        ELSE 0
    END as current_full_quarter_include_current_period
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('quarter',date_add('year',-1,date_add('quarter',-1,current_date))) and date_add('year',-1,date_add('day',-1,date_trunc('quarter',current_date))) then 1
        ELSE 0
    END as previous_year_full_quarter
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('quarter',date_add('year',-1,date_add('quarter',-1,current_date))) and date_add('year',-1,current_date) then 1
        ELSE 0
    END as previous_year_full_quarter_include_current_period
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('quarter',date_add('year',-2,date_add('quarter',-1,current_date))) and date_add('year',-2,date_add('day',-1,date_trunc('quarter',current_date))) then 1
        ELSE 0
    END as previous_2_years_full_quarter
    , CASE
        WHEN calendar_day_date BETWEEN date_trunc('quarter',date_add('year',-2,date_add('quarter',-1,current_date))) and date_add('year',-2,current_date) then 1
        ELSE 0
    END as previous_2_years_full_quarter_include_current_period
    , 1 as none
from {{ ref('calendar_table') }}

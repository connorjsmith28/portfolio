--two dictionaries containing year and the calculations to produce them, and another for period that has an index with the month values
{% set year = {'Current': '0', '1 year previous': '-1', '2 years previous': '-2'} %}
{% set period =
    {'day': [-30],
    'week': [-8],
    'month': [0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11],
    'quarter': [-1]
    } %}

--for each year, return the difference between that year and the current year. Ex.) 2 years previous would return -2, the difference between the previous year and this year
{% for i, years_ago in year.items() %}
    --for each period in each year, return the period values. Ex.) for current year, you'll iterate over day, week, month, and quarter.
    {% for j, period_value in period.items() %}
        --Since there is an index for the value in the dictionary, we want to loop through each value of the index too. So the end result is creating a year||period||period_value string
        {% for z in period_value %}

--variables printed out here to see what they do on each iteration
    /*
        {{i}} as year
        {{years_ago}} as year_value
        {{j}} as period
        {{period_value}} as period_value
        {{z}} as index value
     */

SELECT
        id_field || '{{i}}' || '{{j}}' || '{{z}}' as id_field
        , field_1
        , field_2
        , field_3
        , field_4
        , field_5
        , field_6
        , field_7
        , field_8
        , field_9
        , field_10
        , field_11
        , field_12
        , field_13
        , field_14
        , field_15
        , field_16
        , field_17
        , field_18
        , field_19
        , field_20
        , field_21
        --------date fields---------
        , case
            when field_22 between date_trunc('{{j}}', current_date) and current_date
            then 1 else 0
            end                                             AS include_current_period
        , field_23
        , field_24
        --------metrics---------
        , field_25
        , field_26
        --------tracking---------
        , grain
        , '{{i}}' || '-' || '{{j}}' || '-' || '{{z}}'        AS year_period_value

FROM {{ref('table')}}
WHERE
    --Loop through each year and period value combination from the most recent full period to today. The include_current_period filter can make it only include the full period
    job_start_date_time between
        dateadd('year', {{years_ago}}, (dateadd('{{j}}',{{z}},date_trunc('{{j}}',current_date)))) and
        dateadd('year', {{years_ago}}, (dateadd('{{j}}',
            --need to make sure the interval is only over a single month and not Jan - whatever month. But also don't want this to effect other code.
            {% if j == 'month' %}
                ({{z}} + 1),
            {% else %}
                0,
            {% endif %}
            current_date)))
    and grain = '{{j}}'

        --check if this is the last iteration of the loop, if not union all, otherwise do nothing as we can't end our code with an empty union statement
        {% if not loop.last %}
            UNION ALL
        {% endif -%}
        {% endfor %}
    --check if this is the last iteration of the loop, if not union all, otherwise do nothing as we can't end our code with an empty union statement
    {% if not loop.last %}
        UNION ALL
    {% endif -%}
    {% endfor %}
--check loop again, you'll need union all after each year as well as each period
{% if not loop.last %}
    UNION ALL
{% endif -%}
{% endfor %}

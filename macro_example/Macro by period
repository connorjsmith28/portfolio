{% macro  date_by_period(sql_statement, date_field, unique_key, include_current_period = False) -%}

/*
	Takes sql statement and partitions it into different date periods based on a given date_field. The table genereated by the sql_statement should be at the day grain level. 

	Args:
		sql_statement: A sql string that generates a table at the day grain level
		date_field: A date field in the form YYYY-MM-DD
		unique_key: A unique identifier for the table. Should be unique and not null for every record
		include_current_period: Optional, field that extends the most recent full period to also include the current period as well. For example, if today is 02-10-2022 the flag would create a 1 for each day from 01-01-2022 for the month grain. 

	Returns:
		A sql block that takes the original table, and partitions it out into various date periods. 

	Notes:
		
*/

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


(with base as (
    {{sql_statement}}
)

SELECT
    --To prevent duplicates across multiple periods this line concatenates the year_period_value to the unique_key
    {{unique_key}} || '{{i}}' || '{{j}}' || '{{z}}' as {{unique_key}},
    --select everything from the sql statement, except for the unique_key since we are rebuilding it
    *,
    {% if include_current_period == True %}
    case
            when {{date_field}} between date_trunc('{{j}}', current_date) and current_date
            then 1 else 0
    end                                                  AS include_current_period,
    {% endif %}
    '{{i}}' || '-' || '{{j}}' || '-' || '{{z}}'        AS year_period_value
FROM base
WHERE
    --Loop through each year and period value combination from the most recent full period to today. The include_current_period filter can make it only include the full period
    {{date_field}} between
        dateadd('year', {{years_ago}}, (dateadd('{{j}}',{{z}},date_trunc('{{j}}',current_date)))) and
        dateadd('year', {{years_ago}}, (dateadd('{{j}}',
            --need to make sure the interval is only over a single month and not Jan - whatever month. But also don't want this to effect other code.
            {% if j == 'month' %}
                ({{z}}  1),
            {% else %}
                0,
            {% endif %}
            current_date)))
        and {% if j == 'quarter'%} --there is no quarter grain, so it's just an aggregation of month
            grain = 'month'
        {% else %}
            grain = '{{j}}'
        {% endif %}
)
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

{%- endmacro %}

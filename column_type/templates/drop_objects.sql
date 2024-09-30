--
-- Finally drop temporary objects

\set lock_timeout = '{{timeout}}ms'
\set ON_ERROR_STOP
\set ON_ERROR_ROLLBACK true

{% for table in tables -%}

DROP INDEX CONCURRENTLY {{ table.name }}_{{ table.columns[0].column }}_migr01_idx;

{% for column in table['columns'] -%}
ALTER TABLE {{ table.name }} DROP COLUMN {{ column.column }}_old;
{% endfor %}

{% endfor %}

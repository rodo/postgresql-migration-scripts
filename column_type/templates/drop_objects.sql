--
-- Finally drop objects
{% for table in tables -%}

DROP INDEX CONCURRENTLY {{ table.name }}_{{ table.column }}_migr01_idx;

ALTER TABLE {{ table.name }} DROP COLUMN {{ table.column }}_old;

{% endfor %}

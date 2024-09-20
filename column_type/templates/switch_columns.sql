--
-- We do not want to lock all tables at the same time
{% for table in tables -%}

BEGIN;

DROP TRIGGER {{ table.name }}_{{ table.column }}_migr01_trg ON {{ table.name }} RESTRICT;
DROP FUNCTION {{ table.name }}_{{ table.column }}_migr01_trg();

ALTER TABLE {{ table.name }} RENAME COLUMN {{ table.column }} TO {{ table.column }}_old;
ALTER TABLE {{ table.name }} RENAME COLUMN {{ table.column }}_new TO {{ table.column }};
COMMIT;

{% endfor %}

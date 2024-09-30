--

\set lock_timeout = '{{timeout}}ms'
\set ON_ERROR_STOP
\set ON_ERROR_ROLLBACK true

-- We do not want to lock all tables at the same time
-- so we create a transaction per table
{% for table in tables -%}

BEGIN;

DROP TRIGGER {{ table.name }}_migr01_trg ON {{ table.name }} RESTRICT;
DROP FUNCTION {{ table.name }}_migr01_trg();

{% for column in table['columns'] -%}
ALTER TABLE {{ table.name }} RENAME COLUMN {{ column.column }} TO {{ column.column }}_old;
ALTER TABLE {{ table.name }} RENAME COLUMN {{ column.column }}_new TO {{ column.column }};
{% endfor %}
COMMIT;

{% endfor %}

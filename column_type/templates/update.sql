--
-- Update the data
--
\timing on

\set statement_timeout = '{{timeout}}ms'
\set ON_ERROR_STOP
\set ON_ERROR_ROLLBACK true

{% for table in tables -%}
--
-- table {{table.name}}
--
UPDATE {{table.name}} SET
{% for column in table['columns'] -%}{{ column.column }}_new = {{ column.column }}{% if not loop.last %},{% endif %}
{% endfor %}
WHERE id in (
      SELECT id FROM {{table.name}}
      WHERE {{ table.columns[0].column }}_new IS NULL
      LIMIT {{ nbstep }}
      FOR UPDATE SKIP LOCKED );

VACUUM {{table.name}};
{% endfor %}

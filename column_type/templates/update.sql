-- table {{ table }}
-- column {{ column }}
--
--
-- add the new column
{% for table in tables -%}

UPDATE {{table.name}} SET {{ table.column }}_new = {{ table.column }}
WHERE id in (
      SELECT id FROM {{table.name}}
      WHERE {{ table.column }}_new IS NULL
      LIMIT {{ nbstep }}
      FOR UPDATE SKIP LOCKED );

{% endfor %}

--
-- Tests run after adding the new columns
--
BEGIN;

SELECT 'index',0

{% for table in tables -%}
UNION
SELECT '{{ table.name }}', tuple_count FROM pgstattuple('{{ table.name}}_{{ table.column}}_migr01_idx')
{% endfor %}

ROLLBACK;

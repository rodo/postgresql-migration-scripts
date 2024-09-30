--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{ nbstep }});

{% for table in tables -%}

SELECT results_eq(

   'SELECT tuple_count FROM pgstattuple(''{{ table.name}}_{{ table.columns[0].column}}_migr01_idx'')',
   'SELECT 0::bigint',
   'no tuples remains in index {{ table.name}}_{{ table.columns[0].column}}_migr01_idx');
{% endfor %}

SELECT * FROM finish();

ROLLBACK;

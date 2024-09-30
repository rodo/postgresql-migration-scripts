--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{nbstep}} ) ;

{% for table in tables -%}

SELECT has_table( '{{ table.name }}'::name );

{% for column in table['columns'] -%}
SELECT has_column( '{{ table.name}}'::name, '{{ column.column }}'::name );

SELECT has_column( '{{ table.name}}'::name, '{{ column.column }}_new'::name );

SELECT col_type_is( '{{ table.name}}'::name, '{{ column.column }}_new'::name, '{{ column.dest_type }}' );
{% endfor %}

SELECT has_function( '{{ table.name}}_migr01_trg' );

SELECT has_trigger( '{{ table.name}}', '{{ table.name}}_migr01_trg' );

SELECT has_index( '{{ table.name}}'::name,
                  '{{ table.name}}_{{ table.columns[0].column}}_migr01_idx'::name,
                  'id'::name );

{% endfor %}

SELECT * FROM finish();

ROLLBACK;

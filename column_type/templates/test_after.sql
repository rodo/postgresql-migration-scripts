--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{nbstep}} ) ;

{% for table in tables -%}

SELECT has_table( '{{ table.name }}'::name );

SELECT has_column( '{{ table.name}}'::name, '{{ table.column }}'::name );

SELECT has_column( '{{ table.name}}'::name, '{{ table.column }}_new'::name );

SELECT col_type_is( '{{ table.name}}'::name, '{{ table.column }}_new'::name, '{{ table.dest_type }}' );

SELECT has_function( '{{ table.name}}_{{ table.column}}_migr01_trg' );

SELECT has_trigger( '{{ table.name}}', '{{ table.name}}_{{ table.column}}_migr01_trg' );

SELECT has_index( '{{ table.name}}'::name,
                  '{{ table.name}}_{{ table.column}}_migr01_idx'::name,
                  'id'::name );

{% endfor %}

SELECT * FROM finish();

ROLLBACK;

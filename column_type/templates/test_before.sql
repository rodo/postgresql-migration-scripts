--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{nbstep}} ) ;

{% for table in tables -%}

SELECT has_table( '{{ table.name }}'::name );

SELECT has_column( '{{ table.name}}'::name , '{{ table.column }}'::name );

SELECT col_type_is( '{{ table.name}}'::name, '{{ table.column }}'::name, '{{ table.source_type }}' );

{% endfor %}

SELECT * FROM finish();

ROLLBACK;

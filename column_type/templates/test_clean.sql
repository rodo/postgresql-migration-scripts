--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{nbstep}} ) ;

{% for table in tables -%}

SELECT has_table( '{{ table.name }}' );

SELECT has_column( '{{ table.name}}' , '{{ table.column }}' );

SELECT hasnt_column( '{{ table.name}}' , '{{ table.column }}_old' );

SELECT hasnt_function( '{{ table.name}}_{{ table.column}}_migr01_trg' );

SELECT hasnt_trigger( '{{ table.name}}', '{{ table.name}}_{{ table.column}}_migr01_trg' );

SELECT hasnt_index( '{{ table.name}}'::name,
                  '{{ table.name}}_{{ table.column}}_migr01_idx'::name,
                  'id'::name );

{% endfor %}

SELECT * FROM finish();

ROLLBACK;

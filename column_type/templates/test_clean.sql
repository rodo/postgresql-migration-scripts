--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{nbstep}} ) ;

{% for table in tables -%}

SELECT has_table( '{{ table.name }}' );

{% for column in table['columns'] -%}
SELECT has_column( '{{ table.name}}'::name , '{{ column.column }}'::name );
SELECT hasnt_column( '{{ table.name}}_new'::name , '{{ column.column }}'::name );
SELECT hasnt_column( '{{ table.name}}_old'::name , '{{ column.column }}'::name );
SELECT col_type_is( '{{ table.name}}'::name, '{{ column.column }}'::name, '{{ column.dest_type }}' );
{% endfor %}



SELECT hasnt_function( '{{ table.name}}_migr01_trg' );

SELECT hasnt_trigger( '{{ table.name}}', '{{ table.name}}_migr01_trg' );

SELECT hasnt_index( '{{ table.name}}'::name,
                  '{{ table.name}}_{{ table.column}}_migr01_idx'::name,
                  'id'::name );

{% endfor %}

SELECT * FROM finish();

ROLLBACK;

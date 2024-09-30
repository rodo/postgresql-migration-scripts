--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{nbstep}} ) ;

{% for table in tables -%}

SELECT has_table( '{{ table.name }}'::name );

-- columns

{% for column in table['columns'] -%}
SELECT has_column( '{{ table.name}}'::name , '{{ column.column }}'::name );
SELECT hasnt_column( '{{ table.name}}_new'::name , '{{ column.column }}'::name );
SELECT hasnt_column( '{{ table.name}}_old'::name , '{{ column.column }}'::name );

SELECT col_type_is( '{{ table.name}}'::name, '{{ column.column }}'::name, '{{ column.source_type }}' );

{% endfor %}
--
-- Update is based in the first column, we must ensure it's not null
SELECT col_not_null( '{{ table.name}}'::name, '{{ table.columns[0].column }}'::name );
--
-- Check there is no index with the same name
--
SELECT hasnt_index( '{{ table.name}}'::name,
                    '{{ table.name}}_{{ table.column}}_migr01_idx'::name,
                    'id'::name );

--
-- Check there is no trigger nor function with the same name
--

SELECT hasnt_trigger( '{{ table.name}}', '{{ table.name}}_{{ table.column}}_migr01_trg' );

SELECT hasnt_function( '{{ table.name}}_migr01_trg' );

{% endfor %}

SELECT * FROM finish();

ROLLBACK;

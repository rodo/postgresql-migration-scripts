--
-- Tests run after adding the new columns
--
BEGIN;

SELECT plan ( {{nbstep}} ) ;

{% for table in tables -%}

SELECT has_table( '{{ table.name }}' );

SELECT has_column( '{{ table.name}}' , '{{ table.column }}' );

{% endfor %}

SELECT * FROM finish();

ROLLBACK;

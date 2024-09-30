--
-- Add the new column on the new type
-- Add an index to speed up the migration
--

\unset ECHO
\set QUIET 1

\set statement_timeout = '{{timeout}}ms'
\set ON_ERROR_STOP
\set ON_ERROR_ROLLBACK true


{% for table in tables -%}
BEGIN;

-- add the new columns
{% for column in table['columns'] -%}
ALTER TABLE {{ table.name }} ADD COLUMN {{ column.column }}_new {{ column.dest_type }};
{% endfor %}

-- create a trigger to keep the new column up to date during the migration
CREATE OR REPLACE FUNCTION {{ table.name }}_migr01_trg()
        RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    {% for column in table['columns'] -%}
    NEW.{{ column.column }}_new = NEW.{{ column.column }};
    {% endfor %}
    RETURN NEW;
END;
$$;

CREATE TRIGGER {{ table.name }}_migr01_trg
    BEFORE INSERT OR UPDATE ON {{ table.name }}
    FOR EACH ROW
    EXECUTE PROCEDURE {{ table.name }}_migr01_trg();

COMMIT;
{% endfor %}

-- create dedicated index to speed up the migration
{% for table in tables -%}
-- table {{ table.name }}
CREATE INDEX CONCURRENTLY {{ table.name }}_{{ table.columns[0].column }}_migr01_idx ON
{{ table.name }} (id) WHERE {{ table.columns[0].column }}_new IS NULL;
{% endfor %}

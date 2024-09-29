--
-- Add the new column on the new type
-- Add an index to speed up the migration
--
{% for table in tables -%}
BEGIN;

-- add the new column
ALTER TABLE {{ table.name }} ADD COLUMN {{ table.column }}_new {{ table.dest_type }};

-- create a trigger to keep the new column up to date during the migration
CREATE OR REPLACE FUNCTION {{ table.name }}_{{ table.column }}_migr01_trg()
        RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.{{ table.column }}_new = NEW.{{ table.column }};
    RETURN NEW;
END;
$$;

CREATE TRIGGER {{ table.name }}_{{ table.column }}_migr01_trg
    BEFORE INSERT OR UPDATE ON {{ table.name }}
    FOR EACH ROW
    EXECUTE PROCEDURE {{ table.name }}_{{ table.column }}_migr01_trg();

COMMIT;
{% endfor %}

{% for table in tables -%}
-- create a dedicated index to speed up the migration
CREATE INDEX CONCURRENTLY {{ table.name }}_{{ table.column }}_migr01_idx ON
{{ table.name }} (id) WHERE {{ table.column }}_new IS NULL;
{% endfor %}

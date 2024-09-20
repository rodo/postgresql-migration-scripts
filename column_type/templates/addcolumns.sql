-- table {{ table }}
-- column {{ column }}
--
--
-- add the new column
ALTER TABLE {{table}} ADD COLUMN {{ column }}_new numeric(8,3);

-- create a trigger to keep the new column up to date during the migration
CREATE OR REPLACE FUNCTION {{ table }}_{{ column }}_migr01_trg()
        RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    NEW.{{ column }}_new = NEW.{{ column }};
    RETURN NEW;
END;
$$;

CREATE TRIGGER {{ table }}_{{ column }}_migr01_trg
    BEFORE INSERT OR UPDATE ON {{ table }}
    FOR EACH ROW
    EXECUTE PROCEDURE {{ table }}_{{ column }}_migr01_trg();

-- create a dedicated index to speed up the migration
CREATE INDEX CONCURRENTLY {{ table }}_{{ column }}_migr01_idx ON
{{ table }} (id) WHERE {{ column }}_new IS NULL;

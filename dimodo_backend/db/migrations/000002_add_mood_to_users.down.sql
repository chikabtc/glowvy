BEGIN;
ALTER TABLE userss
    DROP COLUMN mood;
DROP TYPE enum_mood;
COMMIT;


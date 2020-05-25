BEGIN;
CREATE TYPE enum_mood AS ENUM (
    'happy',
    'sad',
    'neutral'
);
ALTER TABLE userss
    ADD COLUMN mood enum_mood;
COMMIT;


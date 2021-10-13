-- upgrade --
CREATE TABLE IF NOT EXISTS "appointmentslots" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "slot_time" VARCHAR(900),
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE
);
-- downgrade --
DROP TABLE IF EXISTS "appointmentslots";

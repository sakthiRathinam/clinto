-- upgrade --
CREATE TABLE IF NOT EXISTS "appointments" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "requested_date" DATE,
    "accepted_date" DATE,
    "status" VARCHAR(15) NOT NULL  DEFAULT 'Pending',
    "accepted_slot_id" INT NOT NULL REFERENCES "appointmentslots" ("id") ON DELETE CASCADE,
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "requested_slot_id" INT NOT NULL REFERENCES "appointmentslots" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);
COMMENT ON COLUMN "appointments"."status" IS 'Requested: Requested\nAccepted: Accepted\nCancelled: Cancelled\nClinicCancelled: ClinicCancelled\nPending: Pending';
-- downgrade --
DROP TABLE IF EXISTS "appointments";

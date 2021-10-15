-- upgrade --
ALTER TABLE "presmedicines" ADD "diagonsis_id" INT NOT NULL;
CREATE TABLE IF NOT EXISTS "prescription" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "active" BOOL NOT NULL  DEFAULT True,
    "personal_prescription" BOOL NOT NULL  DEFAULT False,
    "rating_taken" BOOL NOT NULL  DEFAULT False,
    "gst_percentage" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "doctor_fees" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "age" INT NOT NULL  DEFAULT 0,
    "next_visit" DATE,
    "contains_drug" BOOL NOT NULL  DEFAULT False,
    "clinic_id" INT REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "doctor_id" INT REFERENCES "user" ("id") ON DELETE CASCADE,
    "receponist_id" INT REFERENCES "user" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);;
CREATE TABLE IF NOT EXISTS "prescriptiontemplates" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "age_group" VARCHAR(1000) NOT NULL,
    "active" BOOL NOT NULL  DEFAULT True,
    "personal" BOOL NOT NULL  DEFAULT False,
    "clinic_id" INT REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "diagonsis_id" INT NOT NULL REFERENCES "diagonsis" ("id") ON DELETE CASCADE,
    "doctor_id" INT REFERENCES "clinic" ("id") ON DELETE CASCADE
);;
CREATE TABLE "prescription_diagonsis" ("diagonsis_id" INT NOT NULL REFERENCES "diagonsis" ("id") ON DELETE CASCADE,"prescription_id" INT NOT NULL REFERENCES "prescription" ("id") ON DELETE CASCADE);
CREATE TABLE "prescription_presmedicines" ("presmedicines_id" INT NOT NULL REFERENCES "presmedicines" ("id") ON DELETE CASCADE,"prescription_id" INT NOT NULL REFERENCES "prescription" ("id") ON DELETE CASCADE);
ALTER TABLE "presmedicines" ADD CONSTRAINT "fk_presmedi_diagonsi_4f953d69" FOREIGN KEY ("diagonsis_id") REFERENCES "diagonsis" ("id") ON DELETE CASCADE;
-- downgrade --
ALTER TABLE "presmedicines" DROP CONSTRAINT "fk_presmedi_diagonsi_4f953d69";
DROP TABLE IF EXISTS "prescriptiontemplates_presmedicines";
DROP TABLE IF EXISTS "prescription_diagonsis";
ALTER TABLE "presmedicines" DROP COLUMN "diagonsis_id";
DROP TABLE IF EXISTS "prescription";
DROP TABLE IF EXISTS "prescriptiontemplates";

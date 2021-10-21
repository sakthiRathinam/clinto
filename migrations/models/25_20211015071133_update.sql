-- upgrade --
CREATE TABLE "prescription_medicalreports" ("medicalreports_id" INT NOT NULL REFERENCES "medicalreports" ("id") ON DELETE CASCADE,"prescription_id" INT NOT NULL REFERENCES "prescription" ("id") ON DELETE CASCADE);
-- downgrade --
DROP TABLE IF EXISTS "prescription_medicalreports";

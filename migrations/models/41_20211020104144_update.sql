-- upgrade --
ALTER TABLE "createuserorder" ADD "prescription_id" INT;
CREATE TABLE "createuserorder_presmedicines" ("presmedicines_id" INT NOT NULL REFERENCES "presmedicines" ("id") ON DELETE CASCADE,"createuserorder_id" INT NOT NULL REFERENCES "createuserorder" ("id") ON DELETE CASCADE);
ALTER TABLE "createuserorder" ADD CONSTRAINT "fk_createus_prescrip_69a27a35" FOREIGN KEY ("prescription_id") REFERENCES "prescription" ("id") ON DELETE CASCADE;
-- downgrade --
ALTER TABLE "createuserorder" DROP CONSTRAINT "fk_createus_prescrip_69a27a35";
DROP TABLE IF EXISTS "createuserorder_presmedicines";
ALTER TABLE "createuserorder" DROP COLUMN "prescription_id";

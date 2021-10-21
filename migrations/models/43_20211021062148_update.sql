-- upgrade --
ALTER TABLE "clinic" ADD "zone_id" INT;
ALTER TABLE "clinic" ADD CONSTRAINT "fk_clinic_clinic_a31f421c" FOREIGN KEY ("zone_id") REFERENCES "clinic" ("id") ON DELETE CASCADE;
-- downgrade --
ALTER TABLE "clinic" DROP CONSTRAINT "fk_clinic_clinic_a31f421c";
ALTER TABLE "clinic" DROP COLUMN "zone_id";

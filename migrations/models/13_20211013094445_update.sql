-- upgrade --
ALTER TABLE "prescriptiontemplates" ADD "command" TEXT;
ALTER TABLE "prescriptiontemplates" DROP COLUMN "age_group";
-- downgrade --
ALTER TABLE "prescriptiontemplates" ADD "age_group" VARCHAR(1000) NOT NULL;
ALTER TABLE "prescriptiontemplates" DROP COLUMN "command";

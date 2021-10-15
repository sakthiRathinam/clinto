-- upgrade --
ALTER TABLE "user" ADD "experience" INT;
-- downgrade --
ALTER TABLE "user" DROP COLUMN "experience";

-- upgrade --
ALTER TABLE "user" ALTER COLUMN "date_of_birth" SET DEFAULT '2021-10-16';
ALTER TABLE "medicine" ADD "brand" VARCHAR(500);
-- downgrade --
ALTER TABLE "user" ALTER COLUMN "date_of_birth" SET DEFAULT '2021-10-15';
ALTER TABLE "medicine" DROP COLUMN "brand";

-- upgrade --
ALTER TABLE "user" ADD "qualifications" varchar(3000)[];
ALTER TABLE "user" ADD "specialization" varchar(3000)[];
-- downgrade --
ALTER TABLE "user" DROP COLUMN "qualifications";
ALTER TABLE "user" DROP COLUMN "specialization";

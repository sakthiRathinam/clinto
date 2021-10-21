-- upgrade --
ALTER TABLE "user" ADD "state" VARCHAR(800)   DEFAULT '';
ALTER TABLE "user" ADD "city" VARCHAR(800)   DEFAULT '';
ALTER TABLE "user" ADD "address" TEXT;
ALTER TABLE "user" ADD "country" VARCHAR(800)   DEFAULT '';
-- downgrade --
ALTER TABLE "user" DROP COLUMN "state";
ALTER TABLE "user" DROP COLUMN "city";
ALTER TABLE "user" DROP COLUMN "address";
ALTER TABLE "user" DROP COLUMN "country";

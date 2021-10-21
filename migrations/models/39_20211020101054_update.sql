-- upgrade --
ALTER TABLE "clinic" ADD "user_lang" VARCHAR(200);
ALTER TABLE "clinic" ADD "user_lat" VARCHAR(200);
-- downgrade --
ALTER TABLE "clinic" DROP COLUMN "user_lang";
ALTER TABLE "clinic" DROP COLUMN "user_lat";

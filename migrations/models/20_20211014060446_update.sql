-- upgrade --
ALTER TABLE "clinic" ADD "display_picture" VARCHAR(2000);
-- downgrade --
ALTER TABLE "clinic" DROP COLUMN "display_picture";

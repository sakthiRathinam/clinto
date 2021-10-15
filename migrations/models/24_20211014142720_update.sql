-- upgrade --
ALTER TABLE "user" ADD "display_picture" VARCHAR(2000) NOT NULL  DEFAULT '';
-- downgrade --
ALTER TABLE "user" DROP COLUMN "display_picture";

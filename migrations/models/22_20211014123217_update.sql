-- upgrade --
ALTER TABLE "prescription" ADD "create_template" BOOL NOT NULL  DEFAULT False;
-- downgrade --
ALTER TABLE "prescription" DROP COLUMN "create_template";

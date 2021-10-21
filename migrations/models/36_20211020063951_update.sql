-- upgrade --
ALTER TABLE "dunzoorder" ADD "is_refun" BOOL NOT NULL  DEFAULT False;
-- downgrade --
ALTER TABLE "dunzoorder" DROP COLUMN "is_refun";

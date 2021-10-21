-- upgrade --
ALTER TABLE "dunzoorder" DROP COLUMN "is_refun";
-- downgrade --
ALTER TABLE "dunzoorder" ADD "is_refun" BOOL NOT NULL  DEFAULT False;

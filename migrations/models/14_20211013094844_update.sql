-- upgrade --
ALTER TABLE "presmedicines" ADD "before_food" BOOL NOT NULL  DEFAULT False;
-- downgrade --
ALTER TABLE "presmedicines" DROP COLUMN "before_food";

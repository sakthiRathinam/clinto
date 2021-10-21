-- upgrade --
ALTER TABLE "user" ADD "date_of_birth" DATE NOT NULL  DEFAULT '2021-10-15';
ALTER TABLE "presmedicines" ADD "create_template" BOOL NOT NULL  DEFAULT False;
-- downgrade --
ALTER TABLE "user" DROP COLUMN "date_of_birth";
ALTER TABLE "presmedicines" DROP COLUMN "create_template";

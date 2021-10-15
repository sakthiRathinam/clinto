-- upgrade --
ALTER TABLE "user" ADD "currently_active" BOOL NOT NULL  DEFAULT False;
ALTER TABLE "user" ALTER COLUMN "is_active" SET DEFAULT True;
ALTER TABLE "user" ALTER COLUMN "email" DROP NOT NULL;
-- downgrade --
ALTER TABLE "user" DROP COLUMN "currently_active";
ALTER TABLE "user" ALTER COLUMN "is_active" SET DEFAULT False;
ALTER TABLE "user" ALTER COLUMN "email" SET NOT NULL;

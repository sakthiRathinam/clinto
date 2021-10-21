-- upgrade --
ALTER TABLE "user" ADD "personal_inventory" BOOL NOT NULL  DEFAULT False;
ALTER TABLE "user" ADD "inventory_id" INT;
ALTER TABLE "user" ADD "created_subs" BOOL NOT NULL  DEFAULT False;
ALTER TABLE "clinic" ADD "pincode" VARCHAR(300);
ALTER TABLE "clinicdoctors" ADD "subs" BOOL NOT NULL  DEFAULT False;
ALTER TABLE "clinicdoctors" ADD "personal_inventory" BOOL NOT NULL  DEFAULT False;
CREATE TABLE IF NOT EXISTS "medicalreports" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "title" VARCHAR(1000) NOT NULL UNIQUE,
    "active" BOOL NOT NULL  DEFAULT False
);;
ALTER TABLE "prescription" ADD "is_template" BOOL NOT NULL  DEFAULT False;
ALTER TABLE "user" ADD CONSTRAINT "fk_user_inventor_30747080" FOREIGN KEY ("inventory_id") REFERENCES "inventory" ("id") ON DELETE CASCADE;
-- downgrade --
ALTER TABLE "user" DROP CONSTRAINT "fk_user_inventor_30747080";
ALTER TABLE "user" DROP COLUMN "personal_inventory";
ALTER TABLE "user" DROP COLUMN "inventory_id";
ALTER TABLE "user" DROP COLUMN "created_subs";
ALTER TABLE "clinic" DROP COLUMN "pincode";
ALTER TABLE "prescription" DROP COLUMN "is_template";
ALTER TABLE "clinicdoctors" DROP COLUMN "subs";
ALTER TABLE "clinicdoctors" DROP COLUMN "personal_inventory";
DROP TABLE IF EXISTS "medicalreports";

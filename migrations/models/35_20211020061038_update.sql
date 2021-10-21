-- upgrade --
ALTER TABLE "user" ALTER COLUMN "date_of_birth" SET DEFAULT '2021-10-20';
CREATE TABLE IF NOT EXISTS "clinicverification" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "name" VARCHAR(700) NOT NULL,
    "email" VARCHAR(800),
    "mobile" VARCHAR(20),
    "verified" BOOL NOT NULL  DEFAULT False
);
CREATE INDEX IF NOT EXISTS "idx_clinicverif_name_6af7e7" ON "clinicverification" ("name");;
-- downgrade --
ALTER TABLE "dunzoorder" DROP CONSTRAINT "fk_dunzoord_createus_b98968ad";
ALTER TABLE "user" ALTER COLUMN "date_of_birth" SET DEFAULT '2021-10-19';
ALTER TABLE "dunzoorder" DROP COLUMN "main_order_id";
DROP TABLE IF EXISTS "clinicverification";

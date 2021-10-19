-- upgrade --
CREATE TABLE IF NOT EXISTS "createuserorder" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "order_mode" VARCHAR(9) NOT NULL  DEFAULT 'PENDING',
    "user_lat" VARCHAR(600),
    "user_lang" VARCHAR(600),
    "medical_lat" VARCHAR(600),
    "medical_lang" VARCHAR(600),
    "total_price" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "discount_price" INT NOT NULL  DEFAULT 0,
    "accepted_price" INT NOT NULL  DEFAULT 0
);
COMMENT ON COLUMN "createuserorder"."order_mode" IS 'FAILED: FAILED\nCOMPLETED: COMPLETED\nACTIVE: ACTIVE\nDELIVERED: DELIVERED\nCANCELLED: CANCELLED\nPENDING: PENDING';;
CREATE TABLE "createuserorder_clinic" ("clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,"createuserorder_id" INT NOT NULL REFERENCES "createuserorder" ("id") ON DELETE CASCADE);
-- downgrade --
DROP TABLE IF EXISTS "createuserorder_clinic";
DROP TABLE IF EXISTS "createuserorder";

-- upgrade --
ALTER TABLE "dunzoorder" ADD "main_order_id" INT;
ALTER TABLE "dunzoorder" ADD CONSTRAINT "fk_dunzoord_createus_b98968ad" FOREIGN KEY ("main_order_id") REFERENCES "createuserorder" ("id") ON DELETE CASCADE;
-- downgrade --
ALTER TABLE "dunzoorder" DROP CONSTRAINT "fk_dunzoord_createus_b98968ad";
ALTER TABLE "dunzoorder" DROP COLUMN "main_order_id";

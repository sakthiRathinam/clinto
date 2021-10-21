-- upgrade --
ALTER TABLE "createuserorder" ADD "user_id" INT NOT NULL;
ALTER TABLE "createuserorder" ADD "medical_store_id" INT;
ALTER TABLE "createuserorder" ADD CONSTRAINT "fk_createus_clinic_6e433d03" FOREIGN KEY ("medical_store_id") REFERENCES "clinic" ("id") ON DELETE CASCADE;
ALTER TABLE "createuserorder" ADD CONSTRAINT "fk_createus_user_c5e9c83d" FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE;
-- downgrade --
ALTER TABLE "createuserorder" DROP CONSTRAINT "fk_createus_user_c5e9c83d";
ALTER TABLE "createuserorder" DROP CONSTRAINT "fk_createus_clinic_6e433d03";
ALTER TABLE "createuserorder" DROP COLUMN "user_id";
ALTER TABLE "createuserorder" DROP COLUMN "medical_store_id";

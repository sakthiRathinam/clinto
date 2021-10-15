-- upgrade --
ALTER TABLE "appointmentslots" ADD "doctor_id" INT NOT NULL;
ALTER TABLE "appointments" ADD "doctor_id" INT NOT NULL;
ALTER TABLE "appointmentslots" ADD CONSTRAINT "fk_appointm_user_038b1d91" FOREIGN KEY ("doctor_id") REFERENCES "user" ("id") ON DELETE CASCADE;
ALTER TABLE "appointments" ADD CONSTRAINT "fk_appointm_user_ca49e04e" FOREIGN KEY ("doctor_id") REFERENCES "user" ("id") ON DELETE CASCADE;
-- downgrade --
ALTER TABLE "appointmentslots" DROP CONSTRAINT "fk_appointm_user_038b1d91";
ALTER TABLE "appointments" DROP CONSTRAINT "fk_appointm_user_ca49e04e";
ALTER TABLE "appointments" DROP COLUMN "doctor_id";
ALTER TABLE "appointmentslots" DROP COLUMN "doctor_id";

-- upgrade --
ALTER TABLE "appointmentslots" ADD "max_slots" INT NOT NULL  DEFAULT 0;
-- downgrade --
ALTER TABLE "appointmentslots" DROP COLUMN "max_slots";

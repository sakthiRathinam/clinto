-- upgrade --
ALTER TABLE "clinicdoctors" ADD "doctor_access" BOOL NOT NULL  DEFAULT True;
-- downgrade --
ALTER TABLE "clinicdoctors" DROP COLUMN "doctor_access";

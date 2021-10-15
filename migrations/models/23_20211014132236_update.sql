-- upgrade --
ALTER TABLE "clinicreceponists" DROP COLUMN "endtime";
ALTER TABLE "clinicreceponists" DROP COLUMN "starttime";
-- downgrade --
ALTER TABLE "clinicreceponists" ADD "endtime" DATE;
ALTER TABLE "clinicreceponists" ADD "starttime" DATE;

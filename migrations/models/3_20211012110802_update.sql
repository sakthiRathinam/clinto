-- upgrade --
ALTER TABLE "clinic" ADD "clinic_images" varchar(3000)[];
-- downgrade --
ALTER TABLE "clinic" DROP COLUMN "clinic_images";

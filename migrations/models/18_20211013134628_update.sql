-- upgrade --
ALTER TABLE "clinic" ADD "drug_license" VARCHAR(1000);
ALTER TABLE "clinic" ADD "gst_percentage" DOUBLE PRECISION NOT NULL  DEFAULT 0;
-- downgrade --
ALTER TABLE "clinic" DROP COLUMN "drug_license";
ALTER TABLE "clinic" DROP COLUMN "gst_percentage";

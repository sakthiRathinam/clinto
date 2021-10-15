-- upgrade --
ALTER TABLE "clinic" ADD "gst_no" VARCHAR(1000);
-- downgrade --
ALTER TABLE "clinic" DROP COLUMN "gst_no";

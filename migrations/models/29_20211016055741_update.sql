-- upgrade --
ALTER TABLE "clinic" ALTER COLUMN "sub_types" DROP NOT NULL;
-- downgrade --
ALTER TABLE "clinic" ALTER COLUMN "sub_types" SET NOT NULL;

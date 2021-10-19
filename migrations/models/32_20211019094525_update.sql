-- upgrade --
ALTER TABLE "user" ALTER COLUMN "date_of_birth" SET DEFAULT '2021-10-19';
ALTER TABLE "clinic" ALTER COLUMN "sub_types" TYPE VARCHAR(16) USING "sub_types"::VARCHAR(16);
ALTER TABLE "razorpayment" ADD "active" BOOL NOT NULL  DEFAULT True;
-- downgrade --
ALTER TABLE "user" ALTER COLUMN "date_of_birth" SET DEFAULT '2021-10-18';
ALTER TABLE "clinic" ALTER COLUMN "sub_types" TYPE VARCHAR(16) USING "sub_types"::VARCHAR(16);
ALTER TABLE "razorpayment" DROP COLUMN "active";

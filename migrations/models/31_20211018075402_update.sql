-- upgrade --
CREATE TABLE IF NOT EXISTS "monthlyplans" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "main_subscription" VARCHAR(9) NOT NULL  DEFAULT 'Monthly',
    "amount" INT NOT NULL  DEFAULT 0,
    "discount" INT NOT NULL  DEFAULT 0,
    "discount_percent" DOUBLE PRECISION NOT NULL  DEFAULT 0
);
COMMENT ON COLUMN "monthlyplans"."main_subscription" IS 'Monthly: Monthly\nQuarterly: Quarterly\nYearly: Yearly\nHalfly: Halfly';;
CREATE TABLE IF NOT EXISTS "razorpayment" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "subscription" VARCHAR(9) NOT NULL  DEFAULT 'Monthly',
    "status" VARCHAR(8) NOT NULL  DEFAULT 'Pending',
    "payment_mode" VARCHAR(4) NOT NULL  DEFAULT 'upi',
    "order_id" VARCHAR(800),
    "is_received" BOOL NOT NULL  DEFAULT False,
    "is_refunded" BOOL NOT NULL  DEFAULT False,
    "amount" INT NOT NULL  DEFAULT 0,
    "subscription_date" DATE,
    "valid_till" DATE,
    "is_cash" BOOL NOT NULL  DEFAULT False,
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);
COMMENT ON COLUMN "razorpayment"."subscription" IS 'Monthly: Monthly\nQuarterly: Quarterly\nYearly: Yearly\nHalfly: Halfly';
COMMENT ON COLUMN "razorpayment"."status" IS 'Pending: Pending\nSuccess: Success\nFailed: Failed\nRefunded: Refunded';
COMMENT ON COLUMN "razorpayment"."payment_mode" IS 'upi: upi\ncash: cash\ncard: card';-- downgrade --
DROP TABLE IF EXISTS "monthlyplans";
DROP TABLE IF EXISTS "razorpayment";

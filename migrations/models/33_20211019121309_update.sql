-- upgrade --
CREATE TABLE IF NOT EXISTS "dunzoorder" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "to_send" JSONB,
    "current_response" JSONB,
    "task_id" VARCHAR(500),
    "refund_id" VARCHAR(400),
    "order_id" VARCHAR(300),
    "payment_id" VARCHAR(300),
    "is_refunded" BOOL NOT NULL  DEFAULT False,
    "is_delivered" BOOL NOT NULL  DEFAULT False,
    "current_state" VARCHAR(500),
    "is_cancelled" BOOL NOT NULL  DEFAULT False,
    "estimated_price" DOUBLE PRECISION,
    "razor_price" DOUBLE PRECISION,
    "razor_commision" INT,
    "is_received" BOOL NOT NULL  DEFAULT False,
    "amount" INT NOT NULL  DEFAULT 0,
    "payment_status" VARCHAR(7) NOT NULL  DEFAULT 'Pending',
    "dunzo_status" VARCHAR(9) NOT NULL  DEFAULT 'PENDING',
    "payment_method" VARCHAR(12) NOT NULL  DEFAULT 'DUNZO_CREDIT',
    "medical_store_id" INT REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);
COMMENT ON COLUMN "dunzoorder"."payment_status" IS 'Pending: Pending\nSuccess: Success\nFailed: Failed';
COMMENT ON COLUMN "dunzoorder"."dunzo_status" IS 'FAILED: FAILED\nCOMPLETED: COMPLETED\nACTIVE: ACTIVE\nDELIVERED: DELIVERED\nCANCELLED: CANCELLED\nPENDING: PENDING';
COMMENT ON COLUMN "dunzoorder"."payment_method" IS 'COD: COD\nDUNZO_CREDIT: DUNZO_CREDIT';
-- downgrade --
DROP TABLE IF EXISTS "dunzoorder";

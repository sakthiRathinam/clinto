-- upgrade --
CREATE TABLE IF NOT EXISTS "presmedicines" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "morning_count" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "afternoon_count" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "invalid_count" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "night_count" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "qty_per_time" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "total_qty" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "command" TEXT,
    "is_drug" BOOL NOT NULL  DEFAULT False,
    "is_given" BOOL NOT NULL  DEFAULT False,
    "fromDate" DATE,
    "toDate" DATE,
    "days" DOUBLE PRECISION NOT NULL  DEFAULT 0,
    "medicine_id" INT NOT NULL REFERENCES "medicine" ("id") ON DELETE CASCADE
);
-- downgrade --
DROP TABLE IF EXISTS "presmedicines";

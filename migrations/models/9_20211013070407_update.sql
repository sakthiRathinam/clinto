-- upgrade --
CREATE TABLE IF NOT EXISTS "diagonsis" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "title" VARCHAR(1000) NOT NULL UNIQUE,
    "active" BOOL NOT NULL  DEFAULT False
);
-- downgrade --
DROP TABLE IF EXISTS "diagonsis";
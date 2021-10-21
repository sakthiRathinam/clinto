-- upgrade --
CREATE TABLE IF NOT EXISTS "labowners" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "starttime_str" VARCHAR(600),
    "endtime_str" VARCHAR(600),
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);;
CREATE TABLE IF NOT EXISTS "pharmacyowners" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "starttime_str" VARCHAR(600),
    "endtime_str" VARCHAR(600),
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);-- downgrade --
DROP TABLE IF EXISTS "labowners";
DROP TABLE IF EXISTS "pharmacyowners";

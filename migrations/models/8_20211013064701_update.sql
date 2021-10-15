-- upgrade --
ALTER TABLE "clinic" ADD "created_subs" BOOL NOT NULL  DEFAULT False;
CREATE TABLE IF NOT EXISTS "medicine" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "max_retial_price" INT NOT NULL  DEFAULT 0,
    "type" VARCHAR(13) NOT NULL  DEFAULT 'Capsules',
    "title" VARCHAR(1000) NOT NULL UNIQUE,
    "active" BOOL NOT NULL  DEFAULT False
);
COMMENT ON COLUMN "medicine"."type" IS 'Liquid: Liquid\nTablet: Tablet\nCapsules: Capsules\nCream: Cream\nPowder: Powder\nLotion: Lotion\nSoap: Soap\nShampoo: Shampoo\nSuspension: Suspension\nSerum: Serum\nOil: Oil\nInhalers: Inhalers\nInjections: Injections\nSuppositories: Suppositories\nSolution: Solution\nOthers: Others';-- downgrade --
ALTER TABLE "clinic" DROP COLUMN "created_subs";
DROP TABLE IF EXISTS "medicine";

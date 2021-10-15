-- upgrade --
ALTER TABLE "user" ALTER COLUMN "roles" TYPE VARCHAR(13) USING "roles"::VARCHAR(13);
-- downgrade --
ALTER TABLE "user" ALTER COLUMN "roles" TYPE VARCHAR(13) USING "roles"::VARCHAR(13);

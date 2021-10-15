-- upgrade --
CREATE TABLE IF NOT EXISTS "permissions" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "app_name" VARCHAR(500) NOT NULL UNIQUE,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "permission_level" VARCHAR(14) NOT NULL  DEFAULT 'Admin',
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP
);
COMMENT ON COLUMN "permissions"."permission_level" IS 'Admin: Admin\nEmp: Emp\nLowPermissions: LowPermissions';
CREATE TABLE IF NOT EXISTS "user" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "username" VARCHAR(100) NOT NULL UNIQUE,
    "email" VARCHAR(100) NOT NULL UNIQUE,
    "mobile" VARCHAR(15),
    "roles" VARCHAR(13) NOT NULL  DEFAULT 'Patient',
    "password" VARCHAR(100) NOT NULL,
    "first_name" VARCHAR(100) NOT NULL  DEFAULT '',
    "last_name" VARCHAR(100)   DEFAULT '',
    "date_join" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "last_login" TIMESTAMPTZ,
    "is_active" BOOL NOT NULL  DEFAULT False,
    "is_staff" BOOL NOT NULL  DEFAULT False,
    "is_superuser" BOOL NOT NULL  DEFAULT False,
    "avatar" VARCHAR(1000)
);
COMMENT ON COLUMN "user"."roles" IS 'Doctor: Doctor\nPatient: Patient\nRecoponist: Recoponist\nPharmacyOwner: PharmacyOwner\nLabOwner: LabOwner';
COMMENT ON TABLE "user" IS 'Model user ';
CREATE TABLE IF NOT EXISTS "verification" (
    "link" UUID NOT NULL  PRIMARY KEY,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);
COMMENT ON TABLE "verification" IS 'Модель для подтверждения регистрации пользователя';
CREATE TABLE IF NOT EXISTS "clinictimings" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "day" VARCHAR(9) NOT NULL  DEFAULT 'Monday',
    "timings" varchar(600)[] NOT NULL
);
COMMENT ON COLUMN "clinictimings"."day" IS 'Monday: Monday\nTuesday: Tuesday\nWednesday: Wednesday\nThursday: Thursday\nFriday: Friday\nSaturday: Saturday\nSunday: Sunday';
CREATE TABLE IF NOT EXISTS "inventory" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "title" VARCHAR(400) NOT NULL,
    "types" VARCHAR(12) NOT NULL  DEFAULT 'Clinic'
);
COMMENT ON COLUMN "inventory"."types" IS 'Doctor: Doctor\nMedicalStore: MedicalStore\nClinic: Clinic\nLab: Lab';
CREATE TABLE IF NOT EXISTS "clinic" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "name" VARCHAR(400) NOT NULL,
    "email" VARCHAR(600),
    "mobile" VARCHAR(20),
    "notificationId" VARCHAR(500),
    "address" TEXT,
    "types" VARCHAR(12) NOT NULL  DEFAULT 'Clinic',
    "sub_types" VARCHAR(16) NOT NULL  DEFAULT 'eye',
    "total_ratings" INT NOT NULL  DEFAULT 0,
    "city" VARCHAR(500),
    "state" VARCHAR(500),
    "lat" VARCHAR(200),
    "lang" VARCHAR(200),
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "discount_percent" INT NOT NULL  DEFAULT 0,
    "inventoryIncluded" BOOL NOT NULL  DEFAULT False,
    "active" BOOL NOT NULL  DEFAULT True,
    "inventory_id" INT REFERENCES "inventory" ("id") ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS "idx_clinic_name_0425f2" ON "clinic" ("name");
COMMENT ON COLUMN "clinic"."types" IS 'MedicalStore: MedicalStore\nClinic: Clinic\nOthers: Others\nLab: Lab';
COMMENT ON COLUMN "clinic"."sub_types" IS 'eye: eye\ndental: dental\ncardiology: cardiology\ndermatology: dermatology\nthroat: throat\nnose: nose\ngastroenterology: gastroenterology\nobstetrics: obstetrics\npodiatry: podiatry\nneurology: neurology\nphysicaltherapy: physicaltherapy\nurology: urology\nophthalmology: ophthalmology\noncology: oncology\northopedics: orthopedics\nhomeo: homeo\nvetnary: vetnary';
CREATE TABLE IF NOT EXISTS "clinicdoctors" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "active" BOOL NOT NULL  DEFAULT False,
    "owner_access" BOOL NOT NULL  DEFAULT False,
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "clinicreceponists" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "created" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "updated" TIMESTAMPTZ NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    "starttime_str" VARCHAR(600),
    "endtime_str" VARCHAR(600),
    "starttime" DATE,
    "endtime" DATE,
    "types" VARCHAR(12) NOT NULL  DEFAULT 'Clinic',
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE
);
COMMENT ON COLUMN "clinicreceponists"."types" IS 'Doctor: Doctor\nMedicalStore: MedicalStore\nClinic: Clinic\nLab: Lab';
CREATE TABLE IF NOT EXISTS "aerich" (
    "id" SERIAL NOT NULL PRIMARY KEY,
    "version" VARCHAR(255) NOT NULL,
    "app" VARCHAR(20) NOT NULL,
    "content" JSONB NOT NULL
);
CREATE TABLE IF NOT EXISTS "user_permissions" (
    "user_id" INT NOT NULL REFERENCES "user" ("id") ON DELETE CASCADE,
    "permissions_id" INT NOT NULL REFERENCES "permissions" ("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "clinic_clinictimings" (
    "clinic_id" INT NOT NULL REFERENCES "clinic" ("id") ON DELETE CASCADE,
    "clinictimings_id" INT NOT NULL REFERENCES "clinictimings" ("id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "doctor_timings" (
    "clinicdoctors_id" INT NOT NULL REFERENCES "clinicdoctors" ("id") ON DELETE CASCADE,
    "clinictimings_id" INT NOT NULL REFERENCES "clinictimings" ("id") ON DELETE CASCADE
);

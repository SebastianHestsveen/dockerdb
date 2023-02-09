CREATE TYPE "time_type_enum" AS ENUM (
  'default',
  'no_end',
  'whole_day'
);

CREATE TYPE "location_type" AS ENUM (
  'mazemap',
  'coords'
);

CREATE TABLE "Event" (
  "id" SERIAL PRIMARY KEY,
  "name_no" varchar NOT NULL,
  "name_en" varchar,
  "description_no" varchar,
  "description_en" varchar,
  "informational_no" varchar,
  "informational_en" varchar,
  "time_start" timestamptz NOT NULL,
  "time_end" timestamptz,
  "time_publish" timestamptz,
  "time_signup_release" timestamptz,
  "time_signup_deadline" timestamptz,
  "time_updated" timestamptz NOT NULL DEFAULT (now()),
  "time_type" time_type_enum NOT NULL DEFAULT 'default',
  "canceled" bool NOT NULL DEFAULT false,
  "digital" bool NOT NULL DEFAULT false,
  "highlight" bool NOT NULL DEFAULT false,
  "image_small" varchar NOT NULL,
  "image_banner" varchar NOT NULL,
  "link_facebook" varchar NOT NULL,
  "link_discord" varchar NOT NULL,
  "link_signup" varchar NOT NULL,
  "link_stream" varchar,
  "capacity" int NOT NULL,
  "full" bool NOT NULL DEFAULT false,
  "category" int NOT NULL,
  "location" int,
  "parent" int
);

CREATE TABLE "Category" (
  "id" SERIAL PRIMARY KEY,
  "color" char(6),
  "name_no" varchar NOT NULL,
  "name_en" varchar NOT NULL,
  "description_no" text NOT NULL,
  "description_en" text NOT NULL
);

CREATE TABLE "Audience" (
  "id" SERIAL PRIMARY KEY,
  "name_no" varchar NOT NULL,
  "name_en" varchar,
  "description_no" varchar NOT NULL,
  "description_en" varchar NOT NULL
);

CREATE TABLE "EventAudienceRelation" (
  "event" int NOT NULL,
  "audience" int NOT NULL,
  PRIMARY KEY ("event", "audience")
);

CREATE TABLE "Rules" (
  "id" SERIAL PRIMARY KEY,
  "name_no" varchar NOT NULL,
  "name_en" varchar,
  "description_no" varchar NOT NULL,
  "description_en" varchar NOT NULL,
  "consequence_no" varchar,
  "consequence_en" varchar,
  "time_updated" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "EventRulesRelation" (
  "event" int NOT NULL,
  "rule" int NOT NULL,
  PRIMARY KEY ("event", "rule")
);

CREATE TABLE "Organization" (
  "shortname" varchar PRIMARY KEY,
  "name_no" varchar NOT NULL,
  "name_en" varchar,
  "description_no" varchar NOT NULL,
  "description_en" varchar NOT NULL,
  "link_homepage" varchar,
  "link_linkedin" varchar,
  "link_facebook" varchar,
  "link_instagram" varchar,
  "logo" varchar
);

CREATE TABLE "EventOrganizationRelation" (
  "event" int NOT NULL,
  "organization" varchar NOT NULL,
  PRIMARY KEY ("event", "organization")
);

CREATE TABLE "Location" (
  "id" SERIAL PRIMARY KEY,
  "name_no" varchar NOT NULL,
  "name_en" varchar,
  "type" location_type NOT NULL DEFAULT 'mazemap',
  "mazemap_campus_id" int,
  "mazemap_poi_id" int,
  "address_street" varchar,
  "address_postcode" int,
  "coordinate_lat" float,
  "coordinate_long" float,
  "url" varchar
);

CREATE TABLE "Postcode" (
  "postcode" int PRIMARY KEY,
  "city_name" varchar
);

CREATE TABLE "JobAdvertisement" (
  "id" SERIAL PRIMARY KEY,
  "title_no" varchar NOT NULL,
  "title_en" varchar,
  "position_title_no" varchar,
  "position_title_en" varchar,
  "text_short_no" varchar,
  "text_short_en" varchar,
  "text_long_no" varchar,
  "text_long_en" varchar,
  "link_homepage" varchar,
  "link_linkedin" varchar,
  "link_facebook" varchar,
  "link_instagram" varchar,
  "logo" varchar,
  "organization" varchar NOT NULL
);

CREATE TABLE "JobAdvertisementPostcodeRelation" (
  "ad" int NOT NULL,
  "postcode" int NOT NULL,
  PRIMARY KEY ("ad", "postcode")
);

CREATE TABLE "Skill" (
  "name" varchar PRIMARY KEY
);

CREATE TABLE "JobAdvertisementSkillRelation" (
  "ad" int NOT NULL,
  "skill" varchar NOT NULL,
  PRIMARY KEY ("ad", "skill")
);

CREATE INDEX ON "EventAudienceRelation" ("event");

CREATE INDEX ON "EventAudienceRelation" ("audience");

CREATE INDEX ON "EventRulesRelation" ("event");

CREATE INDEX ON "EventRulesRelation" ("rule");

CREATE INDEX ON "EventOrganizationRelation" ("event");

CREATE INDEX ON "EventOrganizationRelation" ("organization");

CREATE INDEX ON "JobAdvertisementPostcodeRelation" ("ad");

CREATE INDEX ON "JobAdvertisementPostcodeRelation" ("postcode");

CREATE INDEX ON "JobAdvertisementSkillRelation" ("ad");

CREATE INDEX ON "JobAdvertisementSkillRelation" ("skill");

COMMENT ON COLUMN "Category"."color" IS 'hex color';

ALTER TABLE "Event" ADD FOREIGN KEY ("category") REFERENCES "Category" ("id");

ALTER TABLE "Event" ADD FOREIGN KEY ("location") REFERENCES "Location" ("id");

ALTER TABLE "Event" ADD FOREIGN KEY ("parent") REFERENCES "Event" ("id");

ALTER TABLE "EventAudienceRelation" ADD FOREIGN KEY ("event") REFERENCES "Event" ("id");

ALTER TABLE "EventAudienceRelation" ADD FOREIGN KEY ("audience") REFERENCES "Audience" ("id");

ALTER TABLE "EventRulesRelation" ADD FOREIGN KEY ("event") REFERENCES "Event" ("id");

ALTER TABLE "EventRulesRelation" ADD FOREIGN KEY ("rule") REFERENCES "Rules" ("id");

ALTER TABLE "EventOrganizationRelation" ADD FOREIGN KEY ("event") REFERENCES "Event" ("id");

ALTER TABLE "EventOrganizationRelation" ADD FOREIGN KEY ("organization") REFERENCES "Organization" ("shortname");

ALTER TABLE "Location" ADD FOREIGN KEY ("address_postcode") REFERENCES "Postcode" ("postcode");

ALTER TABLE "JobAdvertisement" ADD FOREIGN KEY ("organization") REFERENCES "Organization" ("shortname");

ALTER TABLE "JobAdvertisementPostcodeRelation" ADD FOREIGN KEY ("ad") REFERENCES "JobAdvertisement" ("id");

ALTER TABLE "JobAdvertisementPostcodeRelation" ADD FOREIGN KEY ("postcode") REFERENCES "Postcode" ("postcode");

ALTER TABLE "JobAdvertisementSkillRelation" ADD FOREIGN KEY ("ad") REFERENCES "JobAdvertisement" ("id");

ALTER TABLE "JobAdvertisementSkillRelation" ADD FOREIGN KEY ("skill") REFERENCES "Skill" ("name");
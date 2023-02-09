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

INSERT INTO "Category" ("color", "name_no", "name_en", "description_no", "description_en")
VALUES
('000000', 'Sport', 'Sport', 'Alle arrangementer som omhandler sport', 'All events related to sports'),
('FF0000', 'Musikk', 'Music', 'Alle arrangementer som omhandler musikk', 'All events related to music'),
('00FF00', 'Film', 'Film', 'Alle arrangementer som omhandler film', 'All events related to film'),
('0000FF', 'Teater', 'Theater', 'Alle arrangementer som omhandler teater', 'All events related to theater'),
('FFFF00', 'Bøker', 'Books', 'Alle arrangementer som omhandler bøker', 'All events related to books');

INSERT INTO "Postcode" (postcode, city_name)
VALUES
(1234, 'City A'),
(2345, 'City B'),
(3456, 'City C'),
(4567, 'City D'),
(5678, 'City E');

INSERT INTO "Location" (name_no, name_en, type, mazemap_campus_id, mazemap_poi_id, address_street, address_postcode, coordinate_lat, coordinate_long, url)
VALUES 
('Gløshaugen', 'Gløshaugen', 'mazemap', 1, 1, 'Olav Kyrres gate', 1234, 63.416865, 10.401070, 'https://mazemap.ntnu.no/#/@63.416865,10.401070,18.00z'),
('Sentralbygg 2', 'Central Building 2', 'mazemap', 1, 2, 'Kjøpmannsgt.', 2345, 63.441305, 10.409040, 'https://mazemap.ntnu.no/#/@63.441305,10.409040,18.00z'),
('Dragvoll', 'Dragvoll', 'mazemap', 2, 3, 'Brattørveita', 4567, 63.418200, 10.391700, 'https://mazemap.ntnu.no/#/@63.418200,10.391700,18.00z');

INSERT INTO "Event" (
  "name_no",
  "name_en",
  "description_no",
  "description_en",
  "informational_no",
  "informational_en",
  "time_start",
  "time_end",
  "time_publish",
  "time_signup_release",
  "time_signup_deadline",
  "time_type",
  "canceled",
  "digital",
  "highlight",
  "image_small",
  "image_banner",
  "link_facebook",
  "link_discord",
  "link_signup",
  "link_stream",
  "capacity",
  "full",
  "category",
  "location",
  "parent"
)
VALUES (
  'Test Event Name NO',
  'Test Event Name EN',
  'Test Description NO',
  'Test Description EN',
  'Test Informational NO',
  'Test Informational EN',
  '2022-01-01 12:00:00',
  '2022-01-02 12:00:00',
  '2021-12-31 12:00:00',
  '2021-12-31 10:00:00',
  '2022-01-01 08:00:00',
  'default',
  false,
  false,
  false,
  'test_image_small.jpg',
  'test_image_banner.jpg',
  'https://www.facebook.com',
  'https://www.discord.com',
  'https://www.signup.com',
  'https://www.stream.com',
  100,
  false,
  1,
  1,
  1
);

INSERT INTO "Audience" ("name_no", "name_en", "description_no", "description_en")
VALUES
  ('Studenter', 'Students', 'Studentgruppe for alle studenter', 'Student group for all students'),
  ('Bedrifter', 'Businesses', 'Gruppe for bedrifter', 'Group for businesses'),
  ('Lokalbefolkning', 'Local Community', 'Gruppe for lokalbefolkningen', 'Group for the local community');

INSERT INTO "EventAudienceRelation" ("event", "audience")
VALUES
(1, 1),
(1, 2),
(1, 3);

INSERT INTO "Rules" ("name_no", "name_en", "description_no", "description_en", "consequence_no", "consequence_en") 
VALUES
('Regel 1', 'Rule 1', 'Denne regelen gjelder for alle arrangementer', 'This rule applies to all events', 'Brudd på denne regelen vil føre til bortvisning fra arrangementet', 'Breaking this rule will result in being escorted from the event'),
('Regel 2', 'Rule 2', 'Ingen alkohol tillatt', 'No alcohol allowed', 'Brudd på denne regelen vil føre til bortvisning fra arrangementet', 'Breaking this rule will result in being escorted from the event'),
('Regel 3', 'Rule 3', 'Ingen røyking inne', 'No smoking inside', 'Brudd på denne regelen vil føre til bortvisning fra arrangementet', 'Breaking this rule will result in being escorted from the event');

INSERT INTO "EventRulesRelation" ("event", "rule")
VALUES
(1, 1),
(1, 2),
(1, 3);

INSERT INTO "Organization" (shortname, name_no, name_en, description_no, description_en, link_homepage, link_linkedin, link_facebook, link_instagram, logo)
VALUES
('NTNU', 'Norges teknisk-naturvitenskapelige universitet', 'Norwegian University of Science and Technology', 'NTNU er et av Norges største universiteter, med over 40 000 studenter.', 'NTNU is one of Norway''s largest universities, with over 40,000 students.', 'https://www.ntnu.no', 'https://linkedin.com/company/ntnu', 'https://facebook.com/ntnu', 'https://instagram.com/ntnu_no', 'https://ntnu.no/logo.png'),
('UiO', 'Universitetet i Oslo', 'University of Oslo', 'UiO er Norges eldste og mest prestisjefylte universitet, med over 30 000 studenter.', 'UiO is Norway''s oldest and most prestigious university, with over 30,000 students.', 'https://www.uio.no', 'https://linkedin.com/company/universitetet-i-oslo', 'https://facebook.com/universitetetioslo', 'https://instagram.com/uio_no', 'https://uio.no/logo.png');

INSERT INTO "EventOrganizationRelation" ("event", "organization")
VALUES
(1, 'NTNU'),
(1, 'UiO');

INSERT INTO "JobAdvertisement" (
"title_no",
"title_en",
"position_title_no",
"position_title_en",
"text_short_no",
"text_short_en",
"text_long_no",
"text_long_en",
"link_homepage",
"link_linkedin",
"link_facebook",
"link_instagram",
"logo",
"organization"
)
VALUES
('Tittel på stilling i Norsk', 'Job title in English', 'Stillingstittel i Norsk', 'Position title in English', 'Kort beskrivelse i Norsk', 'Short description in English', 'Lang beskrivelse i Norsk', 'Long description in English', 'https://example.com/homepage', 'https://example.com/linkedin', 'https://example.com/facebook', 'https://example.com/instagram', 'https://example.com/logo', 'NTNU'),
('Tittel på annen stilling i Norsk', 'Another job title in English', 'Annen stillingstittel i Norsk', 'Another position title in English', 'Kort beskrivelse av annen stilling i Norsk', 'Short description of another job in English', 'Lang beskrivelse av annen stilling i Norsk', 'Long description of another job in English', 'https://example.com/homepage2', 'https://example.com/linkedin2', 'https://example.com/facebook2', 'https://example.com/instagram2', 'https://example.com/logo2', 'UiO');

INSERT INTO "JobAdvertisementPostcodeRelation" (ad, postcode) VALUES
(1, 1234),
(2, 2345);

INSERT INTO "Skill" (name) VALUES
('Java'),
('JavaScript'),
('SQL'),
('Python'),
('C++');

INSERT INTO "JobAdvertisement" (title_no, position_title_no, text_short_no, text_long_no, organization) VALUES
('Java-utvikler', 'Software Engineer', 'Vi søker en dyktig Java-utvikler', 'Vi søker en dyktig Java-utvikler til å jobbe med utvikling av våre plattformer. Du må ha erfaring med Java og gode kunnskaper i databaser.', 'NTNU'),
('JavaScript-utvikler', 'Frontend Developer', 'Vi søker en dyktig JavaScript-utvikler', 'Vi søker en dyktig JavaScript-utvikler til å jobbe med utvikling av våre nettsider. Du må ha erfaring med JavaScript, HTML og CSS.', 'UiO'),
('SQL-databaseadministrator', 'Database Administrator', 'Vi søker en dyktig SQL-databaseadministrator', 'Vi søker en dyktig SQL-databaseadministrator til å vedlikeholde og utvikle våre databaser. Du må ha erfaring med SQL og kunnskap om databaseadministrasjon.', 'NTNU');

INSERT INTO "JobAdvertisementSkillRelation" (ad, skill) VALUES
(1, 'Java'),
(2, 'JavaScript'),
(3, 'SQL');
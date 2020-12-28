CREATE SEQUENCE "push_credentials_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "push_device_registration_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "push_message_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "push_campaign_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;
CREATE SEQUENCE "push_campaign_user_seq" MINVALUE 1 MAXVALUE 999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20;

CREATE TABLE "push_app_credentials"
(
    "id"                  INTEGER NOT NULL PRIMARY KEY,
    "app_id"              INTEGER NOT NULL,
    "ios_key_id"          VARCHAR(255),
    "ios_private_key"     VARCHAR(255),
    "ios_team_id"         VARCHAR(255),
    "ios_bundle"          VARCHAR(255),
    "android_private_key" BLOB,
    "android_project_id"  VARCHAR(255)
);

CREATE TABLE "push_device_registration"
(
    "id"                        INTEGER NOT NULL PRIMARY KEY,
    "activation_id"             VARCHAR(37),
    "user_id"                   VARCHAR(255),
    "app_id"                    INTEGER NOT NULL,
    "platform"                  VARCHAR(255) NOT NULL,
    "push_token"                VARCHAR(255) NOT NULL,
    "timestamp_last_registered" TIMESTAMP (6) NOT NULL,
    "is_active"                 BOOLEAN
);

CREATE TABLE "push_message"
(
    "id"                      INTEGER NOT NULL PRIMARY KEY,
    "device_registration_id"  INTEGER NOT NULL,
    "user_id"                 VARCHAR(255) NOT NULL,
    "activation_id"           VARCHAR(37),
    "is_silent"               BOOLEAN NOT NULL DEFAULT FALSE,
    "is_personal"             BOOLEAN NOT NULL DEFAULT FALSE,
    "message_body"            VARCHAR(2048) NOT NULL,
    "timestamp_created"       TIMESTAMP (6) NOT NULL,
    "status"                  INTEGER NOT NULL
);

CREATE TABLE "push_campaign"
(
   "id"                  INTEGER NOT NULL PRIMARY KEY,
   "app_id"              INTEGER NOT NULL,
   "message"             VARCHAR(4000) NOT NULL,
   "is_sent"             BOOLEAN NOT NULL DEFAULT FALSE,
   "timestamp_created"   TIMESTAMP (6) NOT NULL,
   "timestamp_sent"      TIMESTAMP (6),
   "timestamp_completed" TIMESTAMP (6)
);

CREATE TABLE "push_campaign_user"
(
   "id"                INTEGER      NOT NULL PRIMARY KEY,
   "campaign_id"       INTEGER      NOT NULL,
   "user_id"           INTEGER      NOT NULL,
   "timestamp_created" TIMESTAMP(6) NOT NULL
);

---
--- Indexes for better performance.
---

CREATE UNIQUE INDEX PUSH_APP_CRED_APP ON PUSH_APP_CREDENTIALS(APP_ID);

CREATE INDEX PUSH_DEVICE_APP_TOKEN ON PUSH_DEVICE_REGISTRATION(APP_ID, PUSH_TOKEN);
CREATE INDEX PUSH_DEVICE_USER_APP ON PUSH_DEVICE_REGISTRATION(USER_ID, APP_ID);
CREATE UNIQUE INDEX PUSH_DEVICE_ACTIVATION ON PUSH_DEVICE_REGISTRATION(ACTIVATION_ID);
CREATE UNIQUE INDEX PUSH_DEVICE_ACTIVATION_TOKEN ON PUSH_DEVICE_REGISTRATION(ACTIVATION_ID, PUSH_TOKEN);

CREATE INDEX PUSH_MESSAGE_STATUS ON PUSH_MESSAGE(STATUS);

CREATE INDEX PUSH_CAMPAIGN_SENT ON PUSH_CAMPAIGN(IS_SENT);

CREATE INDEX PUSH_CAMPAIGN_USER_CAMPAIGN ON PUSH_CAMPAIGN_USER(CAMPAIGN_ID, USER_ID);
CREATE INDEX PUSH_CAMPAIGN_USER_DETAIL ON PUSH_CAMPAIGN_USER(USER_ID);

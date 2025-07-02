CREATE USER powerauth WITH PASSWORD 'powerauth';

CREATE DATABASE powerauth OWNER powerauth;

\c powerauth powerauth

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::1::Lubos Racansky
-- Create a new sequence push_credentials_seq
CREATE SEQUENCE  IF NOT EXISTS push_credentials_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::2::Lubos Racansky
-- Create a new sequence sequence push_device_registration_seq
CREATE SEQUENCE  IF NOT EXISTS push_device_registration_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::3::Lubos Racansky
-- Create a new sequence sequence push_message_seq
CREATE SEQUENCE  IF NOT EXISTS push_message_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::4::Lubos Racansky
-- Create a new sequence sequence push_campaign_seq
CREATE SEQUENCE  IF NOT EXISTS push_campaign_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::5::Lubos Racansky
-- Create a new sequence sequence push_campaign_user_seq
CREATE SEQUENCE  IF NOT EXISTS push_campaign_user_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::6::Lubos Racansky
-- Create a new sequence sequence push_inbox_seq
CREATE SEQUENCE  IF NOT EXISTS push_inbox_seq START WITH 1 INCREMENT BY 1 CACHE 20;

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::7::Lubos Racansky
-- Create a new sequence push_app_credentials
CREATE TABLE push_app_credentials (id INTEGER NOT NULL, app_id VARCHAR(255) NOT NULL, ios_key_id VARCHAR(255), ios_private_key BYTEA, ios_team_id VARCHAR(255), ios_bundle VARCHAR(255), ios_environment VARCHAR(32), android_private_key BYTEA, android_project_id VARCHAR(255), CONSTRAINT push_app_credentials_pkey PRIMARY KEY (id));

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::8::Lubos Racansky
-- Create a new sequence push_device_registration
CREATE TABLE push_device_registration (id INTEGER NOT NULL, activation_id VARCHAR(37), user_id VARCHAR(255), app_id INTEGER NOT NULL, platform VARCHAR(255) NOT NULL, push_token VARCHAR(255) NOT NULL, timestamp_last_registered TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, is_active BOOLEAN, CONSTRAINT push_device_registration_pkey PRIMARY KEY (id));

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::9::Lubos Racansky
-- Create a new sequence push_message
CREATE TABLE push_message (id INTEGER NOT NULL, device_registration_id INTEGER NOT NULL, user_id VARCHAR(255) NOT NULL, activation_id VARCHAR(37), is_silent BOOLEAN DEFAULT FALSE NOT NULL, is_personal BOOLEAN DEFAULT FALSE NOT NULL, message_body VARCHAR(2048) NOT NULL, timestamp_created TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, status INTEGER NOT NULL, CONSTRAINT push_message_pkey PRIMARY KEY (id));

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::10::Lubos Racansky
-- Create a new sequence push_campaign
CREATE TABLE push_campaign (id INTEGER NOT NULL, app_id INTEGER NOT NULL, message VARCHAR(4000) NOT NULL, is_sent BOOLEAN DEFAULT FALSE NOT NULL, timestamp_created TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, timestamp_sent TIMESTAMP(6) WITHOUT TIME ZONE, timestamp_completed TIMESTAMP(6) WITHOUT TIME ZONE, CONSTRAINT push_campaign_pkey PRIMARY KEY (id));

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::11::Lubos Racansky
-- Create a new sequence push_campaign_user
CREATE TABLE push_campaign_user (id INTEGER NOT NULL, campaign_id INTEGER NOT NULL, user_id VARCHAR(255) NOT NULL, timestamp_created TIMESTAMP(6) WITHOUT TIME ZONE NOT NULL, CONSTRAINT push_campaign_user_pkey PRIMARY KEY (id));

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::12::Lubos Racansky
-- Create a new table push_inbox
CREATE TABLE push_inbox (id INTEGER NOT NULL, inbox_id VARCHAR(37) NOT NULL, user_id VARCHAR(255) NOT NULL, type VARCHAR(32) NOT NULL, subject TEXT NOT NULL, summary TEXT NOT NULL, body TEXT NOT NULL, read BOOLEAN DEFAULT FALSE NOT NULL, timestamp_created TIMESTAMP WITHOUT TIME ZONE NOT NULL, timestamp_read TIMESTAMP WITHOUT TIME ZONE, CONSTRAINT push_inbox_pkey PRIMARY KEY (id));

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::13::Lubos Racansky
-- Create a new sequence push_inbox_app
CREATE TABLE push_inbox_app (app_credentials_id INTEGER NOT NULL, inbox_id INTEGER NOT NULL, CONSTRAINT push_inbox_app_pkey PRIMARY KEY (app_credentials_id, inbox_id));

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::14::Lubos Racansky
-- Create a new unique index on push_app_credentials(app_id)
CREATE UNIQUE INDEX push_app_cred_app ON push_app_credentials(app_id);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::15::Lubos Racansky
-- Create a new index on push_device_registration(app_id, push_token)
CREATE INDEX push_device_app_token ON push_device_registration(app_id, push_token);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::16::Lubos Racansky
-- Create a new index on push_device_registration(user_id, app_id)
CREATE INDEX push_device_user_app ON push_device_registration(user_id, app_id);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::17::Lubos Racansky
-- Create a new unique index on push_device_registration(activation_id)
CREATE UNIQUE INDEX push_device_activation ON push_device_registration(activation_id);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::18::Lubos Racansky
-- Create a new unique index on push_device_registration(activation_id, push_token)
CREATE UNIQUE INDEX push_device_activation_token ON push_device_registration(activation_id, push_token);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::19::Lubos Racansky
-- Create a new index on push_message(status)
CREATE INDEX push_message_status ON push_message(status);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::20::Lubos Racansky
-- Create a new index on push_campaign(is_sent)
CREATE INDEX push_campaign_sent ON push_campaign(is_sent);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::21::Lubos Racansky
-- Create a new index on push_campaign_user(campaign_id, user_id)
CREATE INDEX push_campaign_user_campaign ON push_campaign_user(campaign_id, user_id);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::22::Lubos Racansky
-- Create a new index on push_campaign_user(user_id)
CREATE INDEX push_campaign_user_detail ON push_campaign_user(user_id);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::23::Lubos Racansky
-- Create a new index on push_inbox(inbox_id)
CREATE INDEX push_inbox_id ON push_inbox(inbox_id);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::24::Lubos Racansky
-- Create a new index on push_inbox(user_id)
CREATE INDEX push_inbox_user ON push_inbox(user_id);

-- Changeset powerauth-push-server/1.4.x/20230321-init-db.xml::25::Lubos Racansky
-- Create a new index on push_inbox(user_id, read)
CREATE INDEX push_inbox_user_read ON push_inbox(user_id, read);

-- Changeset powerauth-push-server/1.4.x/20230322-add-tag-1.4.0.xml::1::Lubos Racansky
-- Changeset powerauth-push-server/1.5.x/20230905-add-tag-1.5.0.xml::1::Lubos Racansky
-- Changeset powerauth-push-server/1.7.x/20240119-push_app_credentials-hms.xml::1::Lubos Racansky
-- Add hms_project_id, hms_client_id, and hms_client_secret columns to push_app_credentials
ALTER TABLE push_app_credentials ADD hms_project_id VARCHAR(255);

ALTER TABLE push_app_credentials ADD hms_client_id VARCHAR(255);

ALTER TABLE push_app_credentials ADD hms_client_secret VARCHAR(255);

COMMENT ON COLUMN push_app_credentials.hms_project_id IS 'Project ID defined in Huawei AppGallery Connect.';

COMMENT ON COLUMN push_app_credentials.hms_client_id IS 'Huawei OAuth 2.0 Client ID.';

COMMENT ON COLUMN push_app_credentials.hms_client_secret IS 'Huawei OAuth 2.0 Client Secret.';

-- Changeset powerauth-push-server/1.7.x/20240222-add-tag-1.7.0.xml::1::Lubos Racansky

-- Changeset powerauth-push-server/1.7.x/20240119-push_app_credentials-hms.xml::1::Lubos Racansky
-- Add hms_project_id, hms_client_id, and hms_client_secret columns to push_app_credentials
ALTER TABLE push_app_credentials ADD hms_project_id VARCHAR(255);

ALTER TABLE push_app_credentials ADD hms_client_id VARCHAR(255);

ALTER TABLE push_app_credentials ADD hms_client_secret VARCHAR(255);

COMMENT ON COLUMN push_app_credentials.hms_project_id IS 'Project ID defined in Huawei AppGallery Connect.';

COMMENT ON COLUMN push_app_credentials.hms_client_id IS 'Huawei OAuth 2.0 Client ID.';

COMMENT ON COLUMN push_app_credentials.hms_client_secret IS 'Huawei OAuth 2.0 Client Secret.';

-- Changeset powerauth-push-server/1.8.x/20240708-column-renaming-keywords.xml::1::Roman Strobl
-- Rename columns read to is_read and type to message_type in push_inbox table
ALTER TABLE push_inbox RENAME COLUMN read TO is_read;

ALTER TABLE push_inbox RENAME COLUMN type TO message_type;

-- Changeset powerauth-push-server/1.9.x/20241011-app-credentials-timestamp.xml::1::Lubos Racansky
-- Add columns timestamp_last_updated and timestamp_created to push_app_credentials table
ALTER TABLE push_app_credentials ADD timestamp_created TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW() NOT NULL;

ALTER TABLE push_app_credentials ADD timestamp_last_updated TIMESTAMP WITHOUT TIME ZONE;

-- Changeset powerauth-push-server/1.10.x/20241029-add-new-platforms.xml::1::Roman Strobl
-- Add columns apns_private_key, apns_team_id, apns_key_id, apns_bundle, and apns_environment to push_app_credentials table
ALTER TABLE push_app_credentials ADD apns_private_key BYTEA;

ALTER TABLE push_app_credentials ADD apns_team_id VARCHAR(255);

ALTER TABLE push_app_credentials ADD apns_key_id VARCHAR(255);

ALTER TABLE push_app_credentials ADD apns_bundle VARCHAR(255);

ALTER TABLE push_app_credentials ADD apns_environment VARCHAR(255);

-- Changeset powerauth-push-server/1.10.x/20241029-add-new-platforms.xml::2::Roman Strobl
-- Add columns fcm_private_key and fcm_project_id to push_app_credentials table
ALTER TABLE push_app_credentials ADD fcm_private_key BYTEA;

ALTER TABLE push_app_credentials ADD fcm_project_id VARCHAR(255);

-- Changeset powerauth-push-server/1.10.x/20241029-migrate-ios-to-apns.xml::3::Roman Strobl
-- Migrate existing ios_* columns to apns_* columns
UPDATE push_app_credentials SET apns_bundle = ios_bundle, apns_environment = ios_environment, apns_key_id = ios_key_id, apns_private_key = ios_private_key, apns_team_id = ios_team_id;

-- Changeset powerauth-push-server/1.10.x/20241029-migrate-android-to-fcm.xml::4::Roman Strobl
-- Migrate existing android_* columns to fcm_* columns
UPDATE push_app_credentials SET fcm_private_key = android_private_key, fcm_project_id = android_project_id;

-- Changeset powerauth-push-server/1.10.x/20241108-device-registration-environment.xml::1::Roman Strobl
-- Add columns environment to push_device_registration table
ALTER TABLE push_device_registration ADD environment VARCHAR(255);
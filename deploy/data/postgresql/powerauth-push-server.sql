CREATE DATABASE powerauth;

CREATE USER powerauth WITH PASSWORD 'powerauth';

GRANT ALL PRIVILEGES ON DATABASE powerauth TO powerauth;

\c powerauth

---
--- DB Sequences
---

CREATE SEQUENCE push_credentials_seq;
CREATE SEQUENCE push_device_registration_seq;
CREATE SEQUENCE push_message_seq;
CREATE SEQUENCE push_campaign_seq;
CREATE SEQUENCE push_campaign_user_seq;
CREATE SEQUENCE push_inbox_seq;

---
--- DB Tables
---

-- Create table for application credentials used for APNS and FCM
CREATE TABLE push_app_credentials (
	id INTEGER NOT NULL CONSTRAINT push_app_credentials_pkey PRIMARY KEY,
	app_id VARCHAR(255) NOT NULL,
	ios_key_id VARCHAR(255),
	ios_private_key BYTEA,
	ios_team_id VARCHAR(255),
	ios_bundle VARCHAR(255),
	ios_environment VARCHAR(32),
	android_private_key BYTEA,
	android_project_id VARCHAR(255)
);


-- Create table for registered devices
CREATE TABLE push_device_registration (
	id INTEGER NOT NULL CONSTRAINT push_device_registration_pkey PRIMARY KEY,
	activation_id VARCHAR(37),
	user_id VARCHAR(255),
	app_id INTEGER NOT NULL,
	platform VARCHAR(255) NOT NULL,
	push_token VARCHAR(255) NOT NULL,
	timestamp_last_registered TIMESTAMP(6) NOT NULL,
	is_active BOOLEAN
);


-- Create table for optional auditing of sent push messages
CREATE TABLE push_message (
	id INTEGER NOT NULL CONSTRAINT push_message_pkey PRIMARY KEY,
	device_registration_id INTEGER NOT NULL,
	user_id VARCHAR(255) NOT NULL,
	activation_id VARCHAR(37),
	is_silent BOOLEAN DEFAULT false NOT NULL,
	is_personal BOOLEAN DEFAULT false NOT NULL,
	message_body VARCHAR(2048) NOT NULL,
	timestamp_created TIMESTAMP(6) NOT NULL,
	status INTEGER NOT NULL
);


-- Create table for push message campaigns
CREATE TABLE push_campaign (
	id INTEGER NOT NULL CONSTRAINT push_campaign_pkey PRIMARY KEY,
	app_id INTEGER NOT NULL,
	message VARCHAR(4000) NOT NULL,
	is_sent BOOLEAN DEFAULT false NOT NULL,
	timestamp_created TIMESTAMP(6) NOT NULL,
	timestamp_sent TIMESTAMP(6),
	timestamp_completed TIMESTAMP(6)
);


-- Create table for push campaign user list
CREATE TABLE push_campaign_user (
	id INTEGER NOT NULL CONSTRAINT push_campaign_user_pkey PRIMARY KEY,
	campaign_id INTEGER NOT NULL,
	user_id VARCHAR(255) NOT NULL,
	timestamp_created TIMESTAMP(6) NOT NULL
);

-- Create table for message inbox
CREATE TABLE push_inbox (
    id INTEGER NOT NULL CONSTRAINT push_inbox_pk PRIMARY KEY,
    inbox_id VARCHAR(37) NOT NULL,
    user_id VARCHAR(255) NOT NULL,
    type VARCHAR(32) NOT NULL,
    subject TEXT NOT NULL,
    summary TEXT NOT NULL,
    body TEXT NOT NULL,
    read BOOLEAN DEFAULT false NOT NULL,
    timestamp_created TIMESTAMP NOT NULL,
    timestamp_read TIMESTAMP
);

-- Create table for assignment of inbox messages to apps
CREATE TABLE push_inbox_app (
    app_credentials_id INTEGER NOT NULL,
    inbox_id           INTEGER NOT NULL,
    CONSTRAINT push_inbox_app_pk PRIMARY KEY (inbox_id, app_credentials_id)
);

--
-- DB Indexes (recommended for better performance)
--

CREATE UNIQUE INDEX push_app_cred_app ON push_app_credentials (app_id);

CREATE INDEX push_device_app_token ON push_device_registration (app_id, push_token);

CREATE INDEX push_device_user_app ON push_device_registration (user_id, app_id);

CREATE UNIQUE INDEX push_device_activation ON push_device_registration (activation_id);

CREATE UNIQUE INDEX push_device_activation_token ON push_device_registration (activation_id, push_token);

CREATE INDEX push_message_status ON push_message (status);

CREATE INDEX push_campaign_sent ON push_campaign (is_sent);

CREATE INDEX push_campaign_user_campaign ON push_campaign_user (campaign_id, user_id);

CREATE INDEX push_campaign_user_detail ON push_campaign_user (user_id);

CREATE INDEX push_inbox_id ON push_inbox (inbox_id);
CREATE INDEX push_inbox_user ON push_inbox (user_id);
CREATE INDEX push_inbox_user_read ON push_inbox (user_id, read);

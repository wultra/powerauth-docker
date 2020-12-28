--
--  Drop all tables.
--
DROP TABLE IF EXISTS "push_app_credentials" CASCADE;
DROP TABLE IF EXISTS "push_device_registration" CASCADE;
DROP TABLE IF EXISTS "push_message" CASCADE;
DROP TABLE IF EXISTS "push_campaign" CASCADE;
DROP TABLE IF EXISTS "push_campaign_user" CASCADE;

--
--  Drop all sequences.
--
DROP SEQUENCE IF EXISTS "push_credentials_seq";
DROP SEQUENCE IF EXISTS "push_device_registration_seq";
DROP SEQUENCE IF EXISTS "push_message_seq";
DROP SEQUENCE IF EXISTS "push_campaign_seq";
DROP SEQUENCE IF EXISTS "push_campaign_user_seq";

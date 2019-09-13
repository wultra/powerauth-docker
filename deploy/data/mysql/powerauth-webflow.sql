CREATE DATABASE `powerauth`;

CREATE USER 'powerauth'@'%';

GRANT ALL PRIVILEGES ON powerauth.* TO 'powerauth'@'%';

FLUSH PRIVILEGES;

USE powerauth;

-- Table oauth_client_details stores details about OAuth2 client applications.
-- Every Web Flow client application should have a record in this table.
-- See: https://github.com/spring-projects/spring-security-oauth/blob/master/spring-security-oauth2/src/main/java/org/springframework/security/oauth2/provider/client/JdbcClientDetailsService.java
CREATE TABLE oauth_client_details (
  client_id               VARCHAR(256) PRIMARY KEY,
  resource_ids            VARCHAR(256),
  client_secret           VARCHAR(256),
  scope                   VARCHAR(256),
  authorized_grant_types  VARCHAR(256),
  web_server_redirect_uri VARCHAR(256),
  authorities             VARCHAR(256),
  access_token_validity   INTEGER,
  refresh_token_validity  INTEGER,
  additional_information  VARCHAR(4096),
  autoapprove             VARCHAR(256)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table oauth_client_token stores OAuth2 tokens for retrieval by client applications.
-- See: https://docs.spring.io/spring-security/oauth/apidocs/org/springframework/security/oauth2/client/token/JdbcClientTokenServices.html
CREATE TABLE oauth_client_token (
  token_id          VARCHAR(256),
  token             LONG VARBINARY,
  authentication_id VARCHAR(256) PRIMARY KEY,
  user_name         VARCHAR(256),
  client_id         VARCHAR(256)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table oauth_access_token stores OAuth2 access tokens.
-- See: https://github.com/spring-projects/spring-security-oauth/blob/master/spring-security-oauth2/src/main/java/org/springframework/security/oauth2/provider/token/store/JdbcTokenStore.java
CREATE TABLE oauth_access_token (
  token_id          VARCHAR(256),
  token             LONG VARBINARY,
  authentication_id VARCHAR(256) PRIMARY KEY,
  user_name         VARCHAR(256),
  client_id         VARCHAR(256),
  authentication    LONG VARBINARY,
  refresh_token     VARCHAR(256)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table oauth_access_token stores OAuth2 refresh tokens.
-- See: https://github.com/spring-projects/spring-security-oauth/blob/master/spring-security-oauth2/src/main/java/org/springframework/security/oauth2/provider/token/store/JdbcTokenStore.java
CREATE TABLE oauth_refresh_token (
  token_id       VARCHAR(256),
  token          LONG VARBINARY,
  authentication LONG VARBINARY
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table oauth_code stores data for the OAuth2 authorization code grant.
-- See: https://github.com/spring-projects/spring-security-oauth/blob/master/spring-security-oauth2/src/main/java/org/springframework/security/oauth2/provider/code/JdbcAuthorizationCodeServices.java
CREATE TABLE oauth_code (
  code           VARCHAR(255),
  authentication LONG VARBINARY
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table ns_auth_method stores configuration of authentication methods.
-- Data in this table needs to be loaded before Web Flow is started.
CREATE TABLE ns_auth_method (
  auth_method        VARCHAR(32) PRIMARY KEY NOT NULL,
  order_number       INTEGER NOT NULL,
  check_user_prefs   BOOLEAN NOT NULL,
  user_prefs_column  INTEGER,
  user_prefs_default BOOLEAN DEFAULT FALSE,
  check_auth_fails   BOOLEAN NOT NULL,
  max_auth_fails     INTEGER,
  has_user_interface BOOLEAN DEFAULT FALSE,
  has_mobile_token   BOOLEAN DEFAULT FALSE,
  display_name_key   VARCHAR(32)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table ns_user_prefs stores user preferences.
-- Status of authentication methods is stored in this table per user (methods can be enabled or disabled).
CREATE TABLE ns_user_prefs (
  user_id       VARCHAR(256) PRIMARY KEY NOT NULL,
  auth_method_1 BOOLEAN DEFAULT FALSE,
  auth_method_2 BOOLEAN DEFAULT FALSE,
  auth_method_3 BOOLEAN DEFAULT FALSE,
  auth_method_4 BOOLEAN DEFAULT FALSE,
  auth_method_5 BOOLEAN DEFAULT FALSE,
  auth_method_1_config VARCHAR(256),
  auth_method_2_config VARCHAR(256),
  auth_method_3_config VARCHAR(256),
  auth_method_4_config VARCHAR(256),
  auth_method_5_config VARCHAR(256)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table ns_operation_config stores configuration of operations.
-- Each operation type (defined by operation_name) has a related mobile token template and configuration.
CREATE TABLE ns_operation_config (
  operation_name            VARCHAR(32) PRIMARY KEY NOT NULL,
  template_version          CHAR NOT NULL,
  template_id               INTEGER NOT NULL,
  mobile_token_mode         VARCHAR(256) NOT NULL,
  afs_enabled               BOOLEAN NOT NULL DEFAULT FALSE
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table ns_organization stores definitions of organizations related to the operations.
-- At least one default organization must be configured.
-- Data in this table needs to be loaded before Web Flow is started.
CREATE TABLE ns_organization (
  organization_id          VARCHAR(256) PRIMARY KEY NOT NULL,
  display_name_key         VARCHAR(256),
  is_default               BOOLEAN NOT NULL,
  order_number             INTEGER NOT NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table ns_operation stores details of Web Flow operations.
-- Only the last status is stored in this table, changes of operations are stored in table ns_operation_history.
CREATE TABLE ns_operation (
  operation_id              VARCHAR(256) PRIMARY KEY NOT NULL,
  operation_name            VARCHAR(32) NOT NULL,
  operation_data            TEXT NOT NULL,
  operation_form_data       TEXT,
  application_id            VARCHAR(256),
  application_name          VARCHAR(256),
  application_description   VARCHAR(256),
  application_extras        TEXT,
  user_id                   VARCHAR(256),
  organization_id           VARCHAR(256),
  result                    VARCHAR(32),
  timestamp_created         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  timestamp_expires         TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY organization_fk (organization_id) REFERENCES ns_organization (organization_id)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table ns_operation_history stores all changes of operations.
CREATE TABLE ns_operation_history (
  operation_id                VARCHAR(256) NOT NULL,
  result_id                   INTEGER NOT NULL,
  request_auth_method         VARCHAR(32) NOT NULL,
  request_auth_step_result    VARCHAR(32) NOT NULL,
  request_params              VARCHAR(4096),
  response_result             VARCHAR(32) NOT NULL,
  response_result_description VARCHAR(256),
  response_steps              VARCHAR(4096),
  response_timestamp_created  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  response_timestamp_expires  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  chosen_auth_method          VARCHAR(32),
  PRIMARY KEY (operation_id, result_id),
  FOREIGN KEY operation_fk (operation_id) REFERENCES ns_operation (operation_id),
  FOREIGN KEY auth_method_fk (request_auth_method) REFERENCES ns_auth_method (auth_method)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table ns_step_definition stores definitions of authentication/authorization steps.
-- Data in this table needs to be loaded before Web Flow is started.
CREATE TABLE ns_step_definition (
  step_definition_id       INTEGER PRIMARY KEY NOT NULL,
  operation_name           VARCHAR(32) NOT NULL,
  operation_type           VARCHAR(32) NOT NULL,
  request_auth_method      VARCHAR(32),
  request_auth_step_result VARCHAR(32),
  response_priority        INTEGER NOT NULL,
  response_auth_method     VARCHAR(32),
  response_result          VARCHAR(32) NOT NULL,
  FOREIGN KEY request_auth_method_fk (request_auth_method) REFERENCES ns_auth_method (auth_method),
  FOREIGN KEY response_auth_method_fk (response_auth_method) REFERENCES ns_auth_method (auth_method)
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table wf_operation_session maps operations to HTTP sessions.
-- Table is needed for handling of concurrent operations.
CREATE TABLE wf_operation_session (
  operation_id              VARCHAR(256) PRIMARY KEY NOT NULL,
  http_session_id           VARCHAR(256) NOT NULL,
  result                    VARCHAR(32) NOT NULL,
  timestamp_created         TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Table da_sms_authorization stores data for SMS OTP authorization.
CREATE TABLE da_sms_authorization (
  message_id           VARCHAR(256) PRIMARY KEY NOT NULL,
  operation_id         VARCHAR(256) NOT NULL,
  user_id              VARCHAR(256) NOT NULL,
  organization_id      VARCHAR(256),
  operation_name       VARCHAR(32) NOT NULL,
  authorization_code   VARCHAR(32) NOT NULL,
  salt                 VARBINARY(16) NOT NULL,
  message_text         TEXT NOT NULL,
  verify_request_count INTEGER,
  verified             BOOLEAN DEFAULT FALSE,
  timestamp_created    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  timestamp_verified   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  timestamp_expires    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE tpp_consent (
	consent_id VARCHAR(64) PRIMARY KEY NOT NULL,
	consent_name VARCHAR(128) NOT NULL,
	consent_text TEXT NOT NULL,
	version INT NOT NULL
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE tpp_user_consent (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    user_id VARCHAR(256) NOT NULL,
    client_id VARCHAR(256) NOT NULL,
    consent_id VARCHAR(64) NOT NULL,
    external_id VARCHAR(256) NOT NULL,
    consent_parameters TEXT NOT NULL,
    timestamp_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    timestamp_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE tpp_user_consent_history (
    id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
    user_id VARCHAR(256) NOT NULL,
    client_id VARCHAR(256) NOT NULL,
    consent_id VARCHAR(64) NOT NULL,
    consent_change VARCHAR(16) NOT NULL,
    external_id VARCHAR(256) NOT NULL,
    consent_parameters TEXT NOT NULL,
    timestamp_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- default oauth 2.0 client
-- Note: bcrypt('changeme', 12) => '$2a$12$MkYsT5igDXSDgRwyDVz1B.93h8F81E4GZJd/spy/1vhjM4CJgeed.'
INSERT INTO oauth_client_details (client_id, client_secret, scope, authorized_grant_types, additional_information, autoapprove)
VALUES ('democlient', '$2a$12$MkYsT5igDXSDgRwyDVz1B.93h8F81E4GZJd/spy/1vhjM4CJgeed.', 'profile', 'authorization_code', '{}', 'true');

-- authentication methods
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('INIT', 1, FALSE, NULL, NULL, FALSE, NULL, FALSE, FALSE, NULL);
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('USER_ID_ASSIGN', 2, FALSE, NULL, NULL, FALSE, NULL, FALSE, FALSE, NULL);
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('USERNAME_PASSWORD_AUTH', 3, FALSE, NULL, NULL, TRUE, 5, TRUE, FALSE, 'method.usernamePassword');
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('SHOW_OPERATION_DETAIL', 4, FALSE, NULL, NULL, FALSE, NULL, TRUE, FALSE, 'method.showOperationDetail');
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('POWERAUTH_TOKEN', 5, TRUE, 1, FALSE, TRUE, 5, TRUE, TRUE, 'method.powerauthToken');
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('SMS_KEY', 6, FALSE, NULL, NULL, TRUE, 5, TRUE, FALSE, 'method.smsKey');
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('CONSENT', 7, FALSE, NULL, NULL, TRUE, 5, TRUE, FALSE, 'method.consent');
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('LOGIN_SCA', 8, FALSE, NULL, NULL, TRUE, 5, TRUE, TRUE, 'method.loginSca');
INSERT INTO ns_auth_method (auth_method, order_number, check_user_prefs, user_prefs_column, user_prefs_default, check_auth_fails, max_auth_fails, has_user_interface, has_mobile_token, display_name_key)
VALUES ('APPROVAL_SCA', 9, FALSE, NULL, NULL, TRUE, 5, TRUE, TRUE, 'method.approvalSca');

-- operation configuration
INSERT INTO ns_operation_config (operation_name, template_version, template_id, mobile_token_mode) VALUES ('login', 'A', 2, '{"type":"2FA","variants":["possession_knowledge","possession_biometry"]}');
INSERT INTO ns_operation_config (operation_name, template_version, template_id, mobile_token_mode) VALUES ('login_sca', 'A', 2, '{"type":"2FA","variants":["possession_knowledge","possession_biometry"]}');
INSERT INTO ns_operation_config (operation_name, template_version, template_id, mobile_token_mode) VALUES ('authorize_payment', 'A', 1, '{"type":"2FA","variants":["possession_knowledge","possession_biometry"]}');
INSERT INTO ns_operation_config (operation_name, template_version, template_id, mobile_token_mode) VALUES ('authorize_payment_sca', 'A', 1, '{"type":"2FA","variants":["possession_knowledge","possession_biometry"]}');

-- organization configuration
INSERT INTO ns_organization (organization_id, display_name_key, is_default, order_number) VALUES ('RETAIL', 'organization.retail', TRUE, 1);
INSERT INTO ns_organization (organization_id, display_name_key, is_default, order_number) VALUES ('SME', 'organization.sme', FALSE, 2);

-- login - init operation -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (1, 'login', 'CREATE', NULL, NULL, 1, 'USER_ID_ASSIGN', 'CONTINUE');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (2, 'login', 'CREATE', NULL, NULL, 2, 'USERNAME_PASSWORD_AUTH', 'CONTINUE');

-- login - update operation - CONFIRMED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (3, 'login', 'UPDATE', 'USER_ID_ASSIGN', 'CONFIRMED', 1, 'CONSENT', 'CONTINUE');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (4, 'login', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'CONFIRMED', 1, 'CONSENT', 'CONTINUE');

-- login - update operation - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (5, 'login', 'UPDATE', 'USER_ID_ASSIGN', 'CANCELED', 1, NULL, 'FAILED');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (6, 'login', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'CANCELED', 1, NULL, 'FAILED');

-- login - update operation - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (8, 'login', 'UPDATE', 'USER_ID_ASSIGN', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (9, 'login', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- login - update operation - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (11, 'login', 'UPDATE', 'USER_ID_ASSIGN', 'AUTH_FAILED', 1, 'USER_ID_ASSIGN', 'CONTINUE');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (12, 'login', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'AUTH_FAILED', 1, 'USERNAME_PASSWORD_AUTH', 'CONTINUE');

-- login - update operation (consent) - CONFIRMED -> DONE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (13, 'login', 'UPDATE', 'CONSENT', 'CONFIRMED', 1, NULL, 'DONE');

-- login - update operation (consent) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (14, 'login', 'UPDATE', 'CONSENT', 'CANCELED', 1, NULL, 'FAILED');

-- login - update operation (consent) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (15, 'login', 'UPDATE', 'CONSENT', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- login - update operation (consent) - AUTH_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (16, 'login', 'UPDATE', 'CONSENT', 'AUTH_FAILED', 1, 'CONSENT', 'CONTINUE');

-- authorize_payment - init operation -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (17, 'authorize_payment', 'CREATE', NULL, NULL, 1, 'USER_ID_ASSIGN', 'CONTINUE');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (18, 'authorize_payment', 'CREATE', NULL, NULL, 2, 'USERNAME_PASSWORD_AUTH', 'CONTINUE');

-- authorize_payment - update operation (login) - CONFIRMED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (19, 'authorize_payment', 'UPDATE', 'USER_ID_ASSIGN', 'CONFIRMED', 1, 'POWERAUTH_TOKEN', 'CONTINUE');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (20, 'authorize_payment', 'UPDATE', 'USER_ID_ASSIGN', 'CONFIRMED', 2, 'SMS_KEY', 'CONTINUE');

INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (21, 'authorize_payment', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'CONFIRMED', 1, 'POWERAUTH_TOKEN', 'CONTINUE');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (22, 'authorize_payment', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'CONFIRMED', 2, 'SMS_KEY', 'CONTINUE');

-- authorize_payment - update operation (login) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (23, 'authorize_payment', 'UPDATE', 'USER_ID_ASSIGN', 'CANCELED', 1, NULL, 'FAILED');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (24, 'authorize_payment', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'CANCELED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (login) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (25, 'authorize_payment', 'UPDATE', 'USER_ID_ASSIGN', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (26, 'authorize_payment', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (login) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (27, 'authorize_payment', 'UPDATE', 'USER_ID_ASSIGN', 'AUTH_FAILED', 1, 'USER_ID_ASSIGN', 'CONTINUE');
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (28, 'authorize_payment', 'UPDATE', 'USERNAME_PASSWORD_AUTH', 'AUTH_FAILED', 1, 'USERNAME_PASSWORD_AUTH', 'CONTINUE');

-- authorize_payment - update operation (authorize using mobile token) - CONFIRMED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (29, 'authorize_payment', 'UPDATE', 'POWERAUTH_TOKEN', 'CONFIRMED', 1, 'CONSENT', 'CONTINUE');

-- authorize_payment - update operation (authorize using mobile token) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (30, 'authorize_payment', 'UPDATE', 'POWERAUTH_TOKEN', 'CANCELED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (authorize using mobile token) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (31, 'authorize_payment', 'UPDATE', 'POWERAUTH_TOKEN', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (authorize using mobile token) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (32, 'authorize_payment', 'UPDATE', 'POWERAUTH_TOKEN', 'AUTH_FAILED', 1, 'POWERAUTH_TOKEN', 'CONTINUE');

-- authorize_payment - update operation (authorize using sms key) - CONFIRMED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (33, 'authorize_payment', 'UPDATE', 'SMS_KEY', 'CONFIRMED', 1, 'CONSENT', 'CONTINUE');

-- authorize_payment - update operation (authorize using sms key) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (34, 'authorize_payment', 'UPDATE', 'SMS_KEY', 'CANCELED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (authorize using sms key) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (35, 'authorize_payment', 'UPDATE', 'SMS_KEY', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (authorize using sms key) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (36, 'authorize_payment', 'UPDATE', 'SMS_KEY', 'AUTH_FAILED', 1, 'SMS_KEY', 'CONTINUE');

-- authorize_payment - update operation (consent) - CONFIRMED -> DONE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (37, 'authorize_payment', 'UPDATE', 'CONSENT', 'CONFIRMED', 1, NULL, 'DONE');

-- authorize_payment - update operation (consent) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (38, 'authorize_payment', 'UPDATE', 'CONSENT', 'CANCELED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (consent) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (39, 'authorize_payment', 'UPDATE', 'CONSENT', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- authorize_payment - update operation (consent) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (40, 'authorize_payment', 'UPDATE', 'CONSENT', 'AUTH_FAILED', 1, 'CONSENT', 'CONTINUE');

-- login_sca - init operation -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (41, 'login_sca', 'CREATE', NULL, NULL, 1, 'LOGIN_SCA', 'CONTINUE');

-- login_sca - update operation (login) - CONFIRMED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (42, 'login_sca', 'UPDATE', 'LOGIN_SCA', 'CONFIRMED', 1, 'CONSENT', 'CONTINUE');

-- login_sca - update operation (login) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (43, 'login_sca', 'UPDATE', 'LOGIN_SCA', 'CANCELED', 1, NULL, 'FAILED');

-- login_sca - update operation (login) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (44, 'login_sca', 'UPDATE', 'LOGIN_SCA', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- login_sca - update operation (login) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (45, 'login_sca', 'UPDATE', 'LOGIN_SCA', 'AUTH_FAILED', 1, 'LOGIN_SCA', 'CONTINUE');

-- login_sca - update operation (consent) - CONFIRMED -> DONE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (46, 'login_sca', 'UPDATE', 'CONSENT', 'CONFIRMED', 1, NULL, 'DONE');

-- login_sca - update operation (consent) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (47, 'login_sca', 'UPDATE', 'CONSENT', 'CANCELED', 1, NULL, 'FAILED');

-- login_sca - update operation (consent) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (48, 'login_sca', 'UPDATE', 'CONSENT', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- login_sca - update operation (consent) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (49, 'login_sca', 'UPDATE', 'CONSENT', 'AUTH_FAILED', 1, 'LOGIN_SCA', 'CONTINUE');

-- authorize_payment_sca - init operation -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (50, 'authorize_payment_sca', 'CREATE', NULL, NULL, 1, 'LOGIN_SCA', 'CONTINUE');

-- authorize_payment_sca - update operation (login) - CONFIRMED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (51, 'authorize_payment_sca', 'UPDATE', 'LOGIN_SCA', 'CONFIRMED', 1, 'APPROVAL_SCA', 'CONTINUE');

-- authorize_payment_sca - update operation (login) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (52, 'authorize_payment_sca', 'UPDATE', 'LOGIN_SCA', 'CANCELED', 1, NULL, 'FAILED');

-- authorize_payment_sca - update operation (login) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (53, 'authorize_payment_sca', 'UPDATE', 'LOGIN_SCA', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- authorize_payment_sca - update operation (login) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (54, 'authorize_payment_sca', 'UPDATE', 'LOGIN_SCA', 'AUTH_FAILED', 1, 'LOGIN_SCA', 'CONTINUE');

-- authorize_payment_sca - update operation (approval) - CONFIRMED -> DONE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (55, 'authorize_payment_sca', 'UPDATE', 'APPROVAL_SCA', 'CONFIRMED', 1, 'CONSENT', 'CONTINUE');

-- authorize_payment_sca - update operation (approval) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (56, 'authorize_payment_sca', 'UPDATE', 'APPROVAL_SCA', 'CANCELED', 1, NULL, 'FAILED');

-- authorize_payment_sca - update operation (approval) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (57, 'authorize_payment_sca', 'UPDATE', 'APPROVAL_SCA', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- authorize_payment_sca - update operation (approval) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (58, 'authorize_payment_sca', 'UPDATE', 'APPROVAL_SCA', 'AUTH_FAILED', 1, 'APPROVAL_SCA', 'CONTINUE');

-- authorize_payment_sca - update operation (consent) - CONFIRMED -> DONE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (59, 'authorize_payment_sca', 'UPDATE', 'CONSENT', 'CONFIRMED', 1, NULL, 'DONE');

-- authorize_payment_sca - update operation (consent) - CANCELED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (60, 'authorize_payment_sca', 'UPDATE', 'CONSENT', 'CANCELED', 1, NULL, 'FAILED');

-- authorize_payment_sca - update operation (consent) - AUTH_METHOD_FAILED -> FAILED
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (61, 'authorize_payment_sca', 'UPDATE', 'CONSENT', 'AUTH_METHOD_FAILED', 1, NULL, 'FAILED');

-- authorize_payment_sca - update operation (consent) - AUTH_FAILED -> CONTINUE
INSERT INTO ns_step_definition (step_definition_id, operation_name, operation_type, request_auth_method, request_auth_step_result, response_priority, response_auth_method, response_result)
VALUES (62, 'authorize_payment_sca', 'UPDATE', 'CONSENT', 'AUTH_FAILED', 1, 'APPROVAL_SCA', 'CONTINUE');

-- default consents for PSD2
-- "aisp" consent
INSERT INTO tpp_consent (consent_id, consent_name, consent_text, version)
VALUES ('aisp', 'Access Information Service Provider', '<p>I give a consent to <strong>{{TPP_NAME}}</strong> that allows access to my payment accounts via <strong>{{APP_NAME}}</strong></p>', 1);

-- "pisp" consent
INSERT INTO tpp_consent (consent_id, consent_name, consent_text, version)
VALUES ('pisp', 'Payment Initiation Service Provider', '<p>I give a consent to <strong>{{TPP_NAME}}</strong> that allows payment initiation from my payment accounts via <strong>{{APP_NAME}}</strong></p>', 1);

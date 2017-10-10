CREATE DATABASE `powerauth`;

CREATE USER 'powerauth'@'%';

GRANT ALL PRIVILEGES ON powerauth.* TO 'powerauth'@'%';

FLUSH PRIVILEGES;

USE powerauth;

CREATE TABLE UserConnection (
	userId varchar(255) not null,
	providerId varchar(255) not null,
	providerUserId varchar(255) not null,
	rank int not null,
	displayName varchar(255) null,
	profileUrl varchar(512) null,
	imageUrl varchar(512) null,
	accessToken varchar(1024) not null,
	secret varchar(255) null,
	refreshToken varchar(255) null,
	expireTime bigint null,
	primary key (userId, providerId, providerUserId),
	constraint UserConnectionRank unique (userId, providerId, rank)
);

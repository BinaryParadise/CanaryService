/*
 Navicat Premium Data Transfer

 Source Server         : canary
 Source Server Type    : SQLite
 Source Server Version : 3030001
 Source Schema         : main

 Target Server Type    : SQLite
 Target Server Version : 3030001
 File Encoding         : 65001

 Date: 20/07/2021 14:10:58
*/

PRAGMA foreign_keys = false;

-- ----------------------------
-- Table structure for APISnapshot
-- ----------------------------
DROP TABLE IF EXISTS "APISnapshot";
CREATE TABLE "APISnapshot" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "identify" TEXT NOT NULL,
  "data" blob,
  CONSTRAINT "uk_Identify" UNIQUE ("identify") ON CONFLICT IGNORE
);

-- ----------------------------
-- Table structure for MockData
-- ----------------------------
DROP TABLE IF EXISTS "MockData";
CREATE TABLE "MockData" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "method" TEXT NOT NULL,
  "path" text NOT NULL,
  "updatetime" integer NOT NULL ON CONFLICT REPLACE DEFAULT (STRFTIME('%s', 'now')*1000 + SUBSTR(STRFTIME('%f', 'now'), 4)),
  "groupid" INTEGER NOT NULL,
  "sceneid" integer,
  "enabled" bit NOT NULL ON CONFLICT REPLACE DEFAULT 0,
  CONSTRAINT "uk_mockdata_path" UNIQUE ("path" ASC, "groupid" ASC) ON CONFLICT FAIL,
  CONSTRAINT "uk_mockdata_name" UNIQUE ("name", "groupid")
);

-- ----------------------------
-- Table structure for MockGroup
-- ----------------------------
DROP TABLE IF EXISTS "MockGroup";
CREATE TABLE "MockGroup" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "appid" INTEGER NOT NULL,
  "uid" INTEGER NOT NULL,
  CONSTRAINT "name_pid" UNIQUE ("name" ASC, "appid" ASC)
);

-- ----------------------------
-- Table structure for MockParam
-- ----------------------------
DROP TABLE IF EXISTS "MockParam";
CREATE TABLE "MockParam" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "value" TEXT,
  "comment" TEXT,
  "appid" INTEGER,
  "sceneid" INTEGER,
  "updatetime" integer NOT NULL ON CONFLICT REPLACE DEFAULT (STRFTIME('%s', 'now')*1000 + SUBSTR(STRFTIME('%f', 'now'), 4))
);

-- ----------------------------
-- Table structure for MockScene
-- ----------------------------
DROP TABLE IF EXISTS "MockScene";
CREATE TABLE "MockScene" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" TEXT NOT NULL,
  "response" blob,
  "mockid" INTEGER NOT NULL,
  "updatetime" integer NOT NULL ON CONFLICT REPLACE DEFAULT (STRFTIME('%s', 'now')*1000 + SUBSTR(STRFTIME('%f', 'now'), 4))
);

-- ----------------------------
-- Table structure for Project
-- ----------------------------
DROP TABLE IF EXISTS "Project";
CREATE TABLE "Project" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" text NOT NULL,
  "identify" TEXT NOT NULL,
  "enable" bit NOT NULL DEFAULT 1,
  "orderno" integer NOT NULL DEFAULT 1,
  "uid" INTEGER NOT NULL DEFAULT 1,
  "shared" bit NOT NULL DEFAULT 1,
  "updateTime" integer NOT NULL ON CONFLICT REPLACE DEFAULT (STRFTIME('%s', 'now')*1000 + SUBSTR(STRFTIME('%f', 'now'), 4)),
  CONSTRAINT "UK_Identify" UNIQUE ("identify" ASC) ON CONFLICT FAIL,
  CONSTRAINT "UK_Name" UNIQUE ("name" ASC) ON CONFLICT FAIL
);

-- ----------------------------
-- Table structure for RemoteConfig
-- ----------------------------
DROP TABLE IF EXISTS "RemoteConfig";
CREATE TABLE "RemoteConfig" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" varchar(50) NOT NULL,
  "comment" varchar(50) DEFAULT NULL,
  "updateTime" integer NOT NULL ON CONFLICT REPLACE DEFAULT (STRFTIME('%s', 'now')*1000 + SUBSTR(STRFTIME('%f', 'now'), 4)),
  "appId" int(11) NOT NULL,
  "uid" int NOT NULL,
  "defaultTag" bit DEFAULT 0,
  "type" int(11) DEFAULT 0,
  CONSTRAINT "UK_Name_PID" UNIQUE ("appId" ASC, "name" ASC) ON CONFLICT FAIL
);

-- ----------------------------
-- Table structure for RemoteConfigParam
-- ----------------------------
DROP TABLE IF EXISTS "RemoteConfigParam";
CREATE TABLE "RemoteConfigParam" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,
  "name" varchar(50) NOT NULL,
  "value" varchar(200) DEFAULT NULL,
  "envid" int(11) NOT NULL,
  "updateTime" integer NOT NULL ON CONFLICT REPLACE DEFAULT (STRFTIME('%s', 'now')*1000 + SUBSTR(STRFTIME('%f', 'now'), 4)),
  "comment" varchar(50) DEFAULT NULL,
  "uid" int NOT NULL DEFAULT NULL,
  "type" int(11) NOT NULL DEFAULT 0,
  "platform" int(11) DEFAULT 0
);

-- ----------------------------
-- Table structure for User
-- ----------------------------
DROP TABLE IF EXISTS "User";
CREATE TABLE "User" (
  "id" INTEGER NOT NULL,
  "username" TEXT NOT NULL,
  "password" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "roleid" INTEGER NOT NULL DEFAULT 2,
  "deleteTag" bit NOT NULL DEFAULT 0,
  "appid" INTEGER,
  PRIMARY KEY ("id"),
  CONSTRAINT "UK_Username" UNIQUE ("username" ASC) ON CONFLICT FAIL,
  CONSTRAINT "UK_Name" UNIQUE ("name" ASC) ON CONFLICT FAIL
);

-- ----------------------------
-- Records of User
-- ----------------------------
BEGIN;
INSERT INTO "User" VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', '野荷君', 1, 0, 1);
COMMIT;

-- ----------------------------
-- Table structure for UserRole
-- ----------------------------
DROP TABLE IF EXISTS "UserRole";
CREATE TABLE "UserRole" (
  "id" INTEGER NOT NULL,
  "name" TEXT NOT NULL,
  "level" int NOT NULL DEFAULT 0,
  PRIMARY KEY ("id")
);

-- ----------------------------
-- Table structure for UserSession
-- ----------------------------
DROP TABLE IF EXISTS "UserSession";
CREATE TABLE "UserSession" (
  "id" INTEGER NOT NULL ON CONFLICT REPLACE PRIMARY KEY AUTOINCREMENT,
  "token" TEXT NOT NULL,
  "expire" integer NOT NULL,
  "uid" INTEGER NOT NULL,
  "platform" TEXT NOT NULL,
  CONSTRAINT "uk_platform_uid" UNIQUE ("uid" ASC, "platform" ASC) ON CONFLICT REPLACE
);

-- ----------------------------
-- Table structure for sqlite_sequence
-- ----------------------------
DROP TABLE IF EXISTS "sqlite_sequence";
CREATE TABLE sqlite_sequence(name,seq);

-- ----------------------------
-- Auto increment value for APISnapshot
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 12 WHERE name = 'APISnapshot';

-- ----------------------------
-- Auto increment value for MockData
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 7 WHERE name = 'MockData';

-- ----------------------------
-- Auto increment value for MockGroup
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 8 WHERE name = 'MockGroup';

-- ----------------------------
-- Auto increment value for MockParam
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 11 WHERE name = 'MockParam';

-- ----------------------------
-- Auto increment value for MockScene
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 18 WHERE name = 'MockScene';

-- ----------------------------
-- Triggers structure for table MockScene
-- ----------------------------
CREATE TRIGGER "main"."reset_on_delete"
AFTER DELETE
ON "MockScene"
BEGIN
UPDATE MockData SET sceneid=null WHERE sceneid=old.id;
END;

-- ----------------------------
-- Auto increment value for Project
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 4 WHERE name = 'Project';

-- ----------------------------
-- Auto increment value for RemoteConfig
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 17 WHERE name = 'RemoteConfig';

-- ----------------------------
-- Auto increment value for RemoteConfigParam
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 14 WHERE name = 'RemoteConfigParam';

-- ----------------------------
-- Auto increment value for UserSession
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 109 WHERE name = 'UserSession';

PRAGMA foreign_keys = true;

/*
 Navicat Premium Data Transfer

 Source Server         : canary
 Source Server Type    : SQLite
 Source Server Version : 3030001
 Source Schema         : main

 Target Server Type    : SQLite
 Target Server Version : 3030001
 File Encoding         : 65001

 Date: 17/06/2021 11:59:06
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
-- Records of APISnapshot
-- ----------------------------
BEGIN;
INSERT INTO "APISnapshot" VALUES (5, 'd81db75d5f7840d99a529133c4c12cac', '{"flag":2,"method":"GET","identify":"d81db75d5f7840d99a529133c4c12cac","responsefields":{"Connection":"close","scene_id":"5","Vary":"Accept-Encoding","Content-Length":"75","scene_name":"%E9%BB%98%E8%AE%A4","Date":"Wed, 03 Mar 2021 10:31:43 GMT","X-Powered-By":"Express","Content-Type":"application/json;charset=utf-8"},"requestfields":{},"type":2,"url":"https://quan.suning.com/getSysTime.do&scene_id=5&scene_name=默认","key":"key-1","statusCode":200,"timestamp":1.614767503595818E12}');
INSERT INTO "APISnapshot" VALUES (6, '0207c4eefb134a82a65cb8dc05249694', '{"flag":2,"method":"GET","identify":"0207c4eefb134a82a65cb8dc05249694","responsefields":{"scene_id":"5","Connection":"close","Vary":"Accept-Encoding","Content-Length":"75","Date":"Thu, 04 Mar 2021 02:23:52 GMT","scene_name":"%E9%BB%98%E8%AE%A4","Content-Type":"application/json;charset=utf-8","X-Powered-By":"Express"},"requestfields":{},"type":2,"url":"https://quan.suning.com/getSysTime.do&scene_id=5&scene_name=默认","key":"key-1","statusCode":200,"timestamp":1.614824632153477E12}');
INSERT INTO "APISnapshot" VALUES (7, 'b2679722d43f47f89abc00243b47a06d', '{"flag":2,"method":"GET","identify":"b2679722d43f47f89abc00243b47a06d","responsefields":{"Connection":"close","scene_id":"5","Vary":"Accept-Encoding","Content-Length":"75","scene_name":"%E9%BB%98%E8%AE%A4","Date":"Thu, 04 Mar 2021 02:24:21 GMT","X-Powered-By":"Express","Content-Type":"application/json;charset=utf-8"},"requestfields":{},"type":2,"url":"https://quan.suning.com/getSysTime.do&scene_id=5&scene_name=默认","key":"key-1","statusCode":200,"timestamp":1.6148246617514219E12}');
INSERT INTO "APISnapshot" VALUES (8, 'c746f4754c334215b252a495f4ecd19a', '{"flag":2,"method":"GET","identify":"c746f4754c334215b252a495f4ecd19a","responsefields":{"Connection":"close","scene_id":"5","Vary":"Accept-Encoding","Content-Length":"75","scene_name":"%E9%BB%98%E8%AE%A4","Date":"Thu, 04 Mar 2021 02:36:58 GMT","Content-Type":"application/json;charset=utf-8","X-Powered-By":"Express"},"requestfields":{},"type":2,"url":"https://quan.suning.com/getSysTime.do&scene_id=5&scene_name=默认","key":"key-1","statusCode":200,"timestamp":1.614825418741518E12}');
INSERT INTO "APISnapshot" VALUES (9, 'c72221a094004e01859e7fb6f2739aa5', '{"flag":2,"method":"GET","identify":"c72221a094004e01859e7fb6f2739aa5","responsefields":{"Connection":"close","scene_id":"5","Vary":"Accept-Encoding","Content-Length":"75","scene_name":"%E9%BB%98%E8%AE%A4","Date":"Thu, 04 Mar 2021 02:51:13 GMT","X-Powered-By":"Express","Content-Type":"application/json;charset=utf-8"},"requestfields":{"User-Agent":"CanaryDemo/1.0 (iPhone; iOS 14.4; Scale/2.00)","Accept-Language":"en;q=1"},"responsebody":{"sysTime1":"22222222222222","sysTime2":"2674-03-12 23:30:22"},"type":2,"url":"https://quan.suning.com/getSysTime.do&scene_id=5&scene_name=默认","key":"key-2","statusCode":200,"timestamp":1.614826273814414E12}');
INSERT INTO "APISnapshot" VALUES (11, '3b788edd1fe04950a7275f8569bfb48a', '{"flag":2,"method":"GET","identify":"3b788edd1fe04950a7275f8569bfb48a","responsefields":{"Connection":"close","scene_id":"5","Vary":"Accept-Encoding","Content-Length":"75","scene_name":"%E9%BB%98%E8%AE%A4","Date":"Thu, 04 Mar 2021 02:52:45 GMT","X-Powered-By":"Express","Content-Type":"application/json;charset=utf-8"},"requestfields":{},"type":2,"url":"https://quan.suning.com/getSysTime.do&scene_id=5&scene_name=默认","key":"key-1","statusCode":200,"timestamp":1.614826365885322E12}');
INSERT INTO "APISnapshot" VALUES (12, '6f74fc0a6abd404d9f2c763e9e2d6b1e', '{"flag":2,"method":"GET","identify":"6f74fc0a6abd404d9f2c763e9e2d6b1e","responsefields":{"Connection":"close","scene_id":"5","Vary":"Accept-Encoding","Content-Length":"75","scene_name":"%E9%BB%98%E8%AE%A4","Date":"Thu, 04 Mar 2021 03:04:39 GMT","Content-Type":"application/json;charset=utf-8","X-Powered-By":"Express"},"requestfields":{"User-Agent":"CanaryDemo/1.0 (iPhone; iOS 14.4; Scale/2.00)","Accept-Language":"en;q=1"},"responsebody":{"sysTime1":"22222222222222","sysTime2":"2674-03-12 23:30:22"},"type":2,"url":"https://quan.suning.com/getSysTime.do&scene_id=5&scene_name=默认","key":"key-2","statusCode":200,"timestamp":1.614827079165861E12}');
COMMIT;

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
  "template" blob,
  "sceneid" integer,
  "enabled" integer NOT NULL ON CONFLICT REPLACE DEFAULT 0
);

-- ----------------------------
-- Records of MockData
-- ----------------------------
BEGIN;
INSERT INTO "MockData" VALUES (1, '苏宁时间同步', 'GET', '/getSysTime.do', 1610613579122, 5, NULL, NULL, 1);
INSERT INTO "MockData" VALUES (2, '淘宝时间同步', 'GET', '/rest/api3.do', 1610528864397, 5, NULL, 4, 1);
INSERT INTO "MockData" VALUES (3, '社区接口', 'GET', '/shequ/home', 1610437355265, 8, NULL, NULL, 0);
INSERT INTO "MockData" VALUES (6, '测试', 'GET', '/community/home', 1614762256505, 8, NULL, NULL, 1);
COMMIT;

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
-- Records of MockGroup
-- ----------------------------
BEGIN;
INSERT INTO "MockGroup" VALUES (5, '通用', 1, 1);
INSERT INTO "MockGroup" VALUES (8, '四字成语', 1, 1);
COMMIT;

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
-- Records of MockParam
-- ----------------------------
BEGIN;
INSERT INTO "MockParam" VALUES (6, 'api', 'mtop.common.getTimestamp', '接口名称', NULL, 4, 1608532305718);
COMMIT;

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
-- Records of MockScene
-- ----------------------------
BEGIN;
INSERT INTO "MockScene" VALUES (4, '参数匹配', '{
    "api": "mtop.common.getTimestamp",
    "v": "*",
    "ret": [
        "SUCCESS::接口调用成功，接口被Mock了"
    ],
    "data": {
        "t": "8888888888888"
    }
}', 2, 1610444958306);
INSERT INTO "MockScene" VALUES (5, '默认', '{
    "sysTime2": "2674-03-12 23:30:22",
    "sysTime1": "22222222222222"
}', 1, 1610444890523);
INSERT INTO "MockScene" VALUES (6, '默认', '{
    "api": "mtop.common.getTimestamp",
    "v": "*",
    "ret": [
        "SUCCESS::接口调用成功"
    ],
    "data": {
        "t": "1188888888888"
    }
}', 2, 1610358675558);
INSERT INTO "MockScene" VALUES (13, 'taet', '{}', 4, 1614668680535);
INSERT INTO "MockScene" VALUES (15, '阿哥干辣椒', '{}', 6, 1614760535790);
COMMIT;

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
-- Records of Project
-- ----------------------------
BEGIN;
INSERT INTO "Project" VALUES (1, '奶味蓝乐园', '82e439d7968b7c366e24a41d7f53f47d', 1, 1, 1, 1, 1610359741605);
INSERT INTO "Project" VALUES (2, '这个不辣', '6059996fa9e1a39ecbbb7d6224275fbd', 1, 1, 1, 1, 1610359735724);
COMMIT;

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
  "defaultTag" bit(1) DEFAULT 0,
  "type" int(11) DEFAULT 0,
  CONSTRAINT "UK_Name_PID" UNIQUE ("appId" ASC, "name" ASC) ON CONFLICT FAIL
);

-- ----------------------------
-- Records of RemoteConfig
-- ----------------------------
BEGIN;
INSERT INTO "RemoteConfig" VALUES (12, 'Test1', '测试环境', 1610359539414, 1, 1, 1, 0);
INSERT INTO "RemoteConfig" VALUES (13, 'Rake', 'ffegaesg', 1584176210749, 1, 1, 0, 1);
INSERT INTO "RemoteConfig" VALUES (14, 'ageg', '这个描述会比较多的，能显示的下吗？', 1610359536358, 1, 1, 0, 0);
INSERT INTO "RemoteConfig" VALUES (17, 'Test2', 'OSS文件上传', 1608633790897, 2, 1, 1, 1);
COMMIT;

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
-- Records of RemoteConfigParam
-- ----------------------------
BEGIN;
INSERT INTO "RemoteConfigParam" VALUES (3, 'fefaef', 'aegasegeg', 2, 1582368503378, 'aesgaseg', 2, 0, 1);
INSERT INTO "RemoteConfigParam" VALUES (4, 'afeageage', 'aegasgasega', 2, 1582368510723, 'aegseg', 2, 0, 0);
INSERT INTO "RemoteConfigParam" VALUES (5, 'fefaef', 'aegasegeg', 9, 1582370611559, 'aesgaseg', 2, 0, 1);
INSERT INTO "RemoteConfigParam" VALUES (6, 'afeageage', 'aegasgasega', 9, 1582370611559, 'aegseg', 2, 0, 0);
INSERT INTO "RemoteConfigParam" VALUES (7, 'title', '奶味蓝的乐园', 6, 1582468162890, '远程配置的标题', 2, 0, 0);
INSERT INTO "RemoteConfigParam" VALUES (8, 'text', 'holiday_promo_enabled', 6, 1582468195345, '参数1', 2, 0, 0);
INSERT INTO "RemoteConfigParam" VALUES (9, 'cmt', '这个参数的描述比较长', 6, 1582518681084, '定价方案 刚开始可以免费使用， 然后可以切换到“随用随付”的付费模式。Spark 方案 Generous limits to get started 免费', 2, 0, 0);
INSERT INTO "RemoteConfigParam" VALUES (10, 'A', 'aaaaaa2', 12, 1584797836098, 'aaaaa', 1, 0, 0);
INSERT INTO "RemoteConfigParam" VALUES (11, 'aaaa', 'feafe1', 12, 1584797832663, 'agaeg', 1, 0, 1);
INSERT INTO "RemoteConfigParam" VALUES (12, 'A', 'aaaaaa', 13, 1584176210750, 'aaaaa', 1, 0, 0);
INSERT INTO "RemoteConfigParam" VALUES (13, 'aaaa', 'feafe', 13, 1584176210750, 'agaeg', 1, 0, 1);
INSERT INTO "RemoteConfigParam" VALUES (14, 'afeaf', '333eagesgaseg', 12, 1610359545571, 'asegaseg', 1, 0, 0);
COMMIT;

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
INSERT INTO "User" VALUES (1, 'admin', '21232f297a57a5a743894a0e4a801fc3', '这个不辣', 1, 0, 1);
INSERT INTO "User" VALUES (2, 'dev', 'e77989ed21758e78331b20e477fc5582', '程序媛', 1, 0, 2);
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
-- Records of UserRole
-- ----------------------------
BEGIN;
INSERT INTO "UserRole" VALUES (1, '系统管理员', 0);
INSERT INTO "UserRole" VALUES (2, '开发人员', 1);
INSERT INTO "UserRole" VALUES (3, '测试人员', 2);
COMMIT;

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
-- Records of UserSession
-- ----------------------------
BEGIN;
INSERT INTO "UserSession" VALUES (52, 'c18ffb07100a612af9e7f42308df2b11', 1612940200062, 2, 'Computer');
INSERT INTO "UserSession" VALUES (59, '5e8a6f5652f79bb72aaa7ca5dd3fa324', 1617183365709, 1, 'Mobile');
INSERT INTO "UserSession" VALUES (60, '2ac37f74e4c44bd1ccb8cb3ab77d0784', 1617852002647, 1, 'Computer');
COMMIT;

-- ----------------------------
-- Table structure for sqlite_sequence
-- ----------------------------
DROP TABLE IF EXISTS "sqlite_sequence";
CREATE TABLE sqlite_sequence(name,seq);

-- ----------------------------
-- Records of sqlite_sequence
-- ----------------------------
BEGIN;
INSERT INTO "sqlite_sequence" VALUES ('MockScene', 16);
INSERT INTO "sqlite_sequence" VALUES ('MockParam', 6);
INSERT INTO "sqlite_sequence" VALUES ('MockGroup', 8);
INSERT INTO "sqlite_sequence" VALUES ('UserSession', 60);
INSERT INTO "sqlite_sequence" VALUES ('Project', 2);
INSERT INTO "sqlite_sequence" VALUES ('RemoteConfig', 17);
INSERT INTO "sqlite_sequence" VALUES ('RemoteConfigParam', 14);
INSERT INTO "sqlite_sequence" VALUES ('MockData', 6);
INSERT INTO "sqlite_sequence" VALUES ('APISnapshot', 12);
COMMIT;

-- ----------------------------
-- Auto increment value for APISnapshot
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 12 WHERE name = 'APISnapshot';

-- ----------------------------
-- Auto increment value for MockData
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 6 WHERE name = 'MockData';

-- ----------------------------
-- Auto increment value for MockGroup
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 8 WHERE name = 'MockGroup';

-- ----------------------------
-- Auto increment value for MockParam
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 6 WHERE name = 'MockParam';

-- ----------------------------
-- Auto increment value for MockScene
-- ----------------------------
UPDATE "main"."sqlite_sequence" SET seq = 16 WHERE name = 'MockScene';

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
UPDATE "main"."sqlite_sequence" SET seq = 2 WHERE name = 'Project';

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
UPDATE "main"."sqlite_sequence" SET seq = 60 WHERE name = 'UserSession';

PRAGMA foreign_keys = true;

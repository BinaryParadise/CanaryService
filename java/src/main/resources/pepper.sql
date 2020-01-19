/*
 Navicat Premium Data Transfer

 Source Server         : 172.16.73.189
 Source Server Type    : MySQL
 Source Server Version : 50641
 Source Host           : 172.16.73.189:3306
 Source Schema         : pepper_dev

 Target Server Type    : MySQL
 Target Server Version : 50641
 File Encoding         : 65001

 Date: 27/04/2019 15:13:38
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for apps
-- ----------------------------
DROP TABLE IF EXISTS `apps`;
CREATE TABLE `apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增长',
  `appkey` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '唯一标识',
  `name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'App名称',
  `disable` bit(1) DEFAULT b'0' COMMENT '禁用状态',
  `orderno` int(11) NOT NULL DEFAULT '0' COMMENT '排序号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for envconfig
-- ----------------------------
DROP TABLE IF EXISTS `envconfig`;
CREATE TABLE `envconfig` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增长',
  `name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '配置名称',
  `comment` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '环境说明',
  `updateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `appId` int(11) NOT NULL COMMENT '所属app，apps.id',
  `author` varchar(20) COLLATE utf8_bin NOT NULL COMMENT '操作人',
  `isDefault` bit(1) DEFAULT b'0' COMMENT '是否默认环境',
  `type` int(11) DEFAULT '0' COMMENT '类型：0、测试 1、开发 2、生产',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_envconfig_name_appid` (`name`,`appId`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for envconfigitem
-- ----------------------------
DROP TABLE IF EXISTS `envconfigitem`;
CREATE TABLE `envconfigitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增长',
  `name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '项名称',
  `value` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '值',
  `envid` int(11) NOT NULL COMMENT '配置ID（envconfig.id)',
  `ssl` bit(1) NOT NULL DEFAULT b'0' COMMENT '是否开启https，默认为false',
  `updateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `comment` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '描述',
  `author` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '操作人',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型：0、普通 1、扩展',
  `platform` int(11) DEFAULT '0' COMMENT '平台：0、全部 1、iOS 2、Android',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_name_envid` (`name`,`envid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3575 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for envschemegroup
-- ----------------------------
DROP TABLE IF EXISTS `envschemegroup`;
CREATE TABLE `envschemegroup` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT '名称',
  `value` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '参数值',
  `comment` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '说明',
  `appid` int(11) NOT NULL COMMENT 'apps.id',
  `updateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `author` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '操作人',
  `type` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=384 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for envschemeitem
-- ----------------------------
DROP TABLE IF EXISTS `envschemeitem`;
CREATE TABLE `envschemeitem` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增长',
  `value` varchar(200) COLLATE utf8_bin DEFAULT NULL COMMENT '短链接',
  `pid` int(11) NOT NULL COMMENT '分组ID（envschemegroup.id)',
  `updateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `comment` varchar(50) COLLATE utf8_bin DEFAULT NULL COMMENT '描述',
  `author` varchar(20) COLLATE utf8_bin DEFAULT NULL COMMENT '操作人',
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '类型',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for mclogs
-- ----------------------------
DROP TABLE IF EXISTS `mclogs`;
CREATE TABLE `mclogs` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `appid` int(11) DEFAULT NULL,
  `deviceId` text,
  `uid` text,
  `platform` varchar(255) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '自定义日志类型',
  `message` blob NOT NULL,
  `file` text,
  `fileName` text,
  `function` text,
  `line` int(11) DEFAULT NULL,
  `timestamp` datetime NOT NULL,
  `threadID` text,
  `threadName` text,
  `queueLabel` text,
  PRIMARY KEY (`rid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=14280 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for mcnetlogs
-- ----------------------------
DROP TABLE IF EXISTS `mcnetlogs`;
CREATE TABLE `mcnetlogs` (
  `rid` int(11) NOT NULL AUTO_INCREMENT,
  `appid` int(11) NOT NULL,
  `deviceid` text,
  `uid` text,
  `platform` text,
  `url` text,
  `method` varchar(255) DEFAULT NULL,
  `mimeType` varchar(255) DEFAULT NULL,
  `requestHeader` blob,
  `requestBody` blob,
  `responseHeader` blob,
  `responseBody` blob,
  `statusCode` int(255) DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`rid`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=643 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Event structure for DeleteLogs
-- ----------------------------
DROP EVENT IF EXISTS `DeleteLogs`;
delimiter ;;
CREATE DEFINER=`root`@`%` EVENT `DeleteLogs` ON SCHEDULE EVERY '0:1' MINUTE_SECOND STARTS '2019-04-24 11:20:14' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM mclogs WHERE `timestamp` < CURRENT_DATE - 7;;
;;
delimiter ;

-- ----------------------------
-- Event structure for DeleteNetLogs
-- ----------------------------
DROP EVENT IF EXISTS `DeleteNetLogs`;
delimiter ;;
CREATE DEFINER=`root`@`%` EVENT `DeleteNetLogs` ON SCHEDULE EVERY 1 WEEK STARTS '2019-04-24 11:20:14' ON COMPLETION NOT PRESERVE ENABLE DO DELETE FROM mcnetlogs WHERE `timestamp` < CURRENT_DATE - 7;
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;

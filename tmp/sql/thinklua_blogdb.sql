/*
Navicat MySQL Data Transfer

Source Server         : 本地服务器
Source Server Version : 50718
Source Host           : localhost:3306
Source Database       : thinklua_blogdb

Target Server Type    : MYSQL
Target Server Version : 50718
File Encoding         : 65001

Date: 2018-02-05 10:01:11
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for blog_attachment
-- ----------------------------
DROP TABLE IF EXISTS `blog_attachment`;
CREATE TABLE `blog_attachment` (
  `file_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '文件ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '上传人ID',
  `size` int(11) NOT NULL DEFAULT '0' COMMENT '文件大小',
  `title` varchar(100) DEFAULT NULL COMMENT '文件中文名',
  `path` varchar(255) NOT NULL DEFAULT '' COMMENT '路径',
  `mime_type` varchar(50) NOT NULL DEFAULT '' COMMENT 'MIME类型',
  `downloads` int(11) NOT NULL DEFAULT '0' COMMENT '下载数量',
  `relation_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '关联类型(0为通用;1为文章;2为头像)',
  `relation_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联的ID',
  `remark` text NOT NULL COMMENT '详细描述信息',
  `meta` longtext NOT NULL COMMENT '页面元数据(关键词等)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`file_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='上传附件表';

-- ----------------------------
-- Records of blog_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for blog_category
-- ----------------------------
DROP TABLE IF EXISTS `blog_category`;
CREATE TABLE `blog_category` (
  `category_id` int(12) NOT NULL COMMENT '分类ID',
  `parent_id` int(12) NOT NULL DEFAULT '0' COMMENT '上级ID',
  `category_name` varchar(50) NOT NULL COMMENT '分类名称',
  `alias` varchar(30) NOT NULL DEFAULT '' COMMENT '分类别名',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '分类页页面标题',
  `keywords` varchar(200) NOT NULL DEFAULT '' COMMENT '页面关键词',
  `description` varchar(300) NOT NULL DEFAULT '' COMMENT '页面描述',
  `sort` int(8) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `items` int(12) NOT NULL DEFAULT '0' COMMENT '文章数',
  `options` varchar(300) NOT NULL DEFAULT '[]' COMMENT '选项(用于显示的选项)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`category_id`),
  KEY `idx_pid` (`parent_id`),
  KEY `idx_cname` (`category_name`,`status`),
  KEY `idx_alias` (`alias`,`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='分类表';

-- ----------------------------
-- Records of blog_category
-- ----------------------------

-- ----------------------------
-- Table structure for blog_comment
-- ----------------------------
DROP TABLE IF EXISTS `blog_comment`;
CREATE TABLE `blog_comment` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `posts_id` int(11) NOT NULL DEFAULT '0' COMMENT '文章ID',
  `checked` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否审核',
  `root_id` int(11) NOT NULL DEFAULT '0' COMMENT '层级根ID',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '上级ID',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户ID',
  `username` varchar(50) NOT NULL DEFAULT '' COMMENT '用户名',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '用户邮箱',
  `home_page` varchar(255) NOT NULL DEFAULT '' COMMENT '用户主页',
  `content` text NOT NULL COMMENT '评论内容',
  `ip` varchar(15) NOT NULL DEFAULT '' COMMENT '评论者IP',
  `user_agent` text NOT NULL COMMENT '用户浏览器等信息',
  `meta` longtext NOT NULL COMMENT '其他数据',
  `create_time` datetime DEFAULT NULL COMMENT '评论时间',
  PRIMARY KEY (`comment_id`),
  KEY `comment_pri` (`posts_id`,`root_id`,`checked`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='文章评论';

-- ----------------------------
-- Records of blog_comment
-- ----------------------------

-- ----------------------------
-- Table structure for blog_config
-- ----------------------------
DROP TABLE IF EXISTS `blog_config`;
CREATE TABLE `blog_config` (
  `group` varchar(30) NOT NULL DEFAULT 'SITE' COMMENT '配置分组',
  `title` varchar(50) NOT NULL COMMENT '配置的项的名称',
  `key` varchar(30) NOT NULL COMMENT '配置项键',
  `value` varchar(500) NOT NULL DEFAULT '' COMMENT '配置项值',
  `datatype` enum('STRING','NUMBER','JSON') DEFAULT 'STRING' COMMENT '数据类型',
  PRIMARY KEY (`key`),
  KEY `idx_grp` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置表';

-- ----------------------------
-- Records of blog_config
-- ----------------------------
INSERT INTO `blog_config` VALUES ('SITE', '主题设置', 'default_theme', 'default', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点描述', 'site_description', '专注于web开发', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点关键词', 'site_keywords', 'web开发', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点名称', 'site_name', '诗心博客', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点副标题', 'site_subtitle', '专注于web开发', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点标题', 'site_title', '诗心博客', 'STRING');

-- ----------------------------
-- Table structure for blog_link
-- ----------------------------
DROP TABLE IF EXISTS `blog_link`;
CREATE TABLE `blog_link` (
  `link_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '链接ID',
  `website_name` varchar(50) NOT NULL DEFAULT '' COMMENT '站点名称',
  `link_name` varchar(50) NOT NULL COMMENT '链接显示名称',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT '链接的地址',
  `logo` varchar(255) NOT NULL DEFAULT '' COMMENT 'logo地址',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '审核状态(0表示未审核，1表示已审核)',
  `contact` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '联系邮箱',
  `meta` varchar(200) NOT NULL DEFAULT '{}' COMMENT '其他信息(如微信，微博，手机号等)',
  `create_time` datetime NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='友情链接信息表';

-- ----------------------------
-- Records of blog_link
-- ----------------------------

-- ----------------------------
-- Table structure for blog_module
-- ----------------------------
DROP TABLE IF EXISTS `blog_module`;
CREATE TABLE `blog_module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '模块ID',
  `module_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模块名称',
  `alias` varchar(100) NOT NULL DEFAULT '' COMMENT '模块别名',
  `filename` varchar(50) NOT NULL DEFAULT '' COMMENT '模块文件名',
  `content` text NOT NULL COMMENT '模块内容',
  `position` varchar(30) NOT NULL DEFAULT '0' COMMENT '位置ID',
  `html_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'html元素ID',
  `type` varchar(5) NOT NULL DEFAULT 'HTML' COMMENT '类型(html代表普通html类型;data表示数据类型，需要使用到关联数据库表的数据)',
  `max_items` int(11) NOT NULL DEFAULT '0' COMMENT '最大行数',
  `show_title` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示标题',
  `sort` smallint(6) NOT NULL DEFAULT '0' COMMENT '排序',
  `meta` longtext NOT NULL COMMENT '其他元素',
  `status` enum('ENABLED','DISABLED') NOT NULL DEFAULT 'ENABLED' COMMENT '是否启用',
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='模块插件表';

-- ----------------------------
-- Records of blog_module
-- ----------------------------

-- ----------------------------
-- Table structure for blog_nav
-- ----------------------------
DROP TABLE IF EXISTS `blog_nav`;
CREATE TABLE `blog_nav` (
  `nav_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '导航ID',
  `position` tinyint(1) NOT NULL DEFAULT '1' COMMENT '导航位置(1为主导航;2为底部导航)',
  `title` varchar(30) NOT NULL DEFAULT '' COMMENT '导航名称',
  `url` varchar(300) NOT NULL DEFAULT '' COMMENT '导航URL',
  `icon` varchar(100) NOT NULL DEFAULT '' COMMENT '导航ICON',
  `nav_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '导航类型(1为站内导航，2为站外导航)',
  `target` varchar(20) NOT NULL DEFAULT '' COMMENT '打开类型',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否展示',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`nav_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='导航菜单';

-- ----------------------------
-- Records of blog_nav
-- ----------------------------

-- ----------------------------
-- Table structure for blog_posts
-- ----------------------------
DROP TABLE IF EXISTS `blog_posts`;
CREATE TABLE `blog_posts` (
  `posts_id` int(12) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `category_id` int(12) NOT NULL DEFAULT '0' COMMENT '分类ID',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `alias` varchar(200) NOT NULL DEFAULT '' COMMENT '文章别名(用于自定义URL)',
  `keywords` varchar(200) NOT NULL DEFAULT '' COMMENT '关键词',
  `description` varchar(200) NOT NULL DEFAULT '' COMMENT '描述',
  `summary` varchar(500) NOT NULL DEFAULT '' COMMENT '摘要',
  `content` text NOT NULL COMMENT '内容',
  `views` int(12) NOT NULL DEFAULT '0' COMMENT '浏览数',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '类型(是正式文章还是草稿)',
  `comments` int(12) NOT NULL DEFAULT '0' COMMENT '评论数',
  `options` varchar(200) NOT NULL DEFAULT '[]' COMMENT '其他选项',
  `author` varchar(200) NOT NULL DEFAULT '' COMMENT '作者',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`posts_id`),
  UNIQUE KEY `idx_alias` (`alias`,`type`),
  KEY `idx_title` (`title`,`type`),
  KEY `idx_ctime` (`create_time`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

-- ----------------------------
-- Records of blog_posts
-- ----------------------------

-- ----------------------------
-- Table structure for blog_role
-- ----------------------------
DROP TABLE IF EXISTS `blog_role`;
CREATE TABLE `blog_role` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) NOT NULL DEFAULT '' COMMENT '角色名称',
  `desc` varchar(100) NOT NULL DEFAULT '' COMMENT '角色描述',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否可用',
  `rules` text COMMENT '权限集合',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

-- ----------------------------
-- Records of blog_role
-- ----------------------------

-- ----------------------------
-- Table structure for blog_tag
-- ----------------------------
DROP TABLE IF EXISTS `blog_tag`;
CREATE TABLE `blog_tag` (
  `tag_id` int(12) NOT NULL COMMENT '标题ID',
  `tag_name` varchar(50) NOT NULL COMMENT '标签名称',
  `tag_alias` varchar(30) NOT NULL DEFAULT '' COMMENT '标签别名',
  `sort` int(8) NOT NULL DEFAULT '0' COMMENT '排序值',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示',
  `items` int(11) NOT NULL DEFAULT '0' COMMENT '打标签的次数',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `idx_tname` (`tag_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标签表';

-- ----------------------------
-- Records of blog_tag
-- ----------------------------

-- ----------------------------
-- Table structure for blog_tag_relation
-- ----------------------------
DROP TABLE IF EXISTS `blog_tag_relation`;
CREATE TABLE `blog_tag_relation` (
  `tag_id` int(12) NOT NULL COMMENT '标题ID',
  `posts_id` int(12) NOT NULL COMMENT '文章ID',
  PRIMARY KEY (`tag_id`,`posts_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标签与文章关联关系表';

-- ----------------------------
-- Records of blog_tag_relation
-- ----------------------------

-- ----------------------------
-- Table structure for blog_topic
-- ----------------------------
DROP TABLE IF EXISTS `blog_topic`;
CREATE TABLE `blog_topic` (
  `topic_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '专题ID',
  `topic_name` varchar(30) NOT NULL DEFAULT '' COMMENT '专题名称',
  `topic_alias` varchar(100) NOT NULL DEFAULT '' COMMENT '专题别名',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `keywords` varchar(200) NOT NULL DEFAULT '' COMMENT '关键词',
  `description` varchar(300) NOT NULL DEFAULT '' COMMENT '描述',
  `summary` varchar(500) NOT NULL DEFAULT '' COMMENT '摘要',
  `content` text COMMENT '内容',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否展示',
  `posts` int(11) NOT NULL DEFAULT '0' COMMENT '文章数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='专题';

-- ----------------------------
-- Records of blog_topic
-- ----------------------------

-- ----------------------------
-- Table structure for blog_topic_relation
-- ----------------------------
DROP TABLE IF EXISTS `blog_topic_relation`;
CREATE TABLE `blog_topic_relation` (
  `topic_id` int(12) NOT NULL COMMENT '标题ID',
  `posts_id` int(12) NOT NULL COMMENT '文章ID',
  PRIMARY KEY (`topic_id`,`posts_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='专题与文章关联关系表';

-- ----------------------------
-- Records of blog_topic_relation
-- ----------------------------

-- ----------------------------
-- Table structure for blog_user
-- ----------------------------
DROP TABLE IF EXISTS `blog_user`;
CREATE TABLE `blog_user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL DEFAULT '0' COMMENT '角色ID',
  `account` varchar(50) NOT NULL COMMENT '账号',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(300) NOT NULL DEFAULT '' COMMENT '头像',
  `last_login_time` datetime DEFAULT NULL COMMENT '上次登录时间',
  `last_login_ip` varchar(30) NOT NULL DEFAULT '' COMMENT '上次登录IP',
  `posts` int(11) NOT NULL DEFAULT '0' COMMENT '发布文章数',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`uid`),
  UNIQUE KEY `idx_account` (`account`),
  UNIQUE KEY `idx_email` (`email`),
  UNIQUE KEY `idx_nickname` (`nickname`) USING BTREE,
  KEY `idx_status` (`status`),
  KEY `idx_ctime` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='用户名';

-- ----------------------------
-- Records of blog_user
-- ----------------------------
INSERT INTO `blog_user` VALUES ('1', '0', 'shixinke', 'b51f59230e26216293a94afef5d0b173', '', '', '', '2018-02-05 09:55:38', '127.0.0.1', '0', '1', '2018-01-25 19:18:37');

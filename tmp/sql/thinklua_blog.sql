/*
Navicat MySQL Data Transfer

Source Server         : 台式机
Source Server Version : 50630
Source Host           : 10.2.82.206:3306
Source Database       : thinklua_blog

Target Server Type    : MYSQL
Target Server Version : 50630
File Encoding         : 65001

Date: 2017-02-23 17:09:14
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
  `posts_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联的文章ID',
  `remark` text NOT NULL COMMENT '详细描述信息',
  `meta` longtext NOT NULL COMMENT '页面元数据(关键词等)',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
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
  `create_time` int(12) NOT NULL DEFAULT '0' COMMENT '创建时间',
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
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '评论时间',
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
-- Table structure for blog_module
-- ----------------------------
DROP TABLE IF EXISTS `blog_module`;
CREATE TABLE `blog_module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '模块ID',
  `module_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模块名称',
  `alias` varchar(100) NOT NULL DEFAULT '' COMMENT '模块别名',
  `filename` varchar(50) NOT NULL DEFAULT '' COMMENT '模块文件名',
  `content` text NOT NULL COMMENT '模块内容',
  `sidebar_id` int(11) NOT NULL DEFAULT '0' COMMENT '位置ID',
  `html_id` varchar(50) NOT NULL DEFAULT '' COMMENT 'html元素ID',
  `type` varchar(5) NOT NULL DEFAULT '' COMMENT '类型',
  `max_items` int(11) NOT NULL DEFAULT '0' COMMENT '最大行数',
  `source` varchar(50) NOT NULL DEFAULT '' COMMENT '来源',
  `show_title` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示标题',
  `meta` longtext NOT NULL COMMENT '其他元素',
  `status` enum('ENABLED','DISABLED') DEFAULT 'ENABLED' COMMENT '是否启用',
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='模块插件表';

-- ----------------------------
-- Records of blog_module
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
  `content` text NOT NULL COMMENT '内容',
  `views` int(12) NOT NULL DEFAULT '0' COMMENT '浏览数',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '类型(是正式文章还是草稿)',
  `comments` int(12) NOT NULL DEFAULT '0' COMMENT '评论数',
  `options` varchar(200) NOT NULL DEFAULT '[]' COMMENT '其他选项',
  `author` varchar(200) NOT NULL DEFAULT '' COMMENT '作者',
  `create_time` int(12) NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`posts_id`),
  UNIQUE KEY `idx_alias` (`alias`,`type`),
  KEY `idx_title` (`title`,`type`),
  KEY `idx_ctime` (`create_time`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文章表';

-- ----------------------------
-- Records of blog_posts
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
-- Table structure for blog_tags
-- ----------------------------
DROP TABLE IF EXISTS `blog_tags`;
CREATE TABLE `blog_tags` (
  `tag_id` int(12) NOT NULL COMMENT '标题ID',
  `tag_name` varchar(50) NOT NULL COMMENT '标签名称',
  `tag_alias` varchar(30) DEFAULT NULL COMMENT '标签别名',
  `sort` int(8) NOT NULL DEFAULT '0' COMMENT '排序值',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示',
  `items` int(11) NOT NULL DEFAULT '0' COMMENT '打标签的次数',
  `create_time` int(11) DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `idx_tname` (`tag_name`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标签表';

-- ----------------------------
-- Records of blog_tags
-- ----------------------------

-- ----------------------------
-- Table structure for blog_user
-- ----------------------------
DROP TABLE IF EXISTS `blog_user`;
CREATE TABLE `blog_user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(50) NOT NULL COMMENT '账号',
  `password` varchar(50) NOT NULL COMMENT '密码',
  `email` varchar(50) NOT NULL DEFAULT '' COMMENT '邮箱',
  `nickname` varchar(50) NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(300) DEFAULT NULL COMMENT '头像',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `create_time` int(20) NOT NULL DEFAULT '0' COMMENT '创建时间',
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
INSERT INTO `blog_user` VALUES ('1', 'shixinke', 'ac9feb835e08c15611f12213c4014f0a', '', '', null, '1', '1475222129');

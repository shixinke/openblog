/*
Navicat MySQL Data Transfer

Source Server         : 台式机
Source Server Version : 50718
Source Host           : 10.2.82.56:3306
Source Database       : thinklua_blogdb

Target Server Type    : MYSQL
Target Server Version : 50718
File Encoding         : 65001

Date: 2018-03-23 19:20:25
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for blog_apps
-- ----------------------------
DROP TABLE IF EXISTS `blog_apps`;
CREATE TABLE `blog_apps` (
  `app_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '项目ID',
  `app_name` varchar(200) NOT NULL DEFAULT '' COMMENT '项目名称',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '项目中文名称',
  `cover` varchar(300) NOT NULL DEFAULT '' COMMENT '封面',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '托管平台类型(1表示github)',
  `desc` varchar(300) NOT NULL DEFAULT '' COMMENT '项目描述',
  `url` varchar(300) NOT NULL DEFAULT '' COMMENT '项目地址',
  `display` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否展示',
  `weight` int(10) NOT NULL DEFAULT '200' COMMENT '排序值',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  PRIMARY KEY (`app_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='应用项目表';

-- ----------------------------
-- Records of blog_apps
-- ----------------------------

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
  `media_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1为图片;2为音频;3为视频',
  `mime_type` varchar(50) NOT NULL DEFAULT '' COMMENT 'MIME类型',
  `downloads` int(11) NOT NULL DEFAULT '0' COMMENT '下载数量',
  `relation_type` tinyint(1) NOT NULL DEFAULT '0' COMMENT '关联类型(0为通用;1为文章;2为头像)',
  `relation_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联的ID',
  `remark` text NOT NULL COMMENT '详细描述信息',
  `weight` int(12) NOT NULL DEFAULT '0',
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`file_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='上传附件表';

-- ----------------------------
-- Records of blog_attachment
-- ----------------------------

-- ----------------------------
-- Table structure for blog_category
-- ----------------------------
DROP TABLE IF EXISTS `blog_category`;
CREATE TABLE `blog_category` (
  `category_id` int(12) NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `parent_id` int(12) NOT NULL DEFAULT '0' COMMENT '上级ID',
  `category_name` varchar(50) NOT NULL COMMENT '分类名称',
  `alias` varchar(30) NOT NULL DEFAULT '' COMMENT '分类别名',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '分类页页面标题',
  `keywords` varchar(200) NOT NULL DEFAULT '' COMMENT '页面关键词',
  `description` varchar(300) NOT NULL DEFAULT '' COMMENT '页面描述',
  `weight` int(8) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `items` int(12) NOT NULL DEFAULT '0' COMMENT '文章数',
  `icon` varchar(300) NOT NULL DEFAULT '{}' COMMENT '选项(用于显示的选项)',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`category_id`),
  KEY `idx_pid` (`parent_id`),
  KEY `idx_cname` (`category_name`,`status`),
  KEY `idx_alias` (`alias`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='分类表';

-- ----------------------------
-- Records of blog_category
-- ----------------------------
INSERT INTO `blog_category` VALUES ('2', '0', '右手诗', 'poem', '右手诗', '', '', '200', '1', '0', 'icon-audio', '2018-02-09 16:57:40');
INSERT INTO `blog_category` VALUES ('4', '0', '左手代码', 'code', '左手代码', '33', '33', '20', '1', '0', 'icon-menu-nav', '2018-03-09 23:19:38');

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
  `reply_with_email` tinyint(4) NOT NULL DEFAULT '0' COMMENT '回复时是否发送邮件通知',
  `create_time` datetime DEFAULT NULL COMMENT '评论时间',
  PRIMARY KEY (`comment_id`),
  KEY `comment_pri` (`posts_id`,`root_id`,`checked`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COMMENT='文章评论';

-- ----------------------------
-- Records of blog_comment
-- ----------------------------
INSERT INTO `blog_comment` VALUES ('2', '25', '0', '0', '0', '2', '诗心客', 'ishixinke@qq.com', '', 'testestttt', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36', '0', '2018-03-11 21:05:52');
INSERT INTO `blog_comment` VALUES ('3', '25', '0', '0', '0', '2', '诗心客', 'ishixinke@qq.com', '', 'testestttt', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36', '0', '2018-03-11 21:05:52');
INSERT INTO `blog_comment` VALUES ('4', '25', '0', '0', '0', '2', '诗心客', 'ishixinke@qq.com', '', 'ddddddddtest', '127.0.0.1', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36', '0', '2018-03-11 21:13:50');

-- ----------------------------
-- Table structure for blog_config
-- ----------------------------
DROP TABLE IF EXISTS `blog_config`;
CREATE TABLE `blog_config` (
  `group` varchar(30) NOT NULL DEFAULT 'SITE' COMMENT '配置分组',
  `title` varchar(50) NOT NULL COMMENT '配置的项的名称',
  `key` varchar(30) NOT NULL COMMENT '配置项键',
  `value` varchar(500) NOT NULL DEFAULT '' COMMENT '配置项值',
  `datatype` enum('STRING','NUMBER','JSON','BOOLEAN') NOT NULL DEFAULT 'STRING' COMMENT '数据类型',
  PRIMARY KEY (`key`),
  KEY `idx_grp` (`group`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置表';

-- ----------------------------
-- Records of blog_config
-- ----------------------------
INSERT INTO `blog_config` VALUES ('AUTHOR', '博主头像', 'author_avatar', '/static/images/avatar/13.jpg', 'STRING');
INSERT INTO `blog_config` VALUES ('AUTHOR', '博主邮箱', 'author_email', 'ishixinke@qq.com', 'STRING');
INSERT INTO `blog_config` VALUES ('AUTHOR', 'github地址', 'author_github', 'shixinke', 'STRING');
INSERT INTO `blog_config` VALUES ('AUTHOR', '博主昵称', 'author_nickname', '诗心客', 'STRING');
INSERT INTO `blog_config` VALUES ('AUTHOR', '微博', 'author_weibo', 'yimengshixin', 'STRING');
INSERT INTO `blog_config` VALUES ('FUNC', '评论功能', 'comment_status', '1', 'BOOLEAN');
INSERT INTO `blog_config` VALUES ('SITE', '版权说明', 'copyright', 'ff', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '主题设置', 'default_theme', 'default', 'STRING');
INSERT INTO `blog_config` VALUES ('PAGE', '列表页显示文章数', 'list_page_size', '15', 'NUMBER');
INSERT INTO `blog_config` VALUES ('PAGE', '翻页条显示翻页的数量', 'pagination_page_count', '10', 'NUMBER');
INSERT INTO `blog_config` VALUES ('PAGE', '允许搜索返回文章的最大数量', 'search_max_count', '1', 'NUMBER');
INSERT INTO `blog_config` VALUES ('PAGE', '列出分类下所有子分类的文章', 'show_sub_category_posts', '1', 'BOOLEAN');
INSERT INTO `blog_config` VALUES ('SITE', '站点描述', 'site_description', '专注于web开发', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点关键词', 'site_keywords', 'web开发', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点名称', 'site_name', '诗心博客', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点副标题', 'site_subtitle', '专注于web开发', 'STRING');
INSERT INTO `blog_config` VALUES ('SITE', '站点标题', 'site_title', '诗心博客', 'STRING');
INSERT INTO `blog_config` VALUES ('GLOBAL', '允许上传的文件类型', 'upload_allow_types', 'jpg', 'STRING');
INSERT INTO `blog_config` VALUES ('GLOBAL', '允许上传的文件大小', 'upload_max_size', '2', 'STRING');

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
  `weight` int(11) NOT NULL DEFAULT '0',
  `contact` varchar(50) NOT NULL DEFAULT '' COMMENT '联系人',
  `email` varchar(100) NOT NULL DEFAULT '' COMMENT '联系邮箱',
  `create_time` datetime NOT NULL COMMENT '添加时间',
  PRIMARY KEY (`link_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='友情链接信息表';

-- ----------------------------
-- Records of blog_link
-- ----------------------------
INSERT INTO `blog_link` VALUES ('1', '诗心博客', 'web开发', 'http://www.shixinke.com', 'http://www.shixinke.com/zb_users/theme/dux/style/default/logo.png', '1', '1', '1000', '诗心', 'ishixinke@qq.com', '2018-03-10 16:48:43');

-- ----------------------------
-- Table structure for blog_module
-- ----------------------------
DROP TABLE IF EXISTS `blog_module`;
CREATE TABLE `blog_module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '模块ID',
  `module_type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '模块类型(1:内置模块;2:自定义模块)',
  `module_name` varchar(255) NOT NULL DEFAULT '' COMMENT '模块名称',
  `alias` varchar(100) NOT NULL DEFAULT '' COMMENT '模块别名',
  `hook` varchar(30) NOT NULL DEFAULT '0' COMMENT '钩子ID',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '类型(1代表普通html类型;2表示数据类型，需要使用到关联数据库表的数据)',
  `content` text NOT NULL COMMENT '模块内容',
  `filename` varchar(50) NOT NULL DEFAULT '' COMMENT '模块文件名',
  `max_items` int(11) NOT NULL DEFAULT '0' COMMENT '最大行数',
  `show_title` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否显示标题',
  `weight` smallint(6) NOT NULL DEFAULT '0' COMMENT '排序',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启用',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '创建时间',
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COMMENT='模块插件表';

-- ----------------------------
-- Records of blog_module
-- ----------------------------
INSERT INTO `blog_module` VALUES ('1', '2', '顶部bar', 'topbar', 'topbar', '1', '<div class=\"col-md-12 col-sm-12 col-xs-12 additional-nav text-right\">\n                <ul class=\"list-unstyled list-inline pull-right\">\n                    <li><a href=\"#\">Log In</a></li>\n                </ul>\n            </div>', 'link', '0', '0', '10', '1', '2018-03-14 11:52:48');
INSERT INTO `blog_module` VALUES ('2', '1', 'logo', 'logo', 'logo', '1', '<a class=\"site-logo\" href=\"/\"><img src=\"/static/images/logo.png\" class=\"logo-img\"></a>', 'navbar', '1', '0', '1', '1', '2018-03-14 14:37:00');
INSERT INTO `blog_module` VALUES ('3', '1', '导航栏', 'navbar', 'navbar', '2', '', 'navbar', '20', '0', '10', '1', '2018-03-14 14:46:32');
INSERT INTO `blog_module` VALUES ('4', '1', '搜索栏', 'searchbar', 'searchbar', '1', '<div class=\"searchbar\"></div>', 'logo', '0', '0', '100', '1', '2018-03-14 14:48:38');
INSERT INTO `blog_module` VALUES ('5', '1', '专题', 'topic', 'sidebar', '2', '', 'topic', '20', '1', '20', '1', '2018-03-19 20:00:04');
INSERT INTO `blog_module` VALUES ('6', '1', '标签', 'tag', 'sidebar', '2', '', 'tag', '30', '1', '30', '1', '2018-03-19 20:00:47');
INSERT INTO `blog_module` VALUES ('7', '1', '分类', 'category', 'sidebar', '2', '', 'category', '0', '1', '30', '1', '2018-03-19 20:01:14');
INSERT INTO `blog_module` VALUES ('8', '1', '归档', 'archive', 'sidebar', '2', '', 'archive', '20', '1', '30', '1', '2018-03-19 20:02:16');

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
  `weight` int(6) NOT NULL DEFAULT '0',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否展示',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`nav_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='导航菜单';

-- ----------------------------
-- Records of blog_nav
-- ----------------------------
INSERT INTO `blog_nav` VALUES ('1', '1', '在', '/test', 'icon-enlarge', '1', '_blank', '25', '1', '2018-03-10 14:10:41');

-- ----------------------------
-- Table structure for blog_node
-- ----------------------------
DROP TABLE IF EXISTS `blog_node`;
CREATE TABLE `blog_node` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '节点ID',
  `parent_id` int(11) NOT NULL DEFAULT '0' COMMENT '父节点ID',
  `title` varchar(30) NOT NULL DEFAULT '' COMMENT '节点名称',
  `uri` varchar(100) NOT NULL DEFAULT '' COMMENT '操作URL',
  `weight` int(11) NOT NULL DEFAULT '10' COMMENT '排序值',
  `icon` varchar(300) NOT NULL DEFAULT '' COMMENT '图标',
  `type` tinyint(2) NOT NULL DEFAULT '2' COMMENT '节点类型(1表示菜单，2表示权限项)',
  `display` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否在菜单中展示',
  `path` varchar(200) NOT NULL DEFAULT '0' COMMENT '层级展示',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '是否启用',
  `remark` varchar(200) NOT NULL DEFAULT '' COMMENT '备注信息',
  PRIMARY KEY (`id`),
  KEY `idx_pid` (`parent_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COMMENT='操作节点表';

-- ----------------------------
-- Records of blog_node
-- ----------------------------
INSERT INTO `blog_node` VALUES ('26', '0', '控制台', '/admin/dashboard/index', '500', 'icon-console', '1', '1', '0', '1', '控制台');
INSERT INTO `blog_node` VALUES ('27', '0', '文章管理', '', '499', 'icon-posts-list', '1', '1', '0', '1', '文章');
INSERT INTO `blog_node` VALUES ('29', '27', '文章列表', '/admin/posts/index', '498', 'icon-text', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('30', '0', '权限管理', '', '300', 'icon-access', '1', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('31', '30', '权限菜单', '/admin/node/index', '305', 'icon-menu', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('32', '30', '角色管理', '/admin/role/index', '301', 'icon-role1', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('33', '30', '管理员', '/admin/user/index', '299', 'icon-grant', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('34', '27', '文章分类', '/admin/category/index', '600', 'icon-menu-nav', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('35', '27', '标签管理', '/admin/tag/index', '200', 'icon-tag', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('36', '0', '附件', '/admin/attachment/index', '300', 'icon-attach', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('37', '0', '友情链接', '/admin/link/index', '299', 'icon-link', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('38', '0', '配置', '', '399', 'icon-setting', '1', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('39', '38', '网站配置', '/admin/config/index', '388', 'icon-config', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('40', '38', '导航菜单', '/admin/nav/index', '377', 'icon-structure', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('41', '0', '评论', '/admin/comment/index', '310', 'icon-msg2', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('42', '38', '主题设置', '/admin/theme/index', '421', 'icon-skin', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('43', '0', '模块管理', '/admin/module/index', '411', 'icon-module', '2', '1', '0', '1', '');
INSERT INTO `blog_node` VALUES ('45', '27', '专题管理', '/admin/topic/index', '222', 'icon-topic', '2', '1', '0', '1', '');

-- ----------------------------
-- Table structure for blog_posts
-- ----------------------------
DROP TABLE IF EXISTS `blog_posts`;
CREATE TABLE `blog_posts` (
  `posts_id` int(12) NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `category_id` int(12) NOT NULL DEFAULT '0' COMMENT '分类ID',
  `is_page` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否单页',
  `title` varchar(200) NOT NULL DEFAULT '' COMMENT '标题',
  `alias` varchar(200) NOT NULL DEFAULT '' COMMENT '文章别名(用于自定义URL)',
  `keywords` varchar(200) NOT NULL DEFAULT '' COMMENT '关键词',
  `description` varchar(200) NOT NULL DEFAULT '' COMMENT '描述',
  `summary` varchar(500) NOT NULL DEFAULT '' COMMENT '摘要',
  `markdown` text NOT NULL COMMENT 'markdown格式内容',
  `content` text NOT NULL COMMENT '内容',
  `tags` varchar(100) NOT NULL DEFAULT '' COMMENT '标签ID列表',
  `views` int(12) NOT NULL DEFAULT '0' COMMENT '浏览数',
  `type` tinyint(2) NOT NULL DEFAULT '1' COMMENT '类型(是正式文章还是草稿)',
  `comments` int(12) NOT NULL DEFAULT '0' COMMENT '评论数',
  `template` varchar(200) NOT NULL DEFAULT '' COMMENT '其他选项',
  `author` varchar(200) NOT NULL DEFAULT '' COMMENT '作者',
  `is_top` tinyint(1) NOT NULL DEFAULT '0',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`posts_id`),
  UNIQUE KEY `idx_alias` (`alias`,`type`),
  KEY `idx_title` (`title`,`type`),
  KEY `idx_ctime` (`create_time`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='文章表';

-- ----------------------------
-- Records of blog_posts
-- ----------------------------
INSERT INTO `blog_posts` VALUES ('9', '2', '0', '第一篇', 'test', 'test', 'test', '<h1 id=\"h1-test\"><a name=\"test\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test</h1><h2 id=\"h2-test2\"><a name=\"test2\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test2</h2><p>一样好的</p>\n', '', '<h1 id=\"h1-test\"><a name=\"test\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test</h1><h2 id=\"h2-test2\"><a name=\"test2\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test2</h2><p>一样好的</p>\n', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('11', '2', '0', '第一篇', 'test1', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('12', '2', '0', '第一篇', 'test2', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('13', '2', '0', '第一篇', 'test3', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('15', '2', '0', '第一篇', 'test4', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('17', '2', '0', '第一篇', 'test5', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('18', '2', '0', '第一篇', 'test6', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('20', '2', '0', '第一篇', 'test7', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('21', '2', '0', '第一篇', 'test8', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('23', '2', '0', '第一篇', 'test11', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('24', '2', '0', '第一篇', 'test12', 'test', 'test', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '&lt;h1 id=&quot;h1-test&quot;&gt;&lt;a name=&quot;test&quot; class=&quot;reference-link&quot;&gt;&lt;&#47;a&gt;&lt;span class=&quot;header-link octicon octicon-link&quot;&gt;&lt;&#47;span&gt;test&lt;&#47;h1&gt;', '', '0', '1', '0', '', '2', '0', '2018-03-10 22:39:14');
INSERT INTO `blog_posts` VALUES ('25', '4', '0', 'markdown第一篇', 'md', 'test', 'test', '<h1 id=\"h1-test-markdown\"><a name=\"test markdown\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test markdown</h1><h3 id=\"h3-test-title\"><a name=\"test title\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test title</h3><p>markdown</p>\n', '# test markdown\n\n### test title\n\nmarkdown', '<h1 id=\"h1-test-markdown\"><a name=\"test markdown\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test markdown</h1><h3 id=\"h3-test-title\"><a name=\"test title\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>test title</h3><p>markdown</p>\n', '', '0', '1', '0', '', '2', '0', '2018-03-11 16:52:04');

-- ----------------------------
-- Table structure for blog_role
-- ----------------------------
DROP TABLE IF EXISTS `blog_role`;
CREATE TABLE `blog_role` (
  `role_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(50) NOT NULL COMMENT '角色名称',
  `remark` varchar(100) NOT NULL COMMENT '备注',
  `rules` varchar(1000) NOT NULL COMMENT '权限项组合',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启用',
  `weight` int(10) NOT NULL DEFAULT '0' COMMENT '排序',
  `create_time` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='管理员角色';

-- ----------------------------
-- Records of blog_role
-- ----------------------------
INSERT INTO `blog_role` VALUES ('1', '超级管理员', '超级管理员', '26,27,34,29,30,31,32,33', '1', '899', '2018-03-09 17:31:53');

-- ----------------------------
-- Table structure for blog_tag
-- ----------------------------
DROP TABLE IF EXISTS `blog_tag`;
CREATE TABLE `blog_tag` (
  `tag_id` int(12) NOT NULL AUTO_INCREMENT COMMENT '标题ID',
  `tag_name` varchar(50) NOT NULL COMMENT '标签名称',
  `tag_alias` varchar(30) NOT NULL DEFAULT '' COMMENT '标签别名',
  `weight` int(8) NOT NULL DEFAULT '0' COMMENT '排序值',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '状态',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否显示',
  `items` int(11) NOT NULL DEFAULT '0' COMMENT '打标签的次数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`tag_id`),
  UNIQUE KEY `idx_tname` (`tag_name`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='标签表';

-- ----------------------------
-- Records of blog_tag
-- ----------------------------
INSERT INTO `blog_tag` VALUES ('2', 'php', 'php', '0', '1', '1', '0', '2018-02-07 13:23:20');
INSERT INTO `blog_tag` VALUES ('3', 'mysql', 'mysql', '0', '1', '1', '0', '2018-02-26 19:37:27');
INSERT INTO `blog_tag` VALUES ('4', 'js', 'js', '12', '1', '1', '0', '2018-03-09 22:38:41');

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
INSERT INTO `blog_tag_relation` VALUES ('2', '24');
INSERT INTO `blog_tag_relation` VALUES ('3', '24');

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
  `markdown` text NOT NULL COMMENT 'markdown',
  `content` text COMMENT '内容',
  `display` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否展示',
  `weight` int(12) NOT NULL DEFAULT '0',
  `posts` int(11) NOT NULL DEFAULT '0' COMMENT '文章数',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  PRIMARY KEY (`topic_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='专题';

-- ----------------------------
-- Records of blog_topic
-- ----------------------------
INSERT INTO `blog_topic` VALUES ('1', '专题1', 'topic1', '', '', '', '', '', null, '1', '0', '0', '2018-03-11 17:16:22');
INSERT INTO `blog_topic` VALUES ('2', '专题1', 'topic2', '1', '2', '3', '<h1 id=\"h1-topic1\"><a name=\"topic1\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>topic1</h1>', '#topic1', '<h1 id=\"h1-topic1\"><a name=\"topic1\" class=\"reference-link\"></a><span class=\"header-link octicon octicon-link\"></span>topic1</h1>', '1', '0', '0', '2018-03-11 17:17:30');

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
INSERT INTO `blog_topic_relation` VALUES ('1', '9');
INSERT INTO `blog_topic_relation` VALUES ('1', '11');
INSERT INTO `blog_topic_relation` VALUES ('1', '12');
INSERT INTO `blog_topic_relation` VALUES ('1', '13');
INSERT INTO `blog_topic_relation` VALUES ('1', '15');
INSERT INTO `blog_topic_relation` VALUES ('2', '9');
INSERT INTO `blog_topic_relation` VALUES ('2', '11');
INSERT INTO `blog_topic_relation` VALUES ('2', '12');

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COMMENT='用户名';

-- ----------------------------
-- Records of blog_user
-- ----------------------------
INSERT INTO `blog_user` VALUES ('2', '0', 'shixinke', 'ba8c62ed2a6109ae83f48360a606a115', 'ishixinke@qq.com', '诗心客', '/static/images/avatar/5.jpg', '2018-03-23 16:19:24', '10.2.84.80', '0', '1', '2018-03-08 20:09:17');
INSERT INTO `blog_user` VALUES ('3', '0', 'cal', 'f89a1ddd0bb55b8ce1c599b19981868a', 'cal@qq.com', '文明', '/static/images/avatar/4.jpg', null, '', '0', '1', '2018-03-09 19:40:00');

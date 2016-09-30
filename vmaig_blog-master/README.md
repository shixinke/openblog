vmaig.com 网站源码
=================
[![ENV](https://img.shields.io/badge/python-2.7%2C3.4-blue.svg)](https://github.com/billvsme/vmaig_blog)
[![LICENSE](https://img.shields.io/badge/license-BSD-blue.svg)](https://github.com/billvsme/vmaig_blog/blob/master/LICENSE)
[![Travis](https://img.shields.io/travis/billvsme/vmaig_blog.svg)](https://travis-ci.org/billvsme/vmaig_blog)
[![Docker Stars](https://img.shields.io/docker/stars/billvsme/vmaig_blog.svg)](https://hub.docker.com/r/billvsme/vmaig_blog/)
[![Docker Pulls](https://img.shields.io/docker/pulls/billvsme/vmaig_blog.svg)](https://hub.docker.com/r/billvsme/vmaig_blog/)
#有问题欢迎加qq群
vmaig qq群: 458788510  
我的qq: 994171686  

[使用Docker部署vmaig_blog](http://vmaig.com/article/deplay_vmaig_blog.html)

#更新日志
2015/5/15 从django1.6 升级到 django1.8 (还保留django1.6分支)  
2015/6/21 添加[xadmin分支](https://github.com/billvsme/vmaig_blog/tree/xadmin),xadmin分支中使用xadmin作为后台管理(使用 django 1.8),如果你想后台比较漂亮可以切换到xadmin分支(注意你不需要pip install django-xadmin 但是需要安装django-crispy-forms跟django-reversion详细步骤见xadmin分支中的README)  
2015/7/5 对xadmin分支中的错误进行了比较大的修改  
2016/3/17 添加评论回复  
2016/3/22 添加Dockerfile，使用Docker部署本博客  

#概述
vmaig\_blog 是一个基于  **Django1.8**  跟  **Bootstrap3**  开发的 **博客系统** ，实现了一个博客完整的功能。http://vmaig.com 就是基于vmaig\_blog 搭建的。
#功能
1. 文章,分类,专栏的添加，删除，修改。支持**tinymce**富文本编辑器。支持文章中代码**高亮**。
2. 实现**用户注册,登陆,修改密码,忘记重置密码**。通过**邮箱**通知注册用户, 用户忘记密码基于邮件（需要在setting.py设置好邮箱)。
3. 实现**用户头像**，用户可以上传头像，然后编辑头像大小，然后保存，头像可以存在本地，也可自动保存在**七牛**云中（需要在setting.py 中设置好七牛的相关配置）。
4. **支持评论**，实现了一个独立的评论系统。
5. 首页支持显示**轮播**，显示最新评论，显示人气最高的文章。
6. 首页支持显示**标签云**，拥有一个非常酷炫的便签云。
7. 拥有一个**动态加载**的“全部文章”板块 可以显示所有文章分类，可以按照浏览数或者时间排序显示文章。
8. 拥有一个以**时间轴**显示的非常酷炫的“新闻”板块，你可以每天在后台添加新闻。
9. 支持**手机浏览**，对手机浏览进行了调整。

#Demo
http://vmaig.com   

#预览
![首页](http://vmaig.qiniudn.com/screenshot/vmaig_01.jpg)
![头像](http://vmaig.qiniudn.com/screenshot/vmaig_02.jpg)
![评论](http://vmaig.qiniudn.com/screenshot/vmaig_03.jpg)
![新闻](http://vmaig.qiniudn.com/screenshot/vmaig_news.jpg)

#安装运行
安装virtualenv :

    sudo pip install virtualenv

创建并激活虚拟环境 :

    virtualenv www
    cd www
    source bin/active

下载代码,切换目录 :
    
    git clone https://github.com/billvsme/vmaig_blog
    cd vmaig_blog

首先安装相关Pillow 用到的c库 :
(详见https://pillow.readthedocs.org/en/3.1.x/installation.html#building-on-linux)

    sudo apt-get install libtiff5-dev libjpeg8-dev zlib1g-dev \
        libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk

然后 :

    pip install -r requirements.txt
（注意如果使用python3，还需要pip install python3-memcached）

配置setting.py :

    vim vmaig_blog/setting.py
设置其中的  PAGE\_NUM 每页显示文章数，EMAIL\_HOST(你用的邮箱的smtp)，EMAIL\_PORT(smtp端口)，EMAIL\_HOST\_USER(你的邮箱的用户名)，EMAIL\_HOST\_PASSWORD(你的邮箱密码)，如果要使用七牛设置好七牛的相关配置。  
**注意**：如果想用使用ssl的邮箱（比如qq邮箱），请安装django-smtp-ssl，详见https://github.com/bancek/django-smtp-ssl
```
    # 分页配置
    PAGE_NUM = 3

    # email配置
    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
    EMAIL_HOST = ''                        #SMTP地址 例如: smtp.163.com
    EMAIL_PORT = 25                        #SMTP端口 例如: 25
    EMAIL_HOST_USER = ''                   #我自己的邮箱 例如: xxxxxx@163.com
    EMAIL_HOST_PASSWORD = ''               #我的邮箱密码 例如  xxxxxxxxx
    EMAIL_SUBJECT_PREFIX = u'vmaig'        #为邮件Subject-line前缀,默认是'[django]'
    EMAIL_USE_TLS = True                   #与SMTP服务器通信时，是否启动TLS链接(安全链接)。默认是false

    DEFAULT_FROM_EMAIL = EMAIL_HOST_USER

    # 七牛配置
    QINIU_ACCESS_KEY = ''
    QINIU_SECRET_KEY = ''
    QINIU_BUCKET_NAME = ''
    
    # 网站标题等内容配置
    WEBSITE_TITLE = u'Vmaig'
    WEBSITE_WELCOME = u'欢迎来到Vmaig'
```

初始化数据库 :

    python manage.py makemigrations
    python manage.py migrate
    python manage.py createsuperuser
    
运行 :
    
    python manage.py runserver
    
    
# 生产环境部署
	
使用docker部署，首先pull下来image或者自己使用项目中Dockerfile或者Dockerfile_cn build。
	
	sudo docker pull billvsme/vmaig_blog
然后运行image  
	例子:
	
	sudo docker run -d -p 80:80 --name vmaig\
                            -e WEBSITE_TITLE='Vmaig'\
                            -e SECRET_KEY='django secret key'\
                            -e WEBSITE_WELCOME='欢迎来到vmaig'\
                            -e EMAIL_BACKEND='django.core.mail.backends.smtp.EmailBackend' \
                            -e EMAIL_HOST='smtp.163.com'\
                            -e EMAIL_PORT='25'\
                            -e EMAIL_HOST_USER='yourname@163.com'\
                            -e EMAIL_SUBJECT_PREFIX='vmaig'\
                            -e EMAIL_HOST_PASSWORD='yourpassword'\
                            -e QINIU_ACCESS_KEY='your_as_key'\
                            -e QINIU_SECRET_KEY='your_sr_key'\
                            -e QINIU_URL='your_url'\
                            -e QINIU_BUCKET_NAME='your_bucket_name'\
                            billvsme/vmaig_blog
    
**环境变量**:  
其中：EMAIL_HOST，EMAIL_PORT，EMAIL_HOST_USER，EMAIL_HOST_PASSWORD是必须的，如果不指定，用户注册不了

	WEBSITE_TITLE  网站的title
	WEBSITE_WELCOME  首页显示的欢迎消息
	
	EMAIL_BACKEND  email的引擎，默认是django.core.mail.backends.smtp.EmailBackend，如果想支持qq邮箱请使用django_smtp_ssl.SSLEmailBackend
	EMAIL_HOST  SMTP地址
	EMAIL_PORT  SMTP端口
	EMAIL_HOST_USER  邮箱名称
	EMAIL_HOST_PASSWORD  邮箱密码
	EMAIL_SUBJECT_PREFIX  邮件Subject-line前缀
	
	# 默认头像保存在服务器，如果想保存在七牛中要定义下面这些环境变量
	QINIU_ACCESS_KEY  七牛的access key
	QINIU_SECRET_KEY  七牛的secret key
	QINIU_BUCKET_NAME  七牛的bucket
	QINIU_URL  七牛的url
	
运行后，默认管理员用户名为 admin，密码为 password ， 请登录 http://your-domain/admin 更改密码。                   

#接下来该干什么？
在浏览器中输入 http://127.0.0.1:8000/admin  
输入前面初始化数据库时的用户名密码。  
后台中，可以  
通过“轮播”添加首页的轮播  
通过“导航条”添加首页nav中的项目  
通过“专栏” 添加博客专栏（可以和导航条结合起来）  
通过“资讯” 添加转载的新闻  
通过“分类” “文章” 添加分类跟文章  
通过“用户” 对用户进行操作  

**特别注意**
首页的便签云中的内容，在后台不能修改。
请修改  blog/templates/blog/widgets/tags_cloud.html 中的 tags数组的内容。



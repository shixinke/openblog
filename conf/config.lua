local config = {
    version = '0.0.1',
    debug = true,                               -- 是否开启debug模式
    database = {                                -- 数据库配置
        host = '127.0.0.1',
        port = 3306,
        user = 'root',
        password = '123456',
        database = 'thinklua_blogdb',
        table_prefix = 'blog_',
        charset = 'utf8',
        timeout = 1000,
        max_idle_timeout = 6000,
        pool_size = 100
    },
    cache = {                                   -- redis缓存设置
        host = '127.0.0.1',
        port = 6379,
        timeout = 1000,
        max_idle_timeout = 6000,
        pool_size = 1000
    },
    routes = {                                   -- 路由相关设置
        default_controller = 'index',            -- 默认控制器
        router_status = 'on',                    -- 自定义路由是否开启
        layer_status = 'on',
        theme_status = 'on',
        layers = {
            admin = {
                theme_status = 'off',
                router_status = 'off'
            }
        },                        -- 控制器使用层(目录)，所有的目录以,隔开
        url_suffix = '.html',                    -- 路径后缀，如http://thinklua.shixinke.com/blog/index.html
        view_suffix = '.html',                   -- 模板后缀(可以使用自定义后缀)
        rules = {                                -- 自定义路由规则
            {method = 'get', pattern = '/page-([0-9]+).html', url = '/index/index?page=$1'},
            {method = 'get', pattern = '/date-([0-9]+-[0-9]+).html', url='/posts/archive?alias=$1'},
            {method = 'get', pattern = '/topic/:alias', url = '/posts/topic'},
            {method = 'get', pattern = '/search/:key', url = '/search/index'},
            {method = 'get', pattern = '/tags-([^\\s]+).html', url = '/posts/tag?alias=$1'},  -- 支持正则表达式
            {method = 'get', pattern = '/category-([^\\s]+).html', url = '/posts/category?alias=$1'},  -- 支持正则表达式
            {method = 'get', pattern = '/:category/:alias', url = '/posts/detail'},                   -- 支持都是模糊匹配的(只支持一个)
        }
    },
    hooks = {
        topbar = {
            title = '顶部栏',
            position = 'header',
            max = 1,
            width = 12
        },
        logo = {
            title = 'LOGO',
            position = 'header',
            max = 1,
            width = 3
        },
        navbar = {
            title = '导航栏',
            position = 'header',
            max = 1,
            width = 6
        },
        searchbar = {
            title = '导航边栏',
            position = 'header',
            max = 1,
            width = 3
        },
        beforeContent = {
            title = '内容前置区',
            position = 'main',
            max = -1,
            width = 12
        },
        content = {
            title = '内容区',
            position = 'main',
            max = 1,
            width = 12,
            disabled = true
        },
        afterContent = {
            title = '内容后置区',
            position = 'main',
            max = 1,
            width = 12
        },
        sidebar = {
            title = '右边栏',
            position = 'aside',
            max = 0,
            width = 12
        },
        footerbar = {
            title = '页脚',
            position = 'footer',
            max = -1,
            width = 12
        },
        custombar = {
            title = '自由区',
            position = 'custom',
            max = -1,
            width = 12
        }
    },
    views = {
        file_suffix = '.html',

    },
    cookie = {
        domain = 'localhost'
    },
    security = {                                 -- 安全相关的设置
        password_salt = 'shixinke',              -- 密码加密字符串
        session = {
            secret = 'kdkdikekdldinfk23456'
        }
    },
    pages = {                                    -- 页面的相关配置
        charset = 'UTF-8',                       -- 页面编码
        not_found = '/404.html',                 -- 404页面地址
        server_error = '/server_busy.html',       -- 50x页面地址
        login_page = '/admin/passport/login',
        register = 'on'
    },
    sys = {
        -- 硬盘挂载目录
        disk = {
            system = '/',
            data = '/'
        }
    }

}
return config;

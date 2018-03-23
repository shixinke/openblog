local app = require 'system.app'
local config_service = require 'service.config'
local component = require 'components.component'
local stats = require 'service.stats'
local function init_config()
    local config_init = registry:get('config_init')
    if config_init == 1 then
        return
    end
    local items = config_service.items({'site_name', 'site_subtitle', 'site_title', 'site_keywords', 'site_description', 'default_theme', 'author_nickname', 'author_avatar', 'author_github', 'author_weibo', 'author_email'})
    local length = 0
    for k, v in pairs(items) do
        length = length + 1
        registry:set(k, v)
    end
    if length > 0 then
        registry:set('config_init', 1)
    end
end

local function init_components()
    local component_init = registry:get('component_init')
    if component_init == 1 then
        return
    end
    local items = component.loads()
    registry:set('components', items)
    registry:set('component_init', 1)
end

local function init_view_data()
    local view_data_init = registry:get('view_data_init')
    if view_data_init == 1 then
        return
    end
    local counts = stats.count()
    local common_data = {
        site_name = '',
        site_subtitle = '',
        title = '',
        keywords = '',
        description = '',
        navId = 0
    }
    common_data.site_name = registry:get('site_name')
    common_data.site_subtitle = registry:get('site_subtitle')
    common_data.title = registry:get('site_title')
    common_data.keywords = registry:get('site_keywords')
    common_data.description = registry:get('site_description')
    common_data.author_nickname = registry:get('author_nickname')
    common_data.author_avatar = registry:get('author_avatar')
    common_data.author_email = registry:get('author_email')
    common_data.author_weibo = registry:get('author_weibo')
    common_data.author_github = registry:get('author_github')
    common_data.posts_count = counts.posts
    common_data.tags_count = counts.tags
    common_data.category_count = counts.category
    registry:set('view_data', common_data)
    registry:set('view_data_init', 1)
end

init_config()
init_components()
init_view_data()

app.run()
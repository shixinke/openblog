local _M = {_VERSION = '0.01' }
local tag = require 'models.tag':new()
local posts = require 'models.posts':new()
local comment = require 'models.comment':new()
local topic = require 'models.topic':new()
local category = require 'models.category':new()
local os_date = os.date
local time = ngx.time

function _M.overview()
    local total = {tags = 0, posts = 0, views = 0, comments = 0}
    local tag_count, err = tag:where({status = 1}):count()
    if not tag_count and err then
        func.error_log(err)
    end
    local post_count, err = posts:where({type = 1}):count()
    if not post_count and err then
        func.error_log(err)
    end
    local post_views, err = posts:views()
    if not post_views and err then
        func.error_log(err)
    end
    local comment_count, err = comment:count()
    if not comment_count and err then
        func.error_log(err)
    end
    total.tags = tonumber(tag_count)
    total.posts = tonumber(post_count)
    total.views = tonumber(post_views)
    total.comments = tonumber(comment_count)
    return total
end

function _M.hot()
    local stats = {
        postsList = {},
        topicList = {},
        tagList = {},
        categoryList = {}
    }
    local posts_list = posts:where({type = 1}):order('comments', 'DESC'):order('views', 'DESC'):limit(10):findAll()
    local topic_list = topic:order('posts', 'DESC'):limit(10):findAll()
    local tag_list = tag:where({status = 1}):order('items', 'DESC'):limit(10):findAll()
    local category_list = category:where({status = 1}):order('items', 'DESC'):limit(10):findAll()
    stats.topicList = topic_list
    stats.postsList = posts_list
    stats.tagList = tag_list
    stats.categoryList = category_list
    return stats
end

function _M.daily()
    local daily_data = {
        posts = 0,
        tags = 0,
        comments = 0
    }
    local today = os_date('%Y-%m-%d', time())
    local daily_posts = posts:query('SELECT COUNT(*) AS total FORM '..posts:get_table_name()..' WHERE DATEDIFF(create_time, '..today..') = 0')
    local daily_tags = tag:query('SELECT COUNT(*) AS total FORM '..tag:get_table_name()..' WHERE DATEDIFF(create_time, '..today..') = 0')
    local daily_comments = comment:query('SELECT COUNT(*) AS total FORM '..comment:get_table_name()..' WHERE DATEDIFF(create_time, '..today..') = 0')
    if daily_posts and type(daily_posts) == 'table' then
        daily_data.posts = daily_posts[1] and tonumber(daily_posts[1].total) or 0
    end
    if daily_tags and type(daily_tags) == 'table' then
        daily_data.tags = daily_tags[1] and tonumber(daily_tags[1].total) or 0
    end
    if daily_comments and type(daily_comments) == 'table' then
        daily_data.comments = daily_comments[1] and tonumber(daily_comments[1].total) or 0
    end
    return daily_data
end

function _M.count()
    local tab = {posts = 0, category = 0, tags = 0}
    local tag_count, err = tag:where({status = 1}):count()
    if not tag_count and err then
        func.error_log(err)
    end
    local post_count, err = posts:where({type = 1}):count()
    if not post_count then
        func.error_log(err)
    end
    local category_count, err = category:where({status = 1}):count()
    tab.posts = post_count
    tab.tags = tag_count
    tab.category = category_count
    return tab
end

return _M
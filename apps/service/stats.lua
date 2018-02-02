local _M = {_VERSION = '0.01' }
local tag = require 'models.tag':new()
local posts = require 'models.posts':new()
local comment = require 'models.comment':new()

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
    total.tags = tag_count
    total.posts = post_count
    total.views = post_views
    total.comments = comment_count
    return total
end

return _M
local _M = {_VERSION = '0.01' }
local posts = require 'models.posts':new()
local tagRelation = require 'models.tag_relation':new()
local tag = require 'service.tag'
local category = require 'service.category'
local topic = require 'service.topic'
local substr = string.sub
local tostring = tostring

local function format_datalist(datalist)
    local taglist = tag.taglist()
    local categorylist = category.categorylist()
    categorylist = func.array_column(categorylist, 'categoryId')
    taglist = func.array_column(taglist, 'tagId')
    for i, v in pairs(datalist) do
        if categorylist[tostring(v.categoryId)] then
            local category_info = categorylist[tostring(v.categoryId)]
            datalist[i].url = '/'..category_info.alias..'/'..v.alias
        end
        if type(v.tags) ~= 'table' then
            v.tags = cjson.decode(v.tags)
        end
        if v.tags then
            for _, t in pairs(v.tags) do
                if taglist[tostring(t)] then
                    datalist[i].tags[#datalist[i].tags + 1] = taglist[tostring(t)]
                end
            end
        end
    end
    return datalist
end

function _M.search(condition, page, pagesize)
    local tab = func.page_util(page, pagesize)
    local datalist = posts:search(condition, tab.offset, tab.limit)
    if datalist.list then
        for i, v in pairs(datalist.list) do
            datalist.list[i] = func.table_camel_style(datalist.list[i])
            if v.tags and v.tags ~= '' then
                datalist.list[i].tags = cjson.decode(v.tags)
            else
                datalist.list[i].tags = nil
            end
        end
    end
    return datalist
end

function _M.homepage(page, pagesize)
    local datalist =  _M.search({is_page =0, type = 1}, page, pagesize)
    if datalist then
        datalist.list = format_datalist(datalist.list)
    end
    return datalist
end

function _M.lists_by_tag(alias, page, pagesize)
    local info = tag.get_by_alias(alias)
    if not info then
        return nil, '标签不存在'
    end
    local tab = func.page_util(page, pagesize)
    local count_sql = 'SELECT COUNT(*) AS total FROM blog_posts WHERE posts_id IN (SELECT posts_id FROM blog_tag_relation WHERE tag_id = '..info.tag_id..')'
    local sql = 'SELECT * FROM blog_posts WHERE posts_id IN (SELECT posts_id FROM blog_tag_relation WHERE tag_id = '..info.tag_id..') LIMIT '..tab.offset..','..tab.limit
    local count = posts:query(count_sql)
    local datalist = posts:query(sql)
    local resp = {info = info, datalist = {}}
    local tab = {total = 0, list = {} }
    if count and count[1] then
        tab.total = tonumber(count[1]['total'])
    end
    if datalist then
        tab.list = format_datalist(datalist)
    end
    resp.datalist = tab
    return resp
end

function _M.lists_by_category(alias, page, pagesize)
    local info = category.get_by_alias(alias)
    if not info then
        return nil, '分类不存在'
    end
    local tab = func.page_util(page, pagesize)
    local count_sql = 'SELECT COUNT(*) AS total FROM blog_posts WHERE category_id = '..info.categoryId
    local sql = 'SELECT * FROM blog_posts WHERE category_id = '..info.categoryId..' LIMIT '..tab.offset..','..tab.limit
    local count = posts:query(count_sql)
    local datalist = posts:query(sql)
    local resp = {info = info, datalist = {}}
    local tab = {total = 0, list = {} }
    if count and count[1] then
        tab.total = tonumber(count[1]['total'])
    end
    if datalist then
        tab.list = format_datalist(datalist)
    end
    resp.datalist = tab
    return resp
end

function _M.lists_by_archive(alias, page, pagesize)
    if not alias then
        return nil, '日期不存在'
    end
    local tab = func.page_util(page, pagesize)
    local count_sql = 'SELECT COUNT(*) AS total FROM blog_posts WHERE DATE_FORMAT(create_time, "%Y-%m")="'..alias..'"'
    local sql = 'SELECT * FROM blog_posts WHERE DATE_FORMAT(create_time, "%Y-%m")="'..alias..'" LIMIT '..tab.offset..','..tab.limit
    local count = posts:query(count_sql)
    local datalist = posts:query(sql)
    local resp = {info = {title = ""}, datalist = {}}
    local tab = {total = 0, list = {} }
    if count and count[1] then
        tab.total = tonumber(count[1]['total'])
    end
    if datalist then
        tab.list = format_datalist(datalist)
    end
    resp.datalist = tab
    return resp
end

function _M.lists_by_topic(alias, page, pagesize)
    local info = topic.get_by_alias(alias)
    if not info then
        return nil, '专题不存在'
    end
    local tab = func.page_util(page, pagesize)
    local count_sql = 'SELECT COUNT(*) AS total FROM blog_posts WHERE posts_id IN (SELECT posts_id FROM blog_topic_relation WHERE topic_id = '..info.topicId..')'
    local sql = 'SELECT * FROM blog_posts WHERE posts_id IN ((SELECT posts_id FROM blog_topic_relation WHERE topic_id = '..info.topicId..') LIMIT '..tab.offset..','..tab.limit
    local count = posts:query(count_sql)
    local datalist = posts:query(sql)
    local resp = {info = info, datalist = {}}
    local tab = {total = 0, list = {} }
    if count and count[1] then
        tab.total = tonumber(count[1]['total'])
    end
    if datalist then
        tab.list = format_datalist(datalist)
    end
    resp.datalist = tab
    return resp
end

function _M.lists(limit)
    local datalist = posts:lists(limit)
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.detail(id)
    local data = posts:detail(id)
    if data then
        data = func.table_camel_style(data)
        data.author = tonumber(data.author)
    end
    return data
end

function _M.add(data)
    local tags = data.tags
    if data.tags then
        data.tags = nil
    end
    local id = posts:add(data)
    if id and tags then
        tagRelation:add_tags(id, tags)
    end
    return id
end

function _M.update(data)
    local tags = data.tags
    if data.tags then
        data.tags = nil
    end

    local id = posts:edit(data)
    if id then
        local res = tagRelation:remove(data.posts_id)
        if res then
            tagRelation:add_tags(data.posts_id, tags)
        end
    end
    return id
end

function _M.delete(postsId)
    return posts:remove(postsId)
end

function _M.topic(topicId)
    local datalist =  posts:topic(topicId)
    if datalist then
        datalist = func.array_camel_style(datalist)
    end
    return datalist
end

function _M.archive()
    local data =  posts:archive()
    if data then
        for i, v in pairs(data) do
            local tmp = tostring(v.archive)
            local year = substr(tmp, 0, 4)
            local month = substr(tmp, -2)
            data[i].year = year
            data[i].month = month
            data[i].url = '/date-'..year..'-'..month..config.routes.url_suffix
            data[i].title = year..'年'..month..'月';
        end
    end
    return data
end

function _M.category_related_list(category_id, limit, category_info)
    local datalist =  posts:where({category_id = category_id, type = 1, is_page = 0}):limit(limit):findAll()
    if datalist then
        for i, v in pairs(datalist) do
            datalist[i].url = '/'..category_info.alias..'/'..v.alias
        end
    end
    return datalist
end

function _M.topic_related_list(posts_id, category_info)
    local sql = 'select posts_id, alias, title from blog_posts where posts_id IN (select DISTINCT posts_id from blog_topic_relation where topic_id = (SELECT topic_id from blog_topic_relation where posts_id='..posts_id..' limit 1)) and type=1 and is_page = 0 '
    local datalist =  posts:query(sql)
    if datalist then
        for i, v in pairs(datalist) do
            datalist[i].url = '/'..category_info.alias..'/'..v.alias
        end
    end
    return datalist
end

function _M.deep(alias)
    local info = posts:where({alias = alias}):find()
    local data, err = "文章不存在"
    if info then
        if info.type == 0 then
            err = "文章不存在"
        else
            data = {}
            data.info = func.table_camel_style(info)
            if info.is_page ~= 1 then
                local category_info = category.detail(info.category_id)
                if category_info then
                    data.info.url = '/'..category_info.alias..'/'..info.alias
                    data.category = category_info
                    data.category.url = '/category-'..category_info.alias
                    if config.routes.url_suffix then
                        data.category.url = data.category.url..config.routes.url_suffix
                    end
                end
                if info.tags and info.tags ~= '' then
                    local tags = cjson.decode(info.tags)
                    local tags_list = tag.get_tags(tags)
                    if tags_list then
                        data.info.tags = tags_list
                    end
                else
                    data.info.tags = nil
                end
                data.categoryRelatedList = _M.category_related_list(info.category_id, 5, category_info)
                data.topicRelatedList = _M.topic_related_list(info.posts_id, category_info)
            end
        end
    end
    return data, err
end

return _M
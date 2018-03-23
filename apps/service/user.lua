local _M = {_VERSION = '0.01' }
local user = require 'models.user':new()
local session = require 'system.session'
local region = require 'resty.ip2region.ip2region':new({dict = 'blog_dict'})


function _M.checklogin(account, password)
    local user_info, err = user:checklogin(account, password)
    if not user_info then
        return nil, err
    end
    local update_data = {
        uid = user_info.uid,
        last_login_ip = func.get_client_ip(),
        last_login_time = func.datetime()
    }
    local rows, err = user:edit(update_data)
    if rows then
        user_info.password = nil
        session.set('login_user', user_info)
        return user_info
    else
        return nil, '更新登录信息失败'
    end
end

function _M.save_profile(data)
    local user_info = session.get('login_user')
    if not user_info or not user_info.uid or user_info.uid < 1 then
        return nil, '用户未登录'
    end
    data.uid = user_info.uid
    local rows, err = user:edit(data)
    if rows then
        local user_info = session.get('login_user')
        if user_info then
            user_info.nickname = data.nickname
            user_info.email = data.email
            if data.avatar then
                user_info.avatar = data.avatar
            end
            session.set('login_user', user_info)
        end
        return user_info, '保存成功'
    else
        return nil, '保存失败'
    end
end

function _M.save_password(password, uid)
    if not uid then
        local user_info = session.get('login_user')
        if not user_info or not user_info.uid or user_info.uid < 1 then
            return nil, '用户未登录'
        end
        uid = user_info.uid
    end
    local data = {}
    data.uid = uid
    data.password = func.password(password)
    local rows, err = user:edit(data)
    if rows then
        session.destroy()
        return true, '保存成功'
    else
        return nil, '保存失败'
    end
end

function _M.search(condition, page, pagesize)
    local resp = {
        list = {},
        total = 0
    }
    local tab = func.page_util(page, pagesize)
    local datalist =  user:where(condition):limit(tab.offset, tab.limit):findAll()
    if datalist then
        for i, v in pairs(datalist) do
            local ip = v.last_login_ip
            local city = ''
            if func.is_empty_str(ip) ~= true then
                local region_info = region:search(v.last_login_ip)
                city = region_info and region_info['city'] or ''
            end
            datalist[i].region = city
        end
        resp.list = func.array_camel_style(datalist)
        resp.count = user:where(condition):count()
    end
    return resp
end

function _M.lists()
    return user:where({status = 1}):findAll()
end

function _M.add(data)
    return user:add(data)
end

function _M.update(data)
    return user:edit(data)
end

function _M.delete(id)
    return user:remove(id)
end

function _M.detail(id)
    return user:detail(id)
end

return _M
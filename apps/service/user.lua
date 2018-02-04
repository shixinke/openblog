local _M = {_VERSION = '0.01' }
local user = require 'models.user':new()
local session = require 'system.session'


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

function _M.add(data)
    return user:add(data)
end

return _M
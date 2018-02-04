local session = require 'resty.session'

local _M = {
    _VERSION = '0.01'
}

local function get_session(is_set)
    local sess;
    if is_set then
        sess = session.start({secret = config.security.session.secret, cookie = config.cookie})
    else
        sess = session.open({secret = config.security.session.secret, cookie = config.cookie})
    end
    return sess
end

-- 设置session的封闭(依赖于lua-resty-session)
function _M.set(key, value)
    local sess = get_session(true)
    if not sess then
        return nil, 'start session false'
    end
    if sess.data[key] then
        if type(value) == 'table' then
            for k, v in pairs(value) do
                sess.data[key][k] = v
            end
        else
            sess.data[key] = value
        end
    else
        sess.data[key] = value
    end

    return sess:save()
end

-- 获取session信息
function _M.get(key)
    local sess = get_session(false)
    if not sess then
        return nil, 'start session false'
    end
    ngx.log(ngx.ERR, cjson.encode(sess.data))
    local data = sess.data or {}
    if key then
        return data[key]
    end
    return data
end

function _M.destroy()
    local sess = get_session(true)
    if not sess then
        return nil, 'start session false'
    end
    sess:destroy()
end

return _M
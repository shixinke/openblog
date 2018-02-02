
local function test_time()
    ngx.say(func.time('2018-01-30 10:30:21'))
end

local function test()
    test_time()
end

test()
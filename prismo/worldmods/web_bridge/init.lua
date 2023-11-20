
local http = minetest.request_http_api()
local settings = minetest.settings

local port = settings:get('web_bridge.port') or 45001
local timeout = 10

local http_api = {}

-- validations
if http then
    http_api = dofile(minetest.get_modpath(minetest.get_current_modname()).."/http_lib.lua")(http_api)
    print("[WebBridge] Bridge started...")
else
    print("[WebBridge] Failed to get the HTTP API!")
    return
end


-- mod polls web-server for tasks every 3s
-- task : cmd, msg, announce

local http = minetest.request_http_api()
if not http then
    print("[web_bridge] mod not allowed to use the http api, aborting")
    return
end
print("[web_bridge] initializing...")

web_bridge = {
    -- network = host mode doesn't work on m1 macs
    url = minetest.settings:get("web_bridge.url") or "http://localhost:5000",
    key = minetest.settings:get("web_bridge.key") or "smk-secret-key"
}

local MP = minetest.get_modpath("web_bridge")
local timeout = 10

-- mod polls web-server for tasks every 3s
-- task : cmd, msg, announce
loadfile(MP.."/bridge_rx.lua")(http)
loadfile(MP.."/bridge_tx.lua")(http)

dofile(MP.."/common.lua")
dofile(MP.."/handlers/execute_command.lua")
dofile(MP.."/handlers/heartbeat.lua")
-- dofile(MP.."/handlers/exception.lua")
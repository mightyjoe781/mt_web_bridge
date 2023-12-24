local http = ...

-- list of commands to send
local commands = {}

-- asnyc send triggered
local send_triggered = false

local function send_commands()
    http.fetch({
        url = web_bridge.url .. "/api/bridge",
        extra_headers = {
            "Api-Key: " .. web_bridge.key
        },
        timeout = 10,
        method = "POST",
        data = minetest.write_json(commands)
    }, function(res)
        if not res.succeeded or res.code ~= 200 then
            minetest.log("error", "[web_bridge] failed to send command, " ..
                "status: " .. res.code .. " response: " .. (res.data or "<none>"))
        end
    end)

    -- clear commands list
    commands = {}
    -- reset triggered state
    send_triggered = false
end

-- queues a command to send to the ui
function web_bridge.send_command(cmd, flush)
    -- enqueue
    table.insert(commands, cmd)
    if flush then
        -- high prio
        send_commands()
    elseif not send_triggered then
        -- low prio
        -- defer sending of commands
        minetest.after(1, send_commands)
        send_triggered = true
    end
end
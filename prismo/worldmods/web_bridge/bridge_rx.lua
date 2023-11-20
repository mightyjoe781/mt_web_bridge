local http = ...

local command_handlers = {}

function web_bridge.register_on_command(type, handler)
    command_handlers[type] = handler
end

-- fetch commands from the ui
local function fetch_commands()
    http.fetch({
        url = web_bridge.url .. "/api/bridge",
        extra_headers = {
            "Api-Key: " .. web_bridge.key
        },
        timeout = 30,
        method = "GET"
    }, function(res)
        if res.succeeded and res.code == 200 and res.data ~= "" then
            local command_list = minetest.parse_json(res.data)
            for _, cmd in ipairs(command_list) do
                local handler = command_handlers[cmd.type]
                if type(handler) == "function" then
                    local send = function(data)
                        web_bridge.send_command({
                            type = cmd.type,
                            id = cmd.id,
                            data = data
                        }, true)
                    end

                    local response = handler(cmd.data, send)
                    if response then
                        -- send synchronous response
                        send(response)
                    end
                end
            end

            minetest.after(0, fetch_commands)
        else
            print("[web_bridge] bridge error: " .. res.code)
            minetest.after(10, fetch_commands)
        end
    end)
end

minetest.after(1, fetch_commands)
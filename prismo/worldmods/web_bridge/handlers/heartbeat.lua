web_bridge.register_on_command("heartbeat", function(data)
    local result = true
    local msg = "Heartbeat OK!"
    local message = web_bridge.strip_escapes(msg)
    return { success = result, message = msg}
end)
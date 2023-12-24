
web_bridge.register_on_command("execute_command", function(data)
	local found, _, commandname, params = data.command:find("^([^%s]+)%s(.+)$")
	if not found then
		commandname = data.command
	end

	local cmd = minetest.registered_chatcommands[commandname]
	if not cmd then
		return { success=false, message="invalid command" }
	end

	if cmd.privs and not minetest.check_player_privs(data.playername, cmd.privs) then
		return { success=false, message="not enough privileges" }
	end

	local result, message
	local status, err = pcall(function()
		result, message = cmd.func(data.playername, (params or ""))
	end)

	if not status then
		return { success=false, message="Command crashed: " .. dump(err) }
	end

	-- strip control chars from message
	message = web_bridge.strip_escapes(message)
	return { success = result, message = message }
end)
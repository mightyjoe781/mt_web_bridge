
-- Strips any kind of escape codes (translation, colors) from a string
-- https://github.com/minetest/minetest/blob/53dd7819277c53954d1298dfffa5287c306db8d0/src/util/string.cpp#L777
-- https://github.com/Uberi/Minetest-WorldEdit/blob/abc9efeeb8cccb3e23c055414941fed4a9871b9a/worldedit_commands/init.lua
function web_bridge.strip_escapes(input)
	if not input then
		return ""
	end
	local s = function(idx) return input:sub(idx, idx) end
	local out = ""
	local i = 1
	while i <= #input do
		if s(i) == "\027" then -- escape sequence
			i = i + 1
			if s(i) == "(" then -- enclosed
				i = i + 1
				while i <= #input and s(i) ~= ")" do
					if s(i) == "\\" then
						i = i + 2
					else
						i = i + 1
					end
				end
			end
		else
			out = out .. s(i)
		end
		i = i + 1
	end
	return out
end

function web_bridge.sanitize_ip(ip)
	if ip and string.sub(ip, 1, 7) == "::ffff:" then
		-- trim leading garbage
		return string.sub(ip, 8)
	end

	-- keep it as-is
	return ip
end

function outputTable(data)
	if type(data) ~= "table" then
		return
	end
	
	print('{')
	local first = true
	for k, v in pairs(data) do
		if not first then print(',') end
		
		first = false
		print('"' .. k .. '":')
		if type(v) == 'table' then
			outputTable(v)
		else
		    local str = tostring(v)
			str = string.gsub(str, '"', '\\"')
			str = string.gsub(str, '\n', '\\n')
			print('"' .. str .. '"')
		end
	end
	print('}')
end

if (#arg ~= 1) then
	print("Usage: " .. arg[-1] .. " " .. arg[0] .. " <config file with lua table fromat>")
	return
end

local data = dofile(arg[1])
outputTable(data)

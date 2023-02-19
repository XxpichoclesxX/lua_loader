util.keep_running()

local stand = menu
local util = _G["util"]
local filesystem = _G["filesystem"]

local og_g_keys = {}
for k, v in pairs(_G) do
	og_g_keys[k] = true
end

stand.action(stand.my_root(), "Reset State", {}, "", function()
	-- reset stand runtime
	util.keep_running()
	-- reset global vars to avoid scripts crying about already being loaded
	for k, v in pairs(_G) do
		if og_g_keys[k] == nil then
			_G[k] = nil
		end
	end
	-- restarts the entire script so it can load
	util.restart_script()
end)

local settings_list = stand.list(stand.my_root(), "Settings", {}, "")

-- This will tell how to start 2take1 scripts into appdata
local no_scripts = true
local lua_list = stand.list(stand.my_root(), "Load Scripts", {}, "", function()
	if no_scripts then
		util.toast("Put luas made for 2Take1Menu into the %appdata%\\Stand\\From 2Take1Menu\\scripts folder, then hit \"Reset State\" to refresh.")
	end
end)
local dir = filesystem.stand_dir() .. "From 2Take1Menu\\"
if not filesystem.is_dir(dir) then
	filesystem.mkdir(dir)
end
if not filesystem.is_regular_file(dir.."2Take1Menu.ini") then
	local f = io.open(dir.."2Take1Menu.ini", "w")
	f:write("[Keys]\nMenuRight=NUM6\nMenuSelect=NUM5\nMenuDown=NUM2\nMenu=NUM-\nMenuUp=NUM8\nMenuLeft=NUM4\nMenuBack=NUM0\nMenuTabPrev=NUM7\nMenuTabNext=NUM9")
	f:close()
end
dir = dir .. "scripts\\"
if not filesystem.is_dir(dir) then
	filesystem.mkdir(dir)
end
local created_divider = false
for i, path in ipairs(filesystem.list_files(dir)) do
	if filesystem.is_regular_file(path) then
		no_scripts = false
		path = string.sub(path, string.len(dir) + 1)
		stand.action(lua_list, path, {}, "", function()
			local og_toast = util.toast
			local silent_start = true
			util.toast = function(...)
				silent_start = false
				return og_toast(...)
			end

			local chunk, err = loadfile(dir .. path)
			local status
			if chunk then
				if not created_divider then
					created_divider = true
					stand.divider(stand.my_root(), "Script Features")
				end
				if status then
					if silent_start then
						util.toast("Successfully loaded " .. path)
					end
					return
				end
			end
			util.toast(tostring(err or "no further error information"), TOAST_ALL)
		end)
	end
end


local credits = stand.list(stand.my_root(), "Credits", {}, "")

stand.action(credits, "moonlightlotuos", {}, "The pioneer of this script.", function()
end)
stand.action(credits, "XYGTA5", {}, "Added some 2take1 scripts.", function()
end)
stand.action(credits, "InfiniteCod3", {}, "Also added 2take1 scripts.", function()
end)
stand.action(credits, "XxRagulxX", {}, "Some installation guides.", function()
end)
stand.action(credits, "Wigger", {}, "Main script tester.", function()
end)
stand.action(credits, "Pichocles", {}, "Added natives libraries and helped with compatibility.", function()
end)

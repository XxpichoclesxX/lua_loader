local stand = menu
local util = _G["util"]
local filesystem = _G["filesystem"]
local config = require("2take1 compat")

local og_g_keys = {}
for k, v in pairs(_G) do
	og_g_keys[k] = true
end

local function init()
	stand.action(stand.my_root(), "Reset State", {}, "", function()
		-- reset stand runtime
		util.dispatch_on_stop()
		util.stop_all_threads()
		util.keep_running()
		util.clear_commands_and_event_handlers()
		-- reset global vars to avoid scripts crying about already being loaded
		for k, v in pairs(_G) do
			if og_g_keys[k] == nil then
				_G[k] = nil
			end
		end
		-- restarts entire scripts
		util.restart_script()
	end)

	local settings_list = stand.list(stand.my_root(), "Settings", {}, "")
	stand.toggle(settings_list, "Spoof 2Take1Menu Directory", {}, "Tries to redirect access to resources from the 2Take1Menu directory to the \"From 2Take1Menu\" folder.", function (value)
		config.spoof_2take1_install_dir = value
	end, true)

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
					status, err = xpcall(chunk, function(e)
						util.toast(e)
						util.log(debug.traceback(e, 2))
					end)
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
end

local credits = stand.list(stand.my_root(), "Credits", {}, "")
menu.action(credits, "moonlightlotuos", {}, "The pioneer of this script.", function()
end)
menu.action(credits, "XYGTA5", {}, "Added some 2take1 scripts.", function()
end)
menu.action(credits, "InfiniteCod3", {}, "Also added 2take1 scripts.", function()
end)
menu.action(credits, "XxRagulxX", {}, "Some installation guides.", function()
end)
menu.action(credits, "XxpichoclesxX", {}, "Added natives libraries and helped with compatibility.", function()
end)

init()

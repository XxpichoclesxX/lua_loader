--Made by GhostOne
--v1.1.1

if GhostsHeadBlendLoaded then
	menu.notify("Cancelling", "Head Blend LUA Already Loaded", 3, 255)
	return HANDLER_POP
end
if not menu.is_trusted_mode_enabled() then
	menu.notify("Trusted Mode is not enabled, stat Head Blends will not be an option.\nEnable Trusted Mode then execute the script again to edit stat Head Blends", "Head Blend Profiles", 6, 0xff0000)
end

-- Locals
local HBstats = {
	int = {
		{"MESH_HEAD0", "shape_first"},
		{"MESH_HEAD1", "shape_second"},
		{"MESH_HEAD2", "shape_third"},
		{"MESH_TEX0", "skin_first"},
		{"MESH_TEX1", "skin_second"},
		{"MESH_TEX2", "skin_third"},
		{"HEADBLEND_DAD_BEARD", nil},
		{"HEADBLEND_DAD_BEARD_TEX", nil},
		{"HEADBLEND_DAD_EYEB", nil},
		{"HEADBLEND_DAD_HAIR", nil},
		{"HEADBLEND_DAD_HAIR_TEX", nil},
		{"HEADBLEND_MUM_EYEB", nil},
		{"HEADBLEND_MUM_HAIR", nil},
		{"HEADBLEND_MUM_HAIR_TEX", nil},
		{"HEADBLEND_MUM_MAKEUP", nil},
		{"HEADBLEND_MUM_MAKEUP_TEX", nil},
		{"HAIR_TINT", "HairColor"},
		{"EYEBROW_TINT", nil},
		{"FACIALHAIR_TINT", nil},
		{"BLUSHER_TINT", nil},
		{"LIPSTICK_TINT", nil},
		{"OVERLAY_BODY_1_TINT", nil},
		{"SEC_OVERLAY_BODY_1_TINT", nil},
		{"SEC_HAIR_TINT", "HairHighlightColor"},
		{"SEC_EYEBROW_TINT", "Eyebrows_color"},
		{"SEC_FACIALHAIR_TINT", "FacialHair_color"},
		{"SEC_BLUSHER_TINT", "Blush_color"},
		{"SEC_LIPSTICK_TINT", "Lipstick_color"},
	},
	bool = {
		{"MESH_ISPARENT", nil}
	},
	float = {
		{"MESH_HEADBLEND", "mix_shape"},
		{"MESH_TEXBLEND", "mix_skin"},
		{"MESH_VARBLEND", "mix_third"},
		{"HEADBLEND_DOM", nil},
		{"HEADBLEND_GEOM_BLEND", "mix_shape"},
		{"HEADBLEND_OVER_BLEMISH_PC", "BodyBlemish_opactiy"},
		{"HEADBLEND_OVERLAY_BASE_PC", "SunDamage_opactiy"},
		{"HEADBLEND_OVERLAY_BEARD_PC", "FacialHair_opactiy"},
		{"HEADBLEND_OVERLAY_BLUSHER", "Blush_opactiy"},
		{"HEADBLEND_OVERLAY_DAMAGE_PC", "Complexion_opactiy"},
		{"HEADBLEND_OVERLAY_EYEBRW_PC", "Eyebrows_opactiy"},
		{"HEADBLEND_OVERLAY_MAKEUP_PC", "Makeup_opactiy"},
		{"HEADBLEND_OVERLAY_WETHR_PC", "Age_opactiy"},
		{"HEADBLEND_TEX_BLEND", "mix_skin"},
		{"HEADBLEND_VAR_BLEND", nil},
		{"HEADBLENDOVERLAYCUTS_PC", "Lipstick_opactiy"},
		{"HEADBLENDOVERLAYMOLES_PC", "Freckles_opactiy"},
		{"OVERLAY_BODY_2", nil},
		{"OVERLAY_BODY_3", nil},
		{"OVERLAY_BODY_1", nil},
		{"FEATURE_0", "Nose_width"},
		{"FEATURE_1", "Nose_height"},
		{"FEATURE_2", "Nose_length"},
		{"FEATURE_3", nil},
		{"FEATURE_4", "Nose_tip"},
		{"FEATURE_5", "Nose_bridge"},
		{"FEATURE_6", "Brow_height"},
		{"FEATURE_7", "Brow_width"},
		{"FEATURE_8", "Cheekbone_height"},
		{"FEATURE_9", "Cheekbone_width"},
		{"FEATURE_10", "Cheeks_width"},
		{"FEATURE_11", "Eyes"},
		{"FEATURE_12", "Lips"},
		{"FEATURE_13", "Jaw_width"},
		{"FEATURE_14", "Jaw_height"},
		{"FEATURE_15", "Chin_length"},
		{"FEATURE_16", "Chin_position"},
		{"FEATURE_17", "Chin_width"},
		{"FEATURE_18", "Chin_shape"},
		{"FEATURE_19", "Neck_width"},
		{"FEATURE_20", "EyeColor"}
	}
}

local parent_id_to_name = {
	"Benjamin",
	"Daniel",
	"Joshua",
	"Noah",
	"Andrew",
	"Juan",
	"Alex",
	"Isaac",
	"Evan",
	"Ethan",
	"Vincent",
	"Angel",
	"Diego",
	"Adrian",
	"Gabriel",
	"Michael",
	"Santiago",
	"Kevin",
	"Louis",
	"Samuel",
	"Anthony",
	"Hannah",
	"Audrey",
	"Jasmine",
	"Giselle",
	"Amelia",
	"Isabella",
	"Zoe",
	"Ava",
	"Camila",
	"Violet",
	"Sophia",
	"Evelyn",
	"Nicole",
	"Ashley",
	"Grace",
	"Brianna",
	"Natalie",
	"Olivia",
	"Elizabeth",
	"Charlotte",
	"Emma",
	"Claude",
	"Niko",
	"John",
	"Misty"
}

local featTable = {
	"Parent",
	"savePreset",
	headblends = {}
}
local funcTable = {}

local Options = {}
Options[0] = {name = "Blemish", on = true}
Options[1] = {name = "FacialHair", on = true}
Options[2] = {name = "Eyebrows", on = true}
Options[3] = {name = "Age", on = true}
Options[4] = {name = "Makeup", on = true}
Options[5] = {name = "Blush", on = true}
Options[6] = {name = "Complexion", on = true}
Options[7] = {name = "SunDamage", on = true}
Options[8] = {name = "Lipstick", on = true}
Options[9] = {name = "Freckles", on = true}
Options[10] = {name = "Head Blend", on = true}
Options[11] = {name = "BodyBlemish", on = true}
Options[13] = {name = "EyeColor", on = true}
Options[14] = {name = "HairHighlightColor", on = true}
Options[15] = {name = "HairColor", on = true}
Options[16] = {name = "Hair", on = true}


local FaceFeatures = {
	"Nose_width",
	"Nose_height",
	"Nose_length",
	"Nose_bridge",
	"Nose_tip",
	"Nose_bridge",
	"Brow_height",
	"Brow_width",
	"Cheekbone_height",
	"Cheekbone_width",
	"Cheeks_width",
	"Eyes",
	"Lips",
	"Jaw_width",
	"Jaw_height",
	"Chin_length",
	"Chin_position",
	"Chin_width",
	"Chin_shape",
	"Neck_width"
}
local path = utils.get_appdata_path("PopstarDevs", "").."\\2Take1Menu\\scripts\\Head_Blends\\"
local auto_apply

-- Functions
	function funcTable.SaveData(pid, defaultName)
		local status, name = input.get("Name of preset", defaultName or "", 128, 0)
		while status == 1 do
			status, name = input.get("Name of preset", defaultName or "", 128, 0)
			system.wait(0)
		end
		if status == 2 then
			return HANDLER_POP
		end
		name = name:gsub("[<>:\"/\\|%?%*]", "")
		local pedID = player.get_player_ped(pid)
		local valTable = {}
		if Options[10].on then
			valTable = ped.get_ped_head_blend_data(pedID)
			for k, v in pairs(FaceFeatures) do
				valTable[v] = ped.get_ped_face_feature(pedID, k - 1)
			end
		end
		if valTable == nil then
			menu.notify("Head Blend isn't initialized, open Head Blend in menu tab to fix.", "Head Blend Profiles\nERROR", 5, 0x0000ff)
			return HANDLER_POP
		end
		if Options[16].on then
			valTable["Hair"] = ped.get_ped_drawable_variation(pedID, 2)
		end
		if Options[15].on then
			valTable["HairColor"] = ped.get_ped_hair_color(pedID)
		end
		if Options[14].on then
			valTable["HairHighlightColor"] = ped.get_ped_hair_highlight_color(pedID)
		end
		if Options[13].on then
			valTable["EyeColor"] = ped.get_ped_eye_color(pedID)
		end
		for k, v in pairs(Options) do
			if v.on and k ~= 10 and k <= 11 then
				valTable[v.name] = ped.get_ped_head_overlay_value(pedID, k)
				valTable[v.name.."_opactiy"] = ped.get_ped_head_overlay_opacity(pedID, k)
				valTable[v.name.."_color_type"] = ped.get_ped_head_overlay_color_type(pedID, k)
				valTable[v.name.."_color"] = ped.get_ped_head_overlay_color(pedID, k)
				valTable[v.name.."_highlight_color"] = ped.get_ped_head_overlay_highlight_color(pedID, k)
			end
		end
		funcTable.save_ini(name, path, valTable)
		funcTable.addpreset(name)
	end

	function funcTable.checkifpathexists()
		if not utils.dir_exists(path) then
			utils.make_dir(path)
		end
	end
	funcTable.checkifpathexists()

	function funcTable.apply_headblend(HBTable, pedID)
		if HBTable["shape_first"] then
			ped.set_ped_head_blend_data(pedID, HBTable["shape_first"],
				HBTable["shape_second"],
				HBTable["shape_third"],
				HBTable["skin_first"],
				HBTable["skin_second"],
				HBTable["skin_third"],
				HBTable["mix_shape"],
				HBTable["mix_skin"],
				HBTable["mix_third"]
			)
		end

		if HBTable["HairColor"] or HBTable["HairHighlightColor"] then
			HBTable["HairHighlightColor"] = HBTable["HairHighlightColor"] or 0
			HBTable["HairColor"] = HBTable["HairColor"] or 0
			ped.set_ped_hair_colors(pedID, HBTable["HairColor"], HBTable["HairHighlightColor"])
		end

		if HBTable["EyeColor"] then
			ped.set_ped_eye_color(pedID, HBTable["EyeColor"])
		end

		if HBTable["Hair"] then
			ped.set_ped_component_variation(pedID, 2, HBTable["Hair"], 0, 0)
		end

		for k, v in pairs(Options) do
			if not k == 10 or k <= 11 then
				if not HBTable[v.name] then
					HBTable[v.name] = -1
					HBTable[v.name.."_opactiy"] = -1
					HBTable[v.name.."_color_type"] = -1
					HBTable[v.name.."_color"] = -1
					HBTable[v.name.."_highlight_color"] = -1
				end
				ped.set_ped_head_overlay(pedID, k, HBTable[v.name], HBTable[v.name.."_opactiy"])
				ped.set_ped_head_overlay_color(pedID, k, HBTable[v.name.."_color_type"], HBTable[v.name.."_color"], HBTable[v.name.."_highlight_color"])
			end
		end

		for k, v in pairs(FaceFeatures) do
			if HBTable[v] then
				ped.set_ped_face_feature(pedID, k - 1, HBTable[v])
			end
		end
	end

	function funcTable.addpreset(HBName)
		if featTable.headblends[HBName] then
			return
		end

		local statPreset

		if menu.is_trusted_mode_enabled() then
			statPreset = menu.add_feature(HBName, "action_value_str", featTable["statParent"], function(f)
				local HBTable = funcTable.read_ini(HBName, path)
				if f.value == 0 then
					local prefix = "MP"..stats.stat_get_int(gameplay.get_hash_key("MPPLY_LAST_MP_CHAR"), 1).."_"
					for i = 1, 20 do
						for index, HB in pairs(HBstats["int"]) do
							if HBTable[HB[2]] then
								stats.stat_set_int(gameplay.get_hash_key(prefix..HB[1]), HBTable[HB[2]], true)
							end
						end
						-- for index, HB in pairs(HBstats["bool"]) do
						-- 	stats.stat_set_bool(gameplay.get_hash_key(prefix..HB[1]), HBTable[HB[2]], true)
						-- end
						for index, HB in pairs(HBstats["float"]) do
							if HBTable[HB[2]] then
								stats.stat_set_float(gameplay.get_hash_key(prefix..HB[1]), HBTable[HB[2]], true)
							end
						end
						system.wait(0)
					end
				elseif f.value == 1 then
					if HBTable["shape_first"] and HBTable["shape_second"] then
						menu.notify("Mom: "..parent_id_to_name[HBTable["shape_first"] + 1].." - "..HBTable["shape_first"].."\nDad: "..parent_id_to_name[HBTable["shape_second"] + 1].." - "..HBTable["shape_second"], "Head Blend Profiles")
					else
						menu.notify("There is no Head Blend data saved in this file.", "Head Blend Profiles")
					end
				end
			end)
			statPreset:set_str_data({"Apply", "Notify Parent Names"})
		end

		featTable.headblends[HBName] = menu.add_feature(HBName, "action_value_str", featTable["Parent"], function(f)
			if f.value == 0 then
				funcTable.apply_headblend(funcTable.read_ini(HBName, path), player.get_player_ped(player.player_id()))
			end

			if f.value == 1 then
				--[[io.remove(path..HBName..".ini")
				menu.delete_feature(f.id)
				if statPreset then
					menu.delete_feature(statPreset.id)
				end--]]
				if f.name:match(" %[Auto Apply%]") then
					f.name = HBName
					auto_apply = nil
				else
					for k, v in pairs(featTable.headblends) do
						if v.name:match(" %[Auto Apply%]") then
							featTable.headblends[k].name = k
						end
					end
					f.name = HBName.." [Auto Apply]"
					auto_apply = funcTable.read_ini(HBName, path)
				end
			end
		end)
		featTable.headblends[HBName]:set_str_data({"Apply", "Auto Apply"})
	end

	function funcTable.write_table(tableName, tableTW, file)
		file:write("["..tableName.."]\n")
		for k, v in pairs(tableTW) do
			if type(v) == "table" then
				funcTable.write_table(k, v, file)
			else
				file:write(k..":"..tostring(v).."\n")
			end
		end
		file:write("[%end%]\n")
	end

	function funcTable.save_ini(name, filePath, tableTW, notif)
		local file = io.open(filePath..name..".ini", "w+")

		for k, v in pairs(tableTW) do
			if type(v) ~= "table" and type(v) ~= "function" then
				print(k)
				file:write(k..":"..tostring(v).."\n")
			end
		end

		for k, v in pairs(tableTW) do
			if type(v) == "table" then
				funcTable.write_table(k, v, file)
			end
		end

		if notif then
			menu.notify("Saved Successfully", "Head Blend Profiles", 3, 0x00ff00)
		end

		file:flush()
		file:close()
	end

	function funcTable.read_table(tableRT, file)
		repeat
			local line = file:read("*l")
			if line:match("%[%%end%%%]") then
				return
			elseif line:match("%[.*%]") then
				if not tableRT[tonumber(line:match("%[(.*)%]")) or line:match("%[(.*)%]")] then
					tableRT[tonumber(line:match("%[(.*)%]")) or line:match("%[(.*)%]")] = {}
				end
				funcTable.read_table(tableRT[tonumber(line:match("%[(.*)%]")) or line:match("%[(.*)%]")], file)
			elseif line:match(":(.*)") == "true" or line:match(":(.*)") == "false" then
				tableRT[tonumber(line:match("(.*):")) or line:match("(.*):")] = line:match(":(.*)") == "true"
			else
				tableRT[tonumber(line:match("(.*):")) or line:match("(.*):")] = tonumber(line:match(":(.*)")) or line:match(":(.*)")
			end
		until not line
	end


	function funcTable.read_ini(name, filePath, tableRT)
		tableRT = tableRT or {}
		if not name:match("%.ini") then
			name = name..".ini"
		end
		local file = io.open(filePath..name, "r")
		if not file then return end

		repeat
			local line = file:read("*l")
			if not line then
				break
			end
			if line:match("(.*):") then
				if line:match(":(.*)") == "true" or line:match(":(.*)") == "false" then
					tableRT[tonumber(line:match("(.*):")) or line:match("(.*):")] = line:match(":(.*)") == "true"
				else
					tableRT[tonumber(line:match("(.*):")) or line:match("(.*):")] = tonumber(line:match(":(.*)")) or line:match(":(.*)")
				end
			elseif line:match("%[.*%]") then
				if not tableRT[tonumber(line:match("%[(.*)%]")) or line:match("%[(.*)%]")] then
					tableRT[tonumber(line:match("%[(.*)%]")) or line:match("%[(.*)%]")] = {}
				end
				funcTable.read_table(tableRT[tonumber(line:match("%[(.*)%]")) or line:match("%[(.*)%]")], file)
			end
		until not line

		file:close()

		return tableRT
	end

	local oldsetting = funcTable.read_ini("Options", path)
	if oldsetting then 
		if type(oldsetting[1]) ~= "table" then
			funcTable.save_ini("Options", path, Options)
			menu.notify("Old settings overwritten.", "Head Blend Profiles", 3)
		end
	end
	oldsetting = nil

	funcTable.read_ini("Options", path, Options)

-- Parents
	featTable["Parent"] = menu.add_feature("Head Blend Profiles", "parent", 0).id
	featTable["Options"] = menu.add_feature("Options", "parent", featTable["Parent"]).id
	if menu.is_trusted_mode_enabled() then
		featTable["statParent"] = menu.add_feature("Set Stats", "parent", featTable["Parent"]).id
	end


-- Features
	menu.add_feature("Save Options", "action", featTable["Options"], function()
		funcTable.save_ini("Options", path, Options, true)
	end)


	featTable["savePreset"] = menu.add_feature("Save current Head Blend", "action", featTable["Parent"], function()
		if player.get_player_model(player.player_id()) == 0x9C9EFFD8 or player.get_player_model(player.player_id()) == 0x705E61F2 then
			funcTable.SaveData(player.player_id())
		else
			menu.notify("Character isn't a freemode model.")
		end
	end)

	menu.add_player_feature("Yoink their Head Blend", "action", 0, function(f, pid)
		if player.get_player_model(player.player_id()) == 0x9C9EFFD8 or player.get_player_model(player.player_id()) == 0x705E61F2 then
			funcTable.SaveData(pid, player.get_player_name(pid))
		else
			menu.notify("Character isn't a freemode model.")
		end
	end)

	for i, e in pairs(utils.get_all_files_in_directory(path, "ini")) do
		if e ~= "Options.ini" then
			funcTable.addpreset(e:match("^(.*)%.ini"))
		end
	end

	for k, v in pairs(Options) do
		menu.add_feature("Save "..v.name, "toggle", featTable["Options"], function(f) 
			Options[k].on = f.on
		end).on = Options[k].on
	end

-- Threads
	menu.create_thread(function()
		while true do
			if auto_apply then
				funcTable.apply_headblend(auto_apply, player.get_player_ped(player.player_id()))
			end
			system.wait(10000)
		end
	end, nil)

GhostsHeadBlendLoaded = true
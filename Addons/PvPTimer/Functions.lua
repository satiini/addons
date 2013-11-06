local addon = PvPTimer
local L = addon.Locale

local bband = bit.band
local ssub = string.sub
local smatch = string.match
local sreplace = string.gsub
local mabs = math.abs
local pairs = pairs
local type = type
local next = next
local select = select
local UnitGUID, UnitName, GetUnitName = UnitGUID, UnitName, GetUnitName
local SecondsToTime = SecondsToTime

local COMBATLOG_OBJECT_REACTION_HOSTILE = COMBATLOG_OBJECT_REACTION_HOSTILE
local COMBATLOG_OBJECT_TYPE_PET = COMBATLOG_OBJECT_TYPE_PET
local COMBATLOG_OBJECT_TYPE_GUARDIAN = COMBATLOG_OBJECT_TYPE_GUARDIAN
local COMBATLOG_OBJECT_CONTROL_PLAYER = COMBATLOG_OBJECT_CONTROL_PLAYER
local IsRatedBattleground = IsRatedBattleground
local IsInInstance = IsInInstance
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetSpellInfo = GetSpellInfo
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local emptySpell = {
	name = "",
	id = 0,
	icon = "Interface\\GossipFrame\\ActiveQuestIcon",
}

local emptyUnit = {
	name = "Unknown",
	class = "WARRIOR",
	spec = 0,
	spells = {},
}

-- converts number to time
function addon:ConvertTime(number)
	if not number or number == 0 then
		return "---"
	elseif number > 0 then
		return SecondsToTime(number)
	else
		return "-"..SecondsToTime(mabs(number))
	end
end

-- converts an RGBA color to a table
function addon:ConvertColor(color)
	if color and color.r then
		return {color.r, color.g, color.b, color.a}
	else
		return color
	end
end

-- generic table copy
function addon:CopyTable(t)
	if type(t) ~= "table" then
		return t
	end
	local new = {}
	local i, v = next(t, nil)
	while i do
		if type(v) == "table" then 
			v = addon:CopyTable(v)
		end 
		new[i] = v
		i, v = next(t, i)
	end
	return new
end

-- moves spec icon
function addon:SetIconPoint(icon, anchor, point, start)
	icon:ClearAllPoints()
	local below
	if start == "bottomleft" or start == "bottomright" then below = true end
	if point == "INSIDELEFT" then
		if below then
			icon:SetPoint("BOTTOMLEFT", anchor, "BOTTOMLEFT")
		else
			icon:SetPoint("TOPLEFT", anchor, "TOPLEFT")
		end
	elseif point == "INSIDECENTER" then
		if below then
			icon:SetPoint("BOTTOM", anchor, "BOTTOM")
		else
			icon:SetPoint("TOP", anchor, "TOP")
		end
	elseif point == "INSIDERIGHT" then
		if below then
			icon:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT")
		else
			icon:SetPoint("TOPRIGHT", anchor, "TOPRIGHT")
		end
	elseif point == "LEFT" then
		if below then
			icon:SetPoint("TOPRIGHT", anchor, "BOTTOMLEFT")
		else
			icon:SetPoint("BOTTOMRIGHT", anchor, "TOPLEFT")
		end
	elseif point == "RIGHT" then
		if below then
			icon:SetPoint("TOPLEFT", anchor, "BOTTOMRIGHT")
		else
			icon:SetPoint("BOTTOMLEFT", anchor, "TOPRIGHT")
		end
	end
end

-- returns database key for anchor
function addon:GetAnchorKey(anchor)
	if smatch(anchor, "Anchor_Arena") then
		return "Anchor_Arena"
	else
		return anchor
	end
end

-- gets timer bar color based on spell category or default anchor settings
function addon:GetBarColor(anchor, spelltype)
	local db = addon.DB.profile
	local barcolor

	if db.Anchors[anchor].Bars.TypeColor then
		barcolor = db.SpellCategories[spelltype]
	else
		barcolor = db.Anchors[anchor].Bars.Color
	end

	return barcolor
end

-- check if glyph is turned on for this spell and spec in spell config
function addon:GetGlyphSettings(spellID, spec)
	local db = addon.DB.profile.Spells
	local result = false
	
	if db[spellID] then
		if db[spellID].glyph0 and spec == 0 then
			result = true
		elseif db[spellID].glyph1 and spec == 1 then
			result = true
		elseif db[spellID].glyph2 and spec == 2 then
			result = true
		elseif db[spellID].glyph3 and spec == 3 then
			result = true
		end
	end
	
	return result
end

-- returns talent spec name, icon, color
function addon:GetSpec(class, spec)
	local specs = addon.Const.Specs
	if specs[class] and specs[class][spec] then
		return specs[class][spec]
	else
		return specs["default"]
	end
end

-- returns spec number from spec name
function addon:GetSpecNum(class, spec)
	local specs = addon.Const.Specs[class]
	if specs[1].name == spec then return 1 end
	if specs[2].name == spec then return 2 end
	if specs[3].name == spec then return 3 end
	return 0
end

-- returns spell data for the specified ID
function addon:GetSpell(spellID)
	if not spellID then return false end
	local spell = addon.Spells[spellID]

	-- is it in the database?
	if not spell then return false end
	-- is it turned off?
	local db = addon.DB.profile.Spells
	if db[spellID] and db[spellID].enabled == false then return false end

	-- get real data if it's a pointer
	if type(spell) ~= "table" then
		return addon.Spells[spell]
	end

	return spell
end

-- calculates spell cooldown with glyphs and talents
function addon:GetSpellCooldown(spellID, spec)
	local glyphed = addon:GetGlyphSettings(spellID, spec)
	local spell = addon:GetSpell(spellID)
	if not spell then return 0 end

	local cd = spell.cooldown
	if not cd or cd == 0 then return 0 end

	if spell.cooldown_g and glyphed then
		cd = cd + spell.cooldown_g
	end

	if spell.cooldown_s1 and spec == 1 then
		cd = cd + spell.cooldown_s1
	end
	if spell.cooldown_s2 and spec == 2 then
		cd = cd + spell.cooldown_s2
	end
	if spell.cooldown_s3 and spec == 3 then
		cd = cd + spell.cooldown_s3
	end
    if spell.cooldown_s4 and spec == 4 then
        cd = cd + spell.cooldown_s3
    end

    return cd
end

function addon:GetSpellType(id)
	local db = addon.DB.profile.Spells
	local spell = addon:GetSpell(id)

	if db[id] and db[id].type then
		return db[id].type
	elseif spell and spell.type then
		return spell.type
	else
		return "misc"
	end
end

-- get all spells of the player and its pet
function addon:GetUnitSpells(GUID)
	local unit = addon:GetPlayer(GUID)
	local spells = addon:CopyTable(unit.spells)

	local pet = addon:GetPet(unit.pet)
	for k, v in pairs(pet.spells) do
		spells[k] = v
	end

	return spells
end

-- gets settings based on current zone
function addon:GetZoneSetting(key, subkey)
	local db = addon.DB.profile

	-- is it enabled?
	if db[key][subkey].Enabled == false then return false end

	local zonetype = select(2, IsInInstance())
	local rated = IsRatedBattleground()

	-- arena anchors check
	if subkey == "Anchor_Arena" then
--		return (zonetype == "arena")
		return true
	end

	if zonetype == "pvp" and not rated then -- we're in a normal bg
		return db[key][subkey].BG
	elseif zonetype == "pvp" and rated then -- we're in a rated bg
		return db[key][subkey].RatedBG
	elseif zonetype == "arena" then -- we're in an arena
		return db[key][subkey].Arena
	else -- we're somewhere else
		return db[key][subkey].Else
	end
end

-- returns a player from database, creating it if doesn't exist
function addon:GetPlayer(info)
	if not info then return emptyUnit end

	local units = addon.Units
	local name, GUID
	if ssub(info, 1, 2) == "0x" then
		GUID = info
		name = addon:GetFullUnitName(GUID)
	else
		GUID = nil
		name = info
	end

	if not name then return emptyUnit end

	if not units[name] then
		units[name] = {
			fullname = name,
			GUID = GUID,
			pet = false,
			spells = {},
			class = nil,
			spec = nil,
		}
	end

	units[name].name, units[name].server = addon:SplitUnitName(name)
	if GUID then
		units[name].GUID = GUID
		units[name].class = select(2, GetPlayerInfoByGUID(GUID)) or "PRIEST"
	end

	return units[name]
end

-- returns a pet from database, creating it if doesn't exist
function addon:GetPet(GUID, name)
	local pets = addon.Pets

	if not pets[GUID] then
		pets[GUID] = {
			spells = {},
			name = name,
			class = "PRIEST",
			owner = false,
		}
	end

	return pets[GUID]
end

-- returns true if unit is hostile to player
function addon:IsHostile(flags)
	if not flags then return false end
	return (bband(flags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE)
end

-- returns true if unit is player pet
function addon:IsPlayerPet(flags)
	if not flags then return false end
	-- is it controlled by a player?
	if not bband(flags, COMBATLOG_OBJECT_CONTROL_PLAYER) == COMBATLOG_OBJECT_CONTROL_PLAYER then return false end
	-- is it a pet or guardian?
	return bband(flags, COMBATLOG_OBJECT_TYPE_PET) == COMBATLOG_OBJECT_TYPE_PET or bband(flags, COMBATLOG_OBJECT_TYPE_GUARDIAN) == COMBATLOG_OBJECT_TYPE_GUARDIAN or false
end

-- parse message and replace tags
function addon:ParseMessage(msg, unitID, spellID, stripCodes, isPet)
--[[
	%spell%     Name of the spell
	%player%    Name of the player who cast the spell
	%player2%    Name of the player who cast the spell (crossrealm)
	%spec%      Talent spec of the player who cast the spell
	%icon%      Icon of the spell
	%icon_s%    Icon of the casting player's talent spec
	%color%     Use the spell category color for the following text
	%color_c%   Use the player's class color for the following text
	%color_s%   Use the talent spec color for the following text
]]
	if not msg or msg == "" then return "" end
	-- parse color codes
	msg = sreplace(msg, "||c", "|c")
	msg = sreplace(msg, "||r", "|r")
	if not unitID then return msg end

	local name, unit, spec
	if isPet then
		unit = addon.Pets[unitID] or emptyUnit
		name = unit.name
		if unit.owner then
			local owner = addon:GetPlayer(unit.owner)
			spec = addon:GetSpec(owner.class, owner.spec)
		else
			spec = {name = "", icon = ""}
		end
	else
		unit = addon:GetPlayer(unitID)
		name = unit.name
		spec = addon:GetSpec(unit.class, unit.spec)
	end
	local spell = addon:GetSpell(spellID)
	if not spell then
		spell = emptySpell
		spell.name = "Unknown spell #"..tostring(spellID)
	end


	local color = "|cFF"..addon:RGBtoHex(addon.DB.profile.SpellCategories[spell.type] or addon.DB.profile.SpellCategories['misc'])
	local color_c = "|cFF"..addon:RGBtoHex(RAID_CLASS_COLORS[unit.class])
	local color_s = "|cFF"..addon:RGBtoHex(spec.color)

	msg = sreplace(msg, "%%spell%%", spell.name or "")
	msg = sreplace(msg, "%%player%%", unit.name or "")
	msg = sreplace(msg, "%%player2%%", unit.fullname or "")
	msg = sreplace(msg, "%%spec%%", spec.name or "")

	if stripCodes then
		-- strip any icons and colors
		msg = sreplace(msg, "%%icon%%", "")
		msg = sreplace(msg, "%%icon_s%%", "")
		msg = sreplace(msg, "%%color%%", "")
		msg = sreplace(msg, "%%color_c%%", "")
		msg = sreplace(msg, "%%color_s%%", "")
		msg = sreplace(msg, "||r", "")
		msg = sreplace(msg, "|","||")
	else
		-- insert icons and color codes
		msg = sreplace(msg, "%%icon%%", "|T"..spell.icon..":0|t")
		msg = sreplace(msg, "%%icon_s%%", "|T"..spec.icon..":0|t")
		msg = sreplace(msg, "%%color%%", color)
		msg = sreplace(msg, "%%color_c%%", color_c)
		msg = sreplace(msg, "%%color_s%%", color_s)
		msg = sreplace(msg, "||r", "|r")
	end

	return msg
end

-- convert a color to hex code for text strings
function addon:RGBtoHex(color)
	if not color or not color.r then return "FFFFFF" end
	return ("%02x%02x%02x"):format(color.r * 255, color.g * 255, color.b * 255)
end

-- strips server from unit name
function addon:SplitUnitName(unitname)
	local name, server = smatch(unitname, "(.-)%-(.*)$")

	if not name or not server then return unitname, nil	end
	return name, server
end

-- returns name-server from name or GUID
function addon:GetFullUnitName(unit)
	if not unit then return "" end
	local name, server
	if ssub(unit, 1, 2) == "0x" then
		name = select(6, GetPlayerInfoByGUID(unit))
		server = select(7, GetPlayerInfoByGUID(unit))
	else
		name, server = UnitName(unit)
	end
	if not server or server == "" then return name end
	return name.."-"..server
end

-- if player has a pet, assign it
-- pretty much a dummy function, as this method doesn't work for enemies
-- TODO: find something better
function addon:CheckPets(unit)
	-- get ID's
	local ownerID = UnitGUID(unit)
	local petID = UnitGUID(unit.."pet")
	local petName = UnitName(unit.."pet")

	if not ownerID or not petID then return end

	local owner = addon:GetPlayer(ownerID)
	local pet = addon:GetPet(petID, petName)

	owner.pet = petID
	pet.owner = ownerID
end
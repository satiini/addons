local addon = PvPTimer

local L = addon.Locale
local fb = addon.Lib.Bars
local media = addon.Lib.Media
local ACR = addon.Lib.AceConfigRegistry
local ACD = addon.Lib.AceConfigDialog
local LibStub = LibStub

-- global tables
addon.Anchors = {}
addon.AnchorIcons = {}
addon.Interface = {}
addon.Units = {}
addon.Pets = {}
addon.Groups = {}
addon.Specs = {}
addon.AnchorsLocked = true
addon.AnchorCopy = false
addon.AlertCopy = false

local testspec = "Interface\\Icons\\Spell_Magic_PolymorphChicken"
local lastZone, lastZoneType

-- copy often used stuff to local variables
local units = addon.Units
local specs = addon.Specs
local LastEvent, LastEventTime, LastEventSource, LastEventSpell

local type = type
local pairs = pairs
local smatch = string.match
local sformat = string.format
local ssub = string.sub
local sreplace = string.gsub
local tconcat = table.concat
local select = select
local wipe = wipe
local tostring, tonumber = tostring, tonumber

local UnitGUID, UnitName, UnitIsEnemy, UnitIsPlayer, UnitClass = UnitGUID, UnitName, UnitIsEnemy, UnitIsPlayer, UnitClass
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetTime = GetTime
local GetSpellInfo = GetSpellInfo
local GetSpellBaseCooldown = GetSpellBaseCooldown
local GetCurrentMapAreaID = GetCurrentMapAreaID
local RaidNotice_AddMessage, PlaySoundFile = RaidNotice_AddMessage, PlaySoundFile
local SendChatMessage = SendChatMessage
local IsAddonLoaded = IsAddonLoaded
local CombatText_AddMessage = CombatText_AddMessage
local IsRaidOfficer = IsRaidOfficer
local IsInInstance, IsRatedBattleground = IsInInstance, IsRatedBattleground
local GetNumBattlefieldScores, GetBattlefieldScore = GetNumBattlefieldScores, GetBattlefieldScore

local MSBT = MikSBT
local SCT = SCT
local SCTD = SCTD
local Parrot = Parrot
local RaidWarningFrame = RaidWarningFrame
local frame_rw = ChatTypeInfo["RAID_WARNING"]
local build = select(4, GetBuildInfo())

-- events checked
local events = {
	["PLAYER_ENTERING_WORLD"] = true,
	["ZONE_CHANGED_NEW_AREA"] = true,
 	["COMBAT_LOG_EVENT_UNFILTERED"] = true,
	["PLAYER_TARGET_CHANGED"] = true,
	["PLAYER_FOCUS_CHANGED"] = true,
	["ARENA_OPPONENT_UPDATE"] = true,
	["UPDATE_BATTLEFIELD_SCORE"] = true,
}

-- combatlog event subtypes checked
local eventtypes = {
	["SPELL_CAST_SUCCESS"] = true,
	["SPELL_SUMMON"] = true,
}

local GUID_INVALID = "0x0000000000000000"

-- saves manual changes to anchors
local function OnAnchorChange(event, anchor, ...)
	local name = addon:GetAnchorKey(anchor.name)

	if event == "FancyBar_GroupResize" then
		addon.DB.profile.Anchors[name].Width = ...

		if name == "Anchor_Arena" then
			addon:UpdateAnchorStyle(name)
		end
	elseif event == "FancyBar_GroupMove" then
		local p, f, r, x, y = ...

		if name == "Anchor_Arena" then
			local dx = addon.DB.profile.Anchors[name].Position.NextX
			local dy = addon.DB.profile.Anchors[name].Position.NextY

			if anchor.name == "Anchor_Arena2" then
				x = x - dx
				y = y - dy
			elseif anchor.name == "Anchor_Arena3" then
				x = x - dx*2
				y = y - dy*2
			elseif anchor.name == "Anchor_Arena4" then
				x = x - dx*3
				y = y - dy*3
			elseif anchor.name == "Anchor_Arena5" then
				x = x - dx*4
				y = y - dy*4
			end
		end

		addon.DB.profile.Anchors[name].Position.AttachPoint = p
		addon.DB.profile.Anchors[name].Position.AttachFrame = f
		addon.DB.profile.Anchors[name].Position.AttachRelative = r
		addon.DB.profile.Anchors[name].Position.AttachX = x
		addon.DB.profile.Anchors[name].Position.AttachY = y

		if name == "Anchor_Arena" then
			addon:UpdateAnchorStyle(name)
		end
	end
end

-- restyles bars
local function StyleBar(bar)
	local anchor = bar.group
	if not anchor then bar:Stop(); return end

	local anchorname = addon:GetAnchorKey(anchor.name)
	local db = addon.DB.profile.Anchors[anchorname]
	local dbb = db.Bars

	-- set texture
	if media:IsValid("statusbar", dbb.Texture) then
		bar:SetTexture(media:Fetch("statusbar", dbb.Texture))
	end

	-- set icons
	local icon = bar:GetData("icon")
	if dbb.IconLeft then
		bar:SetIcon(icon)
	else
		bar:SetIcon(false)
	end
	if dbb.IconRight then
		bar:SetIconRight(icon)
	else
		bar:SetIconRight(false)
	end

	-- set spec icon
	if dbb.IconSize < 8 then dbb.IconSize = 8 end
	if dbb.IconMode then
		bar:SetIcon(icon)
		bar:SetIconMode(dbb.IconSize, dbb.TimePosition, dbb.TimeOffsetX, dbb.TimeOffsetY)
	else
		bar:SetIconMode(false)
	end

	-- set bar color
	local color = addon:GetBarColor(anchorname, bar:GetData("type") or 'defensive')
	bar:SetColor(addon:ConvertColor(color))

	-- other settings
	bar:SetAlpha(dbb.Alpha)
	bar:SetSpark(dbb.Spark)
	bar:SetLabelFont(media:Fetch("font", dbb.NameFont), dbb.NameFontSize, dbb.NameFontFlags)
	bar:SetDurationFont(media:Fetch("font", dbb.TimeFont), dbb.TimeFontSize, dbb.TimeFontFlags)
	bar:SetGhost(dbb.Ghost, nil, addon:ParseMessage(dbb.GhostMessage), addon:ConvertColor(dbb.GhostBackground), media:Fetch("statusbar", dbb.GhostTexture))
	bar:SetFadeout(dbb.Fadeout, nil, addon:ParseMessage(dbb.FadeoutMessage), addon:ConvertColor(dbb.FadeoutBackground), media:Fetch("statusbar", dbb.FadeoutTexture))

	-- show/hide label text
	if dbb.NameEnable then
		bar.FB_Label:Show()
	else
		bar.FB_Label:Hide()
	end

	-- show/hide time text
	if dbb.TimeEnable then
		bar.FB_Duration:Show()
	else
		bar.FB_Duration:Hide()
	end

	-- fix any positioning problems
	bar.group:Rearrange()
end

function addon:OnInitialize()
	-- register chat commands
	addon:RegisterChatCommand("pvptimer", "ChatCommand")
	addon:RegisterChatCommand("pt", "ChatCommand")

	-- create db
	addon.DB = LibStub("AceDB-3.0"):New("PTDB", addon.Defaults, true)
	local db = addon.DB
	
	db.profile.Debug = false

	-- create options
	ACR:RegisterOptionsTable("PvPTimer", addon.Options)
	-- add profiles
	addon.Profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(db)
	addon.Options.args.Settings.args.Profiles = addon.Profiles

	addon.OptionsFrame = ACD:AddToBlizOptions("PvPTimer", "PvPTimer", nil, "Settings")

	db.RegisterCallback(addon, "OnProfileChanged", "OnEnable")
	db.RegisterCallback(addon, "OnProfileCopied", "OnEnable")
	db.RegisterCallback(addon, "OnProfileReset", "OnEnable")

	-- local LibDualSpec = LibStub("LibDualSpec-1.0")
	-- LibDualSpec:EnhanceOptions(addon.Profiles, db)

	-- create default anchors
	local anchors = addon.Anchors
	anchors["Anchor_Target"] = fb:NewGroup(300, "Target", "Anchor_Target")
	anchors["Anchor_Focus"] = fb:NewGroup(300, "Focus", "Anchor_Focus")
	anchors["Anchor_Arena1"] = fb:NewGroup(300, "Arena #1", "Anchor_Arena1")
	anchors["Anchor_Arena2"] = fb:NewGroup(300, "Arena #2", "Anchor_Arena2")
	anchors["Anchor_Arena3"] = fb:NewGroup(300, "Arena #3", "Anchor_Arena3")
	anchors["Anchor_Arena4"] = fb:NewGroup(300, "Arena #4", "Anchor_Arena4")
	anchors["Anchor_Arena5"] = fb:NewGroup(300, "Arena #5", "Anchor_Arena5")

	-- create group anchors
	anchors["Group_offensive"] = fb:NewGroup(300, L["Offensive CDs"], "Group_offensive")
	anchors["Group_defensive"] = fb:NewGroup(300, L["Defensive CDs"], "Group_defensive")
	anchors["Group_interrupt"] = fb:NewGroup(300, L["Interrupts and Silences"], "Group_interrupt")
	anchors["Group_cc"] = fb:NewGroup(300, L["Crowd Control"], "Group_cc")
	anchors["Group_root"] = fb:NewGroup(300, L["Roots and Snares"], "Group_root")
	anchors["Group_misc"] = fb:NewGroup(300, L["Miscellaneous Spells"], "Group_misc")
	anchors["Group_custom1"] = fb:NewGroup(300, sformat("%s %d", L["Custom Anchor"], 1), "Group_custom1")
	anchors["Group_custom2"] = fb:NewGroup(300, sformat("%s %d", L["Custom Anchor"], 2), "Group_custom2")
	anchors["Group_custom3"] = fb:NewGroup(300, sformat("%s %d", L["Custom Anchor"], 3), "Group_custom3")

	-- create spec icons
	local icons = addon.AnchorIcons
	icons["Anchor_Target"] = anchors["Anchor_Target"]:CreateTexture(nil, "OVERLAY")
	icons["Anchor_Focus"] = anchors["Anchor_Focus"]:CreateTexture(nil, "OVERLAY")
	icons["Anchor_Arena1"] = anchors["Anchor_Arena1"]:CreateTexture(nil, "OVERLAY")
	icons["Anchor_Arena2"] = anchors["Anchor_Arena2"]:CreateTexture(nil, "OVERLAY")
	icons["Anchor_Arena3"] = anchors["Anchor_Arena3"]:CreateTexture(nil, "OVERLAY")
	icons["Anchor_Arena4"] = anchors["Anchor_Arena4"]:CreateTexture(nil, "OVERLAY")
	icons["Anchor_Arena5"] = anchors["Anchor_Arena5"]:CreateTexture(nil, "OVERLAY")

	for k, v in pairs(anchors) do
		-- temporary hack for drag handles
		v.FG_DragHandle:SetTexture("Interface\\Addons\\PvPTimer\\Textures\\draghandle")

		v.RegisterCallback(v, "FancyBar_GroupResize", OnAnchorChange)
		v.RegisterCallback(v, "FancyBar_GroupMove", OnAnchorChange)
	end

	-- cache spell names and icons
	for k, v in pairs(addon.Spells) do
		if type(v) == "table" then
			local spellName = GetSpellInfo(k) or sformat("Spell #%d", k)
			if v.pet then
				v.name = spellName.." (Pet)"
			else
				v.name = spellName
			end
			v.icon = select(3, GetSpellInfo(k)) or ""
			v.id = k or 0
            -- get cooldowns
            if v.cooldown == nil then
                local x = GetSpellBaseCooldown(k)
                if not (x == nil) then
                    v.cooldown = x/1000
                end
            end
		end
	end

	addon.Faction = UnitFactionGroup("player")
end

function addon:OnEnable()
	local db = addon.DB
	local anchors = addon.Anchors

	--copy any missing options from default settings
	for a in pairs(anchors) do
		a = addon:GetAnchorKey(a)
		for k, v in pairs(db.global.anchor_default) do
			if db.profile.Anchors[a][k] == nil or db.profile.Anchors[a][k] == {} then
				db.profile.Anchors[a][k] = addon:CopyTable(v)
			end
		end
		for k, v in pairs(db.global.anchor_default.Bars) do
			if db.profile.Anchors[a].Bars[k] == nil or db.profile.Anchors[a].Bars[k] == {} then
				db.profile.Anchors[a].Bars[k] = addon:CopyTable(v)
			end
		end
		for k, v in pairs(db.global.anchor_default.Position) do
			if db.profile.Anchors[a].Position[k] == nil or db.profile.Anchors[a].Position[k] == {} then
				db.profile.Anchors[a].Position[k] = addon:CopyTable(v)
			end
		end
	end

	-- register events
	addon:UnregisterAllEvents()
	for k in pairs(events) do
		addon:RegisterEvent(k)
	end

	-- update anchors
	addon:RefreshAnchors()

	-- all done
	addon:Print(L["Addon loaded."])
end

function addon:ChatCommand(input)
	input = strlower(input)

	if input == "sc" or input == "spellconfig" then
		-- open spell configuration
		addon:ToggleSpellConfig()
	elseif input == "lock" then
		-- lock all anchors
		addon.AnchorsLocked = true
		addon:RefreshAnchors()
	elseif input == "unlock" then
		-- unlock all anchors
		addon.AnchorsLocked = false
		addon:RefreshAnchors()
	elseif input == "test" then
		-- run test
		addon:RunTest()
	elseif input == "reset" then
		-- reset data
		addon:ZONE_CHANGED_NEW_AREA(true)
	elseif input == "debug" then
		-- debug mode
		addon.DB.profile.Debug = not addon.DB.profile.Debug
		if addon.DB.profile.Debug then
			addon:Print("Debug Mode |CFF00FF00enabled|r. This makes the addon react to friendly players too. This option is not supported, and provided for testing purposes only!")
		else
			addon:Print("Debug Mode |CFFFF0000disabled|r.")
		end
	else
		ACD:Open("PvPTimer", "Settings")
		-- open blizzard config
--		InterfaceOptionsFrame_OpenToCategory(addon.OptionsFrame)
		-- workaround for options sometimes not opening: try again :)
--		InterfaceOptionsFrame_OpenToCategory(addon.OptionsFrame)
	end
end

-- lock/unlock all anchors
function addon:ToggleLock()
	addon.AnchorsLocked = not addon.AnchorsLocked
	addon:RefreshAnchors()
end

-- run test on all anchors
function addon:RunTest()
	for k, v in pairs(addon.Anchors) do
		v:RunTest(5)
	end
	addon:RefreshAnchors()
end

-- Refresh all anchors
function addon:RefreshAnchors(noStyle)
	local db = addon.DB.profile.Anchors
	local anchors = addon.Anchors

	-- show/hide addons unlocked frame
	if addon.AnchorsLocked then addon.LockMessage:Hide() else addon.LockMessage:Show() end

	-- move, size, style anchors unless disabled
	if not noStyle then
		for k, v in pairs(anchors) do
			addon:UpdateAnchorStyle(addon:GetAnchorKey(k))
		end
	end

	-- update them
	addon:PLAYER_TARGET_CHANGED()
	addon:PLAYER_FOCUS_CHANGED()
	addon:ARENA_OPPONENT_UPDATE()
	addon:UpdateGroupAnchors()
end

-- update all group anchors
function addon:UpdateGroupAnchors()
	local db = addon.DB.profile.Anchors
	local anchors = addon.Anchors

	for k, v in pairs(anchors) do
		if smatch(k, "Group_") then
			addon:UpdateGroupAnchor(v)
		end
	end
end

-- update a group anchor
function addon:UpdateGroupAnchor(anchor)
	local stype = ssub(anchor.name, 7)
	local spells = addon.Groups[stype] or {}

	for k, v in pairs(spells) do
		local unit = ssub(k, 1, 18)

		local unitname = select (6, GetPlayerInfoByGUID(unit))
		if not unitname or unitname == "" then unitname = "Pet" end

		local spec = 0
		if addon.Units[unit] and addon.Units[unit].spec then spec = addon.Units[unit].spec end

		local spellID = tonumber(ssub(k, 20))
		local spell = addon:GetSpell(spellID)

		if spell then
			local cd = addon:GetSpellCooldown(spellID, spec)
			local duration = v + cd - GetTime()
			if duration>0 then
				addon:UpdateSpell(anchor, spellID, duration, cd, unitname)
			end
		end
	end
end

-- updates anchor style settings
function addon:UpdateAnchorStyle(anchorname)
	local db = addon.DB.profile.Anchors
	local anchors = {}

	if anchorname == "Anchor_Arena" then
		for i = 1, 5 do
			anchors["Anchor_Arena"..i] = db[anchorname]
		end
	else
		anchors = {[anchorname] = db[anchorname]}
	end

	for k, a in pairs(anchors) do
		local v = addon.Anchors[k]
		local ap = a.Position
		local ab = a.Bars

		-- should anchor be shown in this zone?
		if addon:GetZoneSetting("Anchors", anchorname) == false then
			-- clear and hide it
			v:Clear(true)
			v:Lock(false)
			v:Hide()
		else
			-- show and update
			v:Show()
			v:Lock(addon.AnchorsLocked)

			v:ClearAllPoints()
			v:SetPoint(ap.AttachPoint, ap.AttachFrame, ap.AttachRelative, ap.AttachX, ap.AttachY)
			v:SetWidth(a.Width)
			v:SetScale(a.Scale)
			v:SetColumns(ab.Columns)
			v:SetVisibleBars(ab.MaxBars)
			v:SetStartPoint(ab.StartPoint)
			v:SetSpacing(ab.Spacing_H, ab.Spacing_V)
			if ab.IconSize < 8 then ab.IconSize = 8 end
			if ab.IconMode then
				v:SetIconMode(ab.IconSize, ab.TimePosition, ab.TimeOffsetX, ab.TimeOffsetY)
			else
				v:SetIconMode(false)
			end
		end
		addon:UpdateAnchor(v)
	end

	-- reposition arena anchors if not 1st is dragged
	if anchorname == "Anchor_Arena" then
		local x = db["Anchor_Arena"].Position.NextX
		local y = db["Anchor_Arena"].Position.NextY
		addon.Anchors["Anchor_Arena2"]:ClearAllPoints()
		addon.Anchors["Anchor_Arena3"]:ClearAllPoints()
		addon.Anchors["Anchor_Arena4"]:ClearAllPoints()
		addon.Anchors["Anchor_Arena5"]:ClearAllPoints()
		addon.Anchors["Anchor_Arena2"]:SetPoint("CENTER", addon.Anchors["Anchor_Arena1"], "CENTER", x, y)
		addon.Anchors["Anchor_Arena3"]:SetPoint("CENTER", addon.Anchors["Anchor_Arena2"], "CENTER", x, y)
		addon.Anchors["Anchor_Arena4"]:SetPoint("CENTER", addon.Anchors["Anchor_Arena3"], "CENTER", x, y)
		addon.Anchors["Anchor_Arena5"]:SetPoint("CENTER", addon.Anchors["Anchor_Arena4"], "CENTER", x, y)
	end
end

-- updates all spells on an anchor
function addon:UpdateAnchor(anchor, spells, GUID)

	local anchorname = addon:GetAnchorKey(anchor.name)
	local db = addon.DB.profile.Anchors[anchorname]

	-- clear timers, redraw test timers
	for k in pairs(anchor.bars) do
		-- is it a valid timer or just a test?
		if k:GetData("id") then
			k:Stop(true)
		else
			StyleBar(k)
		end
	end

	-- group anchors are updated elsewhere
	if smatch(anchor.name, "Group_") then return end

	local unitID = addon.Const.Units[anchor.name]

	local unitName, server = UnitName(unitID)
	if server and server ~= "" then
		unitName = unitName.."-"..server
	end
	local unit, spec
	if UnitIsPlayer(unitID) and unitName then
		unit = addon:GetPlayer(unitName)
		spec = addon:GetSpec(unit.class, unit.spec)
	end

	-- update spec icon
	local icon = addon.AnchorIcons[anchor.name]
	if spec and unit.spec and unit.spec > 0 and db.ShowSpec > 0 then
		icon:SetTexture(spec.icon)
		icon:SetWidth(db.ShowSpec)
		icon:SetHeight(db.ShowSpec)
		addon:SetIconPoint(icon, anchor, db.SpecPosition, db.Bars.StartPoint)
		icon:SetAlpha(db.SpecAlpha)
		icon:Show()
	elseif not addon.AnchorsLocked and db.ShowSpec > 0 then
		local icon = addon.AnchorIcons[anchor.name]
		icon:SetTexture(testspec)
		icon:SetWidth(db.ShowSpec)
		icon:SetHeight(db.ShowSpec)
		addon:SetIconPoint(icon, anchor, db.SpecPosition, db.Bars.StartPoint)
		icon:SetAlpha(db.SpecAlpha)
		icon:Show()
	else
		icon:Hide()
	end

	-- update spells if needed
	if not spells or not GUID then return end
	for k, v in pairs(spells) do
		if type(k) == "number" then
			local spell = addon:GetSpell(k)
			if spell then
				local cd = addon:GetSpellCooldown(k, unit.spec)
				local duration = v + cd - GetTime()
				if duration>0 then
					addon:UpdateSpell(anchor, k, duration, cd)
				end
			end
		end
	end
end

-- sends alert messages
function addon:SendAlert(event, srcGUID, dstGUID, spellID, isPet)
	local db
	if event == "spec" then
		db = addon.DB.profile.Alert['spec']
	else
		local spell = addon:GetSpell(spellID)
		local spelltype = addon:GetSpellType(spellID)
		db = addon.DB.profile.Alert[spelltype]
		if not db then db = addon.DB.profile.Alert['misc'] end
	end

	-- check if alerts are enabled for this spell type
	if db.Enabled == false then return end

	local zonetype = select(2, IsInInstance())
	local rated = IsRatedBattleground()
	local target, onlytarget, sound = false, false, false
	
	-- get alert settings based on current zone
	if zonetype == "pvp" and not rated then -- we're in a normal bg
		target = db.BG
		onlytarget = db.BG_OnlyTarget
		if db.BG_SoundEnable then
			sound = db.BG_Sound
		end
	elseif zonetype == "pvp" and rated then -- we're in a rated bg
		target = db.RatedBG
		onlytarget = db.RatedBG_OnlyTarget
		if db.RatedBG_SoundEnable then
			sound = db.RatedBG_Sound
		end
	elseif zonetype == "arena" then -- we're in an arena
		target = db.Arena
		onlytarget = db.Arena_OnlyTarget
		if db.Arena_SoundEnable then
			sound = db.Arena_Sound
		end
	else -- we're somewhere else
		target = db.Else
		onlytarget = db.Else_OnlyTarget
		if db.Else_SoundEnable then
			sound = db.Else_Sound
		end
	end

	-- no info or alert target is 'none'
	if target == '_none_' then return end
	-- if 'Only target/focus' is on, check if target/focus guid is same as source
	if onlytarget and (UnitGUID("target") ~= srcGUID or UnitGUID("focus") ~= srcGUID) then return end
	
	local message = addon:ParseMessage(db.Message, srcGUID, spellID, false, isPet)
	local rawmessage = addon:ParseMessage(db.Message, srcGUID, spellID, true, isPet)

	-- Faked RW
	if target == "screen" then
		RaidNotice_AddMessage(RaidWarningFrame, message, frame_rw)
	-- (deprecated) Faked RW (silent)
	elseif target == "screen_nosound" then
		sound = false
		RaidNotice_AddMessage(RaidWarningFrame, message, frame_rw)
	-- MSBT(message [, scrollArea, isSticky, colorR, colorG, colorB, fontSize, fontName, outlineIndex, texturePath])
	elseif ssub(target, 1, 5) == "MSBT_" and MSBT and not MSBT.IsModDisabled() then
		local area = ssub(target, 6)
		MSBT.DisplayMessage(message, area)
	-- SCT:DisplayText (msg, color, isCrit, eventtype, frame, anitype, parent, icon)
	elseif target == "SCT_Frame1" and SCT then
		SCT:DisplayText(message, nil, nil, nil, 1)
	elseif target == "SCT_Frame2" and SCT then
		SCT:DisplayText(message, nil, nil, nil, 2)
	elseif target == "SCT_Damage" and SCTD then
		SCT:DisplayText(message, nil, nil, nil, 3);
	elseif target == "SCT_FrameMsg" and SCT then
		-- msg, color, icon
		SCT:DisplayMessage(message, {r=1,g=1,b=1}, nil)
	-- Parrot:ShowMessage (msg, frame, sticky, r, g, b, font, fontsize, outline, icon)
	elseif ssub(target, 1, 7) == "Parrot_" and Parrot then
		local area = ssub(target, 8)
		Parrot:ShowMessage(message, area, false);
	-- builtin combattext (msg, scroll, r, g, b)
	elseif target == "BlizzCT" and IsAddOnLoaded("Blizzard_CombatText") then
	    CombatText_AddMessage(message, COMBAT_TEXT_SCROLL_FUNCTION, 1, 1, 1)
	-- Party chat
	elseif target == "party" then
		SendChatMessage(rawmessage, "PARTY")
	-- Raid chat
	elseif target == "raid" then
		SendChatMessage(rawmessage, "RAID")
	-- Raid Warning
	elseif target == "rw" then
		if IsRaidOfficer() then
			SendChatMessage(rawmessage, "RAID_WARNING")
		else
			SendChatMessage(rawmessage, "RAID")
		end
	-- BG chat
	elseif target == "bg" then
		SendChatMessage(rawmessage, "BATTLEGROUND")
	-- custom channels
	elseif ssub(target, 1, 7) == "channel" then
		local area = tonumber(ssub(target, 8))
		SendChatMessage(rawmessage, "CHANNEL", nil, area)
	-- chat frames
	elseif ssub(target, 1, 4) == "chat" then
		local area = ssub(target, 5)
		_G["ChatFrame"..area]:AddMessage(message)
	-- if all else fails, output to default chat frame
	else
		addon:Print(message)
	end

	-- play sound
	if media:IsValid("sound", sound) then
		PlaySoundFile(media:Fetch("sound", sound))
	end
end

-- updates a spell timer bar
function addon:UpdateSpell(anchor, spellID, duration, maximum, unitname)
	-- exit if anchor is disabled
	local anchorname = addon:GetAnchorKey(anchor.name)
	if addon:GetZoneSetting("Anchors", anchorname) == false then return end

	local spell = addon:GetSpell(spellID)
	local spelltype = addon:GetSpellType(spellID)
	local color = addon:GetBarColor(anchorname, spelltype)
	local label
	if unitname then
		label = addon.DB.profile.Anchors[anchorname].LabelFormat
		label = sreplace(label, "%%spell%%", spell.name)
		label = sreplace(label, "%%player%%", unitname)
	else
		label = spell.name
	end

	-- check if bar exists, reuse it if it does
	local bar
	if unitname then
		bar = anchor:Find("id", unitname.."|"..tostring(spellID))
	else
		bar = anchor:Find("id", spellID)
	end
	if not bar then
		bar = fb:NewBar(anchor, 64, 16)
		if unitname then
			bar:SetData("id", unitname.."|"..tostring(spellID))
		else
			bar:SetData("id", spellID)
		end
		local icon = select(3, GetSpellInfo(spellID))
		bar:SetData("icon", icon)
		bar:SetData("name", spell.name)
		bar:SetData("type", spelltype)
		bar:SetDuration(duration, maximum)
	else
		bar:SetDuration(duration, maximum)
	end

	-- set label, scale
	bar:SetLabel(label)
	bar:SetScale(anchor:GetScale())

	-- apply any other styles
	StyleBar(bar)

	-- finally start it
	bar:Start()
end

-- workaround for ZONE_CHANGED_NEW_AREA not always firing
function addon:PLAYER_ENTERING_WORLD()
	local newZone = GetCurrentMapAreaID()
	if lastZone ~= newZone then
		lastZone = newZone
		addon:ZONE_CHANGED_NEW_AREA()
	end
end

-- wipe data when entering a new zone type (world->bg, etc.)
function addon:ZONE_CHANGED_NEW_AREA(forced)
	local zonetype = select(2, IsInInstance())
	if forced or zonetype ~= lastZoneType then
		--wipe unit data
		wipe(addon.Units)
		wipe(addon.Groups)

		addon:RefreshAnchors()
	end
	lastZoneType = zonetype
end

-- refresh target anchor when player target changes
function addon:PLAYER_TARGET_CHANGED()
	-- is anchor enabled?
	if addon:GetZoneSetting("Anchors", "Anchor_Target") == false then return end
	-- is it a valid enemy player?
	if UnitIsPlayer("target") and (addon.DB.profile.Debug or UnitIsEnemy("player", "target")) then
		local GUID = UnitGUID("target")
		local unit = addon:GetPlayer(GUID)
		local spells = addon:GetUnitSpells(GUID)
		addon:CheckPets("target")
		addon:UpdateAnchor(addon.Anchors["Anchor_Target"], spells, GUID)
	else
		addon:UpdateAnchor(addon.Anchors["Anchor_Target"], nil, nil)
	end
end

-- refresh focus anchor when player focus changes
function addon:PLAYER_FOCUS_CHANGED()
	-- is anchor enabled?
	if addon:GetZoneSetting("Anchors", "Anchor_Focus") == false then return end
	-- is it a valid enemy player?
	if UnitIsPlayer("focus") and (addon.DB.profile.Debug or UnitIsEnemy("player", "focus")) then
		local GUID = UnitGUID("focus")
		local unit = addon:GetPlayer(GUID)
		local spells = addon:GetUnitSpells(GUID)
		addon:CheckPets("focus")
		addon:UpdateAnchor(addon.Anchors["Anchor_Focus"], spells, GUID)
	else
		addon:UpdateAnchor(addon.Anchors["Anchor_Focus"], nil, nil)
	end
end

-- refresh arena anchors as opponent info updates
function addon:ARENA_OPPONENT_UPDATE()
	-- is anchor enabled?
	if addon:GetZoneSetting("Anchors", "Anchor_Arena") == false then return end
	for i = 1, 5 do
		local unitID = "arena"..i
		local anchor = "Anchor_Arena"..i
		if UnitIsPlayer(unitID) then
			local GUID = UnitGUID(unitID)
			local unit = addon:GetPlayer(GUID)
			local spells = addon:GetUnitSpells(GUID)
			addon:CheckPets(unitID)
			addon:UpdateAnchor(addon.Anchors[anchor], spells, GUID)
		else
			addon:UpdateAnchor(addon.Anchors[anchor], nil, nil)
		end
	end
end

-- get unit spec information from battleground score window
function addon:UPDATE_BATTLEFIELD_SCORE()
	local t = {}
	for i=1, GetNumBattlefieldScores() do
		local name, _, _, _, _, faction, _, _, class, _, _, _, _, _, _, spec = GetBattlefieldScore(i)

		if (faction == 0 and addon.Faction == "Alliance") or (faction == 1 and addon.Faction == "Horde") then
			local unit = addon:GetPlayer(name)
			unit.faction = faction
			unit.class = class
			unit.spec = addon:GetSpecNum(class, spec)
		end
	end
end

-- respond to combatlog events
function addon:COMBAT_LOG_EVENT_UNFILTERED(event, timeStamp, eventType, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, dstGUID, dstName, dstFlags, dstRaidFlags, spellID, spellName, spellSchool, auraType)
	-- check event subtype
	if not eventtypes[eventType] then return end

	-- combatlog fail checks
	if not srcGUID or srcGUID == GUID_INVALID or spellName == "-1" or spellID == 0 then return end

	-- don't track the player's cooldowns
	if srcGUID == UnitGUID("player") then return end

	-- check if unit is player/pet
	local isPet = addon:IsPlayerPet(srcFlags)
	if not (GetPlayerInfoByGUID(srcGUID) or isPet) or not (addon.DB.profile.Debug or addon:IsHostile(srcFlags)) then return end

	-- workaround for combatlog bug (2 exact same entries generated for 1 event)
	if LastEventSource == srcGUID and LastEventSpell == spellName then return end
	LastEventSource = srcGUID
	LastEventSpell = spellName

	-- record unit data
	local srcUnit
	if isPet then
		srcUnit = addon:GetPet(srcGUID, srcName)
	else
		srcUnit = addon:GetPlayer(srcGUID)
	end

	-- spec detection #1 (spammable spells)
	if not srcUnit.spec and not isPet and addon.SpecSpells[spellID] then
		srcUnit.spec = addon.SpecSpells[spellID]
		addon:SendAlert("spec", srcGUID)
		addon:RefreshAnchors(true)
	end

	-- check if spell is in database
	local spell = addon:GetSpell(spellID)
	-- stop if not found or it has no cooldown
	if not spell or not spell.cooldown or spell.cooldown<1 then return end

	-- spec detection #2 (cd spells)
	if not srcUnit.spec and not isPet and spell.spec then
		srcUnit.spec = spell.spec
		addon:SendAlert("spec", srcGUID)
		addon:RefreshAnchors(true)
	end
	
	if eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_SUMMON" then
		local t = GetTime()
		local stype = addon:GetSpellType(spellID)
		local anchors = addon.Anchors
		local groups = addon.Groups

		srcUnit.spells[spellID] = t

		-- add spell to group anchors
		if not groups[stype] then groups[stype] = {} end
		local id = tostring(srcGUID).."|"..tostring(spellID)
		groups[stype][id] = t
		if addon.Anchors["Group_"..stype] then
			addon:UpdateGroupAnchor(addon.Anchors["Group_"..stype])
		end

		-- handle cooldown resetting spells
		local resets = spell.resets
		if resets then
			if type(resets) == "table" then
				for k, v in pairs(resets) do
					srcUnit.spells[v] = nil
				end
			elseif resets == 'all' then
				wipe(srcUnit.spells)
			else
				srcUnit.spells[resets] = nil
			end
			addon:RefreshAnchors(true)
		end

		local cd = addon:GetSpellCooldown(spellID, srcUnit.spec)
		-- workaround for spells that have cooldowns, but it's removed on one spec, e.g. Word of Glory
		if cd == 0 then return end

		-- update anchors if unit is currently targeted/focused/etc.
		local source = srcGUID
		if srcUnit.owner then source = srcUnit.owner end

		if source == UnitGUID("target") then
			addon:UpdateSpell(anchors.Anchor_Target, spellID, cd, cd)
		end

		if source == UnitGUID("focus") then
			addon:UpdateSpell(anchors.Anchor_Focus, spellID, cd, cd)
		end
		
		for i = 1, 5 do
			local a = "Anchor_Arena"..i
			local u = "arena"..i
			if source == UnitGUID(u) then
				addon:UpdateSpell(anchors[a], spellID, cd, cd)
			end
		end

		-- send alert about spell used
		if isPet and srcUnit.owner then
			-- if pet has an owner then use owner's id
			addon:SendAlert("used", srcUnit.owner, dstGUID, spellID, false)
		else
			addon:SendAlert("used", srcGUID, dstGUID, spellID, isPet)
		end
	end
end

local addon = PvPTimer
local L = addon.Locale
local LSM = addon.Lib.Media

local smatch = string.match
local sformat = string.format
local pairs = pairs

-- generic getter/setter functions, use AceGUI's IDs to get/set values
local function getConfigValue(i)
	local db = addon.DB.profile

	for k = 2, #i do
		if i[k] ~= "X_Settings" then
			if not db then db = {} end
			db = db[i[k]]
		end
	end

	return db
end

local function setConfigValue(i, v)
	local db = addon.DB.profile
	for k = 2, #i-1 do
		if i[k] ~= "X_Settings" then
			if not db[i[k]] then db[i[k]] = {} end
			db = db[i[k]]
		end
	end

	db[i[#i]] = v
end

-- for colors
local function getColorValue(i)
	local t = getConfigValue(i)

	if i[4] == "X_Color" then
		local x = addon.DB.profile.SpellCategories[i[3]]
		return x.r, x.g, x.b, x.a
	elseif t then
		return t.r, t.g, t.b, t.a
	else
		return 0, 0, 0, 1
	end
end

local function setColorValue(i, r, g, b, a)
	local t = {
		["r"] = r,
		["g"] = g,
		["b"] = b,
		["a"] = a,
	}
	if i[4] == "X_Color" then
		local x = addon.DB.profile.SpellCategories[i[3]]
		x.r = r
		x.g = g
		x.b = b
		x.a = a
	else
		setConfigValue(i, t)
	end
end

-- for multiselect controls
local function getMultiValue(i, k)
	i[#i+1] = k
	return getConfigValue(i)
end

local function setMultiValue(i, k, v)
	i[#i+1] = k
	setConfigValue(i, v)
end

local function getAnchorEnabled(i)
	local db = addon.DB.profile

	local a = i[2]
	local b = i[3]

	if db[a] and db[a][b] then
		return not db[a][b].Enabled
	end
end

local function getIconModeEnabled(i)
	local db = addon.DB.profile

	local a = i[2]
	local b = i[3]

	if db[a] and db[a][b] then
		return db[a][b].Bars.IconMode
	end
	return false
end

local function IsGroupAnchor(i)
	if smatch(i[3], "Group_") then return true end
	return false
end

local function CopyAnchorSettings(i)
	local data = addon.DB.profile.Anchors[i[3]].Bars
	addon.AnchorCopy = addon:CopyTable(data)
end

local function PasteAnchorSettings(i)
	local data = addon.DB.profile.Anchors[i[3]].Bars

	for k, v in pairs(addon.AnchorCopy) do
		data[k] = addon:CopyTable(v)
	end
	addon:RefreshAnchors()
end

local function CopyAlertSettings(i)
	local data = addon.DB.profile.Alert[i[3]]
	addon.AlertCopy = addon:CopyTable(data)
end

local function PasteAlertSettings(i)
	local data = addon.DB.profile.Alert[i[3]]

	for k, v in pairs(addon.AlertCopy) do
		data[k] = addon:CopyTable(v)
	end
end

local const_bg = addon.Const.Battlegrounds
local const_arena = addon.Const.Arenas
local const_autohide = addon.Const.Autohide
local const_attach = addon.Const.Attach
local const_justify = addon.Const.Justify
local const_startpoint = addon.Const.StartPoint
local const_textposition = addon.Const.TextPosition
local const_fontflags = addon.Const.FontFlags

-- option subtables
local anchor = {
	X_Settings = {
		order = 10,
		name = L["Settings"],
		desc = L["Anchor Settings"],
		type = "group",
		args = {
			Enabled = {
				order = 1,
				name = L["Enable anchor"],
				desc = L["Enables or disables this anchor."],
				type = "toggle",
				width = "full",
			},
			Width = {
				disabled = getAnchorEnabled,
				order = 11,
				name = L["Width"],
				desc = L["Width of the anchor."],
				type = "range",
				min = 100,
				max = 400,
				step = 5,
				width = "full",
				disabled = getAnchorEnabled,
			},
			Scale = {
				disabled = getAnchorEnabled,
				order = 12,
				name = L["Scale"],
				desc = L["Scale of the anchor."],
				type = "range",
				min = 0.1,
				max = 5,
				step = 0.05,
				isPercent = true,
				width = "full",
				disabled = getAnchorEnabled,
			},
			Text_Spec = {
				disabled = getAnchorEnabled,
				order = 20,
				name = L["Talent specialization icon"],
				type = "header",
				hidden = IsGroupAnchor,
			},
			ShowSpec = {
				disabled = getAnchorEnabled,
				order = 21,
				name = L["Spec icon size"],
				desc = L["Shows an icon that displays the player's talent specialization. Set to 0 to disable."],
				type = "range",
				min = 0,
				softMax = 64,
				step = 1,
				disabled = getAnchorEnabled,
				hidden = IsGroupAnchor,
			},
			SpecPosition = {
				disabled = getAnchorEnabled,
				order = 22,
				name = L["Position"],
				desc = L["Position of the icon."],
				type = "select",
				values = addon.Const.IconPosition,
				disabled = getAnchorEnabled,
				hidden = IsGroupAnchor,
			},
			SpecAlpha = {
				disabled = getAnchorEnabled,
				order = 23,
				name = L["Opacity"],
				desc = L["Sets the opacity (alpha)."],
				type = "range",
				isPercent = true,
				min = 0,
				max = 1,
				step = 0.05,
				disabled = getAnchorEnabled,
				hidden = IsGroupAnchor,
			},
			LabelFormat = {
				disabled = getAnchorEnabled,
				order = 31,
				name = L["Label Format"],
				desc = L["Format of the label's text. Use |CFF00FF00%spell%|r to substitute the spell name, |CFF00FF00%player%|r for the player's name."],
				type = "input",
				width = "full",
				disabled = getAnchorEnabled,
				hidden = function(i) return not IsGroupAnchor(i) end,
			},
			Text_Enable = {
				disabled = getAnchorEnabled,
				order = 50,
				name = L["Show anchor in"],
				type = "header",
				width = "full",
			},
			BG = {
				disabled = getAnchorEnabled,
				order = 51,
				name = L["Battlegrounds"],
				desc = L["Enable or disable in normal, non-rated Battlegrounds."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			RatedBG = {
				disabled = getAnchorEnabled,
				order = 52,
				name = L["Rated Battlegrounds"],
				desc = L["Enable or disable in rated Battlegrounds."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			Arena = {
				disabled = getAnchorEnabled,
				order = 53,
				name = L["Arenas"],
				desc = L["Enable or disable in arenas."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			-- Duel = {
				-- order = 54,
				-- name = "Duels",
				-- type = "toggle",
			-- },
			-- PvP = {
				-- order = 55,
				-- name = "PvP flagged",
				-- type = "toggle",
			-- },
			Else = {
				disabled = getAnchorEnabled,
				order = 59,
				name = L["Everywhere else"],
				desc = L["Enable or disable anywhere else not specified above."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
		},
	},
	Position = {
		order = 20,
		name = L["Position"],
		desc = L["Position of the anchor."],
		disabled = getAnchorEnabled,
		type = "group",
		args = {
			AttachPoint = {
				order = 11,
				name = L["Anchor point"],
				desc = L["Sets the point that will be anchored."],
				type = "select",
				values = const_attach,
			},
			AttachFrame = {
				order = 12,
				name = L["Relative to"],
				desc = L["Sets the frame to be anchored to.\nUse 'UIParent' for the whole screen."],
				type = "input",
				set = function(i, v)
					if not _G[v] or not _G[v].SetPoint then
						v = "UIParent"
						addon:Print(L["Invalid frame. Resetting to default."])
					end
					setConfigValue(i, v)
					addon:RefreshAnchors()
				end,
			},
			AttachRelative = {
				order = 13,
				name = L["Relative point"],
				desc = L["Sets the point to be anchored to."],
				type = "select",
				values = const_attach,
			},
			AttachX = {
				order = 14,
				name = L["Offset X"],
				desc = L["Horizontal offset."],
				type = "range",
				softMin = -1000,
				softMax = 1000,
				min = -2000,
				max = 2000,
				step = 1,
				bigStep = 5,
				width = "full",
			},
			AttachY = {
				order = 15,
				name = L["Offset Y"],
				desc = L["Vertical offset."],
				type = "range",
				softMin = -1000,
				softMax = 1000,
				min = -2000,
				max = 2000,
				step = 1,
				bigStep = 5,
				width = "full",
			},
		},
	},
	Bars = {
		order = 30,
		name = L["Timer bars"],
		desc = L["Timer bar settings."],
		disabled = getAnchorEnabled,
		type = "group",
		args = {
			CopySettings = {
				order = 1,
				name = L["Copy Settings"],
				desc = L["Copies settings on this page to memory."],
				type = "execute",
				func = CopyAnchorSettings,
			},
			PasteSettings = {
				order = 2,
				name = L["Paste Settings"],
				desc = L["Applies settings in memory."],
				type = "execute",
				func = PasteAnchorSettings,
				disabled = function()
					return (addon.AnchorCopy == false)
				end,
			},
			IconMode = {
				order = 3,
				name = L["Icon Mode"],
				desc = L["Show icons instead of bars."],
				type = "toggle",
				width = "full",
			},
			IconSize = {
				order = 4,
				name = L["Icon Size"],
				desc = L["Size of the icons."],
				type = "range",
				min = 0,
				softMin = 8,
				softMax = 64,
				step = 1,
				hidden = function(i) return not getIconModeEnabled(i) end,
			},
			Color = {
				order = 11,
				name = L["Bar color"],
				desc = L["Default timer bar color."],
				type = "color",
				get = getColorValue,
				set = function(i, r, g, b, a)
					setColorValue(i, r, g, b, a)
					addon:RefreshAnchors()
				end,
				hidden = getIconModeEnabled,
			},
			TypeColor = {
				order = 12,
				name = L["Use spell category color"],
				desc = L["Use spell category color (defined in Spell Categories) instead."],
				type = "toggle",
				hidden = getIconModeEnabled,
			},
			IconLeft = {
				order = 15,
				name = L["Show icon on left side"],
				desc = L["Shows the spell's icon on the left side of the bar."],
				type = "toggle",
				hidden = getIconModeEnabled,
			},
			IconRight = {
				order = 16,
				name = L["Show icon on right side"],
				desc = L["Shows the spell's icon on the right side of the bar."],
				type = "toggle",
				hidden = getIconModeEnabled,
			},
			Spark = {
				order = 17,
				name = L["Show spark"],
				desc = L["Sets a 'spark' for the bar, which is a bright vertical bar at the end of the timerbar, making it easier to see its progress."],
				type = "toggle",
				hidden = getIconModeEnabled,
			},
			Texture = {
				order = 21,
				name = L["Bar texture"],
				desc = L["Texture of timer bars."],
				type = "select",
				dialogControl = 'LSM30_Statusbar',
				values = AceGUIWidgetLSMlists.statusbar,
				hidden = getIconModeEnabled,
			},
			StartPoint = {
				order = 31,
				name = L["Bar start point"],
				desc = L["Set the corner and side bars start from."],
				type = "select",
				values = const_startpoint,
			},
			Columns = {
				order = 32,
				name = L["Columns"],
				desc = L["Arrange bars into columns. (0: automatic)"],
				type = "range",
				min = 0,
				max = 20,
				step = 1,
			},
			Spacing_H = {
				order = 33,
				name = L["Horizontal spacing"],
				desc = L["Horizontal space between timers."],
				type = "range",
				min = 0,
				softMax = 50,
				step = 1,
			},
			Spacing_V = {
				order = 34,
				name = L["Vertical spacing"],
				desc = L["Vertical space between timers."],
				type = "range",
				min = 0,
				softMax = 50,
				step = 1,
			},
			MaxBars = {
				order = 35,
				name = L["Visible Bars"],
				desc = L["Limit the number of visible bars. (0: no limit)"],
				type = "range",
				min = 0,
				max = 20,
				step = 1,
			},
			Alpha = {
				order = 36,
				name = L["Opacity"],
				desc = L["Sets the opacity (alpha)."],
				type = "range",
				min = 0,
				max = 1,
				step = 0.05,
				isPercent = true,
			},
			Text_SpellName = {
				order = 40,
				name = L["Spell Name"],
				type = "header",
				hidden = getIconModeEnabled,
			},
			NameEnable = {
				order = 41,
				name = L["Show"],
				type = "toggle",
				hidden = getIconModeEnabled,
			},
			NameFont = {
				order = 42,
				name = L["Font"],
				type = "select",
				dialogControl = 'LSM30_Font',
				values = AceGUIWidgetLSMlists.font,
				hidden = getIconModeEnabled,
			},
			NameFontSize = {
				order = 43,
				name = L["Font size"],
				type = "range",
				min = 1,
				max = 20,
				step = 1,
				hidden = getIconModeEnabled,
			},
			NameFontFlags = {
				order = 44,
				name = L["Outline"],
				desc = L["Outline of the font."],
				type = "select",
				values = const_fontflags,
				hidden = getIconModeEnabled,
			},
			Text_Time = {
				order = 50,
				name = L["Time Remaining"],
				type = "header",
			},
			TimeEnable = {
				order = 51,
				name = L["Show"],
				type = "toggle",
			},
			TimeFont = {
				order = 52,
				name = L["Font"],
				type = "select",
				dialogControl = 'LSM30_Font',
				values = AceGUIWidgetLSMlists.font,
			},
			TimeFontSize = {
				order = 53,
				name = L["Font size"],
				type = "range",
				min = 1,
				max = 20,
				step = 1,
			},
			TimeFontFlags = {
				order = 54,
				name = L["Outline"],
				desc = L["Outline of the font."],
				type = "select",
				values = const_fontflags,
			},
			TimePosition = {
				order = 55,
				name = L["Position"],
				desc = L["Position of the timer text."],
				type = "select",
				values = const_textposition,
				hidden = function(i) return not getIconModeEnabled(i) end,
			},
			TimeOffsetX = {
				order = 56,
				name = L["Offset X"],
				desc = L["Horizontal offset."],
				type = "range",
				min = -50,
				softMax = 50,
				step = 1,
				hidden = function(i) return not getIconModeEnabled(i) end,
			},
			TimeOffsetY = {
				order = 57,
				name = L["Offset Y"],
				desc = L["Vertical offset."],
				type = "range",
				min = -50,
				softMax = 50,
				step = 1,
				hidden = function(i) return not getIconModeEnabled(i) end,
			},
			Text_Ghost = {
				order = 60,
				name = L["Ghost"],
				type = "header",
			},
			Ghost = {
				order = 61,
				name = L["Duration"],
				desc = L["Sets the duration that the timer persists after expiring as a ghost. Set to 0 to disable."],
				type = "range",
				min = 0,
				softMax = 10,
				step = 0.1,
			},
			GhostBackground = {
				order = 62,
				type = "color",
				name = L["Background color"],
				desc = L["Changes the background color when the effect begins. Does not apply in icon mode."],
				get = getColorValue,
				set = function(i, r, g, b, a)
					setColorValue(i, r, g, b, a)
					addon:RefreshAnchors()
				end,
			},
			GhostTexture = {
				order = 63,
				type = "select",
				name = L["Background texture"],
				desc = L["Changes the background texture when the effect begins. Does not apply in icon mode."],
				dialogControl = 'LSM30_Statusbar',
				values = AceGUIWidgetLSMlists.statusbar,
			},
			GhostMessage = {
				order = 64,
				type = "input",
				name = L["Message"],
				desc = L["Show a message in place of the bar's timer."],
			},
			Text_Fadeout = {
				order = 70,
				name = L["Fade out"],
				type = "header",
			},
			Fadeout = {
				order = 71,
				name = L["Length"],
				desc = L["Sets the amount of time the timer takes to fade out when it finishes. Set to 0 to disable."],
				type = "range",
				min = 0,
				softMax = 10,
				step = 0.1,
			},
			FadeoutBackground = {
				order = 72,
				type = "color",
				name = L["Background color"],
				desc = L["Changes the background color when the effect begins. Does not apply in icon mode."],
				get = getColorValue,
				set = function(i, r, g, b, a)
					setColorValue(i, r, g, b, a)
					addon:RefreshAnchors()
				end,
			},
			FadeoutTexture = {
				order = 73,
				type = "select",
				name = L["Background texture"],
				desc = L["Changes the background texture when the effect begins. Does not apply in icon mode."],
				dialogControl = 'LSM30_Statusbar',
				values = AceGUIWidgetLSMlists.statusbar,
			},
			FadeoutMessage = {
				order = 74,
				type = "input",
				name = L["Message"],
				desc = L["Show a message in place of the bar's timer."],
			},
		},
	},
}

local anchor_arena = addon:CopyTable(anchor)
anchor_arena.Autohide = nil
anchor_arena.Text_Enable = nil
anchor_arena.BG = nil
anchor_arena.RatedBG = nil
anchor_arena.Arena = nil
anchor_arena.Duel = nil
anchor_arena.PvP = nil
anchor_arena.Else = nil

-- for some reason LSM controls don't survive the copy, hack them in again
anchor_arena.Bars.args.NameFont.dialogControl = 'LSM30_Font'
anchor_arena.Bars.args.NameFont.values = AceGUIWidgetLSMlists.font
anchor_arena.Bars.args.TimeFont.dialogControl = 'LSM30_Font'
anchor_arena.Bars.args.TimeFont.values = AceGUIWidgetLSMlists.font

anchor_arena.Position.args.NextX = {
	order = 18,
	name = L["Distance between frames X"],
	desc = L["Horizontal distance between each arena frame."],
	type = "range",
	softMin = -1000,
	softMax = 1000,
	min = -2000,
	max = 2000,
	step = 1,
	bigStep = 5,
	width = "full",
}
anchor_arena.Position.args.NextY = {
	order = 19,
	name = L["Distance between frames Y"],
	desc = L["Vertical distance between each arena frame."],
	type = "range",
	softMin = -1000,
	softMax = 1000,
	min = -2000,
	max = 2000,
	step = 1,
	bigStep = 5,
	width = "full",
}

-- builds spell category list for color picker
local CategoryList_Alert = {}

for k, v in pairs(addon.DB.profile.SpellCategories) do
	CategoryList_Alert[k] = {
		order = 100 + v.order,
		type = "group",
		name = v.name,
		desc = v.desc,
		args = {
			X_Color = {
				order = 1,
				type = "color",
				width = "full",
				name = L["Category Color"],
				desc = L["Timer bars for spells in this category will appear in this color."],
				get = getColorValue,
				set = function(i, r, g, b, a)
					setColorValue(i, r, g, b, a)
					addon:RefreshAnchors()
				end,
			},
			CautionHeader = {
				order = 3,
				name = L["Alert Messages"],
				type = "header",
			},
			CautionText = {
				order = 4,
				name = L["Be careful when using these alerts, they can send out a lot of messages. People will likely yell at you or /ignore you if you spam alerts in a public channel."],
				type = "description",
				width = "full",
				fontSize = "medium",
			},
			CopySettings = {
				order = 5,
				name = L["Copy Settings"],
				desc = L["Copies settings on this page to memory."],
				type = "execute",
				func = CopyAlertSettings,
				hidden = function(i) return (i[3] == "spec") end,
			},
			PasteSettings = {
				order = 6,
				name = L["Paste Settings"],
				desc = L["Applies settings in memory."],
				type = "execute",
				func = PasteAlertSettings,
				hidden = function(i) return (i[3] == "spec") end,
				disabled = function()
					return (addon.AlertCopy == false)
				end,
			},
			Enabled = {
				order = 11,
				name = L["Enable alerts"],
				desc = L["Enable or disable alerts regardless of other settings."],
				type = "toggle",
			},
			Message = {
				order = 12,
				name = L["Message"],
				desc = L["Customize the message displayed when the alert is triggered. You can use the following tags:"].."\n\n"..L["MESSAGE_TAGS"],
				type = "input",
				width = "full",
				disabled = getAnchorEnabled,
			},
			BG_Text = {
				order = 20,
				name = L["Battlegrounds"],
				type = "header",
			},
			BG = {
				order = 21,
				name = L["Alert Target"],
				desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
				type = "select",
				values = function() return addon:GetMessageFrames() end,
				disabled = getAnchorEnabled,
			},
			BG_OnlyTarget = {
				order = 22,
				name = L["Only target/focus"],
				desc = L["Only trigger alerts if source is the current target or focus."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			BG_SoundEnable = {
				order = 24,
				name = L["Play Sound"],
				desc = L["Plays a sound when the alert is triggered."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			BG_Sound = {
				order = 25,
				name = L["Sound"],
				desc = L["Select the sound you want played when the alert is triggered."],
				type = "select",
				dialogControl = 'LSM30_Sound',
				values = AceGUIWidgetLSMlists.sound,
				disabled = getAnchorEnabled,
			},
			RatedBG_Text = {
				order = 30,
				name = L["Rated Battlegrounds"],
				type = "header",
			},
			RatedBG = {
				order = 31,
				name = L["Alert Target"],
				desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
				type = "select",
				values = function() return addon:GetMessageFrames() end,
				disabled = getAnchorEnabled,
			},
			RatedBG_OnlyTarget = {
				order = 32,
				name = L["Only target/focus"],
				desc = L["Only trigger alerts if source is the current target or focus."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			RatedBG_SoundEnable = {
				order = 34,
				name = L["Play Sound"],
				desc = L["Plays a sound when the alert is triggered."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			RatedBG_Sound = {
				order = 35,
				name = L["Sound"],
				desc = L["Select the sound you want played when the alert is triggered."],
				type = "select",
				dialogControl = 'LSM30_Sound',
				values = AceGUIWidgetLSMlists.sound,
				disabled = getAnchorEnabled,
			},
			Arena_Text = {
				order = 40,
				name = L["Arenas"],
				type = "header",
			},
			Arena = {
				order = 41,
				name = L["Alert Target"],
				desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
				type = "select",
				values = function() return addon:GetMessageFrames() end,
				disabled = getAnchorEnabled,
			},
			Arena_OnlyTarget = {
				order = 42,
				name = L["Only target/focus"],
				desc = L["Only trigger alerts if source is the current target or focus."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			Arena_SoundEnable = {
				order = 44,
				name = L["Play Sound"],
				desc = L["Plays a sound when the alert is triggered."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			Arena_Sound = {
				order = 45,
				name = L["Sound"],
				desc = L["Select the sound you want played when the alert is triggered."],
				type = "select",
				dialogControl = 'LSM30_Sound',
				values = AceGUIWidgetLSMlists.sound,
				disabled = getAnchorEnabled,
			},
			Else_Text = {
				order = 90,
				name = L["Everywhere else"],
				type = "header",
			},
			Else = {
				order = 91,
				name = L["Alert Target"],
				desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
				type = "select",
				values = function() return addon:GetMessageFrames() end,
				disabled = getAnchorEnabled,
			},
			Else_OnlyTarget = {
				order = 92,
				name = L["Only target/focus"],
				desc = L["Only trigger alerts if source is the current target or focus."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			Else_SoundEnable = {
				order = 94,
				name = L["Play Sound"],
				desc = L["Plays a sound when the alert is triggered."],
				type = "toggle",
				disabled = getAnchorEnabled,
			},
			Else_Sound = {
				order = 95,
				name = L["Sound"],
				desc = L["Select the sound you want played when the alert is triggered."],
				type = "select",
				dialogControl = 'LSM30_Sound',
				values = AceGUIWidgetLSMlists.sound,
				disabled = getAnchorEnabled,
			},
		},
	}
end

--[[
CategoryList_Alert["spec"] = {
	name = L["Spec Detection"],
	args = {
		CautionHeader = {
			order = 3,
			name = L["Alert Messages"],
			type = "header",
		},
		CautionText = {
			order = 4,
			name = L["Be careful when using these alerts, they can send out a lot of messages. People will likely yell at you or /ignore you if you spam alerts in a public channel."],
			type = "description",
			width = "full",
			fontSize = "medium",
		},
		CopySettings = {
			order = 5,
			name = L["Copy Settings"],
			desc = L["Copies settings on this page to memory."],
			type = "execute",
			func = CopyAlertSettings,
			hidden = function(i) return (i[3] == "spec") end,
		},
		PasteSettings = {
			order = 6,
			name = L["Paste Settings"],
			desc = L["Applies settings in memory."],
			type = "execute",
			func = PasteAlertSettings,
			hidden = function(i) return (i[3] == "spec") end,
			disabled = function()
				return (addon.AlertCopy == false)
			end,
		},
		Enabled = {
			order = 11,
			name = L["Enable alerts"],
			desc = L["Enable or disable alerts regardless of other settings."],
			type = "toggle",
		},
		Message = {
			order = 12,
			name = L["Message"],
			desc = L["Customize the message displayed when the alert is triggered. You can use the following tags:"].."\n\n"..L["MESSAGE_TAGS"],
			type = "input",
			width = "full",
			disabled = getAnchorEnabled,
		},
		BG_Text = {
			order = 20,
			name = L["Battlegrounds"],
			type = "header",
		},
		BG = {
			order = 21,
			name = L["Alert Target"],
			desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
			type = "select",
			values = function() return addon:GetMessageFrames() end,
			disabled = getAnchorEnabled,
		},
		BG_OnlyTarget = {
			order = 22,
			name = L["Only target/focus"],
			desc = L["Only trigger alerts if source is the current target or focus."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		BG_SoundEnable = {
			order = 24,
			name = L["Play Sound"],
			desc = L["Plays a sound when the alert is triggered."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		BG_Sound = {
			order = 25,
			name = L["Sound"],
			desc = L["Select the sound you want played when the alert is triggered."],
			type = "select",
			dialogControl = 'LSM30_Sound',
			values = AceGUIWidgetLSMlists.sound,
			disabled = getAnchorEnabled,
		},
		RatedBG_Text = {
			order = 30,
			name = L["Rated Battlegrounds"],
			type = "header",
		},
		RatedBG = {
			order = 31,
			name = L["Alert Target"],
			desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
			type = "select",
			values = function() return addon:GetMessageFrames() end,
			disabled = getAnchorEnabled,
		},
		RatedBG_OnlyTarget = {
			order = 32,
			name = L["Only target/focus"],
			desc = L["Only trigger alerts if source is the current target or focus."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		RatedBG_SoundEnable = {
			order = 34,
			name = L["Play Sound"],
			desc = L["Plays a sound when the alert is triggered."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		RatedBG_Sound = {
			order = 35,
			name = L["Sound"],
			desc = L["Select the sound you want played when the alert is triggered."],
			type = "select",
			dialogControl = 'LSM30_Sound',
			values = AceGUIWidgetLSMlists.sound,
			disabled = getAnchorEnabled,
		},
		Arena_Text = {
			order = 40,
			name = L["Arenas"],
			type = "header",
		},
		Arena = {
			order = 41,
			name = L["Alert Target"],
			desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
			type = "select",
			values = function() return addon:GetMessageFrames() end,
			disabled = getAnchorEnabled,
		},
		Arena_OnlyTarget = {
			order = 42,
			name = L["Only target/focus"],
			desc = L["Only trigger alerts if source is the current target or focus."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		Arena_SoundEnable = {
			order = 44,
			name = L["Play Sound"],
			desc = L["Plays a sound when the alert is triggered."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		Arena_Sound = {
			order = 45,
			name = L["Sound"],
			desc = L["Select the sound you want played when the alert is triggered."],
			type = "select",
			dialogControl = 'LSM30_Sound',
			values = AceGUIWidgetLSMlists.sound,
			disabled = getAnchorEnabled,
		},
		Else_Text = {
			order = 90,
			name = L["Everywhere else"],
			type = "header",
		},
		Else = {
			order = 91,
			name = L["Alert Target"],
			desc = L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."],
			type = "select",
			values = function() return addon:GetMessageFrames() end,
			disabled = getAnchorEnabled,
		},
		Else_OnlyTarget = {
			order = 92,
			name = L["Only target/focus"],
			desc = L["Only trigger alerts if source is the current target or focus."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		Else_SoundEnable = {
			order = 94,
			name = L["Play Sound"],
			desc = L["Plays a sound when the alert is triggered."],
			type = "toggle",
			disabled = getAnchorEnabled,
		},
		Else_Sound = {
			order = 95,
			name = L["Sound"],
			desc = L["Select the sound you want played when the alert is triggered."],
			type = "select",
			dialogControl = 'LSM30_Sound',
			values = AceGUIWidgetLSMlists.sound,
			disabled = getAnchorEnabled,
		},
	}
}
]]

-- builds spell category list for anchor settings
local CategoryList_Anchors = {
	Anchor_Target = {
		order = 2,
		name = L["Target"],
		desc = L["Anchor that shows information about your current target."],
		type = "group",
		childGroups = "tab",
		args = anchor,
	},
	Anchor_Focus = {
		order = 3,
		name = L["Focus"],
		desc = L["Anchor that shows information about your current focus target."],
		type = "group",
		childGroups = "tab",
		args = anchor,
	},
	Anchor_Arena = {
		order = 4,
		name = L["Arena Targets"],
		desc = L["Anchor that shows information about arena opponents."],
		type = "group",
		childGroups = "tab",
		args = anchor_arena,
	},
}

for k, v in pairs(addon.DB.profile.SpellCategories) do
	CategoryList_Anchors["Group_"..k] = {
		order = 10 + v.order,
		name = sformat("%s: %s", L["Group"], v.name),
		desc = sformat("%s\n\n|CFF00FF00%s|r\n%s", L["Group anchors show all spells in a category, grouped together."], v.name, v.desc),
		type = "group",
		childGroups = "tab",
		args = anchor,
	}
end

--main option table
addon.Options = {
	type = "group",
	name = "PvPTimer",
	get = getConfigValue,
	set = setConfigValue,
	args = {
		Settings = {
			order = 1,
			name = L["Settings"],
			type = "group",
			childGroups = "tab",
			args = {
				Locked = {
					order = 2,
					name = function()
						if addon.AnchorsLocked then
							return L["Unlock anchors"]
						else
							return L["Lock anchors"]
						end
					end,
					desc = L["Locks or unlocks anchors so they can be dragged around and resized using the mouse."],
					type = "execute",
					func = function() addon:ToggleLock() end,
				},
				Test = {
					order = 3,
					name = L["Run Test"],
					desc = L["Shows some test bars."],
					type = "execute",
					func = function() addon:RunTest() end,
				},
				OpenSpellConfig = {
					order = 4,
					name = L["Spell Configuration"],
					desc = L["Opens the Spell Configuration window, where you can disable and adjust spells."],
					type = "execute",
					func = function() addon:ToggleSpellConfig() end,
				},
				Anchors = {
					order = 11,
					name = L["Anchor Settings"],
					desc = L["Anchors are locations on screen to which timers are added."],
					type = "group",
					set = function(i, v)
						setConfigValue(i, v)
						addon:RefreshAnchors()
					end,
					args = CategoryList_Anchors,
				},
				Alert = {
					order = 21,
					name = L["Spell Categories"],
					desc = L["Spell cooldowns are organized into categories."],
					type = "group",
					args = CategoryList_Alert,
				},
			},
		},
	},
}

-- Create lock message
local AceGUI = addon.Lib.AceGUI

addon.LockMessage = AceGUI:Create("Window")
local f = addon.LockMessage
f.frame:SetFrameStrata("LOW")
f:SetCallback("OnClose", function() addon.AnchorsLocked = true; addon:RefreshAnchors() end)
f:SetTitle("PvPTimer Anchors Unlocked")
f:SetLayout("Flow")
f:SetWidth(500)
f:SetHeight(90)
f.sizer_se:Hide()
f:SetPoint("TOP", "UIParent", "TOP", 0, -150)

local text = AceGUI:Create("InteractiveLabel")
text:SetWidth(490)
text:SetText(L["Move anchors around by dragging their title bar. Resize them by dragging their lower right corner. Click 'Run Test' to add some test timers. Click 'Lock Anchors' when you're done."])
f:AddChild(text)

local btn = AceGUI:Create("Button")
btn:SetWidth(235)
btn:SetText(L["Run Test"])
btn:SetCallback("OnClick", function() addon:RunTest() end)
f:AddChild(btn)

local btn2 = AceGUI:Create("Button")
btn2:SetWidth(235)
btn2:SetText(L["Lock anchors"])
btn2:SetCallback("OnClick", function() addon.AnchorsLocked = true; addon:RefreshAnchors() end)
f:AddChild(btn2)


-- Libraries
local LibStub = LibStub
if not LibStub then
	error("PvPTimer requires LibStub.")
end

PvPTimer = LibStub("AceAddon-3.0"):NewAddon("PvPTimer", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local addon = PvPTimer
if not addon then
	error("PvPTimer requires Ace3.")
end

addon.Locale = LibStub:GetLibrary("AceLocale-3.0"):GetLocale("PvPTimer")
local L = addon.Locale

addon.Lib = {}
addon.Lib.AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
addon.Lib.AceConfigDialog = LibStub("AceConfigDialog-3.0")
addon.Lib.AceGUI = LibStub("AceGUI-3.0")

addon.Lib.CallbackHandler = LibStub("CallbackHandler-1.0")
if not addon.Lib.CallbackHandler then
	error("PvPTimer requires CallbackHandler-1.0.")
end
addon.Lib.CallbackHandler:New(addon)

addon.Lib.Bars = LibStub("LibFancyBar-1.0")
if not addon.Lib.Bars then
	error("PvPTimer requires LibFancyBar-1.0.")
end

addon.Lib.Media = LibStub("LibSharedMedia-3.0")
if not addon.Lib.Media then
	error("PvPTimer requires LibSharedMedia-3.0.")
end

addon.Lib.Media:Register("sound", "Raid Warning", [[Sound\Interface\RaidWarning.wav]])

-- Constants
addon.Const = {}
addon.Spells = {}
addon.SpecSpells = {}

local tsort = table.sort
local pairs = pairs
local sformat = string.format

--local BT = LibStub("LibBabble-TalentTree-3.0"):GetUnstrictLookupTable()
local MSBT = MikSBT
local SCT = SCT
local SCTD = SCTD
local Parrot = Parrot
local IsAddonLoaded = IsAddonLoaded

CreateFrame("GameTooltip", "PT_Tooltip", UIParent, "GameTooltipTemplate")
PT_Tooltip:SetClampedToScreen(true)
PT_Tooltip:Hide()

L["MESSAGE_TAGS"] = L["MESSAGE_TAG1"]
		.."\n"..L["MESSAGE_TAG2"]
		.."\n"..L["MESSAGE_TAG10"]
		.."\n"..L["MESSAGE_TAG3"]
		.."\n"..L["MESSAGE_TAG4"]
		.."\n"..L["MESSAGE_TAG5"]
		.."\n"..L["MESSAGE_TAG6"]
		.."\n"..L["MESSAGE_TAG7"]
		.."\n"..L["MESSAGE_TAG8"]
		.."\n"..L["MESSAGE_TAG9"]

local msg1 = "%color_c%%player%||r "
local msg2 = " %icon%%color%%spell%"
local msg3 = " %icon_s%%color_s%%spec%"

-- default settings
addon.Defaults = {
	global = {
		build = 0,
		spells = {},
		anchor_default = {
			["Enabled"] = true,
			["Else"] = true,
			["Scale"] = 1.0,
			["BG"] = true,
			["RatedBG"] = true,
			["ShowSpec"] = 16,
			["SpecPosition"] = "RIGHT",
			["SpecAlpha"] = 1,
			["LabelFormat"] = "%player% - %spell%",
			["Width"] = 150,
			["Position"] = {
				["AttachFrame"] = "UIParent",
				["AttachRelative"] = "CENTER",
				["AttachX"] = "0",
				["AttachPoint"] = "CENTER",
				["AttachY"] = "-100",
			},
			["Bars"] = {
				["StartPoint"] = "bottomright",
				["Spacing_H"] = 0,
				["Spacing_V"] = 0,
				["TimePosition"] = "BOTTOM",
				["TimeOffsetX"] = 0,
				["TimeOffsetY"] = -1,
				["IconMode"] = false,
				["IconSize"] = 32,
				["IconLeft"] = true,
				["IconRight"] = false,
				["Spark"] = true,
				["Alpha"] = 1,
				["NameEnable"] = true,
				["TimeEnable"] = true,
				["NameFont"] = "Arial Narrow",
				["NameFontFlags"] = "",
				["NameFontSize"] = 10,
				["Columns"] = 0,
				["MaxBars"] = 10,
				["Color"] = {
					["a"] = 1,
					["b"] = 0.5,
					["g"] = 0.3,
					["r"] = 0.2,
				},
				["TimeFont"] = "Arial Narrow",
				["TimeFontSize"] = 10,
				["TimeFontFlags"] = "",
				["GrowUp"] = false,
				["ShowName"] = false,
				["ShowTime"] = true,
				["TypeColor"] = true,
				["Texture"] = "Blizzard",
				["Ghost"] = 5,
				["GhostBackground"] =  {
					["a"] = 1,
					["b"] = 0.8,
					["g"] = 0.1,
					["r"] = 0.1,
				},
				["GhostMessage"] = "|cFF00FF00Ready",
				["GhostTexture"] = "Blizzard",
				["Fadeout"] = 1,
				["FadeoutBackground"] =  {
					["a"] = 1,
					["b"] = 0.8,
					["g"] = 0.1,
					["r"] = 0.1,
				},
				["FadeoutTexture"] = "Blizzard",
				["FadeoutMessage"] = "|cFF00FF00Ready",
			},
			["Arena"] = true,
		},
	},
	profile = {
		Settings = {
			EnableAddon = true,
		},
		Spells = {},
		Anchors = {
			Anchor_Target = {
				Width = 150,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "TOPLEFT",
					["AttachX"] = "200",
					["AttachPoint"] = "TOPLEFT",
					["AttachY"] = "-150",
				},
			},
			Anchor_Focus = {
				Width = 150,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "TOPLEFT",
					["AttachX"] = "200",
					["AttachPoint"] = "TOPLEFT",
					["AttachY"] = "-320",
				},
			},
			Anchor_Arena = {
				Width = 120,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "TOPLEFT",
					["AttachX"] = "270",
					["AttachPoint"] = "TOPLEFT",
					["AttachY"] = "-25",
					["NextX"] = 140,
					["NextY"] = 0,
				},
			},
			Group_offensive = {
				Width = 250,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "RIGHT",
					["AttachX"] = "-200",
					["AttachPoint"] = "TOPRIGHT",
					["AttachY"] = "300",
				},
			},
			Group_defensive = {
				Width = 250,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "RIGHT",
					["AttachX"] = "-200",
					["AttachPoint"] = "TOPRIGHT",
					["AttachY"] = "200",
				},
			},
			Group_interrupt = {
				Width = 250,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "RIGHT",
					["AttachX"] = "-200",
					["AttachPoint"] = "TOPRIGHT",
					["AttachY"] = "100",
				},
			},
			Group_cc = {
				Width = 250,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "RIGHT",
					["AttachX"] = "-200",
					["AttachPoint"] = "TOPRIGHT",
					["AttachY"] = "0",
				},
			},
			Group_root = {
				Width = 250,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "RIGHT",
					["AttachX"] = "-200",
					["AttachPoint"] = "TOPRIGHT",
					["AttachY"] = "-100",
				},
			},
			Group_misc = {
				Width = 250,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "RIGHT",
					["AttachX"] = "-200",
					["AttachPoint"] = "TOPRIGHT",
					["AttachY"] = "-200",
				},
			},
			Group_custom1 = {
				Width = 150,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "LEFT",
					["AttachX"] = "20",
					["AttachPoint"] = "TOPLEFT",
					["AttachY"] = "200",
				},
			},
			Group_custom2 = {
				Width = 150,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "LEFT",
					["AttachX"] = "20",
					["AttachPoint"] = "TOPLEFT",
					["AttachY"] = "0",
				},
			},
			Group_custom3 = {
				Width = 150,
				Enabled = false,
				Position = {
					["AttachFrame"] = "UIParent",
					["AttachRelative"] = "LEFT",
					["AttachX"] = "20",
					["AttachPoint"] = "TOPLEFT",
					["AttachY"] = "-200",
				},
			},
		},
		Alert = {
			offensive = {
				Enabled = true,
				BG = "screen",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = true,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "screen",
				Arena = "party",
				Else = "screen",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			defensive = {
				Enabled = true,
				BG = "screen",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = true,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "screen",
				Arena = "party",
				Else = "screen",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			interrupt = {
				Enabled = true,
				OnlyTarget = false,
				BG = "screen",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = true,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "screen",
				Arena = "party",
				Else = "screen",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			cc = {
				Enabled = true,
				OnlyTarget = false,
				BG = "screen",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = true,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "screen",
				Arena = "party",
				Else = "screen",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			misc = {
				Enabled = true,
				OnlyTarget = false,
				BG = "default",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = false,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "default",
				Arena = "default",
				Else = "default",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			root = {
				Enabled = false,
				OnlyTarget = false,
				BG = "_none_",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = false,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "_none_",
				Arena = "_none_",
				Else = "_none_",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			spec = {
				Enabled = true,
				BG = "_none_",
				Message = msg1..L["SPECCED"]..msg3,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = false,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "_none_",
				Arena = "party",
				Else = "default",
				BG_OnlyTarget = false,
				RatedBG_OnlyTarget = false,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = false,
			},
			custom1 = {
				Enabled = false,
				OnlyTarget = false,
				BG = "_none_",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = false,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "_none_",
				Arena = "_none_",
				Else = "_none_",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			custom2 = {
				Enabled = false,
				OnlyTarget = false,
				BG = "_none_",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = false,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "_none_",
				Arena = "_none_",
				Else = "_none_",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
			custom3 = {
				Enabled = false,
				OnlyTarget = false,
				BG = "_none_",
				Message = msg1..L["USED"]..msg2,
				BG_SoundEnable = false,
				BG_Sound = "Raid Warning",
				RatedBG_SoundEnable = false,
				RatedBG_Sound = "Raid Warning",
				Arena_SoundEnable = false,
				Arena_Sound = "Raid Warning",
				Else_SoundEnable = false,
				Else_Sound = "Raid Warning",
				RatedBG = "_none_",
				Arena = "_none_",
				Else = "_none_",
				BG_OnlyTarget = true,
				RatedBG_OnlyTarget = true,
				Arena_OnlyTarget = false,
				Else_OnlyTarget = true,
			},
		},
		SpellCategories = {
			offensive = {
				["a"] = 0.7,
				["b"] = 0,
				["g"] = 0,
				["r"] = 1,
				order = 1,
				name = L["Offensive CDs"],
				desc = L["Cooldowns that increase damage output, e.g. Recklessness."],
			},
			defensive = {
				["a"] = 0.7,
				["b"] = 0,
				["g"] = 1,
				["r"] = 0,
				order = 2,
				name = L["Defensive CDs"],
				desc = L["Defensive and healing cooldowns, e.g. Shield Wall or Swiftmend."],
			},
			interrupt = {
				["a"] = 0.7,
				["b"] = 0,
				["g"] = 1,
				["r"] = 1,
				order = 3,
				name = L["Interrupts and Silences"],
				desc = L["Abilities that interrupt spellcasting or silence, e.g. Kick."],
			},
			cc = {
				["a"] = 0.7,
				["b"] = 1,
				["g"] = 0,
				["r"] = 1,
				order = 4,
				name = L["Crowd Control"],
				desc = L["Abilities that make you lose control of your character, e.g. Fear or Polymorph."],
			},
			root = {
				["a"] = 0.7,
				["b"] = 0,
				["g"] = 0.5,
				["r"] = 1,
				order = 5,
				name = L["Roots and Snares"],
				desc = L["Spells that restrict or prevent movement, e.g. Frost Nova or Hamstring."],
			},
			misc = {
				["a"] = 0.7,
				["b"] = 0.7,
				["g"] = 0.7,
				["r"] = 0.7,
				order = 6,
				name = L["Miscellaneous Spells"],
				desc = L["Anything else. Spells that don't really fit into other categories."],
			},
			custom1 = {
				["a"] = 0.7,
				["b"] = 0.7,
				["g"] = 0.7,
				["r"] = 0.7,
				order = 11,
				name = sformat("%s %d", L["Custom Anchor"], 1),
				desc = L["You can use these to display certain important spells in a separate anchor. Use the Spell Configuration menu to move spells here."],
			},
			custom2 = {
				["a"] = 0.7,
				["b"] = 0.7,
				["g"] = 0.7,
				["r"] = 0.7,
				order = 12,
				name = sformat("%s %d", L["Custom Anchor"], 2),
				desc = L["You can use these to display certain important spells in a separate anchor. Use the Spell Configuration menu to move spells here."],
			},
			custom3 = {
				["a"] = 0.7,
				["b"] = 0.7,
				["g"] = 0.7,
				["r"] = 0.7,
				order = 13,
				name = sformat("%s %d", L["Custom Anchor"], 3),
				desc = L["You can use these to display certain important spells in a separate anchor. Use the Spell Configuration menu to move spells here."],
			},
		},
		Spells = {
			[586] = {
				glyph3 = true,
				glyph0 = true,
			},
			[47585] = {
				glyph3 = true,
			},
			[1850] = {
				glyph3 = true,
				glyph0 = true,
				glyph1 = true,
				glyph2 = true,
			},
			[86121] = {
				glyph1 = true,
			},
			[64044] = {
				glyph3 = true,
			},
		},
	},
}

addon.Const.On = "|cFF00FF00on"
addon.Const.Off = "|cFFFF0000off"
addon.Const.Racial = string.format("|cFFa0a0a0%s", L["Racial"])
addon.Const.Item = string.format("|cFFa0a0a0%s", L["Item"])

addon.Const.Classes = {}
FillLocalizedClassList(addon.Const.Classes)
tsort(addon.Const.Classes)

-- list of arena brackets
addon.Const.Arenas = {
	["2v2"] = "2v2",
	["3v3"] = "3v3",
	["5v5"] = "5v5",
}

-- build a list of channels, excluding server channels
-- based on Prat's similar function
local function BuildChannelTable(t, k, v, ...)
	if k and v then
		local isServer = false
		for _, x in pairs({EnumerateServerChannels()}) do
			if v == x then isServer = true; break end
		end
		if not isServer then t[k] = v end
		return BuildChannelTable(t, ...)
	end

	return t
end

-- list of targets for spell alerts
function addon:GetMessageFrames()
	-- builtin stuff
	local t = {
		["_none_"] = L["- DISABLED -"],
		["default"] = L["Default Chat Frame"],
		["screen"] = L["Faked RW"],
		["party"] = L["Party chat"],
		["raid"] = L["Raid chat"],
		["bg"] = L["Battleground chat"],
		["rw"] = L["Raid Warning"],
	}

	-- add chat windows
	for i=2, 9 do
		local name = "ChatFrame"..i
		-- check if chatframe exists
		-- any better way?
		if #_G[name].messageTypeList > 0 then
			t["chat"..i] = sformat("%s: %s (%d)", L["Chat"], _G[name].name, i)
		end
	end

	-- add custom channels
	local list = BuildChannelTable({}, GetChannelList())
	for k, v in pairs(list) do
		t["channel"..k] = sformat("%s: %s (%d)", L["Channel"], v, k)
	end

	-- add MSBT frames if available
	if MSBT then
		for k, v in MSBT:IterateScrollAreas() do
			t["MSBT_"..k] = "MSBT: "..v
		end
	end

	-- add SCT frames if available
	if SCT then
		t["SCT_Frame1"] = "SCT: Frame 1"
		t["SCT_Frame2"] = "SCT: Frame 2"
		t["SCT_FrameMsg"] = "SCT: Message Frame"
		if SCTD then t["SCT_Damage"] = "SCT: Damage" end
	end

	-- add Parrot frames if available
	if Parrot then
		for k, v in pairs(Parrot:GetScrollAreasChoices()) do
			t["Parrot_"..k] = "Parrot: "..v
		end
	end

	-- add builtin combat text if enabled
	if IsAddOnLoaded("Blizzard_CombatText") then
		t["BlizzCT"] = L["Combat Text"]
	end

	return t
end

-- frame attaching points
addon.Const.Attach = {
	["TOPLEFT"] = L["Top Left"],
	["TOP"] = L["Top"],
	["TOPRIGHT"] = L["Top Right"],
	["LEFT"] = L["Left"],
	["CENTER"] = L["Center"],
	["RIGHT"] = L["Right"],
	["BOTTOMLEFT"] = L["Bottom Left"],
	["BOTTOM"] = L["Bottom"],
	["BOTTOMRIGHT"] = L["Bottom Right"],
}

-- icon attaching points
addon.Const.IconPosition = {
	["INSIDELEFT"] = L["Above or below, on left"],
	["INSIDECENTER"] = L["Above or below, centered"],
	["INSIDERIGHT"] = L["Above or below, on right"],
	["LEFT"] = L["Left"],
	["RIGHT"] = L["Right"],
}

-- text justify options
addon.Const.Justify = {
	["LEFT"] = L["Left"],
	["CENTER"] = L["Center"],
	["RIGHT"] = L["Right"],
}

-- text position options
addon.Const.TextPosition = {
	["BOTTOM"] = L["Bottom"],
	["TOP"] = L["Top"],
	["LEFT"] = L["Left"],
	["CENTER"] = L["Center"],
	["RIGHT"] = L["Right"],
}

-- bar start positions
addon.Const.StartPoint = {
	["bottomright"] = L["Below on right"],
	["bottomleft"] = L["Below on left"],
	["topright"] = L["Above on right"],
	["topleft"] = L["Above on left"]
}

-- unitIDs for anchors
addon.Const.Units = {
	["Anchor_Target"] = "target",
	["Anchor_Focus"] = "focus",
	["Anchor_Arena1"] = "arena1",
	["Anchor_Arena2"] = "arena2",
	["Anchor_Arena3"] = "arena3",
	["Anchor_Arena4"] = "arena4",
	["Anchor_Arena5"] = "arena5",
}

addon.Const.FontFlags = {
	[""] = L["No outline"],
	["OUTLINE"] = L["Normal outline"],
	["THICKOUTLINE"] = L["Thick outline"],
}

--list of specs
addon.Const.Specs = {
	["default"] = {
		color = {r=1.0, g=1.0, b=1.0},
		icon = "Interface\\GossipFrame\\ActiveQuestIcon",
		name = L["Unknown Spec"],
	},
	["DEATHKNIGHT"] = {
		[1] = {
            id = 250,
			color = {r=1.0, g=0.0, b=0.0},
		},
		[2] = {
            id = 251,
			color = {r=0.3, g=0.5, b=1.0},
		},
		[3] = {
            id = 252,
			color = {r=0.2, g=0.8, b=0.2},
		}
	},

	["DRUID"] = {
		[1] = {
            id = 102,
			color = {r=0.8, g=0.3, b=0.8},
		},
		[2] = {
            id = 103,
			color = {r=1.0, g=0.0, b=0.0},
		},
        [3] = {
            id = 104,
            color = {r=1.0, g=0.0, b=0.0},
        },
        [4] = {
            id = 105,
			color = {r=0.4, g=0.8, b=0.2},
		}
	},

	["HUNTER"] = {
		[1] = {
            id = 253,
			color = {r=1.0, g=0.0, b=0.3},
		},
		[2] = {
            id = 254,
			color = {r=0.3, g=0.6, b=1.0},
		},
		[3] = {
            id = 255,
			color = {r=1.0, g=0.6, b=0.0},
		}
	},

	["MAGE"] = {
		[1] = {
            id = 62,
			color = {r=0.7, g=0.2, b=1.0},
		},
		[2] = {
            id = 63,
			color = {r=1.0, g=0.5, b=0.0},
		},
		[3] = {
            id = 64,
			color = {r=0.3, g=0.6, b=1.0},
		}
	},

    ["MONK"] = {
        [1] = {
            id = 268,
            color = {r=0.7, g=0.7, b=0.0},
        },
        [2] = {
            id = 269,
            color = {r=0.0, g=0.3, b=1.0},
        },
        [3] = {
            id = 270,
            color = {r=0.0, g=1.0, b=0.3},
        }
    },

    ["PALADIN"] = {
		[1] = {
            id = 65,
			color = {r=1.0, g=0.5, b=0.0},
		},
		[2] = {
            id = 66,
			color = {r=0.3, g=0.5, b=1.0},
		},
		[3] = {
            id = 70,
			color = {r=1.0, g=0.0, b=0.0},
		}
	},

	["PRIEST"] = {
		[1] = {
            id = 256,
			color = {r=1.0, g=0.5, b=0.0},
		},
		[2] = {
            id = 257,
			color = {r=0.6, g=0.6, b=1.0},
		},
		[3] = {
            id = 258,
			color = {r=0.7, g=0.4, b=0.8},
		}
	},

	["ROGUE"] = {
		[1] = {
            id = 259,
			color = {r=0.5, g=0.8, b=0.5},
		},
		[2] = {
            id = 260,
			color = {r=1.0, g=0.5, b=0.0},
		},
		[3] = {
            id = 261,
			color = {r=0.3, g=0.5, b=1.0},
		}
	},

	["SHAMAN"] = {
		[1] = {
            id = 262,
			color = {r=0.8, g=0.2, b=0.8},
		},
		[2] = {
            id = 263,
			color = {r=0.3, g=0.5, b=1.0},
		},
		[3] = {
            id = 264,
			color = {r=0.2, g=0.8, b=0.4},
		}
	},

	["WARLOCK"] = {
		[1] = {
            id = 265,
			color = {r=0.0, g=1.0, b=0.6},
		},
		[2] = {
            id = 266,
			color = {r=1.0, g=0.0, b=0.0},
		},
		[3] = {
            id = 267,
			color = {r=1.0, g=0.5, b=0.0},
		}
	},

	["WARRIOR"] = {
		[1] = {
            id = 71,
			color = {r=1.0, g=0.72, b=0.1},
		},
		[2] = {
            id = 72,
			color = {r=1.0, g=0.0, b=0.0},
		},
		[3] = {
            id = 73,
			color = {r=0.3, g=0.5, b=1.0},
		}
	},
}

-- fill in spec names and icons
for k, v in pairs(addon.Const.Specs) do
    for i = 1, 4 do
        if v[i] and v[i].id then
            local _, name, _, icon = GetSpecializationInfoByID(v[i].id)
            v[i].name = name
            v[i].icon = icon
        end
    end
end

addon.Const.DefaultIcon = addon.Const.Specs["default"].icon

-- create db
addon.DB = LibStub("AceDB-3.0"):New("PTDB", addon.Defaults, true)

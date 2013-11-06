local addon = PvPTimer

local AceGUI = addon.Lib.AceGUI
local L = addon.Locale
local ST = LibStub("ScrollingTable");

local type = type
local unpack = unpack
local pairs = pairs
local tonumber = tonumber
local sformat = string.format
local GetSpellInfo = GetSpellInfo
local select = select

local const_racial = addon.Const.Racial
local const_item = addon.Const.Item
local const_on = addon.Const.On
local const_off = addon.Const.Off
local specs = addon.Const.Specs
local tt = PT_Tooltip

local classes = addon.Const.Classes
local classFilter = {
	["RACIAL"] = true,
	["ITEM"] = true,
}
for k in pairs(classes) do
	classFilter[k] = true
end

local classFilterBoxes = {}
local categoryDropdown
local spellST
local currentSpell

local COLUMN_ID = 1
local COLUMN_NAME = 2
local COLUMN_CLASS = 3
local COLUMN_TYPE = 4
--local COLUMN_DURATION = 5
local COLUMN_CD = 5
local COLUMN_G0 = 6
local COLUMN_G1 = 7
local COLUMN_G2 = 8
local COLUMN_G3 = 9
local COLUMN_G4 = 10

-- table cell update functions

local function ST_GetSpellIcon(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
	if fShow then 
		local spellID = tonumber(data[realrow].cols[COLUMN_ID].value)
    	local texture = select(3, GetSpellInfo(spellID))
        if texture == nil then print (spellID) end
  		cellFrame.text:SetText("|T"..texture..":16:16|t")
	end
end

local function ST_GetSpellName(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
	if fShow then
		local text = data[realrow].cols[COLUMN_NAME].value
		local id = data[realrow].cols[COLUMN_ID].value
		local db = addon.DB.profile.Spells
		
		if db[id] and db[id].enabled == false then
			cellFrame.text:SetText("|c80FF0000"..text)
		else
			cellFrame.text:SetText("|CFFFFFFFF"..text)
		end
	end
end

local function ST_GetClass(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
	if fShow then
		local class = data[realrow].cols[COLUMN_CLASS].value
		if classes[class] then
			local color = RAID_CLASS_COLORS[class]
			local text = "|CFF"..addon:RGBtoHex(color)..classes[class]
			cellFrame.text:SetText(text)
		elseif class == "RACIAL" then
			cellFrame.text:SetText(const_racial)
		else
			cellFrame.text:SetText(const_item)
		end
	end				
end

local function ST_GetGlyph(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
	if fShow then
		local id = data[realrow].cols[1].value
		local glyph = data[realrow].cols[COLUMN_G0].value
		local class = data[realrow].cols[COLUMN_CLASS].value
		local spell = addon.Spells[id]
		local spec = 0
		if spell.spec then
			spec = spell.spec
		end
		if glyph == 0 or class == "ITEM" or class == "RACIAL" or (spec ~=0 and column - spec ~= COLUMN_G0) then
			cellFrame.text:SetText("|c80808080N/A")
			cellFrame.text:SetJustifyH("CENTER")
			return
		end

		local db = addon.DB.profile.Spells
		local id = data[realrow].cols[COLUMN_ID].value
		local text
		if column == COLUMN_G0 then
			text = "|T"..specs["default"].icon..":16:16|t "
        else
            if column == COLUMN_G4 and not (class == "DRUID") then
                cellFrame.text:SetText("|c80808080N/A")
                cellFrame.text:SetJustifyH("CENTER")
                return
            else
			    text = "|T"..specs[class][column-COLUMN_G0].icon..":16:16|t "
            end
		end
		
		if (column == COLUMN_G0 and db[id] and db[id].glyph0) or
			(column == COLUMN_G1 and db[id] and db[id].glyph1) or
			(column == COLUMN_G2 and db[id] and db[id].glyph2) or
            (column == COLUMN_G3 and db[id] and db[id].glyph3) or
            (column == COLUMN_G4 and db[id] and db[id].glyph4) then
			text = text..const_on
		else
			text = text..const_off
		end
		
		cellFrame.text:SetJustifyV("CENTER")
		cellFrame.text:SetText(text)
	end				
end

local function ST_GetTime(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
	if fShow then
		local number = tonumber(data[realrow].cols[column].value)
		local text = addon:ConvertTime(number)
		cellFrame.text:SetText(text)
	end
end

local function ST_GetSpellCategory(rowFrame, cellFrame, data, cols, row, realrow, column, fShow, self, ...)
	if fShow then
		local cat = data[realrow].cols[column].value
		local spellcat = addon.DB.profile.SpellCategories[cat or "misc"]
		local text = sformat("|cFF%02x%02x%02x%s", spellcat.r*255, spellcat.g*255, spellcat.b*255, spellcat.name)
		cellFrame.text:SetText(text)
	end
end

local function GetSpellTableData()
	local categories = addon.DB.profile.SpellCategories
	
	local src = addon.Spells
	local sd = {}
	local glyphed = ""

	for k, v in pairs(src) do
		if type(v) == "table" then
			local spelltype = addon:GetSpellType(k)
			sd[#sd+1] = {
				cols = {
					{--ID
						value = k,
					},
					{--Name
						value = v.name,
					},
					{--Class
						value = v.class or "ITEM",
					},
					{--Type
						value = spelltype,
						color = categories[spelltype]
					},
--					{--Duration
--						value = v.duration or "---",
--					},
					{--CD
						value = v.cooldown or "---",
					},
					{--Glyph
						value = v.cooldown_g or 0,
					},
					{--Glyph
						value = v.cooldown_g or 0,
					},
					{--Glyph
						value = v.cooldown_g or 0,
					},
					{--Glyph
						value = v.cooldown_g or 0,
					},
                    {--Glyph
                        value = v.cooldown_g or 0,
                    },
                },
			}
		end
	end
	
	return sd
end

-- filters spells
local function SpellFilter(self, row)
	local class = row.cols[COLUMN_CLASS].value
	if classFilter[class] then
		return true
	end
	return false
end

local function SetSpellCategory(self, event, value)
	if currentSpell then
		local db = addon.DB.profile.Spells
		if not db[currentSpell] then
			db[currentSpell] = {}
		end
		db[currentSpell].type = value
	end
	spellST:SetData(GetSpellTableData())
	addon:RefreshAnchors(true)
end

-- handle table tooltips and dropdowns
local function TableEnter(rowFrame, cellFrame, data, cols, row, realrow, column, tableFrame, ...)
	if not realrow then return end

	local spell = tonumber(data[realrow].cols[COLUMN_ID].value)
	local glyph = tonumber(data[realrow].cols[COLUMN_G0].value)
	local stype = data[realrow].cols[COLUMN_TYPE].value

	local dd = categoryDropdown.frame
	local ddp = categoryDropdown.pullout
	if column == COLUMN_TYPE then
		dd:Show()
	else
		dd:Hide()
	end

	if ddp:IsShown() ~= 1 then
		currentSpell = spell
		dd:SetPoint("TOPLEFT", cellFrame)
		dd:SetFrameLevel(cellFrame:GetFrameLevel() + 1)
		categoryDropdown:SetValue(stype)
	end
	
	if spell>0 then
		local db = addon.DB.profile.Spells
		if not db[spell] then db[spell] = {} end
		db = db[spell]
		
		local class = data[realrow].cols[COLUMN_CLASS].value
		local cooldown = tonumber(data[realrow].cols[COLUMN_CD].value)
		local spelldata = addon.Spells[spell]

		local spec
		if spelldata.spec then
			spec = spelldata.spec
		else
			spec = 0
		end
		
		tt:SetOwner(cellFrame, "ANCHOR_RIGHT", 5, -5)
		tt:SetSpellByID(spell)
		
		if class == "RACIAL" and column == COLUMN_NAME then
			tt:AddLine("\n"..L["Click here to enable/disable this racial."], 0, 1, 0, true)
			tt:Show()
			return
		end
		if class == "ITEM" and column == COLUMN_NAME then
			tt:AddLine("\n"..L["Click here to enable/disable this item."], 0, 1, 0, true)
			tt:Show()
			return
		end

		if column == COLUMN_G0 and glyph ~= 0 then
			tt:AddLine("\n"..L["Click here to enable/disable the glyph of this spell when the unit's talent spec is unknown. This should make the cooldown timers more accurate."], 0, 1, 0, true)
		elseif column >= COLUMN_G1 and column <= COLUMN_G4 and data[realrow].cols[column].value ~= 0 then
			tt:AddLine("\n"..L["Click here to enable/disable the glyph of this spell for this talent spec. This should make the cooldown timers more accurate."], 0, 1, 0, true)
		elseif column == COLUMN_NAME then
			tt:AddLine("\n"..L["Click here to enable/disable this spell."], 0, 1, 0, true)
		end

		tt:AddLine("\n"..L["Base cooldown: "]..addon:ConvertTime(cooldown), 1, 1, 1, false)

		if glyph and glyph ~= 0 then
			tt:AddLine(L["Glyph modifier: "]..addon:ConvertTime(glyph), 1, 1, 1, false)
		end
		
		if specs[class] then
			local line = ""
			if spec == 0 then line = line.."\n"..L["Unknown Spec"]..": "..addon:ConvertTime(addon:GetSpellCooldown(spell, 0)) end
			if spec == 0 or spec == 1 then line = line.."\n"..specs[class][1].name..": "..addon:ConvertTime(addon:GetSpellCooldown(spell, 1)) end
			if spec == 0 or spec == 2 then line = line.."\n"..specs[class][2].name..": "..addon:ConvertTime(addon:GetSpellCooldown(spell, 2)) end
			if spec == 0 or spec == 3 then line = line.."\n"..specs[class][3].name..": "..addon:ConvertTime(addon:GetSpellCooldown(spell, 3)) end
			if class == 'DRUID' then
                if spec == 0 or spec == 4 then line = line.."\n"..specs[class][4].name..": "..addon:ConvertTime(addon:GetSpellCooldown(spell, 4)) end
            end
            tt:AddLine(line, 1, 1, 1, true)
		end

		tt:Show()
	else
		tt:Hide()
	end
end

-- handle sorting and clicks
local function TableClick(rowFrame, cellFrame, data, cols, row, realrow, column, tableFrame, button, ...)
	-- table header clicked, do sort
	if not realrow then
		tableFrame.DefaultEvents["OnClick"](rowFrame, cellFrame, data, cols, row, realrow, column, tableFrame, button, ...)
		return true
	end

	local id = data[realrow].cols[COLUMN_ID].value
	local glyph = data[realrow].cols[COLUMN_G0].value
	-- glyph settings
	if column == COLUMN_NAME then
		local db = addon.DB.profile.Spells
		local id = data[realrow].cols[COLUMN_ID].value
		if not db[id] or db[id].enabled == nil then
			db[id] = {}
			db[id].enabled = false
		else
			db[id].enabled = not db[id].enabled
		end
	elseif column >= COLUMN_G0 and column <= COLUMN_G4 and glyph ~= 0 then
		local db = addon.DB.profile.Spells
		if not db[id] then db[id] = {} end
		if column == COLUMN_G0 then
			db[id].glyph0 = not db[id].glyph0
		elseif column == COLUMN_G1 then
			db[id].glyph1 = not db[id].glyph1
		elseif column == COLUMN_G2 then
			db[id].glyph2 = not db[id].glyph2
		elseif column == COLUMN_G3 then
			db[id].glyph3 = not db[id].glyph3
        elseif column == COLUMN_G4 then
            db[id].glyph4 = not db[id].glyph4
        end
	-- enable/disable spell
	end
	-- refresh tooltip
	TableEnter(rowFrame, cellFrame, data, cols, row, realrow, column, tableFrame, ...)
	-- refresh table
	tableFrame:Refresh()
end

local spellTableCols = {
	{ name = "", width = 20, DoCellUpdate = ST_GetSpellIcon, },
	{ name = L["Name"], width = 155, defaultsort = "dsc", sort = "dsc", DoCellUpdate = ST_GetSpellName},
	{ name = L["Class"], width = 80, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetClass, },
	{ name = L["Category"], width = 140, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetSpellCategory},
	--{ name = L["Duration"], width = 60, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetTime, },
	{ name = L["Cooldown"], width = 80, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetTime, },
	{ name = L["Glyph"], width = 50, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetGlyph},
	{ name = L["Spec 1"], width = 50, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetGlyph},
	{ name = L["Spec 2"], width = 50, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetGlyph},
	{ name = L["Spec 3"], width = 50, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetGlyph},
    { name = L["Spec 4"], width = 50, align = "CENTER", defaultsort = "asc", sortnext = COLUMN_NAME, DoCellUpdate = ST_GetGlyph},
}
local spellTableRows = 33
local spellTableRowHeight = 16

function addon:CreateSpellConfig()
	addon.Window_SpellConfig = AceGUI:Create("Window")
	local f = addon.Window_SpellConfig

	f:SetCallback("OnClose", function() f:Hide() end)
	f:SetTitle(L["PvPTimer Spell Configuration"])
	f:SetLayout("List")
	f:SetWidth(955)
	f:SetHeight(598)
	f:SetPoint("CENTER", "UIParent", "CENTER")
	f:EnableResize(false)
	
	spellST = ST:CreateST(spellTableCols, spellTableRows, spellTableRowHeight, nil, f.frame)
	spellST:SetData(GetSpellTableData())
	spellST:SetFilter(SpellFilter)
--	spellST:EnableSelection(true)
	spellST:RegisterEvents({
		["OnClick"] = TableClick,
		["OnEnter"] = TableEnter,
		["OnLeave"] = function(rowFrame, cellFrame, data, cols, row, realrow, column, scrollingTable, ...)
			tt:Hide()
		end,
	})
	spellST.frame:SetPoint("TOPRIGHT", f.frame, "TOPRIGHT", -10, -45)

	local g = AceGUI:Create("SimpleGroup")
	g:SetWidth(160)
	f:AddChild(g)

	local filterClass = AceGUI:Create("InlineGroup")
	filterClass:SetTitle(L["Class Filter"])
	filterClass:SetRelativeWidth(1)
	g:AddChild(filterClass)

	local sortedClasses = {}
	for k in pairs(classes) do
		table.insert(sortedClasses, k)
	end
	table.sort(sortedClasses)

	for i, k in ipairs(sortedClasses) do
		classFilterBoxes[k] = AceGUI:Create("CheckBox")
		local x = classFilterBoxes[k]

		local left, right, top, bottom = unpack(CLASS_BUTTONS[k])
		left = left + (right - left) * 0.07
		right = right - (right - left) * 0.07
		top = top + (bottom - top) * 0.07
		bottom = bottom - (bottom - top) * 0.07
		x:SetImage("Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes", left, right, top, bottom)

		x:SetUserData("key", k)
		x:SetLabel(" "..classes[k])
		x:SetValue(classFilter[k])
		x:SetCallback("OnValueChanged", function(self, event, value) classFilter[self:GetUserData("key")] = value; spellST:SortData() end)
		filterClass:AddChild(x)
	end

	local filterRacial = AceGUI:Create("CheckBox")
	filterRacial:SetLabel(L["Racial"])
	filterRacial:SetValue(classFilter["RACIAL"])
	filterRacial:SetCallback("OnValueChanged", function(self, event, value) classFilter["RACIAL"] = value; spellST:SortData() end)
	filterClass:AddChild(filterRacial)

	local filterItems = AceGUI:Create("CheckBox")
	filterItems:SetLabel(L["Item"])
	filterItems:SetValue(classFilter["ITEM"])
	filterItems:SetCallback("OnValueChanged", function(self, event, value) classFilter["ITEM"] = value; spellST:SortData() end)
	filterClass:AddChild(filterItems)

	local filterCat = AceGUI:Create("Dropdown")
	filterCat:SetLabel(L["Category Filter"])
	filterCat:SetRelativeWidth(1)
	filterCat:SetMultiselect(true)
--	g:AddChild(filterCat)

	local help = AceGUI:Create("Label")
	help:SetText(L["SPELLCONFIG_HELPMSG"])
	help:SetWidth(160)
	help:SetFont(GameFontNormal:GetFont(), 13, "OUTLINE")
	f:AddChild(help)

	local cat = AceGUI:Create("Dropdown")
	local categories = {}
	for k, v in pairs(addon.DB.profile.SpellCategories) do
		categories[k] = v.name
	end
	cat:SetList(categories)
	cat:SetWidth(160)
	cat:SetCallback("OnValueChanged", SetSpellCategory)
	cat.frame:SetParent(f.frame)
	cat.frame:SetFrameStrata("FULLSCREEN_DIALOG")
	cat.frame:SetScale(0.8)
	cat.pullout:Close()
	categoryDropdown = cat

	f:Hide()
end

function addon:ToggleSpellConfig()
	if not addon.Window_SpellConfig then
		addon:CreateSpellConfig()
	end
	local f = addon.Window_SpellConfig

	if f and f:IsVisible() then
		f:Hide()
	else
		GameTooltip:Hide()
		f:Show()
	end
end

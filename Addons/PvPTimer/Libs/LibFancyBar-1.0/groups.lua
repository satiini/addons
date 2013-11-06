--@author Zardas
--@release API for creating and managing timer bar groups.
--Use lib:NewGroup to create a new group.
--All parameters are optional, use nil or just leave them out to omit them.

-- Default settings. Do not modify these directly, use the API calls.
local def_Width = 200
local def_MinWidth = 100
local def_MaxWidth = 1600
local def_StartPoint = "bottomright"
local def_MaxBars = 0
local def_Columns = 0
local def_MinColumns = 0
local def_MaxColumns = 50
--local def_AutoResize = true
local def_SortField = "time"
local def_SortAscending = false
local def_IconMode = false
local def_IconSize = 32
local def_SpacingH = 0
local def_SpacingV = 0
local def_IconTextPosition = "BOTTOM"
local def_IconTextOffsetH = 0
local def_IconTextOffsetY = 0

-- Set up libraries
local lib = LibStub("LibFancyBar-1.0")
local cbh = LibStub:GetLibrary("CallbackHandler-1.0")

-- Copy global functions to local
local GetTime = GetTime
local CreateFrame = CreateFrame
local setmetatable = setmetatable
local tremove = table.remove
local tsort = table.sort
local floor = floor
local unpack = unpack
local pairs = pairs
local ipairs = ipairs
local GT = GameTooltip
local mrand = math.random
local wipe = wipe
local GetSpellInfo = GetSpellInfo
local select = select
local hooksecurefunc = hooksecurefunc

local cfg = {
	"Columns",
	"Visible bars",
--	"Resize bars",
	"Bar starting point",
--	"Sorting"
--	"Icon Mode",
}

local startpoint = {
	["bottomright"] = "Below on right",
	["bottomleft"] = "Below on left",
	["topright"] = "Above on right",
	["topleft"] = "Above on left"
}

local sortfield = {
	"Time remaining",
	"Label (alphabetically)",
	"Time created"
}

local testicons = {
	49028, 49206, 47528, 77606, 91802, 49184, 5217, 5211, 29166, 18562, 48438, 5384, 82945,
	19236, 89485, 88685, 586, 88684, 6229, 6789, 6360, 17877, 2565, 6544, 5246, 498, 96231,
	20066, 20925
}

-- Create a dummy frame to store inherited functions.
-- Idea from LibBars-1.0 and LibCandyBar-3.0
lib.groupPrototype = lib.groupPrototype or CreateFrame("Frame")
lib.groupPrototype_mt = lib.groupPrototype_mt or {__index = lib.groupPrototype}

local groupPrototype = lib.groupPrototype
local groupPrototype_mt = lib.groupPrototype_mt

-- Dragging and resizing functions
local function onDragHandleMouseDown(self)
	self:GetParent():StartSizing("BOTTOMRIGHT")
end

local function onDragHandleMouseUp(self, button)
	self:GetParent():StopMovingOrSizing()
end

local function onResize(self, width)
	self.width = width

	self.callbacks:Fire("FancyBar_GroupResize", self, width)
	self:Rearrange()
end

local function onDragStart(self)
	self:StartMoving()
end

local function onDragStop(self)
	self:StopMovingOrSizing()

	local p, f, rp, x, y = self:GetPoint()
	self.callbacks:Fire("FancyBar_GroupMove", self, p, f, rp, x, y)
end

local function onSetScale(self, scale)
	for k in pairs(self.bars) do
		k:SetScale(scale)
	end
end

-- shows a tooltip
local function ShowTooltip(obj, header, text)
	GT:SetOwner(obj, "ANCHOR_BOTTOMLEFT", -2, -2)
	GT:ClearLines()
	GT:AddLine(header)
	GT:AddLine(" ")
	GT:AddLine(text, 1, 1, 1, true)
	GT:Show()
end

-- Bar sorting function
local function SortBars(a, b, field)
	-- sort using the time remaining
	if field == "time" then
		return (a.remaining < b.remaining)
	-- sort using the bar's label
	elseif field == "label" then
		return (a.labeltext < b.labeltext)
	-- no sorting, uses the bar's creation time
	elseif field == "created" then
		return (a.created < b.created)
	-- sort using a data field
	else
		return (a:GetData(field) < b:GetData(field))
	end
end

--- Creates a new timerbar group and returns it.
--@param width Width of the group in pixels.
--Default: 200.
--@param title Title of the group. This is shown when the group is unlocked for moving.
--@param name Name of the group. This is used to access the group.
function lib:NewGroup(width, title, name)
	local f = CreateFrame("Frame", name, UIParent)
	f:SetWidth(width or def_Width)
	f:SetHeight(20)
	f:SetMinResize(def_MinWidth, f:GetHeight())
	f:SetMaxResize(def_MaxWidth, f:GetHeight())
	f:SetClampedToScreen(true)

	-- import prototype functions
	local group = setmetatable(f, groupPrototype_mt)

	local bg = group:CreateTexture(nil, "PARENT")
	bg:SetAllPoints(group)
	bg:SetBlendMode("BLEND")
	bg:SetTexture(0, 0, 0, 0.5)
	group.FG_Header = bg

	local drag = CreateFrame("Frame", nil, group)
	drag:SetFrameLevel(group:GetFrameLevel() + 10)
	drag:SetWidth(16)
	drag:SetHeight(16)
	drag:SetPoint("BOTTOMRIGHT", bg)
	drag:EnableMouse(true)
	drag:SetScript("OnMouseDown", onDragHandleMouseDown)
	drag:SetScript("OnMouseUp", onDragHandleMouseUp)
	group.FG_DragArea = drag

	local tex = drag:CreateTexture(nil, "BORDER")
	tex:SetBlendMode("ADD")
	tex:SetTexture("Interface\\Addons\\LibFancyBar-1.0\\draghandle")
	tex:SetAlpha(0.5)
	tex:SetPoint("BOTTOMRIGHT", bg)
	group.FG_DragHandle = tex

	local text = group:CreateFontString(nil, "ARTWORK")
	text:SetFontObject(GameFontNormal)
	text:SetText(title or "")
	text:SetAllPoints(group)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("MIDDLE")
	group.FG_HeaderText = text

	group:SetScript("OnSizeChanged", onResize)
	group:SetScript("OnDragStart", onDragStart)
	group:SetScript("OnDragStop", onDragStop)

	-- import callback functions
	group.callbacks = cbh:New(group)

	group.bars = {}
	group.title = title or ""
	group.name = name
	group:SetVisibleBars(def_MaxBars)
	group:SetColumns(def_Columns)
--	group:SetAutoResize(def_AutoResize)
	group:SetStartPoint(def_StartPoint)
	group.sortfield = def_SortField
	group.sortasc = def_SortAscending
	group:SetIconMode(def_IconMode, def_IconTextPosition, def_IconTextOffsetH, def_IconTextOffsetY)
	group:SetSpacing(def_SpacingH, def_SpacingV)
	group.iconsize = def_IconSize

	hooksecurefunc(group, "SetScale", onSetScale)

	group:Lock(true)

	return group
end

--- Rearranges the group's bars.
function groupPrototype:Rearrange()
	if self.bars == nil then return end
	local sh = self.spacing_h or 0
	local sv = self.spacing_v or 0

	local tmp = {}
	for bar in pairs(self.bars) do
		tmp[#tmp+1] = bar
	end
	tsort(tmp, function(a, b) return SortBars(a, b, self.sortfield) end)
	local lastBar = false
	local rowFirst = false
	local barNo = 0

	local barMax
	if self.maxbars>0 and self.maxbars <= #tmp then
		barMax = self.maxbars
	else
		barMax = #tmp
	end

	local startpoint = self.startpoint
	local width = self:GetWidth()
	local columns
	if self.columns == 0 then
		if self.iconmode then
			columns = floor((width+sh) / (self.iconmode+sh))
		else
			columns = 1
		end
	else
		columns = self.columns
	end

	local x, y, z, bar
	if self.sortasc then
		x = barMax
		y = 1
		z = -1
	else
		x = 1
		y = barMax
		z = 1
	end

	for i=x, y, z do
		bar = tmp[i]
		bar:Show()
		bar:ClearAllPoints()
		if not bar.iconmode then
			bar:SetWidth((width - (columns-1)*sh)/columns)
		end

		if rowFirst then
			sv = self.spacing_v
		else
			sv = 0
		end

		if startpoint == "topleft" then
			if (barNo % columns) == 0 then
				bar:SetPoint("BOTTOMLEFT", rowFirst or self, "TOPLEFT", 0, sv)
				rowFirst = bar
			else
				bar:SetPoint("LEFT", lastBar or self, "RIGHT", sh, 0)
			end
		elseif startpoint == "topright" then
			if (barNo % columns) == 0 then
				bar:SetPoint("BOTTOMRIGHT", rowFirst or self, "TOPRIGHT", 0, sv)
				rowFirst = bar
			else
				bar:SetPoint("RIGHT", lastBar or self, "LEFT", -sh, 0)
			end
		elseif startpoint == "bottomright" then
			if (barNo % columns) == 0 then
				bar:SetPoint("TOPRIGHT", rowFirst or self, "BOTTOMRIGHT", 0, -sv)
				rowFirst = bar
			else
				bar:SetPoint("RIGHT", lastBar or self, "LEFT", -sh, 0)
			end
		else
			if (barNo % columns) == 0 then
				bar:SetPoint("TOPLEFT", rowFirst or self, "BOTTOMLEFT", 0, -sv)
				rowFirst = bar
			else
				bar:SetPoint("LEFT", lastBar or self, "RIGHT", sh, 0)
			end
		end
		lastBar = bar
		barNo = barNo + 1
	end

	if self.maxbars>0 and self.maxbars < #tmp then
		for i=self.maxbars+1, #tmp do
			tmp[i]:Hide()
		end
	end
end

--- Sets icon mode for all bars in the group.
--@param size Size of the icons. 0/nil/false disables icon mode.
--@param textPosition Position of the timer text.
--Values: "BOTTOM", "TOP", "LEFT", "RIGHT", "CENTER".
--Default: "BOTTOM".
--@param textOffsetH Horizontal offset of the timer text.
--@param textOffsetY Vertical offset of the timer text.
function groupPrototype:SetIconMode(size, textPosition, textOffsetH, textOffsetY)
	if size == true or size == 1 then size = def_IconSize end
	self.iconmode = size
	self.icontextposition = textPosition
	self.icontextoffseth = textOffsetH
	self.icontextoffsety = textOffsetY

	local bars = self.bars
	for k in pairs(bars) do
		k:SetIconMode(size, textPosition, textOffsetH, textOffsetY)
	end
	self:Rearrange()
	self.callbacks:Fire("FancyBar_GroupIconMode", self, size)
end

--- Adds a bar to the group.
--@param bar Bar object to add.
function groupPrototype:Add(bar)
	self.bars[bar] = true
	bar.group = self
	bar:SetScale(self:GetScale())
	bar:SetIconMode(self.iconmode, self.icontextposition, self.icontextoffseth, self.icontextoffsety)
	self:Rearrange()
end

--- Removes a bar from the group.
--@param bar Bar object to remove.
function groupPrototype:Remove(bar)
	self.bars[bar] = nil
	bar.group = nil
	bar:SetScale(1)
	self:Rearrange()
end

--- Stops and clears all bars from the group.
--@param noEvent If true, bars will not fire their "FB_BarStop" event.
function groupPrototype:Clear(noEvent)
	local bars = self.bars

	for k in pairs(bars) do
		k:Stop(noEvent)
		bars[k] = nil
	end
end

--- Searches in the user data (set via the bar's :SetData() function) of the bars assigned to the group, and retrieves the first bar where key = value. Returns nil if not found.
--@param key Key to search.
--@param value Value to search.
function groupPrototype:Find(key, value)
	for k in pairs(self.bars) do
		if k.data[key] and k.data[key] == value then return k end
	end
	return nil
end

--- Stops and removes any test bars running.
function groupPrototype:StopTest()
	for bar in pairs(self.bars) do
		if bar:GetData("__test") then bar:Stop(true) end
	end
	self.callbacks:Fire("FancyBar_GroupTestStop", self)
end

--- Shows a number of test bars in the group.
-- @param number The number of bars to show.
-- @param icons List of spellID numbers to use. Bar text and icons are retrieved via GetSpellInfo.
-- Default: 50.
function groupPrototype:RunTest(number, icons)
	self:StopTest()

	if not number then number = 50 end
	if not icons then icons = testicons end

	for i=1, number do
		local bar = lib:NewBar(self, 200, 16)
		local spell = icons[mrand(1, #icons)]
		local name = "[Test] "..GetSpellInfo(spell)
		local icon = select(3, GetSpellInfo(spell))

		bar:SetLabel(name)
		bar:SetData("icon", icon)
		bar:SetData("name", name)
		bar:SetData("__test", true)
		bar:SetIcon()
		bar:SetDuration(mrand(1, 30), 30)
		bar:SetFlash(8, 1, 1)
		bar:SetGhost(3, nil, "|cFF00FF00Ready", {0.1, 0.1, 0.8, 0.8})
		bar:SetFadeout(1)
		bar:SetSpark(true)
		bar:Start()
	end
	self:Rearrange()
	self.callbacks:Fire("FancyBar_GroupTestStart", self)
end

--- Locks/unlocks the group so it can be moved and resized.
-- Register callbacks "FB_GroupMoved" and "FB_GroupResized" to get the new position and size, respectively.
-- @param state The group is to be locked (true) or unlocked (false)
function groupPrototype:Lock(state)
	if state then
--		self:StopTest()

		self:EnableMouse(false)
		self:SetMovable(false)
		self:SetResizable(false)
		self:RegisterForDrag(nil)

		self.FG_Header:Hide()
		self.FG_HeaderText:Hide()
		self.FG_DragArea:Hide()
		self.FG_DragHandle:Hide()
	else
		self:EnableMouse(true)
		self:SetMovable(true)
		self:SetResizable(true)
		self:RegisterForDrag("LeftButton")

		self.FG_Header:Show()
		self.FG_HeaderText:Show()
		self.FG_DragArea:Show()
		self.FG_DragHandle:Show()

	end
	self.callbacks:Fire("FancyBar_GroupLock", self, state)
end

--[[
--- Automatically resize bars to fit the width of the group.
--For example if the group is 200 pixels wide and it has 2 columns, then bars are resized to 100 pixels.
--@param resize True or false.
--Default: true.
function groupPrototype:SetAutoResize(resize)
	self.autoresize = resize
	self.FG_ConfigResize:SetChecked(resize)
	self:Rearrange()
	self.callbacks:Fire("FancyBar_ChangedAutoResize", self, resize)
end
]]

--- Sets the maximum number of bars showing for this group. If nil, the group shows all bars added to it.
--@param maxBars The number of bars to show at once.
--Default: nil.
function groupPrototype:SetVisibleBars(maxBars)
	if not maxBars then maxBars = 0 end
	self.maxbars = maxBars
	self:Rearrange()
	self.callbacks:Fire("FancyBar_GroupVisibleBars", self, maxBars)
end

--- Sets the number of columns this group's bars are arranged into.
--@param columns Number of columns.
--Default: 1.
function groupPrototype:SetColumns(columns)
	if columns and columns > 0 then
		self.columns = columns
	else
		self.columns = 0
	end
	self:Rearrange()
	self.callbacks:Fire("FancyBar_GroupColumns", self, self.columns)
end

--- Sets the sorting method used to sort the group's bars.
--@param field Sorting field used.
--Values: "label" (label text alphabetically), "time" (time remaining), "created" (time the bar is created) or a data variable stored via the bar's SetData function (make sure it's set in all bars, is not nil and of the same type).
--Default: "time".
--@param ascending Arranges bars in ascending order.
--Values: true, false.
--Default: false.
function groupPrototype:SetSorting(field, ascending)
	self.sortfield = field
	self.sortasc = ascending
	self:Rearrange()
	self.callbacks:Fire("FancyBar_GroupSorting", self, field, ascending)
end

--- Sets the corner to start bars from.
--@param point
--Values: "bottomleft", "bottomright", "topleft", "topright".
--Default: "bottomleft".
function groupPrototype:SetStartPoint(point)
	if point == "bottomleft" or point == "bottomright" or point == "topleft" or point == "topright" then
		self.startpoint = point
		self:Rearrange()
		self.callbacks:Fire("FancyBar_GroupStartPoint", self, point)
	end
end

--- Sets the spacing between timers. Default is 0/0 (no spacing).
--@param h Horizontal spacing in pixels.
--@param v Vertical spacing in pixels.
function groupPrototype:SetSpacing(h, v)
	self.spacing_h = h
	self.spacing_v = v
	self:Rearrange()
end
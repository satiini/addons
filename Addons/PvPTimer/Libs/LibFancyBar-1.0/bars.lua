--@author Zardas
--@release API for creating and managing timer bars.
--Use lib:NewBar to create a new bar, customize it with the various functions, then use bar:Start() to show and start it.
--All parameters are optional, use nil or just leave them out to omit them.
--Colors are expected in {r, g, b, a} format.

-- Default settings. Do not modify these directly, use the API calls.
local def_Width = 100
local def_Height = 16
local def_Fill = false
local def_IconMode = false
local def_IconSize = 32
local def_Texture = "Interface\\TargetingFrame\\UI-StatusBar"
local def_Color = {0, 0.8, 0}
local def_Alpha = 0.8
local def_BackgroundTexture = "Interface\\TargetingFrame\\UI-StatusBar"
local def_BackgroundColor = {0, 0, 0}
local def_BackgroundAlpha = 0.3
local def_FlashFrequency = false
local def_FlashCooldown = 2
local def_FlashColor = false
local def_Spark = true
local def_SparkTexture = "Interface\\CastingBar\\UI-CastingBar-Spark"
local def_SparkColor = {1, 1, 1}
local def_SparkAlpha = 1
local def_Icon = false
local def_IconLeft = true
local def_IconRight = false
local def_Label = false
local def_LabelFont = "GameFontHighlightSmallOutline"
local def_LabelFontSize = false
local def_Duration = 10
local def_DurationFont = "GameFontHighlightSmallOutline"
local def_DurationFontSize = false
local def_IconTextPosition = "BOTTOM"
local def_IconTextOffsetH = 0
local def_IconTextOffsetY = 0

-- Set up libraries
local major = "LibFancyBar-1.0"
local minor = tonumber(("33"):match("(%d+)")) or 1
if not LibStub then error("LibFancyBar-1.0 requires LibStub.") end

local cbh = LibStub:GetLibrary("CallbackHandler-1.0")
if not cbh then error("LibFancyBar-1.0 requires CallbackHandler-1.0.") end

local lib, old = LibStub:NewLibrary(major, minor)
if not lib then return end

lib.callbacks = lib.callbacks or cbh:New(lib)
local cb = lib.callbacks

-- Copy global functions to local
local GetTime = GetTime
local CreateFrame = CreateFrame
local setmetatable = setmetatable
local tremove = table.remove
local tsort = table.sort
local floor = floor
local unpack = unpack
local hooksecurefunc = hooksecurefunc
local wipe = wipe
local smatch = string.match

-- Create a dummy frame to store inherited functions.
-- Idea from LibBars-1.0 and LibCandyBar-3.0
lib.dummyFrame = lib.dummyFrame or CreateFrame("Frame")
lib.barFrameMT = lib.barFrameMT or {__index = lib.dummyFrame}
lib.barPrototype = lib.barPrototype or setmetatable({}, lib.barFrameMT)
lib.barPrototype_mt = lib.barPrototype_mt or {__index = lib.barPrototype}
local barPrototype = lib.barPrototype
local barPrototype_mt = lib.barPrototype_mt

-- Create a bar cache so we don't have to recreate elements every time.
-- Idea from LibCandyBar-3.0
lib.barPool = lib.barPool or {}
local barPool = lib.barPool

-- Time formatting function.
-- Based on LibCandyBar-3.0's similar function.
local function ConvertTime(t)
	if t >= 3600 then -- > 1 hour
		return "%d:%02d", floor(t/3600), floor((t%3600)/60)
	elseif t >= 60 then -- 1 minute to 1 hour
		return "%d:%02d", floor(t/60), t%60
	elseif t < 10 then -- 0 to 10 seconds
		return "%1.1f", t
	else -- 10 seconds to one minute
		return "%d", floor(t)
	end
end

-- Saves alpha value for alpha-based functions.
local function SaveAlpha(self, alpha)
	if self.stage ~= "fadein" and self.stage ~= "fadeout" then
		self.alpha = alpha
	end
end

-- Returns the opposite of a point.
local function ReversePoint(point)
	if point == "TOPLEFT" then return "BOTTOMRIGHT"
	elseif point == "TOP" then return "BOTTOM"
	elseif point == "TOPRIGHT" then return "BOTTOMLEFT"
	elseif point == "LEFT" then return "RIGHT"
	elseif point == "RIGHT" then return "LEFT"
	elseif point == "BOTTOMLEFT" then return "TOPRIGHT"
	elseif point == "BOTTOM" then return "TOP"
	elseif point == "BOTTOMRIGHT" then return "TOPLEFT"
	else return "CENTER" end
end

-- Adjusts the bar when a new stage (ghost, fadeout, etc.) begins
local function ChangeStage(bar, stage)
	if not bar or not stage then return end

	if bar.stage == "running" then
		bar.callbacks:Fire("FancyBar_BarTimerExpire", bar)
	elseif bar.stage == "ghost" then
		bar.callbacks:Fire("FancyBar_BarGhostEnd", bar)
	end

	if stage == "ghost" then
		bar.callbacks:Fire("FancyBar_BarGhostStart", bar)

		bar.remaining = 0
		bar.FB_Bar:SetValue(0)
		if bar.ghostlabel then
			bar.FB_Label:SetText(bar.ghostlabel)
		end
		if bar.ghosttimer then
			bar.FB_Duration:SetText(bar.ghosttimer)
		end
		bar.FB_Spark:Hide()

		if bar.ghosttexture then bar.FB_Background:SetTexture(bar.ghosttexture) end
		if bar.ghostcolor then bar.FB_Background:SetVertexColor(unpack(bar.ghostcolor)) end
	elseif stage == "fadeout" then
		bar.callbacks:Fire("FancyBar_BarFadeout", bar)

		bar.remaining = 0
		bar.FB_Bar:SetValue(0)
		if bar.fadeoutlabel then
			bar.FB_Label:SetText(bar.fadeoutlabel)
		end
		if bar.fadeouttimer then
			bar.FB_Duration:SetText(bar.fadeouttimer)
		end
		bar.FB_Spark:Hide()

		if bar.fadeouttexture then bar.FB_Background:SetTexture(bar.fadeouttexture) end
		if bar.fadeoutcolor then bar.FB_Background:SetVertexColor(unpack(bar.fadeoutcolor)) end
	end
	bar.stage = stage
end

local function onUpdate(self)
	local t = GetTime()
	self.remaining = self.expires - t

	if t < self.expires then
	-- bar is running

		-- update status bar
		if self.fill then
			self.FB_Bar:SetValue(self.duration_max - self.remaining)
		else
			self.FB_Bar:SetValue(self.remaining)
		end

		-- update spark if enabled
		if self.spark then
			local offset = self.remaining/self.duration_max*self.FB_Bar:GetWidth()
			if self.fill then
				self.FB_Spark:SetPoint("CENTER", self.FB_Bar, "RIGHT", -offset, 0)
			else
				self.FB_Spark:SetPoint("CENTER", self.FB_Bar, "LEFT", offset, 0)
			end
		end

		-- update flash effect if enabled
		if self.flash and self.flash >= self.remaining then
			local timer = (t - self.started - (self.duration - self.flash)) % self.flashperiod
			local half = self.flashfrequency / 2
			if timer < self.flashfrequency/2 then
				self.FB_Bar:SetAlpha(self.alpha * (1 - timer/half))
				self.FB_Spark:SetAlpha(self.alpha * (1 - timer/half))
			elseif timer < self.flashfrequency then
				self.FB_Bar:SetAlpha(self.alpha * ((timer - half) / half))
				self.FB_Spark:SetAlpha(self.alpha * ((timer - half) / half))
			else
				self.FB_Bar:SetAlpha(self.alpha)
				self.FB_Spark:SetAlpha(self.alpha)
			end
		end

		-- update duration text
		self.FB_Duration:SetFormattedText(ConvertTime(self.remaining))
	elseif self.ghost and t < self.ghostexpires then
	-- bar is in ghost
		if self.stage ~= "ghost" then
			ChangeStage(self, "ghost")
		end
	elseif self.fadeout and t < self.fadeoutexpires then
	-- bar is fading out
		if self.stage ~= "fadeout" then
			ChangeStage(self, "fadeout")
		end
		-- update fadeout effect
		self:SetAlpha(self.alpha * ((self.fadeoutexpires - t)/self.fadeout))
	else
	-- all expired, stop bar
		self:Stop()
	end

end

--- Creates a new timerbar object and returns it. Use :Start() to actually show and start the bar.
-- @param group Bar group to add this bar to.
-- Default: nil (no group).
-- @param width Width of the bar in pixels.
-- Default: 100.
-- @param height Height of the bar in pixels.
-- Default: 16.
-- @param texture Path to the texture used for the bar.
-- Default: WoW's default castbar texture.
-- @return bar The bar object.
-- @usage
-- local fb = LibStub("LibFancyBar-1.0")
-- -- Creates a new default 100x16 pixels bar.
-- mybar = fb:NewBar()
-- -- Creates a new 300x50 pixels bar.
-- mybar = fb:NewBar(nil, 300, 50)
-- -- Creates a bar with your custom texture, 150x20 size, and adds it to mygroup.
-- mybar2 = fb:NewBar(mygroup, 150, 20, "Interface\\AddOns\\MyAddOn\\media\\mytexture")
function lib:NewBar(group, width, height, texture)
	-- get a used bar if available
	local bar = tremove(barPool, 1)
	-- if not then create a new one
	if not bar then
		local f = CreateFrame("Frame", nil, UIParent)
		-- import prototype functions
		bar = setmetatable(f, barPrototype_mt)

		-- background texture
		local bg = bar:CreateTexture(nil, "BACKGROUND")
		bg:SetAllPoints(f)
		bar.FB_Background = bg

		-- statusbar
		local statusbar = CreateFrame("StatusBar", nil, bar)
		statusbar:SetFrameStrata("LOW")
		statusbar:SetAllPoints(bg)
		bar.FB_Bar = statusbar

		-- spark texture
		local spark = bar:CreateTexture(nil, "OVERLAY")
		spark:SetTexture(def_SparkTexture)
		spark:SetPoint("CENTER", statusbar, "RIGHT")
		spark:SetBlendMode("ADD")
		spark:SetWidth(18)
		spark:SetHeight(bar:GetHeight())
		bar.FB_Spark = spark

		-- left icon texture
		local icon = bar:CreateTexture(nil, "OVERLAY")
		icon:SetPoint("TOPLEFT")
		icon:SetPoint("BOTTOMLEFT")
		icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		bar.FB_Icon = icon

		-- right icon texture
		local icon2 = bar:CreateTexture(nil, "OVERLAY")
		icon2:SetPoint("TOPRIGHT")
		icon2:SetPoint("BOTTOMRIGHT")
		icon2:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		bar.FB_IconRight = icon2

		-- duration text
		local duration = bar:CreateFontString(nil, "OVERLAY", def_DurationFont)
		duration:SetPoint("RIGHT", statusbar, "RIGHT", -2, 0)
		bar.FB_Duration = duration

		-- label text
		local label = bar:CreateFontString(nil, "OVERLAY", def_LabelFont)
		label:SetPoint("LEFT", statusbar, "LEFT", 2, 0)
		label:SetPoint("RIGHT", duration, "LEFT", -2, 0)
		label:SetJustifyH("LEFT")
		bar.FB_Label = label

		-- import callback functions
		bar.callbacks = cbh:New(bar)

		-- save alpha value for fading functions
		hooksecurefunc(bar, "SetAlpha", SaveAlpha)
	end

	-- reset all attributes
	bar:SetWidth(width or def_Width)
	bar.origwidth = floor(bar:GetWidth())
	bar:SetHeight(height or def_Height)
	bar.origheight = floor(bar:GetHeight())
	bar.FB_Spark:SetHeight(bar:GetHeight())

	bar.FB_Background:SetTexture(texture or def_BackgroundTexture)
	bar.FB_Background:SetVertexColor(unpack(def_BackgroundColor))
	bar.FB_Background:SetAlpha(def_BackgroundAlpha)
	bar.origbg = bar.FB_Background:GetTexture()
	bar.origbgcolor = {
		r, g, b, a = bar.FB_Background:GetVertexColor()
	}
	bar.origbgalpha = bar.FB_Background:GetAlpha()

	bar.FB_Bar:SetStatusBarTexture(texture or def_Texture)
	bar.FB_Bar:SetStatusBarColor(unpack(def_Color))

	bar:Reset()
	-- add bar to group if defined
	if group then
		group:Add(bar)
	end

	return bar
end

--- Resets all bar attributes (font, icon, color, etc.) to its original settings.
function barPrototype:Reset()
	self:SetSpark(def_Spark)
	self.FB_Bar:SetAlpha(def_Alpha)
	self.FB_Spark:SetVertexColor(unpack(def_SparkColor))
	self.FB_Spark:SetAlpha(def_SparkAlpha)

	self:SetAlpha(def_Alpha)
	self.origalpha = self:GetAlpha()
	self:SetLabel(def_Label)
	self:SetDuration(def_Duration)
	self:SetIcon(def_Icon)
	self:SetIconRight(false)
	self:SetFill(def_Fill)
	self:SetIconMode(def_IconMode, def_IconTextPosition, def_IconTextOffsetH, def_IconTextOffsetY)
	self:SetLabelFont(def_LabelFont, def_LabelFontSize)
	self:SetDurationFont(def_DurationFont, def_DurationFontSize)

	self.created = GetTime()
	self.flash = nil
	self.ghost = nil
	self.fadeout = nil
	self.spark = def_Spark
	self.stage = "created"
	self.duration = def_Duration
	self.remaining = self.duration
	self.data = {}
end

--- Sets icon mode for the bar.
--@param size Size of the icons. 0/nil/false disables icon mode.
--@param textPosition Position of the timer text.
--Values: "BOTTOM", "TOP", "LEFT", "RIGHT", "CENTER".
--Default: "BOTTOM".
--@param textOffsetH Horizontal offset of the timer text.
--@param textOffsetY Vertical offset of the timer text.
function barPrototype:SetIconMode(size, textPosition, textOffsetH, textOffsetY)
	if size == true then size = def_IconSize end
	self.iconmode = size

	if size ~= false and type(size) == "number" and size>0 then
		self.FB_Background:Hide()
		self.FB_Bar:Hide()
		self.FB_Label:Hide()
		self.FB_Spark:Hide()
		self.FB_IconRight:Hide()
		self:SetWidth(size)
		self:SetHeight(size)
		self.FB_Icon:ClearAllPoints()
		self.FB_Icon:SetPoint("TOPLEFT", self, "TOPLEFT")
		self.FB_Icon:SetPoint("TOPRIGHT", self, "TOPRIGHT")
		self.FB_Icon:SetHeight(size)
		self.FB_Icon:Show()
		self.FB_Duration:ClearAllPoints()
		self.FB_Duration:SetPoint(ReversePoint(textPosition), self.FB_Icon, textPosition, textOffsetH, textOffsetY)

		if smatch(textPosition, "LEFT") then
			self.FB_Duration:SetJustifyH("RIGHT")
		elseif smatch(textPosition, "RIGHT") then
			self.FB_Duration:SetJustifyH("LEFT")
		else
			self.FB_Duration:SetJustifyH("CENTER")
		end
	else
		self.FB_Background:Show()
		self:SetWidth(self.origwidth)
		self:SetHeight(self.origheight)
		self.FB_Bar:Show()
		if self.spark then self.FB_Spark:Show() end
		self.FB_Label:Show()
		self:SetIcon(self.icon)
		self:SetIconRight(self.iconright)
		self.FB_Duration:ClearAllPoints()
		self.FB_Duration:SetPoint("RIGHT", self.FB_Bar, "RIGHT", -2, 0)
		self.FB_Duration:SetJustifyH("RIGHT")
	end
end

--- Sets the timer duration.
-- @param duration Duration in seconds.
-- @param maximum Maximum duration in seconds. This can be used to create in-progress bars.
-- @usage
-- -- Sets the bar to 5 seconds.
-- bar:SetDuration(5)
-- -- Sets the bar to a total of 8 seconds, with 3 seconds left on the timer.
-- bar:SetDuration(3, 8)
function barPrototype:SetDuration(duration, maximum)
	if maximum and duration > maximum then duration = maximum end
	self.duration = duration or 0
	self.duration_max = maximum or duration or 0
	self.remaining = self.duration
end

--- Returns the bar's remaining and maximum duration.
-- @return remaining Time remaining on the bar.
-- @return maximum Maximum duration.
function barPrototype:GetDuration()
	return self.remaining, self.duration
end

--- Sets the bar's text label.
--@param label Text of the label.
function barPrototype:SetLabel(label)
	self.labeltext = label
	if label then
		self.FB_Label:Show()
		self.FB_Label:SetText(label)
	else
		self.FB_Label:Hide()
	end
end

--- Returns the bar's text label.
--@return label Text of the label.
function barPrototype:GetLabel()
	return self.FB_Label:GetText()
end

--- Sets the font used for the label text.
--@param font Font to apply. Can be a FontObject or a path to the font file.
--@param size Change size of the font.
--@param flags Additional properties for the font specified by one or more (separated by commas) of the following tokens: MONOCHROME, OUTLINE, THICKOUTLINE.
function barPrototype:SetLabelFont(font, size, flags)
	local oldfont, oldsize = self.FB_Label:GetFont()
	-- if we have a FontObject, retrieve the actual font file
	if _G[font] and _G[font].GetFont then
		font, size = _G[font]:GetFont()
	end
	if not font then font = oldfont end
	if not size then size = oldsize end
	self.FB_Label:SetFont(font, size, flags)
end

--- Sets the font used for the duration display.
--@param font Font to apply. Can be a FontObject or a path to the font file.
--@param size Change size of the font.
--@param flags Additional properties for the font specified by one or more (separated by commas) of the following tokens: MONOCHROME, OUTLINE, THICKOUTLINE.
function barPrototype:SetDurationFont(font, size, flags)
	local oldfont, oldsize = self.FB_Duration:GetFont()
	-- if we have a FontObject, retrieve the actual font file
	if _G[font] and _G[font].GetFont then
		font, size = _G[font]:GetFont()
	end
	if not font then font = oldfont end
	if not size then size = oldsize end
	self.FB_Duration:SetFont(font, size, flags)
end

--- Sets the texture of the bar.
-- @param texture Path to the bar texture.
function barPrototype:SetTexture(texture)
	self.FB_Bar:SetStatusBarTexture(texture)
	self.FB_Bar:GetStatusBarTexture():SetHorizTile(false)
end

--- Sets a "spark" for the bar, which is a bright vertical bar at the end of the timerbar, making it easier to see its progress. It is enabled by default.
--@param enabled True or false.
--@param color Color of the spark.
function barPrototype:SetSpark(enabled, color)
	if enabled and self.stage ~= "ghost" and self.stage ~= "fadeout" then
		self.spark = true
		if color then self.FB_Spark:SetVertexColor(unpack(color)) end
		if not self.iconmode then self.FB_Spark:Show() end
	else
		self.spark = false
		self.FB_Spark:Hide()
	end
end

--- Sets the bar's left icon.
--@param icon Path to the icon.
function barPrototype:SetIcon(icon)
	-- set the texture
	self.FB_Icon:SetTexture(icon)
	self.icon = icon

	-- resize bar based on result
	if self.FB_Icon:GetTexture() then
		local size = self:GetHeight()
		self.FB_Icon:ClearAllPoints()
		self.FB_Icon:SetWidth(size)
		self.FB_Icon:SetPoint("TOPLEFT", self, "TOPLEFT")
		self.FB_Icon:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
		self.FB_Icon:Show()
		self.FB_Bar:SetPoint("TOPLEFT", self, size, 0)
		self.FB_Bar:SetPoint("BOTTOMLEFT", self, size, 0)
	else
		self.FB_Bar:SetPoint("TOPLEFT", self)
		self.FB_Bar:SetPoint("BOTTOMLEFT", self)
		self.FB_Icon:Hide()
	end
end

--- Sets the bar's right icon.
--@param icon Path to the icon.
function barPrototype:SetIconRight(icon)
	-- set the texture
	self.FB_IconRight:SetTexture(icon)
	self.iconright = icon

	-- resize bar based on result
	if self.FB_IconRight:GetTexture() then
		self.FB_IconRight:ClearAllPoints()
		local size = self:GetHeight()
		local width = self:GetWidth()
		self.FB_IconRight:SetWidth(size)
		self.FB_IconRight:SetPoint("TOPRIGHT", self, "TOPRIGHT")
		self.FB_IconRight:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
		self.FB_IconRight:Show()
		self.FB_Bar:SetPoint("TOPRIGHT", self, -size, 0)
		self.FB_Bar:SetPoint("BOTTOMRIGHT", self, -size, 0)
	else
		self.FB_Bar:SetPoint("TOPRIGHT", self)
		self.FB_Bar:SetPoint("BOTTOMRIGHT", self)
		self.FB_IconRight:Hide()
	end
end

--- Sets the color of the bar.
--@param color The new color.
function barPrototype:SetColor(color)
	if not color then return end
	self.FB_Bar:SetStatusBarColor(unpack(color))
end

--- Sets if bar is filled (true) or drained (false).
--@param fill True or false.
function barPrototype:SetFill(fill)
	self.fill = fill
end

--- Hides the statusbar texture, leaving only the background and labels visible.
--@param hide True or false.
function barPrototype:HideStatusBar(hide)
	if hide then
		self.FB_Bar:Hide()
		self.FB_Spark:Hide()
	else
		self.FB_Bar:Show()
		if self.spark then self.FB_Spark:Show() end
	end
end

--- Sets the bar to start flashing after a period of time.
--@param start Starts flashing when the time remaining is less than this value.
--@param frequency Frequency of the flash effect in seconds.
--Default: 1.
--@param cooldown Waits the specified number of seconds between flash phases.
--Default: 1.
function barPrototype:SetFlash(start, frequency, cooldown)
	self.flash = start or 0
	self.flashfrequency = frequency or 1
	self.flashcooldown = cooldown or 1
	self.flashperiod = self.flashfrequency + self.flashcooldown
end

--- Sets a "ghost" duration for the bar, that is, after the timer runs out, the bar stays on screen for the specified number of seconds.
--@param duration Ghost time in seconds.
--@param labeltext Changes the label text when the effect begins.
--@param timertext Changes the timer text.
--@param color Changes background color.
--@param texture Changes background texture.
function barPrototype:SetGhost(duration, labeltext, timertext, color, texture)
	self.ghost = duration
	self.ghostlabel = labeltext
	self.ghosttimer = timertext
	self.ghostcolor = color
	self.ghosttexture = texture
	self.ghostexpires = (self.expires or 0) + (self.ghost or 0)
end

--- Sets a fadeout duration for the bar. This comes after the ghost effect if applicable.
--@param duration Fadeout time in seconds.
--@param labeltext Changes the label text when the effect begins.
--@param timertext Changes the timer text.
--@param color Changes background color.
--@param texture Changes background texture.
function barPrototype:SetFadeout(duration, labeltext, timertext, color, texture)
	self.fadeout = duration
	self.fadeoutlabel = labeltext
	self.fadeouttimer = timertext
	self.fadeoutcolor = color
	self.fadeouttexture = texture
	self.fadeoutexpires = (self.ghostexpires or 0) + (self.fadeout or 0)
end

--- Sets user data in the timerbar object.
--@param key Key to use for the data storage.
--@param data Data to store.
function barPrototype:SetData(key, data)
	self.data[key] = data
end

--- Retrieves user data from the timerbar object.
--@param key Key to retrieve.
function barPrototype:GetData(key)
	return self.data and self.data[key]
end

--- Shows the bar and starts it.
--@param noEvent If true, does not fire the "FB_BarStart" event.
function barPrototype:Start(noEvent)
	local t = GetTime()

	if self.stage == "ghost" or self.stage == "fadeout" then
		self.FB_Background:SetTexture(self.origbg)
		self.FB_Background:SetVertexColor(unpack(self.origbgcolor))
		self.FB_Background:SetAlpha(self.origbgalpha)
		self:SetAlpha(self.origalpha)
	end

	self.started = t
	self.expires = t + self.duration
	self.ghostexpires = self.expires + (self.ghost or 0)
	self.fadeoutexpires = self.ghostexpires + (self.fadeout or 0)
	self.stage = "running"

	self.FB_Bar:SetMinMaxValues(0, self.duration_max)

	if not noEvent then
		self.callbacks:Fire("FancyBar_BarStart", self)
	end

	onUpdate(self) -- refresh look before showing to avoid flicker
	self:SetScript("OnUpdate", onUpdate)
	self:Show()

	if self.group then
		self.group:Rearrange()
	end
end

--- Stops the bar.
--@param noEvent If true, does not fire any events.
function barPrototype:Stop(noEvent)
	if self.stage == "stopped" then return end

	if not noEvent and self.stage == "ghost" then
		self.callbacks:Fire("FancyBar_BarGhostEnd", self)
	end
	if not noEvent and self.stage == "fadeout" then
		self.callbacks:Fire("FancyBar_BarFadeoutEnd", self)
	end

	self.stage = "stopped"
	self:SetScript("OnUpdate", nil)
	if not noEvent then
		self.callbacks:Fire("FancyBar_BarStop", self)
	end
	if self.data then wipe(self.data) end
	if self.group then self.group:Remove(self) end
	self:Hide()
	barPool[#barPool + 1] = self
end

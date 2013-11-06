local fb = LibStub("LibFancyBar-1.0")
if not fb then error("LibFancyBar not found.") end

FBTest = LibStub("AceAddon-3.0"):NewAddon("LibFancyBar-1.0 Tester", "AceConsole-3.0", "AceEvent-3.0")
local addon = FBTest
local testgroup, testgroup2

function addon:OnEnable()
	addon:RegisterChatCommand("fbtest", "ChatCommand")
	addon:Print("LibFancyBar-1.0 Test addon loaded. Use |CFF00FF00/fbtest|r to begin testing.")
end

local function BarGhost(callback, bar)
	addon:Print(bar.FB_Label:GetText(), "ghosting.")
end

local function BarFadeout(callback, bar)
	addon:Print(bar.FB_Label:GetText(), "fading out.")
end

local function BarStop(callback, bar)
	addon:Print(bar.FB_Label:GetText(), "stopped.")
end

local function GroupMoved(callback, group, ...)
	addon:Print("New position: ", ...)
end

local function GroupResized(callback, group, ...)
	addon:Print("New width: ", ...)
end

local function GroupSorting(callback, group, ...)
	addon:Print("New width: ", ...)
end

function addon:ChatCommand(input)
	addon:Print("Starting test.")
	if not testgroup then testgroup = fb:NewGroup(500, "Test Group") end
	testgroup:Clear()
	testgroup:SetPoint("CENTER", UIParent, "CENTER", -300, 200)
	testgroup:Lock(false)
	testgroup.RegisterCallback(testgroup, "FB_GroupMove", GroupMoved)
	testgroup.RegisterCallback(testgroup, "FB_GroupResize", GroupResized)

	if not testgroup2 then testgroup2 = fb:NewGroup(500, "Test Group 2") end
	testgroup2:Clear()
	testgroup2:SetPoint("CENTER", UIParent, "CENTER", 300, 200)
	testgroup2:Lock(false)
	testgroup2.RegisterCallback(testgroup2, "FB_GroupMove", GroupMoved)
	testgroup2.RegisterCallback(testgroup2, "FB_GroupResize", GroupResized)
end
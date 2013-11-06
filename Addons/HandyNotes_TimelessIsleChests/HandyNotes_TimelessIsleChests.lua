TimelessIsleChest = LibStub("AceAddon-3.0"):NewAddon("TimelessIsleChest", "AceBucket-3.0", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local HandyNotes = LibStub("AceAddon-3.0"):GetAddon("HandyNotes", true)
if not HandyNotes then return end

--TimelessIsleChest = HandyNotes:NewModule("TimelessIsleChest", "AceConsole-3.0", "AceEvent-3.0")
local db
local iconDefault = "Interface\\Icons\\TRADE_ARCHAEOLOGY_CHESTOFTINYGLASSANIMALS"

TimelessIsleChest.nodes = { }
local nodes = TimelessIsleChest.nodes

nodes["TimelessIsle"] = { }
nodes["CavernofLostSpirits"] = { }


nodes["TimelessIsle"][36703410] = { "33170", "覆苔宝箱", "一次性宝箱 000" }
nodes["TimelessIsle"][25502720] = { "33171", "覆苔宝箱", "一次性宝箱 001" }
nodes["TimelessIsle"][27403910] = { "33172", "覆苔宝箱", "一次性宝箱 002" }
nodes["TimelessIsle"][30703650] = { "33173", "覆苔宝箱", "一次性宝箱 003" }
nodes["TimelessIsle"][22403540] = { "33174", "覆苔宝箱", "一次性宝箱 004" }
nodes["TimelessIsle"][22104930] = { "33175", "覆苔宝箱", "一次性宝箱 005" }
nodes["TimelessIsle"][24805300] = { "33176", "覆苔宝箱", "一次性宝箱 006" }
nodes["TimelessIsle"][25704580] = { "33177", "覆苔宝箱", "一次性宝箱 007" }
nodes["TimelessIsle"][22306810] = { "33178", "覆苔宝箱", "一次性宝箱 008" }
nodes["TimelessIsle"][26806870] = { "33179", "覆苔宝箱", "一次性宝箱 009" }
nodes["TimelessIsle"][31007630] = { "33180", "覆苔宝箱", "一次性宝箱 010" }
nodes["TimelessIsle"][35307640] = { "33181", "覆苔宝箱", "一次性宝箱 011" }
nodes["TimelessIsle"][38707160] = { "33182", "覆苔宝箱", "一次性宝箱 012" }
nodes["TimelessIsle"][39807950] = { "33183", "覆苔宝箱", "一次性宝箱 013" }
nodes["TimelessIsle"][34808420] = { "33184", "覆苔宝箱", "一次性宝箱 014" }
nodes["TimelessIsle"][43608410] = { "33185", "覆苔宝箱", "一次性宝箱 015" }
nodes["TimelessIsle"][47005370] = { "33186", "覆苔宝箱", "一次性宝箱 016" }
nodes["TimelessIsle"][46704670] = { "33187", "覆苔宝箱", "一次性宝箱 017" }
nodes["TimelessIsle"][51204570] = { "33188", "覆苔宝箱", "一次性宝箱 018" }
nodes["TimelessIsle"][55504430] = { "33189", "覆苔宝箱", "一次性宝箱 019" }
nodes["TimelessIsle"][58005070] = { "33190", "覆苔宝箱", "一次性宝箱 020" }
nodes["TimelessIsle"][65704780] = { "33191", "覆苔宝箱", "一次性宝箱 021" }
nodes["TimelessIsle"][63805920] = { "33192", "覆苔宝箱", "一次性宝箱 022" }
nodes["TimelessIsle"][64907560] = { "33193", "覆苔宝箱", "一次性宝箱 023" }
nodes["TimelessIsle"][60206600] = { "33194", "覆苔宝箱", "一次性宝箱 024" }
nodes["TimelessIsle"][49706570] = { "33195", "覆苔宝箱", "一次性宝箱 025" }
nodes["TimelessIsle"][53107080] = { "33196", "覆苔宝箱", "一次性宝箱 026" }
nodes["TimelessIsle"][52706270] = { "33197", "覆苔宝箱", "一次性宝箱 027" }
nodes["TimelessIsle"][61708850] = { "33227", "覆苔宝箱", "一次性宝箱 028" }
nodes["TimelessIsle"][44206530] = { "33198", "覆苔宝箱", "一次性宝箱 - 中间树墩" }
nodes["TimelessIsle"][26006140] = { "33199", "覆苔宝箱", "一次性宝箱 - 西南树墩" }
nodes["TimelessIsle"][24603850] = { "33200", "覆苔宝箱", "一次性宝箱 - 西边树墩" }
nodes["TimelessIsle"][29703180] = { "33202", "覆苔宝箱", "一次性宝箱 - 迷雾海岸" }
nodes["TimelessIsle"][59903130] = { "33201", "覆苔宝箱", "一次性宝箱 - 斡耳朵湖下方" }
nodes["TimelessIsle"][28203520] = { "33204", "坚固宝箱", "一次性宝箱 - 坐信天翁" } -- Swapped questid's with carry bird 2
nodes["TimelessIsle"][26806490] = { "33205", "坚固宝箱", "一次性宝箱 - 坐信天翁" }
nodes["TimelessIsle"][64607040] = { "33206", "坚固宝箱", "一次性宝箱 - 巨口蛙" }
nodes["TimelessIsle"][59204950] = { "33207", "坚固宝箱", "一次性宝箱 - 锤子洞穴" }
nodes["TimelessIsle"][69503290] = { "33208", "阴燃宝箱", "一次性宝箱 - 斡耳朵宝箱 000" }
nodes["TimelessIsle"][54007820] = { "33209", "阴燃宝箱", "一次性宝箱 - 斡耳朵宝箱 001" }
nodes["TimelessIsle"][47602760] = { "33210", "炽燃宝箱", "一次性宝箱 - 炽燃宝箱" }

nodes["TimelessIsle"][46703230] = { "33203", "嵌颅宝箱", "一次性宝箱 - 孤魂岩洞\n注意在下方的洞穴中" }
nodes["CavernofLostSpirits"][62903480] = { "33203", "嵌颅宝箱", "一次性宝箱 - 孤魂岩洞" }


-- Extreme Treasure Hunter
nodes["TimelessIsle"][51607460] = { "32969", "闪闪发光的宝箱", "跳柱子\n起点", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily.tga" } --Old start 51507360
nodes["TimelessIsle"][49706940] = { "32969", "闪闪发光的宝箱", "跳柱子\n|cffffff00[超级宝藏猎人]|r\n周常", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][60204590] = { "32968", "绳索捆扎的宝箱", "走绳子\n起点", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily.tga" }
nodes["TimelessIsle"][53904720] = { "32968", "绳索捆扎的宝箱", "走绳子\n|cffffff00[超级宝藏猎人]|r\n周常，需要先开掉跳柱子的宝箱才可接", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][58506010] = { "32971", "雾气缭绕的宝箱", "发光的仙鹤雕像\n|cffffff00[超级宝藏猎人]|r\n周常，需要先开掉跳柱子和走绳子的宝箱\n点击仙鹤雕像即可\n", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

-- Where There's Pirates, There's Booty
nodes["TimelessIsle"][40409300] = { "32957", "沉没的宝箱", "|cffffff00[哪里有海盗，哪里就有宝藏]|r\n周常，钥匙由周围精英怪掉落", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][16905710] = { "32956", "无赖的海难货物", "洞穴入口", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily.tga" }
nodes["TimelessIsle"][22705890] = { "32956", "无赖的海难货物", "|cffffff00[哪里有海盗，哪里就有宝藏]|r\n周常，宝箱在洞里", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

nodes["TimelessIsle"][70608090] = { "32970", "闪闪发光的宝物袋", "|cffffff00[哪里有海盗，哪里就有宝藏]|r\n周常，到舵所在的地方，走右边的绳索，缓慢移动到不能走动为止，后退三步，跳到下方的横桅杆上走到另一端。", "Interface\\Addons\\HandyNotes_TimelessIsleChests\\Artwork\\chest_normal_daily_end.tga" }

--[[ function TimelessIsleChest:OnEnable()
end

function TimelessIsleChest:OnDisable()
end ]]--

--local handler = {}


function TimelessIsleChest:OnEnter(mapFile, coord) -- Copied from handynotes
    if (not nodes[mapFile][coord]) then return end
	
	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	tooltip:SetText(nodes[mapFile][coord][2])
	if (nodes[mapFile][coord][3] ~= nil) then
	 tooltip:AddLine(nodes[mapFile][coord][3], nil, nil, nil, true)
	end
	tooltip:Show()
end

function TimelessIsleChest:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

local options = {
 type = "group",
 name = "TimelessIsleChest",
 desc = "Locations of treasure chests on Timeless Isle.",
 get = function(info) return db[info.arg] end,
 set = function(info, v) db[info.arg] = v; TimelessIsleChest:Refresh() end,
 args = {
  desc = {
   name = "These settings control the look and feel of the icon.",
   type = "description",
   order = 0,
  },
  icon_scale = {
   type = "range",
   name = "Icon Scale",
   desc = "The scale of the icons",
   min = 0.25, max = 2, step = 0.01,
   arg = "icon_scale",
   order = 10,
  },
  icon_alpha = {
   type = "range",
   name = "Icon Alpha",
   desc = "The alpha transparency of the icons",
   min = 0, max = 1, step = 0.01,
   arg = "icon_alpha",
   order = 20,
  },
  alwaysshow = {
   type = "toggle",
   name = "Show All Chests",
   desc = "Always show every chest regardless of looted status",
   arg = "alwaysshow",
   order = 2,
  },
 },
}

function TimelessIsleChest:OnInitialize()
 local defaults = {
  profile = {
   icon_scale = 1.0,
   icon_alpha = 1.0,
   alwaysshow = false,
  },
 }

 db = LibStub("AceDB-3.0"):New("TimelessIsleChestsDB", defaults, true).profile
 self:RegisterEvent("PLAYER_ENTERING_WORLD", "WorldEnter")
end

function TimelessIsleChest:WorldEnter()
 self:UnregisterEvent("PLAYER_ENTERING_WORLD")

 --self:RegisterEvent("WORLD_MAP_UPDATE", "Refresh")
 --self:RegisterEvent("LOOT_CLOSED", "Refresh")

 --self:Refresh()
 self:ScheduleTimer("RegisterWithHandyNotes", 10)
end

function TimelessIsleChest:RegisterWithHandyNotes()
do
	local function iter(t, prestate)
		if not t then return nil end
		local state, value = next(t, prestate)
		while state do
			    -- questid, chest type, quest name, icon
			    if (value[1] and (not IsQuestFlaggedCompleted(value[1]) or db.alwaysshow)) then
				 --print(state)
				 local icon = value[4] or iconDefault
				 return state, nil, icon, db.icon_scale, db.icon_alpha
				end
			state, value = next(t, state)
		end
	end
	function TimelessIsleChest:GetNodes(mapFile, isMinimapUpdate, dungeonLevel)
	    if (mapFile == "CavernofLostSpirits" and isMinimapUpdate) then return iter, nodes["Hack"], nil end
		return iter, nodes[mapFile], nil
	end
end
 HandyNotes:RegisterPluginDB("TimelessIsleChest", self, options)
 self:RegisterBucketEvent({ "LOOT_CLOSED" }, 2, "Refresh")
 self:Refresh()
end
 

function TimelessIsleChest:Refresh()
 self:SendMessage("HandyNotes_NotifyUpdate", "TimelessIsleChest")
end
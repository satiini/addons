local addon = PvPTimer

local spells = {
	-- PvP Trinket
	[42292] = {
		class = 'ITEM',
		cooldown = 120,
		type = 'defensive',
	},
	-- Healthstone
	[6262] = {
		class = 'ITEM',
		cooldown = 60,
		type = 'defensive',
	},
	-- Battle Standard
	[23034] = 23035,
	[23035] = {
		class = 'ITEM',
		duration = 120,
		cooldown = 600,
		type = 'defensive',
	},
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

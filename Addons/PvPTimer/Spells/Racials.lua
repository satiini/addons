local addon = PvPTimer

local spells = {
	-- Arcane Torrent (Blood Elf)
	[69179] = 28730,	--Rage
	[25046] = 28730,	--Energy
	[80483] = 28730,	--Focus
	[50613] = 28730,	--Runic
	[129597] = 28730,	--Chi
	[28730] = {			--Mana
		class = 'RACIAL',
		cooldown = 120,
		type = 'interrupt'
	},
	-- Berserking (Troll)
	[26297] = {
		class = 'RACIAL',
		duration = 10,
		cooldown = 180,
		type = 'offensive',
	},
	-- Blood Fury (Orc)
	[33697] = 20572,	--Attack Power and Spell Power
	[33702] = 20572,	--Spell Power
	[20572] = {			--Attack Power
		class = 'RACIAL',
		duration = 15,
		cooldown = 120,
		type = 'offensive',
	},
	-- Darkflight (Worgen)
	[68992] = {
		class = 'RACIAL',
		duration = 10,
		cooldown = 120,
		type = 'misc',
	},
	-- Escape Artist (Gnome)
	[20589] = {
		class = 'RACIAL',
		cooldown = 90,
		type = 'defensive',
	},
	-- Every Man For Himself (Human)
	[59752] = {
		class = 'RACIAL',
		cooldown = 120,
		type = 'defensive',
	},
	-- Gift of the Naaru (Dranei)
	[59543] = 59545,	--Hunter
	[59548] = 59545,	--Mage
	[121093] = 59545,	--Monk
	[59542] = 59545,	--Paladin
	[59544] = 59545,	--Priest
	[59547] = 59545,	--Shaman
	[28880] = 59545,	--Warrior
	[59545] = { 		--DK
		class = 'RACIAL',
		cooldown = 180,
		type = 'defensive',
	},
	-- Quaking Palm (Pandaren)
	[107079] = {
		class = 'RACIAL',
		duration = 4,
		cooldown = 120,
		type = 'cc',
	},
	-- Rocket Jump (Goblin)
	[69070] = {
		class = 'RACIAL',
		cooldown = 120,
		type = 'misc',
	},
	-- Rocket Barrage (Goblin)
	[69041] = {
		class = 'RACIAL',
		cooldown = 120,
		type = 'offensive',
	},
	-- Shadowmeld (Night Elf)
	[58984] = {
		class = 'RACIAL',
		cooldown = 120,
		type = 'defensive',
	},
	-- Stoneform (Dwarf)
	[20594] = {
		class = 'RACIAL',
		duration = 8,
		cooldown = 120,
		type = 'defensive',
	},
	-- War Stomp (Tauren)
	[20549] = {
		class = 'RACIAL',
		cooldown = 120,
		type = 'cc',
	},
	-- Will of the Forsaken (Undead)
	[7744] = {
		class = 'RACIAL',
		cooldown = 120,
		type = 'defensive',
	},
	
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

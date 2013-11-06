local addon = PvPTimer

local spells = {
	-- Berserk
	[106951] = 50334,
	[50334] = {
		class = 'DRUID',
		spec = 2,
		duration = 15,
		cooldown = 180,
		type = 'offensive',
	},
	-- Tiger's Fury
	[5217] = {
		class = 'DRUID',
		duration = 6,
		cooldown = 30,
		type = 'offensive',
	},
	-- Force of Nature
	[102693] = 33831,
	[102706] = 33831,
	[33831] = {
		class = 'DRUID',
		duration = 15,
		cooldown = 60,
		type = 'offensive',
	},
	-- Starfall
	[48505] = {
		class = 'DRUID',
		spec = 1,
		duration = 10,
		cooldown = 90,
		type = 'offensive',
	},
	-- Survival Instincts
	[61336] = {
		class = 'DRUID',
		spec = 2,
		duration = 12,
		cooldown = 180,
		type = 'defensive',
	},
	-- Barkskin
	[22812] = {
		class = 'DRUID',
		duration = 12,
		cooldown = 60,
		type = 'defensive',
	},
	-- Incarnation
	[102543] = 33891,
	[102558] = 33891,
	[102560] = 33891,
	[33891] = {
		class = 'DRUID',
		duration = 30,
		cooldown = 180,
		type = 'defensive',
	},
	-- Mighty Bash
	[5211] = {
		class = 'DRUID',
		duration = 5,
		cooldown = 50,
		type = 'cc',
	},
	-- Skull Bash
	[106839] = {
		class = 'DRUID',
		spec = 2,
		cooldown = 15,
		type = 'interrupt',
	},
	-- Wild Charge
	[49376] = 16979,
	[102401] = 16979,
	[102383] = 16979,
	[102417] = 16979,
	[16979] = {
		class = 'DRUID',
		cooldown = 15,
		type = 'root',
	},
	-- Solar Beam
	[78675] = {
		class = 'DRUID',
		spec = 1,
		duration = 10,
		duration_g = 5,
		cooldown = 60,
		type = 'interrupt',
	},
	-- Nature's Grasp
	[16689] = {
		class = 'DRUID',
		duration = 45,
		cooldown = 60,
		type = 'defensive',
	},
	-- Innervate
	[29166] = {
		class = 'DRUID',
		duration = 10,
		cooldown = 180,
		type = 'misc',
	},
	-- Typhoon
	[132469] = {
		class = 'DRUID',
		duration = 6,
		cooldown = 20,
		type = 'root',
	},
	-- Dash
	[1850] = {
		class = 'DRUID',
		duration = 15,
		cooldown = 180,
		cooldown_g = -60,
		type = 'misc',
	},
	-- Stampeding Roar
	[77761] = 77764,
	[77764] = {
		class = 'DRUID',
		duration = 8,
		cooldown = 120,
		type = 'misc',
	},
	-- Tranquility
	[740] = {
		class = 'DRUID',
		duration = 8,
		cooldown = 480,
		cooldown_s3 = -300,
		type = 'defensive',
	},
	-- Nature's Swiftness
	[132158] = {
		class = 'DRUID',
		cooldown = 60,
		type = 'misc',
	},
	-- Swiftmend
	[18562] = {
		class = 'DRUID',
		spec = 3,
		cooldown = 15,
		type = 'defensive',
	},
	-- Rebirth
	[20484] = {
		class = 'DRUID',
		cooldown = 600,
		type = 'misc',
	},
	-- Ironbark
	[102342] = {
		class = 'DRUID',
		duration = 12,
		cooldown = 120,
		type = 'defensive',
	},
	-- Might of Ursoc
	[106922] = {
		class = 'DRUID',
		duration = 20,
		cooldown = 180,
		type = 'defensive',
	},
	-- Celestial Alignment
	[112071] = {
		class = 'DRUID',
		duration = 15,
		cooldown = 180,
		type = 'offensive',
	},
	-- Heart of the Wild
	-- Nature's Vigil
	-- Mass Entanglement
	[102359] = {
		class = 'DRUID',
		duration = 10,
		cooldown = 120,
		type = 'root',
	},
	-- Disorienting Roar
	[99] = {
		class = 'DRUID',
		duration = 3,
		cooldown = 30,
		type = 'cc',
	},
	-- Ursol's Vortex
	[102793] = {
		class = 'DRUID',
		duration = 10,
		cooldown = 60,
		type = 'cc',
	},
	-- Bear Hug
	[102795] = {
		class = 'DRUID',
		spec = 4,
		duration = 3,
		cooldown = 60,
		type = 'cc',
	},
}

local spec = {
	-- Starsurge
	[78674] = 1,
	-- Savage Roar
	[52610] = 2,
	-- Shred
	[5221] = 2,
	-- Berserk
	[50334] = 2,
	[106951] = 2,
	-- Sunfire
	[93402] = 1,
	-- Moonkin Form
	[24858] = 1,
	-- Wild Growth
	[48438] = 3,
	-- Swiftmend
	[18562] = 3,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

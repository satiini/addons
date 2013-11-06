local addon = PvPTimer

local spells = {
	-- Time Warp
	[80353] = {
		class = 'MAGE',
		duration = 40,
		cooldown = 300,
		type = 'offensive',
	},
	-- Icy Veins
	[12472] = {
		class = 'MAGE',
		spec = 3,
		duration = 20,
		cooldown = 180,
		type = 'offensive',
	},
	-- Mirror Image
	[55342] = {
		class = 'MAGE',
		duration = 30,
		cooldown = 180,
		type = 'offensive',
	},
	-- Arcane Power
	[12042] = {
		class = 'MAGE',
		spec = 1,
		duration = 15,
		cooldown = 90,
		type = 'offensive',
	},
	-- Combustion
	[11129] = {
		class = 'MAGE',
		spec = 2,
		cooldown = 45,
		cooldown_g = 45,
		type = 'offensive',
	},
	-- Presence of Mind
	[12043] = {
		class = 'MAGE',
		cooldown = 90,
		type = 'offensive',
	},
	-- Invisibility
	[66] = {
		class = 'MAGE',
		duration = 23, -- 20 duration + 3 sec fade time
		cooldown = 300,
		type = 'defensive',
	},
	-- Evocation
	[12051] = {
		class = 'MAGE',
		duration = 6,
		cooldown = 120,
		type = 'defensive',
	},
	-- Ice Block
	[45438] = {
		class = 'MAGE',
		duration = 10,
		cooldown = 300,
		resets = {
			122,
		},
		type = 'defensive',
	},
	-- Ice Barrier
	[11426] = {
		class = 'MAGE',
		duration = 60,
		cooldown = 25,
		type = 'defensive',
	},
	-- Counterspell
	[2139] = {
		class = 'MAGE',
		cooldown = 24,
		type = 'interrupt',
	},
	-- Cold Snap
	[11958] = {
		class = 'MAGE',
		cooldown = 180,
		resets = {
			45438,
			122,
		},
		type = 'misc',
	},
	-- Deep Freeze
	[44572] = {
		class = 'MAGE',
		duration = 5,
		cooldown = 30,
		type = 'cc',
	},
	-- Dragon's Breath
	[31661] = {
		class = 'MAGE',
		spec = 2,
		cooldown = 20,
		type = 'cc'
	},
	-- Summon Water Elemental
	[31687] = {
		class = 'MAGE',
		spec = 3,
		cooldown = 60,
		type = 'misc',
	},
	-- Ring of Frost
	[113724] = {
		class = 'MAGE',
		duration = 10,
		cooldown = 30,
		type = 'cc',
	},
	-- Blink
	[1953] = {
		class = 'MAGE',
		cooldown = 15,
		type = 'misc',
	},
	-- Frost Nova
	[122] = {
		class = 'MAGE',
		cooldown = 25,
		cooldown_g = -5,
		type = 'root'
	},
	-- Freeze (Water Elemental)
	[33395] = {
		class = 'MAGE',
		cooldown = 25,
		type = 'root',
		pet = true,
	},
	-- Alter Time
	[108978] = {
		class = 'MAGE',
		duration = 6,
		cooldown = 180,
		type = 'defensive',
	},
	-- Incanter's Ward
	[1463] = {
		class = 'MAGE',
		cooldown = 25,
		type = 'offensive',
	},
	-- Ice Floes
	[108839] = {
		class = 'MAGE',
		duration = 10,
		cooldown = 60,
		type = 'offensive',
	},
	-- Ice Ward
	[111264] = {
		class = 'MAGE',
		cooldown = 20,
		type = 'defensive',
	},
	-- Temporal Shield
	[115610] = {
		class = 'MAGE',
		cooldown = 25,
		type = 'defensive',
	},
	-- Greater Invisibility
	[110960] = {
		class = 'MAGE',
		duration = 20,
		cooldown = 150,
		type = 'defensive',
	},
	-- Blazing Speed
	[108843] = {
		class = 'MAGE',
		cooldown = 25,
		type = 'defensive',
	},
	-- Frostjaw
	[102051] = {
		class = 'MAGE',
		duration = 4,
		cooldown = 20,
		type = 'cc',
	},
}

local spec = {
	-- Arcane Barrage
	[44425] = 1,
	-- Pyroblast
	[11366] = 2,
	-- Slow
	[31589] = 1,
	-- Arcane missiles
	[5143] = 1,
	-- Fireball
	[133] = 2,
	-- Pyroblast
	[11366] = 2,
	-- Frostbolt
	[116] = 3,
	-- Dragon's Breath
	[31661] = 2,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

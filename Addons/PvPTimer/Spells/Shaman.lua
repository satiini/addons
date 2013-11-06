local addon = PvPTimer

local spells = {
	-- Heroism
	[32182] = 2825,
	-- Bloodlust
	[2825] = {
		class = 'SHAMAN',
		duration = 40,
		cooldown = 300,
		type = 'offensive',
	},
	-- Elemental Mastery
	[16166] = {
		class = 'SHAMAN',
		duration = 20,
		cooldown = 120,
		type = 'offensive',
	},
	-- Feral Spirit
	[51533] = {
		class = 'SHAMAN',
		spec = 2,
		duration = 30,
		cooldown = 120,
		type = 'offensive',
	},
	-- Earth Elemental Totem
	[2062] = {
		class = 'SHAMAN',
		duration = 60,
		cooldown = 300,
		type = 'offensive',
	},
	-- Fire Elemental Totem
	[2894] = {
		class = 'SHAMAN',
		duration = 60,
		cooldown = 300,
		cooldown_g = -120, -- 40%
		type = 'offensive',
	},
	-- Shamanistic Rage
	[30823] = {
		class = 'SHAMAN',
		spec = 2,
		duration = 15,
		cooldown = 60,
		type = 'defensive',
	},
	-- Spirit Link Totem
	[98008] = {
		class = 'SHAMAN',
		duration = 6,
		cooldown = 180,
		type = 'defensive',
	},

	-- Wind Shear
	[57994] = {
		class = 'SHAMAN',
		cooldown = 12,
		type = 'interrupt',
	},
	-- Spiritwalker's Grace
	[79206] = {
		class = 'SHAMAN',
		duration = 15,
		cooldown = 120,
		type = 'misc',
	},
	-- Ancestral Swiftness
	[16188] = {
		class = 'SHAMAN',
		cooldown = 60,
		type = 'misc',
	},
	-- Hex
	[51514] = {
		class = 'SHAMAN',
		duration = 8,
		cooldown = 45,
		cooldown_g = -10,
		type = 'cc',
	},
	-- Thunderstorm
	[51490] = {
		class = 'SHAMAN',
		spec = 1,
		cooldown = 45,
		cooldown_g = -10,
		type = 'offensive',
	},
	-- Mana Tide Totem
	[16190] = {
		class = 'SHAMAN',
		spec = 3,
		duration = 16,
		cooldown = 180,
		type = 'misc',
	},
	-- Tremor Totem
	[8143] = {
		class = 'SHAMAN',
		duration = 6,
		cooldown = 60,
		type = 'defensive',
	},
	-- Grounding Totem
	[8177] = {
		class = 'SHAMAN',
		type = 'defensive',
		cooldown = 25,
		cooldown_g = 35,
	},
	-- Stormlash Totem
	[120668] = {
		class = 'SHAMAN',
		duration = 10,
		cooldown = 300,
		type = 'offensive',
	},
	-- Spirit Walk
	[58875] = {
		class = 'SHAMAN',
		spec = 2,
		duration = 15,
		cooldown = 120,
		type = 'misc',
	},
	-- Ancestral Guidance
	[108281] = {
		class = 'SHAMAN',
		duration = 10,
		cooldown = 120,
		type = 'defensive',
	},
	-- Astral Shift
	[108271] = {
		class = 'SHAMAN',
		duration = 6,
		cooldown = 120,
		type = 'defensive',
	},
	-- Windwalk Totem
	[108273] = {
		class = 'SHAMAN',
		duration = 6,
		cooldown = 60,
		type = 'misc',
	},
	-- Capacitor Totem
	[108269] = {
		class = 'SHAMAN',
		duration = 5,
		cooldown = 45,
		type = 'cc',
	},
	-- Earthgrab Totem
	[51485] = {
		class = 'SHAMAN',
		duration = 5,
		cooldown = 30,
		type = 'root',
	},
	-- Healing Tide Totem
	[108280] = {
		class = 'SHAMAN',
		duration = 11,
		cooldown = 180,
		type = 'defensive',
	},
	-- Stone Bulwark Totem
	[108270] = {
		class = 'SHAMAN',
		duration = 30,
		cooldown = 60,
		type = 'defensive',
	},
	-- Call of The Elements
	[108285] = {
		class = 'SHAMAN',
		cooldown = 60,
		resets = {
			108269,
			8177,
			51485,
			8143,
			--5394,
			108270,
			108273,
		},
		type = 'defensive',
	},
}

local spec = {
	-- Lava Lash
	[60103] = 2,
	-- Earth Shield
	[974] = 3,
	-- Fulmination
	[88767] = 1,
	-- Earthquake
	[61882] = 1,
	-- Stormstrike
	[17364] = 2,
	-- Riptide
	[61295] = 3,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

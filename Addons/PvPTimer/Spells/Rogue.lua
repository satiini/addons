local addon = PvPTimer

local spells = {
	-- Tricks of the Trade
	[57934] = {
		class = 'ROGUE',
		duration = 6,
		cooldown = 30,
		type = 'offensive',
	},
	-- Adrenaline Rush
	[13750] = {
		class = 'ROGUE',
		spec = 2,
		duration = 15,
		cooldown = 180,
		type = 'offensive',
	},
	-- Killing Spree
	[51690] = {
		class = 'ROGUE',
		spec = 2,
		duration = 3,
		cooldown = 120,
		type = 'offensive',
	},
	-- Shadow Dance
	[51713] = {
		class = 'ROGUE',
		spec = 3,
		duration = 8,
		cooldown = 60,
		type = 'offensive',
	},
	-- Vendetta
	[79140] = {
		class = 'ROGUE',
		spec = 1,
		duration = 20,
		duration_g = 10, -- 20%
		cooldown = 120,
		type = 'offensive',
	},
	-- Evasion
	[5277] = {
		class = 'ROGUE',
		duration = 15,
		duration_g = 5,
		cooldown = 180,
		type = 'defensive',
	},
	-- Combat Readiness
	[74001] = {
		class = 'ROGUE',
		duration = 20,
		cooldown = 120,
		type = 'defensive',
	},
	-- Vanish
	[1856] = {
		class = 'ROGUE',
		duration = 3,
		duration_g = 2,
		cooldown = 180,
		type = 'defensive',
	},
	-- Cloak of Shadows
	[31224] = {
		class = 'ROGUE',
		duration = 5,
		cooldown = 120,
		type = 'defensive',
	},
	-- Kick
	[1766] = {
		class = 'ROGUE',
		cooldown = 15,
		type = 'interrupt',
	},
	-- Gouge
	[1776] = {
		class = 'ROGUE',
		duration = 4,
		cooldown = 10,
		type = 'cc',
	},
	-- Shadowstep
	[36554] = {
		class = 'ROGUE',
		duration = 2,
		cooldown = 24,
	},
	-- Preparation
	[14185] = {
		class = 'ROGUE',
		cooldown = 300,
		resets = {
			2983, -- Sprint
			1856, -- Vanish
			31224, -- Cloak of Shadows
			5277, -- Evasion
			51722, -- Dismantle
		},
		type = 'misc',
	},
	-- Sprint
	[2983] = {
		class = 'ROGUE',
		duration = 8,
		cooldown = 60,
		type = 'misc',
	},
	-- Blind
	[2094] = {
		class = 'ROGUE',
		duration = 8,
		cooldown = 180,
		type = 'cc',
	},
	-- Dismantle
	[51722] = {
		class = 'ROGUE',
		cooldown = 60,
		type = 'misc',
	},
	-- Kidney Shot
	[408] = {
		class = 'ROGUE',
		cooldown = 20,
		type = 'cc',
	},
	-- Redirect
	[73981] = {
		class = 'ROGUE',
		cooldown = 60,
		type = 'offensive',
	},
	-- Smoke Bomb
	[76577] = {
		class = 'ROGUE',
		duration = 5,
		duration_g = 2,
		cooldown = 180,
		type = 'offensive',
	},
	-- Premeditation
	[14183] = {
		class = 'ROGUE',
		cooldown = 20,
		type = 'offensive',
	},
	-- Shroud of Concealment
	[114018] = {
		class = 'ROGUE',
		duration = 15,
		cooldown = 300,
		type = 'misc',
	},
	-- Shadow Blades
	[121471] = {
		class = 'ROGUE',
		duration = 12,
		cooldown = 180,
		type = 'offensive',
	},
}

local spec = {
	-- Revealing Strike
	[84617] = 2,
	-- Hemorrhage
	[16511] = 3,
	-- Mutilate
	[1329] = 1,
	-- Blade Flurry
	[13877] = 2,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

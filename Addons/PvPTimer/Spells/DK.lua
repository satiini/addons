local addon = PvPTimer

local spells = {
	-- Raise Dead
	[46584] = {
		class = 'DEATHKNIGHT',
		cooldown = 120,
		duration = 60,
		duration_s3 = -60,
		type = 'misc',
	},
	-- Outbreak
	[77575] = {
		class = 'DEATHKNIGHT',
		cooldown = 60,
		type = 'offensive',
	},
	-- Empower Rune Weapon
	[47568] = {
		class = 'DEATHKNIGHT',
		cooldown = 300,
		type = 'offensive',
	},
	-- Dancing Rune Weapon
	[49028] = {
		class = 'DEATHKNIGHT',
		spec = 1,
		duration = 12,
		cooldown = 90,
		type = 'offensive',
	},
	-- Dark Transformation
	[63560] = {
		class = 'DEATHKNIGHT',
		spec = 3,
		cooldown = 30,
		type = 'offensive',
	},
	-- Pillar of Frost
	[51271] = {
		class = 'DEATHKNIGHT',
		spec = 2,
		duration = 20,
		cooldown = 60,
		type = 'offensive',
	},
	-- Summon Gargoyle
	[49206] = {
		class = 'DEATHKNIGHT',
		spec = 3,
		duration = 30,
		cooldown = 180,
		type = 'offensive',
	},
	-- Unholy Frenzy
	[49016] = {
		class = 'DEATHKNIGHT',
		spec = 3,
		duration = 30,
		cooldown = 180,
		type = 'offensive',
	},
	-- Death's Advance
	[96268] = {
		class = 'DEATHKNIGHT',
		cooldown = 30,
		type = 'offensive',
	},
	-- Unholy Blight
	[115989] = {
		class = 'DEATHKNIGHT',
		duration = 10,
		cooldown = 90,
		type = 'offensive',
	},
	-- Icebound Fortitude
	[48792] = {
		class = 'DEATHKNIGHT',
		duration = 12,
		cooldown = 180,
		type = 'defensive',
	},
	-- Anti-Magic Shell
	[48707] = {
		class = 'DEATHKNIGHT',
		duration = 5,
		cooldown = 45,
		type = 'defensive',
	},
	-- Anti-Magic Zone
	[51052] = {
		class = 'DEATHKNIGHT',
		duration = 10,
		cooldown = 120,
		type = 'defensive',
	},
	-- Death Pact
	[48743] = {
		class = 'DEATHKNIGHT',
		cooldown = 120,
		type = 'defensive',
	},
	-- Bone Shield
	[49222] = {
		class = 'DEATHKNIGHT',
		spec = 1,
		cooldown = 60,
		type = 'defensive',
	},
	-- Lichborne
	[49039] = {
		class = 'DEATHKNIGHT',
		duration = 10,
		cooldown = 120,
		type = 'defensive',
	},
	-- Vampiric Blood
	[55233] = {
		class = 'DEATHKNIGHT',
		spec = 1,
		duration = 10,
		cooldown = 60,
		type = 'defensive',
	},
	-- Rune Tap
	[48982] = {
		class = 'DEATHKNIGHT',
		spec = 1,
		cooldown = 30,
		type = 'defensive',
	},
	-- Strangulate
	[47476] = {
		class = 'DEATHKNIGHT',
		duration = 5,
		cooldown = 120,
		type = 'interrupt',
	},
	-- Mind Freeze
	[47528] = {
		class = 'DEATHKNIGHT',
		cooldown = 15,
		type = 'interrupt',
	},
	-- Death Grip
	[49576] = {
		class = 'DEATHKNIGHT',
		cooldown = 25,
		type = 'interrupt',
	},
	-- Asphyxiate
	[108194] = {
		class = 'DEATHKNIGHT',
		duration = 10,
		cooldown = 60,
		type = 'cc',
	},
	-- Dark Simulacrum
	[77606] = {
		class = 'DEATHKNIGHT',
		duration = 8,
		cooldown = 60,
		type = 'offensive',
	},
	-- Gnaw (Ghoul)
	[91800] = 47481,
	[47481] = {
		class = 'DEATHKNIGHT',
		duration = 3,
		cooldown = 60,
		type = 'cc',
		pet = true,
	},
	-- Shambling Rush (Transformed Ghoul)
	[91802] = {
		class = 'DEATHKNIGHT',
		cooldown = 30,
		type = 'offensive',
		pet = true,
	},
	-- Monstrous Blow (Transformed Ghoul)
	[91797] = {
		class = 'DEATHKNIGHT',
		duration = 4,
		cooldown = 60,
		type = 'cc',
		pet = true,
	},
	-- Raise Ally
	[61999] = {
		class = 'DEATHKNIGHT',
		cooldown = 600,
		type = 'misc',
	}
}

local spec = {
	-- Heart Strike
	[55050] = 1,
	-- Frost Strike
	[49143] = 2,
	-- Scourge Strike
	[55090] = 3,
	-- Howling Blast
	[49184] = 2,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

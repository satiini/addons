local addon = PvPTimer

local spells = {
	-- Summon Infernal
	[1122] = {
		class = 'WARLOCK',
		duration = 60,
		cooldown = 600,
		type = 'offensive',
	},
	-- Summon Doomguard
	[18540] = {
		class = 'WARLOCK',
		duration = 60,
		cooldown = 600,
		type = 'offensive',
	},
	-- Dark Soul
	[113860] = 113858,	-- Misery
	[113861] = 113858,	-- Knowledge
	[113858] = {		-- Instability
		class = 'WARLOCK',
		duration = 20,
		cooldown = 120,
		type = 'offensive',
	},
	-- Twilight Ward
	[6229] = {
		class = 'WARLOCK',
		cooldown = 30,
		type = 'defensive',
	},
	-- Shadowfury
	[30283] = {
		class = 'WARLOCK',
		duration = 3,
		cooldown = 30,
		type = 'cc',
	},
	-- Mortal Coil
	[6789] = {
		class = 'WARLOCK',
		duration = 3,
		cooldown = 45,
		type = 'cc',
	},
	-- Demonic Rebirth
	[88448] = 108559, -- To be safe
	[108559] = {
		class = 'WARLOCK',
		spec = 2,
		duration = 20,
		cooldown = 120,
	},
	-- Mortal Coil
	[6789] = {
		class = 'WARLOCK',
		duration = 3,
		cooldown = 45,
		type = 'cc',
	},
	-- Soul Swap
	[86213] = 86121,
	[86121] = {
		class = 'WARLOCK',
		spec = 1,
		cooldown = 0,
		cooldown_g = 30,
		type = 'offensive',
	},
	-- Soulstone Resurrection
	[20707] = {
		class = 'WARLOCK',
		duration = 900,
		cooldown = 600,
		type = 'misc',
	},
	-- Soulstone Resurrection
	[20707] = {
		class = 'WARLOCK',
		duration = 900,
		cooldown = 600,
		type = 'misc',
	},
	-- Unending Resolve
	[104773] = {
		class = 'WARLOCK',
		duration = 8,
		cooldown = 180,
		type = 'defensive',
	},
	-- Dark Bargain
	[110913] = {
		class = 'WARLOCK',
		duration = 8,
		cooldown = 180,
		type = 'defensive',
	},
	-- Dark Regeneration
	[108359] = {
		class = 'WARLOCK',
		duration = 12,
		cooldown = 120,
		type = 'defensive',
	},
	-- Sacrficial Pact
	[108416] = {
		class = 'WARLOCK',
		cooldown = 60,
		type = 'defensive',
	},
	-- Unbound Will
	[108482] = {
		class = 'WARLOCK',
		cooldown = 60,
		type = 'defensive',
	},
	-- Grimoire of Service
	[108501] = {
		class = 'WARLOCK',
		duration = 20,
		cooldown = 120,
		type = 'offensive',
	},
	-- Demonic Circle: Teleport
	[48020] = {
		class = 'WARLOCK',
		cooldown = 30,
		cooldown_g = -4,
		type = 'misc',
	},
	-- Howl of Terror
	[5484] = {
		class = 'WARLOCK',
		duration = 8,
		cooldown = 40,
		type = 'cc',
	},

	-- PET SKILLS

	-- Devour Magic (Felhunter)
	[19505] = {
		class = 'WARLOCK',
		cooldown = 15,
		type = 'misc',
		pet = true,
	},
	-- Spell Lock (Felhunter)
	[115781] = 19647, -- Observer
	[19647] = {
		class = 'WARLOCK',
		duration = 3,
		cooldown = 24,
		type = 'interrupt',
		pet = true,
	},
	-- Whiplash (Succubus)
	[6360] = {
		class = 'WARLOCK',
		cooldown = 25,
		type = 'misc',
		pet = true,
	},
	-- Axe Toss (Felguard)
	[89766] = {
		class = 'WARLOCK',
--		spec = 2,
		cooldown = 30,
		type = 'cc',
		pet = true,
	},
	-- Felstorm (Felguard)
	[89751] = {
		class = 'WARLOCK',
--		spec = 2,
		duration = 6,
		cooldown = 45,
		type = 'offensive',
		pet = true,
	},
}

local spec = {
	-- Unstable Affliction
	[30108] = 1,
	-- Summon Felguard
	[30146] = 2,
	-- Curse of Exhaustion
	[18223] = 1,
	-- Haunt
	[48181] = 1,
	-- Shadowburn
	[17877] = 3,
	-- Bane of Havoc
	[80240] = 3,
	-- Chaos Bolt
	[50796] = 3,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

local addon = PvPTimer

local spells = {
	-- Avenging Wrath
	[31884] = {
		class = 'PALADIN',
		duration = 20,
		cooldown = 180,
		type = 'offensive',
	},
	-- Divine Favor
	[31842] = {
		class = 'PALADIN',
		spec = 1,
		duration = 20,
		cooldown = 180,
		type = 'defensive',
	},
	-- Holy Avenger
	[105809] = {
		class = 'PALADIN',
		duration = 18,
		cooldown = 120,
		type = 'offensive',
	},
	-- Ardent Defender
	[31850] = {
		class = 'PALADIN',
		spec = 2,
		duration = 10,
		cooldown = 180,
		type = 'defensive',
	},
	-- Devotion Aura
	[31821] = {
		class = 'PALADIN',
		duration = 6,
		cooldown = 180,
		type = 'defensive',
	},
	-- Hand of Protection
	[1022] = {
		class = 'PALADIN',
		duration = 10,
		cooldown = 300,
		type = 'defensive',
	},
	-- Divine Protection
	[498] = {
		class = 'PALADIN',
		duration = 10,
		cooldown = 60,
		type = 'defensive',
	},
	-- Divine Shield
	[642] = {
		class = 'PALADIN',
		duration = 8,
		cooldown = 300,
		type = 'defensive',
	},
	-- Hand of Sacrifice
	[6940] = {
		class = 'PALADIN',
		duration = 12,
		cooldown = 120,
		type = 'defensive',
	},
	-- Rebuke
	[96231] = {
		class = 'PALADIN',
		cooldown = 15,
		type = 'interrupt',
	},
	-- Avenger's Shield
	[31935] = {
		class = 'PALADIN',
		spec = 2,
		cooldown = 15,
		type = 'interrupt',
	},
	-- Divine Plea
	[54428] = {
		class = 'PALADIN',
		duration = 9,
		cooldown = 120,
		type = 'misc',
	},
	-- Hammer of Justice
	[853] = {
		class = 'PALADIN',
		duration = 6,
		cooldown = 60,
		type = 'cc',
	},
	-- Repentance
	[20066] = {
		class = 'PALADIN',
		duration = 8,
		cooldown = 15,
		type = 'cc',
	},
	-- Lay on Hands
	[633] = {
		class = 'PALADIN',
		cooldown = 600,
		cooldown_g = -120,
		type = 'defensive',
	},
	-- Hand of Freedom
	[1044] = {
		class = 'PALADIN',
		duration = 6,
		cooldown = 25,
		type = 'misc',
	},
	-- Guardian of Ancient Kings -- Holy
	[86669] = {
		class = 'PALADIN',
		duration = 30,
		cooldown = 300,
		type = 'defensive',
	},
	-- Guardian of Ancient Kings -- Ret
	[86698] = {
		class = 'PALADIN',
		duration = 30,
		cooldown = 300,
		type = 'offensive',
	},
	-- Guardian of Ancient Kings -- Prot
	[86659] = {
		class = 'PALADIN',
		duration = 30,
		cooldown = 180,
		type = 'defensive',
	},
	-- Hand of Purity
	[114039] = {
		class = 'PALADIN',
		duration = 6,
		cooldown = 30,
		type = 'defensive',
	},
	-- Speed of Light
	[85499] = {
		class = 'PALADIN',
		duration = 8,
		cooldown = 45,
		type = 'misc',
	},
	-- Fist of Justice
	[105593] = {
		class = 'PALADIN',
		duration = 6,
		cooldown = 30,
		type = 'cc',
	},
	-- Repentance
	[20066] = {
		class = 'PALADIN',
		duration = 8,
		cooldown = 15,
		type = 'cc',
	},
	-- Blinding Light
	[115750] = {
		class = 'PALADIN',
		duration = 6,
		cooldown = 120,
		type = 'cc',
	},
}

local spec = {
	-- Holy Shock
	[20473] = 1,
	-- Templar's Verdict
	[85256] = 3,
	-- Beacon of Light
	[53563] = 1,
	-- Light of Dawn
	[85222] = 1,
	-- Avenger's Shield
	[31935] = 2,
	-- Shield of the Righteous
	[53600] = 2,
	-- Divine Storm
	[53385] = 3,
	-- Exorcism
	[879] = 3,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

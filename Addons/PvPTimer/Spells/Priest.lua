local addon = PvPTimer

local spells = {
	-- Shadowfiend
	[34433] = {
		class = 'PRIEST',
		duration = 13,
		cooldown = 180,
		type = 'offensive',
	},
	-- Power Infusion
	[10060] = {
		class = 'PRIEST',
		duration = 20,
		cooldown = 120,
		type = 'offensive',
	},
	-- Guardian Spirit
	[47788] = {
		class = 'PRIEST',
		spec = 2,
		duration = 10,
		cooldown = 180,
		type = 'defensive',
	},
	-- Pain Suppression
	[33206] = {
		class = 'PRIEST',
		duration = 8,
		cooldown = 180,
		type = 'defensive',
	},
	-- Fear Ward
	[6346] = {
		class = 'PRIEST',
		duration = 180,
		duration_g = -60,
		cooldown = 180,
		cooldown_g = -60,
		type = 'defensive',
	},
	-- Desperate Prayer
	[19236] = {
		class = 'PRIEST',
		cooldown = 120,
		type = 'defensive',
	},
	-- Dispersion
	[47585] = {
		class = 'PRIEST',
		spec = 3,
		duration = 6,
		cooldown = 120,
		cooldown_g = -15,
		type = 'defensive',
	},
	-- Inner Focus
	[89485] = {
		class = 'PRIEST',
		spec = 1,
		duration = 5,
		cooldown = 45,
		type = 'defensive',
	},
	-- Power Word: Barrier
	[62618] = {
		class = 'PRIEST',
		spec = 1,
		duration = 10,
		cooldown = 180,
		type = 'defensive',
	},
	-- Silence
	[15487] = {
		class = 'PRIEST',
		spec = 3,
		duration = 5,
		cooldown = 45,
		type = 'interrupt',
	},
	-- Psychic Horror
	[64044] = {
		class = 'PRIEST',
		spec = 3,
		duration = 3,
		cooldown = 45,
		cooldown_g = -10,
		type = 'cc',
	},
	-- Hymn of Hope
	[64901] = {
		class = 'PRIEST',
		duration = 8,
		cooldown = 360,
		type = 'defensive',
	},
	-- Divine Hymn
	[64843] = {
		class = 'PRIEST',
		spec = 2,
		duration = 8,
		cooldown = 180,
		type = 'defensive',
	},
	-- Leap of Faith
	[73325] = {
		class = 'PRIEST',
		cooldown = 90,
		type = 'defensive',
	},
	-- Psychic Scream
	[8122] = {
		class = 'PRIEST',
		cooldown = 27,
		cooldown_g = 3,
		cooldown_s3 = -4,
		type = 'cc',
	},
	-- Fade
	[586] = {
		class = 'PRIEST',
		cooldown = 30,
		cooldown_g = -6,
		cooldown_s3 = -9,
		type = 'misc',
	},
	-- Holy Word: Chastise
	[88625] = {
		class = 'PRIEST',
		spec = 2,
		cooldown = 30,
		type = 'cc',
	},
	-- Lightwell
	[724] = {
		class = 'PRIEST',
		spec = 2,
		duration = 180,
		cooldown = 180,
		type = 'defensive',
	},
	-- Vampiric Embrace
	[15286] = {
		class = 'PRIEST',
		spec = 3,
		duration = 15,
		cooldown = 180,
		type = 'defensive',
	},
	-- Spectral Guise
	[112833] = {
		class = 'PRIEST',
		cooldown = 30,
		type = 'defensive',
	},
	-- Fade /Phantasm
	[586] = {
		class = 'PRIEST',
		duration = 3,
		cooldown = 30,
		type = 'defensive',
	},
	-- Void Tendrils
	[108920] = {
		class = 'PRIEST',
		duration = 8,
		cooldown = 30,
		type = 'root',
	},
	-- Dominate Mind
	[605] = {
		class = 'PRIEST',
		cooldown = 30,
		type = 'cc',
	},
	-- Psyfiend
	[108921] = {
		class = 'PRIEST',
		duration = 8, --??
		cooldown = 45,
		type = 'cc',
	},
	-- Mass Dispel
	[32375] = {
		class = 'PRIEST',
		cooldown = 15,
		type = 'misc',
	},
}

local spec = {
	-- Penance
	[47540] = 1,
	-- Mind Flay
	[15407] = 3,
	-- Chakra
	[14751] = 2,
	-- Circle of Healing
	[34861] = 2,
	-- Shadowform
	[15473] = 3,
	-- Vampiric Embrace
	[15286] = 3,
	-- Vampiric Touch
	[34914] = 3,
	-- Holy Word: Serenity
	[88684] = 2,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

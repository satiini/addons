local addon = PvPTimer

local spells = {
	-- Touch of Death
	[115080] = {
		class = 'MONK',
        cooldown_g = 120,
		type = 'offensive',
	},
    -- Fortifying Brew
    [115203] = {
        class = 'MONK',
        type = 'defensive',
    },
    -- Spear Hand Strike
    [116705] = {
        class = 'MONK',
        type = 'interrupt',
    },
    -- Paralysis
    [115078] = {
        class = 'MONK',
        type = 'cc',
    },
    -- Grapple Weapon
    [117368] = {
        class = 'MONK',
        type = 'misc',
    },
    -- Zen Meditation
    [115176] = {
        class = 'MONK',
        type = 'defensive',
    },
    -- Transcendence
    [101643] = {
        class = 'MONK',
        type = 'misc',
    },
    -- Avert Harm
    [115213] = {
        class = 'MONK',
        spec = 1,
        type = 'defensive',
    },
    -- Clash
    [122057] = {
        class = 'MONK',
        spec = 1,
        type = 'cc',
    },
    -- Energizing Brew
    [115288] = {
        class = 'MONK',
        spec = 2,
        type = 'misc',
    },
    -- Fists of Fury
    [113656] = {
        class = 'MONK',
        spec = 2,
        type = 'cc',
    },
    -- Fists of Fury
    [101545] = {
        class = 'MONK',
        spec = 2,
        type = 'root',
    },
    -- Guard
    [115295] = {
        class = 'MONK',
        spec = 1,
        type = 'defensive',
    },
    -- Life Cocoon
    [116849] = {
        class = 'MONK',
        spec = 3,
        type = 'defensive',
    },
    -- Revival
    [115310] = {
        class = 'MONK',
        spec = 3,
        type = 'defensive',
    },
    -- Summon Black Ox Statue
    [115315] = {
        class = 'MONK',
        spec = 1,
        type = 'defensive',
    },
    -- Tiger's Lust
    [116841] = {
        class = 'MONK',
        type = 'misc',
    },
    -- Summon Jade Serpent Statue
    [115313] = {
        class = 'MONK',
        spec = 3,
        type = 'defensive',
    },
    -- Thunder Focus Tea
    [116680] = {
        class = 'MONK',
        spec = 3,
        type = 'defensive',
    },
    -- Touch of Karma
    [122470] = {
        class = 'MONK',
        spec = 2,
        type = 'defensive',
    },
    -- Charging Ox Wave
    [119392] = {
        class = 'MONK',
        type = 'cc',
    },
    -- Rushing Jade Wind
    [116847] = {
        class = 'MONK',
        type = 'offensive',
    },
    -- Diffuse Magic
    [122783] = {
        class = 'MONK',
        type = 'defensive',
    },
    -- Invoke Xuen, the White Tiger
    [123904] = {
        class = 'MONK',
        type = 'offensive',
    },
    -- Chi Brew
    [115399] = {
        class = 'MONK',
        type = 'misc',
    },
    -- Dampen Harm
    [122278] = {
        class = 'MONK',
        type = 'defensive',
    },
    -- Diffuse Magic
    [119381] = {
        class = 'MONK',
        type = 'cc',
    },
}

local spec = {
	-- Breath of Fire
	[115181] = 1,
	-- Dizzying Haze
	[115180] = 1,
	-- Purifying Brew
	[119582] = 1,
	-- Rising Sun Kick
	[107428] = 2,
	-- Spinning Fire Blossom
	[115073] = 2,
	-- Enveloping Mist
	[124682] = 3,
	-- Renewing Mist
	[115151] = 3,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

local addon = PvPTimer

local spells = {
	-- Bestial Wrath
	[19574] = {
		class = 'HUNTER',
		spec = 1,
		duration = 10,
		cooldown = 60,
		type = 'offensive',
	},
	-- Fervor
	[82726] = {
		class = 'HUNTER',
		cooldown = 30,
		type = 'offensive',
	},
	-- Rapid Fire
	[3045] = {
		class = 'HUNTER',
		duration = 15,
		cooldown = 180,
		type = 'offensive',
	},
	-- Disengage
	[781] = {
		class = 'HUNTER',
		cooldown = 25,
		cooldown_t = -10,
		type = 'misc',
	},
	-- Scatter Shot
	[19503] = {
		class = 'HUNTER',
		duration = 4,
		cooldown = 30,
		type = 'cc',
	},
	-- Feign Death
	[5384] = {
		class = 'HUNTER',
		duration = 360,
		cooldown = 30,
		type = 'defensive',
	},
	-- Master's Call
	[53271] = {
		class = 'HUNTER',
		duration = 4,
		duration_g = 4,
		cooldown = 45,
		type = 'misc',
	},
	-- Deterrence
	[19263] = {
		class = 'HUNTER',
		duration = 5,
		cooldown = 120,
		cooldown_t = -60,
		type = 'defensive',
	},
	-- Camouflage
	[51753] = {
		class = 'HUNTER',
		cooldown = 60,
		type = 'defensive',
	},
	-- Silencing Shot
	[34490] = {
		class = 'HUNTER',
		cooldown = 20,
		type = 'interrupt',
	},
	-- Flare
	[1543] = {
		class = 'HUNTER',
		duration = 20,
		cooldown = 20,
		type = 'misc',
	},
	-- Wyvern Sting
	[19386] = {
		class = 'HUNTER',
		cooldown = 60,
		type = 'cc',
	},
	-- Readiness
	[23989] = {
		class = 'HUNTER',
		cooldown = 300,
		resets = 'all',
		type = 'misc',
	},
	-- Binding Shot
	[109248] = {
		class = 'HUNTER',
		duration = 3,
		cooldown = 45,
		type = 'cc',
	},
	-- A Murder of Crows
	[131894] = {
		class = 'HUNTER',
		duration = 30,
		cooldown = 120,
		type = 'cc',
	},
	-- Stampede
	[121818] = {
		class = 'HUNTER',
		duration = 20,
		cooldown = 300,
		type = 'offensive',
	},
	
	-- FROST TRAPS
	
	-- Ice Trap (launcher)
	[82941] = 13809,
	-- Ice Trap
	[13809] = {
		class = 'HUNTER',
		duration = 60,
		cooldown = 28,
		cooldown_s3 = -6,
		type = 'root',
	},
	-- Freezing Trap (launcher)
	[60192] = 1499,
	-- Freezing Trap
	[1499] = {
		class = 'HUNTER',
		duration = 60,
		cooldown = 28,
		cooldown_s3 = -6,
		type = 'cc',
	},
	
	-- FIRE TRAPS
	
	-- Black Arrow
	[3674] = {
		class = 'HUNTER',
		spec = 3,
		cooldown = 22,
		type = 'offensive',
	},
	-- Explosive Trap (launcher)
	[82939] = 13813,
	-- Explosive Trap
	[13813] = {
		class = 'HUNTER',
		duration = 60,
		cooldown = 28,
		cooldown_s3 = -6,
		type = 'offensive',
	},
	
	-- NATURE TRAPS

	-- Snake Trap (launcher)
	[82948] = 34600,
	-- Snake Trap
	[34600] = {
		class = 'HUNTER',
		duration = 60,
		cooldown = 28,
		cooldown_s3 = -6,
		type = 'misc',
	},
	
	-- PET SKILLS

	-- Intimidation
	[19577] = {
		class = 'HUNTER',
		spec = 1,
		duration = 3,
		cooldown = 60,
		type = 'cc',
	},
	-- Roar of Sacrifice
	[53480] = {
		class = 'HUNTER',
		duration = 12,
		cooldown = 60,
		type = 'defensive',
		pet = true,
	},
	-- Bullheaded
	[53490] = {
		class = 'HUNTER',
		duration = 12,
		cooldown = 180,
		type = 'defensive',
		pet = true,
	},
	-- Roar of Recovery
	[53517] = {
		class = 'HUNTER',
		duration = 9,
		cooldown = 180,
		type = 'misc',
		pet = true,
	},
	-- Nether Shock (Nether Ray)
	[50479] = {
		class = 'HUNTER',
		cooldown = 40,
		type = 'interrupt',
		pet = true,
	},
	-- Pin (Crab)
	[50245] = {
		class = 'HUNTER',
		duration = 4,
		cooldown = 40,
		type = 'root',
		pet = true,
	},
	-- Web (Spider)
	[4167] = {
		class = 'HUNTER',
		duration = 5,
		cooldown = 40,
		type = 'root',
		pet = true,
	},
	-- Venom Web Spray (Silithid)
	[54706] = {
		class = 'HUNTER',
		spec = 1, -- pet is exotic
		duration = 5,
		cooldown = 40,
		type = 'root',
		pet = true,
	},
	-- Sonic Blast (Bat)
	[50519] = {
		class = 'HUNTER',
		duration = 2,
		cooldown = 60,
		type = 'cc',
		pet = true,
	},
	-- Horn Toss (Rhino)
	[93434] = {
		class = 'HUNTER',
--		spec = 1, -- pet is exotic
		cooldown = 90,
		type = 'misc',
		pet = true,
	},
	-- Pummel (Gorilla)
	[26090] = {
		class = 'HUNTER',
		cooldown = 30,
		type = 'interrupt',
		pet = true,
	},
	-- Serenity Dust (Moth)
	[50318] = {
		class = 'HUNTER',
		cooldown = 60,
		type = 'interrupt',
		pet = true,
	},
	-- Ancient Hysteria
	[90355] = {
		class = 'HUNTER',
--		spec = 1, -- pet is exotic
		duration = 40,
		cooldown = 360,
		type = 'offensive',
		pet = true,
	},
	-- Clench (Scorpid)
	[50541] = {
		class = 'HUNTER',
		cooldown = 60,
		type = 'misc',
		pet = true,
	},
	-- Snatch (Bird of Prey)
	[91644] = {
		class = 'HUNTER',
		cooldown = 60,
		type = 'misc',
		pet = true,
	},
	-- Bad Manner (Monkey)
	[90337] = {
		class = 'HUNTER',
		duration = 4,
		cooldown = 60,
		type = 'cc',
		pet = true,
	},
	-- Lock Jaw (Dog)
	[90327] = {
		class = 'HUNTER',
		duration = 4,
		cooldown = 40,
		type = 'root',
		pet = true,
	},
	-- Sting (Wasp)
	[56626] = {
		class = 'HUNTER',
		duration = 2,
		cooldown = 45,
		type = 'cc',
		pet = true,
	},
	-- Web Wrap (Shale Spider)
	[96201] = {
		class = 'HUNTER',
--		spec = 1, -- pet is exotic
		duration = 3,
		cooldown = 45,
		type = 'cc',
		pet = true,
	},
}

local spec = {
	-- Aimed Shot
	[19434] = 2,
	-- Aimed Shot
	[82928] = 2,
	-- Explosive Shot
	[53301] = 3,
	-- Wild Quiver
	[76663] = 2,
	-- Black Arrow
	[3674] = 3,
	-- Chimera Shot
	[53209] = 2,
	-- Kill Command
	[34026] = 1,
}

local hs = addon.Spells
for k, v in pairs(spells) do hs[k] = v end

local ss = addon.SpecSpells
for k, v in pairs(spec) do ss[k] = v end

local mod	= DBM:NewMod(632, "DBM-Party-WotLK", 12, 283)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 79 $"):sub(12, -3))
mod:SetCreatureID(31134)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"CHAT_MSG_MONSTER_YELL"
)

local warningVacuum		= mod:NewSpellAnnounce(58694, 1)
local warningBlizzard	= mod:NewSpellAnnounce(58693, 3)
local warningMana		= mod:NewTargetAnnounce(59374, 2)
local timerVacuumCD		= mod:NewCDTimer(35, 58694)
local timerMana			= mod:NewTargetTimer(8, 59374)
local timerCombat		= mod:NewCombatTimer(16)

function mod:OnCombatStart(delay)
	timerVacuumCD:Start(30 - delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 58694 then
		warningVacuum:Show()
		timerVacuumCD:Cancel()
		timerVacuumCD:Start()
	elseif args:IsSpellID(58693, 59369) then
		warningBlizzard:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 59374 then
		warningMana:Show(args.destName)
		timerMana:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 59374 then
		timerMana:Cancel()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.CyanArrived then
		self:SendSync("CyanArrived")
	end
end

function mod:OnSync(msg, arg)
	if msg == "CyanArrived" then
		timerCombat:Start()
	end
end
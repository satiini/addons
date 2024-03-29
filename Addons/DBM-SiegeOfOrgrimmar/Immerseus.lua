﻿local mod	= DBM:NewMod(852, "DBM-SiegeOfOrgrimmar", nil, 369)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndPZ		= mod:NewSound(nil, "SoundPZ", true)

mod:SetRevision(("$Revision: 10274 $"):sub(12, -3))
mod:SetCreatureID(71543)--Doesn't die, will need kill detection
mod:SetReCombatTime(45)--Lets just assume he has same bug as tsulong in advance and avoid problems
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_DIED",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_PERIODIC_MISSED",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL"
)

local warnBreath					= mod:NewSpellAnnounce(143436, 3, nil, mod:IsTank() or mod:IsHealer())
local warnShaBolt					= mod:NewSpellAnnounce(143295, 3, nil, false)
local warnSwirl						= mod:NewSpellAnnounce(143309, 4)
local warnSplit						= mod:NewSpellAnnounce(143020, 2)
local warnReform					= mod:NewSpellAnnounce(143469, 2)
local warnSwellingCorruptionCast	= mod:NewSpellAnnounce(143578, 2, 143574)--Heroic (this is the boss spellcast trigger spell NOT personal debuff warning)

local specWarnBreath				= mod:NewSpecialWarningSpell(143436, mod:IsTank())
local specWarnShaSplash				= mod:NewSpecialWarningMove(143297)
local specWarnSwirl					= mod:NewSpecialWarningSpell(143309, nil, nil, nil, 2)
local specWarnSwellingCorruption	= mod:NewSpecialWarningStack(143574, nil, 3)
local specWarnSplit					= mod:NewSpecialWarningCount(143020, nil, nil, nil, 2)

local timerBreathCD					= mod:NewCDTimer(35, 143436, nil, mod:IsTank() or mod:IsHealer())--35-65 second variation wtf?
local timerShaBoltCD				= mod:NewCDTimer(6, 143295, nil, false)--every 6-20 seconds (yeah it variates that much)
local timerSwirlCD					= mod:NewCDTimer(48.5, 143309)
local timerShaResidue				= mod:NewBuffActiveTimer(10, 143459)
local timerPurifiedResidue			= mod:NewBuffActiveTimer(15, 143524)
local timerSwellingCorruptionCD		= mod:NewCDTimer(75, 143578, nil, nil, nil, 143574)

local berserkTimer					= mod:NewBerserkTimer(605)

local lastPower = 100

local splitcount = 0
local needwarnsafe = false
local needwarndr = false
local killcount = 0
local cleancount = 0

mod:AddBoolOption("InfoFrame", true, "sound")
mod:AddBoolOption("dr", true, "sound")
for i = 1, 8 do
	mod:AddBoolOption("dr"..i, false, "sound")
end

local function MyJS()
	if (mod.Options.dr1 and splitcount == 1) or (mod.Options.dr2 and splitcount == 2) or (mod.Options.dr3 and splitcount == 3) or (mod.Options.dr4 and splitcount == 4) or (mod.Options.dr5 and splitcount == 5) or (mod.Options.dr6 and splitcount == 6) or (mod.Options.dr7 and splitcount == 7) or (mod.Options.dr8 and splitcount == 8) then
		return true
	end
	return false
end

local function updateInfoFrame()
	if mod.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(GetSpellInfo(143020))
		DBM.InfoFrame:Show(2, "other", killcount, L.kill, cleancount, L.clean)
	end
end

function mod:OnCombatStart(delay)
	lastPower = 100
	splitcount = 0
	needwarnsafe = false
	needwarndr = false
	killcount = 0
	cleancount = 0
	timerBreathCD:Start(10-delay)
	timerSwirlCD:Start(20-delay)
	sndWOP:Schedule(16-delay, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_xwzb.mp3")--漩渦準備
	sndWOP:Schedule(17-delay, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
	sndWOP:Schedule(18-delay, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
	sndWOP:Schedule(19-delay, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
	berserkTimer:Start(-delay)
	self:RegisterShortTermEvents(
		"UNIT_POWER_FREQUENT boss1"--Do not want this one persisting out of combat even after a wipe, in case you go somewhere else.
	)
	if self:IsDifficulty("heroic10", "heroic25") then
		timerSwellingCorruptionCD:Start(12.5-delay)--12.5-14sec variation
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 143436 then
		warnBreath:Show()
		specWarnBreath:Show()
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_zbcj.mp3") --準備衝擊
		end
		timerBreathCD:Start()
	elseif args.spellId == 143309 then
		warnSwirl:Show()
		specWarnSwirl:Show()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_xwzb.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_xw.mp3") --漩渦
		sndWOP:Schedule(44, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_xwzb.mp3")--漩渦準備
		sndWOP:Schedule(45, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOP:Schedule(46, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOP:Schedule(47, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
		timerSwirlCD:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 143459 and args:IsPlayer() then
		timerShaResidue:Start()
	elseif args.spellId == 143524 and args:IsPlayer() then
		timerPurifiedResidue:Start()
	elseif args.spellId == 143297 and args:IsPlayer() and self:AntiSpam(2, 1) then
		specWarnShaSplash:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	elseif args.spellId == 143523 then
		cleancount = cleancount + 1
		updateInfoFrame()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(117878) and args:IsPlayer() then
		if (args.amount or 1) >= 3 then
			needwarnsafe = true
			specWarnSwellingCorruption:Show(args.amount)
			sndPZ:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\stopatk.mp3") --注意停手
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 143459 and args:IsPlayer() then
		timerShaResidue:Cancel()
	elseif args.spellId == 143524 and args:IsPlayer() then
		timerPurifiedResidue:Cancel()
	elseif args:IsSpellID(117878) and args:IsPlayer() then
		if needwarnsafe then
			sndPZ:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\safenow.mp3") --安全
			needwarnsafe = false
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 143297 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnShaSplash:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_DAMAGE(_, _, _, _, _, _, _, _, spellId)
	if spellId == 145377 or spellId == 143498 then
		if needwarndr then
			needwarndr = false
			if MyJS() then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\defensive.mp3") --注意減傷
			else
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\holdit.mp3")
			end
		end
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 143020 then--Split
		splitcount = splitcount + 1
		warnSplit:Show()
		specWarnSplit:Show(splitcount)
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_xwzb.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_fl.mp3") --分裂開始
		timerBreathCD:Cancel()
		timerSwirlCD:Cancel()
		timerShaBoltCD:Cancel()
		timerSwellingCorruptionCD:Cancel()
		needwarndr = true
		killcount = 0
		cleancount = 0
		updateInfoFrame()
	elseif spellId == 143293 and self:AntiSpam(3, 2) then--Sha Bolt
		warnShaBolt:Show()
		timerShaBoltCD:Start()
	elseif spellId == 143578 then--Swelling Corruption
		warnSwellingCorruptionCast:Show()
		timerSwellingCorruptionCD:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_pz.mp3") --膨脹
	end
end

function mod:UNIT_POWER_FREQUENT(uId)
	local power = UnitPower(uId)
	if power == 0 and self:AntiSpam(3, 1) then
	end
	if power > lastPower then--Only time his power ever goes UP is when he is defeated. he reaches 0 power, then goes back to 1 power
		DBM:EndCombat(self)
	end
	lastPower = power
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg:find("spell:143469") then--Reforms
		warnReform:Show()
		needwarndr = false
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_fljs.mp3") --分裂結束
--		timerBreathCD:Start(15)--8-15 second variation, iffy on this being set
		timerSwirlCD:Start(24)--24-26 variation, this probably is set?
		sndWOP:Schedule(20, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_xwzb.mp3")--漩渦準備
		sndWOP:Schedule(21, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOP:Schedule(22, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOP:Schedule(23, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
--[[		if self:IsDifficulty("heroic10", "heroic25") then
			timerSwellingCorruptionCD:Start(12.5)
		end--]]
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Victory then
		self:SendSync("Victory")
	end
end

function mod:OnSync(msg)
	if msg == "Victory" and self:IsInCombat() then
		DBM:EndCombat(self)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 71603 then
		killcount = killcount + 1
		updateInfoFrame()
	end
end
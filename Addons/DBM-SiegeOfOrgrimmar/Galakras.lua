local mod	= DBM:NewMod(868, "DBM-SiegeOfOrgrimmar", nil, 369)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndZQ		= mod:NewSound(nil, "SoundZQ", true)
local sndTT		= mod:NewSound(nil, "SoundTT", true)

mod:SetRevision(("$Revision: 10202 $"):sub(12, -3))
mod:SetCreatureID(72311, 72560, 72249)--Boss needs to engage off Varian/Lor'themar, not the boss. I include the boss too so we don't detect a win off losing varian. :)
mod:SetReCombatTime(120)--fix combat re-starts after killed. Same issue as tsulong. Fires TONS of IEEU for like 1-2 minutes after fight ends.
mod:SetMainBossID(72249)
mod:SetZone()

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_PERIODIC_MISSED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_DIED",
	"UNIT_SPELLCAST_SUCCEEDED target focus boss1",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

--Stage 2: Bring Her Down!
----TODO, don't want this mod to register events in entire zone so it can warn for prelude trash.
----I'll put duplicate events in trash mod instead since trash mod will be disabled during encounters
local warnWarBanner					= mod:NewSpellAnnounce(147328, 3)
local warnFracture					= mod:NewTargetAnnounce(146899, 3)--TODO: see if target scanning works with one of earlier events
local warnChainHeal					= mod:NewCastAnnounce(146757, 4)
local warnDemolisher				= mod:NewSpellAnnounce("ej8562", 3, 116040)
local warnHealingTideTotem			= mod:NewSpellAnnounce(146753, 4)
----Master Cannoneer Dragryn (Tower)
local warnMuzzleSpray				= mod:NewSpellAnnounce(147824, 3)--147824 spams combat log, 147825 is actual cast but does not show in combat log only UNIT event
----Lieutenant General Krugruk (Tower)
local warnArcingSmash				= mod:NewSpellAnnounce(147688, 3)
----High Enforcer Thranok (Road)
local warnCrushersCall				= mod:NewSpellAnnounce(146769, 4)
local warnShatteringCleave			= mod:NewSpellAnnounce(146849, 3, nil, mod:IsTank())
local warnCurseVenom				= mod:NewSpellAnnounce(147711, 3)

--Phase 3: Galakras,The Last of His Progeny
local warnPhase2					= mod:NewPhaseAnnounce(2, 2)
local warnFlamesofGalakrondTarget	= mod:NewTargetAnnounce(147068, 4)
local warnFlamesofGalakrond			= mod:NewStackAnnounce(147029, 2, nil, mod:IsTank())

--Stage 2: Bring Her Down!
local specWarnWarBanner				= mod:NewSpecialWarningSwitch(147328, not mod:IsHealer())
local specWarnFractureYou			= mod:NewSpecialWarningYou(146899)
local yellFracture					= mod:NewYell(146899)
local specWarnFracture				= mod:NewSpecialWarningTarget(146899, mod:IsHealer())
local specWarnChainheal				= mod:NewSpecialWarningInterrupt(146757)
local specWarnFlameArrow			= mod:NewSpecialWarningMove(146764)
local specWarnShadowAttack			= mod:NewSpecialWarningMove(146872)
local specWarnHealingTideTotem		= mod:NewSpecialWarningSwitch(146753, not mod:IsHealer())
----Master Cannoneer Dragryn (Tower)
local specWarnMuzzleSpray			= mod:NewSpecialWarningSpell(147824, nil, nil, nil, 2)
----Lieutenant General Krugruk (Tower)
local specWarnArcingSmash			= mod:NewSpecialWarningSpell(147688, nil, nil, nil, 2)
----High Enforcer Thranok (Road)
local specWarnCrushersCall			= mod:NewSpecialWarningSpell(146769, false, nil, nil, 2)--optional pre warning for the grip soon. although melee/tank probably don't really care and ranged are 50/50
local specWarnSkullCracker			= mod:NewSpecialWarningRun(146848, nil, nil, nil, 3)--TODO, only warn the ranged who were gripped in by crushers call, instead of all of them
----Korgra the Snake (Road)
local specWarnPoisonCloud			= mod:NewSpecialWarningMove(147705)
local specWarnCurseVenom			= mod:NewSpecialWarningSpell(147711)
--Phase 3: Galakras,The Last of His Progeny
local specWarnFlamesofGalakrond		= mod:NewSpecialWarningSpell(147029, false, nil, nil, 2)--Cast often, so lets make this optional since it's spammy
local specWarnFlamesofGalakrondYou	= mod:NewSpecialWarningYou(147068)
local yellFlamesofGalakrond			= mod:NewYell(147068)
local specWarnFlamesofGalakrondTank	= mod:NewSpecialWarningStack(147029, mod:IsTank(), 3)
local specWarnFlamesofGalakrondOther= mod:NewSpecialWarningTarget(147029, mod:IsTank())

--Stage 2: Bring Her Down!
local timerAddsCD					= mod:NewTimer(55, "timerAddsCD", 2457)
local timerTowerCD					= mod:NewTimer(20, "timerTowerCD", 88852)
local timerDemolisherCD				= mod:NewNextTimer(20, "ej8562", nil, nil, nil, 116040)--EJ is just not complete yet, shouldn't need localizing
----High Enforcer Thranok (Road)
local timerShatteringCleaveCD		= mod:NewCDTimer(7.5, 146849, nil, mod:IsTank())
local timerCrushersCallCD			= mod:NewNextTimer(30, 146769)

--Phase 3: Galakras,The Last of His Progeny
local timerFlamesofGalakrondCD		= mod:NewCDTimer(6, 147068)
local timerFlamesofGalakrond		= mod:NewTargetTimer(15, 147029, nil, mod:IsTank())

mod:AddBoolOption("FixateIcon", true)

local demoCount = 0
local addsCount = 0
local addsDebug = 0

--[[
ENGAGE
14.5 adds 1
45.5 adds 2
55.5 adds 3 (also tower)
+20 (Demolisher)
--This gap verified in 2 logs now and video. Seems intended for miniboss.
+90 adds 4
+55 adds 5(also tower)
+20 (Demolisher)
+34 adds 6 (or 54 after tower)
+55 adds 7
?? Unknown, had boss down by then
--]]

local drcount = 0

mod:AddEditBoxOption("flamecount", 50, "", "sound", 
function()
	if mod.Options.flamecount == "" then return end
	local checknum = tonumber(mod.Options.flamecount)	
	if type(checknum) == "number" then
		DBM:AddMsg("["..L.name.."]".."|cFF00FF00"..mod.localization.options["flamecount"]..DBM_CORE_SETTO..checknum.."|r")
	else
		DBM:AddMsg("["..L.name.."]"..DBM_CORE_WRONGSET.."\""..mod.Options.flamecount.."\"")
		DBM:AddMsg("["..L.name.."]"..DBM_CORE_WRONGSET.."\""..mod.Options.flamecount.."\"")
		DBM:AddMsg("["..L.name.."]"..DBM_CORE_WRONGSET.."\""..mod.Options.flamecount.."\"")
	end
end)

local function MyJS()
	local flamenum = mod.Options.flamecount
	flamenum = tonumber(flamenum)
	if flamenum == drcount then
		return true
	end
	return false
end

function mod:OnCombatStart(delay)
	demoCount = 0
	addsCount = 1
	addsDebug = 0
	drcount = 0
	timerAddsCD:Start(60-delay) --BH FIX
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 147688 and self:checkTankDistance(args.sourceGUID, 60) then--Might be an applied event instead
		warnArcingSmash:Show()
		specWarnArcingSmash:Show()
		if self:AntiSpam(10, 4) then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\carefly.mp3")--小心击飞
		end
	elseif args.spellId == 146757 and self:checkTankDistance(args.sourceGUID, 60) then
		local source = args.sourceName
		warnChainHeal:Show()
		if source == UnitName("target") or source == UnitName("focus") then 
			specWarnChainheal:Show(source)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\kickcast.mp3") --快打斷
		end
	elseif args.spellId == 146848 and self:checkTankDistance(args.sourceGUID, 60) then
		specWarnSkullCracker:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_sfzd.mp3")--旋風斬
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 146769 and self:checkTankDistance(args.sourceGUID, 60) then
		warnCrushersCall:Show()
		specWarnCrushersCall:Show()
		timerCrushersCallCD:Start()
	elseif args.spellId == 146849 and self:checkTankDistance(args.sourceGUID, 60) then
		warnShatteringCleave:Show()
		timerShatteringCleaveCD:Start()
	elseif args.spellId == 146753 and self:checkTankDistance(args.sourceGUID, 60) then
		warnHealingTideTotem:Show()
		specWarnHealingTideTotem:Show()
		sndTT:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_ttkd.mp3") --圖騰快打
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 147068 then
		warnFlamesofGalakrondTarget:Show(args.destName)
		timerFlamesofGalakrondCD:Start()
		if args:IsPlayer() then
			specWarnFlamesofGalakrondYou:Show()
			yellFlamesofGalakrond:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\justrun.mp3") --快跑
		else
			specWarnFlamesofGalakrond:Show()
		end
		if self.Options.FixateIcon then
			self:SetIcon(args.destName, 8)
		end
		drcount = drcount + 1
		if MyJS() then
			sndWOP:Schedule(3, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\defensive.mp3") --注意減傷
		end
	elseif args.spellId == 147029 then--Tank debuff version
		warnFlamesofGalakrond:Show(args.destName, 1)
		timerFlamesofGalakrond:Start(args.destName)
	elseif args.spellId == 147328 and self:checkTankDistance(args.sourceGUID, 60) then
		warnWarBanner:Show()
		specWarnWarBanner:Show()
		sndZQ:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_zqkd.mp3")--战旗快打
	elseif args.spellId == 146899 and self:checkTankDistance(args.sourceGUID, 60) then
		warnFracture:Show(args.destName)
		if args:IsPlayer() then
			specWarnFractureYou:Show()
			yellFracture:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\chargemove.mp3")--冲锋快躲
		else
			specWarnFracture:Show(args.destName)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_sgcf.mp3")--碎骨冲锋
		end
	elseif args.spellId == 147711 and self:checkTankDistance(args.sourceGUID, 60) then
		warnCurseVenom:Show()
		specWarnCurseVenom:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_dskd.mp3")--毒蛇快打
	elseif args.spellId == 147705 then
		if args:IsPlayer() and self:AntiSpam(2, 1) then
			specWarnPoisonCloud:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
		end
	elseif args.spellId == 146765 then
		if args:IsPlayer() and self:AntiSpam(2, 2) then
			specWarnFlameArrow:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args.spellId == 147029 then--Tank debuff version
		local amount = args.amount or 1
		warnFlamesofGalakrond:Show(args.destName, amount)
		timerFlamesofGalakrond:Start(args.destName)
		if amount >= 3 then
			if args:IsPlayer() then
				specWarnFlamesofGalakrondTank:Show(amount)
			else
				specWarnFlamesofGalakrondOther:Show(args.destName)
			end
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 147068 then
		if self.Options.FixateIcon then
			self:SetIcon(args.destName, 0)
		end
	elseif args.spellId == 147029 then--Tank debuff version
		timerFlamesofGalakrond:Cancel(args.destName)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 147705 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnPoisonCloud:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	elseif spellId == 146765 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnFlameArrow:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, destName, _, _, spellId)
	if spellId == 146764 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
	--	specWarnFlameArrow:Show()
	elseif spellId == 146872 and destGUID == UnitGUID("player") and self:AntiSpam(2, 3) then
		specWarnShadowAttack:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 72249 then--Main Boss ID
		DBM:EndCombat(self)
	elseif cid == 72355 then--High Enforcer Thranok
		timerShatteringCleaveCD:Cancel()
		timerCrushersCallCD:Cancel()
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 147825 then--Muzzle Spray::0:147825
		warnMuzzleSpray:Show()
		specWarnMuzzleSpray:Show()
	elseif spellId == 50630 then--Eject All Passengers:
		timerAddsCD:Cancel()
		warnPhase2:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ptwo.mp3") -- 2階段
		drcount = 0
		timerFlamesofGalakrondCD:Start(18.6)--TODO, verify consistency since this timing may depend on where drake lands and time it takes to get picked up.
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.newForces1 or msg == L.newForces2 or msg == L.newForces3 or msg == L.newForces4 then
		self:SendSync("Adds")
	end
end

--"<167.7 21:23:40> [CHAT_MSG_RAID_BOSS_EMOTE] CHAT_MSG_RAID_BOSS_EMOTE#Warlord Zaela orders a |cFFFF0404|hKor'kron Demolisher|h|r to assault the tower!
function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find("cFFFF0404") then--They fixed epiccenter bug (figured they would). Color code should be usuable though. It's only emote on encounter that uses it.
		demoCount = demoCount + 1
		warnDemolisher:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_tscd.mp3") --投石车快打
		if demoCount == 1 then
			timerAddsCD:Start(90)
		elseif demoCount == 2 then
			timerAddsCD:Start(34)
		end
	elseif msg == L.tower or msg:find(L.tower) then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_ptkf.mp3") --炮塔攻破
	end
end

function mod:OnSync(msg)
	if msg == "Adds" and self:AntiSpam(15, 3) then
		addsCount = addsCount + 1
		if addsCount == 1 then
			timerAddsCD:Start(45)
		elseif addsCount == 2 then
			timerTowerCD:Start()
		elseif addsCount == 3 then--This is also a tower so probably don't need redundant emote
			timerDemolisherCD:Start()
		elseif addsCount == 4 then
			timerTowerCD:Start()
		elseif addsCount == 5 then--This is also a tower
			timerDemolisherCD:Start()
		elseif addsCount >= 6 then
			timerAddsCD:Start()
		end
	end
end

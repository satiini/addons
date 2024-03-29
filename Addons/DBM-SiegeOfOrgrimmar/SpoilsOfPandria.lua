local mod	= DBM:NewMod(870, "DBM-SiegeOfOrgrimmar", nil, 369)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 10247 $"):sub(12, -3))
mod:SetCreatureID(73720, 71512)
mod:SetZone()

--Can use IEEU to engage now, it's about 4 seconds slower but better than registering an out of combat CLEU event in entire zone.
--"<10.8 23:23:13> [CLEU] SPELL_CAST_SUCCESS#false#0xF13118D10000674F#Secured Stockpile of Pandaren Spoils#2632#0##nil#-2147483648#-2147483648#145687#Unstable Defense Systems#1", -- [169]
--"<14.2 23:23:16> [INSTANCE_ENCOUNTER_ENGAGE_UNIT] Fake Args:#1#1#Mogu Spoils#0xF1311FF800006750#elite#1#1#1#Mantid Spoils#0xF131175800006752
mod:RegisterCombat("combat")
mod:RegisterKill("yell", L.Victory)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SWING_DAMAGE",
	"SWING_MISSED",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL"
)

local warnSuperNova				= mod:NewCastAnnounce(146815, 4)--Heroic
--Massive Crate of Goods
local warnReturnToStone			= mod:NewSpellAnnounce(145489, 2)
local warnSetToBlow				= mod:NewTargetAnnounce(145987, 4)--145996 is cast ID
--Stout Crate of Goods
local warnForbiddenMagic		= mod:NewTargetAnnounce(145230, 2)
local warnMatterScramble		= mod:NewSpellAnnounce(145288, 3)
local warnCrimsonRecon			= mod:NewCastAnnounce(142947, 4)
local warnEnergize				= mod:NewSpellAnnounce(145461, 3)--May be script spellid that doesn't show in combat log
local warnTorment				= mod:NewSpellAnnounce(142934, 3, nil, mod:IsHealer())
local warnMantidSwarm			= mod:NewSpellAnnounce(142539, 3, nil, mod:IsTank())
local warnResidue				= mod:NewCastAnnounce(145786, 4, nil, nil, mod:IsMagicDispeller())
local warnRageoftheEmpress		= mod:NewCastAnnounce(145812, 4, nil, nil, mod:IsMagicDispeller())
local warnWindStorm				= mod:NewSpellAnnounce(145816, 3)--Stunable?
--Lightweight Crate of Goods
local warnHardenFlesh			= mod:NewSpellAnnounce(144922, 2, nil, false)
local warnEarthenShard			= mod:NewSpellAnnounce(144923, 2, nil, false)
local warnSparkofLife			= mod:NewSpellAnnounce(142694, 3, nil, false)
local warnBlazingCharge			= mod:NewTargetAnnounce(145712, 3)
local warnEnrage				= mod:NewTargetAnnounce(145692, 3, nil, mod:IsTank() or mod:CanRemoveEnrage())--Do not have timer for this yet, add not alive long enough.
--Crate of Pandaren Relics
local warnBreathofFire			= mod:NewSpellAnnounce(146222, 3)--Do not have timer for this yet, add not alive long enough.
local warnGustingCraneKick		= mod:NewSpellAnnounce(146180, 3)
local warnPathofBlossoms		= mod:NewTargetAnnounce(146256, 3)

local specWarnSuperNova			= mod:NewSpecialWarningSpell(146815, nil, nil, nil, 2)
--Massive Crate of Goods
local specWarnSetToBlowYou		= mod:NewSpecialWarningYou(145987)
local specWarnSetToBlow			= mod:NewSpecialWarningPreWarn(145996, nil, 4, nil, 3)
--Stout Crate of Goods
local specWarnForbiddenMagic	= mod:NewSpecialWarningInterrupt(145230, mod:IsMelee())
local specWarnMatterScramble	= mod:NewSpecialWarningSpell(145288, nil, nil, nil, 2)
local specWarnCrimsonRecon		= mod:NewSpecialWarningMove(142947, mod:IsTank())
local specWarnTorment			= mod:NewSpecialWarningSpell(142934, mod:IsHealer())
local specWarnMantidSwarm		= mod:NewSpecialWarningSpell(142539, mod:IsTank())
local specWarnResidue			= mod:NewSpecialWarningSpell(145786, mod:IsMagicDispeller())
local specWarnRageoftheEmpress	= mod:NewSpecialWarningSpell(145812, mod:IsMagicDispeller())
--Lightweight Crate of Goods
local specWarnHardenFlesh		= mod:NewSpecialWarningInterrupt(144922, false)
local specWarnEarthenShard		= mod:NewSpecialWarningInterrupt(144923, false)
local specWarnEnrage			= mod:NewSpecialWarningDispel(145692, mod:CanRemoveEnrage())--Question is, do we want to dispel it? might make this off by default since kiting it may be more desired than dispeling it
local specWarnBlazingCharge		= mod:NewSpecialWarningMove(145716)
local specWarnBubblingAmber		= mod:NewSpecialWarningMove(145748)
local specWarnPathOfBlossoms	= mod:NewSpecialWarningMove(146257)
--Crate of Pandaren Relics
local specWarnGustingCraneKick	= mod:NewSpecialWarningSpell(146180, nil, nil, nil, 2)

local timerSuperNova			= mod:NewCastTimer(10, 146815)
local timerArmageddonCD			= mod:NewCastTimer(270, 145864, (GetSpellInfo(20479)))--145864 will never fly as timer text, it's like bajillion characters long. use 20479 for timertext
--Massive Crate of Goods
local timerReturnToStoneCD		= mod:NewNextTimer(12, 145489)
local timerSetToBlowCD			= mod:NewNextTimer(9.6, 145996)
local timerSetToBlow			= mod:NewBuffFadesTimer(30, 145996)
--Stout Crate of Goods
local timerEnrage				= mod:NewTargetTimer(10, 145692)
local timerMatterScrambleCD		= mod:NewCDTimer(18, 145288)--18-22 sec variation. most of time it's 20 exactly, unsure what causes the +-2 variations
local timerCrimsonReconCD		= mod:NewNextTimer(15, 142947)
local timerMantidSwarmCD		= mod:NewCDTimer(35, 142539)
local timerResidueCD			= mod:NewCDTimer(18, 145786, nil, mod:IsMagicDispeller())
local timerWindstormCD			= mod:NewCDTimer(34, 145816, nil, false)--Spammy but might be useful to some, if they aren't releasing a ton of these at once.
local timerRageoftheEmpressCD	= mod:NewCDTimer(18, 145812, nil, mod:IsMagicDispeller())
--Lightweight Crate of Goods
----Most of these timers are included simply because of how accurate they are. Predictable next timers. However, MANY of these adds up at once.
----They are off by default and a user elected choice to possibly pick one specific timer they are in charge of dispeling/interrupting or whatever
local timerHardenFleshCD		= mod:NewNextTimer(8, 144922, nil, false)
local timerEarthenShardCD		= mod:NewNextTimer(10, 144923, nil, false)
local timerBlazingChargeCD		= mod:NewNextTimer(12, 145712, nil, false)
--Crate of Pandaren Relics
local timerGustingCraneKickCD	= mod:NewCDTimer(18, 146180)
local timerPathOfBlossomsCD		= mod:NewCDTimer(15, 146253)

--local countdownSetToBlow		= mod:NewCountdownFades(29, 145996)
local countdownArmageddon		= mod:NewCountdown(270, 145864, nil, nil, nil, nil, true)

--mod:AddBoolOption("InfoFrame")
mod:AddBoolOption("Filterarea", true, "sound")

local activeBossGUIDS = {}
local setToBlowTargets = {}
local bossDamageTarget = {}

local function checkTankDistance(guid)
	local uId, _
	if mod.Options.Filterarea then
		uId = bossDamageTarget[guid]
	else
		_, uId = mod:GetBossTarget(guid)
	end
	if uId then
		local inRange, checkedRange = UnitInRange(uId)
		if checkedRange then
			return inRange
		else
			return true
		end
	end
	return false
end

local function warnspecmob(guid)
	if not checkTankDistance(guid) then return end
	local cid = mod:GetCIDFromGUID(guid)
	if cid == 71382 then
		if mod:IsDps() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_hpkd.mp3") --花瓶快打
		end
	elseif cid == 71395 then
		if mod:IsDps() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_mxkd.mp3") --魔像快打
		else
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_mxcx.mp3") --魔像出现
		end
	elseif cid == 71385 then
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_tdsd.mp3") --投彈手快打
	end
end

local function warnSetToBlowTargets()
	warnSetToBlow:Show(table.concat(setToBlowTargets, "<, >"))
	table.wipe(setToBlowTargets)
end

function mod:BlazingChargeTarget(targetname)
	if not targetname then
		print("DBM DEBUG: BlazingChargeTarget Scan failed")
		return
	end
	warnBlazingCharge:Show(targetname)
end

function mod:PathofBlossomsTarget(targetname)
	if not targetname then
		print("DBM DEBUG: PathofBlossomsTarget Scan failed")
		return
	end
	warnPathofBlossoms:Show(targetname)
end

local function hideRangeFrame()
	if mod.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:OnCombatStart(delay)
	table.wipe(activeBossGUIDS)
	table.wipe(setToBlowTargets)
	if self:IsDifficulty("lfr25") then
		timerArmageddonCD:Start(297.5-delay)
		countdownArmageddon:Start(297.5-delay)
	else
		timerArmageddonCD:Start(267.5-delay)--May variate by 1 second, my world state stata is showing osmetimes it's 167 and somtimes it's 168 when IEEU fires. may have to just do shitty world state stuff to make it more accurate
		countdownArmageddon:Start(267.5-delay)
	end
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 145996 and checkTankDistance(args.sourceGUID) then
		timerSetToBlowCD:Start(args.sourceGUID)
	elseif args.spellId == 145288 and checkTankDistance(args.sourceGUID) then
		warnMatterScramble:Show()
		specWarnMatterScramble:Show()
		timerMatterScrambleCD:Start(args.sourceGUID)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\stepring.mp3") --注意踩圈
	elseif args.spellId == 145461 and checkTankDistance(args.sourceGUID) then
		warnEnergize:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_llfw.mp3") --力量符文
	elseif args.spellId == 142934 and checkTankDistance(args.sourceGUID) then
		warnTorment:Show()
		specWarnTorment:Show()
		if mod:IsHealer() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_zmcx.mp3") --折磨出現
		end
	elseif args.spellId == 142539 and checkTankDistance(args.sourceGUID) then
		warnMantidSwarm:Show()
		specWarnMantidSwarm:Show()
		timerMantidSwarmCD:Start(args.sourceGUID)
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_zhcq.mp3") --召喚蟲群
		end
	elseif args.spellId == 145816 and checkTankDistance(args.sourceGUID) then
		warnWindStorm:Show()
		timerWindstormCD:Start(args.sourceGUID)
	elseif args.spellId == 144922 and checkTankDistance(args.sourceGUID) then
		local source = args.sourceName
		warnHardenFlesh:Show()
		timerHardenFleshCD:Start(args.sourceGUID)
		if source == UnitName("target") or source == UnitName("focus") then 
			specWarnHardenFlesh:Show(source)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\kickcast.mp3") --快打斷
		end
	elseif args.spellId == 144923 and checkTankDistance(args.sourceGUID) then
		local source = args.sourceName
		warnEarthenShard:Show()
		timerEarthenShardCD:Start(args.sourceGUID)
		if source == UnitName("target") or source == UnitName("focus") then 
			specWarnEarthenShard:Show(source)
		end
	elseif args.spellId == 146222 and checkTankDistance(args.sourceGUID) then
		warnBreathofFire:Show()
	elseif args.spellId == 146180 and checkTankDistance(args.sourceGUID) then
		warnGustingCraneKick:Show()
		specWarnGustingCraneKick:Show()
		timerGustingCraneKickCD:Start(args.sourceGUID)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_so_xft.mp3") --旋風準備
	elseif args.spellId == 145489 and checkTankDistance(args.sourceGUID) then
		warnReturnToStone:Show()
		timerReturnToStoneCD:Start(args.sourceGUID)
	elseif args.spellId == 142947 and checkTankDistance(args.sourceGUID) then--Pre warn more or less
		warnCrimsonRecon:Show()
	elseif args.spellId == 146815 then
		warnSuperNova:Show()
		specWarnSuperNova:Show()
		timerSuperNova:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 142694 and checkTankDistance(args.sourceGUID) then
		warnSparkofLife:Show()
--		specWarnSparkofLife:Show()
	elseif args.spellId == 142947 and checkTankDistance(args.sourceGUID) then
		specWarnCrimsonRecon:Show()--Done here because we want to warn when we need to move mobs, not on cast start (when we can do nothing)
		timerCrimsonReconCD:Start(args.sourceGUID)
		if mod:IsTank() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\bossout.mp3") --拉開BOSS
		end
	elseif args.spellId == 145712 and checkTankDistance(args.sourceGUID) then
		timerBlazingChargeCD:Start(args.sourceGUID)
		self:BossTargetScanner(args.sourceGUID, "BlazingChargeTarget", 0.025, 12)
	elseif args.spellId == 146253 and checkTankDistance(args.sourceGUID) then
		timerPathOfBlossomsCD:Start(args.sourceGUID)
		self:BossTargetScanner(args.sourceGUID, "PathofBlossomsTarget", 0.025, 12)
	elseif args.spellId == 145230 and checkTankDistance(args.sourceGUID) then
		local source = args.sourceName
		warnForbiddenMagic:Show(args.destName)
		if source == UnitName("target") or source == UnitName("focus") then 
			specWarnForbiddenMagic:Show(source)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\kickcast.mp3") --快打斷
		end
	elseif args.spellId == 145786 and checkTankDistance(args.sourceGUID) then
		warnResidue:Show()
		timerResidueCD:Start(args.sourceGUID)
		specWarnResidue:Show()
		if mod:IsMagicDispeller() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\dispelnow.mp3") --快驅散
		end
	elseif args.spellId == 145812 and checkTankDistance(args.sourceGUID) then
		warnRageoftheEmpress:Show()
		specWarnRageoftheEmpress:Show()
		timerRageoftheEmpressCD:Start(args.sourceGUID)
		if mod:IsMagicDispeller() then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\dispelnow.mp3") --快驅散
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 145987 and checkTankDistance(args.sourceGUID) then
		setToBlowTargets[#setToBlowTargets + 1] = args.destName
		self:Unschedule(warnSetToBlowTargets)
		self:Schedule(0.5, warnSetToBlowTargets)
		if args:IsPlayer() then
			specWarnSetToBlowYou:Show()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runout.mp3") --離開人群
--			countdownSetToBlow:Start()
			timerSetToBlow:Start()
			specWarnSetToBlow:Schedule(26)
			sndWOP:Schedule(26, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\bombnow.mp3") --準備爆炸
			sndWOP:Schedule(27, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
			sndWOP:Schedule(28, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
			sndWOP:Schedule(29, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)--Range assumed, spell tooltips not informative enough
				self:Schedule(32, hideRangeFrame)
			end
		end
	elseif args.spellId == 145692 and checkTankDistance(args.sourceGUID) then
		warnEnrage:Show(args.destName)
		specWarnEnrage:Show(args.destName)
		timerEnrage:Start(args.destName)
		if mod:IsTank() or mod:CanRemoveEnrage() then
			local source = args.sourceName
			if (source == UnitName("target") or source == UnitName("focus")) and mod:IsTank() then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\enrage.mp3") -- 激怒
			elseif mod:CanRemoveEnrage() then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\trannow.mp3") -- 注意寧神
			end
		end
	elseif args.spellId == 145998 and checkTankDistance(args.sourceGUID) then--This is a massive crate mogu spawning
		timerReturnToStoneCD:Start(6)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 145987 and args:IsPlayer() then
--		countdownSetToBlow:Cancel()
		timerSetToBlow:Cancel()
		specWarnSetToBlow:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\bombnow.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
	elseif args.spellId == 145692 then
		timerEnrage:Cancel(args.destName)
	end
end

function mod:SPELL_DAMAGE(sourceGUID, sourceName, _, _, destGUID, destName, _, _, spellId)
	if spellId == 145716 and destGUID == UnitGUID("player") and self:AntiSpam(2, 1) then
		specWarnBlazingCharge:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	elseif spellId == 145748 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnBubblingAmber:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	elseif spellId == 146257 and destGUID == UnitGUID("player") and self:AntiSpam(2, 3) then
		specWarnPathOfBlossoms:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3") --快躲開
	end
	if self.Options.Filterarea then
		if (not bossDamageTarget[sourceGUID]) then
			local uId = DBM:GetRaidUnitId(destName)
			if uId then
				bossDamageTarget[sourceGUID] = uId
				warnspecmob(sourceGUID)
			end
		end
		if (not bossDamageTarget[destGUID]) then
			local uId = DBM:GetRaidUnitId(sourceName)
			if uId then
				bossDamageTarget[destGUID] = uId
				warnspecmob(destGUID)
			end
		end
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SWING_DAMAGE(sourceGUID, sourceName, _, _, destGUID, destName)
	if self.Options.Filterarea then
		if (not bossDamageTarget[sourceGUID]) then
			local uId = DBM:GetRaidUnitId(destName)
			if uId then
				bossDamageTarget[sourceGUID] = uId
				warnspecmob(sourceGUID)
			end
		end
		if (not bossDamageTarget[destGUID]) then
			local uId = DBM:GetRaidUnitId(sourceName)
			if uId then
				bossDamageTarget[destGUID] = uId
				warnspecmob(destGUID)
			end
		end
	end
end
mod.SWING_MISSED = mod.SWING_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 71408 then--Shao-Tien Colossus
		timerReturnToStoneCD:Cancel(args.destGUID)
	elseif cid == 71409 then--Ka'thik Demolisher
		timerSetToBlowCD:Cancel(args.destGUID)
	elseif cid == 71395 then--Modified Anima Golem
		timerMatterScrambleCD:Cancel(args.destGUID)
		timerCrimsonReconCD:Cancel(args.destGUID)
	elseif cid == 71397 then--Ka'thik Swarmleader
		timerMantidSwarmCD:Cancel(args.destGUID)
		timerResidueCD:Cancel(args.destGUID)
	elseif cid == 71405 then--Ka'thik Wind Wielder
		timerWindstormCD:Cancel(args.destGUID)
		timerRageoftheEmpressCD:Cancel(args.destGUID)
	elseif cid == 71380 then--Animated Stone Mogu
		timerHardenFleshCD:Cancel(args.destGUID)
		timerEarthenShardCD:Cancel(args.destGUID)
	elseif cid == 71385 then--Ka'thik Bombardier
		timerBlazingChargeCD:Cancel(args.destGUID)
	elseif cid == 72810 then--Wise Mistweaver Spirit
		timerGustingCraneKickCD:Cancel(args.destGUID)
	elseif cid == 72828 then--Nameless Windwalker Spirit
		timerPathOfBlossomsCD:Cancel(args.destGUID)
	end
end

--[[
"<270.3 23:27:32> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#Module 1's all prepared for system reset.#Secured Stockpile of Pandaren Spoils###Omegal
"<270.3 23:27:33> [WORLD_STATE_UI_TIMER_UPDATE] |0#0#true#Defense systems activating in 17 seconds.###Time remaining until the GB-11010 \"Armageddon\"-class defense systems activate.###0#0#0", -- [49218]
"<270.4 23:27:33> [UPDATE_WORLD_STATES] |0#0#true#Defense systems activating in 286 seconds.###Time remaining until the GB-11010 \"Armageddon\"-class defense systems activate.###0#0#0", -- [49221]
----------------
"<283.7 22:31:28> [WORLD_STATE_UI_TIMER_UPDATE] |0#0#false#Defense systems activating in 2 seconds.###Time remaining until the GB-11010 \"Armageddon\"-class defense systems activate.###0#0#0", -- [45259]
"<283.7 22:31:28> [CHAT_MSG_MONSTER_YELL] CHAT_MSG_MONSTER_YELL#Module 1's all prepared for system reset.#Secured Stockpile of Pandaren Spoils###Daltin##0#0##0#31#nil#0#false#false", -- [45267]
"<284.7 22:31:29> [UPDATE_WORLD_STATES] |0#0#false#Defense systems activating in 271 seconds.###Time remaining until the GB-11010 \"Armageddon\"-class defense systems activate.###0#0#0", -- [45333]
--]]
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Module1 or msg:find(L.Module1) then
		local elapsed, total = timerArmageddonCD:GetTime()
		local remaining = total - elapsed
		countdownArmageddon:Cancel()
		if self:IsDifficulty("lfr25") then
			timerArmageddonCD:Start(300+remaining)
			countdownArmageddon:Start(300+remaining)
		else
			timerArmageddonCD:Start(270+remaining)
			countdownArmageddon:Start(270+remaining)
		end
	end
end

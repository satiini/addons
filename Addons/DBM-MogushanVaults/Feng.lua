﻿local mod	= DBM:NewMod(689, "DBM-MogushanVaults", nil, 317)
local L		= mod:GetLocalizedStrings()
local sndWOP	= mod:NewSound(nil, "SoundWOP", true)
local sndWOPD	= mod:NewSound(nil, "SoundWOP", true)

mod:SetRevision(("$Revision: 9663 $"):sub(12, -3))
mod:SetCreatureID(60009)--60781 Soul Fragment
mod:SetZone()
mod:SetUsedIcons(8, 7, 6)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_SPELLCAST_STOP boss1",
	"UNIT_SPELLCAST_CHANNEL_STOP boss1"
)
--Phase order is controlled by players. it is only pre determined order in LFR and LFR only.
--Heroic a player can do ANY phase first. It even says this in encounter journal.
--on normal, it lets you choose nature or fire first but it will not allow arcane first.
--none the less, the player can still control it on normal, just not to degree of heroic. The EJ says it's random on normal but it's not.

local warnPhase						= mod:NewAnnounce("WarnPhase", 1, "Interface\\Icons\\Spell_Nature_WispSplode")
--Nature/Fist
local warnLightningLash				= mod:NewStackAnnounce(131788, 3, nil, mod:IsTank())
local warnLightningFists			= mod:NewSpellAnnounce(116157, 3)
local warnEpicenter					= mod:NewCountAnnounce(116018, 4)

--Fire/Spear
local warnFlamingSpear				= mod:NewStackAnnounce(116942, 3, nil, mod:IsTank())
local warnWildSpark					= mod:NewTargetCountAnnounce(116784, 4)
local yellWildSpark					= mod:NewYell(116784)
local warnDrawFlame					= mod:NewCountAnnounce(116711, 4)
local warnWildfireInfusion			= mod:NewStackAnnounce(116821, 3, nil, mod:IsHealer())

--Arcane/Staff
local warnArcaneShock				= mod:NewStackAnnounce(131790, 3, nil, mod:IsTank())
local warnArcaneResonance			= mod:NewTargetAnnounce(116417, 4)
local warnArcaneVelocity			= mod:NewCountAnnounce(116364, 4)

--Shadow/Shield (Heroic Only)
local warnShadowBurn				= mod:NewStackAnnounce(131792, 3, nil, mod:IsTank())
local warnChainsOfShadow			= mod:NewSpellAnnounce(118783, 2, nil, false)
local warnSiphoningShield			= mod:NewCountAnnounce(117203, 4)

--Tank Abilities
local warnReversalLightningFists	= mod:NewTargetAnnounce(118302, 2)--this spell can interrupt Epicenter, so needs to warn.
local warnNullBarrior				= mod:NewSpellAnnounce(115817, 2)

--Nature/Fist
local specWarnLightningLash			= mod:NewSpecialWarningStack(131788, mod:IsTank(), 2)
local specWarnLightningLashOther	= mod:NewSpecialWarningTarget(131788, mod:IsTank())
local specWarnEpicenter				= mod:NewSpecialWarning("specWarnEpicenter")

--Fire/Spear
local specWarnFlamingSpear			= mod:NewSpecialWarningStack(116942, mod:IsTank(), 2)
local specWarnFlamingSpearOther		= mod:NewSpecialWarningTarget(116942, mod:IsTank())
local specWarnWildSpark				= mod:NewSpecialWarningYou(116784)
local specWarnWildfire				= mod:NewSpecialWarningMove(116793)
local specWarnDrawFlame				= mod:NewSpecialWarning("specWarnDrawFlame")

--Arcane/Staff
local specWarnArcaneShock			= mod:NewSpecialWarningStack(131790, mod:IsTank(), 2)
local specWarnArcaneShockOther		= mod:NewSpecialWarningTarget(131790, mod:IsTank())
local specWarnArcaneResonance		= mod:NewSpecialWarningYou(116417)
local yellArcaneResonance			= mod:NewYell(116417)
local specWarnArcaneVelocity		= mod:NewSpecialWarning("specWarnArcaneVelocity")

--Shadow/Shield (Heroic Only)
local specWarnShadowBurn			= mod:NewSpecialWarningStack(131792, mod:IsTank(), 2)
local specWarnShadowBurnOther		= mod:NewSpecialWarningTarget(131792, mod:IsTank())
local specWarnSiphoningShield		= mod:NewSpecialWarning("specWarnSiphoningShield")

--Tank Abilities
local specWarnNullBarrior			= mod:NewSpecialWarningSpell(115817) -- Null Barrier is important all members, espcially Earth and Arcane Phase.

--Nature/Fist
local timerLightningLash			= mod:NewTargetTimer(20, 131788, nil, mod:IsTank())
local timerLightningLashCD			= mod:NewCDTimer(9, 131788, nil, mod:IsTank())--9-20 second variation.
local timerLightningFistsCD			= mod:NewCDTimer(14, 116157)
local timerEpicenterCD				= mod:NewCDCountTimer(30, 116018)
local timerEpicenter				= mod:NewBuffActiveTimer(10, 116018)

--Fire/Spear
local timerFlamingSpear				= mod:NewTargetTimer(20, 116942, nil, mod:IsTank())
local timerFlamingSpearCD			= mod:NewCDTimer(9, 116942, nil, mod:IsTank())--8-11second variation, usually 10 though.
local timerWildSpark				= mod:NewTargetTimer(5, 116784)
local timerDrawFlame				= mod:NewBuffActiveTimer(6, 116711)
local timerDrawFlameCD				= mod:NewNextCountTimer(30, 116711)--30 seconds after last ended.

--Arcane/Staff
local timerArcaneShock				= mod:NewTargetTimer(20, 131790, nil, mod:IsTank())
local timerArcaneShockCD			= mod:NewCDTimer(9, 131790, nil, mod:IsTank())--not comfirmed
local timerArcaneResonanceCD		= mod:NewCDTimer(15.5, 116417)
local timerArcaneVelocityCD			= mod:NewCDCountTimer(18, 116364)--18 seconds after last ended.
local timerArcaneVelocity			= mod:NewBuffActiveTimer(8, 116364)

--Shadow/Shield (Heroic Only)
local timerShadowBurn				= mod:NewTargetTimer(20, 131792, nil, mod:IsTank())
local timerShadowBurnCD				= mod:NewCDTimer(9, 131792, nil, mod:IsTank())
local timerChainsOfShadowCD			= mod:NewCDTimer(6, 118783, nil, false)--6-10sec variation noted
local timerSiphoningShieldCD		= mod:NewCDCountTimer(35, 117203)--35-38sec variation noted

--Tank Abilities
local timerReversalLightningFists	= mod:NewBuffFadesTimer(20, 118302)
local timerNullBarrior				= mod:NewBuffFadesTimer(6, 115817)
local timerNullBarriorCD			= mod:NewCDTimer(55, 115817)


--local soundEpicenter				= mod:NewSound(116018)

mod:AddBoolOption("SetIconOnWS", true)
mod:AddBoolOption("SetIconOnAR", true)
mod:AddBoolOption("RangeFrame", mod:IsRanged())

local phase = 0
local arIcon = 8
local wildfireCount = 0
local sparkCount = 0
local fragmentCount = 5
local specialCount = 0
local arcaneResonanceTargets = {}

local AVPlayer = false
local AVend = false
mod:AddBoolOption("InfoFrame", not mod:IsDps(), "sound")

mod:AddBoolOption("HudMAP", true, "sound")
mod:AddBoolOption("HudMAP2", true, "sound")
mod:AddBoolOption("HudMAP3", true, "sound")
local DBMHudMap = DBMHudMap
local free = DBMHudMap.free
local function register(e)	
	DBMHudMap:RegisterEncounterMarker(e)
	return e
end
local WildSparkPrisonMarkers = {}
local arcaneResonanceMarkers = {}
local NullBarriorMarkers = {}

local function warnWildfire()
	warnWildfireInfusion:Cancel()
	warnWildfireInfusion:Schedule(1, L.name, wildfireCount)
end

local function warnArcaneResonanceTargets()
	warnArcaneResonance:Show(table.concat(arcaneResonanceTargets, "<, >"))
	table.wipe(arcaneResonanceTargets)
end

function mod:OnCombatStart(delay)
	phase = 0
	arIcon = 8
	wildfireCount = 0
	sparkCount = 0
	specialCount = 0
	table.wipe(arcaneResonanceTargets)
	table.wipe(WildSparkPrisonMarkers)
	table.wipe(arcaneResonanceMarkers)
	table.wipe(NullBarriorMarkers)
	AVPlayer = false
	AVend = false
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.HudMAP or self.Options.HudMAP2 or self.Options.HudMAP3 then
		DBMHudMap:FreeEncounterMarkers()
	end
end
function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(131788) then
		warnLightningLash:Show(args.destName, 1)
		timerLightningLash:Start(args.destName)
		timerLightningLashCD:Start()
		if mod.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(131788))
			DBM.InfoFrame:Show(3, "playerdebuffstackstime", 131788)
		end
	elseif args:IsSpellID(116942) then
		warnFlamingSpear:Show(args.destName, 1)
		timerFlamingSpear:Start(args.destName)
		timerFlamingSpearCD:Start()
		if mod.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(116942))
			DBM.InfoFrame:Show(3, "playerdebuffstackstime", 116942)
		end
	elseif args:IsSpellID(131790) then
		warnArcaneShock:Show(args.destName, 1)
		timerArcaneShock:Start(args.destName)
		timerArcaneShockCD:Start()
		if mod.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(131790))
			DBM.InfoFrame:Show(3, "playerdebuffstackstime", 131790)
		end
	elseif args:IsSpellID(131792) then
		warnShadowBurn:Show(args.destName, 1)
		timerShadowBurn:Start(args.destName)
		timerShadowBurnCD:Start()
		if mod.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(GetSpellInfo(131792))
			DBM.InfoFrame:Show(3, "playerdebuffstackstime", 131792)
		end
	elseif args:IsSpellID(118302) then
		warnReversalLightningFists:Show(args.destName)
		timerReversalLightningFists:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_nzlt.mp3") --逆轉雷霆
	elseif args:IsSpellID(116784) then
		sparkCount = sparkCount + 1
		warnWildSpark:Show(sparkCount, args.destName)
		timerWildSpark:Start(args.destName)
		if self.Options.SetIconOnWS then
			self:SetIcon(args.destName, 8, 5)
		end
		if args:IsPlayer() then
			specWarnWildSpark:Show()
			yellWildSpark:Yell()
			DBM.Flash:Shake(1, 0, 0)
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\firerun.mp3") --火焰點你
			sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countfour.mp3")
			sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
			sndWOP:Schedule(3.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
			sndWOP:Schedule(4.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
		end
		if self.Options.HudMAP then
			local spelltext = GetSpellInfo(116784)
			WildSparkPrisonMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("targeting", args.destName, 3, 6, 1, 0 ,0 ,0.8):SetLabel(spelltext))
		end
	elseif args:IsSpellID(116711) then
		sparkCount = 0
		specialCount = specialCount + 1
		warnDrawFlame:Show(specialCount)
		timerDrawFlame:Start()
		specWarnDrawFlame:Show(specialCount)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_qyhy.mp3") --牽引火焰
	elseif args:IsSpellID(116821) then
		wildfireCount = 1
		warnWildfire()
	elseif args:IsSpellID(116417) then
		arcaneResonanceTargets[#arcaneResonanceTargets + 1] = args.destName
		if self.Options.SetIconOnAR then
			self:SetIcon(args.destName, arIcon)
			arIcon = arIcon - 1
		end
		self:Unschedule(warnArcaneResonanceTargets)
		self:Schedule(0.3, warnArcaneResonanceTargets)
		if args:IsPlayer() then
			specWarnArcaneResonance:Show()
			yellArcaneResonance:Yell()
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runout.mp3") --離開人群
			AVPlayer = true
		end
		if self.Options.HudMAP2 then
			if args:IsPlayer() then
				arcaneResonanceMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", args.destName, 8, nil, 0, 1, 0, 0.4):Appear():RegisterForAlerts():Rotate(360, 14))
			else
				arcaneResonanceMarkers[args.destName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("timer", args.destName, 8, nil, 0, 1, 0, 0.8):Appear():RegisterForAlerts():Rotate(360, 14))
			end
		end
	elseif args:IsSpellID(116364) then
		specialCount = specialCount + 1
		warnArcaneVelocity:Show(specialCount)
		specWarnArcaneVelocity:Show(specialCount)
		timerArcaneVelocity:Start()
		if not AVPlayer then
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\gather.mp3")--快集合
			sndWOP:Schedule(6, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\scattersoon.mp3")--注意分散
		else
			sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_mfdd.mp3")--秘法動蕩
		end
		AVend = true
		self:Schedule(2, function() AVend = false end)
	end
end

-- split Flaming Spear (Arcane Resonance also uses SPELL_AURA_APPLIED_DOSE, buggy)
function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(131788) then
		warnLightningLash:Show(args.destName, args.amount or 1)
		timerLightningLash:Start(args.destName)
		timerLightningLashCD:Start()
		if args:IsPlayer() and (args.amount or 1) >= 2 then
			specWarnLightningLash:Show(args.amount)
		else
			if (args.amount or 1) >= 2 and not UnitIsDeadOrGhost("player") or not UnitDebuff("player", GetSpellInfo(131788)) then
				specWarnLightningLashOther:Show(args.destName)
			end
		end
	elseif args:IsSpellID(116942) then
		warnFlamingSpear:Show(args.destName, args.amount or 1)
		timerFlamingSpear:Start(args.destName)
		timerFlamingSpearCD:Start()
		if args:IsPlayer() and (args.amount or 1) >= 2 then
			specWarnFlamingSpear:Show(args.amount)
		else
			if (args.amount or 1) >= 2 and not UnitIsDeadOrGhost("player") or not UnitDebuff("player", GetSpellInfo(116942)) then
				specWarnFlamingSpearOther:Show(args.destName)
			end
		end
	elseif args:IsSpellID(131790) then
		warnArcaneShock:Show(args.destName, args.amount or 1)
		timerArcaneShock:Start(args.destName)
		timerArcaneShockCD:Start()
		if args:IsPlayer() and (args.amount or 1) >= 2 then
			specWarnArcaneShock:Show(args.amount)
		else
			if (args.amount or 1) >= 2 and not UnitIsDeadOrGhost("player") or not UnitDebuff("player", GetSpellInfo(131790)) then
				specWarnArcaneShockOther:Show(args.destName)
			end
		end
	elseif args:IsSpellID(131792) then
		warnShadowBurn:Show(args.destName, args.amount or 1)
		timerShadowBurn:Start(args.destName)
		timerShadowBurnCD:Start()
		if args:IsPlayer() and (args.amount or 1) >= 2 then
			specWarnShadowBurn:Show(args.amount)
		else
			if (args.amount or 1) >= 2 and not UnitIsDeadOrGhost("player") or not UnitDebuff("player", GetSpellInfo(131792)) then
				specWarnShadowBurnOther:Show(args.destName)
			end
		end
	elseif args:IsSpellID(116821) then
		wildfireCount = args.amount or 1
		warnWildfire()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(131788) then
		timerLightningLash:Cancel(args.destName)
	elseif args:IsSpellID(116942) then
		timerFlamingSpear:Cancel(args.destName)
	elseif args:IsSpellID(131790) then
		timerArcaneShock:Cancel(args.destName)
	elseif args:IsSpellID(131792) then
		timerShadowBurn:Cancel(args.destName)
	elseif args:IsSpellID(118302) then
		timerReversalLightningFists:Cancel()
	elseif args:IsSpellID(116018) then
		timerEpicenter:Cancel()--Epicenter can be removed by Lightning Fists (tank can steal). So added remove stuff.
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countfour.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
	elseif args:IsSpellID(116784) then
		timerWildSpark:Cancel(args.destName)
		if args:IsPlayer() then
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countfour.mp3")
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
			sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
		end
		if WildSparkPrisonMarkers[args.destName] then
			WildSparkPrisonMarkers[args.destName] = free(WildSparkPrisonMarkers[args.destName])
		end
	elseif args:IsSpellID(116711) then
		timerDrawFlameCD:Start(nil, specialCount + 1)
	elseif args:IsSpellID(116417) then
		if self.Options.SetIconOnAR then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() then
			AVPlayer = false
			if AVend then
				sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\gather.mp3")--快集合
				sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\scattersoon.mp3")--注意分散
			end
		end
		if arcaneResonanceMarkers[args.destName] then
			arcaneResonanceMarkers[args.destName] = free(arcaneResonanceMarkers[args.destName])
		end
	elseif args:IsSpellID(116364) then
		timerArcaneVelocity:Cancel()
		timerArcaneVelocityCD:Start(nil, specialCount + 1)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(116018) then
		specialCount = specialCount + 1
		warnEpicenter:Show(specialCount)
		specWarnEpicenter:Show(specialCount)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_yldz.mp3") --遠離地震
--		soundEpicenter:Play()
		timerEpicenter:Start()
		sndWOPD:Schedule(6.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countfour.mp3")
		sndWOPD:Schedule(7.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOPD:Schedule(8.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOPD:Schedule(9.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
		timerEpicenterCD:Start(nil, specialCount + 1)
	elseif args:IsSpellID(116157, 116295) then
		warnLightningFists:Show()
		timerLightningFistsCD:Start()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_zydb.mp3") --注意電波
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(118783) then
		warnChainsOfShadow:Show()
		timerChainsOfShadowCD:Start()
	elseif args:IsSpellID(115817) then
		warnNullBarrior:Show()
		specWarnNullBarrior:Show()
		local spelltext = GetSpellInfo(115817)
		if self.Options.HudMAP3 then
			NullBarriorMarkers[args.sourceName] = register(DBMHudMap:PlaceRangeMarkerOnPartyMember("highlight", args.sourceName, 5, 5, 0, 1, 0, 0.8):RegisterForAlerts(true, spelltext))
		end
		timerNullBarrior:Start()
		if self:IsDifficulty("lfr25") then
			timerNullBarriorCD:Start(25)
		else
			timerNullBarriorCD:Start()
		end
	elseif args:IsSpellID(116417) then
		arIcon = 8
		timerArcaneResonanceCD:Start()
	end
end

function mod:SPELL_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId)
	if spellId == 116793 and destGUID == UnitGUID("player") and self:AntiSpam(3, 3) then
		specWarnWildfire:Show()
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\runaway.mp3")--快躲開
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Nature or msg:find(L.Nature) then
		self:SendSync("Earth")
	elseif msg == L.Fire or msg:find(L.Fire) then
		self:SendSync("Flame")
	elseif msg == L.Arcane or msg:find(L.Arcane) then
		self:SendSync("Purple")
	elseif msg == L.Shadow or msg:find(L.Shadow) then
		self:SendSync("Dark")
	end
end

function mod:OnSync(msg)
	if msg == "Earth" then
		phase = phase + 1
		warnPhase:Show(phase)
		timerLightningLashCD:Start(7)
		timerLightningFistsCD:Start(12)
		timerEpicenterCD:Start(18, 1)--It's either this, or this +10. Not yet sure what causes the +10
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_zrxt.mp3") --自然形态
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif msg == "Flame" then
		phase = phase + 1
		warnPhase:Show(phase)
		timerFlamingSpearCD:Start(5.5)
		timerDrawFlameCD:Start(35, 1)--No variation, or not enough logs of fire phase.
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_hyxt.mp3") --火焰形态
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	elseif msg == "Purple" then
		phase = phase + 1
		warnPhase:Show(phase)
		timerArcaneShockCD:Start(7)
		-- 10/13 01:11:24.437  YELL: Oh sage of the ages! Instill to me your arcane wisdom!
		-- 10/13 01:11:36.671  SPELL_CAST_SUCCESS,0xF150EA690000478E,"",0x10a48,0x0,0x0000000000000000,nil,0x80000000,0x80000000,116417,"",0x40
		timerArcaneResonanceCD:Start(12)
		timerArcaneVelocityCD:Start(14.5, 1)--It's either this, or this +10. Not yet sure what causes the +10
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_mfxt.mp3") --秘法形态
		if self.Options.RangeFrame then
			DBM.RangeCheck:Show(8)
		end
	elseif msg == "Dark" then
		phase = phase + 1
		warnPhase:Show(phase)
		timerSiphoningShieldCD:Start(4, 1)--either this, or this +5. Not yet sure what causes the +5
		timerChainsOfShadowCD:Start(6)
		timerShadowBurnCD:Start(9)--9-11 variation
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_ayxt.mp3") --暗影形態
		if self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, _, _, spellId)
	if spellId == 117203 and self:AntiSpam(2, 1) then--Siphoning Shield
		specialCount = specialCount + 1
		warnSiphoningShield:Show(specialCount)
		specWarnSiphoningShield:Show(specialCount)
		timerSiphoningShieldCD:Start(nil, specialCount + 1)
		sndWOP:Play("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\ex_mop_yldp.mp3") --遠離盾牌
		sndWOP:Schedule(1.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countfour.mp3")
		sndWOP:Schedule(2.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOP:Schedule(3.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOP:Schedule(4.5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
		sndWOP:Schedule(5, "Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\killspirit.mp3") --靈魂快打
	elseif spellId == 121631 and self:AntiSpam(2, 2) then--Draw Essence.
		--Best place to cancel timers, vs duplicating cancel code in all 4 yells above.
		specialCount = 0
		timerFlamingSpearCD:Cancel()
		timerDrawFlameCD:Cancel()
		timerArcaneShockCD:Cancel()
		timerArcaneResonanceCD:Cancel()
		timerArcaneVelocityCD:Cancel()
		timerLightningLashCD:Cancel()
		timerLightningFistsCD:Cancel()
		timerEpicenterCD:Cancel()
		timerShadowBurnCD:Cancel()
		timerSiphoningShieldCD:Cancel()
		timerChainsOfShadowCD:Cancel()
		sndWOP:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\scattersoon.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countfour.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
	end
end

function mod:UNIT_SPELLCAST_STOP(uId, _, _, _, spellId)
	if spellId == 116018 then
		timerEpicenter:Cancel()
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countfour.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countthree.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\counttwo.mp3")
		sndWOPD:Cancel("Interface\\AddOns\\DBM-Core\\extrasounds\\"..DBM.Options.CountdownVoice.."\\countone.mp3")
	end
end
mod.UNIT_SPELLCAST_CHANNEL_STOP = mod.UNIT_SPELLCAST_STOP
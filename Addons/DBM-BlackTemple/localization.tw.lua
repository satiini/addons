if GetLocale() ~= "zhTW" then return end
local L

-----------------
--  Najentus  --
-----------------
L = DBM:GetModLocalization("Najentus")

L:SetGeneralLocalization{
	name = "高階督軍納珍塔斯"
}

L:SetOptionLocalization{
	InfoFrame	= "為血量顯示訊息框架(小於8.8千血量)"
}

L:SetMiscLocalization{
	HealthInfo	= "血量資訊"
}

----------------
-- Supremus --
----------------
L = DBM:GetModLocalization("Supremus")

L:SetGeneralLocalization{
	name = "瑟普莫斯"
}

L:SetWarningLocalization{
	WarnPhase		= "%s階段",
	WarnKite		= ">%s<被注視了"
}

L:SetTimerLocalization{
	TimerPhase		= "下一次%s階段"
}

L:SetOptionLocalization{
	WarnPhase		= "為下個階段顯示警告",
	WarnKite		= "提示注視目標",
	TimerPhase		= "為下個階段顯示計時器",
	KiteIcon		= "為注視目標設置圖示",
}

L:SetMiscLocalization{
	PhaseKite		= "瑟普莫斯憤怒的捶擊地面!",
	PhaseTank		= "地上開始裂開!",
	ChangeTarget	= "瑟普莫斯需要一個新目標!",
	Kite			= "風箏",
	Tank			= "坦克"
}

-------------------------
--  Shape of Akama  --
-------------------------
L = DBM:GetModLocalization("Akama")

L:SetGeneralLocalization{
	name = "阿卡瑪的黑暗面"
}

-------------------------
--  Teron Gorefiend  --
-------------------------
L = DBM:GetModLocalization("TeronGorefiend")

L:SetGeneralLocalization{
	name = "泰朗·血魔"
}

L:SetTimerLocalization{
	TimerVengefulSpirit	= "鬼魂:%s"
}

L:SetOptionLocalization{
	TimerVengefulSpirit	= "為鬼魂持續時間顯示計時器"
}

----------------------------
--  Gurtogg Bloodboil  --
----------------------------
L = DBM:GetModLocalization("Bloodboil")

L:SetGeneralLocalization{
	name = "葛塔格·血沸"
}

--------------------------
--  Essence Of Souls  --
--------------------------
L = DBM:GetModLocalization("Souls")

L:SetGeneralLocalization{
	name = "靈魂聖匣"
}

L:SetWarningLocalization{
	WarnMana		= "30秒後法力用盡"
}

L:SetTimerLocalization{
	TimerMana		= "法力耗盡"
}

L:SetOptionLocalization{
	WarnMana		= "在第二階段耗盡法力顯示警告",
	TimerMana		= "在第二階段法力耗盡顯示計時器"
}

L:SetMiscLocalization{
	Pull			= "等待你們的只有痛苦與折磨﹗",
	Suffering		= "受難精華",
	Desire			= "慾望精華",
	Anger			= "憤怒精華"
}

-----------------------
--  Mother Shahraz --
-----------------------
L = DBM:GetModLocalization("Shahraz")

L:SetGeneralLocalization{
	name = "薩拉茲女士"
}

L:SetTimerLocalization{
	timerAura	= "%s"
}

L:SetOptionLocalization{
	timerAura	= "Show timer for Prismatic Aura"
}

----------------------
--  Illidari Council  --
----------------------
L = DBM:GetModLocalization("Council")

L:SetGeneralLocalization{
	name = "伊利達瑞議會"
}

L:SetWarningLocalization{
	Immune			= "瑪蘭黛 - %s免疫15秒"
}

L:SetOptionLocalization{
	Immune			= "當瑪蘭黛法術或物理免疫時顯示警告",
	PoisonWhisper	= "傳送密語給中了$spell:41485的目標(需要團隊隊長)"
}

L:SetMiscLocalization{
	Gathios			= "粉碎者高希歐",
	Malande			= "瑪蘭黛女士",
	Zerevor			= "高等虛空術師札瑞佛",
	Veras			= "維拉斯·深影",
	Melee			= "物理",
	Spell			= "法術",
}

-------------------------
--  Illidan Stormrage --
-------------------------
L = DBM:GetModLocalization("Illidan")

L:SetGeneralLocalization{
	name = "伊利丹·怒風"
}

L:SetWarningLocalization{
	WarnHuman		= "人形階段即將到來",
	WarnDemon		= "惡魔階段"
}

L:SetTimerLocalization{
	TimerNextHuman		= "人形階段",
	TimerNextDemon		= "惡魔階段",
	TimerPhase4			= "階段轉換"
}

L:SetOptionLocalization{
	WarnHuman		= "為人形階段顯示警告",
	WarnDemon		= "為惡魔階段顯示計時器",
	TimerNextHuman	= "為下一次人形階段顯示計時器",
	TimerNextDemon	= "為下一次惡魔階段顯示計時器",
	TimerPhase4		= "為第4階段轉換顯示計時器",
	RangeFrame		= "為第3第4階段顯示距離框架(10碼)"
}

L:SetMiscLocalization{
	Pull			= "阿卡瑪。你的謊言真是老套。我很久前就應該殺了你和你那些畸形的同胞。",
	Eyebeam			= "直視背叛者的雙眼吧!",
	Demon			= "感受我體內的惡魔之力吧!",
	Phase4			= "你們就這點本事嗎?這就是你們全部的能耐?"
}

if GetLocale() ~= "koKR" then return end
local L

-----------
--  Alar --
-----------
L = DBM:GetModLocalization("Alar")

L:SetGeneralLocalization{
	name = "알라르"
}

L:SetTimerLocalization{
	NextPlatform	= "단상 머무름"
}

L:SetOptionLocalization{
	NextPlatform	= "단상 머무름 바 보기(더 빨리 떠날수는 있으나 더 늦게 떠나진 않습니다.)"
}

------------------
--  Void Reaver --
------------------
L = DBM:GetModLocalization("VoidReaver")

L:SetGeneralLocalization{
	name = "공허의 절단기"
}

--------------------------------
--  High Astromancer Solarian --
--------------------------------
L = DBM:GetModLocalization("Solarian")

L:SetGeneralLocalization{
	name = "고위 점성술사 솔라리안"
}

L:SetWarningLocalization{
	WarnSplit		= "분리",
	WarnSplitSoon	= "곧 분리",
	WarnAgent		= "요원 등장",
	WarnPriest		= "사제/솔라리안 등장",

}

L:SetTimerLocalization{
	TimerSplit		= "다음 분리",
	TimerAgent		= "다음 요원",
	TimerPriest		= "다음 사제/솔라리안"
}

L:SetOptionLocalization{
	WarnSplit		= "분리 알림 보기",
	WarnSplitSoon	= "분리 이전에 알림 보기",
	WarnAgent		= "요원 등장 알림 보기",
	WarnPriest		= "사제/솔라리안 등장 알림 보기",
	TimerSplit		= "다음 분리 바 보기",
	TimerAgent		= "다음 요원 바 보기",
	TimerPriest		= "다음 사제/솔라리안 바 보기",
	WrathWhisper	= "$spell:42783 대상에게 귓속말 보내기"
}

L:SetMiscLocalization{
	WrathWhisper	= "당신에게 분노!",
	YellSplit1		= "그 오만한 콧대를 꺾어주마!",
	YellSplit2		= "한 줌의 희망마저 짓밟아주마!",
	YellPhase2		= "나는 공허의"
}

---------------------------
--  Kael'thas Sunstrider --
---------------------------
L = DBM:GetModLocalization("KaelThas")

L:SetGeneralLocalization{
	name = "캘타스 선스트라이더"
}

L:SetWarningLocalization{
	WarnGaze		= "추적: >%s<",
	WarnMobDead		= "%s 처치",
	WarnEgg			= "불사조 알 생성",
	SpecWarnGaze	= "당신을 추적 - 도망치세요!",
	SpecWarnEgg		= "불사조 알 생성 - 대상 전환!"
}

L:SetTimerLocalization{
	TimerPhase		= "다음 단계",
	TimerPhase1mob	= "%s",
	TimerNextGaze	= "추적 대상 변경",
	TimerRebirth	= "불사조 환생 가능"
}

L:SetOptionLocalization{
	WarnGaze		= "탈라드레드 추적 대상 알림 보기",
	WarnMobDead		= "무기 처치 알림 보기",
	WarnEgg			= "불사조 알 생성 알림 보기",
	SpecWarnGaze	= "탈라드레드 추적 대상이 된 경우 특수 경고 보기",
	SpecWarnEgg		= "불사조 알 생성 특수 경고 보기",
	TimerPhase		= "다음 단계 바 보기",
	TimerPhase1mob	= "1단계 조언가 등장 바 보기",
	TimerNextGaze	= "탈라드레드 추적 대상 변경 바 보기",
	TimerRebirth	= "불사조 알 환생 가능 바 보기",
	RangeFrame		= "거리 창 보기",
	GazeWhisper		= "탈라드레드 추적 대상에게 귓속말 보내기",
	GazeIcon		= "탈라드레드 추적 대상에게 전술 목표 아이콘 설정"
}

L:SetMiscLocalization{
	YellPull1	= "나의 백성은 에너지와 마력에 중독됐지. 태양샘이 파괴되자 지독한 금단 현상이 발생했다. 미래에 온 것을... 환영하노라. 중단하기에는 이미 늦었다. 이제 아무도 날 막지 못해! 셀라마 아샬라노레!",
	YellPhase2	= "보다시피 내 무기고에는 굉장한 무기가 아주 많지.",
	YellPhase3	= "네놈들을 과소평가했나 보군. 모두를 한꺼번에 상대하라는 건 불공평한 처사지만, 나의 백성도 공평한 대접을 받은 적 없기는 매한가지. 받은 대로 돌려주겠다.",
	YellPhase4	= "때론 직접 나서야 할 때도 있는 법이지. 발라모어 샤날!",
	YellPhase5	= "이대로 물러날 내가 아니다! 반드시 내가 설계한 미래를 실현하리라! 이제 진정한 힘을 느껴 보아라!",
	YellSang	= "최고의 조언가를 상대로 잘도 버텨냈군. 허나 그 누구도 붉은 망치의 힘에는 대항할 수 없지. 보아라, 군주 생귀나르를!",
	YellCaper	= "카퍼니안, 놈들이 여기 온 것을 후회하게 해 줘라.",
	YellTelo	= "좋아, 그 정도 실력이면 수석기술자 텔로니쿠스를 상대해 볼만하겠어.",
	EmoteGaze	= "노려봅니다!",
	GazeWhisper	= "당신에게 추적!",
	Thaladred	= "암흑의 인도자 탈라드레드",
	Sanguinar	= "군주 생귀나르",
	Capernian	= "대점성술사 카퍼니안",
	Telonicus	= "수석기술자 텔로니쿠스",
	Bow			= "황천매듭 장궁",
	Axe			= "참상의 도끼",
	Mace		= "우주 에너지 주입기(둔기)",
	Dagger		= "무한의 비수(단검)",
	Sword		= "차원 절단기(도검)",
	Shield		= "위상 변화의 보루 방패",
	Staff		= "붕괴의 지팡이",
	Egg			= "불사조 알"
}

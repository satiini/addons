local S, L, DB, _, C = unpack(select(2, ...))

local r, g, b = DB.MyClassColor.r, DB.MyClassColor.g, DB.MyClassColor.b
local AuroraConfig = DB.AuroraConfig

tinsert(DB.AuroraModules["SunUI"], function()
	-- Achievement alert
	local function fixBg(f)
		if f:GetObjectType() == "AnimationGroup" then
			f = f:GetParent()
		end
		f.bg:SetBackdropColor(0, 0, 0, AuroraConfig.alpha)
	end

	hooksecurefunc("AlertFrame_FixAnchors", function()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["AchievementAlertFrame"..i]

			if frame then
				frame:SetAlpha(1)
				frame.SetAlpha = S.dummy

				local ic = _G["AchievementAlertFrame"..i.."Icon"]
				local texture = _G["AchievementAlertFrame"..i.."IconTexture"]
				local guildName = _G["AchievementAlertFrame"..i.."GuildName"]

				ic:ClearAllPoints()
				ic:Point("LEFT", frame, "LEFT", -26, 0)

				if not frame.bg then
					frame.bg = CreateFrame("Frame", nil, frame)
					frame.bg:SetPoint("TOPLEFT", texture, -10, 12)
					frame.bg:Point("BOTTOMRIGHT", texture, "BOTTOMRIGHT", 240, -12)
					frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
					S.CreateBD(frame.bg)

					frame:HookScript("OnEnter", fixBg)
					frame:HookScript("OnShow", fixBg)
					frame.animIn:HookScript("OnFinished", fixBg)
					S.CreateBD(frame.bg)

					S.CreateBG(texture)

					_G["AchievementAlertFrame"..i.."Background"]:Hide()
					_G["AchievementAlertFrame"..i.."IconOverlay"]:Hide()
					_G["AchievementAlertFrame"..i.."GuildBanner"]:SetTexture("")
					_G["AchievementAlertFrame"..i.."GuildBorder"]:SetTexture("")
					_G["AchievementAlertFrame"..i.."OldAchievement"]:SetTexture("")

					guildName:ClearAllPoints()
					guildName:Point("TOPLEFT", 50, -14)
					guildName:Point("TOPRIGHT", -50, -14)

					_G["AchievementAlertFrame"..i.."Unlocked"]:SetTextColor(1, 1, 1)
					_G["AchievementAlertFrame"..i.."Unlocked"]:SetShadowOffset(1, -1)
				end

				frame.glow:Hide()
				frame.shine:Hide()
				frame.glow.Show = S.dummy
				frame.shine.Show = S.dummy

				texture:SetTexCoord(.08, .92, .08, .92)

				if guildName:IsShown() then
					_G["AchievementAlertFrame"..i.."Shield"]:Point("TOPRIGHT", -10, -22)
				end
			end
		end
	end)

	-- Guild challenges

	local challenge = CreateFrame("Frame", nil, GuildChallengeAlertFrame)
	challenge:Point("TOPLEFT", 8, -12)
	challenge:Point("BOTTOMRIGHT", -8, 13)
	challenge:SetFrameLevel(GuildChallengeAlertFrame:GetFrameLevel()-1)
	S.CreateBD(challenge)
	S.CreateBG(GuildChallengeAlertFrameEmblemBackground)

	GuildChallengeAlertFrameGlow:SetTexture("")
	GuildChallengeAlertFrameShine:SetTexture("")
	GuildChallengeAlertFrameEmblemBorder:SetTexture("")

	-- Dungeon completion rewards

	local bg = CreateFrame("Frame", nil, DungeonCompletionAlertFrame1)
	bg:Point("TOPLEFT", 6, -14)
	bg:Point("BOTTOMRIGHT", -6, 6)
	bg:SetFrameLevel(DungeonCompletionAlertFrame1:GetFrameLevel()-1)
	S.CreateBD(bg)

	DungeonCompletionAlertFrame1DungeonTexture:SetDrawLayer("ARTWORK")
	DungeonCompletionAlertFrame1DungeonTexture:SetTexCoord(.02, .98, .02, .98)
	S.CreateBG(DungeonCompletionAlertFrame1DungeonTexture)

	DungeonCompletionAlertFrame1.dungeonArt1:SetAlpha(0)
	DungeonCompletionAlertFrame1.dungeonArt2:SetAlpha(0)
	DungeonCompletionAlertFrame1.dungeonArt3:SetAlpha(0)
	DungeonCompletionAlertFrame1.dungeonArt4:SetAlpha(0)
	DungeonCompletionAlertFrame1.raidArt:SetAlpha(0)

	DungeonCompletionAlertFrame1.dungeonTexture:Point("BOTTOMLEFT", DungeonCompletionAlertFrame1, "BOTTOMLEFT", 13, 13)
	DungeonCompletionAlertFrame1.dungeonTexture.SetPoint = S.dummy

	DungeonCompletionAlertFrame1.shine:Hide()
	DungeonCompletionAlertFrame1.shine.Show = S.dummy
	DungeonCompletionAlertFrame1.glow:Hide()
	DungeonCompletionAlertFrame1.glow.Show = S.dummy

	hooksecurefunc("DungeonCompletionAlertFrame_ShowAlert", function()
		local bu = DungeonCompletionAlertFrame1Reward1
		local index = 1

		while bu do
			if not bu.styled then
				_G["DungeonCompletionAlertFrame1Reward"..index.."Border"]:Hide()

				bu.texture:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(bu.texture)

				bu.styled = true
			end

			index = index + 1
			bu = _G["DungeonCompletionAlertFrame1Reward"..index]
		end
	end)

	-- Challenge popup

	hooksecurefunc("AlertFrame_SetChallengeModeAnchors", function()
		local frame = ChallengeModeAlertFrame1

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = S.dummy

			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", ChallengeModeAlertFrame1DungeonTexture, -12, 12)
				frame.bg:SetPoint("BOTTOMRIGHT", ChallengeModeAlertFrame1DungeonTexture, 243, -12)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				S.CreateBD(frame.bg)

				frame:HookScript("OnEnter", fixBg)
				frame:HookScript("OnShow", fixBg)
				frame.animIn:HookScript("OnFinished", fixBg)

				S.CreateBG(ChallengeModeAlertFrame1DungeonTexture)
			end

			frame:GetRegions():Hide()

			ChallengeModeAlertFrame1Shine:Hide()
			ChallengeModeAlertFrame1Shine.Show = S.dummy
			ChallengeModeAlertFrame1GlowFrame:Hide()
			ChallengeModeAlertFrame1GlowFrame.Show = S.dummy
			ChallengeModeAlertFrame1Border:Hide()
			ChallengeModeAlertFrame1Border.Show = S.dummy

			ChallengeModeAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	-- Scenario alert

	hooksecurefunc("AlertFrame_SetScenarioAnchors", function()
		local frame = ScenarioAlertFrame1

		if frame then
			frame:SetAlpha(1)
			frame.SetAlpha = S.dummy

			if not frame.bg then
				frame.bg = CreateFrame("Frame", nil, frame)
				frame.bg:SetPoint("TOPLEFT", ScenarioAlertFrame1DungeonTexture, -12, 12)
				frame.bg:SetPoint("BOTTOMRIGHT", ScenarioAlertFrame1DungeonTexture, 244, -12)
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				S.CreateBD(frame.bg)

				frame:HookScript("OnEnter", fixBg)
				frame:HookScript("OnShow", fixBg)
				frame.animIn:HookScript("OnFinished", fixBg)

				S.CreateBG(ScenarioAlertFrame1DungeonTexture)
				ScenarioAlertFrame1DungeonTexture:SetDrawLayer("OVERLAY")
			end

			frame:GetRegions():Hide()
			select(3, frame:GetRegions()):Hide()

			ScenarioAlertFrame1Shine:Hide()
			ScenarioAlertFrame1Shine.Show = S.dummy
			ScenarioAlertFrame1GlowFrame:Hide()
			ScenarioAlertFrame1GlowFrame.Show = S.dummy

			ScenarioAlertFrame1DungeonTexture:SetTexCoord(.08, .92, .08, .92)
		end
	end)

	hooksecurefunc("ScenarioAlertFrame_ShowAlert", function()
		local bu = ScenarioAlertFrame1Reward1
		local index = 1

		while bu do
			if not bu.styled then
				_G["ScenarioAlertFrame1Reward"..index.."Border"]:Hide()

				bu.texture:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(bu.texture)

				bu.styled = true
			end

			index = index + 1
			bu = _G["ScenarioAlertFrame1Reward"..index]
		end
	end)

	-- Loot won alert

	-- I still don't know why I can't parent bg to frame
	local function showHideBg(self)
		self.bg:SetShown(self:IsShown())
	end

	local function onUpdate(self)
		self.bg:SetAlpha(self:GetAlpha())
	end

	hooksecurefunc("LootWonAlertFrame_SetUp", function(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, UIParent)
			frame.bg:SetPoint("TOPLEFT", frame, 10, -10)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, -10, 10)
			frame.bg:SetFrameStrata("DIALOG")
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			frame.bg:SetShown(frame:IsShown())
			S.CreateBD(frame.bg)

			frame:HookScript("OnShow", showHideBg)
			frame:HookScript("OnHide", showHideBg)
			frame:HookScript("OnUpdate", onUpdate)

			frame.Background:Hide()
			frame.IconBorder:Hide()
			frame.glow:SetTexture("")
			frame.shine:SetTexture("")

			frame.Icon:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(frame.Icon)
		end
	end)

	-- Money won alert

	hooksecurefunc("MoneyWonAlertFrame_SetUp", function(frame)
		if not frame.bg then
			frame.bg = CreateFrame("Frame", nil, UIParent)
			frame.bg:SetPoint("TOPLEFT", frame, 10, -10)
			frame.bg:SetPoint("BOTTOMRIGHT", frame, -10, 10)
			frame.bg:SetFrameStrata("DIALOG")
			frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
			frame.bg:SetShown(frame:IsShown())
			S.CreateBD(frame.bg)

			frame:HookScript("OnShow", showHideBg)
			frame:HookScript("OnHide", showHideBg)
			frame:HookScript("OnUpdate", onUpdate)

			frame.Background:Hide()
			frame.IconBorder:Hide()

			frame.Icon:SetTexCoord(.08, .92, .08, .92)
			S.CreateBG(frame.Icon)
		end
	end)

	-- Criteria alert

	hooksecurefunc("CriteriaAlertFrame_ShowAlert", function()
		for i = 1, MAX_ACHIEVEMENT_ALERTS do
			local frame = _G["CriteriaAlertFrame"..i]
			if frame and not frame.bg then
				local icon = _G["CriteriaAlertFrame"..i.."IconTexture"]

				frame.bg = CreateFrame("Frame", nil, UIParent)
				frame.bg:SetPoint("TOPLEFT", icon, -6, 5)
				frame.bg:SetPoint("BOTTOMRIGHT", icon, 236, -5)
				frame.bg:SetFrameStrata("DIALOG")
				frame.bg:SetFrameLevel(frame:GetFrameLevel()-1)
				frame.bg:SetShown(frame:IsShown())
				S.CreateBD(frame.bg)

				frame:SetScript("OnShow", showHideBg)
				frame:SetScript("OnHide", showHideBg)
				frame:HookScript("OnUpdate", onUpdate)

				_G["CriteriaAlertFrame"..i.."Background"]:Hide()
				_G["CriteriaAlertFrame"..i.."IconOverlay"]:Hide()
				frame.glow:Hide()
				frame.glow.Show = S.dummy
				frame.shine:Hide()
				frame.shine.Show = S.dummy

				_G["CriteriaAlertFrame"..i.."Unlocked"]:SetTextColor(.9, .9, .9)

				icon:SetTexCoord(.08, .92, .08, .92)
				S.CreateBG(icon)
			end
		end
	end)

	-- Digsite completion alert

	do
		local frame = DigsiteCompleteToastFrame
		local icon = frame.DigsiteTypeTexture

		S.CreateBD(DigsiteCompleteToastFrame)

		frame:GetRegions():Hide()

		frame.glow:Hide()
		frame.glow.Show = S.dummy
		frame.shine:Hide()
		frame.shine.Show = S.dummy
	end
end)
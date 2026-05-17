-- Client Only
local MonsterUtils = require "Utils.MonsterUtils"
local GameFlowUtils = require "Utils.GameFlowUtils"
local Component = { }

function Component:Initialize()
	--{MonsterID}
	self.FirstSeen = {}
	--{MonsterID, {MonsterRef}
	--self.MonstersNeedCheck = {}
	self.NextMonsterPanel = {}
	--self.MonsterFirstSeenEnabled = true
end

-- function Component:TryRegisterFirstSeen(UnitId, Eid)
-- 	if not DataMgr.Monster[UnitId] then
-- 		return
-- 	end
	
-- 	local UnitGuideId = DataMgr.Monster[UnitId].GuideId
-- 	local IsFirstMonster = false
-- 	local Description = MonsterUtils.GetDescription(UnitId)
-- 	if Description then
-- 		IsFirstMonster = true
-- 	end
-- 	UnitId = Description or UnitId
-- 	if not UnitId and not UnitGuideId then
-- 		return
-- 	end
-- 	local Start, End = string.find(UnitId, "%d+", 1)
-- 	UnitId = tonumber(string.sub(UnitId, Start, End))

-- 	local Avatar = GWorld:GetAvatar()
-- 	if not Avatar then
-- 		return
-- 	end
-- 	local RetIsFirstMonster = Avatar:CheckFirstMonster(UnitId, false)
-- 	local RetIsFirstStrongMonster = Avatar:CheckStrongGuideFirstMonster(UnitGuideId, false)
-- 	IsFirstMonster = IsFirstMonster and RetIsFirstMonster and RetIsFirstStrongMonster
-- 	local IsFirstStrongMonster = UnitGuideId and RetIsFirstStrongMonster
-- 	local IsFindInMonstersNeedCheck = self.MonstersNeedCheck:FindRef(UnitId)
-- 	if not IsFirstMonster and not IsFirstStrongMonster and not IsFindInMonstersNeedCheck then
-- 		return
-- 	end

-- 	local Monster = Battle(self):GetEntity(Eid)
-- 	if not Monster then
-- 		return
-- 	end
-- 	local ThisUnitCheckTable = self.MonstersNeedCheck:FindRef(UnitId)
-- 	if ThisUnitCheckTable then
-- 		self:SetMonstersNeedCheck(ThisUnitCheckTable, Monster)
-- 	else
-- 		self:InitMonstersNeedCheck(UnitId, Monster)
-- 	end
-- 	self:CheckStandAloneAndAddTimer()
-- end

function Component:ShowMonsterFirstSeenPanel(UnitId, RealUnitId)
	local UnitGuideId = DataMgr.Monster[RealUnitId].GuideId
	if UnitGuideId then
		self:ShowMonsterStrongPanel(UnitGuideId, UnitId)
		return
	end
	self:ShowCommonPanel(UnitId)
end

function Component:CheckMonsterGalleryRuleId(UnitId)
	local Avatar = GWorld:GetAvatar()
	if not Avatar then return false end
	local MonsterInfo = DataMgr.Monster[UnitId]
	if not MonsterInfo then return false end
	local GalleryRuleId = MonsterInfo.GalleryRuleId
	if not GalleryRuleId then return false end
	for key, value in ipairs(Avatar.FirstMonsters) do
		local Info = DataMgr.Monster[value]
		if Info then
			local Id = Info.GalleryRuleId
			if GalleryRuleId == Id then
				return true
			end
		end
	end
	return false
end

function Component:ShowCommonPanel(UnitId)
	local Monster = DataMgr.Monster[UnitId]
	if not Monster then
		return
	end
	-- if not MonsterUtils.GetDescription(UnitId) then
	-- 	return
	-- end
	if not Monster.GalleryRuleId then
		return
	end
	if DataMgr.GalleryRule[Monster.GalleryRuleId].DisableArchive then
		return
	end
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	if not GameInstance then
		return
	end
    local UIManger = GameInstance:GetGameUIManager()
	if not UIManger then
		return
	end
	local Avatar = GWorld:GetAvatar()
	if not Avatar then
		return
	end
	if not Avatar:CheckFirstMonster(Monster.GalleryRuleId, true) then
		return
	end
	local IsInEditor = false
	if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GameInstance) then
		IsInEditor = true
	else
		IsInEditor = false
	end
	local NewMonsterPanel = UIManger:GetUIObj("CommonNewMonster")
	if not NewMonsterPanel then
		print(_G.LogTag, "Showing Monster First Seen Panel" .. tostring(UnitId))
		if IsInEditor then
			UIManger:LoadUINew("CommonNewMonster", UnitId)
		else
			UIManger:LoadUIAsync("CommonNewMonster",function()end, UnitId)
		end
		
	else
		print(_G.LogTag, "Showing Monster Next Seen Panel" .. tostring(UnitId))
		self.NextMonsterPanel[#self.NextMonsterPanel + 1] = UnitId
		
	end
	-- local SurvivalPanel = UIManger:GetUIObj("DungenonSurviveFloat")
	-- if not SurvivalPanel then
	-- 	return
	-- end
	-- SurvivalPanel.bShouldContinueAnim = true
	-- SurvivalPanel:PlayAnimationUntilStop("prompt02")
end

function Component:ShowNextMonsterPanel()
	if #self.NextMonsterPanel == 0 then
		return true
	end
	local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
	if not GameInstance then
		return true
	end
	local UIManger = GameInstance:GetGameUIManager()
	if not UIManger then
		return true
	end
	local UnitId = self.NextMonsterPanel[1]
	table.remove(self.NextMonsterPanel, 1)
	local NewMonsterPanel = UIManger:GetUIObj("CommonNewMonster")
	if not NewMonsterPanel then
		print(_G.LogTag,"Showing Next Monster Panel " .. tostring(UnitId))
		
		if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GameInstance) then
			UIManger:LoadUINew("CommonNewMonster", UnitId)
		else
			UIManger:LoadUIAsync("CommonNewMonster",function()end, UnitId)
		end
	else

	end
	return false
end

function Component:ShowMonsterStrongPanel(UnitGuideId, UnitId)
	local ChildGuideUIInfo = DataMgr.UIGuide[UnitGuideId]
	if not ChildGuideUIInfo then
		return
	end
	
	local Avatar = GWorld:GetAvatar()
	local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
	if DungeonId and Avatar.Dungeons[DungeonId] and Avatar.Dungeons[DungeonId].AutoProgress > 0 then
		return
	end
	Avatar:CheckStrongGuideFirstMonster(UnitGuideId, true)
	GameFlowUtils:AddFlow("GuideMain", {
		GWorld.GameInstance, function(_, Flow)
			local UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(self, UnitGuideId)
			UIStateAsyncActionBase.OnGuideEnd:Add(self, function ()
				-- local bShow = self:CheckMonsterGalleryRuleId(UnitId)
				-- local MonsterInfo = DataMgr.Monster[UnitId]
				-- local GalleryRuleId = MonsterInfo.GalleryRuleId
				-- local DisableArchive = DataMgr.GalleryRule[GalleryRuleId].DisableArchive

				-- if not bShow and not DisableArchive then
				-- end
				self:ShowCommonPanel(UnitId)
				GameFlowUtils:RemoveFlow(Flow)
			end)
		end
	})
	-- local UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(self, UnitGuideId)
	-- local OnGuideEnded = function ()
	-- 	self:ShowCommonPanel(UnitId)
	-- end
	-- UIStateAsyncActionBase.OnGuideEnd:Add(self, OnGuideEnded)
end


return Component
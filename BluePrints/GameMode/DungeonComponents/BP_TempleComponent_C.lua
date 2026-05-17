require "UnLua"
local LuaConst = require("EMLuaConst")

local BP_TempleComponent_C = Class({
	"BluePrints.Common.TimerMgr",
})

--------------------GameMode 流程&事件相关------------------------

-- function BP_TempleComponent_C:InitTempleComponent()
-- 	-- 神庙此函数禁止调用
-- end

function BP_TempleComponent_C:InitTempleBaseInfo()
	self.GameMode = self:GetOwner().LevelGameMode
	self.TempleData = DataMgr.Temple[self.GameMode.DungeonId]
	assert(self.TempleData, "TempleComponent: 神庙玩法读表失败，传入的DungeonId: "..tostring(self.GameMode.DungeonId))
	self.SuccessRule = self.TempleData.SucRule

	self.IsNoStarTemple = false
	local RewardId = self.TempleData.RewardId
	if #RewardId == 1 then
		self.IsNoStarTemple = true
	end

	self.StarLevel = 0
	self.Score = 0
	self.Collection = 0

	self.PlayerDeathNum = 0
	self.PlayerDeathMaxNum = 3

	self.PlayerTriggerFallTriggerNum = 0
	self.PlayerTriggerFallTriggerMaxNum = 10

	self.TempleTimeThreshold = -1
	self.ScoreThreshold = -1
	self.CollectionThreshold = -1

	self.GameMode.EMGameState.TempleTime = 0
	self.CurrentStepPlayformEid = 0

	self.FailReason = "QUIT"
	self.CurKey = 0
	self.DelayKeys = {} -- 神庙专用delay计时器的Key合集，后缀用调用时的时间，{计时器Key:{ArchiveID, BreakID, Time(创建时间)}}
	self.CurShowingKey = "" -- 现在适用UI显示的Delay节点

	-- -- 设置附加规则
	-- self:InitTempleFbdRule()
	
	local Avatar = GWorld:GetAvatar()
    if not Avatar then
        error("Avatar is nil")
    end
	self.GameMode.EMGameState.MaxTempleStar = Avatar.Dungeons[self.GameMode.DungeonId].MaxStar
	EventManager:FireEvent(EventID.OnTempleEnter)
	self.OnStageStart:Add(self, self.InterruptByArchiveID)
end

function BP_TempleComponent_C:TriggerTempleOnEnd()
	self:PauseTempleTimer()
	
	-- -- 重置附加规则状态
	-- self:ResetTempleFbdRule()
end

function BP_TempleComponent_C:SetStarLevel(Value)
	DebugPrint("TempleComponent: SetStarLevel:", Value, "DungeonId:", self.GameMode.DungeonId, "SuccRule", self.SuccessRule)
	self.StarLevel = Value
end

function BP_TempleComponent_C:GetStarLevel()
	return self.StarLevel
end

function BP_TempleComponent_C:TempleSucceed()
	if self.IsNoStarTemple then
		self:SetStarLevel(1)
	else
		local StarLevel = 0
		local RatingRange = self.TempleData.RatingRange
		local SuccResult = self:GetSuccResult()
		for _, Rate in pairs(RatingRange) do
			if SuccResult >= Rate then
				StarLevel = StarLevel+1
			end
		end
		self:SetStarLevel(StarLevel)
	end

	self.GameMode:TriggerDungeonWin()
end

function BP_TempleComponent_C:TempleFail()
	self.GameMode:TriggerDungeonFailed()
end

function BP_TempleComponent_C:CustomFinishInfo(AvatarStr)
	return {
		Star = self.StarLevel
	}
end

function BP_TempleComponent_C:GetSuccResult()
	if self.SuccessRule == "CountDown" then
		return self:GetRemainTempleTime()
	elseif self.SuccessRule == "Score" then
		return self:GetScore()
	elseif self.SuccessRule == "Collection" then
		return self:GetCollection()
	elseif self.SuccessRule == "Time" then
		return self:GetTempleTime()
	else
		return 0
	end
end

-------------------------神庙delay节点相关--------------------
function BP_TempleComponent_C:StartTempleDelay(Duration, DelayNode, ArchiveID, BreakID, ShowUI, Title, RedCountdownTime)
	if not self.CurKey and not self.DelayKeys then
		self.CurKey = 0
		self.DelayKeys = {}
	end
	self.CurKey = self.CurKey + 1
	local Key = "TempleDelay_" .. self.CurKey
	local Time = UE4.UGameplayStatics.GetTimeSeconds(self)
	self.DelayKeys[Key] = {ArchiveID, BreakID, Time}
	-- DebugPrint("zwk 启动计时器", Key, ArchiveID, BreakID)
	self:AddTimer(Duration, self.DelayTimerEnd, false, 0, Key, nil, Key, DelayNode, ShowUI)
	DebugPrint("zwk 添加了一个DelayNode ",Key,self:GetName())
	if ShowUI then
		EventManager:FireEvent(EventID.OnTempleDelayStart, Duration, Title, RedCountdownTime)
		self.CurShowingKey = Key
	end
end

function BP_TempleComponent_C:DelayTimerEnd(Key, DelayNode, ShowUI)
	DebugPrint("zwk 执行DelayTimerEnd ",Key,self:GetName())
	if not IsValid(DelayNode) then
		return
	end
	DelayNode:Finished()
	if ShowUI and self.CurShowingKey == Key then
		EventManager:FireEvent(EventID.OnTempleDelayEnd)
		self.CurShowingKey = ""
	end
	self.DelayKeys[Key] = nil
end

-- 打断全部Delay，重开时调用
function BP_TempleComponent_C:InterruptAll()
	for k, _ in pairs(self.DelayKeys) do
		-- DebugPrint("zwk 遍历打断key",k)
		if self.CurShowingKey == k then
			EventManager:FireEvent(EventID.OnTempleDelayEnd)
		end
		self:RemoveTimer(k)
		self.DelayKeys[k] = nil
	end
	DebugPrint("zwk 打断全部Delay完成")
end

-- 根据BreakID打断Delay，蓝图节点主动调用
function BP_TempleComponent_C:InterruptByBreakID(BreakID)
	if BreakID <= 0 then
		return
	end
	local CurTime = UE4.UGameplayStatics.GetTimeSeconds(self)
	for k, v in pairs(self.DelayKeys) do
		if v[2] == BreakID and v[3] < CurTime then
			-- DebugPrint("zwk 主动移除Delay", BreakID, k, v[1], v[2])
			if self.CurShowingKey == k then
				EventManager:FireEvent(EventID.OnTempleDelayEnd)
			end
			self:RemoveTimer(k)
			self.DelayKeys[k] = nil
		end
	end
end

-- 根据Archive阶段打断Delay，在OnStageStart时调用
function BP_TempleComponent_C:InterruptByArchiveID(ArchiveID, UseTimes)
	if ArchiveID <= 0 then
		return
	end
	local CurTime = UE4.UGameplayStatics.GetTimeSeconds(self)
	for k, v in pairs(self.DelayKeys) do
		if v[1] == ArchiveID and v[3] < CurTime then
			-- DebugPrint("zwk 阶段移除Delay", ArchiveID, k, v[1], v[2])
			if self.CurShowingKey == k then
				EventManager:FireEvent(EventID.OnTempleDelayEnd)
			end
			self:RemoveTimer(k)
			self.DelayKeys[k] = nil
		end
	end
	DebugPrint("zwk 根据Archive阶段打断Delay完成")
end
-------------------------神庙delay节点相关--------------------

---------------------通关模式 Time 相关-------------------------

function BP_TempleComponent_C:StartTempleTimer()
	self:AddTimer(1, self.TempleTiming, true, 0, "TempleTimer")
end

function BP_TempleComponent_C:TempleTiming()
	-- 副本结算后禁止定时器逻辑继续跑
	if not self.GameMode.EMGameState:CheckGameModeStateEnable() then
		self:PauseTempleTimer()
		return
	end

	self:AddToTempleTime(1)
	self.GameMode:TriggerGameModeEvent("OnAddingTempleTime")
	DebugPrint("TempleComponent: TempleTime =", self:GetTempleTime())
end

function BP_TempleComponent_C:AddToTempleTime(Value)
	self.GameMode.EMGameState.TempleTime = self.GameMode.EMGameState.TempleTime + Value
	EventManager:FireEvent(EventID.OnTempleTimeChanged, self.GameMode.EMGameState.TempleTime, self.TempleTimeThreshold)
	if IsStandAlone(self) then
		self.GameMode.EMGameState:OnRep_TempleTime()
	end
	if self.GameMode.EMGameState.TempleTime >= self.TempleTimeThreshold then
		self.FailReason = "TIME"
		self.GameMode:TriggerGameModeEvent("OnTempleTimeReachesThreshold")
	end
end

function BP_TempleComponent_C:GetTempleTime()
	return self.GameMode.EMGameState.TempleTime
end

function BP_TempleComponent_C:GetRemainTempleTime()
	return self.TempleTimeThreshold - self.GameMode.EMGameState.TempleTime
end

function BP_TempleComponent_C:StopTempleTimer()
	self:RemoveTimer("TempleTimer")
	self.GameMode.EMGameState.TempleTime = 0
	EventManager:FireEvent(EventID.OnTempleTimeChanged, self.GameMode.EMGameState.TempleTime, self.TempleTimeThreshold)
end

function BP_TempleComponent_C:PauseTempleTimer()
	self:RemoveTimer("TempleTimer")
end

function BP_TempleComponent_C:SetTempleTimeThreshold(Value)
	EventManager:FireEvent(EventID.OnSetTempleLimit, "TIME", Value)
	self.TempleTimeThreshold = Value
end

---------------------通关模式 Score 相关-------------------------

function BP_TempleComponent_C:CheckScoreThreshold()
	if self.Score >= self.ScoreThreshold then
		self.GameMode:TriggerGameModeEvent("OnScoreReachesThreshold")
	end
end

function BP_TempleComponent_C:AddToScore(Value)
	EventManager:FireEvent(EventID.OnTempleScoreCollectChanged, self.Score + Value)
	self.Score = math.max(0, self.Score + Value)
	self.GameMode:TriggerGameModeEvent("OnAddingScore", self.Score)
	self:CheckScoreThreshold()
end

function BP_TempleComponent_C:SetScore(Value)
	EventManager:FireEvent(EventID.OnTempleScoreCollectChanged, Value)
	self.Score = math.max(0, Value)
	self:CheckScoreThreshold()
end

function BP_TempleComponent_C:GetScore()
	return self.Score
end

function BP_TempleComponent_C:SetScoreThreshold(Value)
	self.ScoreThreshold = Value
end

-------------------通关模式 Collection 相关-----------------------

function BP_TempleComponent_C:CheckCollectionThreshold()
	if self.Collection >= self.CollectionThreshold then
		self.GameMode:TriggerGameModeEvent("OnCollectionReachesThreshold")
	end
end

function BP_TempleComponent_C:AddToCollection(Value)
	self.Collection = self.Collection + Value
	EventManager:FireEvent(EventID.OnTempleScoreCollectChanged, self.Collection)
	self.GameMode:TriggerGameModeEvent("OnAddingCollection", self.Collection)
	self:CheckCollectionThreshold()
end

function BP_TempleComponent_C:SetCollection(Value)
	self.Collection = Value
	EventManager:FireEvent(EventID.OnTempleScoreCollectChanged, self.Collection)
	self:CheckCollectionThreshold()
end

function BP_TempleComponent_C:GetCollection()
	return self.Collection
end

function BP_TempleComponent_C:SetCollectionThreshold(Value)
	self.CollectionThreshold = Value
end

------------------------通关失败相关----------------------------

function BP_TempleComponent_C:SetPlayerDeathMaxNum(Value)
	EventManager:FireEvent(EventID.OnSetTempleLimit, "LIFE", Value)
	self.PlayerDeathMaxNum = Value
end

function BP_TempleComponent_C:OnPlayerDead()
	self.PlayerDeathNum = self.PlayerDeathNum + 1
	EventManager:FireEvent(EventID.OnTempleDeathFallChanged, self.PlayerDeathMaxNum - self.PlayerDeathNum)
	self.GameMode:TriggerGameModeEvent("OnPlayerDeadTemple", self.PlayerDeathNum)
	if self.PlayerDeathNum > self.PlayerDeathMaxNum then
		self.FailReason = "LIFE"
		self.GameMode:TriggerGameModeEvent("OnPlayerDeathNumExceedMaxNum")
	end
end

function BP_TempleComponent_C:GetPlayerDeathNum()
	return self.PlayerDeathNum
end

function BP_TempleComponent_C:SetPlayerTriggerFallTriggerMaxNum(Value)
	EventManager:FireEvent(EventID.OnSetTempleLimit, "FALL", Value)
	self.PlayerTriggerFallTriggerMaxNum = Value
end

function BP_TempleComponent_C:OnPlayerTriggerFallTrigger()
	self.PlayerTriggerFallTriggerNum = self.PlayerTriggerFallTriggerNum + 1
	EventManager:FireEvent(EventID.OnTempleDeathFallChanged, self.PlayerTriggerFallTriggerMaxNum - self.PlayerTriggerFallTriggerNum)
	self.GameMode:TriggerGameModeEvent("OnTriggerFall", self.PlayerTriggerFallTriggerNum)
	if self.PlayerTriggerFallTriggerNum > self.PlayerTriggerFallTriggerMaxNum then
		self.FailReason = "FALL"
		self.GameMode:TriggerGameModeEvent("OnPlayerTriggerFallTriggerNumExceedMaxNum")
	end
end

function BP_TempleComponent_C:GetPlayerTriggerFallTriggerNum()
	return self.PlayerTriggerFallTriggerNum
end

function BP_TempleComponent_C:GetPlayerFailReason()
	return self.FailReason
end

function BP_TempleComponent_C:CheckScore(Score)
	if self.Score < Score then
		self.FailReason = "SCORE"
		return false
	end
	return true
end

-------------------机关 相关-----------------------
function BP_TempleComponent_C:AddStepPlatForm(GroupId, StepPlatFormEid)
	if not self.StepPlatformGroup then
		self.StepPlatformGroup = {}
	end
	if not self.StepPlatformGroup[GroupId] then
		self.StepPlatformGroup[GroupId] = {}
	end
	self.StepPlatformGroup[GroupId][StepPlatFormEid] = false
end

function BP_TempleComponent_C:AddDrone(GroupId, ManualItemId)
	if not self.DroneGroup then
		self.DroneGroup = {}
	end
	if not self.DroneGroup[GroupId] then
		self.DroneGroup[GroupId] = {}
	end
	table.insert(self.DroneGroup[GroupId], ManualItemId)
end

function BP_TempleComponent_C:RemoveStepPlatForm(GroupId, StepPlatFormEid)
	if not self.StepPlatformGroup[GroupId] or not self.StepPlatformGroup[GroupId][StepPlatFormEid] then
		return
	end
	self.StepPlatformGroup[GroupId][StepPlatFormEid] = nil
end

function BP_TempleComponent_C:ActiveStepPlatform(StepPlatFormEid)
	self.CurrentStepPlayformEid = StepPlatFormEid
end

function BP_TempleComponent_C:OnStepPlatformChangeGreen(GroupId, StepPlatFormEid)
	if not self.StepPlatformGroup or not self.StepPlatformGroup[GroupId] then return end
	self.StepPlatformGroup[GroupId][StepPlatFormEid] = true
	local Res = true
	for i, v in pairs(self.StepPlatformGroup[GroupId]) do
		Res = Res and v
		if Res == false then
			return
		end
	end
	self.GameMode:TriggerGameModeEvent("OnPlatformAllGreen", GroupId)
end

function BP_TempleComponent_C:OnStepPlatformLeaveGreen(GroupId, StepPlatFormEid)
	if not self.StepPlatformGroup or not self.StepPlatformGroup[GroupId] then return end
	self.StepPlatformGroup[GroupId][StepPlatFormEid] = false
end

function BP_TempleComponent_C:OnPlatformChangedColor(GroupId, ManualItemId, ColorType)
	self.GameMode:TriggerGameModeEvent("OnChangedColor", GroupId, ManualItemId, ColorType)
end

function BP_TempleComponent_C:OnPlayerOverlap(ManualItemId)
	self.GameMode:TriggerGameModeEvent("OnPlayerOverlapPlatform", ManualItemId)
end

function BP_TempleComponent_C:GetColorPlatformNum(GroupId, ColorType)
	local AllActors= TArray(AActor)
	local PlatformClass = LoadClass('/Game/BluePrints/Item/StepPlatform/BP_StepPlatFormBase.BP_StepPlatFormBase')
	UE4.UGameplayStatics.GetAllActorsOfClass(self, PlatformClass, AllActors)
	local Num = 0
    for i = 1, AllActors:Length() do
		if AllActors[i].GroupId == GroupId and AllActors[i].NowColorType == ColorType then
			Num = Num + 1
		end
    end
	return Num
end

function BP_TempleComponent_C:MovePlatform(ManualItemIds)
	for i, v in pairs(ManualItemIds:ToTable()) do
		local PlatForm = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		if PlatForm.IsActive then
			PlatForm:StartMove()
		end
	end
end

function BP_TempleComponent_C:MoveStepPlatform(ManualItemIds)
	self:MovePlatform(ManualItemIds)
	local PlatForm = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualItemIds[1])
	return PlatForm.LinkArchiveID
end

function BP_TempleComponent_C:SetIsStepPlatformMoveEnd(ManualItemId, IsEnd)
	if not self.MoveStepPlatformStates then
		self.MoveStepPlatformStates = {}
	end
	self.MoveStepPlatformStates[ManualItemId] = IsEnd
end

function BP_TempleComponent_C:IsAllManualItemsMoveEnd(ManualItemIds)
	for i, v in pairs(ManualItemIds:ToTable()) do
		if self.MoveStepPlatformStates[v] == false then
			return false
		end
	end
	return true
end

function BP_TempleComponent_C:OnPlayerLeaveColorRange()
	-- 玩家离开BP_ColorChangeRange调用
	self.CurrentStepPlayformEid = -1
end

function BP_TempleComponent_C:SetStepPlatformSpeed(ManualItemIds, NewSpeed)
	for i, v in pairs(ManualItemIds:ToTable()) do
		local Platform = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		if Platform ~= nil then
			Platform.Speed = NewSpeed
		end
	end
end

function BP_TempleComponent_C:MoveRotator(ManualItemIds)
	for i, v in pairs(ManualItemIds:ToTable()) do
		local Rotator = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		if Rotator.IsActive then
			Rotator:StartRotate()
		end
	end
end

function BP_TempleComponent_C:SetRotatorSequence(ManualItemId, Start, End)
	local Rotator = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualItemId)
	Rotator:SetTargetRotation(Start)
	Rotator:StartRotate()
	Rotator:SetSequence(Start, End)
end

function BP_TempleComponent_C:SetIsRotateEnd(ManualItemId, IsEnd)
	if not self.RotatorStates then
		self.RotatorStates = {}
	end
	self.RotatorStates[ManualItemId] = IsEnd
end

function BP_TempleComponent_C:GetRotatorStateID(Id)
	local Rotator = self.GameMode.EMGameState.ManualActiveCombat:Find(Id)
	if Rotator then
		return Rotator:GetRotateState()
	end
	return -2
end

function BP_TempleComponent_C:IsAllManualItemsRotateEnd(ManualItemIds)
	for i, v in pairs(ManualItemIds:ToTable()) do
		if self.RotatorStates[v] == false then
			return false
		end
	end
	return true
end

function BP_TempleComponent_C:IsManualItemRotateEnd(ManualItemId)
	if self.RotatorStates[ManualItemId] == false then
		return false
	end
	return true
end

function BP_TempleComponent_C:ActiveTempleMechanism(ManualItemIds)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	for i, v in pairs(ManualItemIds:ToTable()) do
		local TempleMechanism = GameMode.EMGameState.ManualActiveCombat:Find(v)
		if(TempleMechanism ~= nil) then
			TempleMechanism:ActiveCombat(true)
		else
			DebugPrint("TempleMechanism is nil,ManualItemId is ",v)
		end
	end
end

function BP_TempleComponent_C:InactiveTempleMechanism(ManualItemIds)
	for i, v in pairs(ManualItemIds:ToTable()) do
		local TempleMechanism = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		if(TempleMechanism ~= nil) then
			TempleMechanism:InactiveCombat(true)
		else
			DebugPrint("TempleMechanism is nil,ManualItemId is ",v)
		end
	end
end

function BP_TempleComponent_C:OnDroneFoundPlayer(GroupId, ManualItemId)
	if not self.DroneGroup or not self.DroneGroup[GroupId] then return end
	local IsGroupFirstTriggerMethod = true
	for i = 1, #self.DroneGroup[GroupId] do
		local ManualId = self.DroneGroup[GroupId][i]
		local Drone = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualId)
		if Drone and Drone.IsActive and Drone.ManualItemId ~= ManualItemId then
			Drone:OnOtherDroneFoundPlayer()
			if Drone.AlertValue and Drone.AlertValue > 0 then
				IsGroupFirstTriggerMethod = false
			end
		end
	end
	if IsGroupFirstTriggerMethod then
		self.GameMode:TriggerGameModeEvent("OnDroneStateChange", 1, GroupId)
	end
end

function BP_TempleComponent_C:OnDroneChangeToInit(GroupId, ManualItemId)
	-- 这个是巡逻机关警戒值归0且自身旋转归位触发
	DebugPrint("zwkk OnDroneChangeToInit",ManualItemId)
	if not self.DroneGroup or not self.DroneGroup[GroupId] then return end
	local GroupDroneAllFinish = true
	for i = 1, #self.DroneGroup[GroupId] do
		local ManualId = self.DroneGroup[GroupId][i]
		local Drone = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualId)
		if ManualId ~= ManualItemId and Drone.IsActive and (not Drone.RotateFinish or Drone.AlertValue > 0) then
			-- 自己以外的机关没归位或警戒值仍大于零则判断该组没有脱离警戒
			GroupDroneAllFinish = false
		end
	end
	if GroupDroneAllFinish then
		self.GameMode:TriggerGameModeEvent("OnDroneStateChange", 0, GroupId)
	end
	return GroupDroneAllFinish
end

function BP_TempleComponent_C:OnDroneAlertValueReset(GroupId, ManualItemId)
	-- 这个是巡逻机关警戒值归0触发
	if not self.DroneGroup or not self.DroneGroup[GroupId] then return end
	local GroupDroneAlertValueAllReset = true
	for i = 1, #self.DroneGroup[GroupId] do
		local ManualId = self.DroneGroup[GroupId][i]
		local Drone = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualId)
		if Drone.AlertValue > 0 then
			GroupDroneAlertValueAllReset = false
			break
		end
	end
	if GroupDroneAlertValueAllReset then
		for i = 1, #self.DroneGroup[GroupId] do
			local ManualId = self.DroneGroup[GroupId][i]
			local Drone = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualId)
			if Drone and Drone.IsActive then
				Drone:OnAllGroupDroneAlertZero()
				Drone:OnDroneStateChange(0)
			end
		end
	end
end

function BP_TempleComponent_C:OnDroneDestroyed(GroupId, ManualItemId)

end

function BP_TempleComponent_C:SetPlatformColor(ManualItemId, GroupId, ColorType)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if ManualItemId ~= 0 then
		local PlatForm = GameMode.EMGameState.ManualActiveCombat:Find(ManualItemId)
		if not PlatForm then
			return
		end
		PlatForm.NowColorType = ColorType
		PlatForm:SetColor(false)
	end
	if GroupId ~= 0 then
		for Eid, v in pairs(self.StepPlatformGroup[GroupId]) do
			local PlatForm = Battle(self):GetEntity(Eid)
			if PlatForm.ManualItemId ~= ManualItemId then
				PlatForm.NowColorType = ColorType
				PlatForm:SetColor(false)
			end
		end
	end
end

function BP_TempleComponent_C:SetPlatformPattern(ManualItemId, GroupId, PatternType)
	local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	if ManualItemId ~= 0 then
		local PlatForm = GameMode.EMGameState.ManualActiveCombat:Find(ManualItemId)
		if not PlatForm then
			return
		end
		PlatForm.NowPatternType = PatternType
		PlatForm:SetPattern(false)
	end
	if GroupId ~= 0 then
		for Eid, v in pairs(self.StepPlatformGroup[GroupId]) do
			local PlatForm = Battle(self):GetEntity(Eid)
			if PlatForm.ManualItemId ~= ManualItemId then
				PlatForm.NowPatternType = PatternType
				PlatForm:SetPattern(false)
			end
		end
	end
end

function BP_TempleComponent_C:HitVentilatorSpeedup(AddSpeed, ManualItemIds)
	for i, v in pairs(ManualItemIds:ToTable()) do
		local HitVentilator = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		if(HitVentilator ~= nil and HitVentilator.AddSpeed) then
			HitVentilator:AddSpeed(AddSpeed)
		else
			DebugPrint("HitVentilator is nil,ManualItemId is ",v)
		end
	end
end

function BP_TempleComponent_C:HitVentilatorBroken(GroupId, ManualItemId)
	self.HitVentilatorGroup[GroupId][ManualItemId] = true
	local Res = true
	for i, v in pairs(self.HitVentilatorGroup[GroupId]) do
		Res = Res and v
		if Res == false then
			return
		end
	end
	self.GameMode:TriggerGameModeEvent("OnHitAllVentilatorClear", GroupId)
end

function BP_TempleComponent_C:HitVentilatorReset(GroupId, ManualItemId)
	self.HitVentilatorGroup[GroupId][ManualItemId] = false
end

function BP_TempleComponent_C:AddHitVentilator(GroupId, ManualItemId)
	if not self.HitVentilatorGroup then
		self.HitVentilatorGroup = {}
	end
	if not self.HitVentilatorGroup[GroupId] then
		self.HitVentilatorGroup[GroupId] = {}
	end
	self.HitVentilatorGroup[GroupId][ManualItemId] = false
end

function BP_TempleComponent_C:SpawnBall(UnitId, ManualItemId)
	local Mechanism = self.GameMode.EMGameState.ManualActiveCombat:Find(ManualItemId)
	if Mechanism then
		Mechanism:SpawnBall(UnitId)
	end
end

function BP_TempleComponent_C:AddBombLaunchPad(ManualItemId)
	if not self.BombLaunchPadGroup then
		self.BombLaunchPadGroup = {}
	end
	self.BombLaunchPadGroup[ManualItemId] = ManualItemId
end

function BP_TempleComponent_C:AddSpawnBallPlatform(ManualItemId)
	if not self.SpawnBallPlatformGroup then
		self.SpawnBallPlatformGroup = {}
	end
	self.SpawnBallPlatformGroup[ManualItemId] = ManualItemId
end

function BP_TempleComponent_C:CheckCanInteractiveBomb()
	-- 只要有一个发射台没球就可以交互，否则不可以
	if not self.BombLaunchPadGroup then return end
	for i, v in pairs(self.BombLaunchPadGroup) do
		local BombLaunchPad = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		if BombLaunchPad and not BombLaunchPad.CurBomb then
			return
		end
	end
	for i, v in pairs(self.SpawnBallPlatformGroup) do
		local SpawnBallPlatform = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		SpawnBallPlatform:AllBallForbid()
	end
end

function BP_TempleComponent_C:ChangeAllBombToNormal()
	for i, v in pairs(self.SpawnBallPlatformGroup) do
		local SpawnBallPlatform = self.GameMode.EMGameState.ManualActiveCombat:Find(v)
		SpawnBallPlatform:AllBallNormal()
	end
end

function BP_TempleComponent_C:OnTempleEnergyToZero()
	self.GameMode:TriggerGameModeEvent("OnTempleEnergyComplete")
end

function BP_TempleComponent_C:OnCageMonsterDead(Monster, CageId)
	self.GameMode:TriggerGameModeEvent("OnTempleCageKillMonster", Monster, CageId)
end

--------------------------------------------------------------------------------------

-- function BP_TempleComponent_C:InitTempleFbdRule()
-- 	local FbdRule = self.TempleData.FbdRule
-- 	if FbdRule then
-- 		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)

-- 		-- 轮盘禁用
-- 		if FbdRule.NoBattleWheel and FbdRule.NoBattleWheel ~= 0 then
-- 			if Player then
-- 				Player:DisableBattleWheel()
-- 			end
-- 		end
-- 		-- 技能禁用
-- 		if Player then
-- 			if FbdRule.NoSkill and FbdRule.NoSkill ~= 0 then
-- 				Player:ForbidAllSkills(true)
-- 			end
-- 			if FbdRule.NoMelee and FbdRule.NoMelee ~= 0 then
-- 				Player:ForbidMeleeSkills(true)
-- 			end
-- 			if FbdRule.NoRanged and FbdRule.NoRanged ~= 0 then
-- 				Player:ForbidRangedSkills(true)
-- 			end
-- 		end
-- 	end
-- end

-- function BP_TempleComponent_C:ResetTempleFbdRule()
-- 	local FbdRule = self.TempleData.FbdRule
-- 	if FbdRule then
-- 		local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)

-- 		-- 轮盘禁用
-- 		if FbdRule.NoBattleWheel and FbdRule.NoBattleWheel ~= 0 then
-- 			if Player then
-- 				Player:EnableBattleWheel()
-- 			end
-- 		end
-- 		-- 技能禁用
-- 		if Player then
-- 			if FbdRule.NoSkill and FbdRule.NoSkill ~= 0 then
-- 				Player:ForbidAllSkills(false)
-- 			end
-- 			if FbdRule.NoMelee and FbdRule.NoMelee ~= 0 then
-- 				Player:ForbidMeleeSkills(false)
-- 			end
-- 			if FbdRule.NoRanged and FbdRule.NoRanged ~= 0 then
-- 				Player:ForbidRangedSkills(false)
-- 			end
-- 		end
-- 	end
-- end

function BP_TempleComponent_C:TempleForbid(ForbidRule, IsForbid)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if not Player then return end
	if ForbidRule ==  ETempleForbidRule.Melee then
		Player:ForbidMeleeSkills(IsForbid)
	elseif ForbidRule == ETempleForbidRule.Ranged then
		Player:ForbidRangedSkills(IsForbid)
	elseif ForbidRule == ETempleForbidRule.Skill then
		Player:ForbidAllSkillsByBuff(IsForbid)
	elseif ForbidRule == ETempleForbidRule.BattleWheel then
		if IsForbid then
			Player:DisableBattleWheel()
		else
			Player:EnableBattleWheel()
		end
	end
end

function BP_TempleComponent_C:ResetPlayerLocation()
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local GameMode=UE4.UGameplayStatics.GetGameMode(Player)
	local StartPoint=nil
	if GameMode.LevelLoader then
		 GameMode.LevelLoader:GetRandStartPoint()
		StartPoint=GameMode.LevelLoader.startPoint
	end
	if not StartPoint then
		DebugPrint("Temple:ResetPlayerLocation fail because empty StartPoint")
	end
	if GameMode then
		self:InterruptAll()
		GameMode.EMGameState:ResetAllManualActiveCombat()
		self:OnPlayerLeaveColorRange()
		if Player.bHasAttachBomb then
			Player.bHasAttachBomb = false
		end
		-- GameMode:TriggerFallingCallable(Player,StartPoint:GetTransform(), 0, true)
		--玩家在移动的平台上ResetPlayerLocation时需要等移动平台停止运动后一帧回到起点
		self:AddTimer(0.01, function()
			GameMode:TriggerFallingCallable(Player,StartPoint:GetTransform(), 0, true)
			-- 再Reset一下，防止因为机关先重置玩家延时重置后触发了机关的变化，后面可以把上面的全部重置改为重置移动平台
			GameMode.EMGameState:ResetAllManualActiveCombat()
			GameMode.EMGameState:ResetAllArchivePoint()
			if  GameMode.SetPlayerCharacterForceIdle then
				if not Player:IsDead() then
					GameMode:SetPlayerCharacterForceIdle(Player)
				else
					Player:QuickRecovery()
				end
			end
			DebugPrint("==============TriggerGameModeEvent: OnRestart====ResetAllArchivePointAndManualActiveCombat================")
			self:RestoreStatus(true, true, true, true)
			local GameMode = UE4.UGameplayStatics.GetGameMode(self)
			GameMode:TriggerGameModeEvent("OnRestart")
			GameMode:PostCustomEvent("OnRestart")		-- 策划想在主GameMode上触发事件
			EventManager:FireEvent(EventID.OnTempleEnter)
		end)
	end
end

function BP_TempleComponent_C:RestoreStatus(RestoreBullet, RestoreHp, RestoreSp, RestoreCD)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	local BulletMax = Player.RangedWeapon:GetAttr("BulletMax")
	local MagazineCapacity = Player.RangedWeapon:GetAttr("MagazineCapacity")
	local MaxHp = Player:GetAttr("MaxHp")
	local MaxES = Player:GetAttr("MaxES")
	local MaxSp = Player:GetAttr("MaxSp")
	DebugPrint("zwk RestoreStatus", BulletMax, MagazineCapacity, MaxHp, MaxES, MaxSp)

	-- 子弹
	if RestoreBullet then
		Player.RangedWeapon:ChargeBullet(MagazineCapacity)
		Player:AddBullet(BulletMax, EGetBulletReason.SkillEffectBullet)
	end
	-- Hp + 护盾
	if RestoreHp then
		Player:AddHp(MaxHp)
		Battle(Player):AddEnergyShield(Player, Player, MaxES, false, false, "")
	end
	-- 能量
	if RestoreSp then
		Battle(Player):AddSpToTarget(Player, Player, MaxSp, EChangedSpReason.SkillEffectBullet)
	end
	-- CD
	if RestoreCD then
		for _, Skill in pairs(Player.Skills) do
			Skill:ResetSkillCd()
		end
	end
end

function BP_TempleComponent_C:SetPickupInteractiveTickInterval(Interval)
	local PlayerCharacter = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
	if PlayerCharacter then
		local InteractiveComponent = PlayerCharacter:GetComponentByClass(UInteractiveTriggerComponent)
		if InteractiveComponent then
			InteractiveComponent:SetComponentTickInterval(Interval)
		end
	end
	if self.TempleRecoverPC ~= LuaConst.PCInterativeTickCount or self.TempleRecoverMobiel ~= LuaConst.MobileInterativeTickCount then
		self.TempleRecoverPC = LuaConst.PCInterativeTickCount
		self.TempleRecoverMobiel = LuaConst.MobileInterativeTickCount
		LuaConst.PCInterativeTickCount = Const.TempleInteractiveCount
		LuaConst.MobileInterativeTickCount = Const.TempleInteractiveCount
	end
	DebugPrint('BP_TempleComponent_C: SetPickupInteractiveTickInterval', Interval)
end

function BP_TempleComponent_C:ReceiveEndPlay(EndPlayReason)
	DebugPrint('BP_TempleComponent_C: ReceiveEndPlay', self.TempleRecoverPC, self.TempleRecoverMobiel)
	if self.TempleRecoverPC then
		LuaConst.PCInterativeTickCount = self.TempleRecoverPC
	end
	if self.TempleRecoverMobiel then
		LuaConst.MobileInterativeTickCount = self.TempleRecoverMobiel
	end
end

function BP_TempleComponent_C:ShowNearestMonsterGuide(bFirstHighLight)
	local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
	if not Player then 
		return 
	end

	local NearestMonsterEid = self.GameMode:GetMonsterEidNearestToPlayer(Player)
	if NearestMonsterEid > 0 then
		if bFirstHighLight then
			local ScenceManager = GWorld.GameInstance:GetSceneManager()
			ScenceManager.PlayLoopGuideIcons:Add(NearestMonsterEid)
		end
		self.GameMode.EMGameState:AddGuideEid(NearestMonsterEid)
	end
end

function BP_TempleComponent_C:ShowTempleTipButton(IsShow)
	EventManager:FireEvent(EventID.OnTempleTipButtonShow, IsShow)
end

function BP_TempleComponent_C:OnClickShowTips()
	self.GameMode:TriggerGameModeEvent("OnShowTempleTip")
	EventManager:FireEvent(EventID.OnTempleTipButtonShow, false)
end

return BP_TempleComponent_C


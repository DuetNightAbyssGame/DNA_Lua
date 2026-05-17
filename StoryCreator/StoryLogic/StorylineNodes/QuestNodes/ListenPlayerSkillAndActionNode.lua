local ECompareType = {
    GreaterThan = 0,
    LessThan = 1,
    GreaterThanOrEqual = 2,
    LessThanOrEqual = 3,
    Equal = 4,
    NotEqual = 5
}

local EListenType = {
    StaticPoint = 0,
    TriggerBox = 1
}

local M = Class('StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode')

function M:Init()
    self.ListenIds = {}
    self.CompareType = ECompareType.GreaterThan
    self.ListenCount = 1
    self.ListenType = EListenType.StaticPoint

    self.StaticPointId = 0
    self.StaticPointListenMinCM = 0
    self.StaticPointListenMaxCM = 0

    self.TriggerBoxId = 0

    self.Callback = nil
    self.ListenTimerHandle = nil
    self.ListenIntervalSeconds = 0.5
    self.bIsListenPlayerExecuteSkillOrAction = false
    self.CurrentListenCount = 0
end

function M:Execute(Callback)
    self.Callback = Callback

    self.ListenTimerHandle = GWorld.GameInstance:AddTimer(self.ListenIntervalSeconds, function()
        if (self:IsCanListenPlayerExecuteSkillOrAction()) then
            self:ListenPlayerExecuteSkillOrAction()
        else
            self:UnlistenPlayerExecuteSkillOrAction()
        end
    end, true)
end

function M:Clear()
    GWorld.GameInstance:RemoveTimer(self.ListenTimerHandle)
    self:UnlistenPlayerExecuteSkillOrAction()
end

function M:IsCanListenPlayerExecuteSkillOrAction()
    local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
    if (not IsValid(GameMode)) then
        return false
    end

    if (self.ListenType == EListenType.StaticPoint) then
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        if (not IsValid(PlayerCharacter)) then
            return false
        end

        local StaticPoint = GameMode.EMGameState.StaticCreatorMap:Find(self.StaticPointId)
        if (not IsValid(StaticPoint)) then
            return false
        end

        local DistanceCM = UE4.UKismetMathLibrary.Vector_Distance(PlayerCharacter:K2_GetActorLocation(), StaticPoint:K2_GetActorLocation())
        return DistanceCM > self.StaticPointListenMinCM and DistanceCM < self.StaticPointListenMaxCM
    elseif (self.ListenType == EListenType.TriggerBox) then
        local TriggerBox = GameMode:GetActor2ManualId(self.TriggerBoxId)
        if (not IsValid(TriggerBox)) then
            return false
        end

        return TriggerBox:CheckPlayerIn()
    end
end

function M:ListenPlayerExecuteSkillOrAction()
    if (self.bIsListenPlayerExecuteSkillOrAction) then
        return
    end

    self.bIsListenPlayerExecuteSkillOrAction = true
    EventManager:AddEvent(EventID.OnTheaterPerform, self, self.HandleOnPlayerExecutedSkillOrAction)
end

function M:UnlistenPlayerExecuteSkillOrAction()
    if (not self.bIsListenPlayerExecuteSkillOrAction) then
        return
    end

    self.bIsListenPlayerExecuteSkillOrAction = false
    EventManager:RemoveEvent(EventID.OnTheaterPerform, self)
end

function M:HandleOnPlayerExecutedSkillOrAction(SkillOrActionId)
    local bIsListen = false
    for _, ListenId in ipairs(self.ListenIds) do
        if (ListenId == SkillOrActionId) then
            bIsListen = true
            break
        end
    end

    if (not bIsListen) then
        return
    end

    self.CurrentListenCount = self.CurrentListenCount + 1

    local bConditionMet = false
    if (self.CompareType == ECompareType.GreaterThan) then
        bConditionMet = self.CurrentListenCount > self.ListenCount
    elseif (self.CompareType == ECompareType.LessThan) then
        bConditionMet = self.CurrentListenCount < self.ListenCount
    elseif (self.CompareType == ECompareType.GreaterThanOrEqual) then
        bConditionMet = self.CurrentListenCount >= self.ListenCount
    elseif (self.CompareType == ECompareType.LessThanOrEqual) then
        bConditionMet = self.CurrentListenCount <= self.ListenCount
    elseif (self.CompareType == ECompareType.Equal) then
        bConditionMet = self.CurrentListenCount == self.ListenCount
    elseif (self.CompareType == ECompareType.NotEqual) then
        bConditionMet = self.CurrentListenCount ~= self.ListenCount
    end

    if (bConditionMet) then
        if (self.Callback) then
            self.Callback()
        end
    end
end

return M

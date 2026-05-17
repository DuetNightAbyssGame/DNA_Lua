--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_SurvivalMiniComponent_C
local M = Class({
    "BluePrints.Common.TimerMgr",
})

function M:InitSurvivalMiniBaseComponent()
    self.GameMode = self:GetOwner()
    self.MaxSurvivalMiniValue = DataMgr.GlobalConstant.SurvivalValue.ConstantValue  -- 先按老的写
    self.MonsterDeadOut = 0
    self.CanPlayTalk = true
end

-- 子类重写
function M:StartRound()
    self.IsRoundBegin = true
    self:SetSurvivalMiniValue(0)

    self:SpawnMonsters()
end

function M:OnMiniGameSuccess()
    self.GameMode.EMGameState:SetDungeonUIState(Const.EDungeonUIState.OnTarget)
end

-- 子类重写
function M:SpawnMonsters()

end

function M:AddSurvivalMiniValue(Value)
    local NewValue = self:GetSurvivalMiniValue() + Value
    self:SetSurvivalMiniValue(NewValue)
end

function M:TriggerStopVitamin()
    self.IsStopVitamin = true
end

function M:TrigerResumeVitamin()
    self.IsStopVitamin = false
end

-- 兼容给旧的生存玩法用的外部接口
function M:AddSurvivalValue(Value)
    self:AddSurvivalMiniValue(Value)
end

function M:TriggerRoundEnd()
    if not self.IsRoundBegin then
        return
    end
    self.IsRoundBegin = false
    self.GameMode:TriggerGameModeEvent("Event_OnRoundEnd")
end

function M:SetSurvivalMiniValue(NewValue)
    if not self.IsRoundBegin then
        return
    end
    if self.IsStopVitamin then
        return
    end
    if NewValue < 0 then
        NewValue = 0
    end
    if NewValue > self.MaxSurvivalMiniValue then
        NewValue = self.MaxSurvivalMiniValue
    end

    self.GameMode.EMGameState:SetSurvivalMiniValue(NewValue)
    self:OnSurvivalMiniValueChanged(NewValue)
end

function M:OnSurvivalMiniValueChanged(NewValue)
    if NewValue >= self.MaxSurvivalMiniValue then
        EventManager:FireEvent(EventID.OnSurvivalMiniValueMax)
        self:TriggerRoundEnd()
    end
end

function M:GetSurvivalMiniValue()
    return self.GameMode.EMGameState.SurvivalMiniValue
end

function M:TableToTArray(table)
	local ResTArray = TArray(0)
    if table then
		for _, Item in ipairs(table) do
			ResTArray:Add(Item)
		end
    end
    return ResTArray
end

function M:OnMonsterDeadOut()
    if not IsStandAlone(self) then
        return
    end
    if not self.IsRoundBegin then
        return
    end
    if not self.CanPlayTalk then
        return
    end
    local MaxMonsterDeadOut = DataMgr.GlobalConstant.MaxMonsterDeadOut.ConstantValue
    self.MonsterDeadOut = self.MonsterDeadOut + 1
    if self.MonsterDeadOut >= MaxMonsterDeadOut and self.HasInEnergySurvival then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
        UE4.UPlayTalkAsyncAction.PlayTalk(GameInstance, 600306,nil)
        self.MonsterDeadOut = 0
        self.CanPlayTalk = false
        self:AddTimer(DataMgr.GlobalConstant.SurvivalTalkInterval.ConstantValue, function ()
            self.CanPlayTalk = true
        end, false, 0)
    end
end

-- function M:Initialize(Initializer)
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

return M

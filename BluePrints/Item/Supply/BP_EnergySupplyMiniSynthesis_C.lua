--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_EnergySupplyMiniSynthesis_C
local BP_EnergySupplyMiniSynthesis_C = Class({
    "BluePrints.Item.Supply.BP_EnergySupply_C"
})

function BP_EnergySupplyMiniSynthesis_C:CommonInitInfo(Info)
    BP_EnergySupplyMiniSynthesis_C.Super.CommonInitInfo(self, Info)

    self.Radius = self.UnitParams["Radius"] or 1000
    self.MiniMapPath = self.UnitParams["MiniMapPath"] or '/Game/UI/WBP/Common/VX/Activity/RechargeRebate/1111.1111'
    self.SphereCollision:SetSphereRadius(self.Radius, true)
end

function BP_EnergySupplyMiniSynthesis_C:AuthorityInitInfo(Info)
    BP_EnergySupplyMiniSynthesis_C.Super.AuthorityInitInfo(self,Info)
    EventManager:AddEvent(EventID.OnChargeTimeUp, self, self.OnChargeTimeUp)
    self.SphereCollision.OnComponentBeginOverlap:Add(self, self.CollisionBeginOverlap)
end

function BP_EnergySupplyMiniSynthesis_C:ClientInitInfo(Info)
    BP_EnergySupplyMiniSynthesis_C.Super.ClientInitInfo(self, Info)
    -- EventManager:FireEvent(EventID.ShowRangedIconInMinimap, self.Eid, false, self.MiniMapPath, self.Radius)
end

function BP_EnergySupplyMiniSynthesis_C:OnActorReady(Info)
    BP_EnergySupplyMiniSynthesis_C.Super.OnActorReady(self, Info)

    if not IsAuthority(self) then
        self:SyncEnergy()
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode and GameMode:GetDungeonComponent() and self.StateId ~= self.CompleteStateId then
        if not GameMode:GetDungeonComponent().IsChargeGameRunning  then
            -- 机关重新被创建时如果倒计时结束，则需要改回未激活态
            self:ChangeState("Manual", 0, self.DeActiveStateId)
        elseif GameMode:GetDungeonComponent().IsChargeGameRunning then
            -- 机关重新被创建时如果倒计时未结束，则维持激活态`
            self:ChangeState("Manual", 0, self.ActiveStateId)
        end
    end
    self:RepEnergyPercent()
end

function BP_EnergySupplyMiniSynthesis_C:ChangeEnergy_Lua(ChangeValue, bFromMonster)
    self.NowEnergy = self.NowEnergy + ChangeValue
    self.NowEnergy = math.min(self.NowEnergy, self.MaxEnergy)
    self.NowEnergy = math.max(self.NowEnergy, 0)
    if IsAuthority(self) then
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if GameMode and self.NowEnergy >= self.MaxEnergy then
            GameMode:TriggerDungeonAchieve("EnergySupplyEnergyMax", -1, self.Eid, self.UnitId)
        end
        self:RepEnergyPercent()
    end
    if IsStandAlone(self) or not IsAuthority(self) then
        self:OnEnergyChanged(self.NowEnergy, bFromMonster)
        if ChangeValue < 0 then
            self:OnEnergyDown()
        end
    end
    if self.NowEnergy >= self.MaxEnergy then
        self:ChangeState("Manual", 0, self.CompleteStateId)
    end
end

function BP_EnergySupplyMiniSynthesis_C:RepEnergyPercent()
    -- 同步能量百分比到GameState
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState and self.MaxEnergy and self.MaxEnergy > 0 then
        local percent = self.NowEnergy / self.MaxEnergy
        DebugPrint("zwkkk UpdateSynthesisSupplyPercent ", self.CreatorId, percent)
        GameState:UpdateSynthesisSupplyPercent(self.CreatorId, percent)
        -- 再同步一下当前能量值，主要是为了能在重连时正确显示当前能量，待改进
        GameState:UpdateSynthesisNowEnergy(self.Eid, self.NowEnergy)
    end
end

function BP_EnergySupplyMiniSynthesis_C:SyncEnergy()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    local Energy = GameState.SynthesisNowEnergyValues:FindRef(self.Eid)
    if Energy then
        self.NowEnergy = 0
        self:ChangeEnergy(Energy, false)
    end
end

function BP_EnergySupplyMiniSynthesis_C:OnSurvivalMiniValueMax()
    if not IsAuthority(self) then
        self:OnSurvivalMiniValueMax_Client()
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local PlayerList = GameMode:GetAllPlayer()
    for _, Player in pairs(PlayerList) do
        self:DeactiveGuide(Player.Eid)
    end
    self:EndFindTarget()
    self:EndFindTarget_Client()
    -- EventManager:FireEvent(EventID.ShowRangedIconInMinimap, self.Eid, true, nil, self.Radius)
    for NewNum = 1, 5 do
        -- self.FXComponent:PlayEffectByID(self.BuffFXIds[NewNum])
        self["BottleFull"..NewNum](self, true)
    end
    if GameMode then
        GameMode:TriggerDungeonComponentFun("OnOneChargeFinished", self.CreatorId)
    end
end

function BP_EnergySupplyMiniSynthesis_C:OnSurvivalMiniValueMax_Client()
    self:EndFindTarget_Client()
    -- EventManager:FireEvent(EventID.ShowRangedIconInMinimap, self.Eid, true, nil, self.Radius)
    for NewNum = 1, 5 do
        -- self.FXComponent:PlayEffectByID(self.BuffFXIds[NewNum])
        self["BottleFull"..NewNum](self, true)
    end
end

function BP_EnergySupplyMiniSynthesis_C:EnergyToSurvival()

end

function BP_EnergySupplyMiniSynthesis_C:CheckCanChangeEnergy()
    if self.StateId == self.CompleteStateId or self.StateId == self.DeActiveStateId then
        return false
    end
    return true
end

function BP_EnergySupplyMiniSynthesis_C:CheckCanPlayActiveMontage()
    return self.StateId == self.ActiveStateId or self.StateId == self.CompleteStateId
end

function BP_EnergySupplyMiniSynthesis_C:CheckCanPlayStopMontage()
    return self.StateId == self.DeActiveStateId
end

function BP_EnergySupplyMiniSynthesis_C:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)

    if NowStateId == self.CompleteStateId then
        self:OnSurvivalMiniValueMax()
        self:EnableEffect(true)
        -- self:SynthesisActiveGuide(false)
        EventManager:FireEvent(EventID.ShowRangedIconInMinimap, self.Eid, false, self.MiniMapPath, self.Radius)
    elseif NowStateId == self.DeActiveStateId then
        self:EnableEffect(false)
        -- self:SynthesisActiveGuide(false)
        EventManager:FireEvent(EventID.ShowRangedIconInMinimap, self.Eid, false, self.MiniMapPath, self.Radius)
    elseif NowStateId == self.ActiveStateId then
        self:EnableEffect(true)
        -- self:SynthesisActiveGuide(true)
        EventManager:FireEvent(EventID.ShowRangedIconInMinimap, self.Eid, true, self.MiniMapPath, self.Radius)
    end
end

function BP_EnergySupplyMiniSynthesis_C:EnableEffect(bEnable)
    local MaxEnergy = self.MaxEnergy or self.UnitParams["EnergyLimit"]
    local Num = math.floor(self.NowEnergy / (MaxEnergy / 5))
    if bEnable then
        for i = 1, Num do
            self["BottleFull"..i](self, true)
        end
        if not IsValid(self.ActiveFX) or not self.ActiveFX:IsActive() then
            self.ActiveFX = self.FXComponent:PlayEffectByID(900013)
        end
        if not self.bActiveMontage then
            self.bActiveMontage = true
            self:TriggerBluePrintEvent("PlayActiveMontage")
        end
        self:OnActive()
        self:LiquidEnable()
    else
        for i = 1, Num do
            self["BottleFull"..i](self, false)
        end
        if IsValid(self.ActiveFX) then
            self.ActiveFX:Deactivate()
        end
        if self.bActiveMontage then
            self.bActiveMontage = false
            self:TriggerBluePrintEvent("PlayStopMontage")
        end
        self:OnDeActive()
        self:LiquidDisable()
    end
end

function BP_EnergySupplyMiniSynthesis_C:OnChargeTimeUp()
    if self.StateId ~= self.CompleteStateId then
        self:ChangeState("Manual", 0, self.DeActiveStateId)
    end
end

function BP_EnergySupplyMiniSynthesis_C:CollisionBeginOverlap(Component, OtherActor)
    if not IsAuthority(self) then
        return
    end
    if self.HasTriggerRule then return end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        self.HasTriggerRule = true
        GameMode:TriggerDungeonComponentFun("OnPlayerEnterChargeMechanism", self.CreatorId)
    end
end

function BP_EnergySupplyMiniSynthesis_C:IsActiveAndHasPlayer()
    if self.StateId ~= self.ActiveStateId then
        return false
    end

    local OverlappingActors = UE4.TArray(AActor)
    self.SphereCollision:GetOverlappingActors(OverlappingActors)

    return OverlappingActors:Length() > 0
end

function BP_EnergySupplyMiniSynthesis_C:TryActiveGuide(Type, PlayerEid)

end

function BP_EnergySupplyMiniSynthesis_C:TryDeactiveGuide(PlayerEid)

end

function BP_EnergySupplyMiniSynthesis_C:TryActiveAllGuide(IgnoreList, PlayerEid)

end

function BP_EnergySupplyMiniSynthesis_C:TryDeactiveAllGuide(IgnoreList, PlayerEid)

end

function BP_EnergySupplyMiniSynthesis_C:SynthesisActiveGuide(IsActive)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
	for i = 0 ,GameMode:GetPlayerNum() - 1 do
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,i)
        if IsActive then
            self:ActiveGuide(nil, Player.Eid)
        else
            self:DeactiveGuide(Player.Eid)
        end
    end
end

-- 无交互 无buff 一些UI不需要，相关函数置空
function BP_EnergySupplyMiniSynthesis_C:OnEnergyChanged(NewEnergy, bFromMonster)

end

function BP_EnergySupplyMiniSynthesis_C:OnBuffAdded(PlayerEid, BuffID, OldLayer, NewLayer)

end

function BP_EnergySupplyMiniSynthesis_C:OnPlayerIn(PlayerEid, BuffID)

end

function BP_EnergySupplyMiniSynthesis_C:OnPlayerLeft(PlayerEid)

end

function BP_EnergySupplyMiniSynthesis_C:CheckPlayerInShowToastDis(Dis,PlayerEid)

end

function BP_EnergySupplyMiniSynthesis_C:RealShowToast()

end

function BP_EnergySupplyMiniSynthesis_C:OnInteracrive(PlayerId)

end

function BP_EnergySupplyMiniSynthesis_C:ResetToastInfo()

end

function BP_EnergySupplyMiniSynthesis_C:ShowInteractedToast(PlayerEid)

end

function BP_EnergySupplyMiniSynthesis_C:PhantomInteractive(PhantomEid)

end

function BP_EnergySupplyMiniSynthesis_C:PhantomDeInteractive(PhantomEid)

end

function BP_EnergySupplyMiniSynthesis_C:PlaySurvivalTalk(TalkId)

end

return BP_EnergySupplyMiniSynthesis_C

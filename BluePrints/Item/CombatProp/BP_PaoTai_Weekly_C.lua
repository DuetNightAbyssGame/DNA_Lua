--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_Paotai_Weekly_C
local M = Class({
    "BluePrints/Item/CombatProp/BP_Paotai_C",
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.bCanTriggerGameMode = true
end

function M:GetCanTriggerGameMode()
    return self.bCanTriggerGameMode
end

function M:OnEnterState(NowStateId)
    self.Overridden.OnEnterState(self, NowStateId)
    if NowStateId == self.CompleteStateId then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState.DefBaseMap:Remove(self.Eid)
        GameState.HatredCombatProp:Remove(self.Eid)
        self.bCanTriggerGameMode = false
    end
end

function M:OpenMechanism(PlayerEid)
    print(_G.LogTag,"LXZ OpenMechanism")
    self.OpenState = true
end

function M:CloseMechanism(PlayerEid)
    self.OpenState = false
    if IsAuthority(self) then
        self:Cancel(PlayerEid)
    end
end

function M:OpenUI(PlayerEid)
    if IsAuthority(self) and not IsStandAlone(self) then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player and Player.Eid == PlayerEid then
        local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        local UIManager = GameInstance:GetGameUIManager()
        self.PaoTaiBattleFront = UIManager:LoadUINew("BattleFort02", self.Eid, true)
    end
end

function M:CloseUI(PlayerEid)
    self.OpenState = false
    if IsAuthority(self) and not IsStandAlone(self) then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player and Player.Eid == PlayerEid and IsValid(self.PaoTaiBattleFront) then
        self.PaoTaiBattleFront:Close()
        self.PaoTaiBattleFront = nil
    end
end

function M:SetActiveType()
    self.ActiveType = ""
end

function M:EndInteractive(Player)
    self.ChestInteractiveComponent:EndInteractive(Player)
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

function M:ReceiveEndPlay()
    self:CloseUI(self.PlayerEid)
end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M

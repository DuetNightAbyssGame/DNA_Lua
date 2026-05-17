--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type BP_Paotai_C
local M = Class({
    "BluePrints/Item/DefenceCore/BP_DefenceBase_C",
})

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.InteractiveType = Const.EndByTargetInteractive
    -- self.ChestInteractiveComponent:InitInteractiveComponent(self.Data.InteractiveId)
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self,Info)
end

function M:EndInteractive(Player)
    self.ChestInteractiveComponent:EndInteractive(Player)
end

function M:OpenMechanism(PlayerId)
    print(_G.LogTag,"LXZ OpenMechanism")
    self:ActiveDefence()
    self.OpenState = true

    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    self.PaoTaiBattleFront = UIManager:LoadUINew("BattleFort", self.Eid, false)
end

function M:CloseMechanism()
    self.OpenState = false
    self:Cancel()
    if IsValid(self.PaoTaiBattleFront) then
        self.PaoTaiBattleFront:Close()
        self.PaoTaiBattleFront = nil
    end
end

function M:ForceCloseMechanism(PlayerEid, IsSuccess)
    if self.OpenState then
        self:Cancel()
    end
end

function M:CheckCanInteractive(Player)
    local TraceInfo="From BP_PaoTai_C:CheckCanInteractive"
    local Res = Battle(self):CheckConditionNew(67, Player, nil,TraceInfo)
    if not Res then
        self.ChestInteractiveComponent:InteractiveFailed()
        return false
    end
    return M.Super.CheckCanInteractive(self, Player)
end

function M:GetCanOpen()
    self.CanOpen = true
end

function M:OnHitedEffect(DamageEvent)
    self.Overridden.OnHitedEffect(self,DamageEvent)
    if self.OpenState then
        local DamageCauser = Battle(self):GetEntity(DamageEvent.SourceEid)
        if DamageCauser and not DamageEvent.DisableUIEffect then
            local DirectSource = DamageCauser:GetDirectSource()
            if not DirectSource then
                DirectSource = DamageCauser
            end
            local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
            local Player = PlayerController:GetMyPawn()
            Player:ShowDamageIndicator(DirectSource, DamageEvent)
        end
    end
end

function M:OnCoreDead()
    
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

function M:ReceiveEndPlay()
    self.OpenState = false
    if IsValid(self.PaoTaiBattleFront) then
        self:Cancel()
        self.PaoTaiBattleFront:Close()
        self.PaoTaiBattleFront = nil
    end
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

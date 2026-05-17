--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_FallTrigger_Juque_C
local BP_FallTrigger_Juque_C = Class("BluePrints.Common.TimerMgr")

function BP_FallTrigger_Juque_C:Initialize(Initializer)
    self.InRange = false
end

function BP_FallTrigger_Juque_C:ReceiveBeginPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:AddFallTriggerInfo(self)
    end
end

function BP_FallTrigger_Juque_C:ReceiveEndPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:RemoveFallTriggerInfo(self)
    end
end

function BP_FallTrigger_Juque_C:OnOverlapActor(OtherActor, OtherComponent)
    if not self.Active or UE4.UKismetMathLibrary.ClassIsChildOf(OtherComponent:GetClass(), UInteractiveBaseComponent:StaticClass()) then
        return
    end

    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end

    --判断是掉落物不是其他机关
    if not OtherActor.IsCharacter then
        print(_G.LogTag,"Error: FallTrigger 触发到了没有IsCharacter()的东西, 此物不在ActorType范畴内",OtherActor:GetName())
    end
    if OtherActor.IsCharacter and not OtherActor:IsCharacter() and not OtherActor:Cast(UE4.APickupBase) then
        return
    end
    local Res, ResTransform = self:CheckHasSafeTransform(OtherActor)
    if Res then
        GameMode:TriggerFallingCallable(
            OtherActor,
            ResTransform,
            self.MaxDis,
            self.DefaultEnable,
            self
        )
    else
        local ResComponent = self:GetNearestComponentTransform(OtherActor:K2_GetActorLocation())
        GameMode:TriggerFallingCallable(
            OtherActor,
            ResComponent:K2_GetComponentToWorld(),
            self.MaxDis,
            self.DefaultEnable,
            self
        )
    end
end

function BP_FallTrigger_Juque_C:CheckHasSafeTransform(OtherActor)
    if not OtherActor or not OtherActor.IsPlayer or not OtherActor:IsPlayer() then
        return false, nil
    end

    local SafeTransform = FTransform()
    local bFound = self:GetSafeTransform(OtherActor, SafeTransform)
    if bFound then
        return true, SafeTransform
    end

    return false, nil
end

return BP_FallTrigger_Juque_C

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_FallTrigger_Client_C
local BP_FallTrigger_Client_C = Class("BluePrints.Common.TimerMgr")

-- function BP_FallTrigger_Client_C:UserConstructionScript()
-- end

function BP_FallTrigger_Client_C:ReceiveBeginPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:AddFallTriggerInfo(self)
    end
end

function BP_FallTrigger_Client_C:ReceiveEndPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:RemoveFallTriggerInfo(self)
    end
end

function BP_FallTrigger_Client_C:OnOverlapActor(OtherActor, OtherComponent)
    if not self.Active or UE4.UKismetMathLibrary.ClassIsChildOf(OtherComponent:GetClass(), UInteractiveBaseComponent:StaticClass()) then
        return
    end

    -- 判断是掉落物不是其他机关
    if not OtherActor.IsCharacter then
        print(_G.LogTag,"Error: FallTrigger 触发到了没有IsCharacter()的东西, 此物不在ActorType范畴内",OtherActor:GetName())
    end
    if OtherActor.IsCharacter and not OtherActor:IsCharacter() and not OtherActor:Cast(UE4.APickupBase) then
        return
    end
    
    -- Player由客户端触发，走rpc，其他类型照常
    if OtherActor.IsPlayer and OtherActor:IsPlayer() then
        if not IsClient(self) and not IsStandAlone(self) then return end
        --DebugPrint("zwk Player由客户端触发")
        local Transform = self:GetTransformParam(OtherActor)
        OtherActor.RPCComponent:TriggerGameModeFalling(
            OtherActor, 
            Transform, 
            self.MaxDis, 
            self.DefaultEnable,
            self
        )

        -- if self.TriggerTalk ~= 0 then
        --     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
        --     ---@type BP_TalkContext_C
        --     local TalkContext = GameInstance:GetTalkContext()
        --     TalkContext:StartTalk_CPP(self.TriggerTalk, OtherActor, nil)
        -- end
    elseif IsAuthority(self) then
        local Transform = self:GetTransformParam(OtherActor)
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if not GameMode then
            return
        end
        GameMode:TriggerFallingCallable(
            OtherActor,
            Transform,
            self.MaxDis,
            self.DefaultEnable,
            self
        )
    end

end

function BP_FallTrigger_Client_C:GetTransformParam(OtherActor)
    local Transform = nil
    if self.Reborn:Length() > 0 then
        Transform = self:GetNearestTransformByReborn(OtherActor:K2_GetActorLocation())
    else
        local ResComponent = self:GetNearestComponentTransform(OtherActor:K2_GetActorLocation())
        Transform = ResComponent:K2_GetComponentToWorld()
    end
    return Transform
end

function BP_FallTrigger_Client_C:OverlapChangeNotify(bIsOverlapNow)
    EventManager:FireEvent(EventID.EdgeFalltrigerChangeOverlapState,bIsOverlapNow)
end



return BP_FallTrigger_Client_C

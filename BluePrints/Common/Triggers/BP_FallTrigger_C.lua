--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

---@type BP_FallTrigger_C
local BP_FallTrigger_C = Class("BluePrints.Common.TimerMgr")

function BP_FallTrigger_C:Initialize(Initializer)
    self.InRange = false
end

-- function BP_FallTrigger_C:UserConstructionScript()
-- end

function BP_FallTrigger_C:ReceiveBeginPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:AddFallTriggerInfo(self)
    end
end

function BP_FallTrigger_C:ReceiveEndPlay()
    if IsAuthority(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        GameState:RemoveFallTriggerInfo(self)
    end
end

-- function BP_FallTrigger_C:ReceiveTick(DeltaSeconds)
-- end

-- function BP_FallTrigger_C:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

function BP_FallTrigger_C:OnOverlapActor(OtherActor, OtherComponent)
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
    if self.Reborn:Length() > 0 then
        local Transform = self:GetNearestTransformByReborn(OtherActor:K2_GetActorLocation())
        GameMode:TriggerFallingCallable(
            OtherActor,
            Transform,
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


    -- if self.TriggerTalk == 0 then
    --     return
    -- end

    -- if OtherActor.IsPlayer and OtherActor:IsPlayer() then
    --     local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    --     -- UE4.UTalkActionBase.PlayTalk(GameInstance, self.TriggerTalk, 0, 0)
    --     -- UE4.UPlayTalkProcess.PlayTalk(GameInstance, self.TriggerTalk, OtherActor, nil)

    --     ---@type BP_TalkContext_C
    --     local TalkContext = GameInstance:GetTalkContext()
    --     TalkContext:StartTalk_CPP(self.TriggerTalk, OtherActor, nil)
    -- end
end

-- function BP_FallTrigger_C:ReceiveActorEndOverlap(OtherActor)
-- end

function BP_FallTrigger_C:OverlapChangeNotify(bIsOverlapNow)
    EventManager:FireEvent(EventID.EdgeFalltrigerChangeOverlapState,bIsOverlapNow)
end

-------------------------------- Falltrigger Edge ----------------------------------------------------------
function BP_FallTrigger_C:VignetteBegin(Player, Component)
    self.InRange = true
    if not Player.InEdgeTimer then
        Player.InEdgeTimer = true
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_LEAVE_EDGE"))
        self:AddTimer(2, self.MovePlayerEdge, true, 0, "MovePlayerEdge", nil, Player)
    end
end

function BP_FallTrigger_C:VignetteEnd(Player, Component)
    self.InRange = false
    Player.InEdgeTimer = false
    self:RemoveTimer("MovePlayerEdge")
end

function BP_FallTrigger_C:MovePlayerEdge(Player)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if not GameMode then
        return
    end
    if not self.InRange then return end
    if self.Reborn:Length() > 0 then
        local Transform = self:GetNearestTransformByReborn(Player:K2_GetActorLocation())
        GameMode:TriggerFallingCallable(
            Player,
            Transform,
            self.MaxDis,
            true,
            self
        )
    else
        local ResComponent = self:GetNearestComponentTransform(Player:K2_GetActorLocation())
        GameMode:TriggerFallingCallable(
            Player,
            ResComponent:K2_GetComponentToWorld(),
            self.MaxDis,
            true,
            self
        )
    end

    if self.InRange then
        -- 还在范围里，就继续放toast
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_LEAVE_EDGE"))
    end
end
-------------------------------- Falltrigger Edge End----------------------------------------------------------

return BP_FallTrigger_C

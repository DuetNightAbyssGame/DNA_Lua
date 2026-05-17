--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
--

require "UnLua"
local BP_SupplyBase_C = Class({"BluePrints.Item.Chest.BP_MechanismBase_C", "BluePrints.Common.TimerMgr",})

-- function BP_SupplyBase_C:ReceiveBeginPlay()
--     self.Overridden.ReceiveBeginPlay(self)
--     --self:GetChestInteractiveComponent().DisplayInteractiveName = GText(self.ChestInteractiveComponent.InteractiveName)
-- end

function BP_SupplyBase_C:OnActorReady(Info)
	BP_SupplyBase_C.Super.OnActorReady(self, Info)
end


function BP_SupplyBase_C:AuthorityInitInfo(Info)
    BP_SupplyBase_C.Super.AuthorityInitInfo(self,Info)
    --self:RegisterToGameState()
end

function BP_SupplyBase_C:CommonInitInfo(Info)
    BP_SupplyBase_C.Super.CommonInitInfo(self,Info)
    self.InteractiveType = Const.EndByTargetInteractive
    self.ChestInteractiveComponent.DisPlayInteractiveName = GText(self.ChestInteractiveComponent.InteractiveName)
end

function BP_SupplyBase_C:ClientInitInfo(Info)
    BP_SupplyBase_C.Super.ClientInitInfo(self,Info)
end


-- function BP_SupplyBase_C:ReceiveTick(DeltaSeconds)
--     --self.Overridden.ReceiveTick(self, DeltaSeconds)
--     --print(_G.LogTag,"Eid ::: "..self.Eid)
--     if isCanDestory and LoopCount > 0 then
--         if self.EMActorDestroy then 
--             print(_G.LogTag,"Eid ::: "..self.Eid)
--             self.EMActorDestroy(self)
--             LoopCount = LoopCount - 1
--         end
--     end
-- end

function BP_SupplyBase_C:ActiveMaterialNotify()
    if self.CanOpen and self.OpenState == false then
        self:SetTargetMaterialParam(self.SetCountParamName,self.SetCountParamValueMax)
        self:SetTargetMaterialParam(self.SetTimeParamName,self.SetTimeParamValueMax)
        local CurrentTime = UE4.UGameplayStatics.GetTimeSeconds(self)
        self:SetTargetMaterialParam(self.SetCurrentTimeParamName,CurrentTime)
    end
end



function BP_SupplyBase_C:DelayDestory()
    if self == nil then 
        return
    end
    self:AddTimer(5,self.DestorySupply)
end

function BP_SupplyBase_C:DestorySupply()
    print(_G.LogTag,"Eid ::: "..self.Eid)
    self:EMActorDestroy(EDestroyReason.MechanismDead)
end


function BP_SupplyBase_C:OpenMechanism(PlayerActorEid)
    if  PlayerActorEid == nil or self == nil or not self.CanOpen  then 
        return
    end
    self.CanOpen = false
    if IsAuthority(self) then
        self:TriggerGameModeEvent("OnSupplyInteractive")
        self.NowPlayerEid = PlayerActorEid
        self:ClientPlayAnim(PlayerActorEid, 0, self.Eid)
        self:AddTimer(self.SetInteractiveTime,self.InteractiveHandle, false, 0, "SupplayInteractive", false, PlayerActorEid)
    end
end

function BP_SupplyBase_C:InteractiveHandle(PlayerEid)
    if self.OpenState then
        if not self.OpenState  then
            self.CanOpen = true
        end
        return
    end
    self.OpenState = true
    self:AddSurvivalValue()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:TriggerDungeonAchieve("OnInteractiveSupplyBase", PlayerEid)
    end
    local PlayerActor = Battle(self):GetEntity(PlayerEid)
    if not PlayerActor then
        return
    end
    PlayerActor:DeInteractiveMechanism(self.Eid, PlayerEid, 0, true)
end

function BP_SupplyBase_C:CloseMechanism(PlayerId, IsSuccess)
    if IsAuthority(self) then
        self:DeactiveGuide()
        self:ClientPlayAnim(PlayerId, 2, self.Eid)
        self:DelayDestory()
        self.NowPlayerEid = 0
    end
end

function BP_SupplyBase_C:PlayAnim(PlayerId, InteractiveState, MechanismEid)
    if InteractiveState == 0 then
        self.ChestInteractiveComponent:OnStartInteractive(Battle(self):GetEntity(PlayerId), self.ChestInteractiveComponent.MontageName, MechanismEid)
        self:SetTargetMaterialParam(self.SetTimeParamName,self.SetTimeParamValue)
        self:ActiveSpecialEffects()
    end
    if InteractiveState == 1 then
        
    end
    if InteractiveState == 2 then
        self.ChestInteractiveComponent:OnEndInteractive(Battle(self):GetEntity(PlayerId), self.ChestInteractiveComponent.MontageName, MechanismEid)
    end
end

function BP_SupplyBase_C:AddSurvivalValue()
    local SurvivalValue  = DataMgr.GlobalConstant.BigSurvivalMechanism.ConstantValue
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:TriggerDungeonComponentFun("AddSurvivalValue", SurvivalValue)
    end
    -- print(_G.LogTag,"SupplyMechanism Add SurvivalValue "..SurvivalValue)
end

function BP_SupplyBase_C:OnRep_NowPlayerEid()
    if self.NowPlayerEid == 0 then
        return
    end
    
end

AssembleComponents(BP_SupplyBase_C)
return BP_SupplyBase_C

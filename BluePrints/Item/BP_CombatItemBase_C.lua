require "UnLua"
local BP_CombatItemBase_C = Class({
    "BluePrints.Item.SceneItemBase",
})

BP_CombatItemBase_C._components = {
    "BluePrints.Item.Components.MechanismMovementComponent",
    "BluePrints.Item.Components.DistanceCheck",
}

local MechanismStateCpp = true

function BP_CombatItemBase_C:OnEMActorDestroy(DestroyReason)
    BP_CombatItemBase_C.Super.OnEMActorDestroy(self, DestroyReason)
    if IsStandAlone(self) or IsDedicatedServer(self) then
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        local GameMode = UE4.UGameplayStatics.GetGameMode(self)
        if CommonUtils.CheckDestroyReason(DestroyReason, "IsTriggerDestroyEvent") then
            GameMode:TriggerEMActorDestoryEvent(nil, self, DestroyReason)
        end
        if self.Data and self.Data.GuideInactive then
            GameState:RemoveGuideEid(self.Eid)
        end
    end
end

function BP_CombatItemBase_C:PreInitInfo(Info)
    BP_CombatItemBase_C.Super.PreInitInfo(self,Info)
    if not self.Data then
        assert(self.Data, "CombatItemBase Can't find in Table, UnitId: "..Info.UnitId.." UnitType: "..Info.UnitType)
        return
    end
    self.UnitParams = self.Data["UnitParams"] or {}
    self.UnitName = GText(self.Data["UnitName"]) or self.Data["UnitName"]
    self.ModelId = self.Data.ModelId

    -- if self.UnitType and self.UnitType=="Mechanism" and self.Data and self.Data.MiniMapIcon then
    --     self.MiniMapIcon = self.Data.MiniMapIcon
    -- end
    self:UpdateBluePrintParams()
end

function BP_CombatItemBase_C:CommonInitInfo(Info)
    BP_CombatItemBase_C.Super.CommonInitInfo(self,Info)
    self.ActorLocation = self:K2_GetActorLocation()
    -- triggerbox有重写，如若修改，请一起
    self:InitBattleInfo()
    self:RegisterToGameState()
    self:InitComponent(self)
    self:CheckNeedHide()
    self:SetLightingChannels()
end

function BP_CombatItemBase_C:AuthorityInitInfo(Info)
    BP_CombatItemBase_C.Super.AuthorityInitInfo(self,Info)
    self:AdjustLocation(Info)
	if self.SourceEid ~= 0 and self.RegionDataType ~= ERegionDataType.RDT_None then 
		GWorld.logger.errorlog("Eid = " .. tostring(self.Eid) .. "的机关 RegionDataType不为None, 可能导致机关恢复两份")
	end
end

function BP_CombatItemBase_C:ClientInitInfo(Info)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
	if GameState then
		GameState:TryRegisterFirstSeeMehcanism(self.UnitId, self.Eid)
	end
end

function BP_CombatItemBase_C:InitComponent(Info)
    self.CombatClientEffectComponent:InitComponent()
    if self.DefaultInteractiveComponent then
        self.DefaultInteractiveComponent.bCanUsed = false
        self.DefaultInteractiveComponent.IsDefault = true
        self.InteractiveComponents:Clear()
        self.InteractiveComponents:Add(self.DefaultInteractiveComponent)
        self.ChestInteractiveComponent = self.DefaultInteractiveComponent
    end
    if not MechanismStateCpp then
        self.CombatStateChangeComponent:InitComponent_Lua()
    else
        self.CombatStateChangeComponent:InitComponent()
    end
    if self.NeedNavModifier then
        self:AddNavModifier()
    end
end

--根据机关表显示条件判断显隐
function BP_CombatItemBase_C:CheckNeedHide()
    local ShowConditionId = self.Data.ShowConditionId
    local Avatar = GWorld:GetAvatar()
    if not ShowConditionId or not Avatar or ConditionUtils.CheckCondition(Avatar, ShowConditionId) then
        return
    end
    self:HideMechanism(true, "Condition")
end

function BP_CombatItemBase_C:CreateRegionData()
    self.RegionData = {
        StateId = self.StateId
    }
end

function BP_CombatItemBase_C:CheckUnitNeedStorage()
    if self.RegionDataType and self.RegionDataType > 0 and self.RegionDataType ~= ERegionDataType.RDT_HardBossData and self.RegionDataType ~= ERegionDataType.RDT_QuestData then
        return true
    end
    return false
end

function BP_CombatItemBase_C:SetActorHideTag(HideTag, Invisible)
	if self.HideTags == nil then
		self.HideTags = {}
	end
    if Invisible and self.HideTags[HideTag] then
		return
	end
	if Invisible then
		self.HideTags[HideTag] = 1
	else
		self.HideTags[HideTag] = nil
	end
    if IsClient(self) or IsStandAlone(self) then
		local Hide = not IsEmptyTable(self.HideTags)
        self:SetActorHiddenInGame(Hide)
	end
end

function BP_CombatItemBase_C:HideMechanism(NeedCallBack, Reason, AlwaysShow)
    --隐藏这个机关，包括关闭碰撞和隐藏actor，有特殊处理的在子类续写
    local CompArray = self:K2_GetComponentsByClass(UShapeComponent:StaticClass())
    for i, v in pairs(CompArray) do
        v:SetCollisionEnabled(0)
    end
    if not AlwaysShow then
        self:SetActorHideTag(Reason, true)
        local MeshCompArray = self:K2_GetComponentsByClass(UMeshComponent:StaticClass())
        for i, v in pairs(MeshCompArray) do
            v:SetCollisionEnabled(0)
        end
    end
    if NeedCallBack then
        EventManager:AddEvent(EventID.ConditionComplete, self, self.ShowMechanismWithCondition)
    end
end

function BP_CombatItemBase_C:ShowMechanismWithCondition(ShowConditionId)
    if ShowConditionId ~= self.Data.ShowConditionId then
        return
    end
    --显示这个机关，包括开启碰撞和显示actor，有特殊处理的在子类续写
    local CompArray = self:K2_GetComponentsByClass(UShapeComponent:StaticClass())
    for i, v in pairs(CompArray) do
        v:SetCollisionEnabled(1)
    end
    local MeshCompArray = self:K2_GetComponentsByClass(UMeshComponent:StaticClass())
    for i, v in pairs(MeshCompArray) do
        v:SetCollisionEnabled(1)
    end
    EventManager:RemoveEvent(EventID.ConditionComplete, self)
    self:SetActorHideTag("Condition", false)
end

function BP_CombatItemBase_C:ShowMechanism(Reason)
    --显示这个机关，包括开启碰撞和显示actor，有特殊处理的在子类续写
    local CompArray = self:K2_GetComponentsByClass(UShapeComponent:StaticClass())
    for i, v in pairs(CompArray) do
        v:SetCollisionEnabled(1)
    end
    local MeshCompArray = self:K2_GetComponentsByClass(UMeshComponent:StaticClass())
    for i, v in pairs(MeshCompArray) do
        v:SetCollisionEnabled(1)
    end
    self:SetActorHideTag(Reason, false)
end

function BP_CombatItemBase_C:SetLifeTime(LifeTime, Reason)
    DebugPrint("ZJT_ 当前死亡的机关名称为： ", self:GetName(), self.UnitType, LifeTime, Reason, self.IsCache)
    if self.IsCache then return end
    local function TryDestroy()
        self:EMActorDestroy(EDestroyReason.MechanismLifeTime)
    end
    self:AddTimer(LifeTime, TryDestroy, false)
end

-- function BP_CombatItemBase_C:GetObjType()
--     return EObjType.CombatItemBase
-- end

-- function BP_CombatItemBase_C:GetGuidePos()
--     return self.ActorLocation
-- end

function BP_CombatItemBase_C:SetCollisionType_Lua(ComponentName, ChannelIndex, Response,Reset)
    if Reset then
        self[ComponentName]:SetCollisionResponseToAllChannels(ECollisionResponse.ECR_Ignore)
    end
    self[ComponentName]:SetCollisionResponseToChannel(ChannelIndex,Response)
end

function BP_CombatItemBase_C:GetCurrentModelInfo()
    if self.ModelId == nil then
        return nil
    end
    return DataMgr.Model[self.ModelId]
end

function BP_CombatItemBase_C:GetFXMesh()
    return self.Mesh or self.RootComponent
end

function BP_CombatItemBase_C:GetUnitRealType()
    local Res 
    if DataMgr.Mechanism[self.UnitId] then
        Res = DataMgr.Mechanism[self.UnitId].UnitRealType
    end
    return Res or ""
end

--根据SourceEid触发对应的机关
function BP_CombatItemBase_C:TriggerSource(GamePlayType)
    if self.SourceEid ~= 0 then
        local Source = Battle(self):GetEntity(self.SourceEid)
        if not GamePlayType or Source.GamePlayType == GamePlayType then
            Source:TriggerByChild(self.Eid)
        end
    end
end

function BP_CombatItemBase_C:TriggerFallingCallable()
    DebugPrint("OtherActor is Falling Dead. ActorName: ", self:GetName(), ", UnitId: ", self.UnitId, ", Eid: ", self.Eid, ", CreatorId: ", self.CreatorId, " CreatorType: ", self.CreatorType, ", BornPos: ", self.BornPos)
	self:SetLifeTime(1.0, EDeathReason.TriggerFalling)
end

--被机关创造的机关、怪物或掉落物触发
function BP_CombatItemBase_C:TriggerByChild()
    print(_G.LogTag,"Error: Use CombatItemBase TriggerByChild, Check definition in code")
end

function BP_CombatItemBase_C:SetVariableBool(VariableName, Variable, PlayerEid)
    local Player = Battle(self):GetEntity(PlayerEid)
	if not IsValid(Player) then
		return
	end
    Player.RPCComponent:SetVariableBool(VariableName, Variable, self.Eid)
end

--EventName:音频路径   key:循环音效播放用的通道   SoundParam:音频参数table
function BP_CombatItemBase_C:PlaySound(EventName, key, SoundParam)
    if EventName then
        AudioManager(self):PlayFMODSound(self, nil, EventName, key)
    end
    if SoundParam ~= nil then
        AudioManager(self):SetEventSoundParam(self, key, SoundParam)
    end
end

function BP_CombatItemBase_C:UpdateBluePrintParams()
    if not self.Data.BluePrintParams then
        return
    end
    for i,v in pairs(self.Data.BluePrintParams) do
        if self[i] then
            self[i] = v
        end
    end
end

function BP_CombatItemBase_C:AdjustLocation(Info)
    --BpBorn为true代表拖进场景，必须手配位置，不予调整
    if not self.Mesh or self.BpBorn then return end
    local OldLoc
    local GameMode = UGameplayStatics.GetGameMode(self)
    self:AdjustLocationCPP(Info.Creator, Info.IntParams:Find("RandomRuleId"), Info.IntParams:Find("RandomCreatorId"), self.Mesh.RelativeLocation.Z)
    -- if self.CreatorId then
    --     if self.RandomCreatorId == 0 then
    --         OldLoc = Info.Creator:K2_GetActorLocation()
    --     else
    --         OldLoc = GameMode.RandomActorManager:GetCreatorRegionDataLoc(Info.RandomRuleId, Info.RandomCreatorId)
    --     end
    -- end
    -- local AdjustVector = self.Mesh.RelativeLocation
    -- local CurrentMove = UE4.UKismetMathLibrary.GreaterGreater_VectorRotator(FVector(0,0,AdjustVector.Z), self:K2_GetActorRotation())
    -- self:K2_SetActorLocation(OldLoc - CurrentMove, false, nil, false)
end


function BP_CombatItemBase_C:RegisterToGameState()
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    if GameState == nil then
        print(_G.LogTag,"Error, GameState is nil")
        return
    end
    GameState:RegisterMechanism(self,self:GetUnitRealType())
    GameState:RegisterMechanismCanBeFind(self)
    if self.UniqueId ~= "" then
        GameState:RegisterMechanismRegionOnline(self.UniqueId, self)
    end
end

function BP_CombatItemBase_C:TriggerGameModeEvent(Reason)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    GameMode:TriggerGameModeEvent(Reason)
end

function BP_CombatItemBase_C:ActiveCombat()
    if self.IsActive then
        return
    end
    self.IsActive = true
    --处理逻辑
    self:ActiveOnServer()
    --处理表现
    self:OnActiveStateChange()
end

function BP_CombatItemBase_C:DeActiveCombat()
    if self.IsActive == false then
        return
    end
    self.IsActive = false
    --处理逻辑
    self:DeActive()
    --处理表现
    self:OnActiveStateChange()
end

function BP_CombatItemBase_C:DeActive()
end

function BP_CombatItemBase_C:ActiveOnServer()
end

function BP_CombatItemBase_C:OnActiveStateChange()
    if self.IsActive then
        self.CombatClientEffectComponent:OnActiveEffect()
    else
        self.CombatClientEffectComponent:OnDeactiveEffect()
    end
end

function BP_CombatItemBase_C:UpdateRegionStateId(NewStateId, bFirstState)
	if self.BpBorn and not self:CheckManuItemRegionStorage() then
		return
	end
    if not self.RegionData or self.RegionData["StateId"] == nil then return end
    print(_G.LogTag,"LXZ ChangeState UpdateRegionStateId", self:GetName(), self.RegionData["StateId"], NewStateId)
    self.RegionData["StateId"] = NewStateId
    local GameMode = UGameplayStatics.GetGameMode(self)
    if GameMode then
        GameMode:GetRegionDataMgrSubSystem():UpdateRegionActorData(self, self.RegionData, not bFirstState)
    end
end

function BP_CombatItemBase_C:ServerUpdateRegionStateId(NewStateId, CallBack)
	if self.BpBorn and not self:CheckManuItemRegionStorage() then
		CallBack(0)
        return
	end
    if not self.RegionData or self.RegionData["StateId"] == nil then return end
    local NewRegionData = self.RegionData
    NewRegionData["StateId"] = NewStateId
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local GameState = UGameplayStatics.GetGameState(self)
        if GameState:IsInRegion() then
            Avatar:RegionActorUpdate(self, self.SubRegionId, self.LevelName, NewRegionData, CallBack)
        elseif GameState:IsInDungeon() then
            CallBack(0)
        end
    else
        CallBack(0)
    end
end

function BP_CombatItemBase_C:RecoverBpBornData()
    -- local StorgeStateId = 0
    -- self:ChangeState("Recover", 0, StorgeStateId)
    self:ChangeState("Recover", 0, 0)
end

function BP_CombatItemBase_C:ChangeState(Type, PlayerId, NextState)
    if not IsAuthority(self) and not IsStandAlone(self) or not self.InitSuccess then
        return
    end
    if MechanismStateCpp then
        local GameMode = UGameplayStatics.GetGameMode(self)
        local UseServer = false
        if UseServer and GameMode:CheckServerDungeonEnable() then
            print(_G.LogTag,"LXZ DungeonLogic ChangeState")
            local Info = {
                UnitId = self.UnitId, 
                UniqueId = self.ServerUniqueId, 
                StateId = NextState,
                PlayerId = PlayerId,
                Type = Type
            }
            GameMode:NotifyServerMechanismStateChange(Info)
        else
            self.CombatStateChangeComponent:TryChangeState("ChangeState_"..Type.."_CPP", PlayerId, NextState)
        end
    else
        self.CombatStateChangeComponent["ChangeState_"..Type](self.CombatStateChangeComponent, PlayerId, NextState)
    end
end

--关卡服务器校验通过后切换状态
function BP_CombatItemBase_C:DungeonServerChangeState(EventInfo)
    local Type = EventInfo.Type
    local PlayerId = EventInfo.PlayerId
    local NextState = EventInfo.StateId
    self.CombatStateChangeComponent:TryChangeState("ChangeState_"..Type.."_CPP", PlayerId, NextState)
end

function BP_CombatItemBase_C:OnRep_StateId()
    if self.InitSuccess then
        if not MechanismStateCpp then
            self.CombatStateChangeComponent:ClientChangeToState_Lua(self.StateId)
        else
            self.CombatStateChangeComponent:ClientChangeToState(self.StateId)
        end
    else
        local function Callback()
            if self.InitSuccess then
                if not MechanismStateCpp then
                    self.CombatStateChangeComponent:ClientChangeToState_Lua(self.StateId)
                else
                    self.CombatStateChangeComponent:ClientChangeToState(self.StateId)
                end
                self:RemoveTimer("OnRep_StateId")
            end
        end
        self:AddTimer(0.1, Callback, true, 0, "OnRep_StateId", false, self, self.StateId)
    end
end

function BP_CombatItemBase_C:TriggerBluePrintEvent_Lua(EventName)
    if not IsAuthority(self) or IsStandAlone(self) then
        self[EventName](self)
    end
end

--副本波次存储专用
function BP_CombatItemBase_C:GetDungeonSaveData()
    return {StateId = self.StateId}
end

function BP_CombatItemBase_C:AddTN(ChangeTN)
    local TN = math.max(0, math.min(self:GetAttr("MaxTN"), self:GetAttr("TN") + ChangeTN))
    self:SetAttr("TN", TN)
    --self:GetAttributesSet():OnRep_TN()
end

function BP_CombatItemBase_C:CreateSpecialMonster(RuleId)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if (not IsValid(GameMode)) or (GameMode:IsInDungeon()) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CombatItemBaseLoc = FVector(self:K2_GetActorLocation().X, self:K2_GetActorLocation().Y, self:K2_GetActorLocation().Z)
    local function Cb(ErrCode)
        if (ErrCode ~= ErrorCode.RET_SUCCESS) then
            DebugPrint("ERROR! 机关创建特殊怪失败:   ", ErrorCode:Name(ErrCode))
            return
        end
        local SpawnLocationType = DataMgr.SpecialMonsterSpawn[RuleId].SpawnLocation
        if SpawnLocationType == "Local" then
            local Context = AEventMgr.CreateUnitContext()
            Context.UnitType = "Monster"
            Context.UnitId = DataMgr.SpecialMonsterSpawn[RuleId].UnitId
            Context.Loc = CombatItemBaseLoc
            Context.MonsterSpawn = GameMode.FixedMonsterSpawn
            Context.IntParams:Add("Level", GameMode:GetGameModeLevel())
            GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
        else
            local Strs = Split(SpawnLocationType, ":")
            if Strs[1] == "Offvision" then
                local Offset = tonumber(Strs[2])
                local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance,0)
                local Forward = Player.CharCameraComponent:GetForwardVector()
                local PlayerPos = Player:K2_GetActorLocation()
                local Center = PlayerPos - Forward * (Offset / 2 + 100)
                local Radius = Offset / 2 - 100
                local NavLocation = FVector(0, 0, 0)
                local HasNav = UE4.URuntimeCommonFunctionLibrary.GetRandomReachablePointInRadius(NavLocation, Center, Radius)
                if HasNav then
                    local Context = AEventMgr.CreateUnitContext()
                    Context.UnitType = "Monster"
                    Context.UnitId = DataMgr.SpecialMonsterSpawn[RuleId].UnitId
                    Context.Loc = NavLocation
                    Context.MonsterSpawn = GameMode.FixedMonsterSpawn
                    Context.IntParams:Add("Level", GameMode:GetGameModeLevel())
                    GameMode.EMGameState.EventMgr:CreateUnitNew(Context, false)
                else
                    DebugPrint("=====================CreateSpecialMonster==No Vaild NavLocation")
                end
            end
        end
    end
    Avatar:TrySpawnSpecialMonster(RuleId, Cb)
end

function BP_CombatItemBase_C:SetLightingChannels()
    if not self.NeedLightingChannel then
        return
    end
    local Comps = self:K2_GetComponentsByClass(USkeletalMeshComponent:StaticClass())
    for i, v in pairs(Comps) do
        v:SetLightingChannels(true, false, false)
    end
end

function BP_CombatItemBase_C:CheckCanInteractive(Player)
    local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if MainPlayer.Eid ~= Player.Eid then
        return true
    end
    return not self.ChestInteractiveComponent:IsForbidden(Player)
end

function BP_CombatItemBase_C:CheckMontageInteractive()
    if not self.ChestInteractiveComponent then
        return false
    end
    if not self.ChestInteractiveComponent.MontageName then
        return false
    end
    return true
end

function BP_CombatItemBase_C:GetCanOpenAndOpenState()
    return self.CanOpen and not self.OpenState
end

function BP_CombatItemBase_C:ReceiveEndPlay(Reason)
    EventManager:RemoveEvent(EventID.OnArtLevelLoaded, self)
    BP_CombatItemBase_C.Super.ReceiveEndPlay(self, Reason)
end

function BP_CombatItemBase_C:IsInRegionOnline()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    return Avatar.IsInRegionOnline
end

function BP_CombatItemBase_C:CheckAutoCreateReward()
    local StateList = self.Data.StateIdList
    if not StateList then
        return true
    end
    for i, v in pairs(StateList) do
        local StateData = DataMgr.MechanismState[v]
        if StateData and StateData.StateEvent then
            for j, StateEvent in pairs(StateData.StateEvent) do
                if StateEvent.EventsNextState then
                    for k, Event in pairs(StateEvent.EventsNextState) do
                        if Event.Function == "GiveReward" then
                            return false
                        end
                    end
                end
            end
        end
    end
    return true
end

AssembleComponents(BP_CombatItemBase_C)
return BP_CombatItemBase_C

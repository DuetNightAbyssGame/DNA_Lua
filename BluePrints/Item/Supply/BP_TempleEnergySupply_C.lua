--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_TempleEnergySupply_C = Class({
    "BluePrints.Item.Supply.BP_SupplyBase_C",
    "BluePrints.Combat.Components.EffectSourceInterface"
})

-- 生存长按提示Toast相关变量
local bIsToastShowed = false -- bool 本轮内toast有没有显示过，有的话就不再显示了
local WaitToShowToastTime = DataMgr.GlobalConstant["SurvivalProToastTime"]["ConstantValue"] -- 进入范围内后多久显示toast
local ToastTime = 15 -- Toast持续时间
local ShowToastDistance = DataMgr.GlobalConstant["SurvivalProRadius"]["ConstantValue"] -- 这个距离内开启定时器
local ToastTimerName = "RealShowToast"
local AlreadyDeleteToast = false

BP_TempleEnergySupply_C._components = {
    "BluePrints.Item.Components.RecoverEnergy",
}

function BP_TempleEnergySupply_C:AuthorityInitInfo(Info)
    BP_TempleEnergySupply_C.Super.AuthorityInitInfo(self,Info)
    
    self.NormalEnergy = self.UnitParams["NormalEnergy"]
    self.EliteEnergy = self.UnitParams["EliteEnergy"]
    self.RecoverEnergy = self.UnitParams["RecoverEnergy"]
    self.BuffId = self.UnitParams["BuffId"]
    self.StageTime = self.UnitParams["StageTime"]
    self.MaxEnergyChange = self.UnitParams["MaxEnergyChange"]

    self.LeaveBuffTime = DataMgr.GlobalConstant["LeaveBuffTime"]["ConstantValue"]
    self.MaxSurvivalValue = DataMgr.GlobalConstant.SurvivalValue.ConstantValue

    self.RecoverHandle = nil
    self.SurvivalTime = 0
    self.HasPlayTalk = false
    self.InteractiveFXObjext = nil
    self.HasFindPlayer = false

    self.HasAllEnergyGuideClose = {}
    self.HasEnergyGuideClose = {}
end

function BP_TempleEnergySupply_C:CommonInitInfo(Info)
    BP_TempleEnergySupply_C.Super.CommonInitInfo(self,Info)
    self.InteractiveType = Const.PressInteractive
    self.NowEnergy = self.EnergyLimit
    self.MaxEnergy = self.EnergyLimit
    self.LiquidFXNum = 0
    self.BuffNum = 0
    self.BuffFXNum = 0
    self.BuffFXIds = {900016, 900019, 900017, 900018}
    -- 900015:working_03  900013：working_01  900012：NS_Med_Interactive
    self.BuffFX = {}
    self.RemoveBuffId = self.UnitParams["RemoveBuffId"]
    self.GuideRadius = DataMgr.GlobalConstant["SurvivalProGuideRadius"]["ConstantValue"] or 500
    self.ReduceValue = self.UnitParams["ReduceValue"]
    self.ChestInteractiveComponent.DisPlayInteractiveName = GText(self.ChestInteractiveComponent.InteractiveName)
    self.Target = {}
    self.InToastDisPlayer = {}
    self.BuffId = self.UnitParams["BuffId"]
    self.bActiveMontage = false
end

function BP_TempleEnergySupply_C:ClientInitInfo(Info)
    BP_TempleEnergySupply_C.Super.ClientInitInfo(self, Info)
    
    DebugPrint("ADD TIMER FindTarget_Client",self:GetName())
    self:AddTimer(0.1, BP_TempleEnergySupply_C.FindTarget_Client, true)
end

function BP_TempleEnergySupply_C:OnActorReady(Info)
    BP_TempleEnergySupply_C.Super.OnActorReady(self, Info)
    if IsAuthority(self) then
        self:StartRecover()
        -- self:OnBuffNumChange()
    end
    self:OnFxObjectFinished()
    for i, v in pairs(self.BuffFXIds) do
        self.FXComponent:PlayEffectByID(v)
    end
    self.FXMax = self.FXComponent:PlayEffectByID(900015)
end

function BP_TempleEnergySupply_C:ReceiveEndPlay(Reason)
    self.Overridden.ReceiveEndPlay(self, Reason)
    EventManager:RemoveEvent(EventID.OnStartSkillFeature, self)
    EventManager:RemoveEvent(EventID.OnEndSkillFeature, self)
    self:ResetToastInfo()
end

function BP_TempleEnergySupply_C:OnEMActorDestroy(...)
    BP_TempleEnergySupply_C.Super.OnEMActorDestroy(self, ...)
    print(_G.LogTag,"LXZ OnEMActorDestroy",self:GetName(), self._RegisterOnCharacterDead)
    if self._RegisterOnCharacterDead then
    	Battle(self):UnregisterBattleEvent(BattleEventName.OnAfterDead, self, "_OnCharacterDead")
    end
end

-- function BP_TempleEnergySupply_C:RegisterToGameState()
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     if GameState == nil then
--         print(_G.LogTag,"GameState is nil")
--         return
--     end
--     GameState:RegisterMechanism(self,self:GetUnitRealType())
-- end

function BP_TempleEnergySupply_C:OpenMechanism(PlayerActorEid)
    if IsClient(self) then
        return
    end
    if  PlayerActorEid == nil or self == nil or not self.CanOpen  then 
        return
    end
    if self.IsEnergyInteractive then
        return
    end
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
        self.NowPlayerEid = PlayerActorEid
        self:ClientPlayAnim(PlayerActorEid, 0, self.Eid)
    end
    self.IsEnergyInteractive = true
    if self.EToSHandle == nil then
        self.FXNum = 0
        self.EToSHandle = self:AddTimer(0.1,self.EnergyToSurvival,true)
    end
    self:OnOpenMechanism()
end

function BP_TempleEnergySupply_C:CloseMechanism(Eid, IsSuccess)
    if IsAuthority(self) and Eid == self.NowPlayerEid then
        local Player = Battle(self):GetEntity(self.NowPlayerEid)
        Player.OnInteractiveDelegate:Add(self, self.ChangeToNormalState)
        self:ClientPlayAnim(Eid, 2, self.Eid)
        self:RemoveTimer(self.EToSHandle)
        self:RemoveTimer("EnergySupplyInteractedToast")
        self.EToSHandle = nil
        self.NowPlayerEid = 0
        self.IsEnergyInteractive = false
        self:OnCloseMechanism()
    end
    AudioManager(self):SetEventSoundParam(self, "EnergySupplyOpen", {ToEnd = 1})
end

function BP_TempleEnergySupply_C:ForceCloseMechanism(Eid, IsSuccess)
    print(_G.LogTag,"LXZ ForceCloseMechanism", Eid, self.NowPlayerEid)
    if IsAuthority(self) and Eid == self.NowPlayerEid then
        local Player = Battle(self):GetEntity(self.NowPlayerEid)
        Player.OnInteractiveDelegate:Add(self, self.ChangeToNormalState)
        self:ClientPlayAnim(Eid, 2, self.Eid)
        self:RemoveTimer(self.EToSHandle)
        self:RemoveTimer("EnergySupplyInteractedToast")
        self.EToSHandle = nil
        self.NowPlayerEid = 0
        self.IsEnergyInteractive = false
    end
    AudioManager(self):SetEventSoundParam(self, "EnergySupplyOpen", {ToEnd = 1})
end

function BP_TempleEnergySupply_C:ChangeToNormalState(Player)
    if IsAuthority(self) then
        self.DefaultInteractiveComponent.bCanUsed = false
        self:ChangeState("InteractDone", Player.Eid)
        Player.OnInteractiveDelegate:Remove(self, self.ChangeToNormalState)
    end
end

function BP_TempleEnergySupply_C:SetInteractiveCanUsed(value)
    
end

function BP_TempleEnergySupply_C:PlayAnim(PlayerId, InteractiveState, MechanismEid)
    local PlayerCharacter = Battle(self):GetEntity(PlayerId)
    if InteractiveState == 0 then
        self.ChestInteractiveComponent:OnStartInteractive(PlayerCharacter, self.ChestInteractiveComponent.MontageName, MechanismEid)
        if IsClient(self) then
            --服务器的tag之前已经设过了
            PlayerCharacter:SetCharacterTag("Interactive")
        end
        self:OnInteracrive(PlayerId)
        -- self:ActiveSpecialEffects()
    end
    if InteractiveState == 1 then
        
    end
    if InteractiveState == 2 then
        --客户端的交互组件可用性也要打开，懒得写新的rpc了，放这用用
        self.DefaultInteractiveComponent.bCanUsed = false
        self.ChestInteractiveComponent:OnEndInteractive(PlayerCharacter, self.ChestInteractiveComponent.MontageName, MechanismEid)
        -- self:DeActiveSpecialEffects()
    end
end
---------------Buff相关-------------------
function BP_TempleEnergySupply_C:OnBuffNumChange()
    if not self.BuffId then
        return
    end
    local NewBuffNum = self.NowEnergy//self.BuffBase
    local Sub = math.floor(NewBuffNum - self.BuffNum)
    if Sub < 0 then
        DebugPrint("这里是BuffNumChangelxh1: "..Sub)
        Battle(self):ReduceBuffLayerFromTarget(self, self, self.BuffId, -Sub, false)
    elseif Sub > 0 then
        DebugPrint("这里是BuffNumChangelxh2: "..Sub)
        Battle(self):AddBuffToTarget(self, self, self.BuffId, -1, nil, nil, Sub)
    end
    self.BuffNum = NewBuffNum
end

function BP_TempleEnergySupply_C:FindTarget()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local FindPlayer = false
	for i = 0 ,GameMode:GetPlayerNum() - 1 do
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,i)
        local Dis = self:CalDistance(Player)
        if Dis<=self.Radius and self:CheckInSameLevel(Player) then
            FindPlayer = true
            --在self.Radius和self.GuideRadius之间时，只显示自身指引；小于self.GuideRadius时，不显示所有指引
            if not self.HasAllEnergyGuideClose[Player.Eid] then
                local IgnoreSelf = TArray(0)
                if Dis>=self.GuideRadius then
                    IgnoreSelf:Add(self.Eid)
                end
                -- print(_G.LogTag,"LXZ FindTarget111", Player:GetName(), Player.Eid, self.GuideRadius)
                self:DeactiveAllGuide(IgnoreSelf, Player.Eid)
                self.HasAllEnergyGuideClose[Player.Eid] = true
            elseif Dis>=self.GuideRadius and (self.HasEnergyGuideClose[Player.Eid] or self.HasEnergyGuideClose[Player.Eid] == nil) then
                -- print(_G.LogTag,"LXZ FindTarget222", Player:GetName(), Player.Eid)
                self:ActiveGuide("Add", Player.Eid)
                self.HasEnergyGuideClose[Player.Eid] = false
            elseif Dis<self.GuideRadius and not self.HasEnergyGuideClose[Player.Eid] then
                -- print(_G.LogTag,"LXZ FindTarget333")
                self:DeactiveGuide(Player.Eid)
                self.HasEnergyGuideClose[Player.Eid] = true
            end
        else
            if self.HasAllEnergyGuideClose[Player.Eid] then
                -- print(_G.LogTag,"LXZ FindTarget", Player:GetName(), Player.Eid)
                self:ActiveAllGuide(nil, Player.Eid)
                self.HasAllEnergyGuideClose[Player.Eid] = false
            end
        end
        -- self:CheckPlayerInShowToastDis(Dis,Player.Eid)
    end
    if FindPlayer then
        self:LiquidStart()
    else
        self:LiquidStop()
    end
    if self.HasFindPlayer ~= FindPlayer then
        if FindPlayer then
            self:OnSupplyRun()
        else
            self:OnSupplyStop()
        end
        self.HasFindPlayer = FindPlayer
    end
end

---------------Buff相关-------------------
---------------能量相关-------------------
function BP_TempleEnergySupply_C:StartRecover()
    self.RecoverHandle = self:AddTimer(1, BP_TempleEnergySupply_C.AutoRecover, true)
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
	for i = 0 ,GameMode:GetPlayerNum() - 1 do
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,i)
        if self.HasAllEnergyGuideClose[Player.Eid] or self.HasAllEnergyGuideClose[Player.Eid] == nil then
            self:ActiveAllGuide(nil, Player.Eid)
            self.HasAllEnergyGuideClose[Player.Eid] = false
        end
    end
    self.BuffHandle = self:AddTimer(0.1, BP_TempleEnergySupply_C.FindTarget, true)
end

function BP_TempleEnergySupply_C:AutoRecover()
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local bFindPlayer = false
	for i = 0 ,GameMode:GetPlayerNum() - 1 do
		local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,i)
        local Dis = self:CalDistance(Player)
        if Dis<=self.Radius and self:CheckInSameLevel(Player) then
            bFindPlayer = true
            if not self.bActiveMontage then
                self.bActiveMontage = true
                self:TriggerBluePrintEvent("PlayActiveMontage")
            end
            self:ChangeEnergy(self.RecoverEnergy, false)
            break
        end
    end
    --todo
    if not bFindPlayer and self.bActiveMontage then
        self.bActiveMontage = false
        self:TriggerBluePrintEvent("PlayStopMontage")
    end
    --self:OnBuffNumChange()
end

function BP_TempleEnergySupply_C:OutRecover_Lua(Monster)
    if not IsValid(Monster) or not Monster:IsMonster() then
        return 
    end
    if Monster.EnergySupplyCheck == nil then
        Monster.EnergySupplyCheck = 1
    elseif Monster.EnergySupplyCheck ~= nil and Monster.EnergySupplyCheck ~= -1 then
        Monster.EnergySupplyCheck = Monster.EnergySupplyCheck + 1
    end
    local DisX = Monster:K2_GetActorLocation().X - self:K2_GetActorLocation().X
    local DisY = Monster:K2_GetActorLocation().Y - self:K2_GetActorLocation().Y
    local Dis = math.sqrt(DisX*DisX+DisY*DisY)
    if Dis < self.Radius and self:CheckInSameLevel(Monster) then
        if IsAuthority(self) then
            local SeqFilterTag = {"Mon.Strong",}
            if Monster:HasAnyTags_Table(Monster, SeqFilterTag, false) then
                self:ChangeEnergy(self.EliteEnergy, true)
            else
                self:ChangeEnergy(self.NormalEnergy, true)
            end
        end
        if (not IsAuthority(self) or IsStandAlone(self)) and self.NowEnergy > 0 then
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self,0)
            local MonsterLoc = Monster.Mesh:K2_GetComponentLocation()
            local MonsterRot = Monster.Mesh:K2_GetComponentRotation()
            local FXID = DataMgr.VFX_CommonSet[2]["EffectId"][1]
            local FXObject = Player.FXComponent:PlayEffectByIDParams(FXID, {
                UseAbsoluteLocation = true,
                Location = {MonsterLoc.X,MonsterLoc.Y,MonsterLoc.Z + Monster.OriginHalfHeight},
                Rotation = {MonsterRot.Pitch, MonsterRot.Yaw, MonsterRot.Roll}
            })
            if FXObject then
                self:OnFxObjectCreated(FXObject)
                UE4.UNiagaraFunctionLibrary.OverrideSystemUserVariableSkeletalMeshComponent(FXObject,"Skeletal Mesh",Monster.Mesh)
                FXObject:SetNiagaraVariableVec3("AttarctionPosition",self.AttarctionPosition:K2_GetComponentLocation())
                if self.AttarctionStrength then
                    FXObject:SetNiagaraVariableFloat("AttarctionStrength", self.AttarctionStrength)
                end
                if self.ParticleNumberMul then
                    FXObject:SetNiagaraVariableFloat("ParticleNumberMul", self.ParticleNumberMul)
                end
                if self.ParticleSizeScale then
                    FXObject:SetNiagaraVariableFloat("ParticleSizeScale", self.ParticleSizeScale)
                end
            end
            -- Player.FXComponent:AddFxObjectTag(FXObject, tostring(FXID))
        end
        Monster.EnergySupplyCheck = -1
    end
end

function BP_TempleEnergySupply_C:EnergyToSurvival()
    if not self.IsEnergyInteractive then
        return
    end
    local RealChangeVal =  math.min(self.ReduceValue/10,self.NowEnergy)
    self:ChangeEnergy(-RealChangeVal,false)
    self:OnEnergyDown()
    self.FXNum = self.FXNum + 1
end

function BP_TempleEnergySupply_C:OnForceEndInteractive_Lua(SurvivalValue,MaxSurvivalValue)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
	if not GameState then
		return
	end

    if not IsAuthority(self) or IsStandAlone(self) then
        if SurvivalValue >= MaxSurvivalValue then
            UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "DUNGEON_SURVIVALPRO_108")
	    else
            UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, "DUNGEON_SURVIVALPRO_109")
	    end
    end

	
end

function BP_TempleEnergySupply_C:ChangeEnergy_Lua(ChangeValue, bFromMonster)
    self.NowEnergy = self.NowEnergy + ChangeValue
    self.NowEnergy = math.min(self.NowEnergy, self.MaxEnergy)
    self.NowEnergy = math.max(self.NowEnergy, 0)
    self.EnergyChangeFromMonster = bFromMonster
    if IsStandAlone(self) then
        -- self:OnEnergyChanged(self.NowEnergy, bFromMonster)
        if ChangeValue < 0 then
            self:OnEnergyDown()
        end
        if self.ActiveFX ~= nil and self.NowEnergy <= 0 then
            self.ActiveFX:Deactivate()
            self.ActiveFX = nil
            if not IsValid(self.InteractiveFXObjext) or not self.InteractiveFXObjext:IsActive() then
                self.InteractiveFXObjext = self.FXComponent:PlayEffectByID(900012)
                self.InteractiveFXObjext:SetWorldScale3D(self.EffectScale)
                local StopInteractiveFX = function()
                    if IsValid(self.InteractiveFXObjext) then
                        self.InteractiveFXObjext:Deactivate()
                        self.InteractiveFXObjext = nil
                    end
                end
                self:AddTimer(1, StopInteractiveFX, false, 0)
            end
            -- 所有怪物移除buff
            local GameState = UE4.UGameplayStatics.GetGameState(self)
            for _, Target in pairs(GameState.MonsterMap) do
                if Target:GetCamp() == ECampName.Monster then
                    if self.RemoveBuffId and self.RemoveBuffId ~= 0 then
                        DebugPrint("zwk RemoveBuffId", self.RemoveBuffId, Target:GetName())
                        Battle(self):RemoveBuffFromTarget(self, Target, self.RemoveBuffId, false, -1)
                    end
                end
            end
            -- GameMode事件
            local GameMode = UE4.UGameplayStatics.GetGameMode(self)
            GameMode:GetDungeonComponent():OnTempleEnergyToZero()

            self.CanOpen = false
        end
        if self.FXMax ~= nil and self.NowEnergy < self.MaxEnergy then
            self.FXMax:Deactivate()
            self.FXMax = nil
        end
    end
end

function BP_TempleEnergySupply_C:GetCanOpen()
    if self.NowEnergy > 0 then
        self.CanOpen = true
    else
        self.CanOpen = false
    end
end

function BP_TempleEnergySupply_C:PlayActiveMontage()
    local AnimInstance = self.Mesh:GetAnimInstance()
    local Montage = AnimInstance:GetCurrentActiveMontage()
    if Montage and AnimInstance:Montage_GetCurrentSection(Montage) == "StopIdle" then
        AnimInstance:Montage_JumpToSection("Start", Montage)
        self.ActiveFX = self.FXComponent:PlayEffectByID(900013)
    elseif not Montage then
        self:PlayMontage(self.Mesh, self.MontagePath, "Start", nil, true)
        self.ActiveFX = self.FXComponent:PlayEffectByID(900013)
    end
end

function BP_TempleEnergySupply_C:PlayStopMontage()
    local AnimInstance = self.Mesh:GetAnimInstance()
    local Montage = AnimInstance:GetCurrentActiveMontage()
    local SectionName = AnimInstance:Montage_GetCurrentSection(Montage)
    if Montage and SectionName ~= "Stop" and SectionName ~= "StopIdle" then
        AnimInstance:Montage_JumpToSection("Stop", Montage)
    end
end

function BP_TempleEnergySupply_C:CalDistance(Player)
    local PlayerX = Player:K2_GetActorLocation().X
    local PlayerY = Player:K2_GetActorLocation().Y
    local SelfX = self:K2_GetActorLocation().X
    local SelfY = self:K2_GetActorLocation().Y
    local x = PlayerX - SelfX
    local y = PlayerY - SelfY
    return math.sqrt(x*x+y*y)
end

function BP_TempleEnergySupply_C:OnRep_NowEnergy()
    if self.InitSuccess then
        self:OnFxObjectFinished()
    elseif not self.InitSuccess and not self:IsExistTimer("OnRep_NowEnergy") then
        local function Callback()
            if self.InitSuccess then
                self:OnFxObjectFinished()
                self:RemoveTimer("OnRep_NowEnergy")
            end
        end
        self:AddTimer(0.1, Callback, true, 0, "OnRep_NowEnergy", false)
    end
end
-------------能量相关-------------------------
function BP_TempleEnergySupply_C:CheckInSameLevel(Actor)
    local ActorLevelId = self:CheckActorLevel(Actor)
    local SupplyLevelId = self:CheckActorLevel(self)
    return ActorLevelId~=-1 and ActorLevelId == SupplyLevelId
end

function BP_TempleEnergySupply_C:CheckActorLevel(Actor)
    local LevelLoader = UE4.UGameplayStatics.GetGameInstance(self):GetSceneManager():GetLevelLoader()
    if not LevelLoader then
        return true
    end
    return LevelLoader:GetLevelId(Actor)
end

----------UI事件----------------
-- function BP_TempleEnergySupply_C:OnEnergyChanged(NewEnergy, bFromMonster)
--     self.EnergySupplyBarComponent:OnEnergyChanged(NewEnergy, bFromMonster)
-- end

-- function BP_TempleEnergySupply_C:OnBuffAdded(PlayerEid, BuffID, OldLayer, NewLayer)
--     self.EnergySupplyBarComponent:OnBuffAdded(PlayerEid, BuffID, OldLayer, NewLayer)
-- end

-- function BP_TempleEnergySupply_C:OnPlayerIn(PlayerEid, BuffID)
--     return self.EnergySupplyBarComponent:OnPlayerIn(PlayerEid, BuffID)
-- end

-- function BP_TempleEnergySupply_C:OnPlayerLeft(PlayerEid)
--     return self.EnergySupplyBarComponent:OnPlayerLeft(PlayerEid)
-- end

-- function BP_TempleEnergySupply_C:OnForceEndInteractive()
-- 	self.EnergySupplyBarComponent:OnForceEndInteractive()
-- end

function BP_TempleEnergySupply_C:OnFxObjectCreated(FxObject)
	-- self.EnergySupplyBarComponent:OnFxObjectCreated(FxObject)
    FxObject.OnSystemFinished:Add(self, self.OnFxObjectFinished)
end

-- function BP_TempleEnergySupply_C:OnLiquidChange(Liquid)
--     if IsAuthority(self) and not IsStandAlone(self) then
--         return
--     end
--     -- local NewNum = Liquid//self.BuffBase
--     -- if NewNum < 0 then
--     --     return
--     -- end
--     -- local Sub = NewNum - self.LiquidFXNum
--     -- if Sub < 0 and self.BuffFX[self.LiquidFXNum] then
--     --     if IsValid(self.BuffFX[self.LiquidFXNum]) then
--     --         self.BuffFX[self.LiquidFXNum]:K2_DestroyComponent(self.BuffFX[self.LiquidFXNum])
--     --     end
--     --     self.BuffFX[self.LiquidFXNum] = nil
--     -- elseif Sub > 0 then
--     --     self.BuffFX[NewNum] = self.FXComponent:PlayEffectByID(self.BuffFXIds[NewNum] or 900018)
--     -- end
-- 	if Liquid == self.MaxEnergy and not self.MaxEnergyFX then
--         self.MaxEnergyFX = {}
--         self.MaxEnergyFX[1] = self.FXComponent:PlayEffectByID(900014)
--         self.MaxEnergyFX[2] = self.FXComponent:PlayEffectByID(900015)
--     elseif Liquid < self.MaxEnergy and self.MaxEnergyFX then
--         if IsValid(self.MaxEnergyFX[1]) then
--             self.MaxEnergyFX[1]:K2_DestroyComponent(self.MaxEnergyFX[1])
--         end
--         if IsValid(self.MaxEnergyFX[2]) then
--             self.MaxEnergyFX[2]:K2_DestroyComponent(self.MaxEnergyFX[1])
--         end
--         self.MaxEnergyFX = nil
--     end
--     self.LiquidFXNum = NewNum
-- end

function BP_TempleEnergySupply_C:OnStartSkillFeature(IsHideAllUI)
    -- if IsHideAllUI then
    --     local Widget = self.EnergySupplyBarComponent:GetWidget()
    --     if Widget then
    --         Widget:Hide(Const.SkillFeatureHideTag)
    --     end
    -- end
end

function BP_TempleEnergySupply_C:OnEndSkillFeature(IsHideAllUI)
    -- if IsHideAllUI then
    --     local Widget = self.EnergySupplyBarComponent:GetWidget()
    --     if Widget then
    --         Widget:Show(Const.SkillFeatureHideTag)
    --     end
    -- end
end

function BP_TempleEnergySupply_C:CheckPlayerInShowToastDis(Dis,PlayerEid)
    if bIsToastShowed then
        return
    end
    if Dis < ShowToastDistance then
        if self.InToastDisPlayer[PlayerEid] == nil then
            self:AddTimer(WaitToShowToastTime,self.RealShowToast,false,0,ToastTimerName,true)
            self.InToastDisPlayer[PlayerEid] = self.NowEnergy or 0
        end
    else
        if self.InToastDisPlayer[PlayerEid] ~= nil then
            self:RemoveTimer(ToastTimerName)
            self.InToastDisPlayer[PlayerEid] = nil
        end
    end
end

function BP_TempleEnergySupply_C:RealShowToast()
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager then
        -- UE4.UUIStateAsyncActionBase.ShowGuideToast(GameInstance, 100011, ToastTime)
        UResourceLibrary.LoadClassAsync(GameInstance, UIConst.GuideTextFloat,
            {
                GameInstance, function(_, ClassObject)
                    UE4.UUIStateAsyncActionBase.ShowGuideToastWithUIClass(GameInstance, ClassObject, 100011, ToastTime)
                end
            })
        bIsToastShowed = true
    end
end

-- 交互时取消定时器+让toast消失
function BP_TempleEnergySupply_C:OnInteracrive(PlayerId)
    if AlreadyDeleteToast then
        return
    end
    if self.NowEnergy > (self.InToastDisPlayer[PlayerId] or 0) and self:IsExistTimer(ToastTimerName) then
        self:RemoveTimer(ToastTimerName)
        return
    end
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
    local UIManager = GameInstance:GetGameUIManager()
    if UIManager then
        local ToastUI = UIManager:GetUIObj("GuideTextFloat" .. 100011)
        if ToastUI then
            ToastUI:DeleteGuideMessage(100011)
            AlreadyDeleteToast = true
        end
    end
end

function BP_TempleEnergySupply_C:ResetToastInfo()
    bIsToastShowed = false
    AlreadyDeleteToast = false
    self.InToastDisPlayer = {}
end

--副本波次存储专用
function BP_TempleEnergySupply_C:GetDungeonSaveData()
    return {
        StateId = self.StateId,
        NowEnergy = self.NowEnergy,
        BuffNum = self.BuffNum,
        }
end

function BP_TempleEnergySupply_C:ActiveMaterialNotify()
    
end

function BP_TempleEnergySupply_C:ShowInteractedToast(PlayerEid)
    local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState:ShowInteractedToast(PlayerEid)
end

----------UI事件----------------

-- --因为lua添加了EffectSourceInterface，需要重写这个方法，不然EffectSourceInterface会覆盖父类方法
-- function BP_TempleEnergySupply_C:GetObjType()
--     return EObjType.CombatItemBase
-- end
AssembleComponents(BP_TempleEnergySupply_C)
return BP_TempleEnergySupply_C

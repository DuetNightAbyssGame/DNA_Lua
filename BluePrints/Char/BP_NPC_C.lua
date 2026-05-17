require "DataMgr"
require "UnLua"
local MiscUtils = require "Utils.MiscUtils"
local TalkAudioComp_C = require "BluePrints.Story.Talk.Controller.TalkAudioComp"
local StoryPlayableUtils = require "BluePrints.Story.StoryPlayableUtils"
local ClientEventUtils = require "BluePrints.Common.ClientEvent.ClientEventUtils"

---@class BP_NPC_C : BP_NpcCharacterBase_C
local BP_NPC_C = Class({
"BluePrints.Char.BP_NpcCharacterBase_C",
})

local NpcLogType = UE.EStoryLogType.NPC

-- function BP_NPC_C:Initialize(Initializer)
--     BP_NPC_C.Super.Initialize(self)
--     self.MaxAlertValue = 9999
--     self.AlertResetChange = -100
-- end

--function BP_NPC_C:UserConstructionScript()
--end

function BP_NPC_C:ReceiveBeginPlay()
    -- BP_NPC_C.Super.ReceiveBeginPlay(self)

    ---------- CharacterBase Beginplay Begin
    rawset(self, "AutoSyncProp", self.AutoSyncProp)
	-- self.RelativeMeshTransform = self.Mesh:GetRelativeTransform()
    EventManager:AddEvent(EventID.OnBattleReady, self, self.OnBattleReady_TryInitCharacterInfo)
    EventManager:AddEvent(EventID.EnableNpcSideBubble, self, self.TryEnableNpcSideBubble)
    EventManager:AddEvent(EventID.OnNpcEnterOrQuitSpecialQuest, self, self.UpdateNpcSpecialState)

    -- self:InitFSM()
	-- self.RagdollStateType = ERagdollStateType.None

    -- lua 定义，C++定义的初始化放C++
    -- self.WallJumpCount = 0
    -- self.LastZSpeed = nil
    -- self.StartWallJumpTime = 0
    -- self.OriginCapsuleRadius = self.CapsuleComponent:GetUnscaledCapsuleRadius()
    -- self.OriginHalfHeight = self.CapsuleComponent:GetUnscaledCapsuleHalfHeight()

    -- 受击相关
    -- self.CacheInfos = {}
    -- self:InitCacheInfos()
    -- self.HitMontageSuffix = {}
    -- self.HitMonatgeIndex = {}
    -- self.ReplaceHitTypeTable = {}
    -- self.HitTimeMap = {}


    self.LuaTimerHandles = {}
    -- self.OverlapPushCallback = self.OverlapPushCallback or {}

    -- if UGameplayStatics.GetGameInstance(self).ImmersionModel then
    --     self.CapsuleComponent:SetHiddenInGame(true,false)
    -- end

    -- self:SetCharacterTagIdle()

    -- self.CharacterFashion:ReceiveBeginPlay()

    --------- CharacterBase Beginplay End

    if IsValid(self.NS_NPC_Weita) then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
            self.NS_NPC_Weita:K2_DestroyComponent(self)
            DebugPrint("NS_NPC_Weita Destroyed")
        end
    end
    self.IsDestroied = false
    self.IsShowSideIndicator = false
    self.IsInSpecialQuest = false
    self.IsNeedCollapsedOtherBubble = false
    --if not IsAuthority(self) then
    --    self.InitTags:Add("WaitForInitComponent", false)
    --    self:AddTimer(0.01, self.RemoveWaitInitTagInitComponent, false, 0.01, "RemoveWaitInitTagInitComponent")
    --end
    -- if self.ExecuteInLuaDelegate then
    --     self.ExecuteInLuaDelegate:Add(self,self.CallFromCPPDelegete)
    -- end
end

--function BP_NPC_C:RemoveWaitInitTagInitComponent()
--    self:TryInitCharacterInfo("WaitForInitComponent")
--end

function BP_NPC_C:OnBattleReady_TryInitCharacterInfo(_Battle)
    if Battle(self) == _Battle then
        self:TryInitCharacterInfo("Battle")
    end
end


function BP_NPC_C:AuthorityInitInfo(Info)
    BP_NPC_C.Super.AuthorityInitInfo(self,Info)
    if self.NpcAnimInstance then
        self.NpcAnimInstance.CanTurn = self.CanTurn
    end
end

function BP_NPC_C:CommonInitInfo(Info)
    BP_NPC_C.Super.CommonInitInfo(self, Info)
    self:InitInfo(Info)
end

-- function BP_NPC_C:InitAttributeFromTable(InitFromAnimInst)
--     if self:IsPhantom() then
--         BP_NPC_C.Super.InitAttributeFromTable(self,InitFromAnimInst)
--     end
-- end

function BP_NPC_C:OnCharacterReady(Info)
    BP_NPC_C.Super.OnCharacterReady(self, Info)
end

-- function BP_NPC_C:ClientInitInfo(Info)--已移C++
--     self:InitInfo(Info)
--     if(self.NpcAnimInstance) then
--         if(self.NpcData.DefaultAction) then
--             local FinialPath = self:JointFinalAnimPath(self.NpcId,self.NpcData.DefaultAction)
--             local DefaultAnim = LoadObject(FinialPath)
--             self.NpcAnimInstance:SetNpcDefaultAnimEnable(true)
--             self.NpcAnimInstance:SetNpcDefaultAnim(DefaultAnim)
--         end
--         if(self.NpcData.IsSit == 1) then
--             self:SetSitPoseInteractive()
--             -- self.IsSitting = true
--         end
--     end

--     self:InitNpcInteractiveComponent()
-- end

function BP_NPC_C:OverrideOnPostInitSucc(Func)
    self.OnPostInitSucc = Func
end

function BP_NPC_C:JointFinalAnimPath(UnitId,Path)
    local ModelId = DataMgr.Npc[UnitId].ModelId
    
    assert(ModelId,"Can't find model id for npc: "..UnitId)
    local ModelData = DataMgr.Model[ModelId]
    local MontageFolder = ModelData.MontageFolder
    local Prefix = ModelData.MontagePrefix
    -- 将MontageFolder中的Montage替换为Sequence
    local SequenceFolder = string.gsub(MontageFolder,"Montage","Sequence")
    DebugPrint(UnitId,ModelId,"SequenceFolder",SequenceFolder,"Prefix",Prefix)
    return SequenceFolder.."Interactive/"..Prefix..Path
end

function BP_NPC_C:JointFinalAnimPathMechInteractive(UnitId,Path)
    local ModelId = DataMgr.Npc[UnitId].ModelId
    
    assert(ModelId,"Can't find model id for npc: "..UnitId)
    local ModelData = DataMgr.Model[ModelId]
    local MontageFolder = ModelData.MontageFolder
    local Prefix = ModelData.MontagePrefix
    -- 将MontageFolder中的Montage替换为Sequence
    local SequenceFolder = string.gsub(MontageFolder,"Montage","Sequence")
    DebugPrint(UnitId,ModelId,"SequenceFolder",SequenceFolder,"Prefix",Prefix)
    return SequenceFolder.."Interactive/MechInteractive/"..Prefix..Path
end

function BP_NPC_C:AuthorityCommonInitMonsterInfo()
    BP_NPC_C.Super.AuthorityCommonInitMonsterInfo(self)
end

-- Npc 初始化
-- function BP_NPC_C:InitInfo(Info)
--     self.UnitType = Info.UnitType
--     -- self.NpcId = Info.UnitId
--     self.NpcData = DataMgr[Info.UnitType][self.NpcId]
--     self.NpcTalkInteractiveComponent:Init()
--     self.bInStory = Info.bInStory
--     self:NewInitDefaultFacial()
-- end

-- function BP_NPC_C:NewInitInfo(UnitType, UnitId, bInStory)
--     self.UnitType = UnitType
--     -- self.NpcId = UnitId
--     self.NpcData = DataMgr[UnitType][self.UnitId]
--     self.NpcTalkInteractiveComponent:Init()
--     self.bInStory = bInStory
--     self:NewInitDefaultFacial() 
-- end

function BP_NPC_C:ReceiveEndPlay()
    BP_NPC_C.Super.ReceiveEndPlay(self)
    EventManager:RemoveEvent(EventID.EnableNpcSideBubble, self)
    EventManager:RemoveEvent(EventID.TalkEnableMonsterSpawn, self)
    EventManager:RemoveEvent(EventID.OnNpcEnterOrQuitSpecialQuest, self)

	local GameState = UE4.UGameplayStatics.GetGameState(self)
    GameState:RecordNpcEntity(self, false)
    if self.IsSitting then
        self:SetIdlePose(nil, nil)
    end
    self:UnRegisterHeadUI()
    self.IsDestroied = true
    -- if self.ExecuteInLuaDelegate then
    --     self.ExecuteInLuaDelegate:Remove(self,self.CallFromCPPDelegete)
    -- end
end

function BP_NPC_C:CallFromCPPDelegete(Type)
    DebugPrint("NPC:CallFromCPPDelegete",Type)
end

function BP_NPC_C:ForceResetDynamics()
    if self.Mesh then
        self.Mesh:ResetAnimInstanceDynamics(ETeleportType.ResetPhysics)
    end
end

function BP_NPC_C:ResetDynamicsWithCurrentMontageSection(InNewMontageName, InNewSection)
    if self.CurrentAnimationMontageSectionName == "" then
        return
    end
    if self.CurrentAnimationMontageSectionName == InNewMontageName then
        return
    end
    DebugPrint("LHQPlayMontage DoRest NewMontageName:", InNewMontageName, "Section:", InNewSection, "CurrentNewMontageName:", self.CurrentAnimationMontageSectionName)
    if self.Mesh then
        self.Mesh:ResetAnimInstanceDynamics(ETeleportType.ResetPhysics)
    end
end

--function BP_NPC_C:ReceiveActorBeginOverlap(OtherActor)
--end

--function BP_NPC_C:ReceiveActorEndOverlap(OtherActor)
--end

function BP_NPC_C:CheckCanPart()
    return true
end

-- function BP_NPC_C:GetObjType()
--     return EObjType.NpcCharacter
-- end

function BP_NPC_C:StartTalkContext(TalkId, PlayerActor)
    self.NpcTalkInteractiveComponent:StartTalkContext(TalkId, PlayerActor)
end

function BP_NPC_C:IsCustomNPC()
    return self.Hair_SM ~= nil
end

function BP_NPC_C:StartOral(VoiceName, OralBaked)
    self:StopOral(self.CurrentVoiceName)
    self.CurrentVoiceName = VoiceName

    self:BeginLipSync(OralBaked)
end

function BP_NPC_C:StopOral(VoiceName)
    if (self.CurrentVoiceName ~= VoiceName) then
        return
    end

    self:EndLipSync()
end

-- 提供口型测试的代码，正式运行不调用
function BP_NPC_C:StartSequentialDialogueLipSync(StartDialogueId)
    if not self.TalkAudioComp then
        self.TalkAudioComp = TalkAudioComp_C.New()
    end

    self.CurrentDialogueSequentialId = StartDialogueId
    self.LipSyncComponent.OnBlendStop:Add(self, self.DialogueNextLipSync)
    self:DialogueNextLipSync()
end

function BP_NPC_C:DialogueNextLipSync()
    local DialogueInfo = DataMgr.Dialogue[self.CurrentDialogueSequentialId]
    if not DialogueInfo then
        self:StopSequentialDialogueLipSync()
        return
    end
    local VoiceName = DialogueInfo.VoiceName
    if not VoiceName then
        self:StopSequentialDialogueLipSync()
        return
    end
    local NPC = nil
    local DisableMouth = DialogueInfo.DisableMouth -- 默认不填则开启，填了不开启
    if not DisableMouth then
        NPC = self
    end

    self.TalkAudioComp:PlayAudio(VoiceName, NPC, nil, DialogueInfo)
    self.CurrentDialogueSequentialId = self.CurrentDialogueSequentialId + 1
end

function BP_NPC_C:StopSequentialDialogueLipSync()
    self.LipSyncComponent.OnBlendStop:Remove(self, self.DialogueNextLipSync)
    self.CurrentDialogueSequentialId = nil
end

function BP_NPC_C:IsNeedHideInTalk()
    return false
end

function BP_NPC_C:SetSitPoseInteractive(CallBackFunc, IsImmediately)
    if self.IsSitting == true then
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        return
    end
    self.IsSitting = true
    local Result = TArray(AActor)
    local SeatClass = UE4.AMechanismBase
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self:K2_GetActorLocation(),FVector(50,50,150), nil, SeatClass, nil, Result)
    if Result:Length() > 0 then
        self.CurrentSeat = Result[1]
        self.CurrentSeat:OpenMechanismWithoutInteractive(self, CallBackFunc, IsImmediately)
    else
        UE4.UKismetSystemLibrary.BoxOverlapActors(self, self:K2_GetActorLocation(),FVector(100,100,150), nil, SeatClass, nil, Result)
        if Result:Length() > 0 then
            self.CurrentSeat = Result[1]
            self.CurrentSeat:OpenMechanismWithoutInteractive(self, CallBackFunc, IsImmediately)
        else
            self.MaxCounter = 0
            self:AddTimer(5, function()
                DebugPrint("RunSafe Sit NpcUnitId:", self.UnitId, self:GetName())
                UE4.UKismetSystemLibrary.BoxOverlapActors(self, self:K2_GetActorLocation(),FVector(100,100,150), nil, SeatClass, nil, Result) 
                self.MaxCounter = self.MaxCounter + 1 
                if self.MaxCounter > 20 then
                    self:RemoveTimer("SafeSit")
                end 
                if Result:Length() > 0 then
                    self.CurrentSeat = Result[1]
                    self.CurrentSeat:OpenMechanismWithoutInteractive(self, CallBackFunc, IsImmediately)
                    self:RemoveTimer("SafeSit")
                end
            end, true, 0, "SafeSit")
            EventManager:FireEvent(EventID.OnNpcPoseChange)
        end
    end
end

function BP_NPC_C:SetSitPoseWithoutInteractive(CallBackFunc, IsImmediately, MontageObj)
    if self.IsSitting == true then
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        return
    end
    self.IsSitting = true
    self.IsSpecialSit = true
    self:SetCharacterTag("Seating")
    self.CapsuleComponent:IgnoreActorWhenMoving(self,true)
    local AllNeedIgnoreActor = TArray(AActor)
    local StaticMeshResult = TArray(AActor)
    local MeshClass = UE4.AStaticMeshActor
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), nil, MeshClass, nil, StaticMeshResult)
    for _, Actor in pairs(StaticMeshResult) do
        if Actor then
            self.CapsuleComponent:IgnoreActorWhenMoving(Actor, true)
            AllNeedIgnoreActor:Add(Actor)
        end
    end
    local MechanismResult = TArray(AActor)
    local MechanismClass = UE4.AMechanismBase
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), nil, MechanismClass, nil, MechanismResult)
    for _, Actor in pairs(MechanismResult) do
        if Actor then
            self.CapsuleComponent:IgnoreActorWhenMoving(Actor, true)
            AllNeedIgnoreActor:Add(Actor)
        end
    end
    -- UE4.UKismetSystemLibrary.DrawDebugBox(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), UE4.FLinearColor(1,0,0,1), self:K2_GetActorRotation(), 100)

    if self:GetMovementComponent() then
        self:GetMovementComponent().GravityScale = 0
        if not self:GetMovementComponent():IsComponentTickEnabled() then
            self:GetMovementComponent():SetComponentTickEnabled(true)
        end

        self:GetMovementComponent():OnNpcSeatingBegin()
    end
    self:ResetLocation(AllNeedIgnoreActor)
    
    if self.NpcAnimInstance then
        self.NpcAnimInstance.EnableDataFootIK = false
    end

    local DefaultMontageNames = DataMgr.Npc[self.UnitId].DefaultAction
    local DefaultMontageName = nil
    if self.StaticCreatorDefaultActionIndex and self.StaticCreatorDefaultActionIndex > 0 and DefaultMontageNames and DefaultMontageNames[self.StaticCreatorDefaultActionIndex] then
        DefaultMontageName = DefaultMontageNames[self.StaticCreatorDefaultActionIndex]
    end

    if self.UnitId and DataMgr.Npc[self.UnitId] and DataMgr.Npc[self.UnitId].SpecialSit then
        DefaultMontageName = DataMgr.Npc[self.UnitId].SpecialSit
    end

    if MontageObj then
        UE4.UPlayMontageCallbackProxy.CreateProxyObjectForPlayMontage(self.Mesh, MontageObj, 1, 0)
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        if CallBackFunc then
            CallBackFunc()
        end
        self:AddTimer(3,function ()
            local HasSection = self.Mesh:GetAnimInstance():IsPlayingMontagesContainsSection("Loop") or self.Mesh:GetAnimInstance():IsPlayingMontagesContainsSection("SitLoop")
            if HasSection then
                if self:GetMovementComponent() and self:GetMovementComponent().OnNpcSeatingEnd then
                    self:GetMovementComponent():OnNpcSeatingEnd(EMovementMode.MOVE_NavWalking)
                end
                self:SetNpcMovementTickEnable(false)
            end
            self:RemoveTimer("DelayCloseNpcMovementTickBySit")
        end, true, 0, "DelayCloseNpcMovementTickBySit")
        return
    end

    if IsImmediately == nil or IsImmediately == false then
        self:PlayTalkAction(DefaultMontageName, {self, function()
            if CallBackFunc then
                CallBackFunc()
            end
            self:AddTimer(3,function ()
                local HasSection = self.Mesh:GetAnimInstance():IsPlayingMontagesContainsSection("Loop") or self.Mesh:GetAnimInstance():IsPlayingMontagesContainsSection("SitLoop")
                if self:GetMovementComponent() and self:GetMovementComponent().OnNpcSeatingEnd then
                    self:GetMovementComponent():OnNpcSeatingEnd(EMovementMode.MOVE_NavWalking)
                end
                if HasSection then
                    self:SetNpcMovementTickEnable(false)
                end
                self:RemoveTimer("DelayCloseNpcMovementTickBySit")
            end, true, 0, "DelayCloseNpcMovementTickBySit")
            EventManager:FireEvent(EventID.OnNpcPoseChange)
        end})
    else
        local MontageName = nil
        local MontagePrePath = "Interactive/"
        local TalkActionData = DataMgr.TalkAction[DefaultMontageName]
        if TalkActionData then
            MontageName = TalkActionData.ActionMontage.."_Montage" or MontageName
            MontagePrePath = TalkActionData.MontagePrePath or MontagePrePath
        end
        
        local MontPath = self:GetMontagePath(MontagePrePath, MontageName)
        UResourceLibrary.LoadObjectAsync(self,MontPath,{self, function (_, Montage)
            if self.NpcAnimInstance then
                if self.NpcAnimInstance:IsMontageHasSection(Montage, "Loop") then
                    UE4.UPlayMontageCallbackProxy.CreateProxyObjectForPlayMontage(self.Mesh, Montage, 1, 0, "Loop")
                elseif self.NpcAnimInstance:IsMontageHasSection(Montage, "SitLoop") then
                    UE4.UPlayMontageCallbackProxy.CreateProxyObjectForPlayMontage(self.Mesh, Montage, 1, 0, "SitLoop")
                end
            end
            EventManager:FireEvent(EventID.OnNpcPoseChange)
            if CallBackFunc then
                CallBackFunc()
            end
            self:AddTimer(3,function ()
                local HasSection = self.Mesh:GetAnimInstance():IsPlayingMontagesContainsSection("Loop") or self.Mesh:GetAnimInstance():IsPlayingMontagesContainsSection("SitLoop")
                if self:GetMovementComponent() and self:GetMovementComponent().OnNpcSeatingEnd then
                    self:GetMovementComponent():OnNpcSeatingEnd(EMovementMode.MOVE_NavWalking)
                end
                if HasSection then
                    self:RemoveTimer("DelayCloseNpcMovementTickBySit")
                end
                self:SetNpcMovementTickEnable(false)
            end, true, 0, "DelayCloseNpcMovementTickBySit")
        end})
        return
    end
    self:AddTimer(0.1, function()
        local Section = self.Mesh:GetAnimInstance():Montage_GetCurrentSection()
        if Section == "SitLoop" then
            EventManager:FireEvent(EventID.OnNpcPoseChange)
        end
        self:RemoveTimer("SitToLoop")
    end, true, 0, "SitToLoop")
end

function BP_NPC_C:SetSitPoseWithInteractiveAndNoDown(CallBackFunc)
     if self.IsSitting == true then
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        return
    end
    self.IsSitting = true
    local Result = TArray(AActor)
    local SeatClass = UE4.AMechanismBase
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self:K2_GetActorLocation(),FVector(50,50,150), nil, SeatClass, nil, Result)
    if Result:Length() > 0 then
        self.CurrentSeat = Result[1]
        self.CurrentSeat:OpenMechanismNpcSpecial(self, CallBackFunc)
        self:RealSetSitPoseWithInteractiveAndNoDown(CallBackFunc)
    else
        UE4.UKismetSystemLibrary.BoxOverlapActors(self, self:K2_GetActorLocation(),FVector(100,100,150), nil, SeatClass, nil, Result)
        if Result:Length() > 0 then
            self.CurrentSeat = Result[1]
            self.CurrentSeat:OpenMechanismNpcSpecial(self, CallBackFunc)
            self:RealSetSitPoseWithInteractiveAndNoDown(CallBackFunc)
        else
            self.MaxCounter = 0
            self:AddTimer(5, function()
                DebugPrint("RunSafe Sit NpcUnitId:", self.UnitId, self:GetName())
                UE4.UKismetSystemLibrary.BoxOverlapActors(self, self:K2_GetActorLocation(),FVector(100,100,150), nil, SeatClass, nil, Result) 
                self.MaxCounter = self.MaxCounter + 1 
                if self.MaxCounter > 20 then
                    self:RemoveTimer("SafeSit")
                end 
                if Result:Length() > 0 then
                    self.CurrentSeat = Result[1]
                    self.CurrentSeat:OpenMechanismNpcSpecial(self, CallBackFunc)
                    self:RealSetSitPoseWithInteractiveAndNoDown(CallBackFunc)
                    self:RemoveTimer("SafeSit")
                end
            end, true, 0, "SafeSit")
            EventManager:FireEvent(EventID.OnNpcPoseChange)
        end
    end
end

function BP_NPC_C:RealSetSitPoseWithInteractiveAndNoDown(CallBackFunc)
    self.IsSitting = true
    self.IsSpecialSit = true
    self:SetCharacterTag("Seating")
    self.CapsuleComponent:IgnoreActorWhenMoving(self,true)

    local StaticMeshResult = TArray(AActor)
    local MeshClass = UE4.AStaticMeshActor
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), nil, MeshClass, nil, StaticMeshResult)
    for _, Actor in pairs(StaticMeshResult) do
        if Actor then
            self.CapsuleComponent:IgnoreActorWhenMoving(Actor, true)
        end
    end
    local MechanismResult = TArray(AActor)
    local MechanismClass = UE4.AMechanismBase
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), nil, MechanismClass, nil, MechanismResult)
    for _, Actor in pairs(MechanismResult) do
        if Actor then
            self.CapsuleComponent:IgnoreActorWhenMoving(Actor, true)
        end
    end
    -- UE4.UKismetSystemLibrary.DrawDebugBox(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), UE4.FLinearColor(1,0,0,1), self:K2_GetActorRotation(), 100)
    self:GetMovementComponent():LockMovementMode(true, EMovementMode.Move_Walking)

    if self:GetMovementComponent() then
        self:GetMovementComponent().GravityScale = 0
        if not self:GetMovementComponent():IsComponentTickEnabled() then
            self:GetMovementComponent():SetComponentTickEnabled(false)
        end
    end

    self:K2_SetActorLocation(self.BrothLoc, false, nil, false)
    
    if self.NpcAnimInstance then
        self.NpcAnimInstance.EnableDataFootIK = false
    end

    local DefaultMontageNames = DataMgr.Npc[self.UnitId].DefaultAction
    local DefaultMontageName = nil
    if self.StaticCreatorDefaultActionIndex and self.StaticCreatorDefaultActionIndex > 0 and DefaultMontageNames and DefaultMontageNames[self.StaticCreatorDefaultActionIndex] then
        DefaultMontageName = DefaultMontageNames[self.StaticCreatorDefaultActionIndex]
    end
    local MontagePath = self:GetNpcTalkActionPath(DefaultMontageName)

    UResourceLibrary.LoadObjectAsync(self, MontagePath, {self, function(_, Montage)
            if Montage then
                local PlayParam = {
		        StartSec = "Loop",
            	}
	            MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, Montage, PlayParam)
                if CallBackFunc then
                    CallBackFunc()
                end
                EventManager:FireEvent(EventID.OnNpcPoseChange)
            end
    end})

    -- self:PlayTalkAction(DefaultMontageName, {self, function()
    --     if CallBackFunc then
    --         CallBackFunc()
    --     end
    --     EventManager:FireEvent(EventID.OnNpcPoseChange)
    -- end})
end

function BP_NPC_C:GetStandNearlyStaticMeshAndMechanism()
    local AllActor = TArray(AActor)
    local StaticMeshResult = TArray(AActor)
    local MeshClass = UE4.AStaticMeshActor
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), nil, MeshClass, nil, StaticMeshResult)
    for _, Actor in pairs(StaticMeshResult) do
        if Actor then
            AllActor:Add(Actor)
        end
    end
    local MechanismResult = TArray(AActor)
    local MechanismClass = UE4.AMechanismBase
    UE4.UKismetSystemLibrary.BoxOverlapActors(self, self.RootComponent:K2_GetComponentLocation(), FVector(80, 80, 30), nil, MechanismClass, nil, MechanismResult)
    for _, Actor in pairs(MechanismResult) do
        if Actor then
            AllActor:Add(Actor)
        end
    end

    return AllActor
end

function BP_NPC_C:GetNpcTalkActionPath(InActionId)
    local TalkActionData = DataMgr.TalkAction[InActionId]
	if (TalkActionData == nil) then
		Utils.ScreenPrint("ActionId 不存在:" .. tostring(InActionId))
		return ""
	end
	local MontagePath = ""
    local ModelData = DataMgr.Model[self.ModelId]
    if TalkActionData.MontagePrePath == nil or TalkActionData.MontagePrePath == "" then
	    MontagePath = string.format("%sInteractive/%s%s_Montage", ModelData.MontageFolder, ModelData.MontagePrefix, TalkActionData.ActionMontage)
    else
        MontagePath = string.format("%s%s/%s%s_Montage", ModelData.MontageFolder, TalkActionData.MontagePrePath, ModelData.MontagePrefix, TalkActionData.ActionMontage)
    end

    return MontagePath
end

function BP_NPC_C:MoveToSeat(Loc, Rot)
    if Loc == nil or Rot == nil then
        DebugPrint("NPC Can not MoveToSeat Loc == nil or Rot == nil ",self:GetName())
        return
    end
    DebugPrint("NPC MoveToSeat:",self:GetName())
    self:GetMovementComponent().GravityScale = 0
    self:K2_SetActorLocationAndRotation(Loc, Rot, false, nil, false)
end

function BP_NPC_C:SetIdlePose(NeedMontage, Callback)
    if self.IsSitting == false then
        DebugPrint("NPC Was already Standing :", self:GetName(), self.UnitId)
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        return
    end
    self.IsSitting = false
    
    if self.UnitId and DataMgr.Npc[self.UnitId] and DataMgr.Npc[self.UnitId].SpecialSit and DataMgr.Npc[self.UnitId].IsSit == 2 then
        self:RealSetIdlePoseBySpecialSit(Callback)
        return
    end

    if not self.CurrentSeat then
        print(_G.LogTag,"Error: LXZ not self.CurrentSeat")
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        return
    end

    if NeedMontage then
        self.CurrentSeat:CloseMechanismWithoutInteractive(self, Callback)
    else
        self.CurrentSeat:CloseMechanismWithoutMontage(self)
    end
end

function BP_NPC_C:RealSetIdlePoseBySpecialSit(Callback, IsImmediately, Montage)
    if self.IsSitting == true then
        self.IsSitting = false
    end
    self:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true

    if Montage then
        UE4.UPlayMontageCallbackProxy.CreateProxyObjectForPlayMontage(self.Mesh, Montage, 1, 0)
        if Callback then
            Callback()
        end
    else
        if IsImmediately == nil or IsImmediately == false then
            if self.NpcAnimInstance then
                if self.NpcAnimInstance:IsPlayingMontagesSection("End") then
                    self.Mesh:GetAnimInstance():Montage_JumpToSection("End")
                elseif self.NpcAnimInstance:IsPlayingMontagesSection("SitEnd") then
                    self.Mesh:GetAnimInstance():Montage_JumpToSection("SitEnd")
                end
            end
        else
            if self.NpcAnimInstance then
                if self.NpcAnimInstance:IsPlayingMontagesSection("End") then
                    self.Mesh:GetAnimInstance():Montage_JumpToSectionsEnd("End")
                elseif self.NpcAnimInstance:IsPlayingMontagesSection("SitEnd") then
                    self.Mesh:GetAnimInstance():Montage_JumpToSectionsEnd("SitEnd")
                end
            end
        end
    end

    self.IsSpecialSit = false
    self:SetNpcMovementTickEnable(true)

    -- local NewCallBack = function ()
    --     if(Callback) then Callback() end
    --     EventManager:FireEvent(EventID.OnNpcPoseChange)
    --     self:SetCharacterTag("Idle")
    --     if self.SetNpcMovementTickEnable then
    --         self:SetNpcMovementTickEnable(false)
    --     end
    -- end
    -- local AllCallback = 
    -- {
    --     OnCompleted = NewCallBack,
    -- }
    self.StandCallBack = function()
        -- local DefaultMontageName = "Interactive_SitEnd_Montage"
        -- self:PlayActionMontage("Interactive/MechInteractive", DefaultMontageName, AllCallback, false, true,true)
        if(Callback) then Callback() end
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        self:SetCharacterTag("Idle")
        if self.SetNpcMovementTickEnable then
            self:SetNpcMovementTickEnable(false)
        end
        self.Mesh:GetAnimInstance().OnMontageEnded:Remove(self, self.StandCallBack)
        -- self:GetMovementComponent():LockMovementMode(false, EMovementMode.Move_Walking)
    end
    self.Mesh:GetAnimInstance().OnMontageEnded:Add(self, self.StandCallBack)
end

function BP_NPC_C:InitNpcInteractiveComponent()
    local NpcData = DataMgr[self.UnitType][self.UnitId]
    if not NpcData then
        return
    end
    if NpcData.InteractiveInfo then
        for InteractiveType, CommonUIConfirmID in pairs(NpcData.InteractiveInfo) do
            if DataMgr.InteractiveInfo[InteractiveType].BPPath then
                if self[InteractiveType.."Component"] == nil then
                    UResourceLibrary.LoadClassAsync(self, DataMgr.InteractiveInfo[InteractiveType].BPPath, { 
                        self, function(_, ClassObject)
                            self:OnInteractiveComponentClassLoaded(ClassObject, CommonUIConfirmID, InteractiveType)
                        end
                    })
                end
            end
        end
    end
    if NpcData.NpcBiographyId then
        local BiographyData = DataMgr.NpcBiography[NpcData.NpcBiographyId]
        if self.BiographyComponent == nil then
            UResourceLibrary.LoadClassAsync(self, DataMgr.InteractiveInfo["Biography"].BPPath, { 
                self, function(_, ClassObject)
                    self:OnInteractiveComponentClassLoaded(ClassObject, 100011, "Biography")
                end
            })
        end
    end
end


function BP_NPC_C:ReinitDefaultFacial()
    self:NewInitDefaultFacial()
end

function BP_NPC_C:InitDefaultFacial()
    local NpcInfo = DataMgr.Npc[self.UnitId]
    if NpcInfo and NpcInfo.DefaultExpression then
        DebugPrint("BP_NPC_C:InitDefaultFacial", self:GetName(), self.UnitId)
        self:NewPlayFacial(NpcInfo.DefaultExpression)
    end
end

-- function BP_NPC_C:InitDefaultAnimation()
--     local NpcInfo = DataMgr.Npc[self.UnitId]
--     if NpcInfo and NpcInfo.DefaultAction then
--         DebugPrint("BP_NPC_C:InitDefaultAnimation", self:GetName(), self.UnitId)
--         self:PlayTalkAction(NpcInfo.DefaultAction)
--     end
-- end

function BP_NPC_C:NewPlayAction(InDefaultAction)
    self:PlayTalkAction(InDefaultAction)
end

function BP_NPC_C:PlayDefaultAnimation(CallBackObj)
    local NpcInfo = DataMgr.Npc[self.UnitId]
    if NpcInfo and NpcInfo.DefaultAction then
        DebugPrint("BP_NPC_C:PlayDefaultAnimation", self:GetName(), self.UnitId)
        local DefaultMontageNames = NpcInfo.DefaultAction
        local DefaultMontageName = nil
        if self.StaticCreatorDefaultActionIndex and self.StaticCreatorDefaultActionIndex > 0 and DefaultMontageNames and DefaultMontageNames[self.StaticCreatorDefaultActionIndex] then
            DefaultMontageName = DefaultMontageNames[self.StaticCreatorDefaultActionIndex]
        end
        self:PlayTalkAction(DefaultMontageName, CallBackObj)
    end
end

function BP_NPC_C:StopDefaultAnimation()
    local NpcInfo = DataMgr.Npc[self.UnitId]
    if NpcInfo and NpcInfo.DefaultAction then
        DebugPrint("BP_NPC_C:StopDefaultAnimation", self:GetName(), self.UnitId)
        local DefaultMontageNames = NpcInfo.DefaultAction
        local DefaultMontageName = nil
        if self.StaticCreatorDefaultActionIndex and self.StaticCreatorDefaultActionIndex > 0 and DefaultMontageNames and DefaultMontageNames[self.StaticCreatorDefaultActionIndex] then
            DefaultMontageName = DefaultMontageNames[self.StaticCreatorDefaultActionIndex]
        end
        self:StopTalkAction(DefaultMontageName)
    end
end

function BP_NPC_C:PlayDefaultAnimStartAnimation(CallFunc)
    local NpcInfo = DataMgr.Npc[self.UnitId]
    local DefaultMontageNames = NpcInfo.DefaultAction
    local DefaultMontageName = nil
    if self.StaticCreatorDefaultActionIndex and self.StaticCreatorDefaultActionIndex > 0 and DefaultMontageNames and DefaultMontageNames[self.StaticCreatorDefaultActionIndex] then
        DefaultMontageName = DefaultMontageNames[self.StaticCreatorDefaultActionIndex]
    end
    if DefaultMontageName and DataMgr.TalkAction[DefaultMontageName] and DataMgr.TalkAction[DefaultMontageName].AnimationId then
        local StartAnimName = self:GetStartOrEndAnimtionName(DataMgr.TalkAction[DefaultMontageName].AnimationId, "Start")
        -- self:PlayTalkAction(StartAnimName, CallBackObj)
        local MontagePath = self:GetNpcTalkActionPath(StartAnimName)
         UResourceLibrary.LoadObjectAsync(self, MontagePath, {self, function(_, Montage)
            if Montage then
                local PlayParam = {
		        StartSec = "Start",
                OnCompleted = CallFunc,
            	}
	            MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, Montage, PlayParam)
            end
        end})
    else
        -- StoryPlayableUtils:ExecuteStoryDelegate(CallBackObj)
        if CallFunc then
            CallFunc()
        end
    end
end

function BP_NPC_C:PlayTalkGroupEndAnimation(CallFunc)
   if self.CurrentTalkGroupMontageName ~= nil then
        local EndAnimName = self:GetStartOrEndAnimtionName(self.CurrentTalkGroupMontageName,  "End")
        local MontagePath = self:GetNpcTalkActionPath(EndAnimName)
        -- self:PlayTalkAction(EndAnimName, CallBackObj)
        if MontagePath ~= "" then
            UResourceLibrary.LoadObjectAsync(self, MontagePath, {self, function(_, Montage)
                if Montage and self.NpcAnimInstance and self.NpcAnimInstance:Montage_IsPlaying(Montage) then
                    self.NpcAnimInstance:Montage_JumpToSection("End")
                    local EndSectionTime = self.NpcAnimInstance:GetMontageSectionTime("End")
                    self:AddTimer(EndSectionTime, function ()
                    if CallFunc then
                        CallFunc()
                    end
                    
                    self:RemoveTimer("EndAnimationBackTimer")
                    end, false, 0,"EndAnimationBackTimer")
                else
                    if CallFunc then
                        CallFunc()
                    end
                end
            end})
        else
            if CallFunc then
                CallFunc()
            end
        end
    else
        -- StoryPlayableUtils:ExecuteStoryDelegate(CallBackObj)
        if CallFunc then
            CallFunc()
        end
    end
end

function BP_NPC_C:GetStartOrEndAnimtionName(AnimName, Postfix)
    local lastUnderscorePos = string.match(AnimName, ".*()_")
    -- 如果找到了下划线
    if lastUnderscorePos then
        -- 获取下划线之前和之后的部分
        local prefix = string.sub(AnimName, 1, lastUnderscorePos - 1)
        local retName = prefix.."_"..Postfix
        if DataMgr.TalkAction[retName] then
            return retName
        else
            return ""
        end
    else
        -- 如果没有下划线，返回原字符串和空字符串
        return ""
    end
end

function BP_NPC_C:OnLuaCleanAllTimer()
    local NpcData = DataMgr[self.UnitType][self.UnitId]
    if NpcData then
        if NpcData.InteractiveInfo then
            for InteractiveType, CommonUIConfirmID in pairs(NpcData.InteractiveInfo) do
                if DataMgr.InteractiveInfo[InteractiveType].BPPath then
                    self[InteractiveType.."Component"] = nil
                end
            end
        end
    end
    self.BiographyComponent = nil
end

function BP_NPC_C:OnInteractiveComponentClassLoaded(ClassObject, CommonUIConfirmID, InteractiveType)
    ---@type BP_InteractiveBaseComponent_C
    local Component = self:AddInteractiveComponent(ClassObject)

    if not IsValid(Component) then return end
    Component:InitCommonUIConfirmID(CommonUIConfirmID)
    if InteractiveType then
        self[InteractiveType.."Component"] = Component
    end
end

--region UStoryPlayableInterface
---@return FVector
function BP_NPC_C:GetFreeCameraOffset()
    return self.NpcTalkInteractiveComponent:GetSimpleTalkCenterOffset()
end

---@param SoundPath string
---@param bPlayAs2D boolean
function BP_NPC_C:PlayTalkSound(SoundPath, bPlayAs2D)
    if (SoundPath == nil) then
        DebugPrint("Error: Play talk sound failed, sound path is nil.")
        return
    end
    bPlayAs2D = bPlayAs2D or true

    local AudioManager = AudioManager(self)
    if (AudioManager == nil) then
        DebugPrint("Error: Play talk sound failed, AudioManager is nil.")
    end

    local LocalizationSoundPath = string.gsub(SoundPath, "%$Locale%$", AudioManager:GetLanguage())
    local EventPath = "event:/" .. LocalizationSoundPath
    local Event = UE4.UFMODBlueprintStatics.FindEventbyName(EventPath)
    AudioManager:PlayNormalSound(self, Event, EventPath, Const.TalkSoundKey, bPlayAs2D)
end

function BP_NPC_C:StopTalkSound()
    local AudioManager = AudioManager(self)
    assert(AudioManager, "Stop talk sound failed, AudioManager is nil.")
    AudioManager:StopSound(self, Const.TalkSoundKey)
end

function BP_NPC_C:PlayFacial(FacialId)
    local FacialData = DataMgr.Facial[FacialId]
    if (FacialData == nil) then
        local Message = string.format("找不到表情数据，NpcId: %s，表情Id: %s", self.NpcData.UnitId, FacialId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, NpcLogType, "表情数据缺失/配置错误", Message)
        return
    end

    if (FacialData.NpcEye) then
        self:PlayFacialMontage(FacialData.NpcEye, FacialData.Eye1BlendInTime,nil,true)
    end

    if (FacialData.NpcMouth) then
        self:PlayFacialMontage(FacialData.NpcMouth,nil,nil,true)
    end

    if (FacialData.SoundBaseMouth) then
        self:PlayFacialMontage(FacialData.SoundBaseMouth,nil,nil,true)
    end
end

function BP_NPC_C:StopFacial()
    if (self.NpcAnimInstance == nil) then
        return
    end
    self.NpcAnimInstance:Montage_StopGroupByName(0, Const.CharacterFacialMouthMontageGroupName)
    self.NpcAnimInstance:Montage_StopGroupByName(0, Const.CharacterFacialEyeMontageGroupName)
end

function BP_NPC_C:PlayFacialMontage(MontageName, BlendInTime, PlayParams,bLoadAsync)
    if (MontageName == nil) then
        local Message = string.format("Play facial montage failed, montage name is nil, NpcId: %s", self.NpcData.UnitId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, NpcLogType, "表情蒙太奇资源缺失/配置错误", Message)
        return
    end

    PlayParams = PlayParams or { PlayRate = 1, StartPos = 0, StartSec = 'Default'}

    local MontagePath = self:GetFacialMontagePath(MontageName)

    if bLoadAsync then
        UResourceLibrary.LoadObjectAsync(self,MontagePath,{self,function (_,MontageObj)
            if (IsValid(MontageObj) == false) then
                local Message = string.format("Play facial montage failed, montage is invalid, NpcId: %s, MontagePath: %s", self.NpcData.UnitId, MontagePath)
                UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, NpcLogType, "表情蒙太奇资源缺失/配置错误", Message)
                return
            end
            if (BlendInTime) then
                UTalkFunctionLibrary.SetMontageBlendInTime(MontageObj, BlendInTime)
            end
            -- MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, MontageObj, PlayParams)
            if self.NpcAnimInstance then
                self.NpcAnimInstance:Montage_Play(MontageObj, 1.0)
            end
        end})
        return
    end

    local Montage = LoadObject(MontagePath)
    if (IsValid(Montage) == false) then
        local Message = string.format("Play facial montage failed, montage is invalid, NpcId: %s, MontagePath: %s", self.NpcData.UnitId, MontagePath)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, NpcLogType, "表情蒙太奇资源缺失/配置错误", Message)
        return
    end

    if (BlendInTime) then
        UTalkFunctionLibrary.SetMontageBlendInTime(Montage, BlendInTime)
    end

    -- MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh, Montage, PlayParams)
    if self.NpcAnimInstance then
        self.NpcAnimInstance:Montage_Play(Montage, 1.0)
    end
end

function BP_NPC_C:GetFacialMontagePath(MontageName)
    local ModelData = DataMgr.Model[self.NpcData.ModelId]
    if (ModelData == nil) then
        local Message = string.format("找不到模型数据，NpcId: %s，模型Id: %s", self.NpcData.UnitId, self.NpcData.ModelId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, NpcLogType, "表情模型数据缺失/配置错误", Message)
        return
    end
    local FacePrefix = ""
    if ModelData.MontageFacePrefix ~= nil then
        FacePrefix = ModelData.MontageFacePrefix
        return string.format("%sFacial/%s%s_Montage", ModelData.MontageFolder, FacePrefix, MontageName)
    end
    return string.format("%sFacial/%s%s_Montage", ModelData.MontageFolder, ModelData.MontagePrefix, MontageName)
end
--endregion UStoryPlayableInterface

function BP_NPC_C:TickActorGlobalTimeDilation()
    if not self.NpcData.GlobalGameUITagList then
        return
    end
    local CurGameInstance = GWorld.GameInstance
    local CurGameMode = UE4.UGameplayStatics.GetGameMode(self)

    if not CurGameInstance or not CurGameMode then
        return
    end
    local flag = UE4.UGameplayStatics.IsGamePaused(CurGameMode)
    local GameInstanceTag = CurGameInstance:GetGlobalGameUITag()

    for _, v in pairs(self.NpcData.GlobalGameUITagList) do
        if CurGameInstance:GetGlobalGameUITag() == v and UE4.UGameplayStatics.IsGamePaused(CurGameMode)then
            self:SetActorImmunePause(self, false)
            return
        end
    end
end

function BP_NPC_C:TriggerFaceBlend(bOpen)
    if self.NpcAnimInstance then
        self.NpcAnimInstance.bForbiddenFaceByActionData = bOpen
    end
end

function BP_NPC_C:SetActorsImmunePause(TargetActors,bImmune)
    if not TargetActors then
        return
    end

    for _,TargetActor in pairs(TargetActors) do
        self:SetActorImmunePause(TargetActor, bImmune)
   end
end

function BP_NPC_C:SetActorImmunePause(TargetActor, bImmune)
    if TargetActor ~= nil and  IsValid(TargetActor) then
        TargetActor:SetTickableWhenPaused(bImmune)
        --Get components, non-recursive for now 
        local Components = TargetActor:K2_GetComponentsByClass(UActorComponent:StaticClass())
            if Components then
            for _, _Component in pairs(Components) do
                _Component:SetTickableWhenPaused(bImmune)
            end
        end

        if URuntimeCommonFunctionLibrary.ObjIsChildOf(TargetActor, ACharacterBase) then
            local Attaches = TargetActor:GetAllAttaches()
            if Attaches then
                self:SetActorsImmunePause(Attaches, bImmune)
            end
        end
    end
end

---@param ActionId FName
---@param OnFinished FOnStoryActionFinished
function BP_NPC_C:PlayUITalkAction(ActionId, OnFinished)
    local TalkActionInfo = DataMgr.NPCDialogue[ActionId]
    assert(TalkActionInfo, string.format("%s 在 NPCDialogue 表中不存在。", ActionId))

    local MontagePath = TalkActionInfo.ActionMontage
    local Montage = LoadObject(MontagePath)
    assert(Montage, string.format("%s 不存在", MontagePath))

    if TalkActionInfo.EndLoopMontage then
        local OnMontageFinished = function()
            local EndLoopMontagePath = TalkActionInfo.EndLoopMontage
            local EndLoopMontage = LoadObject(EndLoopMontagePath)
            assert(EndLoopMontage, string.format("%s 不存在", EndLoopMontage))
            UE4.UPlayMontageCallbackProxy.CreateProxyObjectForPlayMontage(self.Mesh, EndLoopMontage, 1, 0, TalkActionInfo.EndLoopMontageSection)
            if (type(OnFinished) == "table") then
                OnFinished[2](OnFinished[1])
            end
        end
        local MontParam = 
        {
            OnCompleted = OnMontageFinished,
            StartSec = TalkActionInfo.MontageSection,
            OnInterrupted = OnMontageFinished,
        }
        MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh,  Montage, MontParam)
    else
        local OnMontageFinished = function()
            if (type(OnFinished) == "table") then
                OnFinished[2](OnFinished[1])
            end
        end
        local MontParam = 
        {
            OnCompleted = OnMontageFinished,
            StartSec = TalkActionInfo.MontageSection,
            OnInterrupted = OnMontageFinished,
        }
        MiscUtils.PlayMontageBySkeletaMesh(self, self.Mesh,  Montage, MontParam)
    end
end

function BP_NPC_C:TriggerNpcGlobalTimeDilation(IsPause)
    self:SetActorImmunePause(self, IsPause)
end

--region UStoryPlayableInterface
function BP_NPC_C:PreEnterStory(OnFinished, bCacheMeshMaterials, bPauseBT)
    if (self.bEnterStory) then
        StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        return
    end

    self.bEnterStory = true

    if bCacheMeshMaterials then
        self.CharacterFashion:CacheMeshMaterials(self.Mesh)
        self.CharacterFashion:ReplaceMeshAllDynamicMaterialAsParent(self.Mesh)
    end

    self:AddTimer(0.01, function()
        self.NativeMeshTickOptions = {}
        self.NativeInSetShadow = {}
        local SKMeshComps = self:K2_GetComponentsByClass(USkeletalMeshComponent):ToTable()
        for _, SKMeshComp in pairs(SKMeshComps) do
            if (IsValid(SKMeshComp)) then
                self.NativeMeshTickOptions[SKMeshComp] = SKMeshComp.VisibilityBasedAnimTickOption
                SKMeshComp.VisibilityBasedAnimTickOption = EVisibilityBasedAnimTickOption.AlwaysTickPoseAndRefreshBones
                self.NativeInSetShadow[SKMeshComp] = SKMeshComp.bCastInsetShadow
                SKMeshComp:SetCastInsetShadow(true)
            end
        end
    end)

    if (bPauseBT and self.StopBT) then
        self:StopBT("Talk")
    end

    local WorldCompositionSubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UWorldCompositionSubSystem)
    if (IsValid(WorldCompositionSubSystem)) then
        WorldCompositionSubSystem:UnregisterEntryToWorldComposition(self)
    end

    -- bInStory 被用于生成销毁逻辑
    self.bInStory = true

    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
end

function BP_NPC_C:PreExitStory(OnFinished, bStartBT, bIsExternal)
    if (not self.bEnterStory) then
        StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
        return
    end

    self.bEnterStory = false

    local MaterialArray = TArray(UMaterialInterface)
    self.CharacterFashion:UncacheMeshMaterials(self.Mesh, MaterialArray)
    self.CharacterFashion:SetMeshMaterials(self.Mesh, MaterialArray)

    for SKMeshComp, TickOption in pairs(self.NativeMeshTickOptions or {}) do
        if (IsValid(SKMeshComp)) then
            SKMeshComp.VisibilityBasedAnimTickOption = TickOption
        end
    end
    self.NativeMeshTickOptions = nil

    for SKMeshComp, bCastInsetShadow in pairs(self.NativeInSetShadow or {}) do
        if (IsValid(SKMeshComp)) then
            SKMeshComp:SetCastInsetShadow(bCastInsetShadow)
        end
    end
    self.NativeInSetShadow = nil
    if (bStartBT and self.RestartBT) then
        self:RestartBT()
    end

    local Controller = self:GetController()
    if Controller and Controller.BrainComponent and Controller.BrainComponent:IsRunning() then
        self:SwitchEnableAnimInstanceIK(false)
    end

    local EMGameState = UE4.UGameplayStatics.GetGameState(self)
    EMGameState:HideNpc(false, Const.TalkHideTag, self)

    if (bIsExternal) then
        local WorldCompositionSubSystem = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UWorldCompositionSubSystem)
        if (IsValid(WorldCompositionSubSystem)) then
            WorldCompositionSubSystem:RegisterEntryToWorldComposition(self)
        end
    else
        self:EMActorDestroy(EDestroyReason.TalkContext)
    end

    self.bInStory = false

    StoryPlayableUtils:ExecuteStoryDelegate(OnFinished)
end

function BP_NPC_C:IsInStory()
    return self.bInStory
end

-----------------------NPC看板娘配饰相关逻辑---------------------------
--初始化Npc的配饰 只有看板娘需要
function BP_NPC_C:InitNpcAccessories(CharId)
    local Avatar = GWorld:GetAvatar()
    -- local AccessorySuit = {}
    -- local IsShowPartMesh
    -- local IsShowHorn
    if Avatar then
        for _ , Char in pairs(Avatar.Chars) do
            if Char.CharId == CharId then
                local AppearanceSuit = Char:DumpAppearanceSuit(Avatar)
                -- AccessorySuit,IsShowPartMesh,IsShowHorn = 
                if(self.CurrentCompositeMesh) then 
                    self.CurrentCompositeMesh = nil
                end
                self:LoadCurrentModel()
                self:InitAppearanceSuit(AppearanceSuit)
                break
            end
        end
    end
end

function BP_NPC_C:InitNpcAccessoriesInStory(CharId)
    self:InitNpcAccessories(CharId)
end

-- function BP_NPC_C:GetCharAccessory(Char)
--     local AccessorySuit = {}
--     local IsShowPartMesh
--     local IsShowHorn
--     local Avatar = GWorld:GetAvatar()
--     local CharAccessorySuit = Char.CharAccessorySuits[Char.CharAccessorySuitIndex]
--     IsShowPartMesh = Char:GetShowPartMesh(Char.CharAccessorySuitIndex)
--     IsShowHorn = Char.IsCornerVisible
--     if not CharAccessorySuit then
--         return AccessorySuit,IsShowPartMesh,IsShowHorn
--     end
--     local AccessorySlot,AccessoryId
--     for _, AccessoryType in pairs(CommonConst.CharAccessoryTypes) do
--         AccessorySlot = CharAccessorySuit[AccessoryType .. "Decoration"]
--         AccessoryId = nil
--         if(AccessorySlot)then
--             local Uuid = AccessorySlot:GetJewelry()
--             AccessoryId = Uuid and Avatar.CharAccessorys[Uuid].AccessoryId
--         end
--         AccessorySuit[AccessoryType] = AccessoryId
--     end
--     return AccessorySuit,IsShowPartMesh,IsShowHorn
-- end

--刷新看板娘配饰
function BP_NPC_C:RefreshNpcAccessories(Char)
    -- local AccessorySuit,IsShowPartMesh,IsShowHorn = self:GetCharAccessory(Char)
    -- self:InitAccessories({
    --     AccessorySuit = AccessorySuit,
    --     IsShowPartMesh = IsShowPartMesh,
    --     IsShowHorn = IsShowHorn,
    --     CharId = Char.CharId,
    -- })
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local AppearanceSuit = Char:DumpAppearanceSuit(Avatar)
        if(self.CurrentCompositeMesh) then 
            self.CurrentCompositeMesh = nil
        end
        self:LoadCurrentModel()
        self:InitAppearanceSuit(AppearanceSuit)
    end
end

function BP_NPC_C:RefreshNpcAccessoriesInStory()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CharAvatar = Avatar.Chars[Avatar.CurrentChar]
    if not CharAvatar then
        return
    end
    self:InitAppearanceSuit({})
end

-----------------------------↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓--NPC重构抽出的函数--↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓-----------------------------

-- -- NPC不跑TickMonsterBattleComponent
-- function BP_NPC_C:TickMonsterBattleComponent()
-- end

--endregion

-- function BP_NPC_C:AddMonsterToInfo(Info)
--     local GameState = UE4.UGameplayStatics.GetGameState(self)
--     GameState.NpcMap:Add(self.Eid, self)
-- end

function BP_NPC_C:CommonOnEMActorDestroy(DestroyReason)
    --self:ClearFXComponent()
    self.GameplayTagsTable = nil
end

function BP_NPC_C:OnEMActorDestroy_Lua(DestroyReason)
    local GameMode = UGameplayStatics.GetGameMode(self)
    -- NewRegionEnable

    if IsValid(self.CurrentSeat) then
        self.CurrentSeat:CloseMechanismNpcSpecial(self)
    end

    if self.UnitId == 818054 then
        self:RemoveTimer("TempSetMoveMode")
    end

    if GameMode then
        GameMode:GetRegionDataMgrSubSystem():DeadRegionActorData(self, DestroyReason, GameMode:GetActorLevelName(self))
    end
    
    self:CommonOnEMActorDestroy(DestroyReason)
    if IsAuthority(self) then
        self:ServerOnEMActorDestroy(DestroyReason)
    end
    -- self.InitSuccess = false

    -- if (IsClient(self) or IsStandAlone(self)) and self.TeammateUI then
    --     local BattleMain = UIManager(self):GetUIObj("BattleMain")
    --     if BattleMain then
    --         BattleMain:RemoveTeammateUI(self.TeammateUI)
    --     end
    --     self.TeammateUI = nil
    -- end
end

function BP_NPC_C:ServerOnEMActorDestroy(DestroyReason)
    -- -- 触发副本事件
    -- local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    -- if NormalDeath then
    --     GameMode:TriggerEMActorDestoryEvent(self, nil)
    -- end
    self:ServerClearMonsterExtraInfo(DestroyReason)
end

-- function BP_NPC_C:InitBTMotionParams()
--     -- 初始化行为树移动参数
-- end

-- function BP_NPC_C:InitBTBattleParams()
--     -- 初始化行为树战斗参数
-- end

function BP_NPC_C:PlayMonsterBirthFX()
end

function BP_NPC_C:GetBlueprintPath()
    return self.Data.UnitBPPath
end

-- function BP_NPC_C:GetOwnBlackBoardComponent()
--     if self.OwnBlackBoardComponent == nil then
--         self.OwnBlackBoardComponent = UE4.UAIBlueprintHelperLibrary.GetBlackboard(self)
--     end
--     return self.OwnBlackBoardComponent
-- end

-- function BP_NPC_C:RealOnDead(KillMineRoleEid, KillMineSkillId, DeathReason)
--     DebugPrint("ERROR: NPC Can not Die:  Npc->UnitId:"..self.UnitId.." Npc->Eid:   " .. self.Eid.." Npc->CreatorId:   " .. self.CreatorId.." Npc->CreatorType:   " .. self.CreatorType.." Npc->Bornpos:   " , self.BornPos)
-- end

-- function BP_NPC_C:RegisterHeadUI()
--     local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self) 
--     --DebugPrint("RegisterHeadUI",self,HeadUISubsystem)
--     if IsValid(HeadUISubsystem) then
--         HeadUISubsystem:OnNpcReady(self)
--     end
-- end

-- function BP_NPC_C:UnRegisterHeadUI()
--     local HeadUISubsystem = UNpcHeadUISubsystem.GetHeadUISubsystem(self)
--     if IsValid(HeadUISubsystem) then
--         HeadUISubsystem:OnNpcEndPlay(self)
--     end
-- end


function BP_NPC_C:TempSetNpcData(InNpcId)
    local NpcData = DataMgr.Npc[InNpcId]
    if InNpcId and InNpcId > 0 and NpcData ~= nil then
        self.UnitType = "Npc"
        self.NpcId = InNpcId
        -- self.NpcData = NpcData
        self.bInStory = true
        local GameState = UE4.UGameplayStatics.GetGameState(self)
        local Npc = GameState.NpcCharacterMap:FindRef(self.UnitId)
        if GameState and Npc == nil then
            GameState.NpcCharacterMap:Add(self.UnitId, self)
        end
    end
end

function BP_NPC_C:InitNpcSideQuestBubbleBrush(InQuestChainId)
    if self.HeadWidgetComponent and self.HeadWidgetComponent:GetWidget() then
        if DataMgr.QuestChain[InQuestChainId] and DataMgr.QuestChain[InQuestChainId].QuestChainType == Const.SpecialSideQuestChainType then
            self.HeadWidgetComponent:GetWidget().Com_GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(LoadObject("/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SpSideMission_Un.T_Gp_SpSideMission_Un"))
        else
            self.HeadWidgetComponent:GetWidget().Com_GuidePoint.Img_GuidePoint_Icon:SetBrushResourceObject(LoadObject("/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_SideMission_Un.T_Gp_SideMission_Un"))
        end
    end
end

function BP_NPC_C:UpdateNpcSpecialState()
    local Avatar = GWorld:GetAvatar()
	if Avatar then
        self.IsInSpecialQuest = Avatar.InSpecialQuest
	end
end

function BP_NPC_C:TryEnableNpcSideBubble(InNpcId, IsEnable)
    if MissionIndicatorManager.MissionNpcSideBubbles[self.UnitId] and InNpcId == self.UnitId and IsEnable then
        self.IsShowSideIndicator = IsEnable
        self:InitNpcSideQuestBubbleBrush(MissionIndicatorManager.MissionNpcSideBubbles[self.UnitId])
        self:EnableNpcSideBubbleWidget(IsEnable)
    elseif IsEnable == false and InNpcId == self.UnitId then
        self.IsShowSideIndicator = IsEnable
        self:EnableNpcSideBubbleWidget(IsEnable)
    end
end

function BP_NPC_C:EnableHeadIconWidget(bEnable)
    if self.IsNeedCollapsedOtherBubble == false then
        self:EnableHeadWidget("HeadIcon", bEnable, self)
    else
        self:EnableHeadWidget("HeadIcon", false, self)
    end
end

function BP_NPC_C:EnableNpcSideBubbleWidget(bEnable)
    if self.IsShowSideIndicator and bEnable and (self.IsInSpecialQuest == false or self.IsInSpecialQuest == nil) then
        self:EnableHeadWidget("NpcSideIndicator", bEnable, self)
    else
        self:EnableHeadWidget("NpcSideIndicator", false, self)
    end
end

function BP_NPC_C:CollapsedOtherBubble()
    self:EnableHeadIconWidget(false)
    self:EnableImpressionWidget(false)
end

function BP_NPC_C:EnableImpressionWidget(bEnable)
    if self.IsNeedCollapsedOtherBubble == false then
        self:EnableHeadWidget("Impression", bEnable, self)
    else
        self:EnableHeadWidget("Impression", false, self)
    end
end

function BP_NPC_C:EnableNameWidget(bEnable)
    local NpcData = DataMgr[self.UnitType][self.UnitId]
    local Name = (NpcData and NpcData.UnitName) or ""
    self:EnableHeadWidget("Name", bEnable, GText(Name))
end

function BP_NPC_C:EnableBubbleWidget(bEnable, Content, Style)
    self:EnableHeadWidget("Bubble", bEnable, Content, Style)
end

function BP_NPC_C:EnableBubbleRewardWidget(bEnable)
    self:EnableHeadWidget("Bubble_Reward", bEnable)
end

function BP_NPC_C:GetHitMontageRule()
    return nil
end

function BP_NPC_C:GetHitMontageFolderAndPrefix()
    return nil, nil
end

function BP_NPC_C:DisableInteractiveScene(bDisable)
    self.bDisableInteractiveScene = bDisable
end

function BP_NPC_C:IsbDisableInteractiveScene()
    return self.bDisableInteractiveScene or false
end

-----------------------------↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑--NPC重构抽出的函数--↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑-----------------------------

function BP_NPC_C:ResetLocation(IgNorActors)
    if self.Data and self.Data.IgnoreFixLocation == true then
        return
    end
	local SpawnPos = self:K2_GetActorLocation()
	local HalfHeight = self.CapsuleComponent:GetScaledCapsuleHalfHeight()
    local Radius = self.CapsuleComponent:GetScaledCapsuleRadius()
	-- local MeshOffsetZ = -self.Mesh.RelativeLocation.Z
    -- if MeshOffsetZ > HalfHeight and MeshOffsetZ < HalfHeight + 5 then
    --     HalfHeight = MeshOffsetZ
    -- end
    local Start = SpawnPos+ FVector(0,0,math.max(HalfHeight - Radius, Radius))
    local StartLine = SpawnPos+ FVector(0,0,HalfHeight)
	local End = SpawnPos + FVector(0,0,-500)
	local HitResult = FHitResult()
    local HitResultLine = FHitResult()
    local OffsetZ = HalfHeight - Radius
    local Ret = UE4.UKismetSystemLibrary.CapsuleTraceSingle(self, Start, End, Radius, Radius, ETraceTypeQuery.TraceScene, false, IgNorActors, 0, HitResult, true)
    local RetLine = UE4.UKismetSystemLibrary.LineTraceSingle(self, StartLine, End, ETraceTypeQuery.TraceScene, false, IgNorActors, 0, HitResultLine, true)
	if Ret and RetLine and HitResult.ImpactPoint.Z - HitResultLine.Location.Z > Radius then
        DebugPrint("BP_NPC_C CapsuleTraceSingle 打中位置：",HitResult.ImpactPoint,"打中目标：",HitResult.Actor:GetName(),"Pawn名字：",self:GetName())
        Ret = RetLine
        HitResult = HitResultLine
        OffsetZ = HalfHeight
    end
	if(Ret) then
        local SurfacePos = FVector(HitResult.Location.X,HitResult.Location.Y,HitResult.Location.Z + OffsetZ)
        DebugPrint("BP_NPC_C半高：",HalfHeight,"打中位置：",HitResult.ImpactPoint,"打中目标：",HitResult.Actor:GetName(),"Pawn名字：",self:GetName(),"SurfacePos：", SurfacePos,"============sssss================")
		self:K2_SetActorLocation(SurfacePos, false, nil, false)
        if math.abs(HitResult.ImpactPoint.Z - SpawnPos.Z) > HalfHeight * 2 then
            Utils.ScreenPrint("BP_NPC_C静态刷新点位置异常,Pawn名字：" .. self:GetName() .. " SpawnPos.Z："  .. SpawnPos.Z .. " ImpactPoint.Z:" .. HitResult.ImpactPoint.Z)
        end
	end

    self:AdjustNpcFloorHeight()
end

function BP_NPC_C:TriggerFallingCallable()
    -- NPC暂时不触发FallTrigger
    return
end

function BP_NPC_C:TriggerWaterFallingCallable()
    -- NPC暂时不触发FallTrigger
    return
end

function BP_NPC_C:GetTalkInteractiveComponent()
    return self.NpcTalkInteractiveComponent
end

function BP_NPC_C:ClearCharacterBattleInfo(NormalDeath, DeathReason)
    BP_NPC_C.Super.ClearCharacterBattleInfo(self, NormalDeath, DeathReason)
    self.IsSitting = false
end

function BP_NPC_C:EnableSkeletalMeshActorRules(bEnable)
    if (bEnable) then
        self.NativeMeshName = self.Mesh:GetName()
        self.NativeMeshTransform = self.Mesh:GetRelativeTransform()

        UE4.URuntimeCommonFunctionLibrary.ObjectRename(self.Mesh, "SkeletalMeshComponent0")
        self.Mesh:ResetRelativeTransform()
        self:SetNpcMovementTickEnable(false)
    else
        UE4.URuntimeCommonFunctionLibrary.ObjectRename(self.Mesh, self.NativeMeshName)
        self.Mesh:K2_SetRelativeTransform(self.NativeMeshTransform, false, nil, true)
        self:SetNpcMovementTickEnable(true)

        self.NativeMeshName = nil
        self.NativeMeshTransform = nil
    end
end

return BP_NPC_C

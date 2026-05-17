--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_RegionOnlineSeat_C
local M = Class("BluePrints.Item.Mechanism.Seat.BP_SeatBase_C")

local OnlineActionController = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController"

function M:ReceiveBeginPlay()
    M.Super.ReceiveBeginPlay(self)
    self.DefaultInteractiveComponent.MergeName = nil
end

function M:CommonInitInfo(Info)
    self.SenderId = Info.NameParams:Find("Sender") or ""
    self.ResourceId = Info.IntParams:Find("ResourceId")
    local UniqueId = Info.NameParams:Find("UniqueId")
    print(_G.LogTag,"LXZ CommonInitInfo", UniqueId, self.SenderId, Info.NameParams:Find("Sender"))
    if self.UniqueId == "None" and UniqueId then
        self.UniqueId = Info.NameParams:Find("UniqueId")
    end
    M.Super.CommonInitInfo(self,Info)
end

function M:OnActorReady(Info)
    M.Super.OnActorReady(self,Info)
    local GameState = UGameplayStatics.GetGameState(self)
    if GameState:CheckDeleteRegionMechanism(self.UniqueId) then
        GameState:RemoveDeleteRegionMechanism(self.UniqueId)
        GameState:RemoveMechanismRegionOnline(self.UniqueId, EDestroyReason.OwnerLeaveRegion)
    end
end

function M:SendServerStartInteractive(PlayerActorEid)
    local Avatar = GWorld:GetAvatar()
    local Point = self:FindPoint(PlayerActorEid)
    local InteractiveId = Point.Index--待定
    local AvatarEid = Avatar.Eid
    if self.SenderId and self.SenderId ~= "" then
        AvatarEid = CommonUtils.Str2ObjId(self.SenderId)
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Apply_Sent"))
    local Player = Battle(self):GetEntity(PlayerActorEid)
    Player.WaitRegionOnlineSeatCB = true
    Avatar:RequestChangeRegionOnlineItemState(Avatar.CurrentOnlineType, self.UniqueId, AvatarEid, InteractiveId, self.StateId)
end

function M:OpenMechanism(PlayerActorEid)
    if not Battle(self) then
        return
    end
    local Avatar = GWorld:GetAvatar()
    -- print(_G.LogTag,"LXZ OpenMechanism", PlayerActorEid, self:GetName(), self.PlayerAndSeat[PlayerActorEid], self.SenderId, Avatar.Eid)
    if self.PlayerAndSeat and self.PlayerAndSeat[PlayerActorEid] then
        return
    end
    local Player = Battle(self):GetEntity(PlayerActorEid)
    local Point = self:FindPoint(PlayerActorEid)
    local EnterPoint = Point:FindEnterPoint(PlayerActorEid)
    Point.IsUsed = true
    Point.EnterType = EnterPoint.Type
    self.PlayerAndSeat[PlayerActorEid] = Point
    local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    local IsMainPlayer = Player.Eid == MainPlayer.Eid
    local OwnerPlayer = Avatar:GetBornedChar(CommonUtils.Str2ObjId(self.SenderId)) or MainPlayer
    if IsMainPlayer then
        Player:AddForbidTag("Battle")
        local Transform = OwnerPlayer:GetTransform()
        Transform.Translation.Z = Transform.Translation.Z - OwnerPlayer.CapsuleComponent:GetScaledCapsuleHalfHeight() + Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
        Player:K2_SetActorTransform(Transform, false, nil, false) --拿脚的位置，减掉胶囊体半高
        self.PlayerMeshTrans = Player.Mesh:GetRelativeTransform()
        local PointTransform = Point:K2_GetComponentToWorld()
        print(_G.LogTag,"lxz OpenMechanism", Player.CapsuleComponent:GetScaledCapsuleHalfHeight())
        -- PointTransform.Translation.Z = PointTransform.Translation.Z - Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
        Player.Mesh:K2_SetWorldTransform(PointTransform,false,nil,false)
        Player.OnInteractiveDelegate:Add(self.ChestInteractiveComponent,self.ChestInteractiveComponent.EndInteractive)
        Player:GetMovementComponent():SetMovementMode(1)
        Player.CharSpringArmComponent.bArmCollision = false
        self.CameraProbeSize = Player.CharSpringArmComponent.CameraProbeSize
        Player.CharSpringArmComponent.CameraProbeSize = 2
        self:SetSittingParam(Player, Point, EnterPoint)

        local Controller=UE4.UGameplayStatics.GetPlayerController(self,0)
        Player:EnableInput(Controller)
        self:ClientPlayAnim(Player.Eid, 0, self.Eid)
        EventManager:FireEvent(EventID.OnOpenMechanism, self.Eid)
        UTalkFunctionLibrary.EnterHeadUIState(Player, EHeadWidgetLocationState.SpecialAction)
    else
        Player:GetMovementComponent().bForbidBalanceTick = true
        Player:SetTickEnabled(ETickCtrlType.DontNeedTick,ETickObjectFlag.FLAG_CHARMOVEMENTCOMPONENT,false)
        local Transform = OwnerPlayer:GetTransform()
        Transform.Translation.Z = Transform.Translation.Z - OwnerPlayer.CapsuleComponent:GetScaledCapsuleHalfHeight() + Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
        Player:K2_SetActorTransform(Transform, false, nil, false)
        self.PlayerMeshTrans = Player.Mesh:GetRelativeTransform()
        local PointTransform = Point:K2_GetComponentToWorld()
        -- PointTransform.Translation.Z = PointTransform.Translation.Z - Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
        Player.Mesh:K2_SetWorldTransform(PointTransform,false,nil,false)
        print(_G.LogTag,"lxz OpenMechanism other", Player.Mesh:GetRelativeTransform())
        Player:GetMovementComponent():SetMovementMode(1)
        self:SetSittingParam(Player, Point, EnterPoint)
        self:ClientPlayAnim(Player.Eid, 0, self.Eid)
        UTalkFunctionLibrary.EnterHeadUIState(Player, EHeadWidgetLocationState.SpecialAction)
    end
end

function M:CloseMechanism(PlayerActorEid, IsSuccess)
    if not Battle(self) then
        return
    end
    local Player = Battle(self):GetEntity(PlayerActorEid)
    local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    local IsMainPlayer = Player.Eid == MainPlayer.Eid
    if IsValid(Player) then
        Player:GetMovementComponent().bForbidBalanceTick = false
        Player:SetTickEnabled(ETickCtrlType.DontNeedTick,ETickObjectFlag.FLAG_CHARMOVEMENTCOMPONENT,true)
        print(_G.LogTag,"LXZ CloseMechanism", self.PlayerMeshTrans, Player:GetName(), Player.OnInteractiveDelegate)
        if IsMainPlayer then
            Player.OnInteractiveDelegate:Remove(self.ChestInteractiveComponent,self.ChestInteractiveComponent.EndInteractive)
            Player.CharSpringArmComponent.bArmCollision = true
            Player.CharSpringArmComponent.CameraProbeSize = self.CameraProbeSize
        end
        Player:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true
        Player.Mesh:K2_SetRelativeTransform(self.PlayerMeshTrans,false,nil,false)
        local EnterPoint = self:GetLeavingPoint(Player)
        if EnterPoint then
            self.PlayerAndSeat[Player.Eid].EnterType = EnterPoint.Type
            self:SetLeavingParam(Player, self.PlayerAndSeat[PlayerActorEid], EnterPoint)
            self:ClientPlayAnim(PlayerActorEid, 2, self.Eid)
        end
        UTalkFunctionLibrary.LeaveHeadUIState(Player, EHeadWidgetLocationState.SpecialAction)
    end
    if self.PlayerAndSeat[PlayerActorEid] then
        self.PlayerAndSeat[PlayerActorEid].IsUsed = false
        self.PlayerAndSeat[PlayerActorEid] = nil
    end
    --self:NotifyUIStop()
end

function M:ForceCloseMechanism(PlayerActorEid, IsSuccess)
    if not Battle(self) then
        return
    end
    local Player = Battle(self):GetEntity(PlayerActorEid)
    print(_G.LogTag,"LXZ ForceCloseMechanism", Player:GetName(), Player.OnInteractiveDelegate)
    Player.OnInteractiveDelegate:Remove(self.ChestInteractiveComponent,self.ChestInteractiveComponent.EndInteractive)
    Player.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_Block)
    Player:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true
    Player:GetMovementComponent():SetMovementMode(1)
    -- self.PlayerAndSeat[PlayerActorEid].IsUsed = false
    -- self.PlayerAndSeat[PlayerActorEid] = nil
end

function M:NotifyUIStop( )
    OnlineActionController:OnEndOnlineAction()
end
function M:PlayAnim(PlayerId, InteractiveState, MechanismEid)
    local Player = Battle(self):GetEntity(PlayerId)
    if InteractiveState == 0 then
        local Point = self.PlayerAndSeat[PlayerId]
        local MontageName = self.PointMontage:Find(Point.Index) or "Gesture_Car_Interactive_Montage"
        -- local MontageName = "Gesture_Car_Interactive_Montage"
        self.ChestInteractiveComponent:OnStartInteractive(Battle(self):GetEntity(PlayerId), MontageName, MechanismEid, "Gesture")
    end
    if InteractiveState == 1 then
        
    end
    if InteractiveState == 2 then
        print(_G.LogTag,"LXZ EndInteractive PlayAnim")
        Traceback()
        self.ChestInteractiveComponent:OnEndInteractive(Battle(self):GetEntity(PlayerId), self.ChestInteractiveComponent.MontageName, MechanismEid)
        Player:StopMontage()
        Player:GetMovementComponent().RootMotionZScale = 1
        -- Player.Mesh:GetAnimInstance():Montage_JumpToSection("SitEnd".."F")
    end
end

function M:CheckInteractiveIdValid(InteractiveId)
    if not self.PlayerAndSeat then
        return true
    end
    for i, v in pairs(self.PlayerAndSeat) do
        if v.Index == InteractiveId then
            return false
        end
    end
    return true
end

function M:OnEMActorDestroy(DestroyReason)
    if not Battle(self) then
        return
    end
    for PlayerEid, Comp in pairs(self.PlayerAndSeat) do
        local Player = Battle(self):GetEntity(PlayerEid)
        if IsValid(Player) then
            local InteractiveComp = self.ChestInteractiveComponent
            Player:DeInteractiveMechanism(self.Eid, PlayerEid, 0, true, InteractiveComp.NextStateId, true, Comp.Index)
        end
    end
    self.PlayerAndSeat = {}
    if self.SenderId then
        local GameState = UGameplayStatics.GetGameState(self)
        GameState.RegionOnlineMechanismMap:Remove(self.SenderId)
        GameState:RemovePlayerMechanismRegionOnline(self.SenderId, self.UniqueId, false)
    end
    M.Super.OnEMActorDestroy(self, DestroyReason)
end

--销毁的时候，服务端数据已经被清楚，不能通过avatar广播来解除交互
function M:ReceiveEndPlay(EndPlayReason)
    if not Battle(self) then
        return
    end
    for PlayerEid, Comp in pairs(self.PlayerAndSeat) do
        local Player = Battle(self):GetEntity(PlayerEid)
        if IsValid(Player) then
            self.ChestInteractiveComponent:EndInteractive(Player)
            Player.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_Block)
        end
    end
    self.PlayerAndSeat = {}
    if self.SenderId then
        local GameState = UGameplayStatics.GetGameState(self)
        GameState.RegionOnlineMechanismMap:Remove(self.SenderId)
        GameState:RemovePlayerMechanismRegionOnline(self.SenderId, self.UniqueId, false)
    end
    M.Super.ReceiveEndPlay(self, EndPlayReason)
end

function M:GetCanOpen(PlayerEid)    
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local AvatarEid = CommonUtils.ObjId2Str(Avatar.Eid)
    local IsOwner = AvatarEid == self.SenderId
    local Player = Battle(self):GetEntity(PlayerEid)
    local CharacterInfo = DataMgr.PlayerStateMachine[Player.AutoSyncProp.CharacterTag]
    self.CanOpen = not CharacterInfo["Seating"]
    if IsOwner or Player.WaitRegionOnlineSeatCB then
        self.CanOpen = false
        return 
    end
    -- M.Super.GetCanOpen(self, PlayerEid)
end
function M:IsForbidden(Player)
    local PointIndex = self:GetValidPoint()
    local CurrentName = self.ChestInteractiveComponent.InteractiveName
    for i, v in pairs(PointIndex) do
        if v.Valid or v.Eid == Player.Eid then
            -- local Data = DataMgr.CommonUIConfirm[self.ChestInteractiveComponent.CommonUIConfirmID]
            -- self.ChestInteractiveComponent.InteractiveName = GText(Data.ConfirmText)
            return false
        end
    end
    -- self.ChestInteractiveComponent.InteractiveName = "UI_RegionOnline_SitOccupied"
    return true
end

function M:GetInteractiveName(Player)
    if self.ChestInteractiveComponent:IsForbidden(Player) then
        return GText("UI_RegionOnline_SitOccupied")
    end
    local Data = DataMgr.CommonUIConfirm[self.ChestInteractiveComponent.CommonUIConfirmID]
    return GText(Data.ConfirmText)
end

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

return M

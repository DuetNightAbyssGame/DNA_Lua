--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local BP_SeatBase_C = Class("BluePrints.Item.Chest.BP_MechanismBase_C")
local UseNewNpcMoveComp = true
function BP_SeatBase_C:ReceiveBeginPlay()
    BP_SeatBase_C.Super.ReceiveBeginPlay(self)
    self.PointArray = self:K2_GetComponentsByClass(LoadClass('/Game/BluePrints/Item/Mechanism/Seat/BP_SeatPointComponent.BP_SeatPointComponent_C'):StaticClass())
    self.PlayerAndSeat = {}
    self.DefaultInteractiveComponent.MergeName = "Seat"
    if self.DefaultInteractiveComponent then
        self.DefaultInteractiveComponent.bCanUsed = true
        self.DefaultInteractiveComponent.IsDefault = true
        self.InteractiveComponents:Clear()
        self.InteractiveComponents:Add(self.DefaultInteractiveComponent)
        self.ChestInteractiveComponent = self.DefaultInteractiveComponent
    end
    -- self:InitActorInfo({
    --     UnitId = self.UnitId,
    --     UnitType = self.UnitType,
    -- })
end

function BP_SeatBase_C:BeginInitInfo()
    print(_G.LogTag,"LXZ BeginInitInfo", self.InitSuccess)
    if self.InitSuccess then
        local GameState = UGameplayStatics.GetGameState(self)
        GameState:FireRegionOnlineMechanismUser(self.UniqueId, self)
        return
    end
    self:InitActorInfo_New()
end

function BP_SeatBase_C:AuthorityInitInfo(Info)
    BP_SeatBase_C.Super.AuthorityInitInfo(self,Info)
    --self:RegisterToGameState()
end

function BP_SeatBase_C:CommonInitInfo(Info)
    BP_SeatBase_C.Super.CommonInitInfo(self,Info)
    self.ChestInteractiveComponent.DisPlayInteractiveName = GText(self.ChestInteractiveComponent.InteractiveName)
end

function BP_SeatBase_C:ClientInitInfo(Info)
    BP_SeatBase_C.Super.ClientInitInfo(self,Info)
end

function BP_SeatBase_C:OnActorReady(Info)
    BP_SeatBase_C.Super.OnActorReady(self,Info)
    local GameState = UGameplayStatics.GetGameState(self)
    GameState:FireRegionOnlineMechanismUser(self.UniqueId, self)
    if self.CacheOpenMechanismWithoutInteractive then
        local CharacterEid = self.CacheOpenMechanismWithoutInteractive.CharacterEid
        local Character = Battle(self):GetEntity(CharacterEid)
        local CallBackFunc = self.CacheOpenMechanismWithoutInteractive.CallBackFunc
        local SourceFunc = self.CacheOpenMechanismWithoutInteractive.SourceFunc
        SourceFunc(self, Character, CallBackFunc, false)
    end
end

function BP_SeatBase_C:SendServerStartInteractive(PlayerActorEid)
    if not Battle(self) then
        return
    end
    local Player = Battle(self):GetEntity(PlayerActorEid)
    self:SpecialRegionOnlineStartLogic(Player)
end

function BP_SeatBase_C:SendServerEndInteractive(PlayerActorEid)
    if not Battle(self) then
        return
    end
    local Player = Battle(self):GetEntity(PlayerActorEid)
    self:SpecialRegionOnlineEndLogic(Player)
end

function BP_SeatBase_C:OpenMechanism(PlayerActorEid)
    print(_G.LogTag,"LXZ OpenMechanism", PlayerActorEid, self:GetName(), self.PlayerAndSeat[PlayerActorEid])
    if self.PlayerAndSeat and self.PlayerAndSeat[PlayerActorEid] then
        return
    end
    local Player = Battle(self):GetEntity(PlayerActorEid)
    local Point = self:FindPoint(PlayerActorEid)
    local EnterPoint = Point:FindEnterPoint(PlayerActorEid)
    local FloorDist = math.max(Player:GetFloorInfo().FloorDist, 2.4)
    local RealZ = EnterPoint:K2_GetComponentLocation().Z + Player.CapsuleComponent.CapsuleHalfHeight + FloorDist
    local Loc = FVector(EnterPoint:K2_GetComponentLocation().X, EnterPoint:K2_GetComponentLocation().Y, RealZ)
    local Rot = EnterPoint:K2_GetComponentRotation()
    Point.IsUsed = true
    Point.EnterType = EnterPoint.Type
    self.PlayerAndSeat[PlayerActorEid] = Point
    local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    local IsMainPlayer = Player.Eid == MainPlayer.Eid
    print(_G.LogTag,"LXZ OpenMechanism00", self:GetName(), EnterPoint:K2_GetComponentLocation().Z, Player.CapsuleComponent.CapsuleHalfHeight, FloorDist)
    if IsMainPlayer then
        Player:AddForbidTag("Battle")
        local Controller=UE4.UGameplayStatics.GetPlayerController(self,0)
        Player:DisableInput(Controller)
        local handle = UE4.ULTweenBPLibrary.Vector3To(self,{self,function(_,value)
            Player.MoveInput = FVector(0,0,0)
            Player.MoveInputCache = FVector(0,0,0)
            Player.CharacterMovement:StopMovementImmediately()
            Player:K2_SetActorLocationAndRotation(value, Rot, false, nil, false)
        end},Player:K2_GetActorLocation(),Loc,0.1,0)
        -- handle:OnUpdate({self,function() print(_G.LogTag,"OpenMechanism22222222", Player:K2_GetActorRotation(), Player.MoveInputCache) end})
        handle:OnComplete({self,function() 
            Player:K2_SetActorLocationAndRotation(Loc, Rot, false, nil, false)
            Player.OnInteractiveDelegate:Add(self.ChestInteractiveComponent,self.ChestInteractiveComponent.EndInteractive)
            Player:GetMovementComponent():SetMovementMode(1)
            Player.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_OverLap)
            Player.CharSpringArmComponent.bArmCollision = false
            self.CameraProbeSize = Player.CharSpringArmComponent.CameraProbeSize
            Player.CharSpringArmComponent.CameraProbeSize = 2
            self:SetSittingParam(Player, Point, EnterPoint)
            self:ClientPlayAnim(Player.Eid, 0, self.Eid)
            Player:EnableInput(Controller)
            EventManager:FireEvent(EventID.OnOpenMechanism, self.Eid)
        end})
    else
        print(_G.LogTag,"LXZ OpenMechanism2222", Player:GetName(), Loc, Rot, Player:K2_GetActorLocation())
        if Player:GetFloorInfo().FloorDist > 0 then
            Player:K2_SetActorLocationAndRotation(Loc, Rot, false, nil, false)
        end
        -- Player:SetOtherWorldMoveAutonomous(true)
        Player:GetMovementComponent():SetMovementMode(1)
        Player.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_OverLap)
        self:SetSittingParam(Player, Point, EnterPoint)
        self:ClientPlayAnim(Player.Eid, 0, self.Eid)
    end
end

function BP_SeatBase_C:CloseMechanism(PlayerActorEid, IsSuccess)
    if not Battle(self) then
        return
    end
    local Player = Battle(self):GetEntity(PlayerActorEid)
    local MainPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
    if not IsValid(Player) or not IsValid(MainPlayer) then
        return
    end
    print(_G.LogTag,"LXZ CloseMechanism", MainPlayer, self)
    local IsMainPlayer = Player.Eid == MainPlayer.Eid
    if IsValid(Player) then
        -- Player:SetOtherWorldMoveAutonomous(false)
        if IsMainPlayer then
            Player.OnInteractiveDelegate:Remove(self.ChestInteractiveComponent,self.ChestInteractiveComponent.EndInteractive)
            Player.CharSpringArmComponent.bArmCollision = true
            Player.CharSpringArmComponent.CameraProbeSize = self.CameraProbeSize
        end
        Player:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true
        local EnterPoint = self:GetLeavingPoint(Player)
        if self.PlayerAndSeat[Player.Eid] then
            self.PlayerAndSeat[Player.Eid].EnterType = EnterPoint.Type
            self:SetLeavingParam(Player, self.PlayerAndSeat[PlayerActorEid], EnterPoint)
            self:ClientPlayAnim(PlayerActorEid, 2, self.Eid)
        end
    end
    if self.PlayerAndSeat[Player.Eid] then
        self.PlayerAndSeat[PlayerActorEid].IsUsed = false
        self.PlayerAndSeat[PlayerActorEid] = nil
    end
end

function BP_SeatBase_C:ForceCloseMechanism(PlayerActorEid, IsSuccess)
    local Player = Battle(self):GetEntity(PlayerActorEid)
    if IsMainPlayer then
        Player.OnInteractiveDelegate:Remove(self.ChestInteractiveComponent,self.ChestInteractiveComponent.EndInteractive)
    end
    Player.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_Block)
    Player:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true
    Player:GetMovementComponent():SetMovementMode(1)
    self.PlayerAndSeat[PlayerActorEid].IsUsed = false
    self.PlayerAndSeat[PlayerActorEid] = nil
end

function BP_SeatBase_C:PlayAnim(PlayerId, InteractiveState, MechanismEid)
    local Player = Battle(self):GetEntity(PlayerId)
    if InteractiveState == 0 then
        local MontageName = self.ChestInteractiveComponent.MontageName.."_"..self.PlayerAndSeat[Player.Eid].EnterType.."_Montage"
        self.ChestInteractiveComponent:OnStartInteractive(Battle(self):GetEntity(PlayerId), MontageName, MechanismEid)
    end
    if InteractiveState == 1 then
        
    end
    if InteractiveState == 2 then
        self.ChestInteractiveComponent:OnEndInteractive(Battle(self):GetEntity(PlayerId), self.ChestInteractiveComponent.MontageName, MechanismEid)
        -- local Type = self:GetLeavingType(Player)
        Player.Mesh:GetAnimInstance():Montage_JumpToSection("SitEnd"..self.PlayerAndSeat[Player.Eid].EnterType)
    end
end

function BP_SeatBase_C:GetCanOpen(PlayerEid)
    local tmp = true
    for i = 1,self.PointArray:Length() do 
        tmp = tmp and self.PointArray[i].IsUsed
    end
    self.CanOpen = not tmp
    local Player = Battle(self):GetEntity(PlayerEid)
    local CharacterInfo = DataMgr.PlayerStateMachine[Player.AutoSyncProp.CharacterTag]
    self.CanOpen = self.CanOpen and not CharacterInfo["Seating"]
end

function BP_SeatBase_C:FindPoint(PlayerEid)
    local Result = nil
    if self.RegionOnlineInteractiveMessage:Find(PlayerEid) then
        local Index = self.RegionOnlineInteractiveMessage:Find(PlayerEid)
        for i, v in pairs(self.PointArray) do
            if v.Index == Index then
                Result = v
            end
        end
    else
        local ResDis = 99999
        for i = 1,self.PointArray:Length() do 
            if not self.PointArray[i].IsUsed then
                -- local CompLoc = self.PointArray[i]:K2_GetComponentLocation()
                -- local PlayerLoc = Battle(self):GetEntity(PlayerEid):K2_GetActorLocation()
                -- local Dis = (CompLoc-PlayerLoc):Size()
                local Dis = self:SeatGetPlayerPointDis(Battle(self):GetEntity(PlayerEid), self.PointArray[i])
                if Result == nil or Dis < ResDis or (Dis == ResDis and math.random()>=0.5) then
                    Result = self.PointArray[i]
                    ResDis = Dis                    
                end
            end
        end
    end
    if not Result then
        print(_G.LogTag,"LXZ FindPoint Failed", self:GetName(), PlayerEid, self.PointArray:Length())
    end
    return Result
    -- print(_G.LogTag,"FindPoint", Tmp:Length())
end

--启动时设置玩家运动参数，主要为Z轴
function BP_SeatBase_C:SetSittingParam(Player, Point, EnterPoint)
    Player:SetCollisionType("CapsuleComponent","MonsterPawn",ECollisionResponse.ECR_OverLap,false)
    Player:SetCollisionType("CapsuleComponent","Pawn",ECollisionResponse.ECR_OverLap,false)
    local UpDiff = self:SeatGetUpDiff(Player.Mesh, Point, 50, true)
    local RootMotionDis = 30
    local BattleCharTag = ""
    if Player:IsNPC() == false then
        BattleCharTag = DataMgr.BattleChar[Player.CurrentRoleId]["BattleCharTag"][1]
    end
    
    if BattleCharTag == "Girl" then
        RootMotionDis = 30
    elseif BattleCharTag == "Man" then
        RootMotionDis = 20
    elseif BattleCharTag == "Woman" then
        RootMotionDis = 30
    else
        RootMotionDis = 20
    end
    if Player:GetMovementComponent() then
        Player:GetMovementComponent().RootMotionZScale = UpDiff/RootMotionDis
    end
end

--离开时设置玩家运动参数，主要为Z轴
function BP_SeatBase_C:SetLeavingParam(Player, Point, EnterPoint)
    Player:SetCollisionType("CapsuleComponent","MonsterPawn",ECollisionResponse.ECR_Block,false)
    Player:SetCollisionType("CapsuleComponent","Pawn",ECollisionResponse.ECR_Block,false)
    -- local UpDiff = Player:K2_GetActorLocation().Z - EnterPoint:K2_GetComponentLocation().Z - Player.OriginHalfHeight
    local UpDiff = self:SeatGetUpDiff(Player.Mesh, EnterPoint, Player.OriginHalfHeight, false)
    local RootMotionDis = 30
    local BattleCharTag = ""
    if Player:IsNPC() == false then
        BattleCharTag = DataMgr.BattleChar[Player.CurrentRoleId]["BattleCharTag"][1]
    end
    if BattleCharTag == "Girl" then
        RootMotionDis = 30
    elseif BattleCharTag == "Man" then
        RootMotionDis = 20
    elseif BattleCharTag == "Woman" then
        RootMotionDis = 30
    else
        RootMotionDis = 20
    end
    Player:GetMovementComponent().RootMotionZScale = UpDiff/RootMotionDis
end

function BP_SeatBase_C:GetLeavingType(Player)
    local TypeList = {"F","R","F","L","F","R","F"}
    local x = Player.MoveInputCache.X
    local y = Player.MoveInputCache.Y
    local PlayerForward = UE4.UKismetMathLibrary.GetForwardVector(Player:K2_GetActorRotation())
    local CameraForward = Player.CharCameraComponent:GetForwardVector()
    local PlayerForward2D = UE4.UKismetMathLibrary.Normal2D(FVector2D(PlayerForward.X, PlayerForward.Y))
    local CameraForward2D = UE4.UKismetMathLibrary.Normal2D(FVector2D(CameraForward.X, CameraForward.Y))
    -- local CameraForward = UE4.UKismetMathLibrary.GetForwardVector(Player:GetController().PlayerCameraManager:GetCameraRotation())
    local Direct = PlayerForward2D.Y*CameraForward2D.X-PlayerForward2D.X*CameraForward2D.Y
    local Angle = UE4.UKismetMathLibrary.DegAcos(PlayerForward2D.X*CameraForward2D.X+PlayerForward2D.Y*CameraForward2D.Y)
    if Direct > 0 then
        Angle = 360 - Angle
    end
    if Angle > 315 then
        Angle = Angle - 315
    end
    local Index = 1
    local Offset = (Angle+45)//90
    if math.abs(x) >= math.abs(y) then
        if x > 0 then
            Index = 1
        else
            Index = 3
        end
    elseif y > 0 then
        Index = 2
    else
        Index = 4
    end
    return TypeList[Index + Offset]
end

function BP_SeatBase_C:GetLeavingPoint(Player)
    if not self.PlayerAndSeat or not self.PlayerAndSeat[Player.Eid] then
        return
    end
    return self.PlayerAndSeat[Player.Eid]:FindLeavingPoint(self:GetLeavingType(Player))
end

function BP_SeatBase_C:NpcGetLeavingPoint(Npc)
    if not self.PlayerAndSeat[Npc.Eid] then
        return nil
    end
    return self.PlayerAndSeat[Npc.Eid]:NpcFindLeavingPoint(Npc)
end

function BP_SeatBase_C:OnEMActorDestroy(DestroyReason)
    for PlayerEid,Point in pairs(self.PlayerAndSeat) do
        local Player = Battle(self):GetEntity(PlayerEid)
        print(_G.LogTag,"LXZ OnEMActorDestroy", self:GetName(), Player, IsValid(Player))
        if IsValid(Player) then
            self.ChestInteractiveComponent:EndInteractive(Player)
        end
    end
    self.PlayerAndSeat = {}
    BP_SeatBase_C.Super.OnEMActorDestroy(self, DestroyReason)
end

--玩家之外的actor要占用椅子，不走交互逻辑，所以新来三个without函数
function BP_SeatBase_C:OpenMechanismWithoutInteractive(Character, CallBackFunc, IsImmediately)
    if not self.InitSuccess then
        self.CacheOpenMechanismWithoutInteractive = {CharacterEid = Character.Eid, CallBackFunc = CallBackFunc, SourceFunc = self.OpenMechanismWithoutInteractive}
        return
    end
    if not IsValid(Character) then
        return
    end
    local Point = self:FindPoint(Character.Eid)
    if not Point then
        print(_G.LogTag,"LXZ OpenMechanismWithoutInteractive", Character:GetName(), self:GetName())
        return
    end
    local EnterPoint = Point:NpcFindEnterPoint(Character)
    -- local Loc = FVector(EnterPoint:K2_GetComponentLocation().X, EnterPoint:K2_GetComponentLocation().Y, EnterPoint:K2_GetComponentLocation().Z + Character.CapsuleComponent.CapsuleHalfHeight + 2)--Character:GetFloorInfo().FloorDist)
    -- local Rot = EnterPoint:K2_GetComponentRotation()
    --DebugPrint("SitLocRot:",Loc, Rot,Character:GetName(), Character:K2_GetActorLocation(),Character.UnitId,EnterPoint:K2_GetComponentLocation(),Character.CapsuleComponent.CapsuleHalfHeight,Character:GetFloorInfo().FloorDist)
    -- Character:K2_SetActorLocationAndRotation(Loc, Rot, false, nil, false)

    -- NPC Z轴插值有表现问题，先去掉Z轴
    -- local RealZ = EnterPoint:K2_GetComponentLocation().Z + Character.CapsuleComponent.CapsuleHalfHeight + Character:GetFloorInfo().FloorDist
    local RealZ = Character:K2_GetActorLocation().Z
    local Loc = FVector(EnterPoint:K2_GetComponentLocation().X, EnterPoint:K2_GetComponentLocation().Y, RealZ)
    local Rot = EnterPoint:K2_GetComponentRotation()

    Point.IsUsed = true
    Point.EnterType = EnterPoint.Type
    self.PlayerAndSeat[Character.Eid] = Point
    local handle = UE4.ULTweenBPLibrary.Vector3To(self,{self,function(_,value)
        Character.MoveInput = FVector(0,0,0)
        Character.MoveInputCache = FVector(0,0,0)
        Character:K2_SetActorLocationAndRotation(value, Rot, false, nil, false)
    end},Character:K2_GetActorLocation(),Loc,0.1,0)
    handle:OnComplete({self,function() 
        if not IsValid(Character) then
            return
        end
        -- Character:K2_SetActorLocationAndRotation(Loc, Rot, false, nil, false)
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
        Character:SetCharacterTag(self.ChestInteractiveComponent.InteractiveTag)
        self:SetSittingParam(Character, Point, EnterPoint)
        -- if not UseNewNpcMoveComp then
        --     Character:GetMovementComponent():LockMovementMode(true, EMovementMode.MOVE_Falling)
        -- else
        --     Character:GetMovementComponent():OnNpcSeatingBegin()
        -- end
        Character.CapsuleComponent:IgnoreActorWhenMoving(self,true) 
        Character.CapsuleComponent:IgnoreActorWhenMoving(Player,true) 

        local Result = TArray(AActor)
        local MeshClass = UE4.AStaticMeshActor
        UE4.UKismetSystemLibrary.BoxOverlapActors(self, EnterPoint:K2_GetComponentLocation()+ FVector(0,0,Character.CapsuleComponent.CapsuleHalfHeight + 2), FVector(80, 80, 30), nil, MeshClass, nil, Result)
        -- UE4.UKismetSystemLibrary.DrawDebugBox(self, EnterPoint:K2_GetComponentLocation()+ FVector(0,0,Character.CapsuleComponent.CapsuleHalfHeight + 2), FVector(80, 80, 30), UE4.FLinearColor(1,0,0,1), self:K2_GetActorRotation(), 100)
        -- Character.CapsuleComponent:SetCollisionResponseToChannel(ECollisionChannel.ECC_WorldStatic, ECollisionResponse.ECR_Ignore)
        for _, Actor in pairs(Result) do
            if Actor then
                Character.CapsuleComponent:IgnoreActorWhenMoving(Actor, true)
            end
        end

        if Character:GetMovementComponent() then
            local GravityScale = Character:GetMovementComponent().GravityScale
            Character.SitGravityScale = GravityScale
            Character:GetMovementComponent().GravityScale = 0

            if Character.SetNpcMovementTickEnable then
                Character:SetNpcMovementTickEnable(true)
            else
                Character:GetMovementComponent():SetComponentTickEnabled(true)
            end

            -- Character:GetMovementComponent():LockMovementMode(false, EMovementMode.MOVE_NavWalking)
            Character:GetMovementComponent():OnNpcSeatingBegin()
        end
        
        -- Character.CharacterMovement.Velocity = FVector(0, 0, 0)
        Character:NpcSitSeat_Transform(Point, EnterPoint, Character.CapsuleComponent.CapsuleHalfHeight)
        -- Character:K2_SetActorLocationAndRotation(Loc, Rot, false, nil, false)
        if Character.NpcAnimInstance then
            Character.NpcAnimInstance.EnableDataFootIK = false
        end
        local function Completed()

        end
    
        local function NotifyBegin()
            
            if CallBackFunc then
                CallBackFunc()
            end
            EventManager:FireEvent(EventID.OnNpcPoseChange)
            Character:SetNpcMovementTickEnable(false)
        end
        local AllCallback = {
            OnCompleted = Completed,
            OnNotifyBegin = NotifyBegin
        }

        if self.PlayerAndSeat[Character.Eid] and self.PlayerAndSeat[Character.Eid].EnterType then
            local MontageName = self.ChestInteractiveComponent.MontageName.."_"..self.PlayerAndSeat[Character.Eid].EnterType.."_Montage"
            local MontagePrePath = "Interactive/MechInteractive"
            if Character.NpcId and DataMgr.Npc[Character.NpcId] and DataMgr.Npc[Character.NpcId].SpecialSit then
                local ActionId = DataMgr.Npc[Character.NpcId].SpecialSit
                local TalkActionData = DataMgr.TalkAction[ActionId]
                if TalkActionData then
                    MontageName = TalkActionData.ActionMontage.."_Montage" or MontageName
                    MontagePrePath = TalkActionData.MontagePrePath or MontagePrePath
                end
            end
            if IsImmediately == nil or IsImmediately == false then
                Character:PlayActionMontage(MontagePrePath, MontageName, AllCallback, false, true, false)
            else
                local MontPath = Character:GetMontagePath(MontagePrePath, MontageName)
                Character:K2_SetActorLocationAndRotation(Point:K2_GetComponentLocation(), Rot, false, nil, false)
                UResourceLibrary.LoadObjectAsync(self,MontPath,{self,function (_, Montage)
                    UE4.UPlayMontageCallbackProxy.CreateProxyObjectForPlayMontage(Character.Mesh, Montage, 1, 0, "SitLoop")
                    EventManager:FireEvent(EventID.OnNpcPoseChange)
                    if CallBackFunc then
                        CallBackFunc()
                    end
                end})
                return 
            end
        end
        Character:AddTimer(0.1, function()
            local Section = Character.Mesh:GetAnimInstance():Montage_GetCurrentSection()
            if Section == "SitLoop" then
                Character:RemoveTimer("SitToLoop")
                EventManager:FireEvent(EventID.OnNpcPoseChange)
            end
        end, true, 0, "SitToLoop")
    end})
    Character:AddTimer(3,function ()
        local HasSection = Character.Mesh:GetAnimInstance():IsPlayingMontagesContainsSection("SitLoop")
        if  Character:GetMovementComponent() and Character:GetMovementComponent().OnNpcSeatingEnd then
            Character:GetMovementComponent():OnNpcSeatingEnd(EMovementMode.MOVE_NavWalking)
        end
        if HasSection then
            Character:SetNpcMovementTickEnable(false)
            Character:RemoveTimer("DelayCloseNpcMovementTickBySit")
        end
    end,true,0,"DelayCloseNpcMovementTickBySit")
end

function BP_SeatBase_C:CloseMechanismWithoutInteractive(Character,Callback)
    Character:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true
    Character:SetNpcMovementTickEnable(true)
    local EnterPoint = self:NpcGetLeavingPoint(Character)
    self.PlayerAndSeat[Character.Eid].EnterType = EnterPoint.Type
    self:SetLeavingParam(Character, self.PlayerAndSeat[Character.Eid], EnterPoint)
    local MontageName = "SitEnd"..self.PlayerAndSeat[Character.Eid].EnterType
    if Character.NpcId and DataMgr.Npc[Character.NpcId] and DataMgr.Npc[Character.NpcId].SpecialSit then
        MontageName = "SitEnd"
    end

    Character.Mesh:GetAnimInstance():Montage_JumpToSection(MontageName)
    -- self.StandCallBack = function()
    --     if(Callback) then Callback() end
    --     Character.Mesh:GetAnimInstance().OnMontageEnded:Remove(Character, self.StandCallBack)
    --     self.PlayerAndSeat[Character.Eid].IsUsed = false
    --     self.PlayerAndSeat[Character.Eid] = nil
    --     EventManager:FireEvent(EventID.OnNpcPoseChange)
    --     DebugPrint("@@@CloseMechanismWithoutInteractive Stand:", Character.UnitId)
    --     Character:AddTimer(3,function ()
    --         Character:SetNpcMovementTickEnable(false)
    --         Character:RemoveTimer("DelayCloseNpcMovementTickByStand")
    --     end,true,0,"DelayCloseNpcMovementTickByStand")
    --     Character:SetCharacterTag("Idle")
    -- end
    -- Character.Mesh:GetAnimInstance().OnMontageEnded:Add(Character, self.StandCallBack)

    if Character.Mesh:GetAnimInstance() and Character.Mesh:GetAnimInstance().GetMontageSectionTime then
        local EndSectionTime = Character.Mesh:GetAnimInstance():GetMontageSectionTime(MontageName)
        Character:AddTimer(EndSectionTime, function ()
            if(Callback) then Callback() end
            self.PlayerAndSeat[Character.Eid].IsUsed = false
        self.PlayerAndSeat[Character.Eid] = nil
        EventManager:FireEvent(EventID.OnNpcPoseChange)
        -- DebugPrint("@@@CloseMechanismWithoutInteractive Stand:", Character.UnitId, "Time:", EndSectionTime)
        Character:AddTimer(3,function ()
            Character:SetNpcMovementTickEnable(false)
            Character:RemoveTimer("DelayCloseNpcMovementTickByStand")
        end,true,0,"DelayCloseNpcMovementTickByStand")
        Character:SetCharacterTag("Idle")
        Character:RemoveTimer("StandCallBackTimer")
        end, false, 0,"StandCallBackTimer")
    end
end

function BP_SeatBase_C:CloseMechanismWithoutMontage(Character)
    Character:GetMovementComponent().bAllowPhysicsRotationDuringAnimRootMotion = true
    local EnterPoint = self:NpcGetLeavingPoint(Character)
    if EnterPoint then
        self.PlayerAndSeat[Character.Eid].EnterType = EnterPoint.Type
        self:SetLeavingParam(Character, self.PlayerAndSeat[Character.Eid], EnterPoint)
        local LeaveLoc = EnterPoint:K2_GetComponentLocation()
        LeaveLoc.Z = LeaveLoc.Z + Character.CapsuleComponent.CapsuleHalfHeight + 2
        Character:K2_SetActorLocation(LeaveLoc, false, nil, false)
    else
        local LeaveLoc = Character.RootComponent:K2_GetComponentLocation()
        local ForWardUpVector = Character:GetActorForWardVector() * 50
        LeaveLoc = LeaveLoc + ForWardUpVector
        Character:K2_SetActorLocation(LeaveLoc, false, nil, false)
    end
    local CurrentMontage = Character.Mesh:GetAnimInstance():GetCurrentActiveMontage()
	if CurrentMontage then
		Character.Mesh:GetAnimInstance():Montage_Stop(0, CurrentMontage)
	end
    if IsValid(self.PlayerAndSeat[Character.Eid]) then
        self.PlayerAndSeat[Character.Eid].IsUsed = false
    end
    self.PlayerAndSeat[Character.Eid] = nil
    Character:SetCharacterTag("Idle")
    if Character.SetNpcMovementTickEnable then
        Character:SetNpcMovementTickEnable(false)
    end
    -- if Character:GetMovementComponent() and not UseNewNpcMoveComp then
    --     Character:GetMovementComponent():LockMovementMode(false, EMovementMode.MOVE_Walking)
    -- end
end

--Npc没有入座动画的入座
function BP_SeatBase_C:OpenMechanismNpcSpecial(Character, CallBackFunc)
    if not Character then
        return
    end
    if not self.InitSuccess then
        self.CacheOpenMechanismWithoutInteractive = {CharacterEid = Character.Eid, CallBackFunc = CallBackFunc, SourceFunc = self.OpenMechanismNpcSpecial}
        return
    end
    local Point = self:FindPoint(Character.Eid)
    if Point then
        Point.IsUsed = true
        Point.EnterType = "F"
        self.PlayerAndSeat[Character.Eid] = Point
    end
    return Point
end

function BP_SeatBase_C:CloseMechanismNpcSpecial(Character, CallBackFunc)
    if IsValid(self.PlayerAndSeat[Character.Eid]) then
        self.PlayerAndSeat[Character.Eid].IsUsed = false
    end
    self.PlayerAndSeat[Character.Eid] = nil
end

-----------------------------------------------------------区域联机-----------------------------------------------------------------------
function BP_SeatBase_C:SpecialRegionOnlineStartLogic(PlayerActor)
    local Avatar = GWorld:GetAvatar()
    local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Avatar or not PlayerActor then
        return
    end
    print(_G.LogTag,"LXZ SpecialRegionOnlineStartLogic", PlayerActor:GetName())
    local Point = self.PlayerAndSeat[PlayerActor.Eid] or self:FindPoint(PlayerActor.Eid)
    if not Point then
        return
    end
    print(_G.LogTag,"LXZ SpecialRegionOnlineStartLogic111", self.UniqueId, self.SenderId)
    local InteractiveId = Point.Index
    local AvatarEid = Avatar.Eid
    if self.SenderId and self.SenderId ~= "" then
        print(_G.LogTag,"LXZ SpecialRegionOnlineStartLogic222", self.UniqueId)
        AvatarEid = CommonUtils.Str2ObjId(self.SenderId)
    end
    -- local function func()
    --     Avatar:RequestChangeRegionOnlineItemState(Avatar.CurrentOnlineType, self.UniqueId, AvatarEid, InteractiveId, self.StateId, self.BpBorn)
    -- end
    -- self:AddTimer(1, func)
    local bInMobile = (CommonUtils.GetRuntimePlatform(self) == "Mobile")
    Avatar:RequestChangeRegionOnlineItemState(Avatar.CurrentOnlineType, self.UniqueId, AvatarEid, InteractiveId, self.StateId, self.BpBorn, bInMobile)
end


function BP_SeatBase_C:SpecialRegionOnlineEndLogic(PlayerActor)
    local Avatar = GWorld:GetAvatar()
    local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if not Avatar or not PlayerActor then
        return
    end
    print(_G.LogTag,"LXZ SpecialRegionOnlineEndLogic", PlayerActor:GetName())
    local Point = self.PlayerAndSeat[PlayerActor.Eid]
    if not Point then
        return
    end
    print(_G.LogTag,"LXZ SpecialRegionOnlineEndLogic111", self.SenderId)
    local InteractiveId = Point.Index
    local AvatarEid = Avatar.Eid
    if self.SenderId and self.SenderId ~= "" then
        AvatarEid = CommonUtils.Str2ObjId(self.SenderId)
    end
    local bInMobile = (CommonUtils.GetRuntimePlatform(self) == "Mobile")
    Avatar:RequestLeaveRegionOnlineItem(Avatar.CurrentOnlineType, self.UniqueId, AvatarEid, InteractiveId, bInMobile)
end

function BP_SeatBase_C:IsCanOnlineInteractive(Player)
    if not Player then
        return false
    end
    local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if MainPlayer ~= Player then
        return true
    end
    local Dis = (Player:K2_GetActorLocation() - self:K2_GetActorLocation()):Size()
    if Dis >= 800 then
        return false
    end
    if not self.ChestInteractiveComponent:CheckPlayerTag(Player) then
        return false
    end
    if Player:GetIsInDelivery() then
        ScreenPrint("玩家传送中，不允许坐下")
        return false
    end
    local TS = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UTalkSubsystem)
    if TS:IsInImmersiveStory() then
        ScreenPrint("玩家剧情中，不允许坐下")
        return false
    end
    return true
end
-- 获取可用的座位
--- PointIndex={true,false,true,true}
function BP_SeatBase_C:GetValidPoint()
    local PointIndex = {}
    for i, Point in pairs(self.PointArray) do
        local Valid = true
        local Eid = 0
        for PlayerEid, UsePoint in pairs(self.PlayerAndSeat) do
            if UsePoint.Index == Point.Index then
                Valid = false
                Eid = PlayerEid
            end
        end
        PointIndex[Point.Index] = {Valid = Valid, Eid = Eid}
    end
    return PointIndex
end
-----------------------------------------------------------区域联机-----------------------------------------------------------------------

return BP_SeatBase_C

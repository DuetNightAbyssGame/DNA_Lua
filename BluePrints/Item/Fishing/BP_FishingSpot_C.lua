--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type BP_FishingSpot_C
local M = Class( "BluePrints/Item/MiniGame/BP_OpenUIMechanism_C")

function M:CommonInitInfo(Info)
    M.Super.CommonInitInfo(self,Info)
    self.DefaultInteractiveComponent.MergeName = "Angling"
    self.UIName = "AnglingMain"
    -- self.FishingSpotId = 10010101

    if not self.BpBorn then
        self.FishingSpotId = self.UnitParams["FishingSpotId"]
    end
    self.FishingSpotName = DataMgr.FishingSpot[self.FishingSpotId]["FishingSpotName"]
    self.ExtraInfo.FishingSpotId = self.FishingSpotId
    self.ExtraInfo.FishingSpot = self
end

function M:SetCamera(Name)
    self:UpdateCameraInfo()
    local Controller=UE4.UGameplayStatics.GetPlayerController(self,0)
    local InfoName = "CameraInfo_"..Name
    local CameraName = "Camera_"..Name
    local Transform = self[InfoName].Trans
    local Time = self[InfoName].Time
    local Exp = self[InfoName].Exp
    if not IsValid(self[CameraName]) then
        self[CameraName] = self:GetWorld():SpawnActor(ACineCameraActor:StaticClass(),Transform)
        self[CameraName].CameraComponent:SetConstraintAspectRatio(self[InfoName].ConstraintAspectRadio)
        self[CameraName].CurrentAperture = self[InfoName].CurrentAperture
        self[CameraName].CurrentFocalLength = self[InfoName].FocalLength
        self[CameraName].CameraComponent:SetAspectRatio(1.7777)
        self[CameraName].CameraComponent:SetFieldOfView(90)
    end
    local PlayerCameraComp = UE4.UGameplayStatics.GetPlayerCharacter(self,0).CharCameraComponent
    Controller:SetViewTargetWithBlend(self[CameraName], Time, EViewTargetBlendFunction.VTBlend_EaseOut, Exp)
    AudioManager(self):PlayUISound(self, "event:/ui/common/whoosh_cam_move_long", nil, nil)
end

function M:OpenUI(PlayerId, NextStateId)
    local Player = Battle(self):GetEntity(PlayerId)
    -- Player:AddForbidTag("Battle")
    Player:SetInvincible(true, "Fishing")
    Player:SetSuperArmor(true, "Fishing")
    Player:SetStealth(true, "Fishing")

    local Rot = self.Arrow:K2_GetComponentRotation()
    Player:K2_SetActorRotation(Rot, false, nil, false)
    Player:GetMovementComponent():SetMovementMode(1)
    Player.CharSpringArmComponent.bArmCollision = false
    self.CameraProbeSize = Player.CharSpringArmComponent.CameraProbeSize
    Player.CharSpringArmComponent.CameraProbeSize = 2

    local Controller=UE4.UGameplayStatics.GetPlayerController(self,0)
    self.Camera:SetAspectRatio(Player.CharCameraComponent.AspectRatio)
    self.Camera:SetFieldOfView(Player.CharCameraComponent.FieldOfView)
    self:SetCamera("Main")
    self.CacheControllerPausedParam = Controller.bShouldPerformFullTickWhenPaused
    Controller.bShouldPerformFullTickWhenPaused = true
    Player.CharSpringArmComponent:SetTickableWhenPaused(true)
    for i, Weapon in pairs(Player.Weapons) do
        Weapon:SetActorHideTag("Fishing", true, false, false)
    end

    self:RealOpenUI(PlayerId, NextStateId)
    MissionIndicatorManager:TriggerAllIndicatorVisible(false)
end

--蒙太奇跑到指定帧才真正打开UI
function M:RealOpenUI(PlayerId, NextStateId)
    self.UINextStateId = NextStateId
    self:BroadcastOpenMechanism(PlayerId)
end

function M:CloseMechanism(PlayerId, IsSuccess)
    M.Super.CloseMechanism(self, PlayerId)
    local Player = Battle(self):GetEntity(PlayerId)
    Player:SetInvincible(false, "Fishing")
    Player:SetSuperArmor(false, "Fishing")
    Player.CharSpringArmComponent.CameraProbeSize = self.CameraProbeSize
    self:AddTimer(1, function()
        Player:SetStealth(false, "Fishing")
    end)
    local Controller = UE4.UGameplayStatics.GetPlayerController(self,0)
    local PlayerRot = Player:K2_GetActorRotation().Yaw
    Controller:SetControlRotation(FRotator(0,PlayerRot,0))
    Controller:SetViewTargetWithBlend(Player, 0, EViewTargetBlendFunction.VTBlend_EaseOut, 4)
    for i, Weapon in pairs(Player.Weapons) do
        Weapon:SetActorHideTag("Fishing", false, false, false)
    end

    if IsValid(self.Camera_Main) then
        self.Camera_Main:K2_DestroyActor()
    end
    if IsValid(self.Camera_Game) then
        self.Camera_Game:K2_DestroyActor()
    end
    MissionIndicatorManager:TriggerAllIndicatorVisible(true)
end

function M:CheckCanInteractive(Player)
    local TraceInfo="From BP_FishingSopo_C:CheckCanInteractive"
    local ResBattle = Battle(self):CheckConditionNew(67, Player, nil,TraceInfo)
    if not ResBattle then
        self.ChestInteractiveComponent:InteractiveFailed()
        return false
    end
    local ResParent = M.Super.CheckCanInteractive(self, Player)
    local Res = ResParent
    local Avatar = GWorld:GetAvatar()
    local ConditionId = DataMgr.FishingSpot[self.FishingSpotId].ConditionId
    if Avatar and ConditionId then
        local ResCondition = ConditionUtils.CheckCondition(Avatar, ConditionId)
        Res = Res and ResCondition
    end
    return Res
end

function M:RetrieveCameraViewInfo(CameraInfo, Time, Exp)
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    local AnchorTrans = Player.Mesh:K2_GetComponentToWorld()
    local List = Split(CameraInfo, ',')
    local Loc = FVector(tonumber(List[1]), tonumber(List[2]), tonumber(List[3]))
    local Rot = FRotator(tonumber(List[5]), tonumber(List[6]), tonumber(List[4]))
    local LocTrans = UE4.UKismetMathLibrary.MakeTransform(Loc, Rot, FVector(1, 1, 1))
    local Table = {}
    Table.Trans = UE4.UKismetMathLibrary.ComposeTransforms(LocTrans,AnchorTrans )
    Table.FocalLength = tonumber(List[7])
    Table.FocusDis = tonumber(List[8])
    Table.ConstraintAspectRadio = List[9] == "true" and true or false
    Table.FocusMethod = List[10]
    Table.CurrentAperture = tonumber(List[11])
    Table.Time = Time
    Table.Exp = Exp
    return Table
end

function M:UpdateCameraInfo()
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    local BattleCharTag = DataMgr.BattleChar[Player.CurrentRoleId]["BattleCharTag"][1]
    local FishingCameraData = DataMgr.FishingCamera[self.FishingSpotId]
    if not FishingCameraData then
        FishingCameraData = DataMgr.FishingCamera[1]
    end
    local CameraInfoMain = FishingCameraData[BattleCharTag]["CameraInfoMain"]
    local CameraInfoGame = FishingCameraData[BattleCharTag]["CameraInfoGame"]
    local CameraInfoSelect = FishingCameraData[BattleCharTag]["CameraInfoSelect"]
    if not CameraInfoMain or not CameraInfoGame or not CameraInfoSelect then
        GWorld.logger.error("钓鱼点"..self.FishingSpotName.."缺少镜头数据")
        return
    end

    local CameraInfoMainTrans = CameraInfoMain[1]
    local CameraInfoMainTime = CameraInfoMain[2] or 0.7
    local CameraInfoMainExp = CameraInfoMain[3] or 5
    self.CameraInfo_Main = self:RetrieveCameraViewInfo(CameraInfoMainTrans, CameraInfoMainTime, CameraInfoMainExp)
    local PlayerCameraComp = UE4.UGameplayStatics.GetPlayerCharacter(self,0).CharCameraComponent
    if not IsValid(self.Camera_Main) then
        self.Camera_Main = self:GetWorld():SpawnActor(ACameraActor:StaticClass(),self.CameraInfo_Main.Trans)
        self.Camera_Main.CameraComponent:SetConstraintAspectRatio(self.CameraInfo_Main.ConstraintAspectRadio)
        -- self.Camera_Main.CurrentAperture = self.CameraInfo_Main.CurrentAperture
        -- self.Camera_Main.CurrentFocalLength = self.CameraInfo_Main.FocalLength
        self.Camera_Main.CameraComponent:SetAspectRatio(PlayerCameraComp.AspectRatio)
        self.Camera_Main.CameraComponent:SetFieldOfView(90)
    end
    local CameraInfoGameTrans = CameraInfoGame[1]
    local CameraInfoGameTime = CameraInfoGame[2] or 0.4
    local CameraInfoGameExp = CameraInfoGame[3] or 7
    self.CameraInfo_Game = self:RetrieveCameraViewInfo(CameraInfoGameTrans, CameraInfoGameTime, CameraInfoGameExp)
    if not IsValid(self.Camera_Game) then
        self.Camera_Game = self:GetWorld():SpawnActor(ACameraActor:StaticClass(),self.CameraInfo_Game.Trans)
        self.Camera_Game.CameraComponent:SetConstraintAspectRatio(self.CameraInfo_Game.ConstraintAspectRadio)
        self.Camera_Game.CameraComponent:SetAspectRatio(PlayerCameraComp.AspectRatio)
        self.Camera_Game.CameraComponent:SetFieldOfView(90)
    end
    local CameraInfoSelectTrans = CameraInfoSelect[1]
    local CameraInfoSelectTime = CameraInfoSelect[2] or 0.4
    local CameraInfoSelectExp = CameraInfoSelect[3] or 7
    self.CameraInfo_Select = self:RetrieveCameraViewInfo(CameraInfoSelectTrans, CameraInfoSelectTime, CameraInfoSelectExp)
    if not IsValid(self.Camera_Select) then
        self.Camera_Select = self:GetWorld():SpawnActor(ACameraActor:StaticClass(),self.CameraInfo_Select.Trans)
        self.Camera_Select.CameraComponent:SetConstraintAspectRatio(self.CameraInfo_Select.ConstraintAspectRadio)
        self.Camera_Select.CameraComponent:SetAspectRatio(PlayerCameraComp.AspectRatio)
        self.Camera_Select.CameraComponent:SetFieldOfView(90)
    end
end

function M:CheckMontageInteractive()
    return true
end

function M:SetFishingSpotLocation(Player)
    local FishPointRelativeTransform = self.FishPoint.RelativeLocation
    local FishPointWorldLocation = self.FishPoint:K2_GetComponentLocation()
    local PlayerTransform = Player.Mesh:K2_GetComponentToWorld()
    local NewLoc = UKismetMathLibrary.TransformLocation(PlayerTransform, FishPointRelativeTransform)
    -- local PlayerForwardRotator = UKismetMathLibrary.ComposeTransforms(PlayerForward)
    -- local OriginVector = FVector(FishPointVector.X, FishPointVector.Y, PlayerVector.Z)
    -- local OriginVectorRotator = UKismetMathLibrary.Conv_VectorToQuaternion(OriginVector)
    -- local Res = UKismetMathLibrary.Quat_RotateVector(PlayerForwardRotator, OriginVector)
    -- OriginVector.Z = FishPointVector.Z

    NewLoc.Z = FishPointWorldLocation.Z
    local GameState = UGameplayStatics.GetGameState(self)
    UDataSetFunctionLibrary.SetVector_ByEid(GameState.Battle, Player.Eid, "FishPoint_Location", NewLoc)
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

require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---负责控制军械库角色动作、模型、镜头
---@type Armory_ActorController
local M = {}
M._components = {
	"BluePrints.UI.WBP.Armory.ActorController.Armory_WeaponActorComponent",
	"BluePrints.UI.WBP.Armory.ActorController.Armory_PetActorComponent",
	"BluePrints.UI.WBP.Armory.ActorController.Armory_ActorAppearanceComponent",
	"BluePrints.UI.WBP.Armory.ActorController.Armory_SceneActorComponent",
	"BluePrints.UI.WBP.Armory.ActorController.Armory_CharActorComponent",
	"BluePrints.UI.WBP.Armory.ActorController.Armory_MountActorComponent",
}
local SelfObjCount = 0

function M:SwitchArmoryCamera(IsArmoryCamera,Duration)
    if not self.ArmoryHelper then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI,0)
    if(not Player)then
        return
    end
    if IsArmoryCamera then
        self.ViewActor = self.ArmoryPlayer or self.ArmoryWeapon
        self.ArmoryHelper:SetViewActor(self.ViewActor)
        if(self.ArmoryPlayer)then
            self.PlayerOriginalRootTrans = self.ArmoryPlayer.Mesh:K2_GetComponentToWorld()
            self.ArmoryHelper.OriginalRootTrans = self.PlayerOriginalRootTrans
            local CameraTrans = self:LoadOpenArmoryCameraInfo(self.ArmoryPlayer)
            self.ArmoryHelper:SetCameraStartTrans(CameraTrans,Player.CharCameraComponent.FieldOfView,self.ArmoryPlayer)
        elseif(self.ArmoryWeapon or self.IsArmoryWeaponLoading)then

        else
            self:SetNoActorCamera()
        end
    else
        local StartTransform,StartLocation,StartRotation,_Duration = self:LoadCloseArmoryCameraInfo()
        Duration = Duration or _Duration
        local OnRecoverEnd = function()
            self:OnRecorverCameraEnd()
        end
        self.ArmoryHelper:RecorverCamera(nil,OnRecoverEnd,Duration,StartTransform,StartLocation,StartRotation)
    end
end

function M:SetNoActorCamera()
    if(not self.EPreviewSceneType)then
        return
    end
    local CameraTrans,FOV = self:LoadNoActorCameraInfo()
    if(CameraTrans)then
        if(not FOV)then
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI,0)
            FOV = Player.CharCameraComponent.FieldOfView
        end
        self.ArmoryHelper:SetCameraStartTrans(CameraTrans,FOV)
    end
end

function M:LoadNoActorCameraInfo()
    local Data = self:GetCameraData()
    Data = Data and Data["Char_Girl"]
    if(not Data)then
        return
    end
    local CameraTrans
    if(self.EPreviewSceneType)then
        local SceneTransform = self:GetPreviewSceneTrans()
        local Transform = FTransform()
        Transform.Translation.Z = SceneTransform.Translation.Z-- + 90
        Transform.Translation.X = SceneTransform.Translation.X
        Transform.Translation.Y = SceneTransform.Translation.Y
        CameraTrans = FTransform()
        local Location = FVector(Data.Location[1],Data.Location[2],Data.Location[3])
        local Rotation = FRotator(Data.Rotation[2],Data.Rotation[3],Data.Rotation[1])
        CameraTrans.Translation = UE4.UKismetMathLibrary.TransformLocation(Transform, Location)
        --CameraTrans.Rotation = UKismetMathLibrary.FindLookAtRotation(CameraTrans.Translation,Transform.Translation):ToQuat()
        CameraTrans.Rotation = UE4.UKismetMathLibrary.TransformRotation(Transform, Rotation):ToQuat()
    end
    local FOV
    if(Data.CameraFocal)then
        FOV = CommonUtils:FocalLengthToFOV(Data.CameraFocal or 22)
    end
    return CameraTrans,FOV
end

function M:LoadOpenArmoryCameraInfo(Player)
    local CameraTrans
    local Data = self:GetCameraData()["Char_"..Player:GetBattleCharBodyType()]
    if(Data and DataMgr.GlobalConstant.ArmoryCameraX)then
        local Transform
        if(self.ArmoryPlayer)then
            Transform = self.ArmoryPlayer.Mesh:GetSocketTransform('Root',ERelativeTransformSpace.RTS_World)
        elseif(self.EPreviewSceneType)then
            Transform = self:GetPreviewSceneTrans()
        end
        local EndCameraPos = FVector(Data.Location[1],Data.Location[2],Data.Location[3])
        local EndCameraRot = FRotator(Data.Rotation[2],Data.Rotation[3],Data.Rotation[1])
        CameraTrans = FTransform()
        local Location = EndCameraPos + FVector(DataMgr.GlobalConstant.ArmoryCameraX.ConstantValue
                                                ,DataMgr.GlobalConstant.ArmoryCameraY.ConstantValue
                                                ,DataMgr.GlobalConstant.ArmoryCameraZ.ConstantValue)
        CameraTrans.Translation = UE4.UKismetMathLibrary.TransformLocation(Transform, Location)
        CameraTrans.Rotation = UKismetMathLibrary.FindLookAtRotation(CameraTrans.Translation,Transform.Translation)
        CameraTrans.Rotation = UE4.UKismetMathLibrary.TransformRotation(Transform, EndCameraRot):ToQuat()
    else
        CameraTrans = Player.CharCameraComponent:K2_GetComponentToWorld()
    end
    return CameraTrans
end

function M:LoadCloseArmoryCameraInfo()
    local StartTransform,StartLocation,StartRotation,Duration
    if(DataMgr.GlobalConstant.ArmoryExitX)then
        StartTransform = FTransform()
        local CameraTrans = self.ArmoryHelper.RecoverEndTransform or StartTransform
        StartLocation = FVector(DataMgr.GlobalConstant.ArmoryExitX.ConstantValue
                                ,DataMgr.GlobalConstant.ArmoryExitY.ConstantValue
                                ,DataMgr.GlobalConstant.ArmoryExitZ.ConstantValue)
        StartTransform.Translation = UE4.UKismetMathLibrary.TransformLocation(CameraTrans, StartLocation)
        StartTransform.Rotation = CameraTrans.Rotation
        Duration = Duration or DataMgr.GlobalConstant.ArmoryExitTime.ConstantValue
        StartLocation = FVector(0,0,0)
        StartRotation = FRotator(0,0,0)
    end
    return StartTransform,StartLocation,StartRotation,Duration
end

function M:OnHelperBecomeViewTarget(PC)
    self.IsControled = true
    self.bTryDestroyActorsWhenDestruct = false
    if(self.OnFirstBecomeViewTarget)then
        self.OnFirstBecomeViewTarget()
        self.OnFirstBecomeViewTarget = nil
        self:HidePlayerActor("ActorController_ChangeViewTarget",false)
        self:HideWeaponActor("ActorController_ChangeViewTarget",false)
        self:HidePetActor("ActorController_ChangeViewTarget",false)
        self:UpdateSceneLighting()
        return
    end

    if(self.IsPlayingSequence)then
        --播放Sequence会改变ViewTarget，逻辑上仍然认为自身是ViewTarget
        if(self.SequenceActorController)then
            self.SequenceActorController:ViewTarget()
        end
        return
    end

    for key, value in pairs(self.PlayerActorHideTags) do
        if(value)then
            self:HidePlayerActor(key,true,true)
        end
    end
    self:HidePlayerActor("ActorController_ChangeViewTarget",false)
    self:HideWeaponActor("ActorController_ChangeViewTarget",false)
    self:HidePetActor("ActorController_ChangeViewTarget",false)

    if(self.ViewActorType == self.ViewActorTypes.Player)then
        self:RecoverToPlayerActor()
    elseif(self.ViewActorType == self.ViewActorTypes.SingleWeapon)then
        self:RecoverToSingleWeapon()
    else
        self:SetNoActorCamera()
    end   
    self:DelayUpdateSceneLighting()
end

function M:RecoverToPlayerActor()
    local LastCharModelInfo = self.LastCharModelInfo
    self.LastCharModelInfo = nil
    if(not LastCharModelInfo)then
        return
    end
    local IsRoleChanged
    if(self.IsProtagonist)then
        IsRoleChanged = self:ChangeToProtagonist(true,true,true)
    else
        IsRoleChanged = self:ChangeCharModel(LastCharModelInfo,true,true,true)
        if(self.LastCharAppearanceInfo)then
            self:ChangeCharAppearance(self.LastCharAppearanceInfo)
        end
    end
    if(self.CurrentPetInfo)then
        self:ChangePetModel(self.CurrentPetInfo)
    end
    --换角色会导致脚位置发生变化，换完角色再重设位置
    if(self.LastArmoryPlayerLoc)then
        self:SetPlayerLocation(self.LastArmoryPlayerLoc)
    end
    if(self.LastArmoryPlayerRot)then
        self:SetPlayerRotation(self.LastArmoryPlayerRot)
    end

    if(self.CurrentWeaponInfo)then
        self:ChangeWeaponModel(self.CurrentWeaponInfo,true,true)
        if(self.LastWeaponAppearanceInfo)then
            self:ChangeWeaponAppearance(self.LastWeaponAppearanceInfo)
        end
    end

    self.ArmoryHelper:OnRoleChanged()

    if(self.SequenceInfo)then
        self:ReplaySequence()
    elseif self.CurRiddingMount then
        self:RefreshMount()
    else
        self.bPlaySameMontage = true
        self:SetArmoryMontageTag(self.CurMontageTag,self.LastShowOrHideWeapon)
    end
end

function M:RecoverToSingleWeapon()
    if(self.CurrentWeaponInfo)then
        self:ChangeWeaponModel(self.CurrentWeaponInfo,true,true)
        if(self.LastWeaponAppearanceInfo)then
            self:ChangeWeaponAppearance(self.LastWeaponAppearanceInfo)
        end
    end
end

function M:OnHelperEndViewTarget(PC)
    self.IsControled = false
    self.LastCharModelInfo = self.CurrentCharInfo
    self.LastCharAppearanceInfo = self.CurrentAppearanceInfo
    self.LastWeaponAppearanceInfo = self.CurrentWeaponAppearanceInfo
    if(self.bDestructed)then
        return
    end
    if(self.IsPlayingSequence)then
        --播放Sequence会改变ViewTarget，逻辑上仍然认为自身是ViewTarget
        return
    end
    for key, value in pairs(self.PlayerActorHideTags) do
        if(value)then
            self:HidePlayerActor(key,false,true)
        end
    end
    self:HidePlayerActor("ActorController_ChangeViewTarget",true)
    self:HideWeaponActor("ActorController_ChangeViewTarget",true)
    self:HidePetActor("ActorController_ChangeViewTarget",true)
    if(IsValid(self.ArmoryPlayer) and self.CurrentCharInfo)then
        self.LastArmoryPlayerLoc = self.ArmoryPlayer:K2_GetActorLocation()
        self.LastArmoryPlayerRot = self.ArmoryPlayer:K2_GetActorRotation()
    end
end

--创建角色、武器、播放镜头动画
function M:OnOpened(Duration)
    local GameInstance = UE4.UGameplayStatics.GetGameInstance(self.ViewUI)

    local UIManager = GameInstance:GetGameUIManager()
    
    if(not IsValid(self.ArmoryHelper))then
        ---@type BP_PlayerCharacterArmoryHelper_C
        self.ArmoryHelper = UIManager:CreateUIActorCameraHelper(UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI,0))
    end
    if(IsValid(self.ArmoryHelper))then
        self.ArmoryHelper:BindViewTargetEvents({
            OnBecomeViewTarget = self.OnHelperBecomeViewTarget,
            OnEndViewTarget =  self.OnHelperEndViewTarget,
            OnAfterEndViewTarget = self.OnAfterHelperEndViewTarget},self)
        self:UpdateCameraPPSetting()
        self.ArmoryHelper.ArchivePreview = false
        self.ArmoryHelper.PersonalPreview = false
        if(self.EPreviewSceneType == CommonConst.EPreviewSceneType.PreviewArmory)then
            self.ArmoryHelper.ArchivePreview = true
        elseif(self.EPreviewSceneType == CommonConst.EPreviewSceneType.PersonInfo)then
            self.ArmoryHelper.PersonalPreview = true
        end
    end

    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI,0)
    if(not Player)then
        return
    end
    self:TryLoadPreviewScene()
    self.UncalculatedTrans = self.PreviewSceneTrans or Player:GetTransform()
    self:UpdateHelperTrans(self.UncalculatedTrans)

    self:HideRealPlayer(true)

    self.OpenDuration = Duration

    self.OnFirstBecomeViewTarget = function()
        self:InitActors()
    end
    self:ViewTarget()
    local FXMgr = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.ViewUI, UE4.UFXPriorityManager)
    if(FXMgr)then
        FXMgr.SetFXTickEvenPaused(self.ViewUI,self.UIName,true)
    end
    GWorld.GameInstance:SetDynamicResolution(self.UIName,true)
end

function M:UpdateHelperTrans(Trans)
    local Trans = UKismetMathLibrary.MakeTransform(Trans.Translation,FRotator(0), FVector(1))
    Trans.Translation.Z = Trans.Translation.Z + 90
    Trans.Translation.Y = Trans.Translation.Y + 90
    Trans.Rotation = Trans.Rotation
    self.ArmoryHelper:K2_SetActorTransform(Trans,false, nil, false)
end

function M:InitActors()
    if(self.CurrentCharInfo)then
        self:GetPlayerActor(true)
    elseif(self.CurrentWeaponInfo)then
        self:SetSingleWeaponCameraStartInfo(self.CurrentWeaponInfo)
        self:ChangeSingleWeapon(self.CurrentWeaponInfo,true)
    elseif(self.CurrentPetInfo)then
        self:ChangeToProtagonist(true)
    end
    self:SwitchArmoryCamera(true,self.OpenDuration)
end

function M:HideRealPlayer(bHide)
    if(self.IsPreviewMode or self.IsSecondary)then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI,0)
    if(not Player)then
        return
    end
    Player:SetActorHideTag(self.UIName,bHide)
    Player.CharCameraComponent:SetComponentTickEnabled(not bHide) --防止实际角色半透效果更新
    if(self.IsCharActorFistCreated)then
        local UIManager = UIManager(self.ViewUI)
        UIManager:HideOrShowPlayerFX(Player,bHide,self.UIName)
        if(IsValid(self.ArmoryPlayer))then
            UIManager:SetTargetActorState(bHide, self.ArmoryPlayer, self.UIName)
        end
    end
end

function M:CalcArmoryCameraTag(Type,Tag,Behavior,ExtraTag)
    local CameraTag1,CameraTag2,CameraTag3,CameraTag4 = "","","",""
    if(self.ViewUI.IsListExpanded)then
        --TODO:这里和军械库耦合度有些高
        CameraTag3 = "Switch"
    end
    CameraTag3 = ExtraTag or CameraTag3
    if(Type == CommonConst.ArmoryType.Char)then
        CameraTag1 = Type
        CameraTag2 = Behavior
        if(Behavior == CommonConst.ArmoryType.Mod)then
            CameraTag3 = nil
        elseif(Behavior == CommonConst.ArmoryTag.Appearance)then
            if(not Tag or Tag == CommonConst.ArmoryType.Char)then
                CameraTag2 = Behavior
            else
                CameraTag2 = Tag
                CameraTag3 = ExtraTag or ""
            end
        elseif(Behavior == CommonConst.ArmoryTag.Files)then
            CameraTag2 = Behavior
        elseif(Behavior == CommonConst.ArmoryTag.Char)then
            CameraTag2 = nil
        end
    elseif(Type == CommonConst.ArmoryType.Weapon)then
        CameraTag1 = Type
        if(Tag and string.find(Tag,CommonConst.ArmoryTag.UWeapon))then
            CameraTag2 = "Ultra"
            if(Behavior == CommonConst.ArmoryType.Mod)then
                CameraTag3 = Behavior
            end
            CameraTag4 = self.ArmoryPlayer.CurrentRoleId
        elseif(Behavior == CommonConst.ArmoryType.Mod)then
            CameraTag2 = Behavior
            CameraTag3 = nil
        elseif(Behavior == CommonConst.ArmoryTag.Grade)then
            CameraTag2 = self.ArmoryPlayer.PlayerAnimInstance.IdleTag
            CameraTag3 = Behavior
        else
            CameraTag2 = self.ArmoryPlayer.PlayerAnimInstance.IdleTag
        end
        if(Behavior == CommonConst.ArmoryTag.Appearance)then
            CameraTag3 = "Color"
        end
    elseif(Type == CommonConst.ArmoryType.Pet)then
        local Avatar = GWorld:GetAvatar() or {Sex = 1}
        if(Avatar.Sex == 1)then
            CameraTag1 = "Nvzhu"
        else
            CameraTag1 = "Nanzhu"
        end
        if (Behavior=="Entry")then
            CameraTag2 = Behavior
        end

        CameraTag4 = Type
    else
        CameraTag1 = CommonConst.ArmoryType.Char
    end
    return CameraTag1,CameraTag2,CameraTag3,CameraTag4
end

function M:CalcArmoryMontageTag(Type,Tag,Behavior)
    local bShowOrHideWeapon = nil
    local MontageTag = nil
    if(Type ==  CommonConst.ArmoryType.Char)then
        if(Behavior == CommonConst.ArmoryType.Mod)then
            MontageTag = Const.ArmoryIdleTags.Armory_Mod
            bShowOrHideWeapon = false
        elseif(Behavior ==  CommonConst.ArmoryTag.Grade)then
            MontageTag = Const.ArmoryIdleTags.Armory_Grade
        elseif(Behavior == CommonConst.ArmoryTag.Appearance)then
            if(Tag and Tag ~= CommonConst.ArmoryType.Char)then
                MontageTag = Const.ArmoryIdleTags.None
            else
                MontageTag = Const.ArmoryIdleTags.Armory
            end
        else
            MontageTag = Const.ArmoryIdleTags.Armory
        end
    elseif(Type == CommonConst.ArmoryType.Weapon)then
        if(Behavior == CommonConst.ArmoryType.Mod)then
            MontageTag = Const.ArmoryIdleTags.Armory_Mod
            if(Tag and string.find(Tag,CommonConst.ArmoryTag.UWeapon))then
                bShowOrHideWeapon = false
            else
                bShowOrHideWeapon = true
            end
        elseif(Tag and string.find(Tag,CommonConst.ArmoryTag.UWeapon))then
            MontageTag = "Ultra"
        else
            MontageTag = Tag
        end
    elseif(Type == CommonConst.ArmoryType.Pet)then
        MontageTag = Const.ArmoryIdleTags.Armory_Pet
    else
        MontageTag = Const.ArmoryIdleTags.Armory_Mod
    end
    return MontageTag,bShowOrHideWeapon
end

---设置动作、镜头
function M:SetMontageAndCamera(Type,Tag,Behavior,ExtraTag)
    if(not IsValid(self.ViewUI))then
        return
    end
    if(not self.ArmoryPlayer)then
        return
    end
    local ArmoryPlayer = self.ArmoryPlayer
    self.LastMontageAndCameraType = Type
    self.LastMontageAndCameraTag = Tag
    self.LastMontageAndCameraBehavior = Behavior
    self.LastExtraTag = ExtraTag
    if(self.DelayFrame and self.DelayFrame > 0)then
        ArmoryPlayer:SetArmoryTag("None")
        self:HidePlayerActor(self.UIName,true)
        self.LastMontageTag,self.bShowOrHideWeapon = self:CalcArmoryMontageTag(self.LastMontageAndCameraType,self.LastMontageAndCameraTag,self.LastMontageAndCameraBehavior)
        self:PlayDisappearFX(ArmoryPlayer.FXComponent,function()
            if(self.bClosed or self.bDestructed or not self.IsControled)then
                return
            end
            self:PlayAppearFX(ArmoryPlayer.FXComponent)
            self:HidePlayerActor(self.UIName,false)
            self:RealPlayMontageAndCamera(self.LastMontageTag,self.bShowOrHideWeapon,self.LastDelayCameraTags)
        end)
    else
        self:RealPlayMontageAndCamera()
    end
end

function M:PlayDisappearFX(FXComponent,OnFXFinished)
    local DelayFrame = self.DelayFrame
    self.DelayFrame = nil
    local IsLastDisappearFXPlaying = self.DisappearFXPlaying
    self.bWatingForDelayFrame = true
    if(FXComponent and not IsLastDisappearFXPlaying and not self.bNoDisappearFX)then
        AudioManager(self.ViewUI):PlayUISound(self.ViewUI, "event:/ui/common/role_disappear", nil, nil)
        local Params = {bTickEvenWhenPaused = true,NotAttached = true}
        if(self.bPreviewSceneLoaded)then
            Params.UseAbsoluteLocation = true
            local Loc = self:GetPreviewSceneTrans().Translation
            Params.Location = {Loc.X,Loc.Y,Loc.Z,}
        end
        FXComponent:PlayEffectByIDParams(302, Params)
        local ReflectionActor = self:GetReflectionActor()
        if(ReflectionActor and ReflectionActor.FXComponent)then
            Params.scale = {1,1,-1}
            ReflectionActor.FXComponent:PlayEffectByIDParams(302, Params)
        end
        self.DisappearFXPlaying = true
    end
    if(IsLastDisappearFXPlaying)then
        return
    end
    self.LTweenHandle_PlayDisappearFX = UE4.ULTweenBPLibrary.DelayFrameCall(self.ViewUI, DelayFrame or 0, function()
        self.LTweenHandle_PlayDisappearFX = nil
        self.DisappearFXPlaying = false
        self.bWatingForDelayFrame = false
        self.bNoDisappearFX = false
        if(OnFXFinished)then
            OnFXFinished()
        end
    end)
    local LTweenActor = UE4.ALTweenActor.GetLTweenInstance(self.LTweenHandle_PlayDisappearFX)
    if(LTweenActor)then
        LTweenActor:SetTickableWhenPaused(true)
    end
end

function M:PlayAppearFX(FXComponent)
    if(FXComponent and not self.bNoDisappearFX)then
        AudioManager(self.ViewUI):PlayUISound(self.ViewUI, "event:/ui/common/role_appear", nil, nil)
        local Params = {bTickEvenWhenPaused = true,NotAttached = true}
        if(self.bPreviewSceneLoaded)then
            Params.UseAbsoluteLocation = true
            local Loc = self:GetPreviewSceneTrans().Translation
            Params.Location = {Loc.X,Loc.Y,Loc.Z,}
        end
        FXComponent:PlayEffectByIDParams(301, Params)
        local ReflectionActor = self:GetReflectionActor()
        if(ReflectionActor and ReflectionActor.FXComponent)then
            Params.scale = {1,1,-1}
            ReflectionActor.FXComponent:PlayEffectByIDParams(301, Params)
        end
    end
end

function M:RealPlayMontageAndCamera(MontageTag,bShowOrHideWeapon,CameraTags)
    if(MontageTag == nil)then
        MontageTag,bShowOrHideWeapon = self:CalcArmoryMontageTag(self.LastMontageAndCameraType,self.LastMontageAndCameraTag,self.LastMontageAndCameraBehavior)
    end
    self:SetArmoryMontageTag(MontageTag,bShowOrHideWeapon)
    if(CameraTags)then
        self:SetArmoryCameraTag(table.unpack(CameraTags))
    else
        local Tags = {self:CalcArmoryCameraTag(self.LastMontageAndCameraType,self.LastMontageAndCameraTag,self.LastMontageAndCameraBehavior,self.LastExtraTag)}
        if(next(Tags))then
            self:SetArmoryCameraTag(table.unpack(Tags))
        end
    end
end

---重置Actor旋转
function M:ResetActorRotation()
    if(self.SequenceActorController)then
        self.SequenceActorController:ResetActorRotation()
        return
    end
    self.ArmoryHelper:ResetRotation()
    local ArmoryPet = self:GetPetActor()
    if (ArmoryPet and ArmoryPet.SkeletalMesh) then
        ArmoryPet.SkeletalMesh:K2_SetRelativeRotation(FRotator(0,0,0), false, nil, false)
    end

    local ReflectionActor = self:GetReflectionActor(self.ArmoryHelper:GetViewActor())
    if(ReflectionActor)then
        ReflectionActor:K2_SetActorRotation(self.ArmoryHelper:GetViewActorRotation(),false,nil,false)
    end
end

---获取倒影
function M:GetReflectionActor(Owner)
    return self.Reflections[Owner]
end

---获取倒影持有者
function M:GetReflectionOwner(ReflectionActor)
    return self.ReflectionOwners[ReflectionActor]
end

function M:SetReflectionActor(Owner,ReflectionActor)
    self.Reflections[Owner] = ReflectionActor
    self.ReflectionOwners[ReflectionActor] = Owner
end

function M:BindEvent(Obj,Events)
    Events = Events or {}
    self.EventObj = Obj
    self.OnPlayPetFresnel = Events.OnPlayPetFresnel
    self.OnCharModelChanged = Events.OnCharModelChanged
end

---播放角色蒙太奇
function M:SetArmoryMontageTag(Tag,bShowOrHideWeapon)
    self.bShowOrHideWeapon = bShowOrHideWeapon
    Tag = Tag or "None"
    self.LastMontageTag = Tag
    if(self.bWatingForDelayFrame)then
        return
    end
    local bPlay = true
    if(self.LastMontageTag == self.CurMontageTag and not self.bPlaySameMontage)then
        bPlay = false
    end

    local Player = self:GetPlayerActor()
    local PlayerReflection = self:GetReflectionActor(Player)
    if(bPlay)then
        self:ResetActorRotation()
        self.bPlaySameMontage = false
        self.CurMontageTag = Tag
        local SetArmoryTag = function(PlayerCharacter)
            if(not PlayerCharacter)then return end
            PlayerCharacter.UsingWeapon = nil
            if(Tag == "Ultra" and not PlayerCharacter:GetWeaponByWeaponTag(Tag,1))then
                self:AddPlayerUltraWeapons(PlayerCharacter)
            end
            PlayerCharacter:SetArmoryTag(Tag)
        end
        SetArmoryTag(Player)
        SetArmoryTag(PlayerReflection)
    end
    
    self.LastShowOrHideWeapon = self.bShowOrHideWeapon
    local ChangeWeapon = function(PlayerCharacter)
        if(PlayerCharacter == nil)then return end
        if(self.bShowOrHideWeapon == true)then
            self:ChangePlayerWeaponByType(self.LastMontageAndCameraTag,PlayerCharacter)
            if(PlayerCharacter.UsingWeapon)then
                PlayerCharacter:UnBindWeaponFromHand()
            end
        elseif(self.bShowOrHideWeapon == false)then
            self:ChangePlayerWeaponByType(nil,PlayerCharacter)
        end
    end
    ChangeWeapon(Player)
    ChangeWeapon(PlayerReflection)

    if(self.bPlayRoleChangedSound and Tag == Const.ArmoryIdleTags.Armory)then
        AudioManager(self.ViewUI):PlayFMODSoundByID(Player, 213, Player, "None"
        , {bFollowSocket = true,bPlayAs2D = true,EventKey = "ArmoryRoleVoice"})
    end
    self.bPlayRoleChangedSound = false
    if(bPlay or self.bShowOrHideWeapon)then
        local SetWeaponTickableWhenPaused = function(PlayerCharacter)
            if(PlayerCharacter == nil)then return end
            --防止换武器后特效不播
            CommonUtils:SetActorTickableWhenPaused(PlayerCharacter,true)
            if(PlayerCharacter.MeleeWeapon)then
                CommonUtils:SetActorTickableWhenPaused(PlayerCharacter.MeleeWeapon,true)
                self:SetAccessoriesTickableWhenPaused(PlayerCharacter.MeleeWeapon.Accessories)
            end
            if(PlayerCharacter.RangedWeapon)then
                CommonUtils:SetActorTickableWhenPaused(PlayerCharacter.RangedWeapon,true)
                self:SetAccessoriesTickableWhenPaused(PlayerCharacter.RangedWeapon.Accessories)
            end
            if(PlayerCharacter.UltraWeapon)then
                CommonUtils:SetActorTickableWhenPaused(PlayerCharacter.UltraWeapon,true)
                self:SetAccessoriesTickableWhenPaused(PlayerCharacter.UltraWeapon.Accessories)
            end
        end
        SetWeaponTickableWhenPaused(Player)
        SetWeaponTickableWhenPaused(PlayerReflection)
    end
end

function M:SetAccessoriesTickableWhenPaused(Accessories)
    if(Accessories)then
        for _, value in pairs(Accessories) do
            CommonUtils:SetActorTickableWhenPaused(value,true)
        end
    end
end

---设置额外镜头位置偏移
function M:SetExCameraOffset(Offset)
    self.ExCameraOffset = Offset
end

function M:EnableCameraScrolling(bEnable)
    self.ArmoryHelper.EnableCameraScrolling = bEnable
end

---设置军械库镜头
---@param Tag1 string 目标类型
---@param Tag2 string 标签
---@param Tag3 string 额外标签
---@param Tag4 string 目标体型/Id
function M:SetArmoryCameraTag(Tag1,Tag2,Tag3,Tag4)
    DebugPrint("gmy@Armory_ActorController M:SetArmoryCameraTag", Tag1,Tag2,Tag3,Tag4)
    self.LastCameraTags = {Tag1 or "",Tag2 or "",Tag3 or "",Tag4 or ""} --加""防止unpack出错
    if(self.bWatingForDelayFrame)then
        self.LastDelayCameraTags = {Tag1 or "",Tag2 or "",Tag3 or "",Tag4 or ""}
        return
    end
    self.LastDelayCameraTags = nil
    local PlayerActor = self:GetPlayerActor()
    if PlayerActor then --角色皮肤和手持武器
        Tag1 = Tag1 or ""
        Tag2 = (Tag2 == "0" and ("_"..PlayerActor.PlayerAnimInstance.IdleTag)) or (Tag2 and Tag2 ~= "" and ("_"..Tag2)) or ""
        Tag3 = (Tag3 and Tag3 ~= "" and ("_"..Tag3)) or ""
        Tag4 = (Tag4 and Tag4 ~= "" and ("_"..Tag4)) or ("_" .. PlayerActor:GetBattleCharBodyType())
    elseif (not PlayerActor) and self.ArmoryWeapon then --独立武器
        Tag1 = Tag1 or ""
        Tag2 = Tag2 or ""
        Tag3 = Tag3 or ""
        Tag4 = Tag4 or ""
    end
    local Tag = Tag1 .. Tag2 .. Tag3 .. Tag4
    
    DebugPrint("gmy@Armory_ActorController M:SetArmoryCameraTag111", Tag)
    local Data = self:GetCameraData()[Tag]
    if(not Data)then
        Tag = "Default"
        Data = self:GetCameraData()[Tag]
    end

    local Location = FVector(Data.Location[1],Data.Location[2],Data.Location[3])
    local Rotation = FRotator(Data.Rotation[2],Data.Rotation[3],Data.Rotation[1])
    local OffsetVector = FVector(0,0,0)
    local OffsetRotator = FRotator(0,0,0)
    local CurrentRoleId = (PlayerActor and PlayerActor.CurrentRoleId) or (self.ArmoryWeapon and self.ArmoryWeapon.WeaponId)
    if(Data.LocationOffset)then
        local OffsetData = Data.LocationOffset[CurrentRoleId]
        if(OffsetData)then
            OffsetVector = FVector(OffsetData[1],OffsetData[2],OffsetData[3])
        end
    end
    if(Data.RotationOffset)then
        local OffsetData = Data.RotationOffset[CurrentRoleId]
        if(OffsetData)then
            OffsetRotator = OffsetRotator + FRotator(OffsetData[2],OffsetData[3],OffsetData[1])
        end
    end
    if(CommonUtils.GetDeviceTypeByPlatformName(self.ViewUI) == "Mobile")then
        local MobileLocationOffset
        if(Data.MobileLocationOffset)then
            MobileLocationOffset = Data.MobileLocationOffset[CurrentRoleId] or Data.MobileLocationOffset[0]
        end
        if(MobileLocationOffset)then
            OffsetVector = OffsetVector + FVector(MobileLocationOffset[1],MobileLocationOffset[2],MobileLocationOffset[3])
        end
        local MobileRotationOffset
        if(Data.MobileRotationOffset)then
            MobileLocationOffset = Data.MobileRotationOffset[CurrentRoleId] or Data.MobileRotationOffset[0]
        end
        if(MobileRotationOffset)then
            OffsetRotator = OffsetRotator + FRotator(MobileRotationOffset[2],MobileRotationOffset[3],MobileRotationOffset[1])
        end
    end
    if(Data.AccessoryLocationOffset and self.CameraOffsetAccessoryId)then
        local OffsetData = Data.AccessoryLocationOffset[self.CameraOffsetAccessoryId]
        if(OffsetData)then
            OffsetVector = OffsetVector + FVector(OffsetData[1],OffsetData[2],OffsetData[3])
        end
    end
    self.CameraOffsetAccessoryId = nil
    self.LastExCameraOffset = self.ExCameraOffset
    if(self.ExCameraOffset)then
        OffsetVector = OffsetVector + self.ExCameraOffset
        self.ExCameraOffset = nil
    end
    Location = Location + OffsetVector
    Rotation = Rotation + OffsetRotator

    -- local ScreenResolution = UWidgetLayoutLibrary.GetViewportSize(self.ViewUI)
    -- local Adjustment = (ScreenResolution.X / ScreenResolution.Y) / (16/9) -- 屏幕比例修正
    -- Location.X = Location.X * Adjustment
    -- Location.Y = Location.Y * Adjustment

    local Time = self._FixedCameraTransTimeOnce or Data.Time or 0
    self._FixedCameraTransTimeOnce = nil
    local StartPos,EndPos = self.ArmoryHelper:TransformCamera(Location,Rotation,Time,Data.Ease)

    local ForwardLocation = Data.ForwardLocation
    local BackwardLocation = Data.BackwardLocation
    if(ForwardLocation or BackwardLocation)then
        if(ForwardLocation)then
            ForwardLocation =  FVector(ForwardLocation[1],ForwardLocation[2],ForwardLocation[3])
        else
            ForwardLocation = Location
        end
        if(BackwardLocation)then
            BackwardLocation =  FVector(BackwardLocation[1],BackwardLocation[2],BackwardLocation[3])
        else
            BackwardLocation = Location
        end
        BackwardLocation = BackwardLocation + OffsetVector
        ForwardLocation = ForwardLocation + OffsetVector
        -- BackwardLocation.X = BackwardLocation.X * Adjustment
        -- BackwardLocation.Y = BackwardLocation.Y * Adjustment
        -- ForwardLocation.X = ForwardLocation.X * Adjustment
        -- ForwardLocation.Y = ForwardLocation.Y * Adjustment
        self.ArmoryHelper:SetCameraScrollRange(ForwardLocation, BackwardLocation, 0.5, Data.Ease)
        self:EnableCameraScrolling(true)
    else
        self:EnableCameraScrolling(false)
    end

    local FOV = CommonUtils:FocalLengthToFOV(Data.CameraFocal or 22)
    self.ArmoryHelper:StartFOVAnim(FOV,Time,Data.Ease)

    if(self.bPreviewSceneLoaded and self.EPreviewSceneType == CommonConst.EPreviewSceneType.PreviewCommon)then
        self:StartPreviewBGAnimation(Data.PreviewBGPos,Time)
    end

    if(Tag ~= "Default")then
        if(self.LastApplyCameraTag and self.LastApplyCameraTag ~= Tag and StartPos)then
            local CameraDistance = (StartPos-EndPos):Size()
            if(CameraDistance > 150)then
                AudioManager(self.ViewUI):StopSound(self.ArmoryHelper, "ArmoryCameraMoveShort")
                AudioManager(self.ViewUI):PlayUISound(self.ArmoryHelper, "event:/ui/common/whoosh_cam_move_long", "ArmoryCameraMoveLong", nil)
            elseif(CameraDistance > 1)then
                AudioManager(self.ViewUI):StopSound(self.ArmoryHelper, "ArmoryCameraMoveLong")
                AudioManager(self.ViewUI):PlayUISound(self.ArmoryHelper, "event:/ui/common/whoosh_cam_move_short", "ArmoryCameraMoveShort", nil)
            end
        end
        self.LastApplyCameraTag = Tag
    end
end

---固定下一次镜头过渡时间
function M:FixedCameraTransTimeOnce(Time)
    self._FixedCameraTransTimeOnce = Time
end

---更新镜头后处理
function M:UpdateCameraPPSetting(Params)
    if(not self.ViewUI)then
        return
    end
    Params = Params or {}
    self.ArmoryHelper:AddTimer(0.1,function()
        self.ArmoryHelper:ClearPPSetting()
        if(Params.IsAccessoryPPSetting)then
            self.ArmoryHelper:OnOpenAccessory()
        elseif(self.EPreviewSceneType == CommonConst.EPreviewSceneType.PreviewArmory)then
            self.ArmoryHelper:UpdatePPSetting(1)
        elseif(self.EPreviewSceneType == CommonConst.EPreviewSceneType.PreviewCommon)then
            self.ArmoryHelper:UpdatePPSetting(2)
        else
            self.ArmoryHelper:UpdatePPSetting(0)
        end
    end,false,0,"DelayUpdateCameraPPSetting",true)
end

local SystemUI = DataMgr.SystemUI
local CameraDataConfig = {
    [SystemUI.ArmoryMain.UIName] = DataMgr.ArmoryCameraData,
    [SystemUI.ArmoryDetail.UIName] = DataMgr.ArmoryCameraData,
    [SystemUI.PersonInfoPageMain.UIName] = DataMgr.PersonalPageCameraData,
    [SystemUI.SquadMainUI.UIName] = DataMgr.SquadCameraData,
    [SystemUI.BattlePassMain.UIName] = DataMgr.BattlePassCameraData,
    [SystemUI.BattlePassPurchase.UIName] = DataMgr.BattlePassCameraData,
    [SystemUI.CharSkinPreview.UIName] = DataMgr.BattlePassCameraData,
    [SystemUI.SkinPreview.UIName] = DataMgr.SkinPreviewCameraData,
    [SystemUI.GuildWarRank.UIName] = DataMgr.GuildWarRankCameraData,
    [SystemUI.PersonalInfoDataRanking.UIName] = DataMgr.GuildWarRankCameraData,
    [SystemUI.ShopMain.UIName] = DataMgr.RecommendCameraData,
    [SystemUI.MountsMain.UIName] = DataMgr.MountCameraData,
    [SystemUI.ActivitySoloTreasureMain.UIName] = DataMgr.SoloTreasureCameraData,
}

---获取镜头数据
function M:GetCameraData()
    if(CameraDataConfig[self.UIName])then
        return CameraDataConfig[self.UIName]
    end
    return DataMgr.ArmoryCameraData
end

---旋转Actor,一般在鼠标拖拽时调用
function M:OnDragViewActor(CursorDelta)
    local ArmoryPet = self:GetPetActor()
    if (ArmoryPet and ArmoryPet.SkeletalMesh) then
        CursorDelta = CursorDelta or {X = 0}
        local DeltaRotation = FRotator(0, math.clamp(-CursorDelta.X, -20, 20), 0)
        ArmoryPet.SkeletalMesh:K2_AddRelativeRotation(DeltaRotation,false,nil,false)
    else
        self.ArmoryHelper:OnDragViewActor(CursorDelta)
        local PlayerReflection = self:GetReflectionActor(self.ArmoryHelper:GetViewActor())
        if(PlayerReflection)then
            PlayerReflection:K2_SetActorRotation(self.ArmoryHelper:GetViewActorRotation(),false,nil,false)
        end
    end
end

---拉镜头,一般在鼠标滚轮滚动时调用
function M:OnScrolling(DeltaMove)
    self.ArmoryHelper:OnScrolling(DeltaMove)
end

--恢复相机结束时
function M:OnRecorverCameraEnd()
    self:BeforeDestruct()
    if(self.Event_OnRecorverCameraEnd)then
        self.Event_OnRecorverCameraEnd.Func(self.Event_OnRecorverCameraEnd.Obj)
    end
end

function M:BeforeDestruct()
end

---关闭时调用
function M:OnClosed()
    if(self.bClosed)then
        return
    end
    self.bClosed = true
    self:RecoverCamera()
    self:OnClosed_Implementation()
end

function M:OnClosed_Implementation()
    try({
        exec = function()
            self:ChangeRealPlayerInfo()
            self:HideRealPlayer(false)
            self:Component_OnClosed()
        end,
        catch = function (err)
            local trace = debug.traceback()
            err = err or ""
            DebugPrint("Error:".."\n"..trace)
        end,
    })
end

function M:Component_OnClosed()
end

function M:RecoverCamera()
    if(not self.bNeedEndCamera)then
        self:SwitchArmoryCamera(false,0)
    else
        if(self.Event_OnRecorverCameraStart)then
            self.Event_OnRecorverCameraStart.Func(self.Event_OnRecorverCameraStart.Obj)
        end
        self:SwitchArmoryCamera(false,nil)
    end
end

---必须在界面的Destruct里调用，不要放Close里！！
function M:OnDestruct()
    if(self.bDestructed)then
        return
    end
    SelfObjCount = SelfObjCount - 1
    GWorld.GameInstance:SetDynamicResolution(self.UIName,false)
    self.bDestructed = true
    if(not self.bClosed)then
        self:OnClosed_Implementation()
    end
	EventManager:RemoveEvent(EventID.OnWindowResized,self)
    self:Component_OnDestruct()
    if(self.bTryDestroyActorsWhenDestruct)then
        self.bTryDestroyActorsWhenDestruct = false
        self:TryDestroyActors()
    end
    if(self.LTweenHandle_PlayDisappearFX and IsValid(self.LTweenHandle_PlayDisappearFX) and IsValid(self.ViewUI))then
        ULTweenBPLibrary.KillIfIsTweening(self.ViewUI,self.LTweenHandle_PlayDisappearFX,false)
    end
    local FXMgr = UE4.USubsystemBlueprintLibrary.GetWorldSubsystem(self.ViewUI, UE4.UFXPriorityManager)
    if(FXMgr)then
        FXMgr.SetFXTickEvenPaused(self.ViewUI,self.UIName,false)
    end
end

---主要用于销毁Actor，在镜头恢复后调用，与UI销毁时序不固定
function M:TryDestroyActors()
    if(self.bActorsDestroyed)then
        return
    end
    if(not self.bDestructed)then
        self.bTryDestroyActorsWhenDestruct = true
        return
    end
    self.bActorsDestroyed = true
    self:Component_DestroyActors()
    self:DestroyHelper()
    self:AfterDestroyActors()
end

function M:AfterDestroyActors()
    self:Component_AfterDestroyActors()
end

function M:Component_AfterDestroyActors()
end

function M:Component_DestroyActors()
end

---主要用于组件移除监听、释放内存
function M:Component_OnDestruct()
end

function M:ViewTarget()
    if(self.IsControled or self.bDestructed)then
        return
    end
    if(not IsValid(self.ArmoryHelper))then
        return
    end
    self.ArmoryHelper:ViewTarget()
end

function M:OnAfterHelperEndViewTarget(NewTarget)
    self:TryDestroyActors()
    if(self.Event_AfterEndViewTarget)then
        self.Event_AfterEndViewTarget.Func(self.Event_AfterEndViewTarget.Obj)
    end
end

function M:DestroyHelper()
    if(not IsValid(self.ArmoryHelper))then
        return
    end
    self.ArmoryHelper:DestroyViewActorIfNeed()
    self.ArmoryHelper:DestroySelf()
end

function M:GetViewTarget()
    return self.ArmoryHelper
end

function M:SetAvatar(Avatar)
    self.Avatar = Avatar
end

function M:GetAvatar()
    return self.Avatar
end

function M:DestoryCreature(Key)
    if(self.Creatures[Key])then
        self.Creatures[Key]:DestroyEffectCreature()
        self.Creatures[Key] = nil
    end
end

function M:Init(Params)
    Params = Params or {}
    self.Params = Params
    self.ViewUI = Params.ViewUI                                     --正在使用这个对象的UI
    self.IsPreviewMode = Params.IsPreviewMode                       --是否预览模式 (预览模式不会修改实际玩家数据)
    self.EPreviewSceneType = Params.EPreviewSceneType               --预览场景类型
    self.PreviewSceneLocation = Params.PreviewSceneLocation         --预览场景创建位置
    self.SkyBoxIndex = Params.SkyBoxIndex                           --天空盒颜色索引
    self.bNeedEndCamera = Params.bNeedEndCamera                     --是否需要退场镜头
    self.Avatar = Params.Avatar or ArmoryUtils:GetAvatar()          --Avatar，可以不传
    self.CurrentCharInfo = Params.Char                              --Avatar的Char，用于创建角色模型
    self.CurrentWeaponInfo = Params.Weapon                          --Avatar的Weapon，用于创建武器模型
    self.CurrentPetInfo = Params.Pet                                --Avatar的Pet，用于创建宠物模型
    self.bEnableReflection = Params.bEnableReflection               --启用倒影
    if(self.EPreviewSceneType and self.bEnableReflection == nil)then
        --预览场景默认启用倒影
        self.bEnableReflection = true
    end
    self.Event_OnRecorverCameraStart = Params.OnRecorverCameraStart --开场镜头结束委托：{Func = function,Obj = table}
    self.Event_OnRecorverCameraEnd = Params.OnRecorverCameraEnd     --退场镜头结束委托：{Func = function,Obj = table}
    self.Event_AfterEndViewTarget = Params.AfterEndViewTarget       --EndViewTarget委托：{Func = function,Obj = table}
    self.ViewActorTypes = {Player = 1,SingleWeapon = 2}
    self.Creatures = {}
    self.Reflections = {}
    self.ReflectionOwners = {}
    self.IsSecondary = SelfObjCount > 1
    self.UIName = self.ViewUI:GetUIConfigName()
    if Params.bPlayRoleChangedSound ~= nil then
        self.bPlayRoleChangedSound = Params.bPlayRoleChangedSound
    else
        self.bPlayRoleChangedSound = true
    end
    if(self.CurrentPetInfo)then
        local Gender2RoleIds = DataMgr.Player2RoleId.Player
        local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime,{CharIds = {Gender2RoleIds[self.Avatar.Sex]}})
        local _,tempChar = next(DummyAvatar.Chars)
        self.CurrentCharInfo = tempChar
    end
   
    EventManager:AddEvent(EventID.OnWindowResized, self, function(self)
        --因为self不是UObject所以用UI
        self.ViewUI:AddTimer(0.3,function()
            if(self.LastCameraTags)then
                self:SetArmoryCameraTag(table.unpack(self.LastCameraTags))
            end
        end,false,0,"DelayUpdateCamera",true)
    end)

    -- 预览模式和自身是二级界面不移除位置同步
    if(self.IsPreviewMode or self.IsSecondary)then
        return
    end
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self.ViewUI, 0)
    if(not Player)then
        return
    end
    print(_G.LogtTag, "Player:RemoveSyncUsingWeapon()")
    -- Player:RemoveSyncLocation()
end

---@return Armory_ActorController
function M:New(Params)
    SelfObjCount = SelfObjCount + 1
	local Obj = {}
	self.__index = self
	setmetatable(Obj, self)
	Obj:Init(Params)
	return Obj
end

AssembleComponents(M)

return M

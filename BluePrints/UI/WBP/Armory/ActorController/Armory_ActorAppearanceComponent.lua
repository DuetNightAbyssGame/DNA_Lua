local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"

---@type Armory_ActorController
local M = {}

function M:Init(Params)
    EventManager:AddEvent(EventID.OnCharGradeLevelUp,self,self.OnCharGradeLevelUp)
    EventManager:AddEvent(EventID.OnWeaponBreakLevelUp, self, self.OnWeaponBreakLevelUp)
end

--#region 角色外观

---角色同卡等级变化，更新外观
function M:OnCharGradeLevelUp(Ret,CharUuid,CurrentGradeLevel)
    if(not self.CurrentCharInfo or self.CurrentCharInfo.Uuid ~= CharUuid)then
        return
    end
    local Avatar = self:GetAvatar()
    local Char = Avatar.Chars[CharUuid]
    if(Char)then
        local OnCharGradeLevelUpInternal = function(Character)
            if(Character == nil or Character.CharacterFashion == nil)then
                return
            end
            Character.CharacterFashion:GradeUpEmissive(Char.GradeLevel)
            if(Character.InfoForInit)then
                Character.InfoForInit.GradeLevel = Char.GradeLevel
            end
        end
        OnCharGradeLevelUpInternal(self.ArmoryPlayer)
        OnCharGradeLevelUpInternal(self:GetReflectionActor(self.ArmoryPlayer))
    end
end

---改变角色全部外观
---@param AppearanceInfo table 由此方法产生 Char:DumpAppearanceSuit(Avatar,AppearanceIndex)
function M:ChangeCharAppearance(AppearanceInfo)
    if(not self.ArmoryPlayer or not self.ArmoryPlayer.CharacterFashion)then
        return
    end
    self.CurrentAppearanceInfo = AppearanceInfo
    self.bPlaySameMontage = true
    local ChangeCharAppearanceInternal = function(Character)
        if(Character == nil)then
            return
        end
        if(Character.CurrentCompositeMesh)then
            Character.CurrentCompositeMesh = nil
        end
        local ModelComp = Character:GetCharModelComponent()
        if ModelComp then
            ModelComp:LoadCurrentModel()
        end
        Character.CharacterFashion:InitAppearanceSuit(AppearanceInfo)
        if(Character.PlayerAnimInstance) then
            Character.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
        end
    end
    ChangeCharAppearanceInternal(self.ArmoryPlayer)
    local ReflectionActor = self:GetReflectionActor(self.ArmoryPlayer)
    ChangeCharAppearanceInternal(ReflectionActor)
    if(ReflectionActor)then
        self:UpdatePlayerReflectionTrans()
    end
end

-- ---改变角色皮肤
-- function M:ChangeCharSkin(SkinId)
--     if(not self.ArmoryPlayer)then
--         return
--     end
--     self.CurrentAppearanceInfo.SkinId = SkinId
--     local ChangeCharSkinInternal = function(Character)
--         local CharacterFashion = Character and Character.CharacterFashion
--         if(not CharacterFashion)then
--             return
--         end
--         Character.CharacterFashion:ChangeCharSkin(SkinId)
--         if(Character.PlayerAnimInstance) then
--             Character.PlayerAnimInstance:SetKawiiLayerState(EKawaiiLayerState.EKLS_Armory)
--         end
--     end
--     ChangeCharSkinInternal(self.ArmoryPlayer)
--     local ReflectionActor = self:GetReflectionActor(self.ArmoryPlayer)
--     ChangeCharSkinInternal(ReflectionActor)
--     if(ReflectionActor)then
--         self:UpdatePlayerReflectionTrans()
--     end
-- end

---改变角色发型
function M:ChangeCharHair(HariId)
    if(not self.ArmoryPlayer)then
        return
    end
    self.CurrentAppearanceInfo.HariId = HariId
    local ChangeCharHairInternal = function(Character)
        local CharacterFashion = Character and Character.CharacterFashion
        if(not CharacterFashion)then
            return
        end
        CharacterFashion:ChangeCharHair(HariId)
    end
    ChangeCharHairInternal(self.ArmoryPlayer)
    ChangeCharHairInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

---改变角色发型全部染色
function M:ChangeCharHairColor(Colors)
    self.CurrentAppearanceInfo.HairColors = Colors
    local ChangeCharHairColorInternal = function(Character)
        local CharacterFashion = Character and Character.CharacterFashion
        if(not CharacterFashion)then
            return
        end
        CharacterFashion:InitHairColors(Colors)
    end
    ChangeCharHairColorInternal(self.ArmoryPlayer)
    ChangeCharHairColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

---改变角色发型染色
function M:ChangeCharHairPartColor(PartIdx,Color,Fresnel)
    local ChangeCharHairPartColorInternal = function(Character)
        local CharacterFashion = Character and Character.CharacterFashion
        if(not CharacterFashion)then
            return
        end
        CharacterFashion:ChangeHairPartColor(PartIdx,Color,Fresnel)
    end
    ChangeCharHairPartColorInternal(self.ArmoryPlayer)
    ChangeCharHairPartColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

---改变角色皮肤全部染色
function M:ChangeCharSkinColor(Colors)
    self.CurrentAppearanceInfo.Colors = Colors
    local ChangeCharSkinColorInternal = function(PlayerCharacter)
        local CharacterFashion = PlayerCharacter and PlayerCharacter.CharacterFashion
        if(not CharacterFashion)then
            return
        end
        self.ArmoryPlayer.CharacterFashion:InitSkinColors(Colors)
    end
    ChangeCharSkinColorInternal(self.ArmoryPlayer)
    ChangeCharSkinColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

---改变角色部位染色
function M:ChangeCharPartColor(PartIdx,Color,Fresnel)
    local ChangeCharPartColorInternal = function(PlayerCharacter)
        local CharacterFashion = PlayerCharacter and PlayerCharacter.CharacterFashion
        if(not CharacterFashion)then
            return
        end
        CharacterFashion:ChangePartColor(PartIdx,Color,Fresnel)
    end
    ChangeCharPartColorInternal(self.ArmoryPlayer)
    ChangeCharPartColorInternal(self:GetReflectionActor(self.ArmoryPlayer))
end

---改变角色配饰
function M:ChangeCharAccessory(AccessoryId,AccessoryType,CustomParams)
    if(not self.ArmoryPlayer)then
        return
    end
    self.CurrentAppearanceInfo.AccessorySuit[CommonConst.NewCharAccessoryTypes[AccessoryType]] = AccessoryId
    local ChangeCharAccessoryInternal = function(PlayerCharacter)
        if(not PlayerCharacter)then
            return
        end
        PlayerCharacter.CharacterFashion:ChangeAccessory(AccessoryId,AccessoryType,CustomParams)
        PlayerCharacter.CharacterFashion:RefreshUncoloredSkinColors(self.CurrentAppearanceInfo.Colors)
    end
    ChangeCharAccessoryInternal(self.ArmoryPlayer)
    ChangeCharAccessoryInternal(self:GetReflectionActor(self.ArmoryPlayer))

end

local ShowFXAccessoryPrefix = "ShowFXAccessory_"

M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Dead] = function(self,Player,AccessoryId,AccessoryType)
    Player = Player or self:GetPlayerActor()
    local Data = DataMgr.CharAccessory[AccessoryId]
    local CreatureKey = AccessoryType
    self:DestoryCreature(CreatureKey)
    local CreatureId = Data and Data.CreatureId or 14001
    Player:AsyncCreateEffectCreatureWithCallBack(CreatureId, FTransform(FRotator(0,0,180),FVector(0,0,0),FVector(1)), true, "Root",
    {self.ViewUI,function(_, Creature)
            self:DestoryCreature(CreatureKey)
            Creature:SetActorHiddenInGame(false)
            self.Creatures[CreatureKey] = Creature
        end
    })
end

M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Footprint] = function(self,Player,AccessoryId,AccessoryType)
    Player = Player or self:GetPlayerActor()
    local Data = DataMgr.CharAccessory[AccessoryId]
    local FXId = Data and Data.VisualEffectId
    if(not FXId)then return end
    local Loc = Player:K2_GetActorLocation()
    Loc.Z = Loc.Z - Player.CapsuleComponent:GetScaledCapsuleHalfHeight() - 2.4
    self.PlayerFXTimerKeys["PlayFootprintFXLoop"] = true
    local PlayEffect = function(PlayerCharacter)
        if(PlayerCharacter == nil)then return end
        PlayerCharacter.FXComponent:PlayEffectByIDParams(FXId, {bTickEvenWhenPaused = true,UseAbsoluteLocation = true,Location = {Loc.X,Loc.Y,Loc.Z}})
    end
    PlayEffect(Player)
    PlayEffect(self:GetReflectionActor(Player))
    self.ArmoryHelper:AddTimer(1,function()
        PlayEffect(Player)
        PlayEffect(self:GetReflectionActor(Player))
    end,true,0,"PlayFootprintFXLoop",true)
end

M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_Teleport] = function(self,Player,AccessoryId,AccessoryType)
    Player = Player or self:GetPlayerActor()
    local PlayerReflection = self:GetReflectionActor(Player)
    local Data = DataMgr.CharAccessory[AccessoryId]
    local MontagePath = Data and Data.Montage or "Teleport_01_Montage"
    local PlayTeleport = function(PlayerCharacter)
        if(PlayerCharacter == nil)then return end
        PlayerCharacter:PlayActionMontage("Interactive/MechInteractive", MontagePath,{},false, true, false)
        PlayerCharacter.PlayerAnimInstance:Montage_JumpToSection("End")
    end
    local PauseMontage = function(PlayerCharacter)
        if(PlayerCharacter == nil)then return end
        PlayerCharacter.PlayerAnimInstance:Montage_Pause()
    end

    Player:PlayActionMontage("Interactive/MechInteractive", MontagePath, {
        OnNotifyBegin = function()
            PauseMontage(Player)
            PauseMontage(PlayerReflection)
            self:HidePlayerActor(self.UIName,true)
            self.PlayerMontageTimerKeys["PlayTeleportMontage"] = true
            self.TeleportMontagePaused = true
            self.ArmoryHelper:AddTimer(1,function()
                PlayTeleport(Player)
                PlayTeleport(PlayerReflection)
                Player:PlayActionMontage("Interactive/MechInteractive", MontagePath,{},false, true, false)
                Player.PlayerAnimInstance:Montage_JumpToSection("End")
                self:HidePlayerActor(self.UIName,false)
                self.TeleportMontagePaused = false
            end,false, 0.0, "PlayTeleportMontage",true)
        end,
        OnInterrupted = function()
            self:HidePlayerActor(self.UIName,false)
        end,
    }, false, true, true)
    if(PlayerReflection)then
        PlayerReflection:PlayActionMontage("Interactive/MechInteractive", MontagePath,{},false, false, true, true)
    end
end

M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_PlungingATK] = function(self,Player,AccessoryId,AccessoryType)
    self:ChangeCharAccessory(AccessoryId,AccessoryType)
    local Avatar = GWorld:GetAvatar()
    local WeaponData = Avatar.Weapons[Avatar.MeleeWeapon]
    local PlayerActor = Player or self:GetPlayerActor()
    self:ChangePlayerWeapon(WeaponData,PlayerActor)
    local PlayFallAttack = function(PlayerCharacter)
        if(PlayerCharacter == nil)then return end
        PlayerCharacter:SetArmoryTag(Const.ArmoryWeaponIdleTags.Armory_FallAttack)
    end
    PlayFallAttack(PlayerActor)
    PlayFallAttack(self:GetReflectionActor(PlayerActor))
end

M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.FX_HelixLeap] = function(self,Player,AccessoryId,AccessoryType)
    self:ChangeCharAccessory(AccessoryId,AccessoryType)
    local PlayBullutJump = function(PlayerCharacter)
        if(PlayerCharacter == nil)then return end
        PlayerCharacter:SetArmoryTag(Const.ArmoryIdleTags.Armory_BullutJump)
    end
    PlayBullutJump(self:GetPlayerActor())
    PlayBullutJump(self:GetReflectionActor(self:GetPlayerActor()))
end

--region MVP

local MVPLocation = FVector(200000,200000,200000)

local PlaySequenceByAccessoryId = function(self,Params)
    local Player = Params.Player
    local AccessoryId = Params.AccessoryId
    local Data = DataMgr.CharAccessory[AccessoryId]
    if(not Data)then
        return
    end
    local MVPPath = Data.MVPKey 
    local MontagePath = Data.Montage
    self.BeforeSequenceLocation = Player:K2_GetActorLocation()
    Player:K2_SetActorLocation(MVPLocation,false,nil,false)
    Player:PlayDungeonSettlementMVPMontage(MontagePath)
    if(Player.MVPSequenceActor)then
        local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
        if(SequencePlayer)then
            SequencePlayer:Stop()
        end
    end
    Player:PlayDungeonSettlementMVPSequence(MVPPath)
    if(Player.MVPSequenceActor)then
        local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
        if(SequencePlayer)then
            SequencePlayer:PlayLooping()
            if(SequencePlayer.OnLoop)then
                SequencePlayer.OnLoop:Clear()
                SequencePlayer.OnLoop:Add(self.ViewUI,function()
                    Player:PlayDungeonSettlementMVPMontage(MontagePath)
                end)
            end
        end
    end
end

local PlaySequenceByPath = function(self,Params)
    local Player = Params.Player
    if(not IsValid(Player))then
        return
    end

    Player:PlayActionMontage("Interactive", Params.MontagePath, {})
    Player:SetCharacterTag("LevelFinish")
    Player:PlayMVPSequence(Params.SequencePath,FTransform(FRotator(0,-90,0):ToQuat(),Const.ZeroVector,Const.OneVector))
    if(Player.MVPSequenceActor)then
        local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
        if(SequencePlayer)then
            SequencePlayer:PlayLooping()
        end
    end
    if(Params.ActorRotation)then
        Player:K2_SetActorRotation(Params.ActorRotation, false, nil, true)
    end
end

local PlaySequenceInternal = function(self,Params)
    UIManager(self.ViewUI):ShowCommonBlackScreen({
        OutAnimationPlayTime = 1,
        IsPlayOutWhenLoaded = true
    })
    self.SequenceInfo = Params
    if(Params.AccessoryId)then
        PlaySequenceByAccessoryId(self,Params)
    elseif(Params.SequencePath)then
        PlaySequenceByPath(self,Params)
    end
    self:HidePlayerActor("ActorController_ChangeViewTarget",false)
    self.IsPlayingSequence = true
    self.ArmoryHelper:AddTimer(0.03,function()
        --延迟取消暂停游戏，防止时序问题导致游戏再次被暂停以及光照问题
        self:SetGamePauseIfNeed(false)
        self:RefreshEnvironment()
    end,false,0,"DelayUnpauseGame",true)
end

function M:SetGamePauseIfNeed(bPause)
    if(self.SequenceActorController or self.SequenceInfo)then
        local Avatar = GWorld:GetAvatar()
        if  not (Avatar and Avatar.CurrentOnlineType and Avatar.CurrentOnlineType ~= -1) then 
            self.ViewUI:UISetGamePaused(self.ViewUI.WidgetName or self.ViewUI.ConfigName, bPause)
        end
    end
end

function M:PlaySequence(Params)
    if(self.SequenceActorController)then
        local PlayerActor = self.SequenceActorController:GetPlayerActor()
        if(PlayerActor)then
            Params.Player = PlayerActor
            PlaySequenceInternal(self.SequenceActorController,Params)
        end
    else
        local PlayerActor = self:GetPlayerActor()
        if(PlayerActor)then
            Params.Player = PlayerActor
            PlaySequenceInternal(self,Params)
        end
    end
end

function M:ReplaySequence()
    if(self.SequenceActorController and self.SequenceActorController.SequenceInfo)then
        self:StopSequence()
        PlaySequenceInternal(self.SequenceActorController,self.SequenceActorController.SequenceInfo)
    elseif (self.SequenceInfo) then
        self:StopSequence()
        PlaySequenceInternal(self,self.SequenceInfo)
    end
end

local StopSequenceInternal = function(self)
    self.ArmoryHelper:RemoveTimer("DelayUnpauseGame") 
    local Player = self.SequenceInfo.Player
    self.SequenceInfo = nil
    self.IsPlayingSequence = false
    Player:StopMontage()
    Player:StopMVPSequence()
    if(self.BeforeSequenceLocation)then
        Player:K2_SetActorLocation(self.BeforeSequenceLocation,false,nil,false)
    end
    self:RefreshEnvironment()
end

function M:StopSequence()
    if(self.SequenceActorController and self.SequenceActorController.SequenceInfo)then
        StopSequenceInternal(self.SequenceActorController)
    elseif (self.SequenceInfo) then
        StopSequenceInternal(self)
    end
end

local PauseSequenceInternal = function(self)
    self.bSequencePaused = true
    self.ArmoryHelper:RemoveTimer("DelayUnpauseGame")
    -- if(self.SequenceInfo.AccessoryId)then
        local Player = self.SequenceInfo.Player
        if(Player and Player.MVPSequenceActor)then
            local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
            if(SequencePlayer)then
                SequencePlayer:Pause()
            end
        end
    -- else
    -- end
end

function M:PauseSequence()
    if(self.SequenceActorController and self.SequenceActorController.SequenceInfo)then
        PauseSequenceInternal(self.SequenceActorController)
    elseif (self.SequenceInfo) then
        PauseSequenceInternal(self)
    end
end

local IsMVPSequencePausedInternal = function(self)
    local Player = self.SequenceInfo.Player
    if(Player and Player.MVPSequenceActor)then
        local SequencePlayer = Player.MVPSequenceActor:GetSequencePlayer()
        if(SequencePlayer)then
            return SequencePlayer:IsPaused()
        end
    end
end

local IsSequencePausedInternal = function(self)
    -- if(self.SequenceInfo.AccessoryId)then
        return IsMVPSequencePausedInternal(self)
    -- else
    -- end
end

function M:IsSequencePaused()
    if(self.SequenceActorController and self.SequenceActorController.SequenceInfo)then
        return IsSequencePausedInternal(self.SequenceActorController)
    elseif (self.SequenceInfo) then
        return IsSequencePausedInternal(self)
    end
end

function M:ShouldPlaySequence()
    return self.SequenceInfo or (self.SequenceActorController and self.SequenceActorController.SequenceInfo)
end

function M:TryCreateSequenceActorController()
    if(not self.SequenceActorController)then
        local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"
        self.SequenceActorController = ActorController:New({
            ViewUI = self.ViewUI,
            IsPreviewMode = true,
            bEnableReflection = false,
            EPreviewSceneType = self.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon,
            SkyBoxIndex = self.SkyBoxIndex,
            Char = self.CurrentCharInfo,
            AfterEndViewTarget = {Func = self.AfterSequenceActorControllerEndViewTarget,Obj = self},
        })
        self.SequenceActorController:OnOpened()
    end
end

function M:AfterSequenceActorControllerEndViewTarget()
    local TopStackUI = UIManager(self.ViewUI):GetWidgetObjInTopStack()
    if(TopStackUI ~= self.ViewUI and not self:IsSequencePaused())then
        self:StopSequence()
    end
end

function M:TryDestroySequenceActorController()
    if(self.SequenceActorController)then
        self:StopSequence()
        self.SequenceActorController:OnDestruct()
        self.SequenceActorController = nil
        self:ViewTarget()
    end
end

--endregion MVP

M[ShowFXAccessoryPrefix .. CommonConst.CharAccessoryTypes.MVP] = function(self,Player,AccessoryId,AccessoryType)
    self:StopSequence()
    self:PlaySequence({AccessoryId = AccessoryId})
end

--显示角色特效部位
function M:ShowPlayerFXAccessory(AccessoryId,AccessoryType)
    if(not AccessoryType)then
        return
    end
    local Player = self:GetPlayerActor()
    if(not Player)then
        return
    end
    local FuncName = ShowFXAccessoryPrefix .. AccessoryType
    if(self[FuncName])then
        self[FuncName](self,Player,AccessoryId,AccessoryType)
    end
end

---设置角色配饰偏移
function M:SetCharAccessoryOffset(AccessoryId,AccessoryType,Scale,Location,Rotation)
    if(not self.ArmoryPlayer)then
        return
    end
    local Trans
    if(Rotation)then
        Trans = FTransform(Rotation:ToQuat(),Const.ZeroVector,Const.OneVector)
    else
        Trans = FTransform(Const.ZeroRotator:ToQuat(),Const.ZeroVector,Const.OneVector)
    end
    if(Location)then
        Trans.Translation = Location
    end
    if(Scale)then
        Trans.Scale3D = Scale
    end
    local OriginTrans = self.ArmoryPlayer.CharacterFashion:GetAccessoryOriginOffset(AccessoryId)
    Trans = Trans * OriginTrans
    local SetCharAccessoryOffsetInternal = function(PlayerCharacter)
        if(PlayerCharacter == nil)then return end
        PlayerCharacter:SetAccessoryTransform(AccessoryId, AccessoryType, Trans)
    end
    SetCharAccessoryOffsetInternal(self:GetPlayerActor())
    SetCharAccessoryOffsetInternal(self:GetReflectionActor(self:GetPlayerActor()))
end

---开始 角色 部位高亮动画
function M:StartPlayerPartHighLight(LastColor,PartIdx,HighLightColor,Curve)
    local CharacterFashion = self.ArmoryPlayer and self.ArmoryPlayer.CharacterFashion
    local FunctionName = "SetCharTintColor"..PartIdx
    local Func = CharacterFashion[FunctionName]
    local _TickFrequency = 0.033
    local _,MaxTime = Curve:GetTimeRange()
    local PassedTime = 0
    local Alpha
    if(Func)then
        self.ArmoryHelper:AddTimer(_TickFrequency,function()
            PassedTime = PassedTime + _TickFrequency
            if(PassedTime >= MaxTime)then
                self:StopPlayerPartHighLight(PartIdx)
                self:ChangeCharPartColor(PartIdx,LastColor)
                return
            end
            Alpha = Curve:GetFloatValue(PassedTime)
            self:ChangeCharPartColor(PartIdx,UKismetMathLibrary.LinearColorLerp(HighLightColor,LastColor,Alpha))
        end,true, 0.0, FunctionName,true)
    end
end

---停止 角色 部位高亮动画
function M:StopPlayerPartHighLight(PartIdx)
    local FunctionName = "SetCharTintColor"..PartIdx
    self.ArmoryHelper:RemoveTimer(FunctionName)
end
--#endregion 角色外观

--#region 武器外观

---改变武器配饰
function M:ChangeWeaponAccessory(AccessoryId,AccessoryType)
    local _ChangeWeaponAccessory = function(...)
        local Func = function(WeaponActor)
            if(WeaponActor == nil)then return end
            WeaponActor:ChangeAccessory(AccessoryId,AccessoryType)
        end
        local WeaponActor = self:GetWeaponActor()
        if(not WeaponActor)then
            return
        end
        self.CurrentWeaponAppearanceInfo.AccessorySuit[CommonConst.WeaponAccessoryTypeIndex[AccessoryType]] = AccessoryId
        Func(WeaponActor)
        Func(self:GetReflectionActor(WeaponActor))
    end
    self:DoSomethingWithWeapon("ChangeWeaponAccessory",_ChangeWeaponAccessory)
end

---改变角色武器配饰
function M:ChangePlayerWeaponAccessory(AccessoryId,AccessoryType)
    local _ChangePlayerWeaponAccessory = function(...)
        local Func = function(WeaponActor)
            if(WeaponActor == nil)then return end
            WeaponActor:ChangeAccessory(AccessoryId,AccessoryType)
        end
        local WeaponActor = self:GetWeaponActor()
        if(not WeaponActor)then
            return
        end
        self.CurrentWeaponAppearanceInfo.AccessoryId = AccessoryId
        Func(WeaponActor)
        Func(self:GetReflectionActor(WeaponActor))
    end
    self:DoSomethingWithWeapon("ChangePlayerWeaponAccessory",_ChangePlayerWeaponAccessory)
end

---改变武器全部染色
function M:ChangeWeaponColor(ColorInfo)
    local _ChangeWeaponColor = function(...)
        local Func = function(WeaponActor)
            if(WeaponActor == nil)then return end
            WeaponActor:InitWeaponBreakMI()
            WeaponActor:InitWeaponColor(ColorInfo)
        end
        local WeaponActor = self:GetWeaponActor()
        if(not WeaponActor)then
            return
        end
        self.CurrentWeaponAppearanceInfo.Colors = ColorInfo
        Func(WeaponActor)
        Func(self:GetReflectionActor(WeaponActor))
    end
    self:DoSomethingWithWeapon("ChangeWeaponColor",_ChangeWeaponColor)
end

---改变武器部位染色
function M:ChangeWeaponPartColor(PartIdx,Color)
    local _ChangeWeaponPartColor = function()
        local Func = function(WeaponActor)
            if(WeaponActor == nil)then return end
            WeaponActor:InitWeaponBreakMI()
            local FunctionName = "SetWPTintColor"..PartIdx
            local Func = WeaponActor[FunctionName]
            if(Func)then
                Func(WeaponActor,Color)
            end
            if(WeaponActor.ChildWeapon)then
                Func = WeaponActor.ChildWeapon[FunctionName]
                if(Func)then
                    Func(WeaponActor.ChildWeapon,Color)
                end
            end
        end
        local WeaponActor = self:GetWeaponActor()
        if(not WeaponActor)then
            return
        end
        Func(WeaponActor)
        Func(self:GetReflectionActor(WeaponActor))
    end
    self:DoSomethingWithWeapon("ChangeWeaponPartColor",_ChangeWeaponPartColor)
end

---改变武器皮肤
function M:ChangeWeaponSkin(SkinId)
    local _ChangeWeaponSkin = function()
        local Func = function(WeaponActor)
            if(WeaponActor == nil)then
                return
            end
            self.CurrentWeaponAppearanceInfo.SkinId = SkinId
            if(SkinId == self.CurrentWeaponInfo.WeaponId)then
                WeaponActor:InitWeaponSkin()
            else
                WeaponActor:InitWeaponSkin(SkinId)
            end
            WeaponActor:OnWeaponReady()
        end
        local WeaponActor = self:GetWeaponActor()
        Func(WeaponActor)
        Func(self:GetReflectionActor(WeaponActor))
    end
    self:DoSomethingWithWeapon("ChangeWeaponSkin",_ChangeWeaponSkin)
end

---改变角色武器皮肤
function M:ChangePlayerWeaponSkin(SkinId)
    local _ChangePlayerWeaponSkin = function()
        local WeaponActor = self:GetPlayerWeaponActor()
        if(WeaponActor)then
            self.CurrentWeaponAppearanceInfo.SkinId = SkinId
            if(SkinId == self.CurrentWeaponInfo.WeaponId)then
                WeaponActor:InitWeaponSkin()
            else
                WeaponActor:InitWeaponSkin(SkinId)
            end
            WeaponActor:OnWeaponReady()
        end
    end
    self:DoSomethingWithWeapon("ChangePlayerWeaponSkin",_ChangePlayerWeaponSkin)
end

---改变武器外观
function M:ChangeWeaponAppearance(AppearanceInfo)
    local _ChangeWeaponAppearance = function()
        self.CurrentWeaponAppearanceInfo = AppearanceInfo
        local Func = function(WeaponActor)
            if(WeaponActor == nil)then
                return
            end
            WeaponActor:InitWeaponAppearance(AppearanceInfo)
            WeaponActor:OnWeaponReady()
        end
        local WeaponActor = self:GetWeaponActor()
        Func(WeaponActor)
        Func(self:GetReflectionActor(WeaponActor))
    end
    self:DoSomethingWithWeapon("ChangeWeaponAppearance",_ChangeWeaponAppearance)
end

---开始武器部位高亮动画
function M:StartWeaponPartHighLight(LastColor,PartIdx,HighLightColor,Curve)
    local _StartWeaponPartHighLight = function()
        local UsingWeapon = self.ArmoryWeapon or (self.ArmoryPlayer and self.ArmoryPlayer.UsingWeapon)
        local FunctionName = "SetWPTintColor"..PartIdx
        local Func = UsingWeapon[FunctionName]
        local _TickFrequency = 0.033
        local _,MaxTime = Curve:GetTimeRange()
        local PassedTime = 0
        local Alpha
        if(Func)then
            self.ArmoryHelper:AddTimer(_TickFrequency,function()
                PassedTime = PassedTime + _TickFrequency
                if(PassedTime >= MaxTime)then
                    self:StopWeaponPartHighLight(PartIdx)
                    self:ChangeWeaponPartColor(PartIdx,LastColor)
                    return
                end
                Alpha = Curve:GetFloatValue(PassedTime)
                self:ChangeWeaponPartColor(PartIdx,UKismetMathLibrary.LinearColorLerp(HighLightColor,LastColor,Alpha))
            end,true, 0.0, FunctionName,true)
        end
    end
    self:DoSomethingWithWeapon("StartWeaponPartHighLight",_StartWeaponPartHighLight)
end

---停止武器部位高亮动画
function M:StopWeaponPartHighLight(PartIdx)
    local FunctionName = "SetWPTintColor"..PartIdx
    self.ArmoryHelper:RemoveTimer(FunctionName)
end

function M:OnWeaponBreakLevelUp(Ret,WeaponUuid,EnhanceLevel)
    if Ret ~= ErrorCode.RET_SUCCESS then
        return 
    end
    if(not self.CurrentWeaponInfo or WeaponUuid ~= self.CurrentWeaponInfo.Uuid)then
        return
    end
    -- 武器突破特效
    self:SetWeaponActorEnhanceLevel(EnhanceLevel)
end

---改变武器突破特效
function M:SetWeaponActorEnhanceLevel(EnhanceLevel)
    if(not self:GetWeaponActor())then
        return
    end
    local ColorInfo = self.CurrentWeaponInfo:DumpColors()
    local SetWeaponActorEnhanceLevelInternal = function(WeaponActor)
        if(WeaponActor == nil)then return end
        WeaponActor:SetAttr("EnhanceLevel",EnhanceLevel)
        WeaponActor:InitWeaponBreakMI()
        WeaponActor:InitWeaponColor(ColorInfo)
    end
    local Actor = self:GetWeaponActor()
    SetWeaponActorEnhanceLevelInternal(Actor)
    SetWeaponActorEnhanceLevelInternal(self:GetReflectionActor(Actor))
end

function M:SkinWeaponVFX(ColorData)
    local ArmoryPlayer = self.ArmoryPlayer
    self.SkinWeaponVFXHandle = ArmoryPlayer.FXComponent:PlayEffectByIDParams(306, {bTickEvenWhenPaused = true,NotAttached = true})
    local Color = FLinearColor(ColorData.R,ColorData.G,ColorData.B)
    self.SkinWeaponVFXHandle:SetVariableLinearColor("Color", Color)
end

function M:StopSkinWeaponVFX()
    if self.SkinWeaponVFXHandle and self.SkinWeaponVFXHandle:IsValid() then
        local name = self.SkinWeaponVFXHandle:GetName()
        -- self.SkinWeaponVFXHandle:SetVisibility(false, false)
        self.SkinWeaponVFXHandle:Deactivate()
        self.SkinWeaponVFXHandle = nil
    end
end

function M:ChangeSkinWeaponVFXColor(ColorData)
    if self.SkinWeaponVFXHandle and self.SkinWeaponVFXHandle:IsValid() then
        local Color = FLinearColor(ColorData.R,ColorData.G,ColorData.B)
        self.SkinWeaponVFXHandle:SetVariableLinearColor("Color", Color)
    end
end

--#endregion 武器外观

function M:Component_OnDestruct()
    EventManager:RemoveEvent(EventID.OnCharGradeLevelUp,self)
    EventManager:RemoveEvent(EventID.OnWeaponBreakLevelUp, self)
end

function M:Component_DestroyActors()
    self:TryDestroySequenceActorController()
end

return M
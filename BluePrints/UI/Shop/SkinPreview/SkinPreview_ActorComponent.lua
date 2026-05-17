---@type SkinPreview_ActorComponent
local M = {"BluePrints.Common.DelayFrameComponent"}

function M:Construct()
end

--- 根据 ItemData 更新预览 Actor
function M:UpdatePreviewActor(ItemData, WeaponCameraOffset)
    self.Avatar = GWorld:GetAvatar()
    if not self.Avatar then
        return
    end

    self.UIName = self:GetUIConfigName()
    self.WeaponCameraOffset = WeaponCameraOffset or FVector(0, 0, 0)
    self.IsRiderMount = true
    self.EnableDrag = true
    self.EnableMouseWheel = true

    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:AddDelayFrameFunc(function()
        self:BlockAllUIInput(false)
    end, 31)
    local Index = 0
    if ItemData.ItemType == "Resource" then
        local ResEntry = DataMgr.Resource[ItemData.TypeId]
        if ResEntry and ResEntry.SkyBoxIndex ~= nil then
            Index = ResEntry.SkyBoxIndex
        end
    end
    
    if ItemData.ItemType == "Resource" then
        local ResourceData = DataMgr.Resource[ItemData.TypeId]
        if not ResourceData then
            return
        end
        if ResourceData.ResourceSType ~= "GestureItem" and ResourceData.ResourceSType ~= "MountItem" then
            return
        end
        ItemData.ResourceSType = ResourceData.ResourceSType
    end

    self.Params = self:GenerateActorParams(ItemData)
    if not self.Params then return end
    
    if not self.ActorController then
        self.Params.Target = self:CreatePreviewTargetData(self.Params)
        self:InitializePreviewActor(ItemData)
        self:NotifySkyBox(Index)
    else
        self:HideAllPreviewActor()
        self:StopActorSound()
        self:UpdateExistingPreviewActor(ItemData)
        self:NotifySkyBox(Index)
    end
end

--- 参数生成调度器
function M:GenerateActorParams(ItemData)
    local itemType = ItemData.ItemType
    if itemType == "Background" then
        return self:_GenerateBackgroundParams(ItemData, self.Avatar)
    elseif itemType == "Char" then
        return { Type = "Char", SkinId = ItemData.TypeId }
    elseif itemType == "Weapon" then
        return { Type = "Weapon", SkinId = ItemData.TypeId }
    elseif itemType == "Skin" then
        return self:_GenerateSkinParams(ItemData)
    elseif itemType == "Hair" then
        return { Type = "Char", HairId = ItemData.TypeId }
    elseif itemType == "GeneralSkin" then
        return self:_GenerateSkinSeriesParams(ItemData, self.Avatar)
    elseif itemType == "WeaponSkin" then
        return self:_GenerateWeaponSkinParams(ItemData)
    elseif itemType == "CharAccessory" then
        return self:_GenerateCharAccessoryParams(ItemData, self.Avatar)
    elseif itemType == "WeaponAccessory" then
        return self:_GenerateWeaponAccessoryParams(ItemData, self.Avatar)
    elseif itemType == "Resource" then
        if ItemData.ResourceSType == "GestureItem" then
            return self:_GenerateCharGestureParams(ItemData, self.Avatar)
        end
    elseif itemType == "Mount" then
        return self:_GenerateCharMountsParams(ItemData, self.Avatar)
    end
    return nil
end

function M:_GenerateBackgroundParams(ItemData, Avatar)
    local Char = Avatar.Chars[Avatar.CurrentChar]
    ItemData.TypeId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
    return { Type = "Char", SkinId = ItemData.TypeId }
end

function M:_GenerateSkinParams(ItemData)
    local SkinData = DataMgr.Skin[ItemData.TypeId]
    if not SkinData then return nil end
    return { Type = "Char", SkinId = SkinData.SkinId }
end

function M:_GenerateSkinSeriesParams(ItemData, Avatar)
    local CharId = Avatar.Chars[Avatar.CurrentChar].CharId
    local SkinInfo = DataMgr.Skin
    local Gender2RoleIds = Const.DefaultAttributeMaster
    local PlayerCharId = Gender2RoleIds[Avatar.Sex]
    local Params = nil
    for SkinId, Info in pairs(SkinInfo) do
        if Info.SkinSeries == ItemData.SkinSeries and Info.CharId == CharId then
            Params = { Type = "Char", SkinId = SkinId }
            break
        elseif Info.SkinSeries == ItemData.SkinSeries and Info.CharId == PlayerCharId then
            Params = { Type = "Char", SkinId = SkinId }
        end
    end
    if not Params then
        return nil
    end
    ItemData.ItemType = "Skin"
    ItemData.TypeId = Params.SkinId
    return Params
end

function M:_GenerateWeaponSkinParams(ItemData)
    local WeaponSkinData = DataMgr.WeaponSkin[ItemData.TypeId]
    if not WeaponSkinData then return nil end
    return { Type = "Weapon", SkinId = WeaponSkinData.SkinID }
end

function M:_GenerateCharAccessoryParams(ItemData, Avatar)
    local AccessoryData = DataMgr.CharAccessory[ItemData.TypeId]
    if not AccessoryData then return nil end
    local Char = Avatar.Chars[Avatar.CurrentChar]
    return {
        Type = "Char",
        SkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId,
        AccessoryId = AccessoryData.AccessoryId,
        AccessoryType = AccessoryData.AccessoryType
    }
end

function M:_GenerateWeaponAccessoryParams(ItemData, Avatar)
    local WeaponAccessoryData = DataMgr.WeaponAccessory[ItemData.TypeId]
    if not WeaponAccessoryData then return nil end

    local Params = {
        Type = "Weapon",
        AccessoryId = WeaponAccessoryData.WeaponAccessoryId,
        AccessoryType = WeaponAccessoryData.AccessoryType,
        SkinId = nil
    }

    local weaponToCheck
    if self.Tab_Change and self.Tab_Change.TabIdx == 2 then
        weaponToCheck = Avatar.Weapons[Avatar.RangedWeapon]
    else
        weaponToCheck = Avatar.Weapons[Avatar.MeleeWeapon]
    end

    if weaponToCheck then
        local currentSkinId = weaponToCheck:GetCurrentSkin().SkinId
        if currentSkinId ~= weaponToCheck.WeaponId then
            Params.SkinId = currentSkinId
        end
    end

    return Params
end

function M:_GenerateCharGestureParams(ItemData, Avatar)
    local Char = Avatar.Chars[Avatar.CurrentChar]
    local Params = {
        Type = "Char",
        SkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId,
    }
    local Res = DataMgr.Resource[ItemData.TypeId]
    Params.SkyBoxIndex = (Res and Res.SkyBoxIndex) or 0
    return Params
end

function M:_GenerateCharMountsParams(ItemData, Avatar)
    local Params = {
        Type = "Char",
    }

    return Params
end

--- 首次创建和初始化预览Actor
function M:InitializePreviewActor(ItemData)
    self.ActorController = self:CreatePreviewActor(self.Params)

    local itemType = ItemData.ItemType
    if itemType == "Weapon" or itemType == "WeaponSkin" or itemType == "WeaponAccessory" then
        self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    end

    self.ActorController:OnOpened()
    self.ActorController.bPlayRoleChangedSound = false

    if itemType == "Background" then
        self:SetupInitialBackgroundPreview()
    elseif itemType == "Char" then
        self:SetupInitialCharPreview(ItemData)
    elseif itemType == "Weapon" then
        self:SetupInitialWeaponPreview(ItemData)
    elseif itemType == "Skin" then
        self:SetupInitialSkinPreview(ItemData)
    elseif itemType == "Hair" then
        self:SetupInitialHairPreview(ItemData)
    elseif itemType == "WeaponSkin" then
        self:SetupInitialWeaponSkinPreview(ItemData)
    elseif itemType == "Resource" then
        if ItemData.ResourceSType == "GestureItem" then
            self:SetupInitialGesturePreview(ItemData)
        end
    elseif itemType == "Mount" then
        self:SetupInitialMountsPreview(ItemData)
    elseif itemType == "CharAccessory" or itemType == "WeaponAccessory"then
        self:ApplyAccessoryPreview(itemType)
    end
end

--- 更新已存在的预览Actor
function M:UpdateExistingPreviewActor(ItemData)
    self:CleanupPreviousPreviewEffects()

    local itemType = ItemData.ItemType
    if itemType == "Background" then
        self:UpdateToBackgroundPreview(ItemData)
    elseif itemType == "Char" then
        self:UpdateToCharPreview(ItemData)
    elseif itemType == "Weapon" then
        self:UpdateToWeaponPreview(ItemData)
    elseif itemType == "Skin" then
        self:UpdateToSkinPreview(ItemData)
    elseif itemType == "Hair" then
        self:UpdateToHairPreview(ItemData)
    elseif itemType == "WeaponSkin" then
        self:UpdateToWeaponSkinPreview(ItemData)
    elseif itemType == "CharAccessory" then
        self:UpdateToCharAccessoryPreview(ItemData)
    elseif itemType == "WeaponAccessory" then
        self:UpdateToWeaponAccessoryPreview(ItemData)
    elseif itemType == "Resource" then
        if ItemData.ResourceSType == "GestureItem" then
            self:UpdateToGesturePreview(ItemData)
        end
    elseif itemType == "Mount" then
        self:UpdateToMountsPreview(ItemData)
    end
end

--- 清理上一个预览对象的特效和状态
function M:CleanupPreviousPreviewEffects()
    self.ActorController:StopPlayerFX()
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Body)
    self.ActorController:RemovePlayerGestureEffectCreature()
    self.ActorController:HidePlayerActor("ActorController_HidePlayerBeforeMount", false)
    self.ActorController:HidePlayerOnMount(false)
    self.ActorController:DestroyMount()
    self.ActorController:StopSequence()
    self.ActorController:ViewTarget()
    local Player = self.ActorController:GetPlayerActor()
    if Player then
        Player:SetActorScale3D(Const.OneVector)
    end
end

--- 将预览Actor重置为当前玩家的默认角色模型
function M:SetupDefaultCharacterModel()
    self.ActorController:HidePlayerActor(self.UIName, false)
    self:HidePlayerWeapon(true)
    self:HideSingleWeapon(true)

    local Char = self.Avatar.Chars[self.Avatar.CurrentChar]
    local CharSkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
    local Params = {Type = "Char", SkinId = CharSkinId}
    local Data = self:CreatePreviewTargetData(Params)

    self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
    self.ActorController.ExCameraOffset = FVector(0, 0, 0)
    self.ActorController:ChangeCharModel(Data, true, true)

    local AppearanceInfo = {CharId = Char.CharId, SkinId = CharSkinId, AccessorySuit = {}}
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)

    --- 隐藏玩家武器（ChangeCharModel会将非ArmoryWeapon、非Single的自带Melee武器显示出来）
    self.ActorController:HidePlayerMeleeWeapon()
end

--#region Actor初始化函数

function M:SetupInitialBackgroundPreview()
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
    self.ActorController:HidePlayerActor(self.UIName, true)
    self.ActorController:EnableCameraScrolling(false)
end

function M:SetupInitialCharPreview(ItemData)
    local CharId = DataMgr.Skin[ItemData.TypeId].CharId
    local CharSkinId = ItemData.TypeId
    local AppearanceInfo = {CharId = CharId, SkinId = CharSkinId, AccessorySuit = {}}
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:SetupInitialWeaponPreview(ItemData)
    local Tag = self.Params.Target:HasTag("Melee") and "Melee" or "Ranged"
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
    self.ActorController:EnableCameraScrolling(false)
end

function M:SetupInitialSkinPreview(ItemData)
    local CharId = DataMgr.Skin[ItemData.TypeId].CharId
    local CharSkinId = ItemData.TypeId
    local AppearanceInfo = {CharId = CharId, SkinId = CharSkinId, AccessorySuit = {}}
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:SetupInitialHairPreview(ItemData)
    local CharId = DataMgr.Hair[ItemData.TypeId].CharId
    local CharHairId = ItemData.TypeId
    local AppearanceInfo = {CharId = CharId, HairId = CharHairId, AccessorySuit = {}}
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:SetupInitialWeaponSkinPreview(ItemData)
    self.ActorController:ChangeWeaponSkin(ItemData.TypeId)
    local Tag = self.Params.Target:HasTag("Melee") and "Melee" or "Ranged"
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
    self.ActorController:EnableCameraScrolling(false)
end

function M:SetupInitialGesturePreview(ItemData)
    local ResourceData = DataMgr.Resource[ItemData.TypeId]
    if ResourceData then
        self:ClearCharAccessory()
        self.ActorController:ChangeWeaponModel(self.Avatar.Weapons[self.Avatar.MeleeWeapon])
        self.ActorController:ChangeWeaponModel(self.Avatar.Weapons[self.Avatar.RangedWeapon])
        self.ActorController:ClearPlayerGestureHideTags()
        self.ActorController:SetArmoryMontageTag("Armory")
        self.ActorController:SetArmoryCameraTag(ResourceData.CameraName or "Char", "", "")
        self.ActorController:PlayResourceMotion(ItemData.TypeId)
    end
end

function M:SetupInitialMountsPreview(ItemData)
    local MountData = DataMgr.Mount[ItemData.TypeId]

    self.ActorController:SetArmoryCameraTag(MountData.CameraName or CommonConst.ArmoryType.Char, "", "")
    self.ActorController:HidePlayerOnMount(false)
    self.ActorController:CreateMount(ItemData.TypeId)
end

--#endregion

--#region 更新Actor状态的函数

function M:ApplyAccessoryPreview(itemType)
    self.ActorController.bPlaySameMontage = true
    self:UpdateAccessoryCamera(self.Params.AccessoryId, self.Params.AccessoryType)
    if (itemType == "CharAccessory") then
        self.ActorController:StopPlayerMontage()
        self:ClearCharAccessory()
        --MVP Sequence不能旋转缩放
        if self.Params.AccessoryType == CommonConst.CharAccessoryTypes.MVP then
            self.EnableDrag = false
            self.EnableMouseWheel = false
        end
        -- 特效类配件
        if UIConst.FXAccessoryTypes[self.Params.AccessoryType] then
            self.ActorController:ShowPlayerFXAccessory(self.Params.AccessoryId, self.Params.AccessoryType)
            if UIConst.HidePlayerAccessoryTypes[self.Params.AccessoryType] then
                self.ActorController:HidePlayerActor(self.UIName, true)
            end
        else -- 模型类配件
            self.ActorController:ChangeCharAccessory(self.Params.AccessoryId, self.Params.AccessoryType,self.Params.CustomParams)
        end
    else -- 武器配件
        self.ActorController:ChangeWeaponAccessory(self.Params.AccessoryId,CommonConst.WeaponAccessoryTypes.Accessory)
        self.ActorController:EnableCameraScrolling(false)
    end
end

function M:UpdateToBackgroundPreview(ItemData)
    self:HidePlayerWeapon(true)
    self:HideSingleWeapon(true)

    local CharSkinId = ItemData.TypeId
    self.Params.Target = self:CreatePreviewTargetData({Type = "Char", SkinId = CharSkinId})

    self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
    self.ActorController.ExCameraOffset = FVector(0, 0, 0)
    self.ActorController:ChangeCharModel(self.Params.Target, true, true)
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
    self.ActorController:HidePlayerActor(self.UIName, true)
    self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToCharPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, false)
    self:HidePlayerWeapon(true)
    self:HideSingleWeapon(true)

    local CharId = DataMgr.Skin[ItemData.TypeId].CharId
    local CharSkinId = ItemData.TypeId
    local AppearanceInfo = {CharId = CharId, SkinId = CharSkinId, AccessorySuit = {}}
    self.Params.Target = self:CreatePreviewTargetData({Type = "Char", SkinId = CharSkinId})

    self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
    self.ActorController.ExCameraOffset = FVector(0, 0, 0)
    self.ActorController:ChangeCharModel(self.Params.Target, true, true)
    self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController.DelayFrame = 30
    self.ActorController.bPlaySameMontage = true
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:UpdateToWeaponPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, true)
    self:HidePlayerWeapon(true)
    -- self:HideSingleWeapon(false)

    self.Params.Target = self:CreatePreviewTargetData({Type = "Weapon", SkinId = ItemData.TypeId})
    self.ActorController.bStandaloneWeapon = true
    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    self.ActorController:ChangeSingleWeapon(self.Params.Target)
    local AppearanceInfo = {SkinId = ItemData.TypeId}
    self.ActorController:ChangeWeaponAppearance(AppearanceInfo)
    self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToSkinPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, false)
    self:HidePlayerWeapon(true)
    self:HideSingleWeapon(true)

    local CharId = DataMgr.Skin[ItemData.TypeId].CharId
    local CharSkinId = ItemData.TypeId
    local AppearanceInfo = {CharId = CharId, SkinId = CharSkinId, AccessorySuit = {}}
    if ItemData.SkinLevel then
        AppearanceInfo.SkinLevel = ItemData.SkinLevel
    end
    self.Params.Target = self:CreatePreviewTargetData({Type = "Char", SkinId = CharSkinId})

    self.ActorController.bStandaloneWeapon = false
    self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
    self.ActorController.ExCameraOffset = FVector(0, 0, 0)
    self.ActorController:ChangeCharModel(self.Params.Target, true, true)
    self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController.DelayFrame = 30
    self.ActorController.bPlaySameMontage = true
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:UpdateToHairPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, false)
    self:HidePlayerWeapon(true)
    self:HideSingleWeapon(true)

    local CharId = DataMgr.Hair[ItemData.TypeId].CharId
    local CharHairId = ItemData.TypeId
    local AppearanceInfo = {CharId = CharId, HairId = CharHairId, AccessorySuit = {}}
    self.Params.Target = self:CreatePreviewTargetData({Type = "Char", HairId = CharHairId})

    self.ActorController.bStandaloneWeapon = false
    self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
    self.ActorController.ExCameraOffset = FVector(0, 0, 0)
    self.ActorController:ChangeCharModel(self.Params.Target, true, true)
    self.ActorController.ArmoryHelper:SetPlayer(self.ActorController.ArmoryPlayer)
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController.DelayFrame = 30
    self.ActorController.bPlaySameMontage = true
    self.ActorController:SetMontageAndCamera("Char", nil, nil)
end

function M:UpdateToWeaponSkinPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, true)
    self:HidePlayerWeapon(true)
    -- self:HideSingleWeapon(false)

    self.Params.Target = self:CreatePreviewTargetData({Type = "Weapon", SkinId = ItemData.TypeId})
    self.ActorController.bStandaloneWeapon = true
    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    self.ActorController:ChangeSingleWeapon(self.Params.Target)
    -- self.ActorController:ChangeWeaponSkin(ItemData.TypeId)
    local AppearanceInfo = {SkinId = ItemData.TypeId}
    self.ActorController:ChangeWeaponAppearance(AppearanceInfo)
    self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToCharAccessoryPreview(ItemData)
    self:SetupDefaultCharacterModel()
    self:ApplyAccessoryPreview("CharAccessory")
end

function M:UpdateToWeaponAccessoryPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, true)
    self:HidePlayerWeapon(true)
    self:HideSingleWeapon(false)

    local WeaponAccessoryData = DataMgr.WeaponAccessory[ItemData.TypeId]
    if not WeaponAccessoryData then return end

    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    if self.Tab_Change and self.Tab_Change.TabIdx == 2 then
        self.Tab_Change:BtnSwitchToLeft()
        self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.MeleeWeapon])
    else
        self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.MeleeWeapon], self.LastItemType == "WeaponAccessory")
    end
    self.ActorController:ChangeWeaponAccessory(WeaponAccessoryData.WeaponAccessoryId,CommonConst.WeaponAccessoryTypes.Accessory)
    self.ActorController:EnableCameraScrolling(false)
end

function M:UpdateToGesturePreview(ItemData)
    self:SetupDefaultCharacterModel()

    self.ActorController:SetArmoryMontageTag("Armory")
    self.ActorController:PlayResourceMotion(ItemData.TypeId)

    local GestureData = DataMgr.Resource[ItemData.TypeId]
    if GestureData then
        self.ActorController:SetArmoryCameraTag(GestureData.CameraName or "Char", "", "")
    end
end

function M:UpdateToMountsPreview(ItemData)
    self:SetupDefaultCharacterModel()
    self.IsRiderMount = true
    self.ActorController:DestroyMount()
    self.ActorController:HidePlayerOnMount(false)
    self.ActorController:CreateMount(ItemData.TypeId)

    local MountData = DataMgr.Mount[ItemData.TypeId]
    self.ActorController:SetArmoryCameraTag(MountData.CameraName or CommonConst.ArmoryType.Char, "", "")
    
    self.ActorController.ArmoryHelper:SetViewActor(self.ActorController.ArmoryPlayer)
end

function M:ClearCharAccessory()
    self.ActorController:StopPlayerFX()
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Body)
    self.ActorController:RemovePlayerGestureEffectCreature()
    local Char = self.Avatar.Chars[self.Avatar.CurrentChar]
    local CharSkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId
    local AppearanceInfo = {CharId = Char.CharId, SkinId = CharSkinId, AccessorySuit = {}}
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
end

--#endregion

--#region 套装预览

function M:ApplySuitPreview(ItemData)
    local Rewards = DataMgr.Reward[ItemData.SuitRewardId[1]]
    if not Rewards then return end

    self.ActorController:HidePlayerActor(self.UIName, false)
    self:HideSingleWeapon(true)

    local AppearanceInfo = {CharId = -1, SkinId = -1, AccessorySuit = {}}
    local currentItemType = ItemData.ItemType
    if currentItemType == "Skin" then
        AppearanceInfo.CharId = DataMgr.Skin[ItemData.TypeId].CharId
        AppearanceInfo.SkinId = ItemData.TypeId
    end

    if currentItemType == "WeaponSkin" or currentItemType == "WeaponAccessory" then
        self:HideSingleWeapon(true)
        self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 90, 0))
    end

    if currentItemType ~= "Skin" then
        self.ActorController.DelayFrame = 30
    end

    for i = 1, #Rewards.Id do
        if not (currentItemType == "Skin" and Rewards.Type[i] == "Skin") then
            self:ApplySingleRewardItem(Rewards.Type[i], Rewards.Id[i], AppearanceInfo)
        end
    end

    self.ActorController:ChangeCharAppearance(AppearanceInfo)
end

function M:ApplySingleRewardItem(rewardType, rewardId, AppearanceInfo)
    if rewardType == "Skin" then
        local CharData = self:CreatePreviewTargetData({Type = "Char", SkinId = rewardId})
        self.ActorController:ChangeCharModel(CharData, true, true)
        AppearanceInfo.CharId = DataMgr.Skin[rewardId].CharId
        AppearanceInfo.SkinId = rewardId
        self:HideZoomKey(false)

    elseif rewardType == "WeaponSkin" then
        self:HidePlayerWeapon(false)
        local WeaponData = self:CreatePreviewTargetData({Type = "Weapon", SkinId = rewardId})
        self.ActorController:ChangeWeaponModel(WeaponData)
        self.ActorController:ChangePlayerWeaponSkin(rewardId)
        local Tag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
        self.ActorController.DelayFrame = 30
        self.ActorController.bPlaySameMontage = true
        self.ActorController:SetMontageAndCamera("Weapon", Tag)

    elseif rewardType == "CharAccessory" then
        local AccessoryType = DataMgr.CharAccessory[rewardId].AccessoryType
        AppearanceInfo.AccessorySuit[CommonConst.NewCharAccessoryTypes[AccessoryType]] = rewardId
        self:HideZoomKey(false)

    elseif rewardType == "WeaponAccessory" then
        self:HidePlayerWeapon(false)
        self.ActorController:ChangePlayerWeaponAccessory(rewardId)
    end
end

function M:RevertToSingleItemPreview(ItemData)
    local itemType = ItemData.ItemType

    if itemType == "Skin" then
        self:RevertToSkinPreview(ItemData)
    elseif itemType == "WeaponSkin" then
        self:RevertToWeaponSkinPreview(ItemData)
    elseif itemType == "CharAccessory" then
        self:RevertToCharAccessoryPreview(ItemData)
    elseif itemType == "WeaponAccessory" then
        self:RevertToWeaponAccessoryPreview(ItemData)
    end
end

--#endregion

--#region 撤销套装展示后的恢复函数

--- 恢复到皮肤
function M:RevertToSkinPreview(ItemData)
    local CharId = DataMgr.Skin[ItemData.TypeId].CharId
    local CharSkinId = ItemData.TypeId
    local AppearanceInfo = {CharId = CharId, SkinId = CharSkinId, AccessorySuit = {}}
    self.ActorController:ChangeCharAppearance(AppearanceInfo)
    self.ActorController.DelayFrame = 30
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, nil)
    self.ActorController.bStandaloneWeapon = true
    self:HideZoomKey(false)
end

--- 恢复到武器皮肤
function M:RevertToWeaponSkinPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, true)
    self:HidePlayerWeapon(true)
    local WeaponData = self:CreatePreviewTargetData({Type = "Weapon", SkinId = ItemData.TypeId})
    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    self.ActorController.ArmoryHelper:SetOriginalRotation(FRotator(0, 0, 0))
    self.ActorController:ChangeSingleWeapon(WeaponData)
    self.ActorController:ChangeWeaponSkin(ItemData.TypeId)
    self.ActorController:EnableCameraScrolling(false)
    self.ActorController.bStandaloneWeapon = true
    self:HideZoomKey(true)
end

--- 恢复到角色饰品
function M:RevertToCharAccessoryPreview(ItemData)
    local AccessoryData = DataMgr.CharAccessory[ItemData.TypeId]
    local Char = self.Avatar.Chars[self.Avatar.CurrentChar]
    local Params = {Type = "Char", SkinId = Char.AppearanceSuits[Char.CurrentAppearanceIndex].SkinId}
    local Data = self:CreatePreviewTargetData(Params)
    local CustomParams = Char:DumpAccessoryCustomParams(Char.AppearanceSuits) or {}

    self.ActorController:ChangeCharModel(Data, true, true)
    self:UpdateAccessoryCamera(AccessoryData.AccessoryId, AccessoryData.AccessoryType)
    self.ActorController:StopPlayerMontage()
    self.ActorController:ChangeCharAccessory(AccessoryData.AccessoryId, AccessoryData.AccessoryType,CustomParams[AccessoryData.AccessoryId])
    self:HideZoomKey(false)
end

--- 恢复到武器饰品
function M:RevertToWeaponAccessoryPreview(ItemData)
    self.ActorController:HidePlayerActor(self.UIName, true)
    local WeaponAccessoryData = DataMgr.WeaponAccessory[ItemData.TypeId]
    if not WeaponAccessoryData then return end

    self.ActorController:ResetActorRotation()
    self.ActorController.ExCameraOffset = self.WeaponCameraOffset

    if self.Tab_Change.TabIdx == 2 then
         self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.RangedWeapon])
    else
         self.ActorController:ChangeSingleWeapon(self.Avatar.Weapons[self.Avatar.MeleeWeapon])
    end

    self.ActorController:ChangeWeaponAccessory(WeaponAccessoryData.WeaponAccessoryId,CommonConst.WeaponAccessoryTypes.Accessory)
    self.ActorController:EnableCameraScrolling(false)
    self:HideZoomKey(true)
end

--#endregion

--- 武器配饰预览切换（近战/远程）
function M:SwitchWeaponAccessoryPreview(TabIdx)
    if not self.ActorController or not self.Avatar then
        return
    end

    local WeaponToDisplay
    if TabIdx == 1 then
        WeaponToDisplay = self.Avatar.Weapons[self.Avatar.MeleeWeapon]
    elseif TabIdx == 2 then
        WeaponToDisplay = self.Avatar.Weapons[self.Avatar.RangedWeapon]
    else
        return
    end
    if not WeaponToDisplay then return end

    local AccessoryId = self.Params and self.Params.AccessoryId
    if not AccessoryId then
        return
    end

    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    self.ActorController:ChangeSingleWeapon(WeaponToDisplay)
    self.ActorController:ChangeWeaponAccessory(AccessoryId,CommonConst.WeaponAccessoryTypes.Accessory)
end

--- 重播动作/资源预览
function M:ReplayGesture(ResourceTypeId)
    if not self.ActorController or not self.ActorController.ArmoryPlayer then
        return
    end
    local ResourceData = DataMgr.Resource[ResourceTypeId]
    if ResourceData and ResourceData.ResourceSType == "GestureItem" then
        self.ActorController:PlayResourceMotion(ResourceTypeId)
    end
end

--- 骑乘状态切换
function M:RiderMount()
    self.IsRiderMount = not self.IsRiderMount

    if self.IsRiderMount then
        self.ActorController:HidePlayerOnMount(false)
    else
        self.ActorController:HidePlayerOnMount(true)
    end
end

--#region 工具函数

function M:NotifySkyBox(Index)
    if not self.ActorController then
        return
    end
    self.ActorController:ChangeSkyBoxColor(Index)
end

function M:HidePlayerWeapon(IsHidden)
    if not self.ActorController:GetPlayerWeaponActor() then
        return
    end
    self.ActorController:GetPlayerWeaponActor():SetActorHideTag(self.UIName, IsHidden)
end

function M:HideSingleWeapon(IsHidden)
    if not UIManager(self).ShowWeapon then
        return
    end
    UIManager(self).ShowWeapon:SetActorHideTag(self.UIName, IsHidden)
    -- if not self.ActorController:GetSingleWeaponActor() then
    --     return
    -- end
    -- self.ActorController:GetSingleWeaponActor():SetActorHideTag(self.UIName, IsHidden)
end

function M:HideAllPreviewActor()
    if self.ActorController then
        self.ActorController:HidePlayerActor(self.UIName, true)
        self:HidePlayerWeapon(true)
        self:HideSingleWeapon(true)
    end
end

function M:StopActorSound()
    if self.ActorController and self.ActorController.ArmoryPlayer then
        self.ActorController:StopPlayerMontage()
        self.ActorController:StopPlayerFX()
        self.ActorController:RemovePlayerGestureEffectCreature()
    end
end

function M:SetCameraToDefault()
    if self.CurrentCameraState == "Default" then
        return
    end

    local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local PreviewController = self.ActorController
    if Controller and Player and PreviewController then
        self:CloseMVPSequence()
        Controller:SetViewTargetWithBlend(Player)
        self.CurrentCameraState = "Default"
    end
end

function M:SetCameraToPreviewActor()
    if self.CurrentCameraState == "Preview" then
        return
    end

    local Controller = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local PreviewController = self.ActorController
    if Controller and PreviewController then
        local PreviewTargetActor = PreviewController:GetViewTarget()
        if PreviewTargetActor then
            Controller:SetViewTargetWithBlend(PreviewTargetActor)
        end
    end
    self.CurrentCameraState = "Preview"
end

function M:ResetWeaponCamera()
    if self.ActorController then
        self.ActorController.ExCameraOffset = self.WeaponCameraOffset
        self.ActorController:SetSingleWeaponCamera(self.Params.Target, true)
        self.ActorController:EnableCameraScrolling(false)
    end
end

--#endregion

function M:CloseMVPSequence()
    if self.ActorController then
        self.ActorController:StopSequence()
    end
end

function M:DestroyPreviewActor()
    if self.ActorController then
        self.ActorController:DestroyMount()
        self.ActorController:OnDestruct()
        self.ActorController = nil
    end
end

function M:ClosePreview()
    if self.ActorController then
        self.ActorController:RevertPlayerGestureEffectCreature()
    end
end

return M

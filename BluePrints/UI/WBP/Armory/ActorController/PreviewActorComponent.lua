--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local ActorController = require "BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController"

local M = {}

function M:CreatePreviewActor(Params)
    --Params.Type = "Char"|"Weapon"
    --Params.Target = Params.Target --角色或武器数据可以通过CreatePreviewTargetData创建
    if(not self.ActorController)then
        local Char,Weapon
        if(Params.Type == "Char")then
            Char = Params.Target
        else
            Weapon = Params.Target
        end
        self.NeedDestroyActorController = true
        self.ActorController = ActorController:New({
            ViewUI = self,
            IsPreviewMode = true,
            Char = Char,
            Weapon = Weapon,
            Avatar = self._DummyAvatar,
            bNeedEndCamera = false,
            EPreviewSceneType = Params.EPreviewSceneType or CommonConst.EPreviewSceneType.PreviewCommon,
            SkyBoxIndex = Params.SkyBoxIndex,
        })
    end
    return self.ActorController
end

function M:CreatePreviewTargetData(Params)
    --Params.SkinId = 1011
    --Params.HairId = 1011
    --Params.Accessory
    --Params.Type = Char|Weapon
    local Avatar = GWorld:GetAvatar()
    if(Params.Type == "Char")then
        local Char = Avatar.Chars[Avatar.CurrentChar]
        local SkinData
        if(Params.SkinId)then
            SkinData = DataMgr.Skin[Params.SkinId]
        elseif(Params.HairId)then
            SkinData = DataMgr.Hair[Params.HairId]
        end
        if(SkinData)then
            if(SkinData.CharId ~= Char.CharId) or (Params.SystemType == "BattlePass") or (Char:GetAppearance().SkinId ~= SkinId) then
                local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime,{CharIds = {SkinData.CharId}})
                self._DummyAvatar = DummyAvatar
                if(self.ActorController)then
                    self.ActorController:SetAvatar(self._DummyAvatar)
                end
                local _,temp = next(DummyAvatar.Chars)
                Char = temp
                Char:GetAppearance().SkinId = Params.SkinId or Char:GetAppearance().SkinId
                Char:GetAppearance().HairId = Params.HairId or Char:GetAppearance().HairId
                if(Params.Accessory)then
                    local AppearanceSuit = Char:GetAppearance()
                    for k,v in pairs(Params.Accessory) do
                        AppearanceSuit.Accessory[k] = v
                    end
                end
            end
        end
        return Char
    elseif(Params.Type == "Weapon")then
        local Weapon
        if(Params.SkinId)then
            local WeaponId
            local SkinData = DataMgr.WeaponSkin[Params.SkinId]
            local AppType
            if SkinData then
                AppType = SkinData.ApplicationType
            else
                SkinData = DataMgr.Weapon[Params.SkinId]
                if SkinData then
                    WeaponId = Params.SkinId
                    AppType = SkinData.SkinApplicationType[1]
                end
            end
            if(WeaponId == nil)then
                for key, value in pairs(DataMgr.Weapon) do
                    if(UIUtils.CanApplyWeaponSkin(value.WeaponId,AppType))then
                        WeaponId = value.WeaponId
                        break
                    end
                end
            end
            if(WeaponId)then
                local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime,{WeaponIds = {WeaponId}})
                self._DummyAvatar = DummyAvatar
                if(self.ActorController)then
                    self.ActorController:SetAvatar(self._DummyAvatar)
                end
                local _,temp = next(DummyAvatar.Weapons)
                Weapon = temp
                Weapon:GetAppearance().SkinId = Params.SkinId
                Weapon:AddSkin(Params.SkinId)
                if(Params.Accessory)then
                    local AppearanceSuit = Weapon:GetAppearance()
                    for k,v in pairs(Params.Accessory) do
                        AppearanceSuit.Accessory[k] = v
                    end
                end
            end
        else
            Weapon = Avatar.Weapons[Avatar.MeleeWeapon]
            if(not Weapon)then
                Weapon = Avatar.Weapons[Avatar.RangedWeapon]
            end
        end
        return Weapon
    end
end

---更新配饰镜头
function M:UpdateAccessoryCamera(AccessoryId,AccessoryType)
    if(self.ActorController:IsWeaponActorLoading())then
        return
    end
    if(self.ActorController)then
        local _AccessoryType = AccessoryType
        if(not _AccessoryType)then
            local Data = DataMgr.CharAccessory[AccessoryId]
            if(Data)then
                _AccessoryType = Data and Data.AccessoryType
            else
                Data = DataMgr.CharPartMesh[AccessoryId]
                _AccessoryType = Data and Data.AccessoryType
            end
        end
        self.ActorController.CameraOffsetAccessoryId = AccessoryId
        self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char,_AccessoryType,CommonConst.ArmoryTag.Appearance)
    end
end

-- 武器配饰切换远程与近战
function M:SwitchWeaponAccessoryPreview(TabIdx)
    local Avatar = GWorld:GetAvatar()
    if not self.ActorController or not Avatar then
        return
    end

    local WeaponToDisplay
    if TabIdx == 1 then
        WeaponToDisplay = Avatar.Weapons[Avatar.MeleeWeapon]
    elseif TabIdx == 2 then
        WeaponToDisplay = Avatar.Weapons[Avatar.RangedWeapon]
    else
        return
    end
    if not WeaponToDisplay then return end

    local AccessoryId = self.CurRoleContent and self.CurRoleContent.AccessoryId
    if not AccessoryId then
        return
    end

    self.ActorController.ExCameraOffset = self.WeaponCameraOffset
    self.ActorController:ChangeSingleWeapon(WeaponToDisplay)
    self.ActorController:ChangeWeaponAccessory(AccessoryId,CommonConst.WeaponAccessoryTypes.Accessory)
end

--清除角色配饰
function M:ClearCharAccessoryPreview()
    local Avatar = self.ActorController:GetAvatar()
    if not Avatar then return end
    self.ActorController:StopPlayerFX()
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Body)
    self.ActorController:StopPlayerMontage()
    self.ActorController:DestoryPlayerMeleeWeapon()
    if self.ActorController.ArmoryPlayer then
        self.ActorController.ArmoryPlayer:RemoveAllEffectCreature(false)
    end
    self.ActorController.CurrentAppearanceInfo = self.ActorController.CurrentAppearanceInfo or {}
    self.ActorController.CurrentAppearanceInfo.AccessorySuit = {}
    self.ActorController:ChangeCharAppearance(self.ActorController.CurrentAppearanceInfo)
end

function M:Destruct()
    if(self.NeedDestroyActorController and self.ActorController)then
        self.ActorController:OnDestruct()
    end
end

AssembleComponents(M)

return M

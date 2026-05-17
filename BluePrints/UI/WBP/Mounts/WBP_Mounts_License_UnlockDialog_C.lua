--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Mounts_License_UnlockDialog_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

M._components = {
    "BluePrints.UI.KeyInputComponent"
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Close.OnClicked:Add(self, self.OnLicenseUnlock_OnClicked)
end

function M:OnLicenseUnlock_OnClicked()
    self:PlayAnimation(self.Out)
end

function M:OnLoaded(LicenseId, ParentWidget)
    self:StopAllAnimations()
    self:SetFocus()
    self.LicenseId = LicenseId
    self.ParentWidget = ParentWidget
    self:PlayAnimation(self.In)
    self:PlayAnimation(self.Unlock_Normal)
    AudioManager(self):PlayUISound(self, "event:/ui/common/fly_liscense_region_in", nil, nil)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self:InitCommonUnlockUI()
    if Avatar:HasMountLicenseById(self.LicenseId) then
        self:InitUnLockUI()
        self:InitUnLockBtnInfo()
        self:PlayAnimation(self.Icon_Unlock, 0, 0, 0, 1, true)
    else
        self:InitLockUI()
        self:InitLockBtnInfo()
        self:PlayAnimation(self.Icon_Lock, 0, 0, 0, 1, true)
    end
    self:AddLongPressEvent(UIConst.GamePadKey.FaceButtonBottom, 1,
            self.OnGamepad_FaceButton_Bottom_LongPressStart,
            self.OnGamepad_FaceButton_Bottom_LongPressCancel,
            self.OnGamepad_FaceButton_Bottom_LongPressEnd)
end

function M:OnGamepad_FaceButton_Bottom_LongPressStart()
    self.Btn_Unlock.Key_Consume:OnButtonPressed(false, true, 0, self:GetLongPressAnimationTime("Gamepad_FaceButton_Bottom"))
end

function M:OnGamepad_FaceButton_Bottom_LongPressEnd()
    self.Btn_Unlock:SetFocus()
    self.HasFocusUnlock = true
end

function M:OnGamepad_FaceButton_Bottom_LongPressCancel()
    local FaceButtonBottomBtn = self.Btn_Unlock.Key_Consume
    FaceButtonBottomBtn:OnButtonReleased()
    FaceButtonBottomBtn:StopAllAnimations()
    FaceButtonBottomBtn:PlayAnimation(FaceButtonBottomBtn.Normal)
end

function M:InitCommonUnlockUI()
    local ConfigData = DataMgr.FlyLicense[self.LicenseId]
    self.Text_Title:SetText(GText(ConfigData.Name))
    self.Text_Desc:SetText(GText(ConfigData.Des))
    self.Text_Name:SetText(GText("UI_Mount_Name"))
    self.Text_Date:SetText(GText("UI_Mount_UnlockDate"))
    self.Text_Tip:SetText(GText("UI_RougeLike_End__ClickEmpty"))
    local Obj = LoadObject(ConfigData.Photo)
    local IconDynaMaterial = self.Img_Cover:GetDynamicMaterial()
    if Obj and IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("MainTex", Obj)
    end
    self.Key_Back:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B",
            },
        },
        Desc = GText("UI_WORLDMAP_ESC")
    })
end

function M:InitUnLockUI()
    local Avatar = GWorld:GetAvatar()
    self.Text_PlayerName:SetText(Avatar.Nickname)
    if not Avatar.MountFlyLicenses[self.LicenseId] then
        return
    end
    local year, month, day, hour, min, sec = TimeUtils.TimestampToData(Avatar.MountFlyLicenses[self.LicenseId])
    if not month or not day then
        return
    end
    self.Text_PlayerDate:SetText(string.format("%d-%02d-%02d", year, month, day))
end

function M:InitLockUI()
    self.Text_PlayerName:SetText("")
    self.Text_PlayerDate:SetText("")
end

function M:InitUnLockBtnInfo()
    self.Switch_Lock:SetActiveWidgetIndex(1)
    self.Text_UnlockArea:SetText(GText("UI_UNLOCKED"))
end

function M:InitLockBtnInfo()
    local Avatar = GWorld:GetAvatar()
    local ConfigData = DataMgr.FlyLicense[self.LicenseId]
    self.Switch_Lock:SetActiveWidgetIndex(0)
    local Resources = {}
    local ShopItemId = ShopUtils:GetShopItemDataById(ConfigData.Resource[1], CommonConst.DataType.Resource, true)
    local ResourceIcon = ItemUtils.GetItemIconPath(ConfigData.Resource[1], "Resource")
    local Resource = ConfigData.Resource and Avatar.Resources[ConfigData.Resource[1]]
    Resources[1] = {
        Id = ConfigData.Resource[1],
        Icon = ResourceIcon,
        ItemType = CommonConst.DataType.Resource,
        Count = Resource and Resource.Count or 0,
        NeedCount = 1,
        ShopItemId = ShopItemId,
        IsShowDetails = true,
        ShowRedFont = true,
    }
    local RedDot = ReddotManager.GetTreeNode("MountLicense_Item")
    self.Btn_Unlock:Init({
        Owner = self,
        bShowCoin = true,
        Id = ConfigData.Resource[1],
        Resources = Resources,
        ResourceKeyInfos = {
            KeyInfoList = {{Type="Img", ImgShortPath="A"}},
            bLongPress = true,
        },
        KeyInfos = {
            KeyInfoList = {{Type="Img", ImgShortPath="A", ClickCallback = self.OnUnlockBtnClicked, Owner = self}},
        },
        Text = GText("UI_Unlock_Topic"),
        ShowReddot = RedDot.Count > 0,
        OnClicked = self.OnUnlockBtnClicked,
    })
end

function M:OnUnlockBtnClicked()
    if self.Switch_Lock:GetActiveWidgetIndex() ~= 0 then
        return
    end
    local Avatar = GWorld:GetAvatar()
    local ConfigData = DataMgr.FlyLicense[self.LicenseId]
    Avatar:LevelUpFlyLicense(self.LicenseId, ConfigData.Resource[1], function(Ret)
        if Ret == ErrorCode.RET_SUCCESS then
            self:OnUnlockLicenseCallBack()
        else
            UIManager(self):ShowUITip("CommonToastMain", GText("FlyLicense_NotEnough_Tips"), 1.5)
        end
    end)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
end

function M:OnUnlockLicenseCallBack()
    self:StopAnimation(self.Icon_Lock)
    self:PlayAnimation(self.Icon_Unlock, 0, 0, 0, 1, true)
    self:PlayAnimation(self.UnLock)
    self:InitUnLockUI()
    self:InitUnLockBtnInfo()
    self.ParentWidget:InitLicenseUI()
    ReddotManager.DecreaseLeafNodeCount("MountLicense_Item", 1)
    AudioManager(self):PlayUISound(self, "event:/ui/common/fly_liscense_region_unlock", nil, nil)
    EventManager:FireEvent(EventID.OnGetLicense)
end

function M:Destruct()
    self.Btn_Close.OnClicked:Clear()
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:Close()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" then
        self:PlayAnimation(self.Out)
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        if not self.HasFocusUnlock then
            self:PlayAnimation(self.Out)
        else
            self:SetFocus()
            self.HasFocusUnlock = false
        end
    end
    local t = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    return t
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Gamepad_FaceButton_Bottom" and not self.HasFocusUnlock then
        self:OnUnlockBtnClicked()
    end
    local t = self:ProcessOnKeyUp(MyGeometry, InKeyEvent)
    return t
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    local IsGamePad = GameInputModeSubsystem and GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
    self.WS_Tip:SetActiveWidgetIndex(IsGamePad and 1 or 0)
    if not IsGamePad then
        self:SetFocus()
        self.HasFocusUnlock = false
    end
end

AssembleComponents(M)

return M

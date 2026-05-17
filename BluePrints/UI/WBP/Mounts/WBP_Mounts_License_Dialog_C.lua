--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Mounts_License_Dialog_C
local M = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.DelayFrameComponent"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddDispatcher(EventID.OnGetLicense, self, self.OnGetLicense)
    self:InitLicenseUI()
    self:CreateLicenseItem()
    self:BindBtnEvents()
end

function M:OnGetLicense()
    self:InitLicenseUI()
end

function M:OnLoaded()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm_positive", nil, nil)
end

function M:InitLicenseUI()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Text_LicenseTitle:SetText(GText("UI_Mount_FlyLicense"))
    self.Text_UnlockArea:SetText(GText("UI_Mount_FlyLicense_Activated"))
    self.Num_Hold:SetText(CommonUtils.TableLength(Avatar.MountFlyLicenses))
    local Count = 0
    for i, v in pairs(DataMgr.FlyLicense) do
        Count = Count + 1
    end
    self.Num_Total:SetText(Count)
    self.Key_Confirm:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A",
            },
        },
        Desc = GText("UI_Tips_Ensure")
    })
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

function M:InitNavigationOfItem()
    for i = 1, #self.NavigationItems do
        if i ~= 1 then
            self.NavigationItems[i].Btn_Area:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
                self.FocusItem = self.NavigationItems[i - 1]
                self.ScrollBox_License:ScrollWidgetIntoView(self.NavigationItems[i - 1], true, UE4.EDescendantScrollDestination.Center)
                return self.NavigationItems[i - 1].Btn_Area
            end})
        end
        if i ~= #self.NavigationItems then
            self.NavigationItems[i].Btn_Area:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
                self.FocusItem = self.NavigationItems[i + 1]
                self.ScrollBox_License:ScrollWidgetIntoView(self.NavigationItems[i + 1], true, UE4.EDescendantScrollDestination.Center)
                return self.NavigationItems[i + 1].Btn_Area
            end})
        end
    end
    self.NavigationItems[1].Btn_Area:SetNavigationRuleCustom(EUINavigation.Left, {self, function()
        self.FocusItem = self.NavigationItems[1]
        return self.NavigationItems[1].Btn_Area
    end})
    self.NavigationItems[#self.NavigationItems].Btn_Area:SetNavigationRuleCustom(EUINavigation.Right, {self, function()
        self.FocusItem = self.NavigationItems[#self.NavigationItems]
        return self.NavigationItems[#self.NavigationItems].Btn_Area
    end})
end

function M:CreateLicenseItem()
    self.ScrollBox_License:ClearChildren()
    local Count = 0
    self.NavigationItems = {}
    local FlyLicenseIds = {}
    for LicenseId, v in pairs(DataMgr.FlyLicense) do
        table.insert(FlyLicenseIds, LicenseId)
    end
    table.sort(FlyLicenseIds)
    for _, LicenseId in ipairs(FlyLicenseIds) do
        local Item = UIManager(self):_CreateWidgetNew("MountLicenseItem")
        if not Item then
            return
        end
        Item:InitLicenseItem(LicenseId, self)
        self.ScrollBox_License:AddChild(Item)
        Count = Count + 1
        table.insert(self.NavigationItems, Item)
    end
    self:AddDelayFrameFunc(function()
        self:InitNavigationOfItem()
        self.NavigationItems[1].Btn_Area:SetFocus()
        self.FocusItem = self.NavigationItems[1]
    end, 1)
    local Interval = 4 - Count
    if Interval > 0 then
        for i = 1, Interval do
            local Item = UIManager(self):_CreateWidgetNew("MountLicenseItem")
            if not Item then
                return
            end
            Item:InitLicenseItem(0)
            self.ScrollBox_License:AddChild(Item)
        end
    end
end

function M:BindBtnEvents()
    self.Btn_Close:BindEventOnClicked(self, self.OnCloseBtnClicked)
end

function M:OnCloseBtnClicked()
    self.IsPlayOut = true
    self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out and self.IsPlayOut then
        self:Close()
        self.IsPlayOut = false
    end
end

function M:Destruct()
    self.Btn_Close:UnBindEventOnClicked(self, self.OnCloseBtnClicked)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if InKeyName == "Escape" then
        self:Close()
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        self:Close()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    local IsGamePad = GameInputModeSubsystem and GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
    self.HB_Key_GamePad:SetVisibility(IsGamePad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    for i = 1, #self.NavigationItems do
        self.NavigationItems[i]:OnUpdateUIStyleByInputTypeChange()
    end
    if IsGamePad and self.FocusItem then
        self.FocusItem.Btn_Area:SetFocus()
    end
end

function M:ReceiveEnterState(StackAction)
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    self.Overridden.ReceiveEnterState(self, StackAction)
end

function M:ReceiveExitState(StackAction)
    if StackAction == 0 then
        self:StopAnimation(self.In)
        self:PlayAnimation(self.Out)
    end
    self.Overridden.ReceiveExitState(self, StackAction)
end

return M

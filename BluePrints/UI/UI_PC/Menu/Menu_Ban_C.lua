--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Menu_Ban_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- 初始化函数，外部调用传入惩罚次数
---@param PunishCount number 惩罚次数
function M:InitPunishCount(PunishCount)
    self:SetFocus()
    self.TextBan:SetText(GText("UI_DungeonPunish_Tips"))

    self.PunishCountText = string.format(GText("UI_DungeonPunish_Times"), PunishCount)
    self.TextTimeContent:SetText(self.PunishCountText)

    self.Btn.Onclicked:Add(self, self.ShowPunishPopup)

    self.WBP_Com_BtnQa:Init({
        OwnerWidget = self,
        PopupID = 100297,
        ClickCallback = self.ShowPunishPopup
    })
    self:RefreshControllerUI()
end

function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()
    self.TextTimeNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
end

function M:ShowPunishPopup()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/baned_click", nil, nil)
    local Params = { Tips = { self.PunishCountText } }
    UIManager(self):ShowCommonPopupUI(100333, Params)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Destruct()
    self:RemoveInputMethodChangedListen()
    M.Super.Destruct(self)
end

function M:RefreshControllerUI()
    local isGamepad = (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)

    if not isGamepad then
        -- 非手柄：隐藏手柄区域
        self.Key:SetVisibility(ESlateVisibility.Collapsed)
        return
    end

    -- 手柄模式：显示手柄L按键
    self.Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key:CreateCommonKey({
        KeyInfoList = {
            { Type = "Img", ImgShortPath = "LS" }
        },
    })
end

-- function M:OnKeyDown(MyGeometry, InKeyEvent)
--     local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
--     local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
--     if InKeyName == "Gamepad_LeftShoulder" then
--         UIManager(self):ShowCommonPopupUI(100297)
--     end
--     return UE4.UWidgetBlueprintLibrary.Handled()
-- end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    self:RefreshControllerUI()
end


return M

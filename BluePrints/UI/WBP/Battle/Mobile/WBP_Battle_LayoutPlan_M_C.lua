--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_LayoutPlan_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.CurSelectIndex = nil
    self.IsClosing = false
    self.Btn_Confirm.Button_Area:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Confirm:PlayAnimation(self.Btn_Confirm.Forbidden)
    self.Btn_Confirm.Button_Area.OnClicked:Add(self, self.OnClickConfirm)
    self.Layout_01.Btn_Area.OnClicked:Add(self, self.OnClickLayout1)
    self.Layout_02.Btn_Area.OnClicked:Add(self, self.OnClickLayout2)
    self.Text_Title:SetText(GText("UI_SelectLayoutPopup_Tittle03"))
    self.Text_Desc:SetText(GText("UI_SelectLayoutPopup_Tip"))
    self.Layout_01.Text_Plan:SetText(GText("UI_SelectLayoutPopup_Tittle01"))
    self.Layout_01.Text_PlanDesc:SetText(GText("UI_SelectLayoutPopup_Content01"))
    self.Layout_02.Text_Plan:SetText(GText("UI_SelectLayoutPopup_Tittle02"))
    self.Layout_02.Text_PlanDesc:SetText(GText("UI_SelectLayoutPopup_Content02"))
    self.Layout_01.New:SetVisibility(ESlateVisibility.Collapsed)
    self.Layout_02.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Confirm.Text_Button:SetText(GText("UI_SelectLayoutPopup_Button"))
    AudioManager(self):PlayUISound(self, "event:/ui/common/complete_trial_level_panel_show", "LayoutPlan", nil)
end

function M:OnLoaded(...)
end

function M:OnClickConfirm()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:InitMobileHudPlan(self.CurSelectIndex)
        if self.CurSelectIndex == 2 then
            EMCache:Set("FirstOpenLayoutPlan", true, true)
            ReddotManager.ClearLeafNodeCount("Setting_Layout")
        end
    end
    self:CloseSelf()
    self.IsClosing = true
    EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, self.CurSelectIndex)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
end

function M:OnClickLayout1()
    if self.Layout_02.LayoutState == UIConst.ButtonState.Click then
        self.Layout_02:PlayAnimation(self.Layout_02.Normal)
        self.Layout_02.LayoutState = UIConst.ButtonState.None
    end
    if not self.CurSelectIndex then
        self.Btn_Confirm:PlayAnimation(self.Btn_Confirm.Normal)
    end
    self.CurSelectIndex = 1
    self.Btn_Confirm.Button_Area:SetVisibility(ESlateVisibility.Visible)
end

function M:OnClickLayout2()
    if self.Layout_01.LayoutState == UIConst.ButtonState.Click then
        self.Layout_01:PlayAnimation(self.Layout_01.Normal)
        self.Layout_01.LayoutState = UIConst.ButtonState.None
    end
    if not self.CurSelectIndex then
        self.Btn_Confirm:PlayAnimation(self.Btn_Confirm.Normal)
    end
    self.CurSelectIndex = 2
    self.Btn_Confirm.Button_Area:SetVisibility(ESlateVisibility.Visible)
    self.Layout_02.New:SetVisibility(ESlateVisibility.Collapsed)
end

function M:CloseSelf()
    if self.IsClosing then
        return
    end
    self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "LayoutPlan", {ToEnd = 1})
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:Close()
    end
end

return M

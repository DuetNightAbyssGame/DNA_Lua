--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_SettingCustomOnTrial_M_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
    self.CurEditPlan, self.WidgetPlanData = ...
end

function M:Construct()
    self.TextContent:SetText(GText("UI_CustomLayout_Trial_Tittle01"))
    self:BindBtnClick()
    self.Btn_Exit:SetText(GText("UI_CustomLayout_Trial_Back"))
    self.Btn_Save:SetText(GText("UI_CustomLayout_Trial_Save"))
    self:AddDispatcher(EventID.OnExitMobileHudTrial, self, self.OnExitMobileHudTrial)
end

function M:OnExitMobileHudTrial()
    self:Close()
end

function M:BindBtnClick()
    self.Btn_Exit:BindEventOnClicked(self, self.OnClickedExit)
    self.Btn_Save:BindEventOnClicked(self, self.OnClickedSave)
end

function M:OnClickedExit()
    UIManager(self):LoadUINew("CustomHUDSetting",  self.CurEditPlan, self.WidgetPlanData, true)
    self:Close()
end

function M:OnClickedSave()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        Avatar:UpdateMobileHudPlan(self.CurEditPlan, self.WidgetPlanData)
    end
    self:Close()
end

function M:GetCurEditPlan()
    return self.CurEditPlan
end

function M:GetWidgetPlanData()
    return self.WidgetPlanData
end

return M

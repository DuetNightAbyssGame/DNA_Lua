--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_SolutionItem_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Write:BindEventOnClicked(self, self.OnClickedWrite)
    self.BtnUse:BindEventOnClicked(self, self.OnClickedUse)
end

function M:InitUI(Index, bSelected, Owner)
    self.Index = Index
    self.Owner = Owner
    self:SetSelected(bSelected)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local PlanData = Avatar:GetMobileHudPlan(self.Index)
    if not PlanData then
        return
    end
    local PlanName = PlanData.HudPlanName or "Default"
    self.PlanName = PlanName
    self.TextContent:SetText(PlanName)
end

function M:SetSelected(bSelected)
    self.bSelected = bSelected
    if bSelected then
        self.BtnUse:ForbidBtn(true)
        self.BtnUse:SetText(GText("UI_CustomLayout_InUse"))
        if self.Owner and self.Owner.LastSelectedWidget then
            self.Owner.LastSelectedWidget:SetSelected(false)
        end
        self.Owner.LastSelectedWidget = self
    else
        self.BtnUse:ForbidBtn(false)
        self.BtnUse:SetText(GText("UI_CustomLayout_Choose"))
    end
end

function M:OnClickedWrite()
    self.NameEditDialog = UIManager(self):ShowCommonPopupUI_Interrupt(100321, {
        EditTextConfig = {
            Text = self.PlanName,
            IsMultiLine = false,
            Owner = self,
            TextLimit = 20,
            bLimitSpaces = true,
            bNotAllowEmpty = true,
            Events = {
                OnTextChanged = function(Text)
                    if(Text == self.PlanName)then
                        self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(true)
                    else
                        self.NameEditDialog:GetButtonBar().Btn_Yes:ForbidBtn(false)
                    end
                end
            },
            bNeedCheckStringSensitive = true,
            OnCheckStringSensitive = function(_,bSuccess,Name)
                if(bSuccess)then
                    Name = Name or ""
                    if(Name ~= "")then
                        self:ChangePlanName(Name)
                    end
                else
                end
            end
        },
    }, self)
end

function M:OnClickedUse()
    EventManager:FireEvent(EventID.OnSwitchMobileHUDLayout, self.Index)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:SwitchMobileHudPlan(self.Index)
    Avatar:RecordLayoutIndexToMappedPlan(self.Index)
    self:SetSelected(true)
end

function M:ChangePlanName(Name)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local PlanData = Avatar:GetMobileHudPlan(self.Index)
    if not PlanData then
        return
    end
    PlanData.HudPlanName = Name
    EventManager:FireEvent(EventID.OnUpdateMobileHudPlanName, self.Index, Name)
    Avatar:UpdateMobileHudPlan(self.Index, PlanData, true)
end

return M

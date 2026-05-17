--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"
---@type WBP_Set_LayoutBtn_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Area.OnPressed:Add(self, self.OnPressLayout)
    self.Btn_Area.OnReleased:Add(self, self.OnReleasedLayout)
    self.Btn_Area.OnUnhovered:Add(self, self.OnOnUnhoveredLayout)
    self.Btn_Area.OnClicked:Add(self, self.OnClickedLayout)
    self.Btn_CustomLayout.Button_Area.OnClicked:Add(self, self.OnClickedCustomLayout)
    self.LayoutState = UIConst.ButtonState.None
    self:PlayAnimation(self.Normal)
    EventManager:AddEvent(EventID.OnSwitchMobileHUDLayout, self, self.OnSwitchMobileHUDLayout)
    ReddotManager.AddListener("Setting_Control_LayOutBtn",self,self.RefreshReddot)
end

function M:Destruct()
    self:PlayAnimation(self.Normal)
    self.Btn_Area.OnPressed:Clear()
    self.Btn_Area.OnReleased:Clear()
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnClicked:Clear()
    EventManager:RemoveEvent(EventID.OnSwitchMobileHUDLayout, self)
    ReddotManager.RemoveListener("Setting_Control_LayOutBtn", self)
end

function M:OnClickedCustomLayout()
    local CustomHUDSettingTrailUI = UIManager(self):GetUI("CustomHUDSettingTrailUI")
    -- 如果正在试用中
    if CustomHUDSettingTrailUI then
        local CurEditPlan = CustomHUDSettingTrailUI:GetCurEditPlan()
        local WidgetPlanData = CustomHUDSettingTrailUI:GetWidgetPlanData()
        if CurEditPlan == self.PlanIndex then
            UIManager(self):LoadUINew("CustomHUDSetting",  self.PlanIndex, WidgetPlanData, true)
            return
        end
    end
    UIManager(self):LoadUINew("CustomHUDSetting",  self.LayoutIndex)
end

function M:RefreshReddot()
    local RedDot = ReddotManager.GetTreeNode("Setting_Control_LayOutBtn")
    if self.Index == 1 then
        RedDot = ReddotManager.GetTreeNode("Setting_Control_TrailBtn")
    end
    if RedDot and RedDot.Count > 0 then
        self.Btn_CustomLayout:SetReddot(true)
    else
        self.Btn_CustomLayout:SetReddot(false)
    end
end

function M:OnPressLayout()
    if self.LayoutState == UIConst.ButtonState.Click then
        return
    end
    self.LayoutState = UIConst.ButtonState.Press
    self:PlayAnimation(self.Press)
end

function M:OnOnUnhoveredLayout()
    if self.LayoutState == UIConst.ButtonState.Click then
        return
    end
    self.LayoutState = UIConst.ButtonState.Unhovered
end

function M:OnReleasedLayout()
    if self.LayoutState == UIConst.ButtonState.Click then
        return
    end
    if self.LayoutState == UIConst.ButtonState.Unhovered then
        self:PlayAnimation(self.Normal)
    end
    self.LayoutState = UIConst.ButtonState.Release
end

function M:OnClickedLayout()
    if self.LayoutState == UIConst.ButtonState.Click then
        return
    end
    self.LayoutState = UIConst.ButtonState.Click
    self:PlayAnimation(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
end

function M:InitLayoutPlan(PlanIndex, LayoutIndex)
    self.PlanIndex = PlanIndex
    self.LayoutIndex = LayoutIndex
    if self.Index % 2 == self.PlanIndex % 2 and self.LayoutState ~= UIConst.ButtonState.Click then
        self.LayoutState = UIConst.ButtonState.Click
        self:PlayAnimation(self.Click)
    elseif self.Index % 2 ~= self.PlanIndex % 2 and self.LayoutState == UIConst.ButtonState.Click then
        self.LayoutState = UIConst.ButtonState.None
        self:PlayAnimation(self.Normal)
    end
    local IsFirstShow = EMCache:Get("FirstOpenLayoutPlan", true)
    if not IsFirstShow and PlanIndex == 1 and self.Index == 2 then
        self.New:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnSwitchMobileHUDLayout(PlanIndex)
    self.PlanIndex = PlanIndex
    if PlanIndex % 2 == self.Index % 2 then
        self.LayoutIndex = PlanIndex
    end
end

return M

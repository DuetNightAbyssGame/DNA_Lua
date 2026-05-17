--
-- DESCRIPTION
-- 止流委托，用于切换日期的按钮
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_ZhiliuEvent_TaskTab_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:InitTaskTab(ParentUI, TabIndex, Condition)   -- "Normal" "Locked" "Completed"
    self.ParentUI = ParentUI
    self.TabIndex = TabIndex
    self.IsSelected = false
    self.IsCompleted = false
    self.IsLocked = false
    self.Image_Lock:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if Condition == "Completed" then
        self:SetCompleted()
    elseif Condition == "Normal" then
        -- self:SetNormal()  播normal再播click会有问题 不走SetNormal能解决
    elseif Condition == "Locked" then
        self:SetLocked()
    end

    self:InitBindEvents()
    self:InitDisplayText()
end

function M:InitBindEvents()
    self.Btn_Tab.OnClicked:Add(self, self.OnClickedEvent)
    self.Btn_Tab.OnPressed:Add(self, self.OnPressedEvent)
    self.Btn_Tab.OnHovered:Add(self, self.OnHoverdEvent)
    self.Btn_Tab.OnUnhovered:Add(self, self.OnUnHoveredEvent)
end

function M:OnClickedEvent()
    if self.IsLocked then 
        self.ParentUI:OnDaySwitchButtonLockedClicked(self.TabIndex)
    else
        self:PlayAnimation(self.Click)
        self.ParentUI:OnDaySwitchButtonClicked(self.TabIndex)
        self.IsSelected = true
    end
end

function M:OnPressedEvent()
    if self.IsLocked then return end
    self.IsSelected = true
    --self:PlayAnimation(self.Press)   Press动效和Click动效冲突
end

function M:OnHoverdEvent()
    if self.IsSelected then return end
    if self.IsLocked then return end
    self:PlayAnimation(self.Hover)
end

function M:OnUnHoveredEvent()
    if self.IsSelected then return end
    if self.IsLocked then return end
    self:PlayAnimation(self.Normal)
end

function M:SetNormal()
    if self.IsLocked then return end
    self.IsSelected = false
    self:PlayAnimation(self.Normal)
end

function M:SetLocked()
    self.IsLocked = true
    self:PlayAnimation(self.Lock)
end

function M:SetCompleted()
    self.IsCompleted = true
    self:PlayAnimation(self.Completed)
end

function M:InitDisplayText()
    self.Text_TabNum:SetText("0"..self.TabIndex)
    --self.Text_TabDay:SetText(GText("Day")) 策划要求无需配置，写蓝图里
end

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

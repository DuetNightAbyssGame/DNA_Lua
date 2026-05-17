--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Battle_LayoutBtn_M_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Area.OnPressed:Add(self, self.OnPressLayout)
    self.Btn_Area.OnReleased:Add(self, self.OnReleasedLayout)
    self.Btn_Area.OnUnhovered:Add(self, self.OnOnUnhoveredLayout)
    self.Btn_Area.OnClicked:Add(self, self.OnClickedLayout)
    self.LayoutState = UIConst.ButtonState.None
end

function M:Destruct()
    self:PlayAnimation(self.Normal)
    self.Btn_Area.OnPressed:Clear()
    self.Btn_Area.OnReleased:Clear()
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnClicked:Clear()
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
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm_positive", nil, nil)
end

return M

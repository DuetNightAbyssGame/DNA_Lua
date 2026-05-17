--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_MarkBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnAddedToFocusPath(MyGeometry, InFocusEvent)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
        self.Btn.OnClicked:Broadcast()
        self:PlayAnimation(self.Click)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnRemovedFromFocusPath(MyGeometry, InFocusEvent)
    if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
        self:PlayAnimation(self.Normal)
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    return self.Parent:OnKeyDown(MyGeometry, InKeyEvent)
end

return M

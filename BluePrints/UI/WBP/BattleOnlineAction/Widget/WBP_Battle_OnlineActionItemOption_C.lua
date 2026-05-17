require "UnLua"
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.Key_Option_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnRemovedFromFocusPath()
    if not self.Parent.IsGamePad then
        return
    end
    self.Key_Option_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.Normal)
end

function M:OnAddedToFocusPath()
    if not self.Parent.IsGamePad then
        return
    end
    self.Key_Option_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:StopAnimation(self.Normal)
    self:PlayAnimation(self.Hover)
end

-- function M:OnAnimationStarted(Animation)
--     ScreenPrint("正在播放动画"..Animation:GetName())
-- end

return M

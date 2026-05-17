require "UnLua"

local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Init(ParentWidget, Callback)
    if ParentWidget and Callback then
        self.Btn_Reward.OnClicked:Add(ParentWidget, Callback)
    end
    self:PlayAnimation(self.Reward, 0, 0)
end

return M
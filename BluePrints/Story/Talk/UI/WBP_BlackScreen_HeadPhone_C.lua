--
-- DESCRIPTION
--
-- @COMPANY ** 黑屏提示佩戴耳机界面
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_Entry_EventTypeTab_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

-- function M:Destruct()
-- end

function M:Init(Content)
    self.Content = Content
    self.Text_Hint:SetText(GText("Textmap_NodeText001"))
end

function M:PlayInAnimation(BlendInTime)
    if BlendInTime <= 0.01 then
        BlendInTime = 0.01
    end
    local InAnimation = self.In
    local AnimationInTime = InAnimation:GetEndTime()
    self:PlayAnimation(InAnimation, 0, 1, EUMGSequencePlayMode.Forward, AnimationInTime/BlendInTime)
end

function M:PlayOutAnimation(BlendOutTime)
    if BlendOutTime <= 0.01 then
        BlendOutTime = 0.01
    end
    local OutAnimation = self.Out
    local AnimationOutTime = OutAnimation:GetEndTime()
    self:PlayAnimation(OutAnimation, 0, 1, EUMGSequencePlayMode.Forward, AnimationOutTime/BlendOutTime)
end

return M

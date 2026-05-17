--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_RecommendBanner_SubItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:OnListItemObjectSet(Content)
    Content.SelfWidget = self
    self.LastTime = Content.LastTime
    self:ResetItem()
    if Content.NeedStartTick then
        self:StartTick()
    else
        self:ResetItem()
    end
end
--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:CleanTimer()
    self.Super.Destruct(self)
end


function M:StartTick()
    self:PlayAnimation(self.In)
    self.Image_Progress:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:ResetItem()
    -- self:RemoveTimer("RefreshBottomItem")
    self.Image_Progress:SetVisibility(ESlateVisibility.Collapsed)
end


return M

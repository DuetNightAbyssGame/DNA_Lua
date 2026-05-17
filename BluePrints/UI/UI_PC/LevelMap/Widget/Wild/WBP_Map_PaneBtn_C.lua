--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_PaneBtn_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(PaneIndex, Index, FloorId, Map)
    self.PaneIndex = PaneIndex
    self.Index = Index
    self.FloorId = FloorId
    self.Map = Map
    self.Choose:SetRenderOpacity(0)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    self.Map:OnPaneButtonDown(self)
    return UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    self.Map:OnPaneButtonUp(self)
    return UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    self.Map:OnPaneButtonEnter(self)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    self.Map:OnPaneButtonLeave(self)
end

return M

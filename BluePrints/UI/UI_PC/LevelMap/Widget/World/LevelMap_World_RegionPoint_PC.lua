--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Map_RegionPoint_C
local M = Class("BluePrints.UI.BP_UIState_C")

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Param)
    self.UIIndex = Param.UIIndex
    self.Used = Param.Used
    self.WorldMapData = Param.WorldMapData
    self.RootPage = Param.RootPage

    self.Btn_Click.OnClicked:Add(self, self.OnMouseClick)
    self.Btn_Click.OnHovered:Add(self, self.OnMouseHover)
    self.Btn_Click.OnUnhovered:Add(self, self.OnMouseUnhover)
end

function M:OnMouseClick()
    self.RootPage.SelectBtnIdx = self.UIIndex
    self.RootPage:OnMouseButtonUp(nil, nil)
end

function M:OnMouseHover()
    self.RootPage.HoverBtnIdx = self.UIIndex
    self.RootPage:OnItemHover()
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_hover_level", "", nil)
end

function M:OnMouseUnhover()
    self.RootPage.HoverBtnIdx = nil
    self.RootPage:OnItemUnhover()
end


return M

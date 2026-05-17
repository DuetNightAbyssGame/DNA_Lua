--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type Prologue_Map_Area_Level_Item_C
local M = Class()

function M:Initialize(Initializer)
    ---@type Prologue_Map_Area_Level_C
    self.DungeonMapAreaLevelUI = nil
end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:SetDungeonInfo(Parent, DungeonId, UIIndex)
    self.DungeonMapAreaLevelUI = Parent
    self.DungeonId = DungeonId
    self.UIIndex = UIIndex
end

function M:OnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_level", nil, nil)
    self.DungeonMapAreaLevelUI:OnClickedAreaLevelItem(self.UIIndex, self.DungeonId)
end

function M:OnHovered()
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_hover_level", nil, nil)
end

return M

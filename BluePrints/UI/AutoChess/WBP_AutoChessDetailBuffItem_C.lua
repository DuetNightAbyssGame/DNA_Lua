--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_LevelDetailsBuffItem_C
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


function M:OnListItemObjectSet(Content)
    Content.UI = self
    local Path = LoadObject(Content.Path)
    self.MissionId = Content.MissionId
    self.Icon_Buff:SetBrushResourceObject(Path)
    self.Btn_Click.OnClicked:Add(self, self.OnClick)
end


function M:OnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
    UIManager(self):LoadUINew("AutoChessBuffDetail",self.MissionId)
end


return M

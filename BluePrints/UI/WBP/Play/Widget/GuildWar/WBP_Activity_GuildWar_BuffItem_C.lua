--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_GuildWar_BuffItem_C
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

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_GuildWar_RewardItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

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
    self.Content = Content
    self.RaidDungeonBuffData = Content.RaidDungeonBuffData 
    self:InitItemContent()
end

function M:InitItemContent()
    local RaidBuffDes = self.RaidDungeonBuffData.RaidBuffDes
    local RaidBuffParameter = self.RaidDungeonBuffData.RaidBuffParameter
    local BuffDes = UIUtils.GenAbyssEntryDesc(GText(RaidBuffDes),RaidBuffParameter ,0)
    self.Text:SetText(GText(BuffDes))
end




return M

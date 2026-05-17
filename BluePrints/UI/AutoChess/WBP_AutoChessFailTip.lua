--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_AutoChess_SettlementFailTip_C
local WBP_Activity_AutoChess_SettlementFailTip_C = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


function WBP_Activity_AutoChess_SettlementFailTip_C:OnListItemObjectSet(Content)
    self.Text_Tip:SetText(Content.Text)
end

return WBP_Activity_AutoChess_SettlementFailTip_C

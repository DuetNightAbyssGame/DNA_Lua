--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local OnlineActionCommon = require "BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon"

---@type WBP_Battle_OnlineAction_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
 M._components = {"BluePrints.UI.WBP.BattleOnlineAction.WBP_Battle_OnlineActionBaseView"}


---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.M=M
    self.Btn_Refresh:SetText(GText("UI_RegionOnline_Refresh"))
    self.Btn_Refuse:SetText(GText("UI_RegionOnline_RefruseAll"))
    self.Btn_Refresh.Button_Area.OnClicked:Add(self, self.OnRefreshAllKeyDown)
    self.Btn_Refuse.Button_Area.OnClicked:Add(self, self.OnRejectAllKeyDown)
end
function M:Tick(MyGeometry, InDeltaTime)

    
end

--function M:Destruct()
--end

AssembleComponents(M)
return M

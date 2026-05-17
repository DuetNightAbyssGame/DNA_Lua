--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_PersonalInfo_Data_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
    --"BluePrints.UI.WBP.PersonInfo.Base.PersonInfoEntryBaseView",
"BluePrints.UI.WBP.PersonInfo.Data.PersonInfoDataPageBaseView",
--"BluePrints.UI.WBP.PersonInfo.Base.PersonInfoEntryBaseView"
}
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end
function M:InitBaseView()
    self:InitTab()
end
function M:InitTab()
    local TabWithoutChar={
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {{
            KeyInfoList = {{
                Type = "Text",
                Text = "Esc",
                ClickCallback = self.OnReturnKeyDown,
                Owner = self
            }},
            Desc = GText("UI_BACK")

        }},
        StyleName = "Text",
        OwnerPanel = self,
        TitleName = GText("UI_PersonalPage_Recount_Name"),
        BackCallback = self.OnReturnKeyDown
    }

    self.Root.Com_Tab_M:Init(TabWithoutChar)
end
-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

AssembleComponents(M)
return M

--[[
Author: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
Date: 2025-09-02 22:11:14
LastEditors: error: error: git config user.name & please set dead value or install git && error: git config user.email & please set dead value or install git & please set dead value or install git
LastEditTime: 2025-09-22 15:48:45
FilePath: \EM\Content\Script\BluePrints\UI\WBP\DayAndNight\Mobile\WBP_DayAndNight_M_C.lua
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
--]]
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_DayAndNight_M_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {"BluePrints.UI.WBP.DayAndNight.DayAndNightPageBaseView"}
---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end


function M:Construct()
    ScreenPrint("WBP_DayAndNight_M_C:Construct")
     local TabInfo = {
        Tabs = self.AllTabInfo,
        DynamicNode = {"Back", "Tip", "BottomKey"},
        BottomKeyInfo = {
        {
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
        TitleName = GText("UI_SetTime_Title"),
        BackCallback = self.OnReturnKeyDown
    }
    self.WBP_Com_Tab_M:Init(TabInfo)
end
--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

AssembleComponents(M)

return M

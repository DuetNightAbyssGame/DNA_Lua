--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Angling_DayAndNightDialog_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:InitContent(Params, PopupData, Owner)
    print(_G.LogTag,"LXZ InitContent")
    M.Super.InitContent(self, Params, PopupData, Owner)
    self.Morn.Text_Time:SetText(GText("UI_Fishing_DayAndNight_Cont_1"))
    self.Morn.Text_Period:SetText(GText("UI_Fishing_DayAndNight_Period_1"))
    self.Noon.Text_Time:SetText(GText("UI_Fishing_DayAndNight_Cont_2"))
    self.Noon.Text_Period:SetText(GText("UI_Fishing_DayAndNight_Period_2"))
    self.Night.Text_Time:SetText(GText("UI_Fishing_DayAndNight_Cont_3"))
    self.Night.Text_Period:SetText(GText("UI_Fishing_DayAndNight_Period_3"))
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end


return M

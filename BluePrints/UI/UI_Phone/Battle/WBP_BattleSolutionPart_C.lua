--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
---@type WBP_BattleSolutionPart_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Index = Avatar:GetCurrentMobileHudPlanIndex()
end

function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    if self.Index == nil then
        self.Index = Params.Index
    end
    -- 判断Index是奇数还是偶数
    -- 把NewEMWidgetBlueprint_1到NewEMWidgetBlueprint_3设置InitUI,Index为1，3，5，偶数的情况就是2，4，6
    for i = 1, 3 do
        if self.Index % 2 == 0 then
            self["NewEMWidgetBlueprint_"..i]:InitUI(i*2, i*2 == self.Index, self)
        else
            self["NewEMWidgetBlueprint_"..i]:InitUI(i*2-1, i*2-1 == self.Index, self)
        end
    end
end

return M

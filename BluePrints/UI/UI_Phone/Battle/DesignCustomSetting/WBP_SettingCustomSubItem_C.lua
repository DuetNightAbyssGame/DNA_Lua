--
-- DESCRIPTION
-- 手机端布局自定义Design子Item
-- @AUTHOR HY

require "UnLua"

local BattleHUDCommonConst = require "BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

M._components = {
    "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent",
}

-- function M:Initialize(Initializer)
-- end

--function M:PreConstruct(IsDesignTime)
--end

function M:InitTaskText()
    self.TextTaskTitle01:SetText(GText("UI_CustomLayout_CaseName05"))
    self.TextTaskTitle02:SetText(GText("UI_CustomLayout_CaseName06"))
    self.TextTask01:SetText(GText("UI_CustomLayout_CaseName07"))
    self.TextTask02:SetText(GText("UI_CustomLayout_CaseName07"))
    self.TextTask03:SetText(GText("UI_CustomLayout_CaseName07"))
    self.TextTask04:SetText(GText("UI_CustomLayout_CaseName07"))
end

function M:InitDropText()
    self.TextName:SetText(GText("UI_CustomLayout_CaseName08"))
    self.TextDrop:SetText(GText("UI_CustomLayout_CaseName09"))
    self.TextItem01:SetText(GText("UI_CustomLayout_CaseName10"))
    self.TextItem02:SetText(GText("UI_CustomLayout_CaseName10"))
    self.TextItem03:SetText(GText("UI_CustomLayout_CaseName10"))
end

function M:InitTeamText()
    self.TextName1:SetText(GText("UI_CustomLayout_CaseName11"))
    self.TextName2:SetText(GText("UI_CustomLayout_CaseName11"))
end

AssembleComponents(M)

return M

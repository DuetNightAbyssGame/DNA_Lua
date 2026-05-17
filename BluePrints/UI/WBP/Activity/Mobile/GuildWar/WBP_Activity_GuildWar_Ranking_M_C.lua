require "UnLua"

local M = Class{"BluePrints.UI.WBP.Activity.PC.GuildWar.WBP_Activity_GuildWar_RankingBase"}


function M:Construct()
    self.Super.Construct(self)
end

function M:Destruct()
    self.Super.Destruct(self)
end

function M:InitCommonTab()
    self.TabConfigData = {
        DynamicNode = {"Back", "Tip", "BottomKey"},
        TitleName = GText("RaidDungeon_Rank"),
        Tabs = self.AllTabInfo,
        StyleName = "TextImage",
        OwnerPanel = self,
        BackCallback = self.CloseSelf,
    }
    self.Tab:Init(self.TabConfigData, true)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Escape") then
        self:CloseSelf()
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

-- 接收输入时聚焦到Item
function M:OnFocusReceived()
    local LastItem = self.LastClickedItem
    if LastItem and LastItem.SelfWidget then
        self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
    end
    return UIUtils.Handled
end

return M
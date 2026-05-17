require "UnLua"
local PersonInfoController = require "BluePrints.UI.WBP.PersonInfo.PersonInfoController"
-- local GuildWarUtils = require "BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils"

local M = Class{"BluePrints.UI.WBP.PersonInfo.GuildWarData.WBP_PersonalInfo_GuildWar_Ranking_Base"}

function M:Construct()
    self.Super.Construct(self)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    self:InitCommonTab()
end

function M:Destruct()
    self.Super.Destruct(self)
end

function M:InitCommonTab()
    local CloseFunc = function()
        self:OnReturnKeyDown()
    end
    self.CloseCallback = CloseFunc
    local TabInfo = {
        DynamicNode = {"Back", "Tip", "BottomKey"},
        TitleName = GText("RaidDungeon_Rank_History"),
        Tabs = self.AllTabInfo,
        StyleName = "TextImage",
        OwnerPanel = self,
        BackCallback = CloseFunc
    }
    if self.Tab then
        self.Tab:Init(TabInfo, true)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == "Escape") then
        if self.CloseCallback then
            self.CloseCallback()
        else
            self:CloseSelf()
        end
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnFocusReceived()
    local LastItem = self.LastClickedItem
    if LastItem and LastItem.SelfWidget then
        self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
    end
    return UIUtils.Handled
end

return M
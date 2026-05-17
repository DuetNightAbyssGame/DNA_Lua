--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

local BattleHUDCommonConst = require "BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst"

local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self:InitBaseInfo()
    self:BindAllEvent()
end

function M:Destruct()
    for _, value in ipairs(self.AllSolutionItem) do
        value:ResetState()
    end
end

function M:InitBaseInfo()
    self.TextTitle:SetText(GText("UI_CustomLayout_AddBtn_Tittle01"))
    self.TextTips:SetText(GText("UI_CustomLayout_AddBtn_Tips01"))

    self.AllSolutionItem = {}
    self.CurSelectItem = nil
end

function M:InitClickInfo(ParentWidget, WidgetDataInfo, CheckBoxClickCallback, BackClickCallback)
    self.ParentWidget = ParentWidget
    self.CheckBoxClickCallback = CheckBoxClickCallback
    self.BackClickCallback = BackClickCallback

    for key, value in pairs(BattleHUDCommonConst.ManualAdditionConfigInHUD) do
        local TargetWidget = self["Solution_Item"..value.NodeIdx]
        if (TargetWidget) then
            local SubItemDataInfo = WidgetDataInfo[key] or {}
            TargetWidget:Init(key, value, SubItemDataInfo.bHasAddInHUDSetting, self.ClickToManualAddWidget, self)
            table.insert(self.AllSolutionItem, TargetWidget)
        end
    end
end

function M:RefreshStateWhenDataChange(SubItemConfigData, SubItemServerData)
    local TargetWidget = self["Solution_Item"..SubItemConfigData.NodeIdx]
    if (TargetWidget) then
        TargetWidget:RefreshStateWhenDataChange(SubItemServerData.bHasAddInHUDSetting)
    end
end

function M:BindAllEvent()
    self.BtnReturn.OnClicked:Add(self, self.OnBtnReturnClicked)
    self.BtnClose.OnClicked:Add(self, self.OnBtnReturnClicked)

    self:BindToAnimationFinished(self.Out, {self, function()
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end})
end

function M:ClickToManualAddWidget(bChecked, NodeName, CurSelectItem)
    if (self.CurSelectItem ~= nil and self.CurSelectItem ~= CurSelectItem) then
        self.CurSelectItem:CancelCellSelectState()
    end
    if (type(self.CheckBoxClickCallback) == "function") then
        self.CheckBoxClickCallback(self.ParentWidget, bChecked, NodeName)
    end
    self.CurSelectItem = CurSelectItem
end

function M:PlayInAnim()
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.In)
end

function M:OnBtnReturnClicked()
    if (self.CurSelectItem ~= nil) then
        self.CurSelectItem:CancelCellSelectState()
    end
    self:PlayAnimation(self.Out)
    if (type(self.BackClickCallback) == "function") then
        self.BackClickCallback(self.ParentWidget)
    end
end

return M

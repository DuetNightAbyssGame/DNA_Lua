require "UnLua"
local WBP_Activity_AutoChess_DeputeMonsterInfoTab = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_Activity_AutoChess_DeputeMonsterInfoTab:OnListItemObjectSet(ListItemObject)
    DebugPrint("------------------------MonsterInfoTab-------------------------")
    self:LoadData(ListItemObject)
    self.Button_Area.OnClicked:Clear()
    self.Button_Area.OnClicked:Add(self, self.OnItemClicked)

    if self.SetSelected then
        self:SetSelected(ListItemObject.IsSelected)
    end

    self:SetNavStop(true)
end

function WBP_Activity_AutoChess_DeputeMonsterInfoTab:LoadData(ListItemObject)
    self.Content = ListItemObject
    -- 加载头像Icon
    if ListItemObject.MonsterIcon then
        local HeadIconObj = LoadObject(ListItemObject.MonsterIcon)
        if HeadIconObj then
            self.Monster_Head:SetBrushFromTexture(HeadIconObj)
        end
    end
    -- 加载定位Icon
    if ListItemObject.PositionIcon then
        local PositionIconObj = LoadObject(ListItemObject.PositionIcon)
        if PositionIconObj then
            self.Icon_Type.Icon:SetBrushFromTexture(PositionIconObj)
        end
    end
    -- 加载装备
    self:RefreshEquip(ListItemObject.EquipList)
end

function WBP_Activity_AutoChess_DeputeMonsterInfoTab:RefreshEquip(EquipList)
    local Count = 0

    if EquipList ~= nil then
        if type(EquipList) == "table" then
            Count = #EquipList
        else
            Count = 1
        end
    end

    if self.Equipment_01 and self.Equipment_02 then
        self.Equipment_01:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Equipment_02:SetVisibility(UE4.ESlateVisibility.Visible)
        if Count == 1 then
            self.Equipment_01.WS_Type:SetActiveWidgetIndex(0) -- On
            self.Equipment_02.WS_Type:SetActiveWidgetIndex(1) -- Off
        elseif Count == 2 then
            self.Equipment_01.WS_Type:SetActiveWidgetIndex(0) -- On
            self.Equipment_02.WS_Type:SetActiveWidgetIndex(0) -- On
        elseif Count == 0 then
            self.Equipment_01:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.Equipment_02:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end

function WBP_Activity_AutoChess_DeputeMonsterInfoTab:OnItemClicked()
    if self.Content and self.Content.OnBtnClickedCallback then
        local MonsterItemIndex = self.Content.Index
        self.Content.OnBtnClickedCallback(MonsterItemIndex, self)
    end
end

function WBP_Activity_AutoChess_DeputeMonsterInfoTab:SetSelected(bSelected)
    if bSelected then
        self:PlayAnimation(self.Select)
    else
        self:PlayAnimation(self.Normal)
    end
end

function WBP_Activity_AutoChess_DeputeMonsterInfoTab:SetNavStop(bStop)
    local Rule = bStop and UE4.EUINavigationRule.Stop or UE4.EUINavigationRule.Escape

    self:SetNavigationRuleBase(UE4.EUINavigation.Left, Rule)
    self:SetNavigationRuleBase(UE4.EUINavigation.Right, Rule)
    self:SetNavigationRuleBase(UE4.EUINavigation.Up, Rule)
    self:SetNavigationRuleBase(UE4.EUINavigation.Down, Rule)
end

function WBP_Activity_AutoChess_DeputeMonsterInfoTab:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.Content and self.Content.OnFocusReceivedCallback then
        self.Content.OnFocusReceivedCallback()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

return WBP_Activity_AutoChess_DeputeMonsterInfoTab

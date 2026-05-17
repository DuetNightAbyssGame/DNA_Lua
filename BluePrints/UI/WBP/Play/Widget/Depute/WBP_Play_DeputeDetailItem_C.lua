--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeDetailItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end
function M:Init(Obj)
    local RewardList = Obj.RewardList
    if not RewardList then
        return
    end
    self.List_Item:DisableScroll(true)
    self.List_Item:ClearListItems()
    -- self.List_Item:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    -- self.List_Item:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    -- self.List_Item:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    -- self.List_Item:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    self.DropType = Obj.DropType
    local Index = Obj.Index
    self.ParentWidget = Obj.ParentWidget
    local DropTypeText
    if self.DropType == "FirstReward" then
        DropTypeText = "UI_Dungeon_First_Reward"
    else
        DropTypeText = DataMgr.DropProbType[self.DropType].DropTypeText
    end
    self.Text_Title:SetText(GText(DropTypeText))

    for _, ItemData in pairs(RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = ItemData.Id
        Content.Icon = ItemData.Icon
        Content.ParentWidget = self
        Content.ItemType = ItemData.ItemType
        Content.Rarity = ItemData.Rarity or 1
        Content.IsShowDetails = true
        Content.UIName = "StyleOfPlay"
        Content.Count = ItemData.ItemCount
        Content.OnAddedToFocusPathEvent = {
            Obj = self,
            Callback = function()
                self.ParentWidget.Scroll_Drop:ScrollWidgetIntoView(Content.SelfWidget,true,EDescendantScrollDestination.IntoView)
            end
        }
        local BaseCount = ItemData.ItemCount or nil
        --Content.HandleMouseDown = true
        if ItemData.FirstRewardFlag then
            Content.BonusType = 2
        end
        if ItemData.Quantity then
            if #ItemData.Quantity > 1 then
                Content.MaxCount = ItemData.Quantity[2]
            end
            BaseCount = ItemData.Quantity[1] or nil
        end

        -- 状态判断是否翻倍
        if  BaseCount then
            if Obj.Checked and not ItemData.FirstRewardFlag  then
                Content.Count = BaseCount * 2
            else
                Content.Count = BaseCount
            end
        end

        self.List_Item:AddItem(Content)
     end

    self:AddTimer(0.01, function()
        if Index == 1 then
            self.List_Item:NavigateToIndex(0)
            -- local RewardItemUIs = self.List_Item:GetDisplayedEntryWidgets()
            -- RewardItemUIs:SetFocus()
            --     return RewardItemUIs[1]
        end
        local len = self.List_Item:GetNumItems()
        for i = 1, len do
            local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, i - 1)
            if entryWidget then
                entryWidget:BindEvents(self, {
                    OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
                })
                --entryWidget:SetNavigationRuleExplicit(EUINavigation.Down, self.ParentWidget.DropType_FixedItem)

                -- local XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.List_Item, "XY")

                -- -- 计算当前行数
                -- local CurRow = math.ceil(i / XCount)
                -- -- 计算最大行数 (动态计算真实行数)
                -- local MaxRow = math.ceil(len / XCount)
                -- local IsLastRow = (CurRow == MaxRow)
                -- local IsFirstRow = (CurRow == 1)
                -- -- if entryWidget.IsFirstRow then
                -- --     DebugPrint("Item GetNumItems " .. i .. " 是第一行")
                -- -- elseif entryWidget.IsLastRow then
                -- --     DebugPrint("Item GetNumItems " .. i .. " 是最后一行")
                -- -- else
                -- --     DebugPrint("Item GetNumItems " .. i .. " 不是第一行也不是最后一行")
                -- -- end

                --   -- 处理 DropType
                -- if self.DropType == "FirstReward" then
                --     if self.ParentWidget.DropType_FixedItem then
                --         if IsLastRow then
                --             DebugPrint("Item GetNumItems " .. i .. " 是最后一行 设置向下的导航")
                --             local PrevRowIndex = i - XCount
                --             local entryWidgetPrev = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(
                --             self.List_Item, PrevRowIndex - 1)
                --             if entryWidgetPrev then
                --                 entryWidget:SetNavigationRuleExplicit(EUINavigation.Up, entryWidgetPrev)
                --             end
                --             entryWidget:SetNavigationRuleExplicit(EUINavigation.Down,
                --                 self.ParentWidget.DropType_FixedItem)
                --         elseif IsFirstRow then
                --             DebugPrint("Item GetNumItems " .. i .. " 是第一行 设置向下的导航")
                --             local NextRowIndex = i + XCount
                --             local entryWidgetNext = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(
                --             self.List_Item, NextRowIndex - 1)
                --             if entryWidgetNext then
                --                 entryWidget:SetNavigationRuleExplicit(EUINavigation.Down, entryWidgetNext)
                --             end
                --             entryWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
                --         end
                --     end
                -- elseif self.DropType == "DropType_Fixed" then
                --     if self.ParentWidget.DropType_DropTag_Prob then
                --         if IsLastRow then
                --             DebugPrint("Item GetNumItems " .. i .. " 是最后一行 设置向下的导航")
                --             local PrevRowIndex = i - XCount
                --             local entryWidgetPrev = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(
                --             self.List_Item, PrevRowIndex - 1)
                --             if entryWidgetPrev then
                --                 entryWidget:SetNavigationRuleExplicit(EUINavigation.Up, entryWidgetPrev)
                --             end
                --             entryWidget:SetNavigationRuleExplicit(EUINavigation.Down,
                --                 self.ParentWidget.DropType_DropTag_Prob)
                --         elseif IsFirstRow then
                --             DebugPrint("Item GetNumItems " .. i .. " 是第一行 设置向下的导航")
                --             local NextRowIndex = i + XCount
                --             local entryWidgetNext = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(
                --             self.List_Item, NextRowIndex - 1)
                --             if entryWidgetNext then
                --                 entryWidget:SetNavigationRuleExplicit(EUINavigation.Down, entryWidgetNext)
                --             end
                --             entryWidget:SetNavigationRuleExplicit(EUINavigation.Up, self.ParentWidget.DropType_FixedItem)
                --         end
                --     end
                --     if self.ParentWidget.DropType_FirstReward then
                --         -- 设置向上的导航
                --         entryWidget:SetNavigationRuleExplicit(EUINavigation.Up,
                --             self.ParentWidget.DropType_FirstReward)
                --     end
                -- elseif self.DropType == "DropTag_Prob" then
                --     if self.ParentWidget.DropType_FixedItem then
                --         -- 设置向上的导航
                --         entryWidget:SetNavigationRuleExplicit(EUINavigation.Up, self.ParentWidget.DropType_FixedItem)
                --         -- 设置向下的导航停止
                --         entryWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
                --     end
                -- end
            end
        end
    end, false, 0, "_DeputeDetailItem_List_Item")
end


function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if (bIsOpen) then
        self.ParentWidget:ShowGamepadABtn(false)
        self.ParentWidget:ShowGamepadCloseBtn(false)
        --self.ParentWidget:ShowGamepadScrollBtn(false)
    else
        self.ParentWidget:ShowGamepadABtn(true)
        self.ParentWidget:ShowGamepadCloseBtn(true)
        --self.ParentWidget:ShowGamepadScrollBtn(true)
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.List_Item:NavigateToIndex(0)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:ShowGamepadABtn(bIsShow)
    self.ParentWidget:HideAllGamepadShortcut()
    if bIsShow then
        self.GamepadCheckItemKeyInfo = self.GamepadCheckItemKeyInfo or self.ParentWidget:ShowGamepadShortcutBtn({
            KeyInfoList = {
                { Type = "Img", ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom }
            },
            Desc = GText("UI_Controller_CheckDetails")  --UI_Controller_CheckDetails

        })
    elseif self.GamepadCheckItemKeyInfo then
        self.ParentWidget:HideGamepadShortcut(self.GamepadCheckItemKeyInfo)
        self.GamepadCheckItemKeyInfo = nil
    end
end

return M

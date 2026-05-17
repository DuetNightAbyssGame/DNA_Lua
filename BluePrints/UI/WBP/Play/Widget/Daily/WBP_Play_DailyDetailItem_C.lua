--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DailyDetailItem_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

--function M:Initialize(Initializer)
--end

-- function M:Construct()
--     M.Super.Construct(self)
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Obj)
    self.Obj = Obj
        local RewardList = self.Obj.RewardList
        local Des =  self.Obj.des
        if not RewardList then
            return
        end
        if not Des then
            return
        end
        self.Index = self.Obj.Index
        self.List_Item:ClearListItems()
        -- self.List_Item:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
        -- self.List_Item:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
        -- self.List_Item:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        -- self.List_Item:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        --self.DropType = Obj.DropType
        self.ParentWidget = Obj.ParentWidget
        self.Text_Title:SetText(string.format(GText("UI_DailyGoal_Phase"), Des))
        if self.Obj.IsTabPage then
            self.Text_Title:SetText(Des)
        end

    local SortFunc = function(A, B)
       -- DebugPrint("Comparing DungeonRewardSeq:",  DataMgr.RewardType[A.ItemType].DungeonRewardSeq, DataMgr.RewardType[B.ItemType].DungeonRewardSeq)
        if A.Rarity == B.Rarity then
            local RewardA = DataMgr.RewardType[A.ItemType]
            local RewardB = DataMgr.RewardType[B.ItemType]

            local SeqA = RewardA and RewardA.DungeonRewardSeq or 0
            local SeqB = RewardB and RewardB.DungeonRewardSeq or 0
            if SeqA == SeqB then
                return A.ItemId < B.ItemId
            end
            return SeqA < SeqB
        end
        return A.Rarity > B.Rarity
    end

        table.sort(RewardList, SortFunc)

        for _, ItemData in pairs(RewardList) do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Id = ItemData.ItemId
            Content.Icon = ItemData.Icon
            Content.ParentWidget = self
            Content.ItemType = ItemData.ItemType
            Content.Rarity = ItemData.Rarity or 1
            Content.IsShowDetails = true
            Content.UIName = "StyleOfPlay"
            Content.Count = ItemData.Count
            -- DebugPrint("Comparing A.ItemId:", ItemData.ItemId)
            -- DebugPrint("Comparing Remark:",  DataMgr.RewardType[ItemData.ItemType].Remark)
            -- DebugPrint("Comparing Rarity:", ItemData.Rarity)
            self.List_Item:AddItem(Content)
        end

    self:AddTimer(0.01, function()

        if self.Index == 1 then
            self.List_Item:NavigateToIndex(0)
        end
        local len = self.List_Item:GetNumItems()
        for i = 1, len do
            local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, i - 1)
            if entryWidget then
                entryWidget:BindEvents(self, {
                    OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
                })

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
    else
        self.ParentWidget:ShowGamepadABtn(true)
        self.ParentWidget:ShowGamepadCloseBtn(true)
    end
end


function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.List_Item:NavigateToIndex(0)
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M

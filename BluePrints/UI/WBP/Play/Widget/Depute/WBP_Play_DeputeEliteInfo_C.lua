--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR shilei
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Play_DeputeEliteInfo_C
local M = Class({ "BluePrints.UI.BP_UIState_C" })
local TypeSort = {
    Char = 1,
    Weapon = 2,
    Mod = 3,
    Draft = 4,
    Reward = 5,
    Resource = 6,
}
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:InitItemContent(MonId, WeaknessIcon, Parent,DungeonRewardView)
    if not MonId then
        self.Switch_Type:SetActiveWidgetIndex(1)
        return
    end
    self.Switch_Type:SetActiveWidgetIndex(0)
    self.Parent = Parent
    self.Monster_Elite:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.Mobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
    if (UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad) then
        self.List_EliteProp:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
   
    self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Left,EUINavigationRule.Stop)
    self.List_EliteProp:SetNavigationRuleBase(EUINavigation.Right,EUINavigationRule.Stop)
    local MonsterData = DataMgr.Monster[MonId]
    --设置怪物头像 名称
    self.Text_Elite:SetText(GText(MonsterData.UnitName))
    local Obj = {}
    Obj.WeaknessIcon = WeaknessIcon
    self.Monster_Elite:SetBasicData(MonId, Obj)
    -- local MonRewardData = nil
    -- for _, Data in pairs(DataMgr.ModDungeonMonReward) do
    --     if (Data.MonsterUnitId == MonId) then
    --         MonRewardData = Data
    --         break
    --     end
    -- end
    if not DungeonRewardView then return end
    --刷新奖励
    self:RefreshRewardInfoList(DungeonRewardView)
end

-- 更新奖励信息列表
---@param DungeonReward number[] @奖励Id列表[RewardView]
function M:RefreshRewardInfoList(DungeonReward)
    if not DungeonReward then
        DebugPrint("SL DungeonReward is nil")
        return
    end
    local RewardList = RewardUtils:GetRewardViewInfoById(DungeonReward)
    -- table.sort(RewardList, function(A, B)
    --     if A.Rarity == B.Rarity then
    --         if TypeSort[A.Type] and TypeSort[B.Type] then
    --             if TypeSort[A.Type] == TypeSort[B.Type] then
    --                 return A.Id < B.Id
    --             end
    --             return TypeSort[A.Type] < TypeSort[B.Type]
    --         end
    --         return A.Id < B.Id
    --     end
    --     return A.Rarity > B.Rarity
    -- end)
    self.RewardList = RewardList

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    -- 逐个实例化奖励列表
    for _, ItemData in pairs(RewardList) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = ItemData.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
        Content.ParentWidget = self
        Content.ItemType = ItemData.Type
        Content.Rarity = ItemData.Rarity or 1
        Content.IsShowDetails = true
        Content.UIName = "DeputeDetail"
        if ItemData.DropType then
            Content.bRare = DataMgr.DropProbType[ItemData.DropType].IsRareItem
        end
        if ItemData.Quantity then
            if #ItemData.Quantity > 1 then
                Content.Count = ItemData.Quantity[1]
                Content.MaxCount = ItemData.Quantity[2]
            else
                Content.Count = ItemData.Quantity[1]
            end
        end

        -- 处理置灰状态
        Content.bShadow = false
        if Content.ItemType == "Mod" then
            local ModModel = ModController:GetModel()
            Content.bShadow = ModModel:GetModCountById(Content.Id) <= 0
        elseif Content.ItemType == "Walnut" then
            -- 获取玩家背包中的核桃
            local WalnutsInBag = Avatar.Walnuts.WalnutBag
            Content.bShadow = (WalnutsInBag[Content.Id] or 0) <= 0
        end
        self.List_EliteProp:AddItem(Content)
    end

    if self:IsExistTimer(self.NextFrameListEmpty) then
        self:RemoveTimer(self.NextFrameListEmpty)
    end

    --- 用空Item补全ListView, 加定时器是因为隔一帧才能拿到已生成的Entry
    self.NextFrameListEmpty = self:AddTimer(0.01, function()
        local len = self.List_EliteProp:GetNumItems()
        for i = 1, len do
            local entryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_EliteProp, i - 1)
            if entryWidget then
                entryWidget:BindEvents(self, {
                    OnMenuOpenChanged = self.OnStuffMenuOpenChanged,
                })
            end
        end

        local RewardItemUIs = self.List_EliteProp:GetDisplayedEntryWidgets()
        local RestCount = UIUtils.GetListViewContentMaxCount(self.List_EliteProp, RewardItemUIs, true) -
            RewardItemUIs:Length()
        for i = 1, RestCount do
            self:CreateAndAddEmptyItem()
        end
    end, false, 0, "DeputeEliteInfoListView")
end

function M:CreateAndAddEmptyItem()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    -- Content.IsEmpty = true
    Content.Id = 0
    self.List_EliteProp:AddItem(Content)
end

function M:OnStuffMenuOpenChanged(bIsOpen)
    if (UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad) then
        return
    end
    if (bIsOpen) then
        self.Parent:UpdatKeyDisplay("")
        self.Parent.Button_Multi:SetPCVisibility(true)
        self.Parent.Button_Solo:SetPCVisibility(true)
    else
        self.Parent:UpdatKeyDisplay("RewardWidget")
        self.Parent.Button_Multi:SetPCVisibility(false)
        self.Parent.Button_Solo:SetPCVisibility(false)
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self:IsAnimationPlaying(self.In) then
        return
    end
    self.IsEnter = true
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad or self:IsAnimationPlaying(self.In) then
        return
    end
    self.IsEnter = false
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
end

-- function M:OnFocusReceived(MyGeometry, InFocusEvent)
--     self.List_EliteProp:NavigateToIndex(0)
--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    end
    if (IsEventHandled) then
        return UWidgetBlueprintLibrary.Handled()
    else
        return UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    --DebugPrint("SL OnGamePadDown is InKeyName", InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftThumbstick" then
        local RewardItemUIs = self.List_EliteProp:GetDisplayedEntryWidgets()
        if not RewardItemUIs[1]:HasAnyUserFocus() then
            self.List_EliteProp:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.List_EliteProp:NavigateToIndex(0)
            self.Parent:UpdatKeyDisplay("RewardWidget")
            IsEventHandled = true
        else
            self:SetFocus()
            self.Parent:UpdatKeyDisplay("EliteProp")
            self.List_EliteProp:SetVisibility(ESlateVisibility.HitTestInvisible)
            IsEventHandled = true
        end
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        local RewardItemUIs = self.List_EliteProp:GetDisplayedEntryWidgets()
        for i = 1, RewardItemUIs:Length() do
            if RewardItemUIs[i]:HasFocusedDescendants() or RewardItemUIs[i]:HasAnyUserFocus() then
                self:SetFocus()
                self.Parent:UpdatKeyDisplay("EliteProp")
                self.List_EliteProp:SetVisibility(ESlateVisibility.HitTestInvisible)
                IsEventHandled = true
                break
            end
        end
    else
        local RewardItemUIs = self.List_EliteProp:GetDisplayedEntryWidgets()
        for i = 1, RewardItemUIs:Length() do
            if RewardItemUIs[i]:HasFocusedDescendants() or RewardItemUIs[i]:HasAnyUserFocus() then
                IsEventHandled = true
                break
            end
        end
    end
    return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        -- PC逻辑
        self.List_EliteProp:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.List_EliteProp:SetVisibility(ESlateVisibility.HitTestInvisible)
    end
    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

return M

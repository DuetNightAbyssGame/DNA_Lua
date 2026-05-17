---@type WBP_LimitedPrizePool_RewardItem02_C
local M = Class({ "BluePrints.UI.BP_EMUserWidget_C" })

function M:Construct()
    self.RedDot = self.Reddot
    self.CustomSelectButton = self.Btn_Add
    self.RewardSwitcher = self.WS_Show
    self.RewardTipSwitcher = self.WS_Bottom
    self.OptionalText = self.Text_Optional
    self.Item = self.Item

    self.PromptSelectableAnimation = self.Choose_In
    self.GotAnimation = self.Get_Normal
    self.NormalAnimation = self.Add_Normal
    self.LockNormalAnimation = self.Normal

    self.OptionalText:SetText(GText("UI_LimitedPrizePool_OthSelect"))

    self.Content = nil
    self.GachaGetCallbackFunc = nil

    self.CustomSelectButton.OnClicked:Add(self, self.OnClicked)
    self.CustomSelectButton.OnPressed:Add(self, self.OnPressed)
    self.CustomSelectButton.OnReleased:Add(self, self.OnReleased)
    self.CustomSelectButton.OnClicked:Add(self, self.OpenSelectWidget)
end

function M:Destruct()
    self.CustomSelectButton.OnClicked:Remove(self, self.OnClicked)
    self.CustomSelectButton.OnPressed:Remove(self, self.OnPressed)
    self.CustomSelectButton.OnReleased:Remove(self, self.OnReleased)
    self.CustomSelectButton.OnClicked:Remove(self, self.OpenSelectWidget)
end

function M:Init(Content)
    self.Content = Content

    if (self.Content.Id) then
        self:SetSelectedItem(self.Content)
    else
        self.RedDot:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.RewardSwitcher:SetActiveWidgetIndex(0)
        self.RewardTipSwitcher:SetActiveWidgetIndex(0)
    end

    if (Content.IsPreviewMode) then
        self.RewardTipSwitcher:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.RewardTipSwitcher:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end

    if (Content.bLocked) then
        self.RewardTipSwitcher:SetActiveWidgetIndex(2)
        self.Btn_Add:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
        self.Btn_Add:SetVisibility(UIConst.VisibilityOp.Visible)
    end

    if (Content.bGot) then
        self:PlayAnimation(self.GotAnimation)
    else
        if (Content.bLocked) then
            self:PlayAnimation(self.LockNormalAnimation)
        else
            self:PlayAnimation(self.NormalAnimation)
        end
    end
end

function M:OpenSelectWidget(RestoreIndex)
    if ((self.Content.Ids and #self.Content.Ids <= 1) or self.Content.bLocked) then
        return
    end

    local ItemDatas = {}
    for Index, Id in ipairs(self.Content.Ids) do
        table.insert(ItemDatas, {
            OriginalIndex = Index,
            ResourceId = Id,
            StuffId = Id,
            StuffType = self.Content.Type,
            StuffName = GText(ItemUtils.GetItemName(Id, self.Content.Type)),
            StuffIcon = ItemUtils.GetItemIconPath(Id, self.Content.Type),
            Rarity = ItemUtils.GetItemRarity(Id, self.Content.Type),
            HaveCountNumber = 0,
            IsCanSelect = true,
            StuffCount = self.Content.Count
        })
    end

    UIManager(self):ShowCommonPopupUI(100335, {
        ParentWidget = self,
        AutoFocus = true,
        IsLimitedPrizePool = true,

        Title = GText("UI_LimitedPrizePool_SelecteTitle"),
        OptionalItemsList = ItemDatas,

        FunctionCallbackObj = self,
        ChooseCallbackFunction = self.SelectItem,

        RightCallbackObj = self,
        RightCallbackFunction = self.ConfirmSelectItem,

        RightGamepadImg = EKeys.A.KeyName,
        RightGamepadKey = Const.GamepadFaceButtonBottom,

        RestoreSelectIndex = RestoreIndex
    })
end

function M:SelectItem(Item)
    self.SelectedId = Item.ResourceId
    self.SelectedIndex = Item.OriginalIndex
end

function M:ConfirmSelectItem(Result, PopUI)
    if self.Content.SelectedIndex == self.SelectedIndex then
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Callback = function(Ret)
        if not ErrorCode:Check(Ret) then
            return
        end
        self.Content.Id = self.SelectedId
        self.Content.SelectedIndex = self.SelectedIndex
        self:SetSelectedItem(self.Content)
        self:TryDecreaseLimitedPrizeRewardSelectReddot(self.Content.Number)
    end
    Avatar:SetLimitPrizeSelfSelect(Callback, self.Content.EventId, self.Content.Number, self.SelectedIndex)
end

function M:SetSelectedItem(ItemData)
    self.RedDot:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.RewardSwitcher:SetActiveWidgetIndex(1)
    self.RewardTipSwitcher:SetActiveWidgetIndex(1)

    self.Item:Init({
        Id = ItemData.Id,
        ItemType = ItemData.Type,
        Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type),
        Rarity = ItemUtils.GetItemRarity(ItemData.Id, ItemData.Type),
        Count = ItemData.Count,

        IsShowDetails = true,
        HandleMouseDown = true,

        OnMenuOpenChangedEvents = {Obj = self, Callback = self.ItemMenuAnchorChanged},
    })

    if (self.Content.OnSetSelectableReward and self.Content.OnSetSelectableReward[1] and self.Content.OnSetSelectableReward[2]) then
        self.Content.OnSetSelectableReward[2](self.Content.OnSetSelectableReward[1])
    end
end

function M:TryPromptSelectableReward()
    if (self.Content.Id) then
        return
    end

    self:PlayAnimation(self.PromptSelectableAnimation)
end

function M:PlayGachaInAnimation()
    if (self.Choose_In) then
        self:PlayAnimation(self.Choose_In)
    end
end

function M:PlayGachaOutAnimation()
    if (self.Choose_Out) then
        self:PlayAnimation(self.Choose_Out)
    end
end

function M:PlayGachaGetAnimation(CallbackFunc)
    if (self.Get) then
        self.GachaGetCallbackFunc = CallbackFunc
        self:UnbindAllFromAnimationFinished(self.Get)
        self:BindToAnimationFinished(self.Get, { self, self.OnGachaGetAnimationFinished })
        self:PlayAnimation(self.Get)
    else
        if CallbackFunc then
            CallbackFunc()
        end
    end
end

function M:OnGachaGetAnimationFinished()
    if (self.Get) then
        self:UnbindAllFromAnimationFinished(self.Get)
    end
    if self.GachaGetCallbackFunc then
        local CallbackFunc = self.GachaGetCallbackFunc
        self.GachaGetCallbackFunc = nil
        CallbackFunc()
    end
end

function M:RestoreSelectWidget()
    self:OpenSelectWidget(self.SelectWidgetChooseIndex)
end

function M:TryDecreaseLimitedPrizeRewardSelectReddot(Index)
    local NodeName = "LimitedPrizeRewardSelect"
    if not ReddotManager.GetTreeNode(NodeName) then
        ReddotManager.AddNode(NodeName)
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
    if CacheDetail[Index] then
        CacheDetail[Index] = nil
        ReddotManager.DecreaseLeafNodeCount(NodeName, 1)
    end
end

function M:ItemMenuAnchorChanged(IsOpen)
    if (self.Content.OnMenuOpenChangedEvent and self.Content.OnMenuOpenChangedEvent[1] and self.Content.OnMenuOpenChangedEvent[2]) then
        self.Content.OnMenuOpenChangedEvent[2](self.Content.OnMenuOpenChangedEvent[1], IsOpen)
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if not self.Content or ((self.Content.Ids and #self.Content.Ids <= 1) or self.Content.bLocked) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Add_Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if not self.Content or ((self.Content.Ids and #self.Content.Ids <= 1) or self.Content.bLocked) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Add_UnHover)
end

function M:OnClicked()
    if not self.Content or ((self.Content.Ids and #self.Content.Ids <= 1) or self.Content.bLocked) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Add_Click)
end

function M:OnPressed()
    if not self.Content or ((self.Content.Ids and #self.Content.Ids <= 1) or self.Content.bLocked) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Add_Press)
end

function M:OnReleased()
    if not self.Content or ((self.Content.Ids and #self.Content.Ids <= 1) or self.Content.bLocked) then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Add_Normal)
end

return M

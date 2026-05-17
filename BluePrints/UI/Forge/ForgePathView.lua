---@type WBP_Forging_PathTree_C
local ForgePathView = Class("BluePrints.UI.BP_UIState_C")
local ForgeUtils = require "Blueprints.UI.Forge.ForgeUtils"
local ForgeConst = require "Blueprints.UI.Forge.ForgeConst"

function ForgePathView:PreInit()
    self.ItemMap = {
        {self.Item_Head},
        {self.Item_01, self.Item_02, self.Item_03, self.Item_04},
        {self.Item_05, self.Item_06, self.Item_07, self.Item_08},
        {self.Item_09, self.Item_10, self.Item_11, self.Item_12}
    }
    self.LineMap = {
        {self.Line_01},
        {self.Line_02, self.Line_03, self.Line_04, self.Line_05},
        {self.Line_06, self.Line_07, self.Line_08},
        {self.Line_09, self.Line_10, self.Line_11},
    }
    self.RowMap = {self.Head, self.Level_1, self.Level_2, self.Level_3}

    -- 预处理每条Line右侧接线的位置
    self.LinePosMap = {
        {0},
        {2 ,3, 4, 5},
        {2, 4, 5},
        {2, 4, 5}
    }
    
    self.LineAnimMap = {
        nil, nil, self.SecondRow, self.ThirdRow
    }

    -- 初始化一些界面文本
    self.Text_ForgingPath:SetText(GText("UI_FORGING_PATH"))
    self.Text_Ok:SetText(GText("UI_FORGING_READY"))
    self.Text_Working:SetText(GText("UI_TAB_NAME_FORGING"))
    self.Text_Lack:SetText(GText("UI_FORGING_NOCONDITION"))
    self.Text_No:SetText(GText("UI_FORGING_FORBIDDEN"))
    self.Text_State:SetText(GText("UI_FORGING_STATE"))
    self:BindUIEvents()
    self.LastTargetRowIndex = nil
    self.LastTargetColIndex = nil
end

function ForgePathView:InitView(DraftId, MaxLen)
    self:PlayAnimation(self.In)
    self.Btn_Close:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return",nil,nil)
    end)
    self.Btn_Close:UnBindEventOnClicked(self, self.OnBtnCloseClicked)
    self.Btn_Close:BindEventOnClicked(self, self.OnBtnCloseClicked)
    self.ItemDetails.Forging:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local Content = ForgeUtils:ConstructItemContentFromDraftId(DraftId)
    Content.OnMouseButtonDownEvent = {Obj = self, Callback = function()
        if self.CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
            self:OnItemSelected(1, 1, true)
        else
            self:OnItemSelected(1, 1)
        end
    end}
    Content.OnFocusReceivedEvent = {
        Obj = self,
        Callback = function() 
            if UIUtils.IsGamepadInput() then
                self:OnItemSelected(1, 1)
                AudioManager(self):PlayItemSound(self, self.Item_Head.Id, "Click", self.Item_Head.ItemType) -- 播一下音效
            end

        end
    }
    Content.HandleKeyDown = false
    self.Item_Head:Init(Content)
    -- 自定义根节点向下导航规则
    self.Item_Head:SetNavigationRuleCustom(UE4.EUINavigation.Down, {self, function()
        return self.ItemMap[2][math.min(#self.PathModel.RowInfos[2], 2)]
    end})
    
    self.Line_01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.ItemDetails.Draft:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.ItemDetails.Text_Draft:SetText(GText("UI_FORGING_BLUEPRINT"))
    self.ItemDetails.Text_DraftNum:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

    for i = 1, MaxLen do 
        self.RowMap[i]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        if i > 1 then 
            local ItemRow = self.ItemMap[i]
            for _, Item in ipairs(ItemRow) do 
                Item.Line02_Bg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                Item.Line02_Connect:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            end
        end
    end

    for i = MaxLen + 1, #self.RowMap do 
        self.RowMap[i]:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end


    -- 隐藏掉最下一排图标的下连接线
    local ItemLastRow = self.ItemMap[MaxLen]
    for _, Item in ipairs(ItemLastRow) do 
        Item.Line02_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        Item.Line02_Connect:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function ForgePathView:RefreshView(DraftInfo)
    local ItemDetailParam = {}
    ItemDetailParam.ItemId = DraftInfo.ProductId
    ItemDetailParam.ItemType = DraftInfo.ProductType
    ItemDetailParam.bHideGamePad = true
    ItemDetailParam.HandleKeyDown = false
    self.ItemDetails:RefreshItemInfo(ItemDetailParam, true)
    self.ItemDetails.Text_DraftNum:SetText(DraftInfo.Count)
end

function ForgePathView:TickRefreshView(DraftInfo)
    if DraftInfo then
        self.ItemDetails.Forging:RefreshView(DraftInfo)
    else
        self.ItemDetails.Forging:SetDraftNotEnough() 
    end
end

function ForgePathView:BindUIEvents()
    for RowIndex, ItemRow in ipairs(self.ItemMap) do 
        if RowIndex ~= 1 then
            for ColIndex, PathItem in ipairs(ItemRow) do 
                PathItem:PreInit(RowIndex, ColIndex, self, self.OnItemSelected)
            end
        end
    end
end

function ForgePathView:SelectNodeView(RowIndex, ColIndex, HasNextRowItems)
    if RowIndex > 1 then
        local ItemView = self.ItemMap[RowIndex][ColIndex]
        ItemView:SetSelected(true, HasNextRowItems)
    end
    self:SetTargetSelectedView(RowIndex, ColIndex, true)

    -- 更新RowIndex + 1的Item的Count

end

function ForgePathView:UnSelectNodeView(RowIndex, ColIndex)
    if RowIndex > 1 then 
        local ItemView = self.ItemMap[RowIndex][ColIndex]
        ItemView:SetSelected(false)
    end
end

function ForgePathView:SetTargetSelectedView(RowIndex, ColIndex, IsSelected)
    local PathItem = self.ItemMap[RowIndex][ColIndex]
    if RowIndex == 1 then 
        PathItem:SetSelected(IsSelected) 
    else 
        PathItem.Item:SetSelected(IsSelected)
    end

    if IsSelected and self.LastTargetRowIndex and self.LastTargetColIndex then 
        self:SetTargetSelectedView(self.LastTargetRowIndex, self.LastTargetColIndex, false)
    end

    self.LastTargetRowIndex = RowIndex
    self.LastTargetColIndex = ColIndex
end

function ForgePathView:RefreshSingleItemView(RowIndex, ColIndex, ItemInfo)
    local ItemView = self.ItemMap[RowIndex][ColIndex]
    if ItemView then
        self:_RefreshSingleItemView(ItemView, ItemInfo)
    else 
        DebugPrint("Tianyi@ RefreshSingleItemView failed: ItemView not found!")
    end
end

function ForgePathView:_RefreshSingleItemView(Item, ItemInfo)
    local Avatar = GWorld:GetAvatar()
    local ItemContent = ForgeUtils:ConstructItemContentFromResourceId(ItemInfo.ResourceType, ItemInfo.ResourceId)
    ItemContent.Count = ForgeUtils:GetResourceNum(ItemInfo.ResourceType, ItemInfo.ResourceId)
    ItemContent.NeedCount = ItemInfo.ResNeedNum 
    Item:UpdateView(ItemContent)

    -- 更新物品对应的设计稿状态
    local DraftId = ItemInfo.DraftId 
    local ItemDraftState = nil
    local ShowRedDot = false
    if DraftId then 
        local DraftInfo = self.ForgeModel:CheckState(DraftId)
        if DraftInfo then 
            if DraftInfo.State == ForgeConst.DraftState.InProgress then 
                ItemDraftState = ForgeConst.PathItemDraftState.Producing
            elseif DraftInfo.State == ForgeConst.DraftState.Complete then 
                local CanProduce = DraftInfo.IsResourceEnough and DraftInfo.IsFoundryEnough
                ItemDraftState = CanProduce and ForgeConst.PathItemDraftState.CanProduce or ForgeConst.PathItemDraftState.ConditionsNotMet 
                ShowRedDot = true
            elseif DraftInfo.CanProduce then 
                ItemDraftState = ForgeConst.PathItemDraftState.CanProduce
            else 
                ItemDraftState = ForgeConst.PathItemDraftState.ConditionsNotMet 
            end
        else 
            ItemDraftState = ForgeConst.PathItemDraftState.ConditionsNotMet
        end
    else 
        ItemDraftState = ForgeConst.PathItemDraftState.CantProduce
    end

    Item:UpdateDraftState(ItemDraftState, ShowRedDot)
end

-- 当新的一行Item更新时调用
function ForgePathView:UpdateNewRowItem(Item, ItemInfo)
    self:_RefreshSingleItemView(Item, ItemInfo)
    Item:SetUpLineVisible(true)
    Item:SetDownLineVisible(false)
    Item:SetSelected(false)
end

-- 清空所有路径Item的数量显示，用于铸造图鉴
function ForgePathView:ClearItemCountWidget()
    for RowIndex, ItemRow in ipairs(self.ItemMap) do 
        if RowIndex ~= 1 then
            for ColIndex, PathItem in ipairs(ItemRow) do 
                PathItem.Item:ClearBackGroundHeight(true)
                PathItem.Item:SetCount(nil)
            end
        end
    end
end

-- 清掉一行的内容
function ForgePathView:ClearRowView(RowIndex)
    if not self.ItemMap[RowIndex] then return end
    for _, PathItem in ipairs(self.ItemMap[RowIndex]) do 
        PathItem:SetEmpty()
    end
    
    if not self.LineMap[RowIndex] then return end 
    for _, LineItem in ipairs(self.LineMap[RowIndex]) do 
        LineItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end


-- 刷新一行内容
function ForgePathView:UpdateRowItemsView(RowIndex, ItemsList)
    for Index, Item in ipairs(self.ItemMap[RowIndex]) do 
        if Index > #ItemsList then 
            Item:SetEmpty()
        else 
            local ItemInfo = ItemsList[Index]
            self:UpdateNewRowItem(Item, ItemInfo)
        end
    end

    if #ItemsList > 0 then 
        local LineAnim = self.LineAnimMap[RowIndex]
        if LineAnim then 
            self:PlayAnimation(LineAnim)
        end
    end

    -- self.RowMap[RowIndex]:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)                                                               
end

function ForgePathView:UpdateRowLinesView(RowIndex, RightMostPos)
    for Index, Line in ipairs(self.LineMap[RowIndex]) do 
        local LineRightPos = self.LinePosMap[RowIndex][Index]
        if RightMostPos >= LineRightPos then 
            Line:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else 
            Line:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end

    if RightMostPos > 0 and self.LineAnimMap[RowIndex] then 
        self:PlayAnimation(self.LineAnimMap[RowIndex])
    end
end

-- 手柄端
-----------------------------------
function ForgePathView:InitKeyboardView()
        -- 刷新一遍所有Item的可点击性
    for RowIndex, ItemRow in ipairs(self.ItemMap) do 
        if RowIndex ~= 1 then
            for ColIndex, PathItem in ipairs(ItemRow) do 
                PathItem:SetClickable(true)
            end
        end
    end
end

function ForgePathView:InitGamepadView()
    -- 刷新一遍所有Item的可点击性
    for RowIndex, ItemRow in ipairs(self.ItemMap) do 
        if RowIndex ~= 1 then
            for ColIndex, PathItem in ipairs(ItemRow) do 
                PathItem:SetClickable(false)
            end
        end
    end
end

function ForgePathView:SetGamepadFocus()
    self.Item_Head:SetFocus()
end



function ForgePathView:OnBtnCloseClicked()
    self:OnClose()
end

function ForgePathView:CloseView()
    self:PlayAnimation(self.Out)
end

function ForgePathView:OnAnimationFinished(InAnim)
    if InAnim == self.Out then 
        self:RealCloseView()
    end
end

function ForgePathView:RealCloseView()
    if self.OnClosedCallback then
        local Obj, Func = table.unpack(self.OnClosedCallback)
        if Obj and Func then
            Func(Obj)
        end
    end
end

function ForgePathView:GetDesiredFocusTarget()
    if self.LastTargetColIndex and self.LastTargetRowIndex then 
        local ItemWidget = self.ItemMap[self.LastTargetRowIndex][self.LastTargetColIndex]
        return ItemWidget
    else 
        return self.Item_Head
    end
end

function ForgePathView:RefocusToPathView()
    self:GetDesiredFocusTarget():SetFocus()
    self.ItemDetails.Forging:SetGamepadButtonKeyVisible(true)
end

function ForgePathView:Handle_KeyDownOnGamePad(InKeyName)
    local IsEventHandled = false 
    if InKeyName == Const.GamepadFaceButtonDown then 
        IsEventHandled = true 
    elseif InKeyName == Const.GamepadFaceButtonRight then 
        if self.IsShowTipDetails then
            self:HandleTipShowDetails(false)
        else 
            self:OnBtnCloseClicked()
        end
        IsEventHandled = true 
    elseif InKeyName == Const.GamepadSpecialLeft then 
        IsEventHandled = self:HandleTipShowDetails(true)
    elseif InKeyName == Const.GamepadFaceButtonLeft then
        self:OnDetailsViewBtnCancelClicked()
        IsEventHandled = true 
    end

    if not IsEventHandled then
        IsEventHandled = self.ItemDetails:OnGamePadDown(InKeyName)
    end

    return IsEventHandled
end

function ForgePathView:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
       IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

-- 图鉴模式
function ForgePathView:InitCompendiumView()
    self.State:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.ItemDetails.Forging:SetVisibility(UE4.ESlateVisibility.Collapsed)

    for RowIndex, ItemRow in ipairs(self.ItemMap) do 
        if RowIndex ~= 1 then
            for ColIndex, PathItem in ipairs(ItemRow) do 
                PathItem:InitCompendiumView()
            end
        end
    end
end

return ForgePathView
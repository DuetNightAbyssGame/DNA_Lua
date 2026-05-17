--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local RewardBox = require "BluePrints.Client.CustomTypes.SimpleRewardBox"
---@type Common_GetItem_PC_C
local M = Class("BluePrints.UI.BP_UIState_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.List_Item.BP_OnEntryGenerated:Add(self,self.OnItemListEntryGenerated)
    self.List_Item_Single.BP_OnEntryGenerated:Add(self,self.OnItemListEntryGenerated)
end

function M:OnItemListEntryGenerated(Widget)
    if Widget._MostRarityFX and self:IsAnimationPlaying(self.In) then
        Widget:_SetMostRarityFX(0)
    end
end


function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    if not self.bSpecial then
        AudioManager(self):PlayUISound(self, "event:/ui/common/get_award_items", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/get_award_items_high_level", nil, nil)
    end

    self:PlayAnimation(self.In)
    self:BindToAnimationFinished(self.In, {self,function()
        if self.NowList then
            for _,Entry in pairs(self.NowList:GetDisplayedEntryWidgets()) do
                Entry:_SetMostRarityFX(Entry.Rarity)
            end
        end
    end})

    -- self.bIsFocusable = true
    -- self:SetFocus()

    self.Text_GetItem:SetText(GText("UI_COMMONPOP_TITLE_100017"))
    self.Text_Tip:SetText(GText("UI_TRAIN_CLOSE"))

    local ShopItemType, ShopItemId, Count, PurchaseRewards, func, ParentWidget, IsReAttachFocusToPage, ToastText = ...
    if func == -1 then
        func = nil
    end
    if ParentWidget == -1 then
        ParentWidget = nil
    end
    if func then
        self:BindActionOnClosed(func, ParentWidget)
    end

    if (IsReAttachFocusToPage) then
        self:AddTimer(0.5, self.DelayToCheckIsFocusOnReward)
    end

    self.RewardList = {}
    -- self.WrapBox_Content:ClearChildren()
    self:AddTimer(self.InTime, function()
        self:InitGetItemInfo(ShopItemType, ShopItemId, Count, PurchaseRewards)
    end, false, 0, nil, true)
    self.IsShowDetails = false
    -- self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
    if ToastText then
        self.Toast_GetItem.Text_Toast:SetText(ToastText)
        self.Toast_GetItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Toast_GetItem:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:InitGetItemInfo(ShopItemType, ShopItemId, Count, PurchaseRewards)
    self.List_Item:ClearListItems()
    self.List_Item_Single:ClearListItems()
    if PurchaseRewards then
        local RewardType = DataMgr.RewardType
        for ItemType, _ in pairs(RewardType) do
            local Rewards = PurchaseRewards[ItemType.."s"]
            if Rewards then
                local RewardInfo = DataMgr[ItemType]
                for ItemId, ItemCount in pairs(Rewards) do
                    local count = 0
                    if type(ItemCount) == "table" then
                        count = RewardBox:GetCount(ItemCount)
                    end
                    if type(ItemCount) == "number" then
                        count = ItemCount
                    end
                    self.RewardList[ItemId] = { TableName = ItemType, ItemCount = count, Rarity = RewardInfo[ItemId].Rarity or RewardInfo[ItemId][ItemType.."Rarity"]}
                end
            end
        end

        self.RewardInfoList = {}
        for key, Value in pairs(self.RewardList) do
            table.insert(self.RewardInfoList, {ItemId = key, ItemInfo = Value})
        end
        table.sort(self.RewardInfoList, function(A, B)
            local RarityA = A.ItemInfo.Rarity or 1
            local RarityB = B.ItemInfo.Rarity or 1
            if RarityA > RarityB then
                return true
            elseif RarityA == RarityB then
                return A.ItemId < B.ItemId
            else
                return false
            end
        end)
        if #self.RewardInfoList > 7 then
            self.WS_List:SetActiveWidgetIndex(0)
            for _, Value in pairs(self.RewardInfoList) do
                local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
                local Content = self:NewItemContent(ItemInfo.TableName, ItemId, ItemInfo.ItemCount)
                self.List_Item:AddItem(Content)
            end
            self.NowList = self.List_Item
        else
            self.WS_List:SetActiveWidgetIndex(1)
            for _, Value in pairs(self.RewardInfoList) do
                local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
                local Content = self:NewItemContent(ItemInfo.TableName, ItemId, ItemInfo.ItemCount)
                self.List_Item_Single:AddItem(Content)
            end
            self.NowList = self.List_Item_Single
        end
    else
        if (ShopItemType ~= nil and ShopItemType ~= -1) then
            self.WS_List:SetActiveWidgetIndex(1)
            local Content = self:NewItemContent(ShopItemType, ShopItemId, Count)
            self.List_Item_Single:AddItem(Content)
        end
        self.NowList = self.List_Item_Single
    end
    self:InitHandleKeyInfo()
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    self:OnUpdateUIStyleByInputTypeChange(self.CurInputDeviceType, self.CurGamepadName)

end

function M:SetDefaultFocus()
    if self.RewardInfoList and #self.RewardInfoList > 7 then
        self.List_Item:SetFocus()
    else
        self.List_Item_Single:SetFocus()
    end
end

function M:DelayToCheckIsFocusOnReward()
    if (not self:HasAnyFocus()) then
        --self:SetFocus()
        self:SetDefaultFocus()
    end
end

--- 初始化道具框Item
---@param ContainerWidget WrapBox 父容器
---@param Item WBP_CommonItemSubsize_C 道具框Item
---@param Content Common_Item_subsize_PC_Content_C 道具框Item的内容
function M:InitListItem(ContainerWidget, Item, Content, bNewItem)
    if bNewItem then
        ContainerWidget:AddChild(Item)
    end
    Item:Init(Content)
    --- 记录道具框Item的MenuAnchor是否打开来决定点击关闭获得物品弹窗时是否关闭
    local Events = {}
    Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
    Item:BindEvents(self, Events)
end

function M:ItemMenuAnchorChanged(bIsOpen)
    self.IsShowDetails = bIsOpen
    -- if bIsOpen then
        self.bCantClose = bIsOpen
    -- end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self:OnUpdateUIStyleByInputTypeChange(GameInputModeSubsystem:GetCurrentInputType(), GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:BP_GetDesiredFocusTarget()
    if self.RewardInfoList and #self.RewardInfoList > 7 then
        return self.List_Item
    else
        return self.List_Item_Single
    end
end

function M:InitHandleKeyInfo()
    self.Panel_Key:ClearChildren()
    local Item1 = self:CreateWidgetNew("ComKeyTextDesc")
    local Item2 = self:CreateWidgetNew("ComKeyTextDesc")
    local Item3 = self:CreateWidgetNew("ComKeyTextDesc")
    Item1:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LH"
            },
        },
        Desc = GText("UI_Controller_Switch"),
    })
    Item2:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            },
        },
        Desc = GText("UI_DETAILS"),
    })
    Item3:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B"
            },
        },
        Desc = GText("UI_BACK"),
    })
    if self.RewardInfoList and #self.RewardInfoList > 1 then
        self.Panel_Key:AddChild(Item1)
    end
    self.Panel_Key:AddChild(Item2)
    self.Panel_Key:AddChild(Item3)
end


--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:NewItemContent(ItemType, ItemId, Count)
    local ItemData = DataMgr[ItemType][ItemId]
    --新建一个列表数据对象
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.ItemType = ItemType
    Obj.Id = ItemId
    local Name;
    if ItemType == "Draft" then
        local ProductData = DataMgr[ItemData.ProductType][ItemData.ProductId]
        Name = GText("UI_FORGING_BLUEPRINT")..GText(ProductData[ItemData.ProductType.."Name"] or ProductData["Name"])
    else
        Name = ItemUtils:GetDropName(ItemId, ItemType)
    end
    Obj.Count = Count
    Obj.Rarity = ItemUtils.GetItemRarity(ItemId, ItemType)

    if ItemType == "HeadSculpture" then
        Obj.Icon = ItemData.HeadPath
    else
        Obj.Icon = ItemUtils.GetItemIconPath(ItemId, ItemType)
    end
    Obj.IsShowDetails = true
    Obj.UIName = "GetItemPage"
    return Obj
end

function M:BindActionOnClosed(func, ParentWidget)
    self.OnClosed = func
    self.ParentWidget = ParentWidget
end

function M:CloseSelf()
    -- if self.bCantClose then
    --     self.bCantClose = false
    --     return
    -- end
    self:RemoveTimer("InitGetItemInfo")
    if not self.bAnimClose then
        self:AddTimer(0.5, function()
            self.bAnimClose = true
        end, false, 0, nil, true)
        return
    end
    -- Focus到父级
    local UIState = UIManager(self):GetLastestAndFocusableUIWidgetObj()
    if UIState then
        UIState:SetFocus()
    end
    self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        self:Close()
        if self.OnClosed then 
            if (self.ParentWidget ~= nil) then
                self.OnClosed(self.ParentWidget)
            else
                self:OnClosed() 
            end
        end
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    if (IsUseKeyAndMouse) then
        -- PC逻辑
        self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif CurInputDevice == ECommonInputType.Gamepad then
        self:SetDefaultFocus()
        if not self.IsShowDetails then
            self.Panel_Key:SetVisibility(ESlateVisibility.Visible)
        else
            self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        end
        self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
    end
end


function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:CloseSelf()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right" then
        self:CloseSelf()
        IsEventHandled = true
    end
    return IsEventHandled
end

-- function M:OnMouseButtonDown()
--     self:CloseSelf()
--     return UE4.UWidgetBlueprintLibrary.Handled()
-- end

return M

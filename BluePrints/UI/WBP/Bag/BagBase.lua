--
-- DESCRIPTION
-- 背包Model类 （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local CommonUtils = require "Utils.CommonUtils"
local StuffIconObject = require "BluePrints.UI.WBP.Bag.Widget.BagStuffIconObject"
local BagCommon = require "BluePrints.UI.WBP.Bag.BagCommon"

local M = Class()

--#region BagSift 背包出售、分解批量选择
function M:InitMultiSelectWidget()
    for key, value in pairs(BagCommon.RarityColorInfo) do
        local ConfigData = {
            ColorName = key,
            Rarity = value,
            ClickCallback = self.ToSelectBagItemWithRarity,
            OwnerWidget = self,
        } 
        self[key]:Init(ConfigData)
    end
    if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC) then
        self.Key_GamePad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "LS",
                },
            },
        }) 
    end
    self.Text_MultiSelect:SetText(GText("UI_Bag_Sell_Batch"))

    self.CheckBox_Retain:BindEventOnClicked({Inst = self, Func = self.OnRetainOneCheckStateChanged})
    self.Text_Retain:SetText(GText("UI_Bag_RemainOne"))
    self.CheckBox_Ignore:BindEventOnClicked({Inst = self, Func = self.OnIgnoreEquipedCheckStateChanged})
    self.Text_Ignore:SetText(GText("UI_Bag_IgnoreEquipped"))

    self.CheckBox_Retain:HideKey(true)
    self.CheckBox_Ignore:HideKey(true)
end

function M:StartMultiSelectWidget()
    for key, value in pairs(BagCommon.RarityColorInfo) do
        self[key]:Start()
    end
end

function M:ResetMultiSelectWidget()
    for key, value in pairs(BagCommon.RarityColorInfo) do
        self[key]:Reset()
    end
end

function M:ToSelectBagItemWithRarity(IsChecked, Rarity)
    -- 添加进出售、分解列表
    local AllItemCount, ResultList = self.List_Item:GetNumItems(), {}
    local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
    for i = 0, AllItemCount - 1, 1 do
        local ItemObj = self.List_Item:GetItemAt(i)
        if (ItemObj and ItemObj.Rarity == Rarity) then
            if (IsChecked) then
                local RetData = self:TryToAddItemToTargetListWithRarity(ItemObj, SellPageMainUI)
                local IsReserveOne, IsCanAdd = self.CheckBox_Retain:IsChecked(), true
                if (IsReserveOne and RetData and RetData.StuffCount <= 1) then
                    IsCanAdd = false
                end
                if (IsCanAdd) then
                    table.insert(ResultList, RetData)
                end
            else
                local bIsNeedRemove = self:TryToRemoveItemToTargetListWithRarity(ItemObj)
                if (bIsNeedRemove) then
                    table.insert(ResultList, ItemObj.Uuid)
                end
            end
        end
    end
    if (SellPageMainUI) then
        if (IsChecked) then
            SellPageMainUI:MultiAddBagItemToList(ResultList)
        else
            SellPageMainUI:MultiRemoveBagItemInList(ResultList)
        end
    end
end
--#endregion

--region BagSift 背包筛选相关
function M:FilterStuffDataBySift(StuffItems)
    if not self.SelectedSiftItems or next(self.SelectedSiftItems) == nil then
        return StuffItems
    end
    -- if not self.AllStuffData then return end
    local FilteredItems = {}
    for _, StuffItem in ipairs(self.AllStuffData) do
        -- 判断物品是否符合筛选条件
        if self:IsStuffItemMatchedWithSift(StuffItem) then
            table.insert(FilteredItems, StuffItem)
        end
    end
    self.FilteredStuffData = FilteredItems
    return FilteredItems
end

function M:OnSiftAddedToFocusPath()
    self.Filter.Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnSiftRemovedFromFocusPath()
    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
        self.Filter.Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
end

function M:IsStuffItemMatchedWithSift(StuffItem)
    local fieldMapping = {}
    local SiftModelId = self.SiftModelId 
    local SubIds = DataMgr.SiftModel[SiftModelId].SubId
    for i, SiftId in ipairs(SubIds) do
        local SiftData = DataMgr.SiftDimens[SiftId]  
        local field = SiftData.SelectionField[1]
        fieldMapping[i] = field == "WeaponRarity" and "Rarity" or field
    end

    local function getFieldValueByIndex(StuffItem, index)
        local fieldName = fieldMapping[index]
        if fieldName == "WeaponTag" then
            return StuffItem.SiftTag
        elseif fieldName == "FilterTag" then
            return StuffItem.FilterTag
        else
            local fieldValue = StuffItem[fieldName]
            if fieldName == "Level" and type(fieldValue) == "number" and fieldValue > 1 then
                fieldValue = 1
            end
            if fieldName == "bAura" then
                if StuffItem.bAura then
                    fieldValue = 1
                else
                    fieldValue = 0
                end
            end
            if type(fieldValue) == "number" then
                return tostring(fieldValue)
            else
                return fieldValue
            end
        end
    end

    for i, SiftItem in pairs(self.SelectedSiftItems) do
        -- 获取对应的 StuffItem 字段值
        local fieldValue = getFieldValueByIndex(StuffItem, i)
        if fieldValue then
            local matched = false
            -- 根据索引从 SiftItemDatas 中获取对应的筛选值
            local siftValues = {}
            for _, index in pairs(SiftItem) do
                local siftValue = self.SiftItemDatas[i].SelectionDatas[index]
                if siftValue then
                    table.insert(siftValues, siftValue)
                end
            end
            -- 检查 fieldValue 是否匹配当前筛选字段的任意一个值
            if fieldMapping[i] == "FilterTag" then
                for _, tagValue in ipairs(fieldValue) do
                    for _, siftValue in ipairs(siftValues) do
                        if tagValue == siftValue then
                            matched = true
                            break
                        end
                    end
                    if matched then
                        break
                    end
                end
            elseif fieldMapping[i] == "WeaponTag" then
                for tagValue, _ in pairs(fieldValue) do
                    for _, siftValue in ipairs(siftValues) do
                        if tagValue == siftValue then
                            matched = true
                            break
                        end
                    end
                    if matched then
                        break
                    end
                end
            else
                for _, siftValue in ipairs(siftValues) do
                    if fieldValue == siftValue then
                        matched = true
                        break
                    end
                end
            end
            if not matched then
                return false
            end
        else
            return false
        end
    end
    return true
end
--endregion

--region BagSort 背包排序相关
function M:SortAllItemsByType(StuffDataTable)
    local Filter1Idx, SortType = self.Filter:GetSortInfos()
    self:SortItemContents(StuffDataTable, BagCommon.SortFilters[self.CurTabId][Filter1Idx], SortType)
    return StuffDataTable
end

function M:SortItemContents(InOutArr, Key, SortType)
    local OrderBy, SortFunc = nil, nil
    if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
        -- 武器排序
        OrderBy = {"Level", "SortPriority", "StuffId"}
        SortFunc = function(a,b)
            -- if(self.CurSelectStuffContent ~= nil and a.Uuid == self.CurSelectStuffContent.Uuid)then
            --     return true
            -- end
            -- if(self.CurSelectStuffContent ~= nil and b.Uuid == self.CurSelectStuffContent.Uuid)then
            --     return false
            -- end
            if (a.IsEquipped and not b.IsEquipped) then
                return true
            end
            if (not a.IsEquipped and b.IsEquipped) then
                return false
            end
            return self:GetFinalSortResult(a, b, OrderBy, SortType, 1, 3)
        end
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
        -- Mod排序
        OrderBy = {"ApplicationType", "Rarity", "Level", "Price", "StuffId"}
        if(Key == "UI_Select_Unique")then
            OrderBy[1] = "Rarity"
            OrderBy[2] = "ApplicationType"
        elseif(Key == "UI_Select_Level")then
            OrderBy[1] = "Level"
            OrderBy[2] = "ApplicationType"
            OrderBy[3] = "Rarity"
        elseif(Key == "UI_Select_Price")then
            OrderBy[1] = "Price"
            OrderBy[2] = "ApplicationType"
            OrderBy[3] = "Rarity"
            OrderBy[4] = "Level"
        end
        SortFunc = function(a,b)
            if (a.IsEquipped and not b.IsEquipped) then
                return true
            end
            if (not a.IsEquipped and b.IsEquipped) then
                return false
            end
            return self:GetFinalSortResult(a, b, OrderBy, SortType, 1, 5)
        end
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Resource) then
        -- 道具排序
        OrderBy = { "Rarity", "Price", "StuffId"}  
        if(Key == "UI_Select_Price")then
            OrderBy[1] = "Price"
            OrderBy[2] = "Rarity"
            OrderBy[3] = "StuffId"
        end
        SortFunc = function(a,b)
            return self:GetFinalSortResult(a, b, OrderBy, SortType, 1, 3)
        end
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.ConsumableItem) then
        -- 消耗品排序
        OrderBy = { "Rarity", "ConsumableType", "StuffId"} 
        SortFunc = function(a,b)
            a["ConsumableType"] = BagCommon.ConsumableItemTypeSortWeight[a.UseEffectType] or 1
            b["ConsumableType"] = BagCommon.ConsumableItemTypeSortWeight[b.UseEffectType] or 1
            return self:GetFinalSortResult(a, b, OrderBy, SortType, 1, 3)
        end
    elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Draft) then
        -- 铸造图纸相关
        OrderBy = {"ApplicationType", "Rarity", "StuffId"}
        if(Key == "UI_Select_Unique")then
            OrderBy[1] = "Rarity"
            OrderBy[2] = "ApplicationType"
        end
        SortFunc = function(a,b)
            return self:GetFinalSortResult(a, b, OrderBy, SortType, 1, 3)
        end
    else
        -- 其他排序
        OrderBy = {"Rarity", "StuffId"}  
        SortFunc = function(a,b)
            return self:GetFinalSortResult(a, b, OrderBy, SortType, 1, 2)
        end
    end
    table.sort(InOutArr,SortFunc)
end

function M:GetFinalSortResult(CompareA, ComPareB, OrderBy, SortType, StartIndex, MaxDepth)
    if (StartIndex == MaxDepth) then
        if(SortType == CommonConst.ASC)then
            return CompareA[OrderBy[StartIndex]] < ComPareB[OrderBy[StartIndex]]
        else
            return CompareA[OrderBy[StartIndex]] > ComPareB[OrderBy[StartIndex]]
        end 
    end 
    if(CompareA[OrderBy[StartIndex]] == ComPareB[OrderBy[StartIndex]])then
        return self:GetFinalSortResult(CompareA, ComPareB, OrderBy, SortType, StartIndex + 1, MaxDepth)
    elseif(SortType == CommonConst.ASC)then
        return CompareA[OrderBy[StartIndex]] < ComPareB[OrderBy[StartIndex]]
    else
        return CompareA[OrderBy[StartIndex]] > ComPareB[OrderBy[StartIndex]]
    end 
end
--endregion

--region BagItemList 背包列表相关
function M:FillWithListViewData(TabId, NeedDelayJumpToItem)
    if (self.LoadMode == "FrameBlocking") then
        if (self:IsExistTimer("DelayToLoadItemByFrame")) then
            self:RemoveTimer("DelayToLoadItemByFrame")
        end
        self:AddTimer(self.TimeToDelayLoad, function()
            self:RemoveCoroutineTask(self.FillPlayerDataByTypeInFrame)
            self.IsLoadCompleted = false
            self.List_Item:BP_ClearSelection()
            self.List_Item:ClearListItems()
            self:AddCoroutineTask(self.FillPlayerDataByTypeInFrame, self, TabId, NeedDelayJumpToItem)
        end, false, 0, "DelayToLoadItemByFrame") 
        self:HorizontalListViewResize_SetUp(self.Panel_Content, self.List_Item, 0)
    else
        self.IsLoadCompleted = true
        self.List_Item:BP_ClearSelection()
        self.List_Item:ClearListItems()
        self:FillPlayerDataByType(TabId, NeedDelayJumpToItem)
    end
end

function M:FillPlayerDataByType(TabId, NeedDelayJump)
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        DebugPrint("Avatar is nil, Not Connect to Server")
        return
    end
    local PlayerStuffs = nil
    self.NeedSelectGridIndex = -1
    if (TabId == BagCommon.ItemTypeToTabId.MeleeWeapon or TabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
        PlayerStuffs = Avatar.Weapons
    elseif (TabId == BagCommon.ItemTypeToTabId.Mod) then
        PlayerStuffs = Avatar.Mods
    elseif (TabId == BagCommon.ItemTypeToTabId.Draft) then
        PlayerStuffs = Avatar.Drafts
    else
        PlayerStuffs = Avatar.Resources
    end
    if (PlayerStuffs ~= nil) then
        local ReasultStuffData = {}
        for Id, StuffServerData in pairs(PlayerStuffs) do
            local StuffData = nil
            if (TabId == BagCommon.ItemTypeToTabId.MeleeWeapon or TabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
                -- 武器相关
                if ((TabId == BagCommon.ItemTypeToTabId.MeleeWeapon and StuffServerData:HasTag("Melee")) or (TabId == BagCommon.ItemTypeToTabId.RangedWeapon and StuffServerData:HasTag("Ranged"))) then
                    StuffData = StuffIconObject:GetWeaponStuffData(StuffServerData, self)
                end
                if (StuffData ~= nil) then
                    StuffData.IsEquipped = self:GetIsStuffIsEquiped(StuffData)
                end
            elseif (TabId == BagCommon.ItemTypeToTabId.Mod) then
                -- Mod相关
                StuffData = StuffIconObject:GetModStuffData(StuffServerData, self) 
                if (StuffData ~= nil) then
                    StuffData.IsEquipped = self:GetIsStuffIsEquiped(StuffData)
                end
            elseif (TabId == BagCommon.ItemTypeToTabId.Draft) then
                -- 铸造图纸相关
                StuffData = StuffIconObject:GetDraftsStuffData(StuffServerData, self)
            else
                -- 道具相关
                local StuffConfigData = StuffServerData:Data()
                if (StuffConfigData and StuffConfigData.MaterialClassify == TabId) then
                    StuffData = StuffIconObject:GetItemStuffData(StuffServerData, self)
                end
            end
            if (StuffData ~= nil) then
                table.insert(ReasultStuffData, StuffData)
            end
        end
        -- 保存所有物品数据
        self.AllStuffData = ReasultStuffData
        ReasultStuffData = self:FilterStuffDataBySift(self.AllStuffData)
        local FinalStuffData = {}
        if (#ReasultStuffData > 1) then
            FinalStuffData = self:SortAllItemsByType(ReasultStuffData)
        else
            FinalStuffData = ReasultStuffData
        end
        local BagItemCount = #self.AllStuffData
        self:RefreshItemViewByItemCount(BagItemCount, #FinalStuffData)

        if (#FinalStuffData > 0) then
            for i, OrderStuffData in ipairs(FinalStuffData) do
                if (self.NeedSelectStuffId ~= nil) then
                    OrderStuffData.IsSelect = OrderStuffData.Uuid == self.NeedSelectStuffId
                else
                    OrderStuffData.IsSelect = false
                end
                if (OrderStuffData.IsSelect) then
                    self.NeedSelectGridIndex = math.max(i - 1, 0)
                end
                OrderStuffData.GridIndex = i
                local StuffObj = StuffIconObject:CreateBagItemContent(OrderStuffData)
                self.List_Item:AddItem(StuffObj)
                -- 刷新一下数据
                if (self.DesireSaleStuffObjList[StuffObj.Uuid] ~= nil) then
                    self.DesireSaleStuffObjList[StuffObj.Uuid] = StuffObj
                end
                if (self.DesireResolveWeaponList[StuffObj.Uuid] ~= nil) then
                    self.DesireResolveWeaponList[StuffObj.Uuid] = StuffObj
                end
            end

            --- 用空Item补全ListView, 加定时器是因为隔一帧才能拿到已生成的Entry
            self:AddTimer(0.01, function()
                local BagItemUIs = self.List_Item:GetDisplayedEntryWidgets()
                local BagItemCount = BagItemUIs:Length()
                local AllFillCount = UIUtils.GetTileViewContentMaxCount(self.List_Item)
                local EmptyCount = AllFillCount - BagItemCount 
                if (EmptyCount <= 0) then return end

                for i=1, EmptyCount do
                    local BagItemContent = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", GridIndex=BagItemCount+i, StuffCount=0, 
                                                                        IsSelected=false, StuffIcon=nil, ParentWidget=self})
                    self.List_Item:AddItem(BagItemContent)
                end
                self.List_Item:SetEmptyGridItemCount(EmptyCount)
                local VisibilityTag = EmptyCount > 0 and "Collapsed" or "Visible"
                -- self.List_Item:RegenerateAllEntries()
                self.List_Item:SetScrollbarVisibility(UIConst.VisibilityOp[VisibilityTag])
            end) 
        end
    end
    self:JumpToSelectItem(NeedDelayJump)
end

function M:JumpToSelectItem(NeedDelay)
    if (NeedDelay) then
        self:AddDelayFrameFunc(function ()
                self:RealToJumpToSelectItem()
        end, 2, "RealToJumpToSelectItem")
    else
        self:RealToJumpToSelectItem()
    end
end

function M:RealToJumpToSelectItem()
    local AllItemCount = self.List_Item:GetNumItems()
    if (self.BagCurState == BagCommon.AllBagState.NormalState and AllItemCount > 0 and self.NeedSelectGridIndex >= 0) then
        self.CurSelectGridIndex = self.NeedSelectGridIndex + 1
        self.CurSelectStuffContent = self.List_Item:GetItemAt(self.NeedSelectGridIndex)
        if (IsValid(self.CurSelectStuffContent) and not self.CurSelectStuffContent.IsSelect) then
            if (self.CurSelectStuffContent.SelfWidget) then
                self.CurSelectStuffContent.SelfWidget:SetSelected(true)
            else
                self.CurSelectStuffContent.IsSelect = true
            end
        end
        -- 如果是空格不需要跳转选中以及显示详情
        if (self.CurSelectStuffContent.StuffType ~= "EmptyGrid") then
            self.List_Item:SetSelectedIndex(self.NeedSelectGridIndex)
            if (self.ListJumpOffset ~= nil) then
                self.List_Item:SetScrollOffset(self.ListJumpOffset)
                self.ListJumpOffset = nil
            else
                self.List_Item:ScrollIndexIntoView(self.NeedSelectGridIndex)
            end
            self:RefreshDetail(self.CurSelectGridIndex, self.CurSelectStuffContent.Uuid)
        else
            self:RefreshDetail(-1, nil)
        end
    else
        -- 如果右侧详情没有打开，则需要滚动到最上方
        if (not self.Panel_Detail:IsVisible()) then
            self.CurSelectGridIndex = -1
            self.CurSelectStuffContent = nil
            self.List_Item:ScrollIndexIntoView(0)
        end
        self:RefreshDetail(-1, nil)
    end
    self:AfterFillDataInfo()
end
--endregion

--#region BagSale&&BagResolve 背包出售以及分解相关
function M:CheckIsCanAddToSaleList(CurStuffContent, bIsShowToast, IsFromAutoSelect)
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        return false
    end
    if (CurStuffContent == nil) then
        CurStuffContent = self.CurSelectStuffContent
    end
    local ShowTextId = nil
    if (CurStuffContent ~= nil) then
        if (CurStuffContent.Price == -1) then
            ShowTextId = 7014
        elseif (CurStuffContent.LockType ~= 0) then
            -- 锁定内容无法出售
            ShowTextId = 7010
        elseif (self:GetIsStuffIsEquiped(CurStuffContent)) then
            -- 非Mod的在装备过程之中不能加入出售队列，Mod是否能加入取决于是否勾选了右下方设置选项
            if (CurStuffContent.StuffType == BagCommon.StuffType.Mod) then
                if (self.CheckBox_Ignore:IsChecked() and IsFromAutoSelect) then
                    ShowTextId = 7012
                end
            else
                ShowTextId = 7012
            end
        end
    end
    if (ShowTextId and bIsShowToast) then
        UIManager(self):ShowError(ShowTextId, nil, UIConst.Tip_CommonToast)
    end
    return ShowTextId == nil
end

function M:CheckIsCanAddToResolveList(CurStuffContent, bIsShowToast)
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        return false
    end
    if (CurStuffContent == nil) then
        CurStuffContent = self.CurSelectStuffContent
    end
    local ShowTextId = nil
    if (CurStuffContent ~= nil) then
        if (CurStuffContent.LockType ~= 0) then
            -- 锁定内容无法出售
            ShowTextId = 7010
        elseif (self:GetIsStuffIsEquiped(CurStuffContent)) then
            -- 在装备过程之中不能加入分解队列
            ShowTextId = 7012
        end
    end
    if (ShowTextId and bIsShowToast) then
        UIManager(self):ShowError(ShowTextId, nil, UIConst.Tip_CommonToast)
    end
    return ShowTextId == nil
end

function M:GetStuffSaleCondition()
    if (self.CurTabId ~= BagCommon.ItemTypeToTabId.Mod) then
        return false, false
    else
        -- 保留一个和忽略已装备的选项只在Mod出售时显示
        return self.CheckBox_Retain:IsChecked(), self.CheckBox_Ignore:IsChecked()
    end
end

function M:RefreshSaleItemSelect(StuffUuid, GridIndex, AddNum)
    if (self.BagCurState == BagCommon.AllBagState.ChooseSaleState) then
        local StuffServerData = self:GetStuffServerData(self.CurSelectStuffContent.Uuid, self.CurSelectStuffContent.StuffType, self.CurSelectStuffContent.FishInfo)
        if (not self:CheckIsCanAddToSaleList(nil, true)) then
            -- 不满足加入待出售队列的条件
            return
        end
        -- if (self.CurSelectStuffContent.StuffType == BagCommon.StuffType.Mod and StuffServerData.IsOriginal == true) then
        --     -- 原始Mod不能加入待出售队列
        --     return
        -- end
        local SaleObj = self.DesireSaleStuffObjList[StuffUuid]
        if SaleObj then
            if AddNum > 0 then  --self.CurTabId == BagCommon.ItemTypeToTabId.Resource or self.CurSelectStuffContent.StuffType == BagCommon.StuffType.Mod and 
                local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
                if SellPageMainUI then
                    local StateTagInfo = SaleObj.StateTagInfo
                    local ExtraData = StateTagInfo and StateTagInfo.ExtraData

                    if type(ExtraData) == "table" and ExtraData[1] and ExtraData[2] then
                        local CurCount, MaxCount = ExtraData[1], ExtraData[2]
                        local NewCount = CurCount + AddNum
                        local FinalCount = math.min(NewCount, MaxCount)
                        if FinalCount >= CurCount then
                            local DeltaNum = FinalCount - CurCount
                            ExtraData[1] = FinalCount
                            SellPageMainUI:UpdateItemNumFromList(SaleObj, DeltaNum)
                        end
                    end
                end
            else
                DebugPrint("Stuff is in Sale list, removing...")
                EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffUuid)
            end
            return
        end
        local StuffData = {}
        if (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
            -- Mod相关
            StuffData = StuffIconObject:GetModStuffData(StuffServerData, nil, "ClickChooseStuff")
        elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Draft) then
            -- 图纸相关
            StuffData = StuffIconObject:GetDraftsStuffData(StuffServerData, nil, "ClickChooseStuff")
        else
            -- 道具相关
            StuffData = StuffIconObject:GetItemStuffData(StuffServerData, nil, "ClickChooseStuff")
        end
        local function RemoveStuffCallback()
            EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffUuid)
        end
        local StuffStateTagInfo = { Name = "IsToChoose", ExtraData = { 1, StuffData.StuffCount, StuffData.Price, StuffData.CoinId, RemoveStuffCallback } }
        self.CurSelectStuffContent.StateTagInfo = StuffStateTagInfo
        if (self.CurSelectStuffContent.SelfWidget) then
            self.CurSelectStuffContent.SelfWidget:SetStuffStyleByStateTag(self.CurSelectStuffContent)
        end
        self.DesireSaleStuffObjList[StuffUuid] = self.CurSelectStuffContent
        EventManager:FireEvent(EventID.OnAddBagItemToList, StuffData)
    end
end

function M:RefreshResolveWeaponSelect(StuffUuid, GridIndex)
    if (self.BagCurState == BagCommon.AllBagState.WeaponResolveState) then
        if (not self:CheckIsCanAddToResolveList(nil, true)) then
            -- 不满足加入待分解队列的条件
            return
        end

        if (self.DesireResolveWeaponList[StuffUuid] ~= nil) then
            -- DebugPrint("Stuff is in Resolve list, So Now It is to remove it~")
            -- EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffUuid)
            return
        end
        local function RemoveWeaponCallback()
            EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffUuid)
        end
        local StuffServerData = self:GetStuffServerData(self.CurSelectStuffContent.Uuid, self.CurSelectStuffContent.StuffType)
        local StuffData = StuffIconObject:GetWeaponStuffData(StuffServerData, nil, "ClickChooseStuff")
        local StuffStateTagInfo = {Name="IsToChoose",  ExtraData={1, StuffData.StuffCount, StuffData.Price, StuffData.CoinId, RemoveWeaponCallback}}
        self.CurSelectStuffContent.StateTagInfo = StuffStateTagInfo
        if (self.CurSelectStuffContent.SelfWidget) then
            self.CurSelectStuffContent.SelfWidget:SetStuffStyleByStateTag(self.CurSelectStuffContent)
        end
        self.DesireResolveWeaponList[StuffUuid] = self.CurSelectStuffContent
        EventManager:FireEvent(EventID.OnAddBagItemToList, StuffData)
    end
end

function M:RemoveItemSaleState(StuffId)
    local StuffContent = self.DesireSaleStuffObjList[StuffId]
    if (not IsValid(StuffContent)) then
        return
    end
    local StuffStateTagInfo = {Name="Normal",  ExtraData={StuffContent.Count, StuffContent.Price, StuffContent.CoinId}}
    StuffContent.StateTagInfo = StuffStateTagInfo
    StuffContent.IsSelect = false
    if (StuffContent.SelfWidget and StuffContent.Uuid == StuffId) then
        StuffContent.SelfWidget:SetSelected(false)
        StuffContent.SelfWidget:SetStuffStyleByStateTag(StuffContent)
    end
    local IsNeedCancelSelect = false
    if (StuffContent.StuffType == BagCommon.StuffType.Mod) then
        local IsCurInModTab = self.CurTabId == BagCommon.ItemTypeToTabId.Mod
        IsNeedCancelSelect = (IsCurInModTab and self.CurSelectStuffContent ~= nil and StuffContent.Uuid == self.CurSelectStuffContent.Uuid)
    elseif (StuffContent.StuffType == BagCommon.StuffType.Draft) then
        IsNeedCancelSelect = (self.CurTabId == BagCommon.ItemTypeToTabId.Draft and self.CurSelectStuffContent ~= nil and StuffContent.Uuid == self.CurSelectStuffContent.Uuid)
    elseif (StuffContent.StuffType == BagCommon.StuffType.Resource) then
        local StuffConfigData = DataMgr.Resource[StuffContent.UnitId]
        IsNeedCancelSelect = (self.CurTabId == StuffConfigData.MaterialClassify and self.CurSelectStuffContent ~= nil and StuffContent.Uuid == self.CurSelectStuffContent.Uuid)
    end
    self.DesireSaleStuffObjList[StuffId] = nil
    if (IsNeedCancelSelect) then
        self.List_Item:BP_ClearSelection()
    end
end

function M:RemoveWeaponResolveState(StuffUuid)
    local StuffContent = self.DesireResolveWeaponList[StuffUuid]
    if (not IsValid(StuffContent)) then
        return
    end
    local StuffStateTagInfo = {Name="Normal",  ExtraData={StuffContent.Count, StuffContent.Price, StuffContent.CoinId}}
    StuffContent.StateTagInfo = StuffStateTagInfo
    StuffContent.IsSelect = false
    if (StuffContent.SelfWidget and StuffContent.Uuid == StuffUuid) then
        StuffContent.SelfWidget:SetSelected(false)
        StuffContent.SelfWidget:SetStuffStyleByStateTag(StuffContent)
    end
    local IsCurInWeaponTab = (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon)
    local IsNeedCancelSelect = (IsCurInWeaponTab and self.CurSelectStuffContent ~= nil and StuffContent.Uuid == self.CurSelectStuffContent.Uuid)
    self.DesireResolveWeaponList[StuffUuid] = nil
    if (IsNeedCancelSelect) then
        self.List_Item:BP_ClearSelection()
    end
end

function M:TryToAddItemToTargetListWithRarity(StuffContent)
    local StuffType = StuffContent.ItemType
    local StuffUuid = StuffContent.Uuid
    local StuffServerData = self:GetStuffServerData(StuffContent.Uuid, StuffType, StuffContent.FishInfo)
    local StuffData = nil

    local function RemoveStuffCallback()
        EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffUuid)
    end
    if (StuffType == BagCommon.StuffType.Weapon) then
        if (self:CheckIsCanAddToResolveList(StuffContent, false)) then
            if (self.DesireResolveWeaponList[StuffUuid] == nil) then
                -- 没有添加进分解列表
                StuffData = StuffIconObject:GetWeaponStuffData(StuffServerData, nil, "ClickChooseStuff")
                local StuffStateTagInfo = {Name="IsToChoose",  ExtraData={1, StuffData.StuffCount, StuffData.Price, StuffData.CoinId, RemoveStuffCallback}}
                StuffContent.StateTagInfo = StuffStateTagInfo
                if (StuffContent.SelfWidget) then
                    StuffContent.SelfWidget:SetStuffStyleByStateTag(StuffContent)
                end
                self.DesireResolveWeaponList[StuffUuid] = StuffContent
                -- EventManager:FireEvent(EventID.OnAddBagItemToList, StuffData)
            end
        end
    else
        if (self:CheckIsCanAddToSaleList(StuffContent, false, true)) then
            if (self.DesireSaleStuffObjList[StuffUuid] == nil) then
                local NowAddToSaleListCount = 0
                if (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
                    -- Mod相关
                    StuffData = StuffIconObject:GetModStuffData(StuffServerData, nil, "ClickChooseStuff")
                    if (self.CheckBox_Retain:IsChecked()) then
                        NowAddToSaleListCount = StuffData.StuffCount - 1
                    else
                        NowAddToSaleListCount = StuffData.StuffCount
                    end
                elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Draft) then
                    -- 图纸相关
                    StuffData = StuffIconObject:GetDraftsStuffData(StuffServerData, nil, "ClickChooseStuff")
                    NowAddToSaleListCount = StuffData.StuffCount
                else
                    -- 道具相关
                    StuffData = StuffIconObject:GetItemStuffData(StuffServerData, nil, "ClickChooseStuff")
                    NowAddToSaleListCount = StuffData.StuffCount
                end
                if (NowAddToSaleListCount > 0) then
                    -- 添加当前道具所有数量
                    local StuffStateTagInfo = { Name = "IsToChoose", ExtraData = { NowAddToSaleListCount, StuffData.StuffCount, StuffData.Price, StuffData.CoinId, RemoveStuffCallback } }
                    StuffContent.StateTagInfo = StuffStateTagInfo
                    if (StuffContent.SelfWidget) then
                        StuffContent.SelfWidget:SetStuffStyleByStateTag(StuffContent)
                    end
                    self.DesireSaleStuffObjList[StuffUuid] = StuffContent
                    -- EventManager:FireEvent(EventID.OnAddBagItemToList, StuffData)
                end
            end
        end
    end
    return StuffData
end

function M:TryToRemoveItemToTargetListWithRarity(StuffContent)
    local StuffType = StuffContent.StuffType
    local StuffUuid = StuffContent.Uuid
    local bIsNeedRemove = false
    if (StuffType == BagCommon.StuffType.Weapon) then
        if (self.DesireResolveWeaponList[StuffUuid]) then
            local StuffStateTagInfo = {Name="Normal",  ExtraData={StuffContent.Count, StuffContent.Price, StuffContent.CoinId}}
            StuffContent.StateTagInfo = StuffStateTagInfo
            StuffContent.IsSelect = false
            if (StuffContent.SelfWidget) then
                StuffContent.SelfWidget:SetSelected(false)
                StuffContent.SelfWidget:SetStuffStyleByStateTag(StuffContent)
            end
            local IsCurInWeaponTab = (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon)
            local IsNeedCancelSelect = (IsCurInWeaponTab and self.CurSelectStuffContent ~= nil and StuffContent.Uuid == self.CurSelectStuffContent.Uuid)
            self.DesireResolveWeaponList[StuffUuid] = nil
            if (IsNeedCancelSelect) then
                self.List_Item:BP_ClearSelection()
            end
            bIsNeedRemove = true
            -- EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffContent.Uuid)
        end
    else
        if (self.DesireSaleStuffObjList[StuffUuid]) then
            local StuffStateTagInfo = {Name="Normal",  ExtraData={StuffContent.Count, StuffContent.Price, StuffContent.CoinId}}
            StuffContent.StateTagInfo = StuffStateTagInfo
            StuffContent.IsSelect = false
            if (StuffContent.SelfWidget) then
                StuffContent.SelfWidget:SetSelected(false)
                StuffContent.SelfWidget:SetStuffStyleByStateTag(StuffContent)
            end
            local IsNeedCancelSelect = false
            if (StuffContent.StuffType == BagCommon.StuffType.Mod) then
                local IsCurInModTab = self.CurTabId == BagCommon.ItemTypeToTabId.Mod
                IsNeedCancelSelect = (IsCurInModTab and self.CurSelectStuffContent ~= nil and StuffContent.Uuid == self.CurSelectStuffContent.Uuid)
            elseif (StuffContent.StuffType == BagCommon.StuffType.Resource) then
                local StuffConfigData = DataMgr.Resource[StuffContent.UnitId]
                IsNeedCancelSelect = (self.CurTabId == StuffConfigData.MaterialClassify and self.CurSelectStuffContent ~= nil and StuffContent.Uuid == self.CurSelectStuffContent.Uuid)
            end
            self.DesireSaleStuffObjList[StuffUuid] = nil
            if (IsNeedCancelSelect) then
                self.List_Item:BP_ClearSelection()
            end
            bIsNeedRemove = true
            -- EventManager:FireEvent(EventID.OnRemoveBagItemInList, StuffContent.Uuid)
        end
    end
    return bIsNeedRemove
end

--#endregion

--#region 通用接口
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    local IsUseGamePad = CurInputType == ECommonInputType.Gamepad and self:IsCanChangeToGamePadViewMode()
    -- 一些公共组件切换显示模式
    self.Panel_Detail:UpdateUIStyleInPlatform(IsUseGamePad)
    self:UpdateUIStyleInPlatform(IsUseGamePad)
    if IsUseGamePad and self.BagCurState == BagCommon.AllBagState.ChooseSaleState then
        self:RefreshBottomKeyInfo("ChooseSaleState")
    end
end

function M:IsCanChangeToGamePadViewMode()
    -- 判断是否可以切换到手柄端
    if (self.CurFocusWidget == "DefaultWidget") then
        return true
    else
        local PlayerController = self:GetOwningPlayer()
        if (self.BagCurState == BagCommon.AllBagState.NormalState) then
            if (self.Filter:HasUserFocus(PlayerController)) then
                return false
            elseif (self.Sift:HasUserFocus(PlayerController)) then
                return false
            end
        else
            if (self.Yellow:HasUserFocus(PlayerController)) then
                return false
            elseif (self.Purple:HasUserFocus(PlayerController)) then
                return false
            elseif (self.Blue:HasUserFocus(PlayerController)) then
                return false
            elseif (self.Green:HasUserFocus(PlayerController)) then
                return false
            elseif (self.Grey:HasUserFocus(PlayerController)) then
                return false
            end
        end
        if (self.Panel_Detail:IsVisible() and self.Panel_Detail:IsInGamePadViewAccessKey()) then
            return false
        end
        return true
    end
end

function M:GetIsStuffIsEquiped(SelectStuffContent)
    local PlayerAvatar = GWorld:GetAvatar()
    SelectStuffContent = SelectStuffContent or self.CurSelectStuffContent
    local IsEquiped = false
    if (SelectStuffContent.StuffType == BagCommon.StuffType.Weapon) then
        -- 武器相关
        local WeaponUuid = self:GetStuffObjId(SelectStuffContent.Uuid)
        if (WeaponUuid == PlayerAvatar.MeleeWeapon or WeaponUuid == PlayerAvatar.RangedWeapon) then
            IsEquiped = true
        end
    elseif (SelectStuffContent.StuffType == BagCommon.StuffType.Mod) then
        -- Mod相关
        local StuffServerData = self:GetStuffServerData(SelectStuffContent.Uuid, BagCommon.StuffType.Mod)
        if (StuffServerData ~= nil and StuffServerData.Count > 0 and (StuffServerData.WeaponUuids:Length() > 0 or StuffServerData.CharUuids:Length() > 0)) then
            IsEquiped = true
        end
    end
    return IsEquiped
end

function M:BindEventOnSelectionsChanged(Filter1, Filter2, Filter3, SortType)
    self:RefreshStuffListItem(true)
end

function M:BindEventOnSortTypeChanged(SortType)
    self:RefreshStuffListItem(false)
end

function M:RefreshStuffListItem(IsFilterSelectionsChanged)
    self.IsFilterSelectionsChanged = IsFilterSelectionsChanged
    self:ReGenerateBagList()
end

function M:ReGenerateBagList()
    self:CancelStuffClickAndHideDetail()
    -- if (CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
    --     self.OverLay_List:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    -- else
    --     self.ListCanvas:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    -- end
    self.List_Item:BP_ClearSelection()
    self.List_Item:ClearListItems()
    if (self.LoadMode == "FrameBlocking") then
        self:RemoveCoroutineTask(self.FillPlayerDataByTypeInFrame)
        self.IsLoadCompleted = false
        self:AddCoroutineTask(self.FillPlayerDataByTypeInFrame, self, self.CurTabId)
    else
        self:FillPlayerDataByType(self.CurTabId)
    end
end

function M:OnSelectStuffItemChanged(SelectItem, bIsSelect)
    -- 手柄模式下自动打开详情面版
    if (not SelectItem) then
        return
    end
    if (self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad) then
        if (self.BagCurState == BagCommon.AllBagState.NormalState) then
            -- 手柄普通模式下Hover到道具上面直接选中
            self:OnListSelectStuffClicked(SelectItem)
            if SelectItem.GridIndex ~= 1 then -- 第一个道具容易被默认选中，消不掉select状态
                local FirstFocusSelectStuffContent = self.List_Item:GetItemAt(0)
                if FirstFocusSelectStuffContent.IsSelect and FirstFocusSelectStuffContent.SelfWidget then
                    FirstFocusSelectStuffContent.SelfWidget:SetSelected(false)
                end
            end
        elseif (self.BagCurState == BagCommon.AllBagState.ChooseSaleState or self.BagCurState == BagCommon.AllBagState.WeaponResolveState) then
            -- 手柄选择出售/分解模式下Hover到道具上面刷新内容
            local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
            if (SellPageMainUI ~= nil) then
                SellPageMainUI:TryToHoverToItemOnNavigation(SelectItem)
            end

            if self.BagCurState == BagCommon.AllBagState.ChooseSaleState or BagCommon.AllBagState.WeaponResolveState then
                --DebugPrint("SelectItem.AddNum  ",SelectItem.AddNum)
                -- DebugPrint("SelectItem.ExtraData  ",SelectItem.StateTagInfo.ExtraData[1])
                if  SelectItem.bMinus then
                    self.HoverItem = SelectItem  --记录下当前的可被取消选中的 Hoveritem 方便清除
                    self:RefreshBottomKeyInfo("ChooseSaleState")
                else
                    self:RefreshBottomKeyInfo("NoRemoveSelect")
                end
            end
        end
    end
end

function M:GetStuffObjId(StuffUuid)
    local FinalObjId = StuffUuid
    if (type(FinalObjId) =="string" and CommonUtils.IsObjIdStr(FinalObjId)) then
        FinalObjId = CommonUtils.Str2ObjId(FinalObjId)
    end
    return FinalObjId
end

-- 跳转回来之后的更新逻辑
function M:UpdatePageInfoFromStackAction()
    -- 跳转回来的时候重新设置一下列表内容，避免数据不更新
    if (IsValid(self.CurSelectStuffContent)) then
        if (self.CurSelectStuffContent.SelfWidget) then
            self.CurSelectStuffContent.SelfWidget:SetSelected(false)
        else
            self.CurSelectStuffContent.IsSelect = false
        end
        self.NeedSelectStuffId = self.CurSelectStuffContent.Uuid
    end
    self:FillWithListViewData(self.CurTabId, true)
    self:RefreshBottomKeyInfo()
    self:UpdateUIStyleInPlatform(self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad)
end

-- 设置聚焦点并且刷新快捷键提示
function M:SetFocus_Lua()
    if (UIManager(self):IsHaveMenuAnchorOpen()) then
        -- 上面有菜单锚界面，直接返回
        return
    end
    local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
    if (CommonDialog ~= nil) then
        -- 上面有弹窗，直接返回
        return
    end
    local ComSortFullScreen = UIManager(self):GetUIObj("ComSortFullScreen")
    if (ComSortFullScreen ~= nil) then
        -- 上面有排序框，直接返回
        return
    end
    local ComGetItemPage = UIManager(self):GetUIObj("GetItemPage")
    if (ComGetItemPage ~= nil) then
        -- 上面有获得物品界面，直接返回
        return
    end
    --if self:HasFocusedDescendants() or self:HasAnyUserFocus() then return end
    self:RefreshBottomKeyInfo()
    local AllItemCount = self.List_Item:GetNumItems()
    if (AllItemCount > 0) then
        self.List_Item:SetFocus()
    else
        self:SetFocus()
    end
end

-- 获取聚焦点目标
function M:BP_GetDesiredFocusTarget()
    local DesiredFocusTarget = nil
    -- 出售界面是否存在
    if (DesiredFocusTarget == nil) then
        local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
        if (SellPageMainUI ~= nil) then
            DesiredFocusTarget = SellPageMainUI:GetGetDesiredFocusTarget_Lua()
        end
    end

    if (DesiredFocusTarget == nil) then
        local AllItemCount = self.List_Item:GetNumItems()
        if (AllItemCount > 0) then
            DesiredFocusTarget = self.List_Item
        else
            DesiredFocusTarget = self
        end
    end
    return DesiredFocusTarget
end 

function M:RefreshButtonInfoInDiffTab()
    -- 先检测是否需要显示按钮
    local BagTabData, bIsShowSellBtn = DataMgr.BagTab[self.CurTabId], false
    if (BagTabData and BagTabData.HideSell) then
        bIsShowSellBtn = true
    end
    if (bIsShowSellBtn) then
        self.Button_Sell:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
            self.Button_Sell:SetText(GText("UI_Bag_Decompose"))
        elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
            self.Button_Sell:SetText(GText("UI_Bag_ModExtract"))
        else
            self.Button_Sell:SetText(GText("UI_BAG_Sell"))
        end
        self.Button_Sell:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end
--#endregion

--region 各种点击回调
function M:OnRetainOneCheckStateChanged(IsChecked)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    local NeedUpdateList, NeedRemoveList = nil, nil
    if (IsChecked) then
        -- 勾选了保留一个
        for key, StuffContent in pairs(self.DesireSaleStuffObjList) do
            local StuffStateTagInfo = StuffContent.StateTagInfo
            if (StuffStateTagInfo.ExtraData) then
                if (StuffStateTagInfo.ExtraData[2] == 1) then
                    -- 总共只有一个数量，则直接移除
                    self:RemoveItemSaleState(key)
                    if (NeedRemoveList ~= nil) then
                        table.insert(NeedRemoveList, key)
                    else
                        NeedRemoveList = {key}
                    end
                elseif (StuffStateTagInfo.ExtraData[1] > 1) then
                    StuffStateTagInfo.ExtraData[1] = StuffStateTagInfo.ExtraData[1] - 1
                    if (StuffContent.SelfWidget) then
                        StuffContent.SelfWidget:SetStuffStyleByStateTag(StuffContent)
                    end
                    if (NeedUpdateList ~= nil) then
                        table.insert(NeedUpdateList, StuffContent)
                    else
                        NeedUpdateList = {StuffContent}
                    end
                end
            end
        end
    else
        -- 策划说取消选中目前不用处理
    end
    local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
    if (NeedUpdateList and SellPageMainUI) then
        SellPageMainUI:UpdateItemInfoFromList(NeedUpdateList)
    end
    if (NeedRemoveList and SellPageMainUI) then
        SellPageMainUI:MultiRemoveBagItemInList(NeedRemoveList)
    end
end

function M:OnIgnoreEquipedCheckStateChanged(IsChecked)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    local NeedRemoveList = nil
    if (IsChecked) then
        -- 勾选了忽略已装备
        for key, StuffContent in pairs(self.DesireSaleStuffObjList) do
            if (self:GetIsStuffIsEquiped(StuffContent)) then
                self:RemoveItemSaleState(key)
                if (NeedRemoveList ~= nil) then
                    table.insert(NeedRemoveList, key)
                else
                    NeedRemoveList = {key}
                end
            end
        end
    else
        -- 策划说取消选中目前不用处理
    end
    local SellPageMainUI = UIManager(self):GetUI(BagCommon.BagStuffSelectUIName)
    if (NeedRemoveList and SellPageMainUI) then
        SellPageMainUI:MultiRemoveBagItemInList(NeedRemoveList)
    end
end

function M:OnClickGoToAmory()
    self.IsNeedPlayNpcAnim = false
    self.GoToArmoryWhenClose = true
    self:Close()
end

function M:ReClickGoToUseConsume()
    -- 某些情况下自动重新打开道具自选
    if (not self.CurSelectStuffContent) then
        return
    end
    local StuffUuid = self.CurSelectStuffContent.Uuid 
    local StuffType = self.CurSelectStuffContent.StuffType
    local StuffServerData = self:GetStuffServerData(StuffUuid, StuffType)

    self:AddTimer(0.15, function()
        if (StuffServerData) then
            local StuffConfigData = StuffServerData:Data()
            self:OnClickGoToUseConsume(StuffConfigData)
        end
    end)
    -- if (StuffServerData) then
    --     local StuffConfigData = StuffServerData:Data()
    --     self:OnClickGoToUseConsume(StuffConfigData)
    -- end

    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self:AddTimer(0.01, function()
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    end)
end

function M:OnClickGoToUseConsume(StuffConfigData)
    self.CurrentChooseInfo = nil
    local CommonDialogParams = {}
    CommonDialogParams.OptionalItemsList = {}
    local UseEffectType, ExtraString, OptCount = StuffConfigData.UseEffectType, "", nil
    if (UseEffectType) then
        local ResultData = {}
        if (type(self["GenerateDataWith_" .. UseEffectType]) == "function") then
            ResultData, ExtraString, OptCount = self["GenerateDataWith_" .. UseEffectType](self, StuffConfigData.ResourceId, StuffConfigData.UseParam)
        end
        CommonDialogParams.OptionalItemsList = ResultData
    end

    -- 通用外观选择
    DebugPrint("ayff test use resourceID:"..StuffConfigData.ResourceId)
    local CharSkinPreviewTypeList = {
        [CommonConst.ResUseEffectType.SelectGeneralSkin] = "SelectGeneralSkin",
        [CommonConst.ResUseEffectType.SelectCharAccessory] = "SelectCharAccessory",
        [CommonConst.ResUseEffectType.SelectWeaponSkin] = "SelectWeaponSkin",
        [CommonConst.ResUseEffectType.SelectWeaponAccessory] = "SelectWeaponAccessory",
        [CommonConst.ResUseEffectType.SelectSkin] = "SelectSkin",
        [CommonConst.ResUseEffectType.SelectGestureItem] = "SelectGestureItem",
    }
    if CharSkinPreviewTypeList[UseEffectType] then
        UIManager(self):LoadUINew("CharSkinPreview", {Type = UseEffectType, OptRewardId = StuffConfigData.UseParam, ResourceId = StuffConfigData.ResourceId})
        return
    end

    -- CommonDialogParams.DontFocusParentWidget = true
    -- CommonDialogParams.LeftCallbackFunction = function() self:SetFocus_Lua() end
    CommonDialogParams.Title = GText(StuffConfigData.ResourceName)
    -- CommonDialogParams.Tips = {string.format(GText("UI_Consumable_Choose"), ExtraString)}
    if UseEffectType == "ResourcePack" then
        CommonDialogParams.Tips = {string.format(ExtraString,"材料包",1,1,1)}
    elseif UseEffectType == "SelectResource" then
        CommonDialogParams.Tips = {string.format(ExtraString,GText(StuffConfigData.ResourceName),0,OptCount,2)}
    else
        CommonDialogParams.Tips = {string.format(GText("UI_Consumable_Choose"), ExtraString)}
    end
    CommonDialogParams.AutoFocus = true
    CommonDialogParams.DontCloseWhenRightBtnClicked = true
    CommonDialogParams.FunctionCallbackObj = self
    CommonDialogParams.ChooseCallbackFunction = self.TryToChooseConsumableItems
    CommonDialogParams.RightGamepadImg = EKeys.A.KeyName
    CommonDialogParams.RightGamepadKey = Const.GamepadFaceButtonBottom
    CommonDialogParams.ParentWidget = self
    CommonDialogParams.HideItemTips = true
    CommonDialogParams.ResourceId = StuffConfigData.ResourceId
    CommonDialogParams.UseParam = StuffConfigData.UseParam
    CommonDialogParams.RightCallbackFunction = function(_, FirstData, FirstPopUIWidget) 
        local ConfirmParams, TargetStuffName, PopConfirmUIId = {}, "", 100210
        if (UseEffectType == "SelectWeapon") then
            if (self.CurrentChooseInfo) then
                TargetStuffName = self.CurrentChooseInfo.ChooseName
            end
            ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
        elseif (UseEffectType == "SelectCharacter") then
            local GradeLevel = 0 
            if (self.CurrentChooseInfo) then
                TargetStuffName = self.CurrentChooseInfo.ChooseName
                GradeLevel = CommonDialogParams.OptionalItemsList[self.CurrentChooseInfo.ChooseIndex].GradeLevel or 0
            end
            local MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
            if (GradeLevel >= MaxGradeLevel) then
                -- ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm").."\n".."duojiayihang", TargetStuffName)
                ConfirmParams.ShortText = string.format(GText("UI_Consumable_CardLevel_Max"), TargetStuffName)
            else
                ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
            end
        elseif (UseEffectType == "SelectPet") then
            if (self.CurrentChooseInfo) then
                TargetStuffName = self.CurrentChooseInfo.ChooseName
            end
            ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
        elseif (UseEffectType == "SelectResource") then
            -- select resource 不需要二次确认
        elseif (UseEffectType == "ResourcePack") then
            self.ConsumeCount = self.CurrentChooseInfo.ConsumeCount or 1
        elseif (UseEffectType == "RandomSelectPack") then
            -- select resource 不需要二次确认
        end

        if (UseEffectType == "ResourcePack") then
            FirstPopUIWidget.DontFocusParentWidget = true
            FirstPopUIWidget:RemoveFirstItemInPopupQueue()
            FirstPopUIWidget:OnCloseBtnClicked()
            self:ConfirmDealWithConsumablePacks(UseEffectType)
        elseif (UseEffectType == "SelectResource") then
            FirstPopUIWidget.DontFocusParentWidget = true
            FirstPopUIWidget:RemoveFirstItemInPopupQueue()
            FirstPopUIWidget:OnCloseBtnClicked()
            self:ConfirmDealWithConsumableResource(UseEffectType)
        elseif (UseEffectType == "RandomSelectPack") then
            FirstPopUIWidget.DontFocusParentWidget = true
            FirstPopUIWidget:RemoveFirstItemInPopupQueue()
            FirstPopUIWidget:OnCloseBtnClicked()
            self:ConfirmDealWithConsumableRandomBox(UseEffectType)
        elseif (ConfirmParams.ShortText) then
            FirstPopUIWidget.DontFocusParentWidget = true
            ConfirmParams.AutoFocus = true
            ConfirmParams.RightCallbackFunction = function(_, Data, PopUIWidget)
                PopUIWidget:RemoveFirstItemInPopupQueue()
                self:ConfirmDealWithConsumableItems(UseEffectType, StuffConfigData.UseParam)
            end
            ConfirmParams.DontFocusParentWidget = true
            UIManager(self):ShowCommonPopupUI_Interrupt(PopConfirmUIId, ConfirmParams, self)
        else
            FirstPopUIWidget.DontFocusParentWidget = false
            self:ConfirmDealWithConsumableItems(UseEffectType, StuffConfigData.UseParam) 
        end
    end
    if (UseEffectType == "ResourcePack") then
        UIManager(self):ShowCommonPopupUI(100207, CommonDialogParams, self)
    elseif (UseEffectType == "SelectResource") then
        UIManager(self):ShowCommonPopupUI(100208, CommonDialogParams, self)
    elseif (UseEffectType == "RandomSelectPack") then
        UIManager(self):ShowCommonPopupUI(100343, CommonDialogParams, self)   
    else
        UIManager(self):ShowCommonPopupUI(100209, CommonDialogParams, self)
    end
end

function M:TryToChooseConsumableItems(CurrentChooseInfo)
    self.CurrentChooseInfo = CurrentChooseInfo
end

function M:ConfirmDealWithConsumableItems(UseEffectType, UseParam)
    -- 发送RPC选择对应武器or角色or魔灵
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
        return
    end
    if (self.CurrentChooseInfo == nil) then
        DebugPrint("ConfirmDealWithConsumableItems error, CurrentChooseInfo is nil")
        return
    end
    DebugPrint("Now ConfirmDealWithConsumableItems The ChooseId is ", self.CurrentChooseInfo.ChooseId)
    local ResourceId, OptionalId, OptIdxList, bIsNew= nil, nil, nil, true
    ResourceId, OptionalId = self.CurrentChooseInfo.ResourceId, self.CurrentChooseInfo.OptionalId

    -- RPC获取奖励中，根据CurrentChooseInfo.ChooseIndex匹配参数列表中的奖励
    -- 此处奖励排序已重置，需要重新设置ChooseIndex
    local OptIndex = 1
    for Index, Id in pairs(DataMgr.OptReward[UseParam].Id) do
        if Id == self.CurrentChooseInfo.ChooseId then
            OptIndex = Index
            break
        end
    end
    OptIdxList = {OptIndex}

    if UseEffectType == "SelectCharacter" then
        bIsNew = not PlayerAvatar:CheckCharEnough({[self.CurrentChooseInfo.ChooseId] = 1})
    end
    local DealWithConsumableItemsCallback = function()
        local OptionalItemsDataConfig = DataMgr.OptReward[OptionalId]
        if (UseEffectType == "SelectWeapon") then
            -- 获取武器自选的回调
            local WeaponChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
            if (WeaponChooseId) then
                UIUtils.ShowGetItemPage(BagCommon.StuffType.Weapon, WeaponChooseId, 1)
            end
            -- 刷新一下List里面对应Item的数量信息
            local AllItemCount = self.List_Item:GetNumItems()
            for i = 0, AllItemCount - 1, 1 do
                local ItemObj = self.List_Item:GetItemAt(i)
                if (ItemObj and ItemObj.StuffId == ResourceId) then
                    local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                    if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and  (StuffServerData.Count <= 0))) then
                        self.List_Item:RemoveItem(ItemObj)  
                        local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                        self.List_Item:AddItem(EmptyStuffObj) 
                        self.List_Item:AddEmptyGridItemCount(1)
                        self.NeedSelectGridIndex = 0
                        self:JumpToSelectItem(false)
                        self:RefreshAllGridIndex()
                    else
                        ItemObj.Count = StuffServerData.Count
                        if (ItemObj.SelfWidget) then
                            ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                        end
                    end
                end
            end
            -- 刷新一下详情数量
            if (self.Panel_Detail:IsVisible()) then
                self.Panel_Detail:UpdateItemNumber()
            end
        elseif (UseEffectType == "SelectCharacter") then
            -- 获取角色自选的回调
            local CharChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
            if (CharChooseId) then
                UIUtils.ShowGetItemPage("Char", CharChooseId, 1, nil, nil, nil, nil, nil, nil, bIsNew)
            end

            -- 刷新一下List里面对应Item的数量信息
            local AllItemCount = self.List_Item:GetNumItems()
            for i = 0, AllItemCount - 1, 1 do
                local ItemObj = self.List_Item:GetItemAt(i)
                if (ItemObj and ItemObj.StuffId == ResourceId) then
                    local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                    if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and  (StuffServerData.Count <= 0))) then
                        self.List_Item:RemoveItem(ItemObj)  
                        local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                        self.List_Item:AddItem(EmptyStuffObj) 
                        self.List_Item:AddEmptyGridItemCount(1)
                        self.NeedSelectGridIndex = 0
                        self:JumpToSelectItem(false)
                        self:RefreshAllGridIndex()
                    else
                        ItemObj.Count = StuffServerData.Count
                        if (ItemObj.SelfWidget) then
                            ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                        end
                    end
                end
            end
            -- 刷新一下详情数量
            if (self.Panel_Detail:IsVisible()) then
                self.Panel_Detail:UpdateItemNumber()
            end
        elseif (UseEffectType == "SelectPet") then
            -- 获取魔灵自选的回调
            local PetChooseId = OptionalItemsDataConfig.Id[OptIdxList[1]]
            if (PetChooseId) then
                local GameInstance = GWorld.GameInstance
                local UIManager = GameInstance:GetGameUIManager()
                local SystemUIName = "GetItemPage"
                UIManager:LoadUINew(SystemUIName,BagCommon.OptionalItemType.Pet, PetChooseId, 1, nil, -1, -1)
            end

            -- 刷新一下List里面对应Item的数量信息
            local AllItemCount = self.List_Item:GetNumItems()
            for i = 0, AllItemCount - 1, 1 do
                local ItemObj = self.List_Item:GetItemAt(i)
                if (ItemObj and ItemObj.StuffId == ResourceId) then
                    local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                    if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and  (StuffServerData.Count <= 0))) then
                        self.List_Item:RemoveItem(ItemObj)  
                        local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                        self.List_Item:AddItem(EmptyStuffObj) 
                        self.List_Item:AddEmptyGridItemCount(1)
                        self.NeedSelectGridIndex = 0
                        self:JumpToSelectItem(false)
                        self:RefreshAllGridIndex()
                    else
                        ItemObj.Count = StuffServerData.Count
                        if (ItemObj.SelfWidget) then
                            ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                        end
                    end
                end
            end
            -- 刷新一下详情数量
            if (self.Panel_Detail:IsVisible()) then
                self.Panel_Detail:UpdateItemNumber()
            end
        end
    end
    PlayerAvatar:UseOptResourceInBag(ResourceId, OptIdxList, DealWithConsumableItemsCallback)
    self.CurrentChooseInfo = nil
end

function M:ConfirmDealWithConsumableResource(UseEffectType)
    -- 发送RPC选择自选材料
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
        return
    end
    if (self.CurrentChooseInfo == nil) then
        DebugPrint("ConfirmDealWithConsumableItems error, CurrentChooseInfo is nil")
        return
    end
    DebugPrint("Now ConfirmDealWithConsumableItems The ChooseId is ", self.CurrentChooseInfo.ChooseId)
    local ResourceId, OptionalId, OptIdxList, OptionalList, Count= nil, nil, nil, {}, 0
    if (type(self.CurrentChooseInfo) == "table" and UseEffectType == "SelectResource") then
        local k, v = next(self.CurrentChooseInfo)
        ResourceId, OptionalId = v.ResourceId, v.OptionalId
        OptIdxList = {}
        for k, v in pairs(self.CurrentChooseInfo) do
            for i = 1, v.ConsumeCount do
                table.insert(OptIdxList, v.ChooseIndex)
                Count = Count + 1
            end
            OptionalList[v.ChooseId] = v.ConsumeCount
        end
    else
        ResourceId, OptionalId = self.CurrentChooseInfo.ResourceId, self.CurrentChooseInfo.OptionalId
        if (type(self.CurrentChooseInfo.ChooseIndex) == "table") then
            OptIdxList = self.CurrentChooseInfo.ChooseIndex
        else
            OptIdxList = {self.CurrentChooseInfo.ChooseIndex}
        end 
    end

    -- 回调
    local DealWithConsumableItemsCallback = function()
        local OptionalItemsDataConfig = DataMgr.OptReward[OptionalId]
        local AllRewards = {Resources = {}}
        for k,v in pairs(OptionalItemsDataConfig.Id) do
            if OptionalList[v] and OptionalList[v] > 0 then
                AllRewards.Resources[v] = OptionalList[v] * OptionalItemsDataConfig.Count[k]
            end
        end
        UIManager(self):LoadUINew("GetItemPage",  nil, nil, nil, AllRewards, nil, self, true)

        -- 刷新一下List里面对应Item的数量信息
        local AllItemCount = self.List_Item:GetNumItems()
        for i = 0, AllItemCount - 1, 1 do
            local ItemObj = self.List_Item:GetItemAt(i)
            if (ItemObj and ItemObj.StuffId == ResourceId) then
                local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and  (StuffServerData.Count <= 0))) then
                    self.List_Item:RemoveItem(ItemObj)  
                    local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                    self.List_Item:AddItem(EmptyStuffObj) 
                    self.List_Item:AddEmptyGridItemCount(1)
                    self.NeedSelectGridIndex = 0
                    self:JumpToSelectItem(false)
                    self:RefreshAllGridIndex()
                else
                    ItemObj.Count = StuffServerData.Count
                    if (ItemObj.SelfWidget) then
                        ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                    end
                end
            end
        end
        -- 刷新一下详情数量
        if (self.Panel_Detail:IsVisible()) then
            self.Panel_Detail:UpdateItemNumber()
        end
    end
    PlayerAvatar:UseOptResourceInBag(ResourceId, OptIdxList, DealWithConsumableItemsCallback)
    self.CurrentChooseInfo = nil
end

function M:ConfirmDealWithConsumableRandomBox()
    -- 使用随机道具箱
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
        return
    end

    local ResourceId = self.CurrentChooseInfo.ResourceId
    local ConsumeCount = self.CurrentChooseInfo.ConsumeCount or 1
    local DealWithConsumableItemsCallback = function(RewardInfo)
        -- local AllRewards ={
        --     Resources = {},
        -- }
        -- for ReosurceId, ResourceInfo in pairs(RewardInfo.Resources) do
        --     AllRewards.Resources[ReosurceId] = ResourceInfo["1"]
        -- end
        --AllRewards.Resources[110018] = 2
        --UIManager(self):LoadUINew("GetItemPage",  nil, nil, nil, AllRewards, nil, self, true)

        --显示获取的道具
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardInfo, false, function()
        end, self, false)

        -- 刷新一下List里面对应Item的数量信息
        local AllItemCount = self.List_Item:GetNumItems()
        for i = 0, AllItemCount - 1, 1 do
            local ItemObj = self.List_Item:GetItemAt(i)
            if (ItemObj and ItemObj.StuffId == ResourceId) then
                local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and  (StuffServerData.Count <= 0))) then
                    self.List_Item:RemoveItem(ItemObj)  
                    local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                    self.List_Item:AddItem(EmptyStuffObj) 
                    self.List_Item:AddEmptyGridItemCount(1)
                    self.NeedSelectGridIndex = 0
                    self:JumpToSelectItem(false)
                    self:RefreshAllGridIndex()
                else
                    ItemObj.Count = StuffServerData.Count
                    if (ItemObj.SelfWidget) then
                        ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                    end
                end
            end
        end
        -- 刷新一下详情数量
        if (self.Panel_Detail:IsVisible()) then
            self.Panel_Detail:UpdateItemNumber()
        end
    end

    PlayerAvatar:UseResourceInBag(ResourceId, ConsumeCount, DealWithConsumableItemsCallback)

    self.CurrentChooseInfo = nil
end

function M:ConfirmDealWithConsumablePacks(UseEffectType)
    -- 发送RPC获得礼包
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
        return
    end
    local ResourceId = self.CurrentChooseInfo.ResourceId
    local OptionalId = self.CurrentChooseInfo.OptionalId
    local ConsumeCount = self.CurrentChooseInfo.ConsumeCount or 1
    local DealWithConsumableItemsCallback = function()
        local OptionalItemsDataConfig = DataMgr.Reward[OptionalId]
        local Count = self.ConsumeCount
        local ResourcePackChooseId = OptionalItemsDataConfig.Id
        local AllRewards ={
            Resources = {},
        }
        for k, v in pairs(OptionalItemsDataConfig.Id) do
            AllRewards.Resources[v] = OptionalItemsDataConfig.Count[k][1] * Count
        end
        -- UIUtils.ShowGetItemPage(BagCommon.StuffType.Resource, ResourcePackChooseId[1], Count)
        UIManager(self):LoadUINew("GetItemPage",  nil, nil, nil, AllRewards, nil, self, true)
        -- 刷新一下List里面对应Item的数量信息
        local AllItemCount = self.List_Item:GetNumItems()
        for i = 0, AllItemCount - 1, 1 do
            local ItemObj = self.List_Item:GetItemAt(i)
            if (ItemObj and ItemObj.StuffId == ResourceId) then
                local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and  (StuffServerData.Count <= 0))) then
                    self.List_Item:RemoveItem(ItemObj)  
                    local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                    self.List_Item:AddItem(EmptyStuffObj) 
                    self.List_Item:AddEmptyGridItemCount(1)
                    self.NeedSelectGridIndex = 0
                    self:JumpToSelectItem(false)
                    self:RefreshAllGridIndex()
                else
                    ItemObj.Count = StuffServerData.Count
                    if (ItemObj.SelfWidget) then
                        ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                    end
                end
            end
        end
        -- 刷新一下详情数量
        if (self.Panel_Detail:IsVisible()) then
            self.Panel_Detail:UpdateItemNumber()
        end
    end
    PlayerAvatar:UseResourceInBag(ResourceId, ConsumeCount, DealWithConsumableItemsCallback)
    -- self.CurrentChooseInfo = nil
end

function M:GenerateDataWith_SelectWeapon(ResourceId, UseParam)
    -- 自选武器数据
    local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        DebugPrint("GenerateDataWith_SelectWeapon Avatar is nil, Not Connect to Server")
        return ResultData
    end

    if (OptionalItemsDataConfig) then
        for index, value in ipairs(OptionalItemsDataConfig.Id) do
            local RewardObject = {}
            RewardObject.HaveCountNumber = 0
            for Uuid, StuffServerData in pairs(Avatar.Weapons) do
                if (StuffServerData.WeaponId == value) then
                    RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
                    if (RewardObject.GradeLevel == nil or StuffServerData.GradeLevel > RewardObject.GradeLevel) then
                        RewardObject.GradeLevel = StuffServerData.GradeLevel
                        RewardObject.IsMaxGradeLevel = DataMgr.WeaponCardLevel[value].CardLevelMax == StuffServerData.GradeLevel
                    end
                end
            end
            local WeaponConfigData = DataMgr.Weapon[value]

            local BattleWeaponInfo, AttributeIcon = DataMgr.BattleWeapon[value], nil
            if BattleWeaponInfo then 
                for _,Tag in pairs(BattleWeaponInfo.WeaponTag) do
                    local TagInfo = DataMgr.WeaponTag[Tag]
                    if TagInfo and TagInfo.WeaponTagfilter and TagInfo.Icon then
                        AttributeIcon = TagInfo.Icon
                        break
                    end
                end
            end

            RewardObject.ResourceId = ResourceId
            RewardObject.OptionalId = UseParam
            RewardObject.StuffId = value
            RewardObject.StuffIcon = WeaponConfigData.Icon
            RewardObject.StuffName = GText(WeaponConfigData.WeaponName)
            RewardObject.StuffType = BagCommon.OptionalItemType.Weapon
            RewardObject.Rarity = WeaponConfigData.WeaponRarity or 1
            RewardObject.AttrIcon = AttributeIcon
            RewardObject.UIName = BagCommon.MainUIName
            RewardObject.ParentWidget = self
            table.insert(ResultData, RewardObject)
        end
    end
    return ResultData, GText("UI_SHOP_SUBTAB_NAME_WEAPON")
end

function M:GenerateDataWith_SelectCharacter(ResourceId, UseParam)
    -- 自选角色数据
    local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        return ResultData
    end

    if (OptionalItemsDataConfig) then
        for index, value in ipairs(OptionalItemsDataConfig.Id) do
            local RewardObject = {}
            RewardObject.HaveCountNumber = 0
            -- 统计拥有该角色的数量
            for Uuid, StuffServerData in pairs(Avatar.Chars or {}) do
                if (StuffServerData.CharId == value) then
                    RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
                    if (RewardObject.GradeLevel == nil or StuffServerData.GradeLevel > RewardObject.GradeLevel) then
                        RewardObject.GradeLevel = StuffServerData.GradeLevel
                    end
                    local CharPieceId = DataMgr.Char[value].CharPieceId
                    RewardObject.Count = Avatar:GetResourceNum(CharPieceId)
                end
            end

            local CharacterConfigData = DataMgr.Char[value]
            local BattleCharInfo, AttributeIcon = DataMgr.BattleChar[value], nil
            if BattleCharInfo then 
                local Attribute = BattleCharInfo.Attribute
                AttributeIcon = DataMgr.Attribute[Attribute] and DataMgr.Attribute[Attribute].Icon
            end
            RewardObject.ResourceId = ResourceId
            RewardObject.OptionalId = UseParam
            RewardObject.StuffId = value
            RewardObject.StuffIcon = CharacterConfigData.Icon
            RewardObject.StuffName = GText(CharacterConfigData.CharName)
            RewardObject.StuffType = BagCommon.OptionalItemType.Avatar
            RewardObject.Rarity = CharacterConfigData.CharRarity
            RewardObject.AttrIcon = AttributeIcon
            RewardObject.Attribute = BattleCharInfo.Attribute
            RewardObject.UIName = BagCommon.MainUIName
            RewardObject.ParentWidget = self
            table.insert(ResultData, RewardObject)
        end
    end
    return ResultData, GText("UI_Armory_Char")
end

function M:GenerateDataWith_SelectPet(ResourceId, UseParam)
    -- 自选魔灵数据
    local ResultData, OptionalItemsDataConfig = {}, DataMgr.OptReward[UseParam]
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        return ResultData
    end

    if (OptionalItemsDataConfig) then
        for index, value in ipairs(OptionalItemsDataConfig.Id) do
            local RewardObject = {}
            RewardObject.HaveCountNumber = 0
            -- 统计拥有该魔灵的数量
            for Uuid, StuffServerData in pairs(Avatar.Pets or {}) do
                if (StuffServerData.PetId == value) then
                    RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
                    if (RewardObject.GradeLevel == nil or StuffServerData.BreakNum > RewardObject.GradeLevel) then
                        RewardObject.GradeLevel = StuffServerData.BreakNum
                    end
                end
            end

            local PetConfigData = DataMgr.Pet[value]
            RewardObject.ResourceId = ResourceId
            RewardObject.Premium = PetConfigData.Premium
            RewardObject.OptionalId = UseParam
            RewardObject.StuffId = value
            RewardObject.StuffIcon = PetConfigData.Icon
            RewardObject.StuffName = GText(PetConfigData.Name)
            RewardObject.StuffType = BagCommon.OptionalItemType.Pet
            RewardObject.Rarity = PetConfigData.Rarity or 1
            RewardObject.UIName = BagCommon.MainUIName
            RewardObject.ParentWidget = self
            table.insert(ResultData, RewardObject)
        end
    end
    return ResultData, GText("MAIN_UI_PET")
end

function M:GenerateDataWith_SelectResource(ResourceId, UseParam)
    -- 自选道具
    local ResultData, OptionalItemsDataConfig, OptCount = {}, DataMgr.OptReward[UseParam], nil
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        return ResultData
    end

    if (OptionalItemsDataConfig) then
        OptCount = Avatar.Resources[ResourceId].Count
        for index, value in ipairs(OptionalItemsDataConfig.Id) do
            local RewardObject = {}
            RewardObject.HaveCountNumber = 0
            -- 统计拥有该资源包的数量
            for Uuid, StuffServerData in pairs(Avatar.Resources or {}) do
                if (StuffServerData.ResourceId == value) then
                    RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
                end
            end

            local ResourceConfigData = DataMgr.Resource[value]
            RewardObject.ResourceId = ResourceId
            RewardObject.OptionalId = UseParam
            RewardObject.StuffId = value
            RewardObject.StuffCount = Avatar.Resources[value] and Avatar.Resources[value].Count or 0
            RewardObject.StuffIcon = ResourceConfigData.Icon
            RewardObject.StuffName = GText(ResourceConfigData.ResourceName)
            RewardObject.StuffType = "SelectResource"
            RewardObject.Rarity = ResourceConfigData.Rarity or 1
            RewardObject.UIName = BagCommon.MainUIName
            RewardObject.ParentWidget = self
            RewardObject.Count = OptionalItemsDataConfig.Count[index]
            RewardObject.OptCount = OptCount
            table.insert(ResultData, RewardObject)
        end
    end
    return ResultData, GText("UI_Consumable_Effect_ResourcePack"), OptCount
end

function M:GenerateDataWith_ResourcePack(ResourceId, UseParam)
    -- 资源包
    local ResultData, OptionalItemsDataConfig, OptCount = {}, DataMgr.Reward[UseParam], nil
    local Avatar = GWorld:GetAvatar()
    if (Avatar == nil) then
        return ResultData
    end

    if (OptionalItemsDataConfig) then
        OptCount = Avatar.Resources[ResourceId].Count
        for index, value in ipairs(OptionalItemsDataConfig.Id) do
            local RewardObject = {}
            RewardObject.HaveCountNumber = 0
            -- 统计拥有该资源包的数量
            for Uuid, StuffServerData in pairs(Avatar.Resources or {}) do
                if (StuffServerData.ResourceId == value) then
                    RewardObject.HaveCountNumber = RewardObject.HaveCountNumber + 1
                end
            end

            local ResourceConfigData = DataMgr.Resource[value]
            RewardObject.ResourceId = ResourceId
            RewardObject.OptionalId = UseParam
            RewardObject.StuffId = value
            RewardObject.StuffIcon = ResourceConfigData.Icon
            RewardObject.StuffName = GText(ResourceConfigData.ResourceName)
            RewardObject.StuffType = "ResourcePack"
            RewardObject.Rarity = ResourceConfigData.Rarity or 1
            RewardObject.UIName = BagCommon.MainUIName
            RewardObject.ParentWidget = self
            RewardObject.Count = OptionalItemsDataConfig.Count[index][1] or 1
            RewardObject.OptCount = OptCount
            table.insert(ResultData, RewardObject)
        end
    end
    local ResourcePackText = GText("UI_Consumable_Effect_ResourcePack"), OptCount
    return ResultData, ResourcePackText
end

function M:ClickToUnlockStuff()
    local PlayerAvatar = GWorld:GetAvatar()
    if (PlayerAvatar == nil) then
        DebugPrint("PlayerAvatar is nil, Not Connect to Server")
        return
    end
    if (self.CurSelectStuffContent == nil) then
        DebugPrint("ClickToUnlockStuff error, CurSelectStuffContent is nil")
        return
    end
    if (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
        local StuffServerData = self:GetStuffServerData(self.CurSelectStuffContent.Uuid, self.CurSelectStuffContent.StuffType)
        if (StuffServerData ~= nil and StuffServerData.IsOriginal == true) then
            -- 原始Mod不能锁定
            UIManager(self):ShowError(7013, nil, UIConst.Tip_CommonToast)
            return
        end
    end
    if (self.CurSelectStuffContent ~= nil and self.CurSelectStuffContent.Price == -1) then
        UIManager(self):ShowError(7014, nil, UIConst.Tip_CommonToast)
        return
    end
    if (self.CurSelectStuffContent and self.CurSelectStuffContent.LockType ~= 0) then
        UIManager(self):ShowCommonPopupUI_Old(100019, self, self.RealToUnLockItems)
    else
        if (self.CurSelectStuffContent.StuffType == BagCommon.StuffType.Weapon) then
            local WeaponUuid = self:GetStuffObjId(self.CurSelectStuffContent.Uuid)
            PlayerAvatar:LockResourceInBag(CommonConst.AllType.Weapon, WeaponUuid)
            self:BlockAllUIInput(true)
        elseif (self.CurSelectStuffContent.StuffType == BagCommon.StuffType.Mod) then
            local ModUuid = self:GetStuffObjId(self.CurSelectStuffContent.Uuid)
            PlayerAvatar:LockResourceInBag(CommonConst.AllType.Mod, ModUuid)
            self:BlockAllUIInput(true)
        elseif (self.CurSelectStuffContent.StuffType == BagCommon.StuffType.Resource) then
            local StuffUnitId = self.CurSelectStuffContent.UnitId
            if BagCommon:IsFishResource(StuffUnitId) then
                PlayerAvatar:LockResourceInBag(CommonConst.AllType.Resource, StuffUnitId, self.CurSelectStuffContent.FishInfo.Size)
            else
                PlayerAvatar:LockResourceInBag(CommonConst.AllType.Resource, StuffUnitId)
            end
            self:BlockAllUIInput(true)
        end
    end
end

function M:OnClickBlank()
    if (not self.Panel_Detail:IsVisible()) then
        return
    end
    if (IsValid(self.CurSelectStuffContent)) then
        if (self.CurSelectStuffContent.SelfWidget) then
            self.CurSelectStuffContent.SelfWidget:SetSelected(false)
        else
            self.CurSelectStuffContent.IsSelect = false
        end
    end
    self:CancelStuffClickAndHideDetail()
end

function M:RealToUnLockItems()
    local PlayerAvatar = GWorld:GetAvatar()
    if (self.CurSelectStuffContent) then
        if (self.CurSelectStuffContent.StuffType == BagCommon.StuffType.Weapon) then
            local StuffUuid = self:GetStuffObjId(self.CurSelectStuffContent.Uuid)
            self:Unlock_OpenSeconderyPassword(CommonConst.AllType.Weapon, StuffUuid, PlayerAvatar)
        elseif (self.CurSelectStuffContent.StuffType == BagCommon.StuffType.Mod) then
            local StuffUuid = self:GetStuffObjId(self.CurSelectStuffContent.Uuid)
            self:Unlock_OpenSeconderyPassword(CommonConst.AllType.Mod, StuffUuid, PlayerAvatar)
        else
            local StuffUnitId = self.CurSelectStuffContent.UnitId
            if BagCommon:IsFishResource(StuffUnitId) then
                PlayerAvatar:UnLockResourceInBag(CommonConst.AllType.Resource, StuffUnitId, self.CurSelectStuffContent.FishInfo.Size)
            else
                PlayerAvatar:UnLockResourceInBag(CommonConst.AllType.Resource, StuffUnitId)
            end
            -- 发送Rpc之后禁用一下输入相关
            self:BlockAllUIInput(true)
        end
    end
end

-- 通过二级密码解锁 武器和Mod
function M:Unlock_OpenSeconderyPassword(Type, Uuid, PlayerAvatar)
    local Callback={
        OnSuccess = function(Password)
            self:SetFocus()
            self:BlockAllUIInput(true)
            PlayerAvatar:UnLockResourceInBag(Type, Uuid)
        end,
        OnCancel = function()
            self:SetFocus()
        end,
    }

    SecondaryPasswordController:RequestSecPasswordValidation(Callback)
end

--#endregion

--#region RPC回调相关
function M:OnUpdateBagItemByAction(OpAction, ErrCode, ...)
    -- 所有RPC的回调
    if (not ErrorCode:Check(ErrCode, UIConst.Tip_CommonToast)) then
        if (OpAction == "StateChange" or OpAction == "FishStateChange") then
            -- 先解除一下输入阻塞
            self:BlockAllUIInput(false)
        end
        return
    end
    if (OpAction == "StateChange") then
        self:BlockAllUIInput(false)
        local StuffUnitId = ...
        local StuffServerData = nil
        if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
            StuffServerData = self:GetStuffServerData(StuffUnitId, BagCommon.StuffType.Weapon)
        elseif (self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
            StuffServerData = self:GetStuffServerData(StuffUnitId, BagCommon.StuffType.Mod)
        else
            StuffServerData = self:GetStuffServerData(StuffUnitId, BagCommon.StuffType.Resource)
        end
        if (StuffServerData and StuffServerData:IsLock()) then
            UIManager(self):ShowError(7006, nil, UIConst.Tip_CommonToast)
        else
            UIManager(self):ShowError(7007, nil, UIConst.Tip_CommonToast)
        end
        -- 刷新一下格子Item
        self:RefreshDetail(self.CurSelectGridIndex, self.CurSelectStuffContent.Uuid)
        local AllItemCount = self.List_Item:GetNumItems()
        local NeedEqualStuffUnitId = ""
        if (type(StuffUnitId) == "number") then
            NeedEqualStuffUnitId = tostring(StuffUnitId)
        else
            NeedEqualStuffUnitId = self:GetStuffObjId(StuffUnitId)
        end
        for i = 0, AllItemCount - 1, 1 do
            local ItemObj = self.List_Item:GetItemAt(i)
            if (ItemObj and ItemObj.Uuid == NeedEqualStuffUnitId) then
                local LockType = StuffServerData:IsLock() and 1 or 0
                ItemObj.LockType = LockType
                if (ItemObj.SelfWidget) then
                    ItemObj.SelfWidget:SetLock(LockType)
                end
                break
            end
        end
    elseif (OpAction == "FishStateChange") then
        self:BlockAllUIInput(false)
        local FishResourceId, FishSize = ...
        local IsLocked = BagCommon:IsFishResourceLocked(FishResourceId, FishSize)
        if IsLocked then
            UIManager(self):ShowError(7006, nil, UIConst.Tip_CommonToast)
        else
            UIManager(self):ShowError(7007, nil, UIConst.Tip_CommonToast)
        end
        self:RefreshDetail(self.CurSelectGridIndex, self.CurSelectStuffContent.Uuid)
        for i = 0, self.List_Item:GetNumItems() - 1, 1 do
            local ItemObj = self.List_Item:GetItemAt(i)
            if (ItemObj and ItemObj.Uuid == self.CurSelectStuffContent.Uuid) then
                ItemObj.LockType = IsLocked and 1 or 0
                if (ItemObj.SelfWidget) then
                    ItemObj.SelfWidget:SetLock(ItemObj.LockType)
                end
                break
            end
        end
    elseif (OpAction == "WeaponBulkBreakDown") then
        if (self.CurTabId == BagCommon.ItemTypeToTabId.MeleeWeapon or self.CurTabId == BagCommon.ItemTypeToTabId.RangedWeapon) then
            -- 如果当前正好选中武器Tab，则进行刷新
            local _, ResolveWeaponSucc = ...
            local SellCount, IsNeedRefreshAll = 0, false
            for i, v in ipairs(ResolveWeaponSucc) do
                local WeaponUnitId = v
                local NeedRemoveObj = self.DesireResolveWeaponList[WeaponUnitId]
                if (NeedRemoveObj) then
                    self.List_Item:RemoveItem(NeedRemoveObj)
                    SellCount = SellCount + 1
                else
                    IsNeedRefreshAll = true
                end
            end

            if (IsNeedRefreshAll) then
                -- 这种情况需要重新刷新整个列表
                self:ReGenerateBagList()
            else
                for i = 1, SellCount, 1 do
                    local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                    self.List_Item:AddItem(EmptyStuffObj)
                    self.List_Item:AddEmptyGridItemCount(1)
                end
                -- self.CurSelectStuffContent = nil
                -- self.CurSelectGridIndex = -1
                -- self:RefreshDetail(-1, StuffUnitId)
                self.NeedSelectGridIndex = 0
                self:JumpToSelectItem(false)
                self:RefreshAllGridIndex()
            end
        end
        self.Tab_Bag:UpdateResource()
    elseif (UE4.UKismetStringLibrary.EndsWith(OpAction, "Sale", ESearchCase.CaseSensitive)) then
        local SellCount, IsNeedRefreshAll, bIsIgnore = 0, false, false
        if (OpAction == "ModBulkSale" and self.CurTabId == BagCommon.ItemTypeToTabId.Mod) then
            -- 如果当前正选中Mod列
            local DecomposeSuccStuff, DecomposeModSucc = ...
            for i, v in ipairs(DecomposeModSucc) do
                local StuffUnitId = v
                local StuffServerData = self:GetStuffServerData(StuffUnitId, BagCommon.StuffType.Mod)
                if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and  (StuffServerData.Count <= 0))) then
                    -- 此类型Mod卖光了
                    local NeedRemoveObj = self.DesireSaleStuffObjList[StuffUnitId]
                    if (NeedRemoveObj) then
                        self.List_Item:RemoveItem(NeedRemoveObj)   
                        SellCount = SellCount + 1
                    else
                        IsNeedRefreshAll = true
                    end
                else
                    local NeedUpdateObj = self.DesireSaleStuffObjList[StuffUnitId]
                    if (NeedUpdateObj) then
                        NeedUpdateObj.Count = StuffServerData.Count
                        if (NeedUpdateObj.SelfWidget) then
                            NeedUpdateObj.SelfWidget:SetCount(StuffServerData.Count)
                            NeedUpdateObj.SelfWidget:SetName(StuffServerData.Count)
                            -- NeedUpdateObj.SelfWidget:SetGradeLevel(StuffServerData.Count)
                        end
                    end
                    -- if (self.CurSelectStuffContent and self.CurSelectStuffContent.Uuid == StuffUnitId) then
                    --     self:RefreshDetail(self.CurSelectGridIndex, StuffUnitId)
                    -- end
                end
            end
        elseif (OpAction == "ResourceBulkSale") then
            -- 如果当前正选中Resource列
            local SaleItemSucc, SaleItemFail = ...
            for k, v in pairs(SaleItemSucc) do
                local StuffUnitId = k
                local StuffServerData = self:GetStuffServerData(StuffUnitId, BagCommon.StuffType.Resource)
                if (StuffServerData) then
                    local StuffConfigData = StuffServerData:Data()
                    if (StuffConfigData.MaterialClassify ~= self.CurTabId) then
                        bIsIgnore = true
                        break
                    end
                end
                if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and StuffServerData.Count <= 0)) then
                    -- 此道具卖光了
                    local NeedRemoveObj = self.DesireSaleStuffObjList[tostring(StuffUnitId)]
                    if (NeedRemoveObj) then
                        self.List_Item:RemoveItem(NeedRemoveObj)  
                        SellCount = SellCount + 1 
                    else
                        IsNeedRefreshAll = true
                    end
                else
                    local NeedUpdateObj = self.DesireSaleStuffObjList[tostring(StuffUnitId)]
                    if (NeedUpdateObj) then
                        NeedUpdateObj.Count = StuffServerData.Count
                        if (NeedUpdateObj.SelfWidget) then
                            NeedUpdateObj.SelfWidget:SetCount(StuffServerData.Count)
                        end
                    end
                    -- if (self.CurSelectStuffContent and self.CurSelectStuffContent.Uuid == tostring(StuffUnitId)) then
                    --     self:RefreshDetail(self.CurSelectGridIndex, StuffUnitId)
                    -- end
                end
            end
        elseif (OpAction == "FishResourceBulkSale" and self.CurTabId == BagCommon.ItemTypeToTabId.FishItem) then
            local SaleFishResources, SaleFishPrice = ...
            local Avatar = GWorld:GetAvatar()
            for ResourceId, FishInfos in pairs(SaleFishResources) do
                if "table" ~= type(FishInfos) then
                    break
                end
                -- 不是当前Tab页，忽略格子刷新
                local StuffServerData = self:GetStuffServerData(ResourceId, BagCommon.StuffType.Resource)
                if (StuffServerData) then
                    local StuffConfigData = StuffServerData:Data()
                    if (StuffConfigData.MaterialClassify ~= self.CurTabId) then
                        bIsIgnore = true
                        break
                    end
                end
                -- 根据售卖情况刷新格子
                for _, FishInfo in ipairs(FishInfos) do
                    local FishCount
                    local FishSize2Count = BagCommon:GetFishSize2Count(ResourceId)
                    if FishSize2Count then
                        FishCount = FishSize2Count[FishInfo.Size]
                    end

                    local FishStuffId = ResourceId.."_"..(FishInfo.Size)
                    local FishSaleStuffObj = self.DesireSaleStuffObjList[FishStuffId]

                    if (FishCount == nil or  (type(FishCount) == "number" and FishCount == 0)) then
                        -- 特定类型且特定尺寸的鱼卖光
                        if FishSaleStuffObj then
                            self.List_Item:RemoveItem(FishSaleStuffObj)
                            SellCount = SellCount + 1
                        else
                            IsNeedRefreshAll = true
                        end
                    elseif FishSaleStuffObj then
                        FishSaleStuffObj.Count = FishCount
                        if (FishSaleStuffObj.SelfWidget) then
                            FishSaleStuffObj.SelfWidget:SetCount(FishCount)
                        end
                    end
                end
            end
        elseif (OpAction == "DraftBulkSale" and self.CurTabId == BagCommon.ItemTypeToTabId.Draft) then
            local SaleDraftSucc = ...
            for k, v in pairs(SaleDraftSucc) do
                local StuffUnitId = k
                local StuffServerData = self:GetStuffServerData(StuffUnitId, BagCommon.StuffType.Draft)

                if (StuffServerData == nil or (type(StuffServerData.Count) == "number" and StuffServerData.Count <= 0)) then
                    -- 此图纸卖光了
                    local NeedRemoveObj = self.DesireSaleStuffObjList[tostring(StuffUnitId)]
                    if (NeedRemoveObj) then
                        self.List_Item:RemoveItem(NeedRemoveObj)  
                        SellCount = SellCount + 1 
                    else
                        IsNeedRefreshAll = true
                    end
                else
                    local NeedUpdateObj = self.DesireSaleStuffObjList[tostring(StuffUnitId)]
                    if (NeedUpdateObj) then
                        NeedUpdateObj.Count = StuffServerData.Count
                        if (NeedUpdateObj.SelfWidget) then
                            NeedUpdateObj.SelfWidget:SetCount(StuffServerData.Count)
                        end
                    end
                    -- if (self.CurSelectStuffContent and self.CurSelectStuffContent.Uuid == tostring(StuffUnitId)) then
                    --     self:RefreshDetail(self.CurSelectGridIndex, StuffUnitId)
                    -- end
                end
            end
        end
        if (not bIsIgnore) then
            if (IsNeedRefreshAll) then
                -- 这种情况需要重新刷新整个列表
                self:ReGenerateBagList()
            else
                for i = 1, SellCount, 1 do
                    local EmptyStuffObj = StuffIconObject:CreateBagItemContent({Uuid="", StuffType="EmptyGrid", StuffCount=0, StuffIcon=nil, ParentWidget=self})
                    self.List_Item:AddItem(EmptyStuffObj) 
                    self.List_Item:AddEmptyGridItemCount(1)
                end
                -- self.CurSelectStuffContent = nil
                -- self.CurSelectGridIndex = -1
                -- self:RefreshDetail(-1, StuffUnitId)
                self.NeedSelectGridIndex = 0
                self:JumpToSelectItem(false)
                self:RefreshAllGridIndex()
            end
        end
        self.Tab_Bag:UpdateResource()
    elseif (OpAction == "ReceiveStuffItem") then
        -- 获取道具Item
        local GetItemStuffId, GetItemCount, PackRewards = ...
        local AllItemCount = self.List_Item:GetNumItems()
        for i = 0, AllItemCount - 1, 1 do
            local ItemObj = self.List_Item:GetItemAt(i)
            if (ItemObj and ItemObj.StuffId == GetItemStuffId) then
                local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                ItemObj.Count = StuffServerData.Count
                if (ItemObj.SelfWidget) then
                    ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                end
            end
        end
        -- 刷新一下详情数量
        if (self.Panel_Detail:IsVisible()) then
            self.Panel_Detail:UpdateItemNumber()
        end
    elseif (OpAction == "UseStuffItem") then
        -- 获取道具Item
        local GetItemStuffId = ...
        local AllItemCount, IsNeedRemoveItem = self.List_Item:GetNumItems(), false
        for i = 0, AllItemCount - 1, 1 do
            local ItemObj = self.List_Item:GetItemAt(i)
            if (ItemObj and ItemObj.StuffId == GetItemStuffId) then
                local StuffServerData = self:GetStuffServerData(ItemObj.Uuid, BagCommon.StuffType.Resource)
                if (StuffServerData) then
                    ItemObj.Count = StuffServerData.Count
                    if (ItemObj.SelfWidget) then
                        ItemObj.SelfWidget:SetCount(StuffServerData.Count)
                    end
                else
                    -- 道具消耗完了
                    IsNeedRemoveItem = true
                    self.List_Item:RemoveItem(ItemObj)
                end
            end
        end
        if (IsNeedRemoveItem) then
            -- 移除当前Stuff格子
            self.NeedSelectGridIndex = 0
            self:JumpToSelectItem(false)
            self:RefreshAllGridIndex()
        else
            -- 刷新一下详情数量
            if (self.Panel_Detail:IsVisible()) then
                self.Panel_Detail:UpdateItemNumber()
            end
        end
    end
end
--#endregion

return M
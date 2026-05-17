--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR 
-- @DATE 
--
require "UnLua"

local M = Class("BluePrints.UI.Shop.WBP_Shop_Main_Base_C")
local ImpressionTypes = require"BluePrints.UI.UI_PC.Impression.ImpressionConst".ImpressionTypes

M._components = {
    "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp",
    "BluePrints.UI.UI_PC.Common.LSFocusComp",
}
function M:Construct()
    M.Super.Construct(self)

    self:AddLSFocusTarget(self.Btn_DimensionDrawArea.Key_Dimension, self.Btn_DimensionDrawArea, "Menu", true)
    self:AddLSFocusTarget(self.CheckBox_Own.Com_KeyImg, self.CheckBox_Own, "X", true)
    self:AddLSFocusTarget(nil, {self.Common_SortList_PC})
end

function M:Destruct()
    M.Super.Destruct(self)

    self:RemoveFocusTarget("Menu")
    self:RemoveFocusTarget("LS")
    self:RemoveFocusTarget("X")
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)
    local MainTabIdx, SubTabIdx, ShopItemId, bNotPlayBgBlend = ...
    self.ExtraShopItemInfos = {}
    self.Filters = { "UI_Select_Default", "UI_RARITY_NAME"}
    self.bFilterOwned = false
    self.List_Item:SetVisibility(ESlateVisibility.Visible)
    self:PlayAnimation(self.In)
    self:InitImpressionShop(MainTabIdx, SubTabIdx, ShopItemId, bNotPlayBgBlend)
    self:SetGText()
    self:PlayInAudio()
end

function M:PlayInAudio()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "ImpressionShopIn", nil)
    AudioManager(self):PlaySystemUIBGM(self.ShopBGM, nil, "ImpressionShop")
end

function M:PlaySwitchRegionAudio()
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_five_dimension_region_change", "ImpressionShopSwitchRegion", nil)
end

function M:PlayCloseAudio()
    AudioManager(self):SetEventSoundParam(self, "ImpressionShopIn", { ToEnd = 1 })
    AudioManager(self):StopSystemUIBGM("ImpressionShop")
end

function M:InitDimensionBtn()
    for _,MapData in pairs(DataMgr.WorldMap) do
        for _,regionMapId in pairs(MapData.WorldMapRegion) do
            if self.RegionId == DataMgr.RegionMap[regionMapId].RegionId then
                self.RegionIcon = MapData.RegionIcon
                self.WorldId = MapData.WorldMapId
                break
            end
        end
    end
    self.Btn_DimensionDrawArea:Init(self.RegionId)
end

function M:SetGText()
    self.Text_ImpressionShopTips:SetText(GText("UI_ImpressionShop_Tips"))
end

function M:BindButtonEvents()
    self.Btn_DimensionDrawArea:BindEventOnClicked(self, self.OnBtn_DimensionClicked)
    self.CheckBox_Own:BindEventOnClicked({Inst = self,Func = self.OnClickFilterOwned})
end

function M:UnBindButtonEvents()
    self.CheckBox_Own:UnBindEventOnClickedByObj(self)
    self.Btn_DimensionDrawArea:UnBindEventOnClicked(self, self.OnBtn_DimensionClicked)
end

function M:OnClickFilterOwned()
    DebugPrint("WBP_Impression_Shop_P:OnClickFilterOwned") 
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self.bFilterOwned = not self.bFilterOwned

    self:UpdateShopDetail(nil, true)
end

function M:OnBtn_DimensionClicked()
    local DimensionPanel=UIManager(self):LoadUINew("RegionMapImpression")
    DimensionPanel:Init(self.RegionId,self,true)
    self.Btn_DimensionDrawArea:SetIsChecked(false)
end

function M:InitBg(bNotPlayBgBlend)
    self.PlayBgBlend = not bNotPlayBgBlend
end

function M:InitImpressionShop(MainTabIdx, SubTabIdx, ShopItemId, bNotPlayBgBlend)
    self.bIniting = true
    self.bIsFocusable = true
    self.Text_None:SetText(GText("UI_SHOP_NOTOWNED"))
    local MainTabIdx = MainTabIdx
    if not MainTabIdx then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local RegionId = Avatar:GetSubRegionId2RegionId()
            MainTabIdx = DataMgr.RegionId2ImpressionMainTab[RegionId]
        end
    end
    self:InitBg(bNotPlayBgBlend)
    self:InitSortList()
    self:InitShopTabInfo(MainTabIdx, SubTabIdx, 2)
    self.SelectItemId = nil
    if ShopItemId then
        self.SelectItemId = ShopItemId
        if not self:IsAnimationPlaying(self.In) then
            self:BlockAllUIInput(true,"SP_DisplayOnly")
            self:AddTimer(0.1, function()
                self:BlockAllUIInput(false)
                self:ShowItemDetail()
            end, false, 0, "OpenShopItemDialog", true)
        end
    end
    self.bIniting = false
end

function M:ShowItemDetail()
    if not self.SelectItemId then
        return
    end
    local ShopItemContent = self.ShopItemContentsMap[self.SelectItemId]
    if not ShopItemContent or not IsValid(ShopItemContent.UI) then
        return
    end
    ShopItemContent.UI:ShowItemDetail()
end

function M:CloseItemDetail()
    if not self.SelectItemId then
        return
    end
    local ShopItemContent = self.ShopItemContentsMap[self.SelectItemId]
    if not ShopItemContent or not IsValid(ShopItemContent.UI) then
        return
    end
    ShopItemContent.UI:CloseItemDetail()
end

function M:InitRegionInfo(MainTabIdx)
    local RegionId = nil
    if MainTabIdx then
        local MainTabData = DataMgr.ImpressionShopMainTab[MainTabIdx]
        RegionId = MainTabData and MainTabData.RegionId
    end
    if not RegionId then
        local Message = string.format("未在ImpressionShopMainTab中找到对应的区域信息，MainTabId：%d", MainTabIdx)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Impression, "印象商店MainTab未填写区域Id", Message)

        local Avatar = GWorld:GetAvatar()
        if Avatar then
            RegionId = Avatar:GetSubRegionId2RegionId()
        end
    end
    RegionId = RegionId and tonumber(RegionId)
    self.RegionId = RegionId
    if not DataMgr.ImpressionShopInfo[self.RegionId] then
        local Message = string.format("未在ImpressionShopInfo中找到当前区域的商店信息，RegionId：%d", self.RegionId)
        UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Impression, "未获取印象商店信息", Message)
        return
    end
    self.ShopData = DataMgr.ImpressionShopInfo[self.RegionId]

    self:UpdateBgBP()
    self:UpdateTitle()
    self:UpdateResource()
    self:InitDimensionBtn()
    self.ShopBGM = self.ShopData.PlaySystemUIBGM
end

function M:SwitchRegion(MainTabIdx)
    local OldPlayBgBlend = self.PlayBgBlend
    self.PlayBgBlend = false
    if IsValid(self.Btn_DimensionDrawArea) then
        self.Btn_DimensionDrawArea:PlayAnimation(self.Btn_DimensionDrawArea.Change)
    end
    self:PlaySwitchRegionAudio()
    self:InitRegionInfo(MainTabIdx)
    self.PlayBgBlend = OldPlayBgBlend
end

function M:UpdateBgBP(BPPath)
    self.BgItem = nil
    local BPPath = BPPath or self.ShopData and self.ShopData.ShopBgBPPath
    if not BPPath then
        return
    end
    local Widget = UE4.UWidgetBlueprintLibrary.Create(self, LoadClass(BPPath))
    if Widget then
        self.Group_BG:ClearChildren()
        local Slot = self.Group_BG:AddChild(Widget)
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        self.BgItem = Widget
        self.BgItem.bPlayBgBlend = self.PlayBgBlend
        self.BgItem:PlayBgIn()
    end
end

function M:UpdateTitle(TitleName)
    local TitleName = TitleName or self.ShopData and self.ShopData.ShopName
    if not TitleName then
        return
    end
    self.Common_Tab:UpdateTopTitle(GText(TitleName))
end

function M:UpdateResource(ResourceId)
    local ResourceId = ResourceId or self.ShopData and self.ShopData.TabCoin
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local SubRegionId = Avatar:GetSubRegionId2RegionId()
        local Data = DataMgr.ImpressionResource[SubRegionId]
        ResourceId = ResourceId or Data and Data.ResourceId
    end
    if not ResourceId then
        ResourceId = {3001}
    end
    self.Common_Tab:OverrideTopResource(ResourceId, true)
end

--- 主页签切换回调方法
---@param TabWidget Common_Tab_Item_PC_C
function M:OnMainTabChanged(TabWidget)
    M.Super.OnMainTabChanged(self, TabWidget)
    local MainTabId = self.MainTabMap[TabWidget.Idx]
    if not MainTabId then
        return
    end
    if self.bIniting then
        self:InitRegionInfo(MainTabId)
    else
        self:SwitchRegion(MainTabId)
    end
    self:UpdateSortList()
end

function M:SetFocus_Lua()
    if (self.ShopItemNum > 0) then
        self.List_Item:SetFocus()
    else
        self:SetFocus()
    end
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:UnBindButtonEvents()
    self:PlayAnimation(self.Out)
    if self.BgItem then
        self.BgItem.bPlayBgBlend = self.PlayBgBlend
        self.BgItem:PlayBgOut()
    end
end

function M:BindSortListEvents()
    self.Common_SortList_PC:BindEventOnSelectionsChanged(self, self.OnSelectionsChanged)
    self.Common_SortList_PC:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
end

function M:InitSortList()
    self.Common_SortList_PC:Init(self,self.Filters, CommonConst.ASC)
    self:BindSortListEvents()
end

function M:OnSelectionsChanged()
    DebugPrint("WBP_Impression_Shop_P:OnSelectionsChanged")
    self:UpdateSortList()
end

function M:OnSortTypeChanged()
    DebugPrint("WBP_Impression_Shop_P:OnSortTypeChanged")
    self:UpdateSortList()
end

function M:GetAllAvailableImpressionShopItemDatas(CheckFunc)
    local ShopItems = {}
    for _,v in pairs(DataMgr.ImpressionShop) do
        if (not CheckFunc) or (CheckFunc(v)) then
            table.insert(ShopItems, setmetatable({}, {
                __index = v })
            )
        end
    end

    return ShopItems
end

-- 添加额外商品数据，包括：
-- 1. bUnlocked: 是否解锁,0代表已解锁，1代表未解锁
-- 2. Rarity: 稀有度,默认为1
-- 3. ItemSeq: 排序优先级，若未填默认为0
function M:ProcessShopItemData(ItemInfos)
    for _,ItemInfo in pairs(ItemInfos)do
        ItemInfo.bUnlocked = ItemInfo.bUnlocked or self:CheckShopItemUnlocked(ItemInfo) 
        ItemInfo.Rarity = ItemInfo.Rarity or self:GetItemRarity(ItemInfo.ItemType,ItemInfo.ItemId,1)
        ItemInfo.ItemSeq = ItemInfo.ItemSeq or 0
    end
end

function M:CheckShopItemUnlocked(ItemInfo)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    return ConditionUtils.CheckCondition(Avatar, ItemInfo.UnlockCondition, false)
end

function M:AddOrRefreshShopItemSoldOut(ShopItemDatas)
    local Avatar = GWorld:GetAvatar()
    for _,ItemData in pairs(ShopItemDatas) do
        if Avatar then
            local Info = Avatar.ImpressionShops[ItemData.ImpressionShopId]
            local bSoldOut = false
            if Info then
                bSoldOut = ItemData.PurchaseLimit and Info.AlreadyPurchaseTimes >= ItemData.PurchaseLimit or false
            else
                bSoldOut = true
            end
            ItemData.bSoldOut = bSoldOut 
            ItemData.bNotSoldOut = not bSoldOut 
        else
            ItemData.bSoldOut = true
        end
    end
end

function M:OnShopItemSold()
    self:UpdateShopDetail()
end

function M:UpdateSortList(SubTabData)
    SubTabData = SubTabData or self.CachedSubTabData
    self.CachedSubTabData = SubTabData
    local Avatar = GWorld:GetAvatar()
    local GetShopItemCheckFunc = function(ShopItemData)
        if ShopItemData.RegionId ~= self.RegionId then
            return false
        end
        if ShopItemData.SubTabId ~= SubTabData.SubTabId then
            return false
        end
        if ShopItemData.ConditionId and not ConditionUtils.CheckCondition(Avatar, ShopItemData.ConditionId) then
            return false
        end
        return true
    end
    local ItemInfos = self:GetAllAvailableImpressionShopItemDatas(GetShopItemCheckFunc)
    local Filter1, SortType = self.Common_SortList_PC:GetSortInfos()

    self:ProcessShopItemData(ItemInfos)
    self:AddOrRefreshShopItemSoldOut(ItemInfos)

    local SortFunc
    local bReverse = SortType ~= CommonConst.ASC
    DebugPrint("WBP_Impression_Shop_P:UpdateSortList ",SortType,Filter1,bReverse, self.bFilterOwned)
    if Filter1 == 1 then
        -- 一级排序：未售罄>解锁
        -- 二级排序：排序优先级>商品ID
        SortFunc = function(A, B)
            if self:SortByBoolField(A, B, 'bNotSoldOut',bReverse) then 
                return true
            elseif self:SortByBoolField(B, A, 'bNotSoldOut',bReverse) then 
                return false
            elseif self:SortByBoolField(A, B, 'bUnlocked',bReverse) then 
                return true
            elseif self:SortByBoolField(B, A, 'bUnlocked',bReverse) then 
                return false 
            elseif self:SortByFloatField(A, B, 'ItemSeq',not bReverse) then 
                return true
            elseif self:SortByFloatField(B, A, 'ItemSeq',not bReverse) then 
                return false
            else 
                return self:SortByFloatField(A, B, 'ImpressionShopId', bReverse)
            end
        end
    elseif Filter1 == 2 then
        -- 一级排序：未售罄>稀有度>解锁
        -- 二级排序：排序优先级>商品ID
        SortFunc = function(A, B)
            if self:SortByBoolField(A, B, 'bNotSoldOut',bReverse) then 
                return true
            elseif self:SortByBoolField(B, A, 'bNotSoldOut',bReverse) then 
                return false
            elseif self:SortByFloatField(A, B, 'Rarity',not bReverse) then 
                return true
            elseif self:SortByFloatField(B, A, 'Rarity',not bReverse) then 
                return false
            elseif self:SortByBoolField(A, B, 'bUnlocked',bReverse) then 
                return true
            elseif self:SortByBoolField(B, A, 'bUnlocked',bReverse) then 
                return false 
            elseif self:SortByFloatField(A, B, 'ItemSeq',not bReverse) then 
                return true
            elseif self:SortByFloatField(B, A, 'ItemSeq',not bReverse) then 
                return false
            else 
                return self:SortByFloatField(A, B, 'ImpressionShopId', bReverse)
            end
        end
    end

    table.sort(ItemInfos, SortFunc)

    local ShopDataList = {}
    for _, ItemData in pairs(ItemInfos) do
        if self.bFilterOwned then
            local bOwn = self:CheckSelfOwnShopItem(ItemData,true)
            if not bOwn then
                table.insert(ShopDataList,ItemData)
            end
        else
            table.insert(ShopDataList, ItemData)
        end
    end

    self.List_Item:ScrollIndexIntoView(0)
    self:StopAttrListFramingIn()
    self.List_Item:ClearListItems()
    self.ShopItemNum = #ShopDataList
    self.ShopItemContentsMap = {}
    --需要修改为对应印象商店Item的加载
    for i = 1, self.ShopItemNum do
        local ShopData = ShopDataList[i]
        local Content = NewObject(self.ShopItemContentClass)
        Content.ShopItemData = ShopData
        Content.ShopUI = self
        self.List_Item:AddItem(Content)
        self.ShopItemContentsMap[ShopData.ImpressionShopId] = Content
    end
    local XAnchor = (CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile") and 0 or 0.5
    self:HorizontalListViewResize_SetUp(self.Group_Item, self.List_Item, XAnchor)
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    if self.ShopItemNum == 0 then
        GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    else
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
        end
    end
    self:AddTimer(0.01, function()
        local XCount, YCount = UIUtils.GetTileViewContentMaxCount(self.List_Item, "XY")
        local EmptyItemNum
        if (self.ShopItemNum - XCount * YCount <= 0) then
            EmptyItemNum = XCount * YCount - self.ShopItemNum
        else
            EmptyItemNum = XCount - self.ShopItemNum % XCount
        end

        for i = 1, EmptyItemNum do
            local Content = NewObject(self.ShopItemContentClass)
            Content.ShopId = nil
            self.List_Item:AddItem(Content)
            self.List_Item:RegenerateAllEntries()
        end
        if not (CommonUtils:IfExistSystemGuideUI(self)) then
            self:SetFocus_Lua()
        end
        self:AddTimer(0.01, function()
            self:PlayAttrListFramingIn()
        end)
    end)
end

function M:PlayAttrListFramingIn()
    self.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self._ListAttrAnimTimerKeys = UIUtils.PlayListViewFramingInAnimation(self, self.List_Item, {
        Interval = self.IntervalTime, Visibility=UIConst.VisibilityOp.Visible, Callback = function()
        self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
    end})
end

function M:StopAttrListFramingIn()
    UIUtils.StopListViewFramingInAnimation(self.List_Item, {UIState=self, TimerKeys=self._ListAttrAnimTimerKeys})
end

--- 初始化商店商品信息
---@param SubTabData table @子页签数据
function M:UpdateShopDetail(SubTabData)
    self:UpdateSortList(SubTabData)
end

function M:OnReturnKeyDown()
    self:CloseSelf()
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:Close()
    elseif InAnimation == self.In then
        self:BindButtonEvents()
        if self.SelectItemId then
            self:BlockAllUIInput(true, "SP_DisplayOnly")
            self:AddTimer(0.1, function()
                self:BlockAllUIInput(false)
                self:ShowItemDetail()
            end, false, 0, "OpenShopItemDialog", true)
        end
    end
end

function M:Close()
    DebugPrint("WBP_Impression_Shop_P:Close")
    self:HorizontalListViewResize_TearDown()
    self:PlayCloseAudio()
    M.Super.Close(self)
end

function M:ReceiveEnterState(StackAction)
    if StackAction == 1 then
        self:RefreshImpressionList()
    end
    M.Super.ReceiveEnterState(self, StackAction)
end

function M:RefreshImpressionList()
    self.List_Item:RegenerateAllEntries()
end

function M:ReceiveExitState(StackAction)
    self:CloseItemDetail()
    M.Super.ReceiveExitState(self, StackAction)
end

function M:IsShopItemUnlocked(ShopItemData)
    return ShopItemData.bUnlocked
end

function M:IsShopItemSoldOut(ShopItemData)
    return ShopItemData.bSoldOut
end

function M:GetShopItemNum(ShopItemData)
    local AvailableTime, LimitTime = 0, 0
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        local Info = Avatar.ImpressionShops[ShopItemData.ImpressionShopId]
        if Info then
            LimitTime = ShopItemData.PurchaseLimit
            AvailableTime = LimitTime - Info.AlreadyPurchaseTimes
        end
    end
    return AvailableTime, LimitTime
end

function M:CheckSelfOwnShopItem(ShopItemData, bForceRefresh)
    if (ShopItemData.bOwn ~= nil) and (not bForceRefresh) then
        return ShopItemData.bOwn
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end

    local NetData = Avatar[ShopItemData.ItemType .. "s"]
    if NetData then
        for _, Data in pairs(NetData) do
            local ItemId = Data[ShopItemData.ItemType .. "Id"] or Data.AccessoryId
            if ItemId == ShopItemData.ItemId then
                return true
            end
        end
    end
    return false
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
    return M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
end

AssembleComponents(M)
return M

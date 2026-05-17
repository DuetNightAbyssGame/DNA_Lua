--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE 2024年3月7日
--
require "UnLua"
local MiscUtils = require "Utils.MiscUtils"
---@class WBP_Shop_Main_Base_C
local M = Class("BluePrints.UI.BP_UIState_C")

--- 初始化商店页签信息
---@param MainTabIdx number @主页签索引
---@param SubTabIdx number @子页签索引
---@param ShopType number @商店类型[0:普通商店,1:肉鸽刻印商店,2:印象商店, 3肉鸽宝物商店]
function M:InitShopTabInfo(MainTabIdx, SubTabIdx, ShopType)
    --- 主页签数据表名
    ---@type string
    self.MainTabData = "ShopTabMain"
    --- 子页签数据表名
    ---@type string
    self.SubTabData = "ShopTabSub"
    self.ShopType = ShopType
    if ShopType == 1 then
        self.MainTabData = "RougeBlessingShop"
        self.SubTabData = nil
    elseif ShopType == 3 then
        self.MainTabData = "RougeTreasureShop"
        self.SubTabData = nil
    elseif ShopType == 2 then
        self.MainTabData = "ImpressionShopMainTab"
        self.SubTabData = "ImpressionShopSubTab"
    end
    local TabList = {}
    self.MainTabMap = {}
    for _, ShopMainTabData in MiscUtils.PairsByKeys(DataMgr[self.MainTabData]) do
        local MainTab = 
        {
            Text = GText(ShopMainTabData.MainName),
            TabId = ShopMainTabData.MainTabId,
            IconPath = ShopMainTabData.Icon,
        }
        table.insert(TabList, MainTab)
    end
    table.sort(TabList, function(a, b)
        return a.TabId < b.TabId
    end)
    for _, Tab in ipairs(TabList) do
        table.insert(self.MainTabMap, Tab.TabId)
    end

    local SubTabDict = {}
    local SubTabMapIdx = {}
    if self.SubTabData then
        for SubTabId, Data in MiscUtils.PairsByKeys(DataMgr[self.SubTabData]) do
            if not SubTabDict[Data.MainTabId] then
                SubTabDict[Data.MainTabId] = 1
            else
                SubTabDict[Data.MainTabId] = SubTabDict[Data.MainTabId] + 1
            end
            SubTabMapIdx[SubTabId] = SubTabDict[Data.MainTabId]
        end
    end

    local OverridenTopResouces = nil
    if (type(self.GetOverrideTopResource) == "function") then
        OverridenTopResouces = self:GetOverrideTopResource()
    end
    if ShopType == 0 then
        self.Common_Tab:Init({LeftKey="Q", RightKey="E", Tabs = TabList, 
        DynamicNode={"Back", "ResourceBar", "BottomKey",}, 
        BottomKeyInfo = { {KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                           GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")} },
        StyleName="Text",
        TitleName=GText("MAIN_UI_SHOP"),
        OverridenTopResouces = OverridenTopResouces,
        OwnerPanel=self,
        BackCallback=self.CloseSelf})
    elseif ShopType == 1 or ShopType == 3 then
        self.Common_Tab:Init(
        { 
            LeftKey = "Q", RightKey = "E", Tabs = TabList, DynamicNode = { "Back", "ResourceBar", "BottomKey" }, 
            BottomKeyInfo = { { KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, Desc = GText("UI_BACK"), bLongPress = false}},
            TitleName=GText("MAIN_UI_SHOP"),
            OverridenTopResouces = OverridenTopResouces,
            OwnerPanel = self,
            BackCallback = self.CloseSelf,
        }, true)
    elseif ShopType == 2 then
        self.MainTabMap = {}
        local FilteredTabList = {}
        local Avatar = GWorld:GetAvatar()
        local TitleText = "UI_ImpressionShop_ShopName"
        local ShopInfos = DataMgr.ImpressionShopInfo
        for _, TabInfo in ipairs(TabList) do
            local RegionId = DataMgr[self.MainTabData][TabInfo.TabId].RegionId
            local ImprShopInfo = ShopInfos[RegionId]
            if ConditionUtils.CheckCondition(Avatar, ImprShopInfo.ShopUnlockRuleId) then
                table.insert(FilteredTabList, TabInfo)
                table.insert(self.MainTabMap, TabInfo.TabId)
            end
        end
        self.Common_Tab:Init({LeftKey="Q", RightKey="E",Tabs = FilteredTabList, --ForceHideTabs = true, 
        DynamicNode={"Back", "ResourceBar", "BottomKey",}, 
        BottomKeyInfo = { {KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                           GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")} },
        StyleName="Text",
        TitleName= GText(TitleText),
        OverridenTopResouces = OverridenTopResouces,
        OwnerPanel=self,
        BackCallback=self.CloseSelf})
    end
    self.Common_Tab:BindEventOnTabSelected(self, self.OnMainTabChanged)
    if not MainTabIdx then
        self.Common_Tab:SelectTab(1)
    else
        self.Common_Tab:SelectTab(MainTabIdx)
        if self.Common_Toggle_TabGroup_PC then
            self.Common_Toggle_TabGroup_PC:SelectTab(SubTabMapIdx[SubTabIdx])
        end
    end
end

--- 主页签切换回调方法
---@param TabWidget Common_Tab_Item_PC_C
function M:OnMainTabChanged(TabWidget)
    local MainTabId = self.MainTabMap[TabWidget.Idx]
    if not MainTabId then
        return
    end
    self:CleanTimer()
    local SubTabList = {}
    self.SubTabMap = {}
    for _, ShopSubTabData in MiscUtils.PairsByKeys(DataMgr[self.SubTabData]) do
        if ShopSubTabData.MainTabId == MainTabId then
            local SubTab = 
            {
                Text = GText(ShopSubTabData.SubName),
                Img = ShopSubTabData.Icon,
                TabId = ShopSubTabData.SubTabId,
                Data = ShopSubTabData
            }
            table.insert(SubTabList, SubTab)
        end
    end
    table.sort(SubTabList, function(a, b)
        return a.TabId < b.TabId
    end)
    for _, Tab in ipairs(SubTabList) do
        table.insert(self.SubTabMap, Tab.Data)
    end
    if self.Common_Toggle_TabGroup_PC then
        self.Common_Toggle_TabGroup_PC:Init( { 
            LeftKey = "A", 
            RightKey = "D",
            Tabs = SubTabList 
        } )
        self.Common_Toggle_TabGroup_PC:BindEventOnTabSelected(self, self.OnSubTabChanged)
        self.Common_Toggle_TabGroup_PC:SelectTab(1)
        if #SubTabList <= 1 then
            self.Common_Toggle_TabGroup_PC:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Common_Toggle_TabGroup_PC:SetVisibility(ESlateVisibility.Visible)
        end
    end
end

---@param TabWidget Common_Tab_Item_PC_C
function M:OnSubTabChanged(TabWidget)
    local SubTabData = self.SubTabMap[TabWidget.Idx]
    if not SubTabData then
        return
    end
    self:CleanTimer()
    self.CurSubTabMap = SubTabData
    --- 普通商城初始化
    if self.ShopType == "Shop" then
        EventManager:FireEvent(EventID.OnMenuClose)
        if SubTabData.TabCoin then
            self.TabCoinInfo = SubTabData.TabCoin
        else
            self.TabCoinInfo = DataMgr.SystemUI["ShopMain"].TabCoin
        end
        self.Common_Tab:OverrideTopResource(self.TabCoinInfo)
        self.Common_Tab:ResetDynamicNode()
        self:UpdateShopDetail(self.CurSubTabMap)
    --- 肉鸽商城初始化
    elseif self.ShopType == 1 or self.ShopType == 3 then
        self:UpdateShopDetail(self.CurSubTabMap, false, true)
    elseif self.ShopType == 2 then
        self:UpdateShopDetail(self.CurSubTabMap, false, true)
    end
end

--- 填充商品空余格子
---@param ItemName string @商品Item名
---@param CurrentItemList  @当前商品Item列表
-- function M:FillWrapBoxContent(ItemName, CurrentItemList)
--     local function GetWrapBoxSize()
--         local ScrollBoxSize = USlateBlueprintLibrary.GetLocalSize(self.ScrollBox_Item:GetCachedGeometry())
--         if ScrollBoxSize.X == 0 then
--             return FVector2D(0, 0)
--         end
--         local WrapBoxPadding = self.WrapBox_ShopItems.Slot.Padding
--         local ScrollBoxPadding = self.ScrollBox_Item.ScrollbarPadding
--         return FVector2D(ScrollBoxSize.X - WrapBoxPadding.Left - WrapBoxPadding.Right - ScrollBoxPadding.Left - ScrollBoxPadding.Right, ScrollBoxSize.Y - WrapBoxPadding.Top - WrapBoxPadding.Bottom - ScrollBoxPadding.Top - ScrollBoxPadding.Bottom)
--     end

--     local InnerSlotPadding = self.WrapBox_ShopItems.InnerSlotPadding
--     local WrapBoxSize = GetWrapBoxSize()
--     local function FillWrapBoxFunc()
--         if WrapBoxSize.X == 0 then
--             return false
--         end
--         ---@type Shop_Item_PC_C
--         local ShopItem
--         if self.WrapBox_ShopItems:GetChildrenCount() > 0 then
--             ShopItem = self.WrapBox_ShopItems:GetChildAt(0)
--         else
--             ShopItem = self:CreateWidgetNew(ItemName)
--             ShopItem:InitEmptyItem()
--             self.WrapBox_ShopItems:AddChild(ShopItem)
--         end
--         local ItemSize = USlateBlueprintLibrary.GetLocalSize(ShopItem:GetCachedGeometry())
--         if ItemSize.X == 0 then
--             return false
--         end
--         local CurrentItemCount = #CurrentItemList
--         local XCount = math.floor((WrapBoxSize.X - InnerSlotPadding.X) / (ItemSize.X + InnerSlotPadding.X))
--         local YCount = math.floor(WrapBoxSize.Y / (ItemSize.Y + InnerSlotPadding.Y)) + 1
--         YCount = math.max(YCount, (CurrentItemCount - 1) // XCount + 1)
--         if self.IntervalTime then
--             for i = 1, YCount do
--                 self:AddTimer(self.IntervalTime * (i - 1), function()
--                     for j = 1, XCount do
--                         local Count = (i-1) * XCount + j
--                         ---@type Shop_Item_PC_C
--                         local ShopItem
--                         if Count <= CurrentItemCount then
--                             ShopItem = CurrentItemList[Count]
--                         else
--                             ShopItem = self:CreateWidgetNew(ItemName)
--                             ShopItem:InitEmptyItem()
--                         end
--                         ShopItem:PlayAnimation(ShopItem.In)
--                         self.WrapBox_ShopItems:AddChild(ShopItem)
--                     end
--                 end, false, 0, nil, true)
--             end
--         end
--         if math.ceil(CurrentItemCount / XCount) < YCount then
--             self.ScrollBox_Item:SetScrollBarVisibility(ESlateVisibility.Hidden)
--         else
--             self.ScrollBox_Item:SetScrollBarVisibility(ESlateVisibility.Visible)
--         end
--         return true
--     end
--     if FillWrapBoxFunc() then
--         return
--     end
--     local TimerFunc = function()
--         WrapBoxSize = GetWrapBoxSize()
--         if FillWrapBoxFunc() then
--             self:RemoveTimer("FillWrapBoxTimer")
--             return true
--         end
--         return false
--     end
--     self:AddTimer(0.01, TimerFunc, true, nil, "FillWrapBoxTimer")
-- end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "Escape" then
            if not UIManager(self):GetUIObj("CommonDialog") and not self.bCannotResponseEscape then
                IsEventHandled = true
                self:CloseSelf()
            end
        elseif InKeyName == "Q" then
            IsEventHandled = true
            self.Common_Tab:TabToLeft()
        elseif InKeyName == "E" then
            IsEventHandled = true
            self.Common_Tab:TabToRight()
        elseif InKeyName == "A" then
            if self.Common_Toggle_TabGroup_PC then
                IsEventHandled = true
                self.Common_Toggle_TabGroup_PC:TabToLeft()
            end
        elseif InKeyName == "D" then
            if self.Common_Toggle_TabGroup_PC then
                IsEventHandled = true
                self.Common_Toggle_TabGroup_PC:TabToRight()
            end
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
    if InKeyName == "Gamepad_LeftTrigger" or InKeyName == "Gamepad_RightTrigger"  then
        if self.Common_Toggle_TabGroup_PC then
            IsEventHandled = self.Common_Toggle_TabGroup_PC:Handle_KeyEventOnGamePad(InKeyName)
        end
    else
        IsEventHandled = self.Common_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
    return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDevice = CurInputDevice
    M.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:SetFocus_Lua()
    return UIUtils.Handle
end

function M:SetFocus_Lua()
    --子类中实现
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType())
end

----------------排序函数-------------------
function M:SortByFloatField(ItemA, ItemB, Field, bReverse)
    if ItemA[Field] == nil then
        DebugPrint("Error: 使用了未知的字段用于比较商品",Field)
        return false
    end

    local bRes = false
    if bReverse then
        bRes = ItemA[Field] > ItemB[Field]
    else
        bRes = ItemA[Field] < ItemB[Field]
    end
    --DebugPrint("SortByField ",Field,ItemA[Field],ItemB[Field],bRes)
    return bRes
end

function M:SortByBoolField(ItemA, ItemB, Field, bReverse)
    local bRes = false
    if ((ItemA[Field]) and (not ItemB[Field])) then
        bRes = true
    end
    if bReverse then
        bRes = (ItemB[Field]) and (not ItemA[Field]) 
    else
        bRes = (ItemA[Field]) and (not ItemB[Field]) 
    end
    --DebugPrint("SortByField ",Field,ItemA[Field],ItemB[Field],bRes)
    return bRes
end

----------------排序函数-------------------

function M:GetItemRarity(ItemType,ItemId,DefaultRarity)
    local Rarity =  DataMgr[ItemType][ItemId].Rarity or 
                    DataMgr[ItemType][ItemId].WeaponRarity or
                    DataMgr[ItemType][ItemId].CharRarity or 
                    DefaultRarity or 1
    
    return Rarity

end

return M

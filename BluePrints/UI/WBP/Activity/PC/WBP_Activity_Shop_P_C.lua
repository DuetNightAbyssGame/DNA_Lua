require "UnLua"
local MiscUtils = require "Utils.MiscUtils"

---@class Activity_Shop_PC_C:WBP_Shop_Main_Base_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
    self.Super.OnLoaded(self)
    self.bIsFocusable = true
    self.Filters = { "UI_Select_Default", "UI_Select_Time", "UI_RARITY_NAME", "UI_PRICE_NAME" }
    self.MainTabMap = {}
    self.SubTabMap = {}
    self.bFilterOwned = false
    local MainTabIdx, ShopItemId, ShopSystemName, ShopSystemName1, CloseCallBack, ClsoeCallBackObj = ...
    if ShopSystemName == nil or ShopSystemName == "nil" then
        ShopSystemName = ShopSystemName1
    end
    self.SelectShopItemId = ShopItemId
    self.List_Item:SetVisibility(ESlateVisibility.Visible)
    self:InitShop(MainTabIdx, ShopItemId, ShopSystemName, CloseCallBack, ClsoeCallBackObj)
end

function M:Construct()
    M.Super.Construct(self)
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(self.ShopItemContentClass)
        Content.ShopId = nil
        return Content
    end)

    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
        self:AddTimer(0.1, function()
            self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        end)
        self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    end
    self:SetFocus()
    self.Text_ShopItemEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
    self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
    self:BindToAnimationFinished(self.In,{self, self.OnInAnimationFinished})
end

function M:OnInAnimationFinished()
    self:RefreshUI()
end

function M:OnPurchaseShopItem(Ret)
    self:BlockAllUIInput(false)
    self:RefreshShopDetail(self.nowIndex)
end

function M:InitShop(MainTabIdx, ShopItemId, ShopType, CloseCallBack, ClsoeCallBackObj)
    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    if IsValid(PlayerController) then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            PlayerController.bShowMouseCursor = true
        else
            PlayerController.bShowMouseCursor = false
        end
    end
    -- local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    -- Player:SetCanInteractiveTrigger(false)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "OpenShopMain", nil)
    if not ShopType then
        DebugPrint("ShopType缺失")
        ShopType = "Shop"
    end
    self:PlayAnimation(self.In)
    self.Common_SortList_PC:Init(self,self.Filters, CommonConst.ASC)
    self.Common_SortList_PC:BindEventOnSelectionsChanged(self, self.BindEventOnSelectionsChanged)
    self.Common_SortList_PC:BindEventOnSortTypeChanged(self, self.BindEventOnSortTypeChanged)
    self.SelectShopItemId = ShopItemId
    self.CloseCallBack = CloseCallBack
    self.ClsoeCallBackObj = ClsoeCallBackObj
    self:InitShopTabInfo(MainTabIdx, ShopType)
    self:InitShopBG(ShopType)
    self:RefreshShopDetail(1)
end

function M:InitShopBG(ShopType)
    -- 商店类型对应的背景路径
    local bgPathMap = {
        ["ZhiLiuEntrust"] = "/Game/UI/WBP/Activity/Widget/Shop/ShopBG/WBP_Activity_Shop_BG_ZhiliuEvent.WBP_Activity_Shop_BG_ZhiliuEvent"
        -- 可以在这里添加更多的商店类型和对应的背景路径
    }
    -- 获取背景路径，如果没有对应的则使用默认背景
    local bgPath = bgPathMap[ShopType] or bgPathMap["ZhiLiuEntrust"]
    local WidgetClass = LoadClass(bgPath)
    self.Group_BG:ClearChildren()
    if WidgetClass then
        local Widget = UE4.UWidgetBlueprintLibrary.Create(self, WidgetClass)
        self.Group_BG:AddChild(Widget)
        local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
        OverlaySlot:SetPadding(FMargin(0,0,0,0))
        OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        Widget:PlayAnimation(Widget.In)
    else
        DebugPrint("Error: 无法加载商店背景: " .. bgPath)
    end
end

--- 初始化商店页签信息
---@param MainTabIdx number @主页签索引
---@param ShopType number @商店类型[Shop表中SystemName]
function M:InitShopTabInfo(MainTabIdx, ShopType)
    --- 主页签数据表名
    ---@type string
    self.MainTabData = "ShopTabMain"
    --- 子页签数据表名
    ---@type string
    self.SubTabData = "ShopTabSub"
    self.ShopType = ShopType

    local MainShopTabData = DataMgr.Shop[ShopType]
    assert(MainShopTabData, "获取商店类型信息失败:"..ShopType)

    local TabList = {}
    self.MainTabMap = {}
    local MainTabs = {}
    for _, MainTabId in ipairs(MainShopTabData.MainTabId) do
        local ShopMainTabData = DataMgr.ShopTabMain[MainTabId]
        local MainTab = 
        {
            Text = GText(ShopMainTabData.MainName),
            TabId = ShopMainTabData.MainTabId,
            IconPath = ShopMainTabData.Icon,
        }
        table.insert(TabList, MainTab)
    end

    for i, Tab in ipairs(TabList) do
        MainTabs[Tab.TabId] = i
        table.insert(self.MainTabMap, Tab.TabId)
    end

    if ModController:IsMobile() then
        self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_Tab_M:Init({
            DynamicNode={"Back", "ResourceBar", "BottomKey",},
            StyleName="Text",
            TitleName=GText("MAIN_UI_SHOP"),
            OwnerPanel=self,
            BackCallback=self.CloseSelf})
        return
    end
    self.Com_Tab_P:Init({
        DynamicNode={"Back", "ResourceBar", "BottomKey",},
        Tabs = TabList,
        BottomKeyInfo = {
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        },
        StyleName="Text",
        TitleName=GText("MAIN_UI_SHOP"),
        OwnerPanel=self,
        BackCallback=self.CloseSelf})
    self.Com_Tab_P.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
    self.Com_KeyTips:UpdateKeyInfo({
        {
            KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
            GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, 
            Desc=GText("UI_BACK")
        },
    })
    self.Com_Tab_P:BindEventOnTabSelected(self, self.OnMainTabChanged)
    self.Com_Tab_P:SelectTab(1)
    if not MainTabIdx then
        self.Com_Tab_P:SelectTab(1)
    else
        self.Com_Tab_P:SelectTab(MainTabs[MainTabIdx])
    end
    if #TabList <= 1 then
        self.Com_Tab_P.Key_Left:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_Tab_P.Key_Right:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Com_Tab_P.Key_Left:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Com_Tab_P.Key_Right:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

--- 主页签切换回调方法
---@param TabWidget Common_Tab_Item_PC_C
function M:OnMainTabChanged(TabWidget)
    self:RefreshShopDetail(TabWidget.Idx)
end

function M:RefreshShopDetail(index)
    self.nowIndex = index
    local MainTabId = self.MainTabMap[index]
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
    local SubTabData = self.SubTabMap[1]
    if not SubTabData then
        return
    end
    self:CleanTimer()
    self.CurSubTabMap = SubTabData
    if SubTabData.TabCoin then
        self.TabCoinInfo = SubTabData.TabCoin
    else
        self.TabCoinInfo = DataMgr.SystemUI["ShopMain"].TabCoin
    end
    if not ModController:IsMobile() then
        self.Com_Tab_P:OverrideTopResource(self.TabCoinInfo)
        self.Com_Tab_P:ResetDynamicNode()
    else
        self.Com_Tab_M:OverrideTopResource(self.TabCoinInfo)
        self.Com_Tab_M:ResetDynamicNode()
    end
    self:UpdateShopDetail(self.CurSubTabMap)
end

function M:UpdateShopDetail(SubTabData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self:SetTabReddot(self.ShopType)

    local Filter1, SortType = self.Common_SortList_PC:GetSortInfos()
    local ShopDataList = {}
    for ShopItemId, ShopData in pairs(DataMgr.ShopItem) do
        if ShopData.SubTabId == SubTabData.SubTabId and ShopUtils:GetShopItemCanShow(ShopItemId) then
            if not self.bFilterOwned then
                table.insert(ShopDataList, ShopData)
            else
                if ShopData.ItemType == "Reward" then
                    table.insert(ShopDataList, ShopData)
                else
                    local NetData = Avatar[ShopData.ItemType .. "s"]
                    if NetData then
                        local bOwn = false
                        for _, Data in pairs(NetData) do
                            local ItemId = Data[ShopData.ItemType .. "Id"] or Data.AccessoryId
                            if ItemId == ShopData.TypeId then
                                bOwn = true
                                break
                            end
                        end
                        if not bOwn then
                            table.insert(ShopDataList, ShopData)
                        end
                    end
                end
            end
        end
    end
    local SortFunc
    local SortBySequence = function(a, b)
        if SortType == CommonConst.ASC then
            if a.Sequence == b.Sequence then
                return a.ItemId > b.ItemId
            end
            return a.Sequence > b.Sequence
        else
            return a.Sequence < b.Sequence
        end
    end
    local SortFuncByTime = function(a, b)
        if SortType == CommonConst.ASC then
            return a.StartTime < b.StartTime
        else
            return a.StartTime > b.StartTime
        end
    end
    local SortFuncByRarity = function(a, b)
        local ItemDataA = DataMgr[a.ItemType][a.TypeId]
        local ItemDataB = DataMgr[b.ItemType][b.TypeId]
        local RarityA = ItemDataA.Rarity or ItemDataA.WeaponRarity or 1
        local RarityB = ItemDataB.Rarity or ItemDataB.WeaponRarity or 1
        if SortType == CommonConst.ASC then
            return RarityA < RarityB
        else
            return RarityA > RarityB
        end
    end
    local SortFuncByPrice = function(a, b)
        if SortType == CommonConst.ASC then
            return ShopUtils:GetShopItemPrice(a.ItemId) < ShopUtils:GetShopItemPrice(b.ItemId)
        else
            return ShopUtils:GetShopItemPrice(a.ItemId) > ShopUtils:GetShopItemPrice(b.ItemId)
        end
    end
    if Filter1 == 1 then
        -- Sequence>时间>稀有度>价格
        SortFunc = function(a, b)
            if SortBySequence(a, b) then
                return true
            elseif SortBySequence(b, a) then
                return false
            elseif SortFuncByTime(a, b) then
                return true
            elseif SortFuncByTime(b, a) then
                return false
            elseif SortFuncByRarity(a, b) then
                return true
            elseif SortFuncByRarity(b, a) then
                return false
            elseif SortFuncByPrice(a, b) then
                return true
            elseif SortFuncByPrice(b, a) then
                return false
            else
                return false
            end
        end
    elseif Filter1 == 3 then
        -- 稀有度>Sequence>时间>价格
        SortFunc = function(a, b)
            if SortFuncByRarity(a, b) then
                return true
            elseif SortFuncByRarity(b, a) then
                return false
            elseif SortBySequence(a, b) then
                return true
            elseif SortBySequence(b, a) then
                return false
            elseif SortFuncByTime(a, b) then
                return true
            elseif SortFuncByTime(b, a) then
                return false
            elseif SortFuncByPrice(a, b) then
                return true
            elseif SortFuncByPrice(b, a) then
                return false
            else
                return false
            end
        end
    elseif Filter1 == 2 then
        -- 时间>Sequence>稀有度>价格
        SortFunc = function(a, b)
            if SortFuncByTime(a, b) then
                return true
            elseif SortFuncByTime(b, a) then
                return false
            elseif SortBySequence(a, b) then
                return true
            elseif SortBySequence(b, a) then
                return false
            elseif SortFuncByRarity(a, b) then
                return true
            elseif SortFuncByRarity(b, a) then
                return false
            elseif SortFuncByPrice(a, b) then
                return true
            elseif SortFuncByPrice(b, a) then
                return false
            else
                return false
            end
        end
    else
        -- 价格>Sequence>时间>稀有度
        SortFunc = function(a, b)
            if SortFuncByPrice(a, b) then
                return true
            elseif SortFuncByPrice(b, a) then
                return false
            elseif SortBySequence(a, b) then
                return true
            elseif SortBySequence(b, a) then
                return false
            elseif SortFuncByTime(a, b) then
                return true
            elseif SortFuncByTime(b, a) then
                return false
            elseif SortFuncByRarity(a, b) then
                return true
            elseif SortFuncByRarity(b, a) then
                return false
            else
                return false
            end
        end
    end

    local NotSoldOutList = {}
    local SoldOutList = {}
    local LimitLevelList = {}

    for _, ShopData in pairs(ShopDataList) do
        local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ShopData.ItemId)
        if PurchaseLimit ~= 0 then
            local NeedLevel = ShopData.UnlockLevel or 0
            if Avatar.Level < NeedLevel then
                table.insert(LimitLevelList, ShopData)
            else
                table.insert(NotSoldOutList, ShopData)
            end
        else
            table.insert(SoldOutList, ShopData)
        end
    end

    table.sort(NotSoldOutList, SortFunc)
    table.sort(SoldOutList, SortFunc)
    table.sort(LimitLevelList, SortFunc)
    ShopDataList = {}
    for _, ShopData in ipairs(NotSoldOutList) do
        table.insert(ShopDataList, ShopData)
    end
    for _, ShopData in ipairs(LimitLevelList) do
        table.insert(ShopDataList, ShopData)
    end
    for _, ShopData in ipairs(SoldOutList) do
        table.insert(ShopDataList, ShopData)
    end

    self.List_Item:ScrollIndexIntoView(0)
    self.List_Item:ClearListItems()
    self.ShopItemNum = #ShopDataList
    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    if self.ShopItemNum == 0 then
        GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
        self.List_Item:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
            GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
        end
        self.List_Item:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
    end
    for i = 1, self.ShopItemNum do
        local ShopData = ShopDataList[i]
        local Content = NewObject(self.ShopItemContentClass)
        Content.ShopId = ShopData.ItemId
        Content.IsFree = ShopUtils:IsFree(ShopData.ItemId)
        self.List_Item:AddItem(Content)
    end
    self.List_Item:RequestFillEmptyContent()
    self.List_Item:RequestPlayEntriesAnim()
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    AudioManager(self):SetEventSoundParam(self, "OpenShopMain", {ToEnd = 1})
    self:PlayAnimation(self.Out)
    
    local AllBgCount = self.Group_BG:GetChildrenCount()
    for i = 1,AllBgCount,1 do
        local Child = self.Group_BG:GetChildAt(i - 1)
        Child:PlayAnimation(Child.Out)
    end
end

function M:Close()
    self.Super.Close(self)
    if self.CloseCallBack then
        self.CloseCallBack(self.ClsoeCallBackObj)
    end
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:Close()
    elseif InAnimation == self.In then
        if self.SelectShopItemId then
            self:AddTimer(0.01, function()
                self:ShowItemDetail()
                self.SelectShopItemId = nil
            end, false, 0, "OpenShopItemDialog", true)
        end
    end
end

function M:BindEventOnSelectionsChanged(Filter1, Filter2, Filter3, SortType)
    self:UpdateShopDetail(self.CurSubTabMap)
end

function M:BindEventOnSortTypeChanged(SortType)
    self:UpdateShopDetail(self.CurSubTabMap)
end

function M:Destruct()
    -- local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    -- if Player then
    --     Player:SetCanInteractiveTrigger(true)
    -- end
    self.List_Item.OnCreateEmptyContent:Unbind()
    self.Super.Destruct(self)
end

function M:ShowItemDetail()
    self.ShopItemData = setmetatable({}, {__index = DataMgr.ShopItem[self.SelectShopItemId]})
    if not self.ShopItemData or self.ShopItemData.TypeId == nil then
        return
    end
    local TypeId = self.ShopItemData.TypeId
    local ItemType = self.ShopItemData.ItemType
    AudioManager(self):PlayItemSound(self,TypeId,"Click",ItemType)
    local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.SelectShopItemId)
    local ItemData = DataMgr[ItemType][TypeId]
    local CommonPopupUIID
    if ItemType == "Reward" and (DataMgr.Reward[ItemData.RewardId].Mode == "Fixed" or DataMgr.Reward[ItemData.RewardId].Mode == "Once") then
        if RemainTimes == 0 then
            CommonPopupUIID = 100040
        else
            CommonPopupUIID = 100039
        end
    else
        if RemainTimes == 0 then
            CommonPopupUIID = 100042
        else
            CommonPopupUIID = 100041
        end
    end
    if not CommonPopupUIID then
        return
    end
    local Funds = {}
    Funds[1] = {}
    Funds[1].FundId = self.ShopItemData.PriceType
    Funds[1].FundNeed = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId)
    ---@type WBP_Common_Dialog_PC_C
    local CommonDialog = UIManager(self):ShowCommonPopupUI(CommonPopupUIID, { ShopItemData = self.ShopItemData, ShopType = 0, Funds = Funds, ShowParentTabCoin = true,
        LeftCallbackObj = self,
        LeftCallbackFunction = function(Obj, PackageData)
            local Shop = UIManager(self):GetUIObj("ActivityShop")
            if Shop then
                Shop:SetFocus()
            end
        end,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, PackageData)
            PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
        end,
        ForbiddenRightCallbackObj = self,
        ForbiddenRightCallbackFunction = function(Obj, PackageData)
            PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
        end,
        DontFocusParentWidget = true,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = function(Obj, PackageData)
            local Shop = UIManager(self):GetUIObj("ActivityShop")
            if Shop then
                Shop:SetFocus()
            end
        end,
        ForbidRightBtn = not ShopUtils:CanPurchase(self.ShopItemData, Funds[1].FundId, Funds[1].FundNeed)
    }, UIManager(self):GetUIObj("ActivityShop"))
end

--- 判断能否购买：失败原因：0:可购买 1:售罄 2:货币不足 3:等级限制
function M:CanPurchase(PriceType, Price)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    self.ShopItemData.PurchaseFailRes = 0
    local ShopItemRemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
    if ShopItemRemainTimes == 0 then
        self.ShopItemData.PurchaseFailRes = 1
        return false
    end
    if self.ShopItemData.UnlockLevel and Avatar.Level < self.ShopItemData.UnlockLevel then
        self.ShopItemData.PurchaseFailRes = 3
        return false
    end
    local PriceCount = Avatar.Resources[PriceType] and Avatar.Resources[PriceType].Count or 0
    if PriceCount < Price then
        self.ShopItemData.PurchaseFailRes = 2
        return false
    end
    return true
end

function M:SetTabReddot(ShopType)
    for _, MainTabId in pairs(DataMgr.Shop[ShopType].MainTabId) do
        local Data = DataMgr.ShopItem2ShopTab[MainTabId]
        local MainTabNeedReddot = false
        if Data then
            for SubTabId, ShopItemData in pairs(Data) do
                local SubTabNeedReddot = false
                for _, ItemId in pairs(ShopItemData) do
                    if ShopUtils:IsFree(ItemId) then
                        SubTabNeedReddot = true
                        MainTabNeedReddot = true
                        break
                    end
                end
            end
            if not ModController:IsMobile() then
                if MainTabNeedReddot then
                    self.Com_Tab_P:ShowTabRedDotByTabId(MainTabId, false, true, false)
                else
                    self.Com_Tab_P:ShowTabRedDotByTabId(MainTabId, false, false, false)
                end
            end
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "Escape" then
            if  not UIManager(self):GetUIObj("CommonDialog") and
                not self.bCannotResponseEscape then
                self:CloseSelf()
                IsEventHandled = true
            end
        elseif InKeyName == "Q" then
            self.Com_Tab_P:TabToLeft()
            IsEventHandled = true
        elseif InKeyName == "E" then
            self.Com_Tab_P:TabToRight()
            IsEventHandled = true
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_FaceButton_Right" and self.IsFocusInIcon) then
            self.List_Item:SetFocus()
            self.IsFocusInIcon = false
            IsHandled = true
        end
    end
    if InKeyName == "Escape" then
        if  not UIManager(self):GetUIObj("CommonDialog") and
            not self.bCannotResponseEscape then
            self:CloseSelf()
            IsHandled = true
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftTrigger" then
        self.Com_Tab_P:TabToLeft()
        IsEventHandled = true
    elseif InKeyName == "Gamepad_RightTrigger" then
        self.Com_Tab_P:TabToRight()
        IsEventHandled = true
    elseif InKeyName == "Gamepad_LeftThumbstick" then
        self.Common_SortList_PC:SetFocus()
    elseif InKeyName == "Gamepad_RightThumbstick" then
        if self.Com_Tab_P.WBP_Com_Tab_ResourceBar then
            self.Com_Tab_P.WBP_Com_Tab_ResourceBar:SetFocus()
        end
        self.IsFocusInIcon = true
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        self:CloseSelf()
    end
    return IsEventHandled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, 
                Desc=GText("UI_BACK")
            },
        })
    elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}}, 
                Desc=GText("UI_BACK")
            },
        })
    end
end

function M:SetFocus_Lua()
    self.List_Item:SetFocus()
end

function M:BP_GetDesiredFocusTarget()
    return self.List_Item
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        DebugPrint("thy    已经显示的是该输入模式，不需要进行刷新")
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName
    self.IsSwitchDevice = true
    --更新UI
    self:RefreshUI()
    if(self.CurInputDeviceType == ECommonInputType.Gamepad) then
        if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
            return
        end
        self.List_Item:SetFocus()
    end
end

function M:RefreshUI()
    if(self.CurInputDeviceType == ECommonInputType.Gamepad) then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}},
                Desc=GText("UI_BACK")
            },
        })
    elseif self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
        self.Com_KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                Desc=GText("UI_BACK")
            },
        })
    end
end

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE 2025年8月5日10:51:35
--
require "UnLua"
local MiscUtils = require "Utils.MiscUtils"

---@class WBP_Shop_Base_New_C
local M = Class("BluePrints.UI.BP_UIState_C")

--@param bBanAnimation 若进入商店前需要播放视频，设置bBanAnimation = true，禁用商店界面的动画
function M:InitShop(MainTabIdx, SubTabIdx, ShopItemId, ShopType, bBanAnimation)
    local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
    if IsValid(PlayerController) then
        if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
            PlayerController.bShowMouseCursor = true
        else
            PlayerController.bShowMouseCursor = false
        end
    end
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    Player:SetCanInteractiveTrigger(false)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "OpenShopMain", nil)
    if not ShopType then
        DebugPrint("ShopType缺失，ZDX_请对应系统接口负责人传入商城具体的SystemName")
        ShopType = "Shop"
    end
    self.ShopType = ShopType
    self.Common_SortList_PC:Init(self,self.Filters, CommonConst.ASC)
    self.Common_SortList_PC:BindEventOnSelectionsChanged(self, self.BindEventOnSelectionsChanged)
    self.Common_SortList_PC:BindEventOnSortTypeChanged(self, self.BindEventOnSortTypeChanged)
    self.SelectShopItemId = ShopItemId
    self:CommmonInitShop(MainTabIdx, SubTabIdx, ShopItemId, ShopType)
    self:InitShopTabInfo(MainTabIdx, SubTabIdx, ShopType)
    if not bBanAnimation then
        self:PlayAnimation(self.In)
        self:BlockAllUIInput(true,"SP_DisplayOnly")
    else
        -- 开头直接播放置顶视频的情况下，将动画直接快进到结束，避免偶现的UI无法显示的bug
        self:PlayAnimation(self.In, 0, 1, EUMGSequencePlayMode.Forward, 6e3, false)
        self:BlockAllUIInput(true,"SP_DisplayOnly")
    end
end

function M:CommmonInitShop(MainTabIdx, SubTabIdx, ShopItemId, ShopType)
    self.Group_BG:ClearChildren()
    local BGPath = DataMgr.Shop[ShopType].ShopBgBPPath
    if BGPath then
        local WidgetClass = LoadClass(BGPath)
        local Widget = UE4.UWidgetBlueprintLibrary.Create(self, WidgetClass)
        if Widget then
            self.Group_BG:AddChild(Widget)
            local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
            OverlaySlot:SetPadding(FMargin(0,0,0,0))
            OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            Widget:PlayAnimation(Widget.In)
        end
    end

end
function M:LoadShopTabInfo(MainShopTabData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self.MainTabList = {}
    self.MainTabMap = {}
    self.MainTabs = {}
    for _, MainTabId in ipairs(MainShopTabData.MainTabId) do
        if ShopUtils:IsCanOpenPay(true) then
            local ShopMainTabData = DataMgr.ShopTabMain[MainTabId]
            local MainTab = 
            {
                Text = GText(ShopMainTabData.MainName),
                TabId = ShopMainTabData.MainTabId,
                IconPath = ShopMainTabData.Icon,
            }
            if ShopMainTabData.ConditionId then
                MainTab.IsLocked = not Avatar.CheckUIUnlocked(Avatar, ShopMainTabData.ConditionId)
                MainTab.LockReasonText = GText(DataMgr.Condition[DataMgr.UIUnlockRule[ShopMainTabData.ConditionId].ConditionId].ConditionText)
            end
            if not MainTab.IsLocked or not ShopMainTabData.UnlockHide then
                table.insert(self.MainTabList, MainTab)
            end
        end
    end


    -- table.sort(TabList, function(a, b)
    --     return a.TabId < b.TabId
    -- end)
    for i, Tab in ipairs(self.MainTabList) do
        self.MainTabs[Tab.TabId] = i
        table.insert(self.MainTabMap, Tab.TabId)
    end

    local SubTabDict = {}
    self.SubTabMapIdx = {}
    for SubTabId, Data in MiscUtils.PairsByKeys(DataMgr.ShopTabSub) do
        if ShopUtils:IsCanOpenPay(true) then
            if self.MainTabs[Data.MainTabId] then
                if not SubTabDict[Data.MainTabId] then
                    SubTabDict[Data.MainTabId] = 1
                else
                    SubTabDict[Data.MainTabId] = SubTabDict[Data.MainTabId] + 1
                end
                self.SubTabMapIdx[SubTabId] = SubTabDict[Data.MainTabId]
            end
        end
    end

    self.OverridenTopResouces = nil
    if (type(self.GetOverrideTopResource) == "function") then
        self.OverridenTopResouces = self:GetOverrideTopResource()
    end
end


--- 加载对应主页签信息
---@param MainTabId number 主页签Id
function M:LoadMainTabInfo(MainTabId)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self:CleanTimer()
    self.SubTabList = {}
    self.SubTabMap = {}
    for _, ShopSubTabData in MiscUtils.PairsByKeys(DataMgr.ShopTabSub) do
        if ShopSubTabData.MainTabId == MainTabId then
            if ShopUtils:IsCanOpenPay(true) then
                local SubTab = 
                {
                    Text = GText(ShopSubTabData.SubName),
                    TabId = ShopSubTabData.SubTabId,
                    Data = ShopSubTabData,
                }
                if ShopSubTabData.ConditionId then
                    SubTab.IsLocked = not Avatar.CheckUIUnlocked(Avatar, ShopSubTabData.ConditionId)
                    SubTab.LockReasonText = GText(DataMgr.Condition[DataMgr.UIUnlockRule[ShopSubTabData.ConditionId].ConditionId].ConditionText)
                end
                if not SubTab.IsLocked or not ShopSubTabData.UnlockHide then
                    table.insert(self.SubTabList, SubTab)
                end
            end
        end
    end
    table.sort(self.SubTabList, function(a, b)
        return a.TabId < b.TabId
    end)
    for _, Tab in ipairs(self.SubTabList) do
        table.insert(self.SubTabMap, Tab.Data)
    end
end

--- 加载子页签信息
--- @param SubTabId table 子页签数据
function M:LoadSubTabInfo(SubTabData)
    self:CleanTimer()
    self.CurSubTabMap = SubTabData
    EventManager:FireEvent(EventID.OnMenuClose)
    if SubTabData.TabCoin then
        self.TabCoinInfo = SubTabData.TabCoin
    else
        assert(DataMgr.Shop[self.ShopType].ShopUIName, "该商城对应的蓝图在SystemUI中不存在："..self.ShopType)
        self.TabCoinInfo = DataMgr.SystemUI[DataMgr.Shop[self.ShopType].ShopUIName].TabCoin
    end
    self.Common_Tab:OverrideTopResource(self.TabCoinInfo)
    self.Common_Tab:ResetDynamicNode()
    if self.Common_Tab.WBP_Com_Tab_ResourceBar then
        self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(nil)
    end
    if self.Common_Tab and self.Common_Tab.UpdateBottomKeyInfo then
        self.Common_Tab:UpdateBottomKeyInfo({
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.CloseSelf, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.CloseSelf, Owner=self}}, Desc=GText("UI_BACK")
            }
        })
    end
end

function M:UpdateShopDetail(SubTabData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local Filter1, SortType = self.Common_SortList_PC:GetSortInfos()
    local ShopDataList = {}
    for ShopItemId, ShopData in pairs(DataMgr.ShopItem) do
        if ShopData.SubTabId == SubTabData.SubTabId and ShopUtils:GetShopItemCanShow(ShopItemId) then
            local bNotCheckWalnut = false
            local bNotCheckOwn = false
            if self.bFilterWalnutOwned then
                if ShopData.ItemType == "Walnut" and ShopUtils:GetCharWeaponHasLevelMax(ShopItemId) then
                    bNotCheckWalnut = true
                end
            end
            if self.bFilterOwned then
                if ShopData.ItemType ~= "Reward" then
                    local CheckFuncName = "Check"..ShopData.ItemType.."Enough"
                    local CheckMethod = Avatar[CheckFuncName]
                    local bOwn = CheckMethod(Avatar,{[ShopData.TypeId] = 1})
                    bNotCheckOwn = bOwn
                end
            end
            if not bNotCheckWalnut and not bNotCheckOwn then
                table.insert(ShopDataList, ShopData)
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
        if PurchaseLimit == 0 or Avatar:CheckShopItemUnique(ShopData.ItemId) then
            table.insert(SoldOutList, ShopData)
        else
            local NeedLevel = ShopData.UnlockLevel or 0
            if Avatar.Level < NeedLevel then
                table.insert(LimitLevelList, ShopData)
            else
                table.insert(NotSoldOutList, ShopData)
            end
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

    if self.CurSubTabMap.TabType == "Pack" then
        self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
        self:InitPayGiftPage(ShopDataList)
        return
    end

    self.List_Item:ScrollIndexIntoView(0)
    self.List_Item:ClearListItems()
    self.ShopItemNum = #ShopDataList

    self.Index2ShopSkin = {}
    self.ShopSkin2Index = {}
    self.SkinCount = 0
    for i = 1, self.ShopItemNum do
        local ShopData = ShopDataList[i]
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.ShopType = self.ShopType
        Content.ShopId = ShopData.ItemId
        if UIUtils.CanOpenSkinPreview(ShopData.ItemType, ShopData.TypeId) then
            self.SkinCount = self.SkinCount + 1
            self.Index2ShopSkin[self.SkinCount] = ShopData.ItemId
            self.ShopSkin2Index[ShopData.ItemId] = self.SkinCount
        end
        if self.SelectShopItemId and self.SelectShopItemId == ShopData.ItemId and ShopUtils:GetShopItemPurchaseLimit(self.SelectShopItemId) ~= 0 then
            self.ItemIndex = i - 1
        end
        self.List_Item:AddItem(Content)
    end
    local XAnchor = 0.5
    self:HorizontalListViewResize_SetUp(self.Group_Item, self.List_Item, XAnchor)

    local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    if self.List_Item:GetNumItems()>0 then
        self.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Common_SortList_PC:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:AddTimer(0.1, function ()
            if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
                GameInputModeSubsystem:SetNavigateWidgetVisibility(true)
            end
            self.VB_ItemList:SetVisibility(ESlateVisibility.Visible)
            self.Group_Empty:SetVisibility(ESlateVisibility.Collapsed)
            self.List_Item:RequestFillEmptyContent()
            -- 如果是从其他界面返回到商店界面，则不播放格子动画
            if (not self.NotNeedPlayEntryAnimation) then
                self.List_Item:RequestPlayEntriesAnim()
            end
            self.NotNeedPlayEntryAnimation = nil
            if not (CommonUtils:IfExistSystemGuideUI(self)) or self:HasAnyFocus() or self:HasFocusedDescendants() then
                self.List_Item:SetFocus()
            end
            if self.ItemIndex then
                self.List_Item:ScrollIndexIntoView(self.ItemIndex)
            end
            self.ItemIndex = nil
        end)
    else
        if self.bFilterOwned or self.bFilterWalnutOwned then
            self.Text_ShopItemEmpty:SetText(GText("UI_SHOP_NOITEM"))
        else
            self.Text_ShopItemEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
        end
        GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
        self.VB_ItemList:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_Empty:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Common_SortList_PC:SetVisibility(ESlateVisibility.Collapsed)
        if self.bFilterOwned or self.bFilterWalnutOwned then
            self.Group_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Group_Bottom:SetVisibility(ESlateVisibility.Collapsed)
        end
    end
end

function M:OnClickFilterOwned()
    if self:IsAnimationPlaying(self.Filtrate) then
        return
    end
    if self.bFilterOwned then
        self:PlayAnimationReverse(self.Filtrate)
    else
        self:PlayAnimation(self.Filtrate)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self.bFilterOwned = not self.bFilterOwned

    self:UpdateShopDetail(self.CurSubTabMap, true)
end

function M:OnClickFilterWalnutOwned()
    if self:IsAnimationPlaying(self.Filtrate) then
        return
    end
    if self.bFilterWalnutOwned then
        self:PlayAnimationReverse(self.Filtrate)
    else
        self:PlayAnimation(self.Filtrate)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    self.bFilterWalnutOwned = not self.bFilterWalnutOwned

    self:UpdateShopDetail(self.CurSubTabMap, true)
end

function M:GetOverrideTopResource()
    if self.TabCoinInfo then
        return self.TabCoinInfo
    end
end

function M:CloseSelf()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    AudioManager(self):SetEventSoundParam(self, "OpenShopMain", {ToEnd = 1})
    if (self.IsAddInDeque) then
        self:PlayAnimationForward(self.Out, UIConst.AnimOutSpeedWithPageJump.MaxSpeed)
    else
        self:PlayAnimation(self.Out)
    end
end

function M:BindEventOnSelectionsChanged(Filter1, Filter2, Filter3, SortType)
    self:UpdateShopDetail(self.CurSubTabMap)
end

function M:BindEventOnSortTypeChanged(SortType)
    self:UpdateShopDetail(self.CurSubTabMap)
end

function M:ShowItemDetail()
    if not DataMgr.ShopItem[self.SelectShopItemId] then
        return
    end
    self.ShopItemData = setmetatable({}, {__index = DataMgr.ShopItem[self.SelectShopItemId]})
    if not self.ShopItemData then
        return
    end
    local TypeId = self.ShopItemData.TypeId
    local ItemType = self.ShopItemData.ItemType
    AudioManager(self):PlayItemSound(self,TypeId,"Click",ItemType)
    local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.SelectShopItemId)
    local ItemData = DataMgr[ItemType][TypeId]
    local CommonPopupUIID
    if ItemType == "Reward" and (DataMgr.Reward[ItemData.RewardId].Mode == "Fixed" or DataMgr.Reward[ItemData.RewardId].Mode == "Once") then
        if self.ShopItemData.Bg == 1 then
            UIManager(self):LoadUINew("PayGiftPopup_Yellow", self.ShopItemData, self)
        elseif self.ShopItemData.Bg == 2 then
            UIManager(self):LoadUINew("PayGiftPopup_Purple", self.ShopItemData, self)
        else
            UIManager(self):LoadUINew("PayGiftPopup_Purple", self.ShopItemData, self)
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
    local ShopUIName = DataMgr.Shop[self.ShopType].ShopUIName
    ---@type WBP_Common_Dialog_PC_C
    local CommonDialog = UIManager(self):ShowCommonPopupUI(CommonPopupUIID, { ShopItemData = self.ShopItemData, ShopType = 0, Funds = Funds, ShowParentTabCoin = true,
        LeftCallbackObj = self,
        LeftCallbackFunction = function(Obj, PackageData)
            local Shop = UIManager(self):GetUIObj(ShopUIName)
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
            local Shop = UIManager(self):GetUIObj(ShopUIName)
            if Shop then
                Shop:SetFocus()
            end
        end,
        ForbidRightBtn = not ShopUtils:CanPurchase(self.ShopItemData, Funds[1].FundId, Funds[1].FundNeed)
    }, UIManager(self):GetUIObj(ShopUIName))
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
    return M.Super.OnKeyUp(self, MyGeometry, InKeyEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if not IsEventHandled then
            IsEventHandled = self:OnGamePadDown(InKeyName)
        end
    else
        if InKeyName == "Escape" then
                IsEventHandled = true
                self:CloseSelf()
        elseif InKeyName == "Q" then
            IsEventHandled = true
            self.ShopTab:TabToLeft()
        elseif InKeyName == "E" then
            IsEventHandled = true
            self.ShopTab:TabToRight()
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
        if self.IsBannerPage and self.BannerIdMap and self.SelectBannerId then
            local Banner = self.BannerIdMap[self.SelectBannerId]
            if Banner and Banner.OnKeyDown then
                return Banner:OnKeyDown(MyGeometry, InKeyEvent)
            end
        end
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnRechargeFinished(Result, GoodsId,ShopItems)
    self:BlockAllUIInput(false)
    self:RefreshSubTabData(self.CurSubTabMap)

    -- if Result == ErrorCode.RET_SUCCESS then
    --     if ShopItems then
    --         if DataMgr.PayGoods[GoodsId].ItemId then
    --             local ShopItemData = DataMgr.ShopItem[DataMgr.PayGoods[GoodsId].ItemId]
    --             assert(ShopItemData, "购买成功后读表ShopItemData为空", DataMgr.PayGoods[GoodsId].ItemId)
    --             if ShopItemData.ItemType == "DailyPack" then
    --                 UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, ShopItems, ShopItemData.IsSpPopup, function()
    --                     UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_DailyPack_PurchaseDone"))
    --                 end)
    --             else
    --                 UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, ShopItems, ShopItemData.IsSpPopup, ShopUtils:GetCloseGetItemPageCallback())
    --             end
    --         end
    --     end
    -- else
    --     UIManager(GWorld.GameInstance):ShowError(Result,1.0,"CommonToastMain")
    -- end
end

function M:SetFocus_Lua()
    local AllItemCount = self.List_Item:GetNumItems()
    if (AllItemCount > 0) then
        self.List_Item:SetFocus()
    else
        self:SetFocus()
    end
end
return M

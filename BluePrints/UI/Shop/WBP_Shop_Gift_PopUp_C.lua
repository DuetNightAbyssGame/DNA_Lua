--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local GiftController = require("BluePrints.UI.WBP.Gift.GiftController")
local GiftCommon = require("BluePrints.UI.WBP.Gift.GiftCommon")
---@type WBP_Shop_Gift_PopUp_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_FullClose.OnClicked:Add(self, self.CloseSelf)

    self.Btn_GiftPay:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.Btn_GiftPay.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp["Collapsed"])

    self.Btn_GiftPay:BindEventOnClicked(self, self.PurChaseShopItem)
    self.Btn_GiftPay:TryOverrideSoundFunc(function()
        AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
    end)

    self.Btn_GiftPay:BindForbidStateExecuteEvent(self, self.PurChaseShopItem)
    self.Text_Qa:SetText(GText("UI_GACHA_DESDETAIL"))
    self.Btn_GiftPay.Text_BtnBuy:SetText(GText("UI_SHOP_PURCHASE"))
    if GiftController and GiftController:IsInGiftShop() then
        self.Btn_GiftPay.Text_BtnEmpty:SetText(GText("UI_SendGift_GiftItemMax"))
        self.Text_SoldOut:SetText(GText("UI_SendGift_GiftItemMax"))
    else
        self.Btn_GiftPay.Text_BtnEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
        self.Text_SoldOut:SetText(GText("UI_SHOP_SOLDOUT"))
    end
    self.Btn_GiftPay.Img_GamePad:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            }
        }
    })

    self.Btn_Choose:UnBindEventOnClickedByObj(self)
    self.Btn_Choose:BindEventOnClicked(self, self.OnBtnChooseGiftClicked)
    self.Btn_Choose:BindForbidStateExecuteEvent(self, self.OnBtnChooseGiftClicked)
    self.Btn_Choose:OverriddenSoundFunc()

    self.Com_Hint:UnBindEventOnClickedByObj(self)
    self.Com_Hint:BindEventOnClicked(self, function()
        ShopUtils:OpenLockConditionPopup(self.ShopItemData)
    end)

    self.Text_Tip:SetText(GText("UI_TRAIN_CLOSE"))
    if GiftController:IsInGiftShop() then
        self.Text_BuyLeftTitle:SetText(GText("UI_SendGift_GiftItemMax"))
    else
        self.Text_BuyLeftTitle:SetText(GText("UI_SHOP_SHOPITEMLIMIT"))
    end
    self:InitGamePadKeyInfo()

    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Conf = nil
        Content.IsSelected = false
        Content.Parent = self
        return Content
    end)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Btn_GiftPay:UnBindEventOnClickedByObj(self)
    self.Super.Destruct(self)
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self)

    self.ShopItemData, self.ParentWidget, self.CloseCallback = ...
    -- GiftShop 上下文标记,判断是不是在送礼商店
    self.bInGiftShop =GiftController:IsInGiftShop()

    self.CurrentCount = 1
    self.UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId)
    self:SetFocus()
    self:BlockAllUIInput(true,"SP_DisplayOnly")

    --- 礼包Icon
    local Icon = ItemUtils.GetItemIcon(self.ShopItemData.TypeId, self.ShopItemData.ItemType)
    if Icon then
        self.Image_Icon:SetBrushFromTexture(Icon)
    end

    --- 礼包名称
    local ItemName = ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType)
    if self.ShopItemData.Bg == 1 then
        self.Text_GiftTitle_Yellow:SetText(GText(ItemName))
    else
        self.Text_GiftTitle_Purple:SetText(GText(ItemName))
    end

    --- 礼包内容Item
    local ItemData = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId]
    local Rewards = DataMgr.Reward[ItemData.RewardId]
    if Rewards then
        self.RewardList = {}
        local RewardIds = Rewards.Id
        local RewardCounts = Rewards.Count
        local RewardTypes = Rewards.Type
        for i = 1, #RewardIds do
            local ItemId = RewardIds[i]
            local Count = RewardUtils:GetCount(RewardCounts[i])
            local Icon = ItemUtils.GetItemIcon(ItemId, RewardTypes[i])
            local Rarity = ItemUtils.GetItemRarity(ItemId, RewardTypes[i])
            local ItemType = RewardTypes[i]
            local RewardContent = {
                Id = ItemId,
                Type = ItemType,
                ItemCount = Count,
                Icon = Icon,
                Rarity = Rarity,
            }
            table.insert(self.RewardList, RewardContent)
        end

        self.List_Item:ClearListItems()
        for _, ItemInfo in pairs(self.RewardList) do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Id = ItemInfo.Id
            Content.Icon = ItemUtils.GetItemIconPath(ItemInfo.Id, ItemInfo.Type)
            Content.ParentWidget = self
            Content.ItemType = ItemInfo.Type
            Content.Count = ItemInfo.ItemCount
            Content.Rarity = ItemInfo.Rarity or 1
            Content.IsShowDetails = true
            Content.UIName = "ShopMain"
            Content.OnMenuOpenChangedEvents = 
            {
                Obj = self,
                Callback = self.ItemMenuAnchorChanged
            }
            self.List_Item:AddItem(Content)
        end
    end

    --- 空态填充
    self.List_Item:RequestFillEmptyContent()

    local LimitText = ShopUtils:GetUnifiedLimitText(self.ShopItemData.ItemId)
    self.Text_BuyLeftTimes:SetText(LimitText)

    --- 礼包价格
    local Cost = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId)
    -- 根据 GiftShop 上下文更新按钮文案
    if self.bInGiftShop then
        self.Btn_GiftPay.Text_BtnBuy:SetText(GText("UI_SendGift_Send"))
    else
        self.Btn_GiftPay.Text_BtnBuy:SetText(GText("UI_SHOP_PURCHASE"))
    end
    if DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId] then
        self.Btn_GiftPay.WS_Detail:SetActiveWidgetIndex(0)
        self.Btn_GiftPay.Text_PriceMoneySymbol:SetText(GText(ShopUtils:GetCurrencyType()))
        self.Btn_GiftPay.Text_PriceMoneyNum:SetText(Cost)
    else
        assert(ItemData.Icon, "缺少Icon", self.ShopItemData.ItemType, self.ShopItemData.TypeId)
        self.Btn_GiftPay.WS_Detail:SetActiveWidgetIndex(1)
        self.Btn_GiftPay.Icon_Currency:Init({
            Id = self.ShopItemData.PriceType,
            Icon = LoadObject(DataMgr.Resource[self.ShopItemData.PriceType].Icon),
            ItemType = "Resource",
            UIName = "ShopMain",
            IsShowDetails = true,
            MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
        })
        self.Btn_GiftPay.Text_Price:SetText(Cost)
    end

    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    --- 购买按钮状态
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Btn_GiftPay:ForbidBtn(false)
    self.IsLockState = ShopUtils:CheckShopItemCondition(self.ShopItemData)
    if self.IsLockState then
        self:UpdateLockCondition()
    else
        self.WS_Btn:SetActiveWidgetIndex(0)
        local canPurchase = ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId))
        local shouldSoldOut = self.bInGiftShop and ShopUtils:ShouldPlaySoldOutAnimation(self.ShopItemData.ItemId)
        if canPurchase and not shouldSoldOut then
            self.Btn_GiftPay:ForbidBtn(false)
            self.bForbiddenPurchase = false
        else
            local forbid = (self.ShopItemData.PurchaseFailRes == 1) or self.bInGiftShop or shouldSoldOut
            if forbid then
                self.Btn_GiftPay:ForbidBtn(true)
                self.bForbiddenPurchase = true
            else
                self.Btn_GiftPay:DisableBtn(true)
                self.bForbiddenPurchase = true
            end
        end
    end

    self.Btn_GiftPay.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFF"))
    if not DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId] then
        local HasCount = Avatar.Resources[self.ShopItemData.PriceType] and Avatar.Resources[self.ShopItemData.PriceType].Count or 0
        local NeedCount = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId)
        if HasCount < NeedCount then
            self.Btn_GiftPay.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
        end
    end

    --- 倒计时相关
    -- 下架倒计时
    local CutoffData = ShopUtils:GetShopItemCutoffData(self.ShopItemData.ItemId)
    if CutoffData and CutoffData.CutoffEndTime then
        self.Panel_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:UpdateCutOffTime(CutoffData.CutoffEndTime)
        self:AddTimer(1, self.UpdateCutOffTime, true, 0, "RefreshCutOffTimer", true, CutoffData.CutoffEndTime)
    elseif self.ShopItemData.StartTime and self.ShopItemData.EndTime then
        self.Panel_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:UpdateLimitTime(self.ShopItemData.EndTime)
        self:AddTimer(1, self.UpdateLimitTime, true, 0, "RefreshEndTimer", true, self.ShopItemData.EndTime)
    else
        self.Panel_Time:SetVisibility(ESlateVisibility.Collapsed)
    end
    -- 限时刷新倒计时
    if self.ShopItemData.RefreshTime then
        self.Panel_RefreshTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self:UpdateRefreshTime(self.ShopItemData.RefreshTime)
    else
        self.Panel_RefreshTime:SetVisibility(ESlateVisibility.Collapsed)
    end

    --- Tips相关
    local ConfigData = {
        OwnerWidget = self,
        TextContent = GText(self.ShopItemData.ItemDes),
        OnMenuOpenChangedCallBack = self.OnDescOpenChanged,
    }
    self.Btn_Qa:Init(ConfigData)

    if self.ShopItemData.ItemDes then
        self.Btn_Qa:SetVisibility(ESlateVisibility.Visible)
        self.Text_Qa:SetVisibility(ESlateVisibility.Visible)
    else
        self.Btn_Qa:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Qa:SetVisibility(ESlateVisibility.Collapsed)
    end

    --- 折扣/超值百分比
    if ShopUtils:ShouldShowDiscount(self.ShopItemData.ItemId, self.ShopItemData) then
        self.Group_More:SetVisibility(ESlateVisibility.Visible)
        self.Text_MoreNum:SetText("+"..self.ShopItemData.ShowBonus)
    else
        self.Group_More:SetVisibility(ESlateVisibility.Collapsed)
    end

    --- 送礼
    -- GiftShop 入口：主按钮已改为“赠送”，隐藏单独送礼按钮
    if self.bInGiftShop then
        self.BtnChooseGiftEnable = false
        self.Group_BtnChoose:SetVisibility(ESlateVisibility.Collapsed)
    else
        if self.ShopItemData.CanBeGift and ShopUtils:ShowSendGiftButton(self.ShopItemData) then
            self.BtnChooseGiftEnable = true
            self.Group_BtnChoose:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            if GiftController:CheckCanSendGift() then
                self.Btn_Choose:ForbidBtn(false)
            else
                self.Btn_Choose:ForbidBtn(true)
            end
        else
            self.BtnChooseGiftEnable = false
            self.Group_BtnChoose:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

    --- 货币栏
    local TopResource = {self.ShopItemData.PriceType}
    self.Com_Tab_ResourceBar:InitResourceBar(TopResource, false)
    self.Com_Tab_ResourceBar:BindEvents(self, {OnMenuOpenChanged = self.OnDescOpenChanged})

    self:UpdateGamePadKeyInfo()

    if ShopUtils:ShouldPlaySoldOutAnimation(self.ShopItemData.ItemId) then
        self:PlayAnimation(self.In_SoldOut)
    else
        self:PlayAnimation(self.In)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/gift_pack_info_show", "GiftPopupIn", nil)
end

function M:List_In()
    self.List_Item:RequestPlayEntriesAnim()
end

--- 打开商品详情tips
function M:OnBtnDetailClick()
    -- local Content = {}
    -- Content.ItemType = "Tips"
    -- Content.Type = self.ShopItemData.ItemType
    -- Content.ItemId = self.ShopItemData.TypeId
    -- Content.Tips = self.ShopItemData.ItemDes
    -- Content.MenuPlacement = 7 ---估计是MenuPlacement_CenteredAboveAnchor，不过替换接口还是遵循原业务代码不变的原则...

    -- ItemDetails_MenuAnchor在蓝图中被移除了
    -- self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)

    if self.ShopItemData and self.ShopItemData.ItemDes then
        if not self.Btn_Qa:IsMenuAnchorOpen() then
            self.Btn_Qa:PlayClickSound()
            self.Btn_Qa.Btn_Click:SetChecked(true)
            self.Btn_Qa:OpenMenuAnchor()
        else
            self.Btn_Qa.Btn_Click:SetChecked(false)
            self.Btn_Qa:CloseMenuAnchor()
        end
    end
end

--- 刷新限时刷新倒计时
function M:UpdateRefreshTime(RefreshTime)
    ShopUtils:RefreshShopRefreshTime(RefreshTime, self.Text_RefreshTime, self.ShopItemData.ItemId)
    self:AddTimer(1, ShopUtils.RefreshShopRefreshTime, true, 0, "RefreshTimeTimer", true, RefreshTime, self.Text_RefreshTime, self.ShopItemData.ItemId)    
end

--- 折扣倒计时
function M:UpdateCutOffTime(CutoffTime)
    local EndTime = CutoffTime
    if TimeUtils.NowTime() >= EndTime then
        self:RemoveTimer("RefreshCutOffTimer")
        return
    end
    local RemainTimeStr = ShopUtils:UpdateLimitTime(EndTime)
    self.Text_Time:SetText(string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr))
end

--- 下架刷新倒计时
function M:UpdateLimitTime(ItemEndTime)
    local EndTime = ItemEndTime
    if TimeUtils.NowTime() >= EndTime then
        self:CleanTimer()
        EventManager:FireEvent(EventID.RefreshShop)
        return
    end
    local RemainTimeStr = ShopUtils:UpdateLimitTime(EndTime)
    self.Text_Time:SetText(string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr))
end

--- 更新商品解锁条件
function M:UpdateLockCondition()
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.ConditionDisplay = self.ShopItemData.ItemConditionDisplay and self.ShopItemData.ItemCondition
    if self.ConditionDisplay then
        self.Com_Hint.IsForbidden = true
        self.Com_Hint:SetText(GText(DataMgr.Condition[self.ShopItemData.ItemCondition[1]] and DataMgr.Condition[self.ShopItemData.ItemCondition[1]].ConditionText or ""))
        self.Com_Hint.bAutoButtonChange = false
        self.Com_Hint:SetIconPanelVisibility(ESlateVisibility.Collapsed)
        self.Com_Hint:SetGamepadIconVisibility(false)
        self.Com_Hint:SetGamePadVisibility(ESlateVisibility.Collapsed)
        self.Com_Hint.Button_Area:SetIsEnabled(false)
    else
        self.Com_Hint.IsForbidden = false
        self.Com_Hint:SetText(GText("UI_Shop_ItemUnlock"))
        self.Com_Hint.bAutoButtonChange = true
        self.Com_Hint:SetIconPanelVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Com_Hint:SetGamepadIconVisibility(true)
        self.Com_Hint.Button_Area:SetIsEnabled(true)
    end
end

function M:PurChaseShopItem()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    -- 送礼商店逻辑：GiftShop：直接进入贺卡界面（优先使用当前 GiftShop 的 FriendUid），不走自购逻辑
    if self.bInGiftShop then
        local giftMain = UIManager(self):GetUIObj(GiftCommon.GiftShopViewName)
        local OtherUid = giftMain and giftMain.FriendUid or nil
        if OtherUid then
            GiftController:TryToSendGift(OtherUid, self.ShopItemData.ItemId)
        else
            ScreenPrint("没有选择好友，请在送礼商店选完好友在点击")
        end
        self:CloseSelf(true)
        return
    end
    ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId))
    self:Purchase(self.ShopItemData, self)
end

function M:Purchase(ShopItemData, ParentWidget)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if DataMgr.ShopItem2PayGoods[ShopItemData.ItemId] then
        if ShopItemData.PurchaseFailRes == 0 then
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return false
            end
            if not HeroUSDKSubsystem():IsHeroSDKEnable() then
                local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
                GMFunctionLibrary.ExecConsoleCommand(GWorld.GameInstance,"sgm pgi "..DataMgr.ShopItem2PayGoods[ShopItemData.ItemId])
                self:CloseSelf(true)
                return
            end
            Avatar:RequestPay(DataMgr.ShopItem2PayGoods[ShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
                if not ErrorCode:Check(ret) then
                    return
                end
                local PaymentParameters = FHeroUPaymentParameters()
                PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[ShopItemData.ItemId]
                PaymentParameters.cpOrder = OrderId
                PaymentParameters.callbackUrl = CallbackUrl

                local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
                local ItemName = ""
                ItemName = GText(ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType))
                HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo, ItemName);
                local TrackInfo = {}
                TrackInfo.product_id = DataMgr.ShopItem2PayGoods[ShopItemData.ItemId]
                if ShopItemData.ItemId then
                    TrackInfo.item_id = ShopItemData.ItemId
                    TrackInfo.product_type = DataMgr.ShopItem[ShopItemData.ItemId].ItemType
                end
                TrackInfo.game_order_id = OrderId
                TrackInfo.order_create_time = TimeUtils.NowTime()
                HeroUSDKSubsystem(self):UploadTrackLog_Lua("charge_client", TrackInfo)
                self:CloseSelf(true)
            end)
        else
            UIManager(self):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO,1.0,"CommonToastMain")
        end
        return
    end
    if ShopItemData.PurchaseFailRes ~= 0 then
        if ShopItemData.PurchaseFailRes == 1 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO, 1.0, "CommonToastMain")
        elseif ShopItemData.PurchaseFailRes == 2 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[ShopItemData.PriceType].ResourceName)), 1.0)
        elseif ShopItemData.PurchaseFailRes == 3 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), ShopItemData.UnlockLevel), 1.0)
        elseif ShopItemData.PurchaseFailRes == 6 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_UNIQUE_ALREDAY_OWNED,1.0,"CommonToastMain")
        elseif ShopItemData.PurchaseFailRes == 4 then
            local PopUpId =  100136
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return
            end
            local ItemName = ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType)

            local PriceCount = Avatar.Resources[ShopItemData.PriceType] and Avatar.Resources[ShopItemData.PriceType].Count or 0

            local PopoverText = GText(DataMgr.CommonPopupUIContext[PopUpId].PopoverText)
            if string.find(PopoverText,'&ResourceName&') then
                PopoverText = string.gsub(PopoverText,'&ResourceName&', GText(DataMgr.Resource[CommonConst.Coins.Coin4].ResourceName))
            end
            if string.find(PopoverText,'&ResourceName1&') then
                PopoverText = string.gsub(PopoverText,'&ResourceName1&', GText(DataMgr.Resource[CommonConst.Coins.Coin4].ResourceName))
            end
            if string.find(PopoverText,'&ResourceName2&') then
                PopoverText = string.gsub(PopoverText,'&ResourceName2&', GText(ItemName))
            end
            if string.find(PopoverText,'&Num1&') then
                PopoverText = string.gsub(PopoverText,'&Num1&',ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount)
            end
            if string.find(PopoverText,'&Num2&') then
                PopoverText = string.gsub(PopoverText,'&Num2&',ParentWidget.CurrentCount)
            end

            local Confirm = function()
                local Coin4Count = 0
                if Avatar.Resources[CommonConst.Coins.Coin4] then
                    Coin4Count =  Avatar.Resources[CommonConst.Coins.Coin4].Count
                end
                if ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount > Coin4Count then
                    local JumpToShop = function()
                        PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId,nil,nil, "Shop")
                        self:CloseSelf(true)
                    end
                    local Params = {}
                    Params.LeftCallbackObj = self
                    Params.RightCallbackObj = self
                    Params.RightBtnClickedCallback = JumpToShop
                    UIManager(self):ShowCommonPopupUI(100137,Params, self)
                else
                    ShopUtils:SendExchangeRequest(ShopItemData.ItemId, ParentWidget.CurrentCount)
                end
            end
            
            local ItemList = {}
            local Coin4Count = Avatar.Resources[CommonConst.Coins.Coin4] and Avatar.Resources[CommonConst.Coins.Coin4].Count or 0
            table.insert(ItemList,{ItemId = CommonConst.Coins.Coin4,
                ItemType = CommonConst.ItemType.Resource,
                ItemNum = Coin4Count,
                ItemNeed = ParentWidget.CurrentCount * ParentWidget.UnitPrice - PriceCount})
            local Params = {
                RightCallbackFunction = Confirm,
                ItemList = ItemList,
                ShortText = PopoverText
            }
            UIManager(self):ShowCommonPopupUI(PopUpId,Params)
        elseif ShopItemData.PurchaseFailRes == 5 then
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return
            end

            local CachedShopItemData = self.ShopItemData
            local CachedParentWidget = self.ParentWidget
            local CachedCloseCallback = self.CloseCallback
            local IsYellow = (self.ShopItemData.Bg == 1)

            local ReOpenGiftPopup = function()
                local UIName = IsYellow and "PayGiftPopup_Yellow" or "PayGiftPopup_Purple"
                UIManager(GWorld.GameInstance):LoadUINew(UIName, CachedShopItemData, CachedParentWidget, CachedCloseCallback)
            end
            ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = ReOpenGiftPopup})
            local Params = {}
            Params.ShopItemId = self.ShopItemData.ItemId
            Params.Uid = Avatar.Uid
            Params.CloseBtnCallback = {
                Func = function()
                    ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = nil})
                end
            }
            UIManager(self):LoadUINew("ShopTargetPay", Params)
            self:CloseSelf(true)
        end
        return
    end
    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    local ShopActivity = UIManager(self):GetUIObj("ActivityShop")
    local CommonShopActivity = UIManager(self):GetUIObj("ShopActivity")
    if ShopMain then
        ShopMain:SetFocus()
        ShopMain:BlockAllUIInput(true)
    end
    if ShopActivity then
        ShopActivity:SetFocus()
        ShopActivity:BlockAllUIInput(true)
    end
    if CommonShopActivity then
        CommonShopActivity:SetFocus()
        CommonShopActivity:BlockAllUIInput(true)
    end
    Avatar:PurchaseShopItem(ShopItemData.ItemId, 1)
    self:CloseSelf(true)
end

function M:OnBtnChooseGiftClicked()
    if self.BtnChooseGiftEnable then
        if self.Btn_Choose:IsBtnForbidden() then
            ShopUtils:OpenForbidGiftChooseTip()
        else
            ShopUtils:OpenChooseGiftTarget(self.ShopItemData.ItemId, self.ParentWidget)
            self:CloseSelf(true)
        end
    else
    end
end

function M:CloseSelf(bForce)
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    if not bForce and self.bCantClose then
        self.bCantClose = false
        return
    end
    if self.CloseCallback then
        self.CloseCallback(self)
    end
    self:PlayAnimation(self.Out)
    AudioManager(self):SetEventSoundParam(self, "GiftPopupIn", {ToEnd = 1})
end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.In or InAnim == self.In_SoldOut then
        self:BlockAllUIInput(false)
    elseif InAnim == self.Out then
        self:Close()
        -- if self.ParentWidget then
        --     self.ParentWidget:SetFocus()
        -- end
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
            IsEventHandled = true
            if not self.bTipOpen and not self.bItemTipsOpen then
                self.bCantClose = false
            end
            self:CloseSelf()
        end
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

----------------------------------------------------------- 手柄相关 -----------------------------------------------------------
function M:InitGamePadKeyInfo()
    self.Panel_Key:ClearChildren()
    self.GamePadKeyCheck = self:CreateWidgetNew("ComKeyTextDesc")
    self.GamePadKeyA = self:CreateWidgetNew("ComKeyTextDesc")
    self.GamePadKeyB = self:CreateWidgetNew("ComKeyTextDesc")
    self.GamePadKeyCheck:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = DataMgr.KeyboardText[UIConst.GamePadKey.LeftThumb].KeyText
            },
        },
        Desc = GText("UI_Controller_CheckDetails"),
    })
    self.GamePadKeyB:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B"
            },
        },
        Desc = GText("UI_BACK"),
    })
    self.GamePadKeyA:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            },
        },
        Desc = GText("UI_Tips_Ensure"),
    })
    self.Panel_Key:AddChild(self.GamePadKeyCheck)
    self.Panel_Key:AddChild(self.GamePadKeyA)
    self.Panel_Key:AddChild(self.GamePadKeyB)

    local Key_Qa_Params = {
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = DataMgr.KeyboardText[UIConst.GamePadKey.SpecialLeft].KeyText
            },
        },
    }
    self.Key_Qa:CreateCommonKey(Key_Qa_Params)
    self.Key_Qa:SetVisibility(ESlateVisibility.Collapsed)

    local Key_BtnChoose_Params = {
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = DataMgr.KeyboardText[UIConst.GamePadKey.FaceButtonTop].KeyText
            },
        },
    }
    if self.Key_BtnChoose then
        self.Key_BtnChoose:CreateCommonKey(Key_BtnChoose_Params)
    end
    if self.Gift_GamePad then
        self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    end

    self.Com_Tab_ResourceBar:SetGamePadKeyImgByPath(UIUtils.UtilsGetKeyIconPathInGamepad(DataMgr.KeyboardText[UIConst.GamePadKey.RightThumb].KeyText))
    self.Com_Tab_ResourceBar:SetLastFocusWidget(self)

    self:UpdateGamePadKeyInfo()
end

--- 弹窗/资源栏Tips
function M:OnDescOpenChanged(bOpen)
    self.bTipOpen = bOpen
    if bOpen then
        self.bCantClose = bOpen
    end
    if not self.FocusOnSubItem and not self.bTipOpen then
        self:SetFocus()
    end
    self:UpdateGamePadKeyInfo()
end

--- 礼包商品Item的Tips
function M:ItemMenuAnchorChanged(bIsOpen)
    self.bItemTipsOpen = bIsOpen
    if bIsOpen then
        self.bCantClose = bIsOpen
    end
    self:UpdateGamePadKeyInfo()
end

--- 更新手柄按键提示
function M:UpdateGamePadKeyInfo()
    self.Btn_GiftPay:RefreshIconAndGamePadVisibility()
    self.Com_Hint:RefreshIconAndGamePadVisibility()
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Key:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.FocusOnSubItem and not (self.bItemTipsOpen or self.bTipOpen) then
            self.Btn_GiftPay:SetGamePadVisibility(ESlateVisibility.Collapsed)
            self.Com_Hint:SetGamePadVisibility(ESlateVisibility.Collapsed)
            self.Key_Qa:SetVisibility(ESlateVisibility.Collapsed)
            self.GamePadKeyCheck:SetVisibility(ESlateVisibility.Collapsed)
            self.GamePadKeyA:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.GamePadKeyB:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            if self.Gift_GamePad then self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed) end
        elseif self.bItemTipsOpen or self.bTipOpen then
            if self.bItemTipsOpen then self.Key_Qa:SetVisibility(ESlateVisibility.Collapsed) end
            self.Btn_GiftPay:SetGamePadVisibility(ESlateVisibility.Collapsed)
            self.Com_Hint:SetGamePadVisibility(ESlateVisibility.Collapsed)
            self.GamePadKeyCheck:SetVisibility(ESlateVisibility.Collapsed)
            self.GamePadKeyA:SetVisibility(ESlateVisibility.Collapsed)
            self.GamePadKeyB:SetVisibility(ESlateVisibility.Collapsed)
            if self.Gift_GamePad then self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed) end
        else
            if self.ShopItemData and self.ShopItemData.ItemDes then self.Key_Qa:SetVisibility(ESlateVisibility.SelfHitTestInvisible) end
            self.Btn_GiftPay:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
            if not self.ConditionDisplay then self.Com_Hint:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible) end
            self.GamePadKeyCheck:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.GamePadKeyA:SetVisibility(ESlateVisibility.Collapsed)
            self.GamePadKeyB:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            if self.BtnChooseGiftEnable and self.Gift_GamePad then self.Gift_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible) end
        end
    else
        self.Key_Qa:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Tip:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Panel_Key:SetVisibility(ESlateVisibility.Collapsed)
        if self.Gift_GamePad then self.Gift_GamePad:SetVisibility(ESlateVisibility.Collapsed) end
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.LeftThumb then
        if self.bTipOpen then return false end
        self.List_Item:SetFocus()
        self.FocusOnSubItem = true
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.RightThumb then
        if self.bTipOpen then return false end
        self.Com_Tab_ResourceBar:FocusToResource()
        self.FocusOnSubItem = true
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        IsEventHandled = true
        if self.FocusOnSubItem then
            self.FocusOnSubItem = false
            self:SetFocus()
        elseif self.bTipOpen then
            self:OnBtnDetailClick()
        else
            if not self.FocusOnSubItem and not self.bTipOpen and self.bCantClose then
                self.bCantClose = false
            end
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", nil, nil)
            self:CloseSelf()
        end
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
        if not self.FocusOnSubItem then
            IsEventHandled = true
            self:OnBtnDetailClick()
        end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        if self.bTipOpen then return false end
        AudioManager(self):PlayUISound(self.Btn_GiftPay, "event:/ui/activity/shop_small_btn_click", nil, nil)
        if self.IsLockState then
            if self.ShopItemData.ItemCondition and not self.ShopItemData.ItemConditionDisplay then
                ShopUtils:OpenLockConditionPopup(self.ShopItemData)
            end
        else
            self:PurChaseShopItem()
        end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
        if self.BtnChooseGiftEnable and not self.FocusOnSubItem and not self.bTipOpen and not self.bItemTipsOpen then
            IsEventHandled = true
            self:OnBtnChooseGiftClicked()
        end
    end
    self:UpdateGamePadKeyInfo()
    return IsEventHandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self.FocusOnSubItem = false
    self.bItemTipsOpen = false
    self.bTipOpen = false
    self:UpdateGamePadKeyInfo()
    return UIUtils.Unhandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        local bFocusInList = self.List_Item:HasAnyUserFocus() or self.List_Item:HasFocusedDescendants()
        local bFocusInRes = self.Com_Tab_ResourceBar:HasAnyUserFocus() or self.Com_Tab_ResourceBar:HasFocusedDescendants()
        if bFocusInList or bFocusInRes then
            self.FocusOnSubItem = true
        else
            self.FocusOnSubItem = false
        end
    end
    self:UpdateGamePadKeyInfo()
end

return M

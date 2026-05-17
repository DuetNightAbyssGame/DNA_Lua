--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
---@type WBP_Shop_PayGift_YellowItem_P_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.ShowItemDetail)
    -- self.Btn_Click.OnHovered:Add(self, self.BtnOnHovered)

    self.Com_Time.Text_TimeTitle:SetVisibility(ESlateVisibility.Collapsed)
end

function M:SetCallbacks(OwnerObj, Callbacks)
    self.OwnerObj = OwnerObj
    self.OnClickCb = Callbacks.OnClickCb
    self.ClearRdCb = Callbacks.ClearRdCb
end

function M:InitItemInfo(ShopItemData)
    self:CleanTimer()
    self.ShopItemId = ShopItemData.ItemId
    if self.ShopItemId and DataMgr.ShopItem[self.ShopItemId] then
        self.ShopItemData = setmetatable({}, {__index = DataMgr.ShopItem[self.ShopItemId]})
    end
    local ItemData = DataMgr[ShopItemData.ItemType][ShopItemData.TypeId]

    if DataMgr.ShopItem2PayGoods[self.ShopItemId] then
        self.WS_PriceSign:SetActiveWidgetIndex(0)
    else
        self.WS_PriceSign:SetActiveWidgetIndex(1)
        assert(ItemData.Icon, "缺少Icon", ShopItemData.ItemType, ShopItemData.TypeId)
        self.Com_ItemIcon:Init({
            Id = ShopItemData.PriceType,
            Icon = LoadObject(DataMgr.Resource[ShopItemData.PriceType].Icon),
            ItemType = "Resource",
            UIName = "ShopMain",
            IsShowDetails = true,
            MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
        })
    end

    local Cost = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
    self.Text_PriceNum:SetText(Cost)
    self.Text_PriceSign:SetText(GText(ShopUtils:GetCurrencyType()))
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    if ShopUtils:ShouldShowDiscount(ShopItemData.ItemId, ShopItemData) then
        self.Group_More:SetVisibility(ESlateVisibility.Visible)
        self.Text_MoreNum:SetText("+"..ShopItemData.ShowBonus)
    else
        self.Group_More:SetVisibility(ESlateVisibility.Collapsed)
    end


    local ItemName = ItemUtils:GetDropName(ShopItemData.TypeId, ShopItemData.ItemType)
    self.Text_GiftTitle:SetText(ItemName)

    local LimitText = ShopUtils:GetUnifiedLimitText(ShopItemData.ItemId, true)
    if LimitText ~= "" then
        self.Group_BuyLeftTimes:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_BuyLeftTimes:SetText(LimitText)
    else
        self.Group_BuyLeftTimes:SetVisibility(ESlateVisibility.Collapsed)
    end


    local IconPath = ItemData.Icon
    if IconPath then
        local IconObj = LoadObject(IconPath)
        if IconObj then
            self.Image_Icon:SetBrushResourceObject(IconObj)
        end
    end

    self.Group_LimitTime:SetVisibility(ESlateVisibility.Collapsed)
    if self.ShopItemData.RefreshTime then
        self.Group_LimitTime:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Com_Time.Image_ClockIcon:SetBrush(self.Com_Time.Img_Refresh)
        self:UpdateShopItemRefreshTime(self.ShopItemData.RefreshTime, self.Com_Time.Text_TimeDesc)
    elseif self.ShopItemData.StartTime and self.ShopItemData.EndTime then
        self.Group_LimitTime:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Com_Time.Image_ClockIcon:SetBrush(self.Com_Time.Img_Time)
        self:UpdateLimitTime(self.ShopItemData.EndTime, self.Com_Time.Text_TimeDesc)
        self:AddTimer(1, self.UpdateLimitTime, true, 0, "RefreshEndTimer", true, self.ShopItemData.EndTime, self.Com_Time.Text_TimeDesc)
    end
end

function M:UpdateBuyLeftTimesForGift(ShopItemData)
    local giftMain = GiftController and GiftController:GetGiftMainPage() or nil
    local Uid = giftMain and giftMain.FriendUid or nil
    local Remain = ShopUtils:GetGiftItemPurchaseLimit(ShopItemData.ItemId, Uid)
    local Total = ShopUtils:GetGiftItemPurchaseTotalLimit(ShopItemData.ItemId, Uid)
    if Remain >= 0 and Total >= 0 then
        self.Group_BuyLeftTimes:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_BuyLeftTimes:SetText(GText("UI_SendGift_SendGiftLimit")..Remain.."/"..Total)
    else
        self.Group_BuyLeftTimes:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:UpdateBuyLeftTimesForShop(ShopItemData)
    local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ShopItemData.ItemId)
    if PurchaseLimit >= 0 then
        self.Group_BuyLeftTimes:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_BuyLeftTimes:SetText(GText("UI_SHOP_SHOPITEMLIMIT")..PurchaseLimit.."/"..self.ShopItemData.PurchaseLimit)
    else
        self.Group_BuyLeftTimes:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:UpdateShopItemRefreshTime(RefreshTime)
    if not RefreshTime then
        self.Group_LimitTime:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Group_LimitTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        ShopUtils:RefreshShopRefreshTime(RefreshTime, self.Com_Time.Text_TimeDesc, self.ShopItemData.ItemId)
        self:AddTimer(1, ShopUtils.RefreshShopRefreshTime, true, 0, "RefreshTimeTimer", true, RefreshTime, self.Com_Time.Text_TimeDesc, self.ShopItemData.ItemId)
    end
end

-- function M:BtnOnHovered()
--     AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large_crystal", "PayGiftItemHover", nil)
-- end

function M:ShowItemDetail()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if Avatar:CheckShopItemEnhanceRedDot(self.ShopItemData.ItemId) then
        Avatar:CleanShopItemEnhanceRedDot(self.ShopItemData.ItemId, function()
            if self.ClearRdCb and self.OwnerObj then
                self.ClearRdCb(self.OwnerObj)
            end
        end)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", "PayGiftItemClick", nil)

    -- Bg == 1 means yellow
    -- Bg == 2 means purple
    if self.ShopItemData.Bg == 1 then
        UIManager(self):LoadUINew("PayGiftPopup_Yellow", self.ShopItemData, self)
    elseif self.ShopItemData.Bg == 2 then
        UIManager(self):LoadUINew("PayGiftPopup_Purple", self.ShopItemData, self)
    else
        UIManager(self):LoadUINew("PayGiftPopup_Purple", self.ShopItemData, self)
    end
    if self.OnClickCb and self.OwnerObj then
        self.OnClickCb(self.OwnerObj)
    end
    -- local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
    -- local ItemData = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId]
    -- local CommonPopupUIID
    -- if self.ShopItemData.ItemType == "Reward" and (DataMgr.Reward[ItemData.RewardId].Mode == "Fixed" or DataMgr.Reward[ItemData.RewardId].Mode == "Once") then
    --     if RemainTimes == 0 then
    --         CommonPopupUIID = 100040
    --     else
    --         CommonPopupUIID = 100039
    --     end
    -- else
    --     if RemainTimes == 0 then
    --         CommonPopupUIID = 100042
    --     else
    --         CommonPopupUIID = 100041
    --     end
    -- end
    -- if not CommonPopupUIID then
    --     return
    -- end
    -- local Funds = {}
    -- Funds[1] = {}
    -- Funds[1].FundId = self.ShopItemData.PriceType
    -- if DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId] then
    --     Funds[1].PriceSign = "￥"
    -- end
    -- Funds[1].NoColor = true
    -- Funds[1].FundNeed = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId)
    -- ---@type WBP_Common_Dialog_PC_C
    -- local CommonDialog = UIManager(self):ShowCommonPopupUI(CommonPopupUIID, { ShopItemData = self.ShopItemData, ShopType = 0, Funds = Funds, ShowParentTabCoin = true,
    --     LeftCallbackObj = self,
    --     LeftCallbackFunction = function(Obj, PackageData)
    --         local Shop = UIManager(self):GetUIObj("ShopMain")
    --         if Shop then
    --             Shop:SetFocus()
    --         end
    --     end,
    --     RightCallbackObj = self,
    --     RightCallbackFunction = function(Obj, PackageData)
    --         PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
    --     end,
    --     ForbiddenRightCallbackObj = self,
    --     ForbiddenRightCallbackFunction = function(Obj, PackageData)
    --         PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
    --     end,
    --     DontFocusParentWidget = true,
    --     CloseBtnCallbackObj = self,
    --     CloseBtnCallbackFunction = function(Obj, PackageData)
    --         local Shop = UIManager(self):GetUIObj("ShopMain")
    --         if Shop then
    --             Shop:SetFocus()
    --         end
    --     end,
    --     ForbidRightBtn = not ShopUtils:CanPurchase(self.ShopItemData, Funds[1].FundId, Funds[1].FundNeed)
    -- }, UIManager(self):GetUIObj("ShopMain"))
end

function M:UpdateLimitTime(ItemEndTime, TimeWidget)
    local EndTime = ItemEndTime
    if TimeUtils.NowTime() >= EndTime then
        self:CleanTimer()
        EventManager:FireEvent(EventID.RefreshShop)
        return
    end
    local RemainTimeStr = ShopUtils:UpdateLimitTime(EndTime)
    TimeWidget:SetText(string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr))
end

return M

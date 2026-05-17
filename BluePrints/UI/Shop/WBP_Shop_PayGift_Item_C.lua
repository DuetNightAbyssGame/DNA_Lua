--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_PayGift_Item_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.WS_Item:SetActiveWidgetIndex(0)
    self.Text_SoldOut:SetText(GText("UI_SHOP_SOLDOUT"))
end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.ItemData = Content.ItemData
    self:InitPayGiftItemInfo(self.ItemData)
end

function M:InitPayGiftItemInfo(ShopItemData)
    if not ShopItemData then
        self.WS_Item:SetActiveWidgetIndex(1)
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.WS_Item:SetActiveWidgetIndex(0)
    self.NowPayGiftItem = nil
    self.Lock:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_SoldOut:SetVisibility(ESlateVisibility.Collapsed)
    self.IsLockState = ShopUtils:CheckShopItemCondition(ShopItemData)
    if self.IsLockState then
        if ShopItemData.ItemConditionDisplay and ShopItemData.ItemCondition then
            self.Lock.Text_Lock:SetText(GText(DataMgr.Condition[ShopItemData.ItemCondition[1]] and DataMgr.Condition[ShopItemData.ItemCondition[1]].ConditionText or ""))
        else
            self.Lock.Text_Lock:SetText(GText("UI_Shop_ItemUnlock"))
        end
        self.Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif ShopItemData.UnlockLevel and Avatar.Level < ShopItemData.UnlockLevel then
        self.Lock.Text_Lock:SetText(GText("UI_Player_Level")..ShopItemData.UnlockLevel)
        self.Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        if GiftController:IsInGiftShop() then--送礼商店限送逻辑
            local giftMain = GiftController:GetGiftMainPage()
            local Uid = giftMain and giftMain.FriendUid or nil
            local PurchaseLimit = ShopUtils:GetGiftItemPurchaseLimit(ShopItemData.ItemId, Uid)
            if PurchaseLimit and PurchaseLimit > -1 and PurchaseLimit == 0 then
                self.PayGift_PurpleItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
                self.PayGift_YellowItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
                self.Text_SoldOut:SetText(GText("UI_SendGift_GiftItemMax"))
                self.Group_SoldOut:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            end
        elseif Avatar:CheckShopItemSoldOutDisplay(ShopItemData.ItemId) then --普通商店限购逻辑
            self.PayGift_PurpleItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
            self.PayGift_YellowItem.Group_More:SetVisibility(ESlateVisibility.Collapsed)
            self.Group_SoldOut:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    end
    self.bNewShopItem = Avatar:CheckShopItemEnhanceRedDot(ShopItemData.ItemId)
    if self.bNewShopItem then
        self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.New:SetVisibility(ESlateVisibility.Collapsed)
    end

    local Cost = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
    if Cost == 0 then
        self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.New:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Reddot:SetVisibility(ESlateVisibility.Collapsed)

    end

    if ShopItemData.Bg == 1 then
        self.NowPayGiftItem = self.PayGift_YellowItem
        self.PayGift_YellowItem:SetVisibility(ESlateVisibility.Visible)
        self.PayGift_PurpleItem:SetVisibility(ESlateVisibility.Collapsed)
        self.PayGift_YellowItem:InitItemInfo(ShopItemData)
    else
        self.NowPayGiftItem = self.PayGift_PurpleItem
        self.PayGift_YellowItem:SetVisibility(ESlateVisibility.Collapsed)
        self.PayGift_PurpleItem:SetVisibility(ESlateVisibility.Visible)
        self.PayGift_PurpleItem:InitItemInfo(ShopItemData)
    end

    self.NowPayGiftItem:SetCallbacks(self, {
        OnClickCb = self.OnSubItemClick,
        ClearRdCb = self.OnClearReddot,
    })
    self.ShopId = ShopItemData.ItemId
    self:EMShowReddot(false,EReddotType.New)
    local ShopTabConf = DataMgr.ShopTabSub[ShopItemData.SubTabId]
    local NodeName = ShopTabConf and ShopTabConf.ReddotNode
    if NodeName then
        local Node = ReddotManager.GetTreeNode(NodeName)
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
        if CacheDetail and CacheDetail[self.ShopId] and CacheDetail[self.ShopId] ~= Const.ShopCacheReason.Read then
            if Node then
                self:EMShowReddot(true,Node.ReddotType)
            else
                self:EMShowReddot(true, EReddotType.New)
            end
        elseif not CacheDetail[self.ShopId] then
            local NowTime = TimeUtils.NowTime()
            Node:_RefreshAShopItem(self.ShopId, Node.Cache, NowTime)
            if Node.Cache.Count > Node.Count then
                ReddotManager.IncreaseLeafNodeCount(NodeName,DeltaCount)
            end
        end
    end
end

function M:OnClearReddot()
    self:EMShowReddot(false,EReddotType.New)
end

function M:OnSubItemClick()
    local ShopTabConf = DataMgr.ShopTabSub[self.ItemData.SubTabId]
    local NodeName = ShopTabConf and ShopTabConf.ReddotNode
    if NodeName then
        if ReddotManager.DecreaseLeafNodeCount(ShopTabConf.ReddotNode,1,{ShopItemId = self.ShopId}) then
            self:EMShowReddot(false,EReddotType.New)
        end
    end
end

--function M:Destruct()
--end


return M

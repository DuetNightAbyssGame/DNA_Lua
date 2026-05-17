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
---@class Shop_Item_PC_C:WBP_Shop_Item_Base_C
local M = Class("BluePrints.UI.Shop.WBP_Shop_Item_Base_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end
function M:Destruct()
    self:CleanTimer()
end

function M:OnListItemObjectSet(Content)
    self.ShopId = Content.ShopId
    self.IsSelect = Content.IsSelect
    self.ShopType = Content.ShopType
    self:InitShopItem(self.ShopId)
    if self.IsSelect then
        self:ShowItemDetail()
    end
end

function M:InitShopItem(ShopItemId)
    self:ResetItem()
    local ShopItemData = nil
    if ShopItemId and DataMgr.ShopItem[ShopItemId] then
        ShopItemData = setmetatable({}, {__index = DataMgr.ShopItem[ShopItemId]})
    end
    self:EMShowReddot(false,EReddotType.New)
    if not ShopItemData then
        local ItemContent = {}
        self.Group_Item:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Item_Shop:Init(ItemContent)
        return
    end

    self.ShopItemData = ShopItemData
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ItemData = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId]
    if not ItemData then
        return
    end
    self.bNewShopItem = Avatar:CheckShopItemEnhanceRedDot(ShopItemId)
    
    if self.bNewShopItem then
        self:EMShowReddot(true,EReddotType.New)
    end
    
    self.IsFree = ShopUtils:IsFree(ShopItemId)
    if self.IsFree then
        self:EMShowReddot(true,EReddotType.Normal)
    end

    if not self.IsFree and not self.bNewShopItem then
        local ShopTabConf = DataMgr.ShopTabSub[self.ShopItemData.SubTabId]
        local NodeName = ShopTabConf and ShopTabConf.ReddotNode
        if NodeName then
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
            if CacheDetail and CacheDetail[self.ShopId] and CacheDetail[self.ShopId] ~= Const.ShopCacheReason.Read then
                self:EMShowReddot(true,EReddotType.New)
            end
        end
    end
    
    local ItemName = ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType)
    if self.ShopItemData.ItemType == "Draft" then
        ItemName = ItemUtils:GetDraftName(ItemData.DraftId)
    end
    if self.ShopItemData.TypeNum and self.ShopItemData.TypeNum > 1 then
        ItemName = ItemName .. " x" .. self.ShopItemData.TypeNum
    end
    self.Text_Name:SetText(ItemName)
    self.Text_Name_NoQuality:SetText(ItemName)
    self:Set_Text_Height()
    local CurrentCount = Avatar:GetResourceNum(self.ShopItemData.PriceType)
    local Cost = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
    self.CutoffData = ShopUtils:GetShopItemCutoffData(ShopItemData.ItemId)
    self.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if self.CutoffData then
        self.Text_Discount:SetText(100 - self.CutoffData.CutoffShow)
        self.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Text_Undiscounted_Price:SetText(self.ShopItemData.Price)
        self.Panel_Discount:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        if self.CutoffData.CutoffEndTime then
            self.Panel_Time:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self:UpdateCutoffTime(self.CutoffData.CutoffEndTime)
            self:AddTimer(1, self.UpdateCutoffTime, true, 0, "RefreshCutoffTimer", true, self.CutoffData.CutoffEndTime)
        else
            -- self.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Text_Price:SetText(math.ceil(self.ShopItemData.Price))
            self.Panel_Time:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    elseif ShopItemData.StartTime and ShopItemData.EndTime then
        self.Panel_Time:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self:UpdateLimitTime()
        self:AddTimer(1, self.UpdateLimitTime, true, 0, "RefreshEndTimer", true)
    else
        self.Panel_Time:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:UpdateShopItemRefreshTime(ShopItemData.RefreshTime)

    self:RefreshSoldOutInfo()
    local Rarity = DataMgr[ShopItemData.ItemType][ShopItemData.TypeId].Rarity or DataMgr[ShopItemData.ItemType][ShopItemData.TypeId][ShopItemData.ItemType .. "Rarity"]

    self.WS_Name:SetActiveWidgetIndex(0)
    if not Rarity then
        self.WS_Name:SetActiveWidgetIndex(1)
    end
    local ItemContent = {}
    ItemContent.ShopItemId = ShopItemId
    ItemContent.Icon = ItemUtils.GetItemIconPath(self.ShopItemData.TypeId, self.ShopItemData.ItemType)
    ItemContent.Rarity = Rarity
    self.Item_Shop:Init(ItemContent)

    self.Walnut_Number:SetVisibility(ESlateVisibility.Collapsed)
    -- if self.ShopItemData.ItemType == "Walnut" then
    --     self.Walnut_Number:InitWalnutNumber(self.ShopItemData.TypeId)
    --     self.Walnut_Number:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    -- end
    self.Text_Price:SetText(math.ceil(Cost))

    if Cost == 0 then
        self.Text_Price:SetText(GText("UI_FREE"))
        self.Group_Currency:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Group_Currency:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
    if CurrentCount < Cost then
        self.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
    else
        self.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFF"))
    end
    self.Img_Currency:SetBrushResourceObject(ItemUtils.GetItemIcon(self.ShopItemData.PriceType, "Resource"))
    
    -- 解锁条件
    self.IsLockState = ShopUtils:CheckShopItemCondition(self.ShopItemData)
    if self.IsLockState then
        if self.ShopItemData.ItemConditionDisplay and self.ShopItemData.ItemCondition then
            self.Lock.Text_Lock:SetText(GText(DataMgr.Condition[self.ShopItemData.ItemCondition[1]] and DataMgr.Condition[self.ShopItemData.ItemCondition[1]].ConditionText or ""))
        else
            self.Lock.Text_Lock:SetText(GText("UI_Shop_ItemUnlock"))
        end
        self.Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif ShopItemData.UnlockLevel and Avatar.Level < ShopItemData.UnlockLevel  then
        self.Lock.Text_Lock:SetText(GText("UI_Player_Level")..ShopItemData.UnlockLevel)
        self.Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Lock:SetVisibility(ESlateVisibility.Collapsed)
        if not Avatar:CheckShopItemUnlockRaidPoint(ShopItemId) then
            self.Lock.Text_Lock:SetText(GText("RaidDungeon_Shop_UnlockPoint")..ShopItemData.UnlockRaidPoint)
            self.Lock:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        --解锁后的商品如果没有缓存需要设置一下红点
        local ShopTabConf = DataMgr.ShopTabSub[self.ShopItemData.SubTabId]
        local NodeName = ShopTabConf and ShopTabConf.ReddotNode
        if NodeName then
            local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
            if not CacheDetail[self.ShopId] then 
                local Node = ReddotManager.GetTreeNode(NodeName)
				local NowTime = TimeUtils.NowTime()
                Node:_RefreshAShopItem(self.ShopId, Node.Cache, NowTime)
                if Node.Cache.Count > Node.Count then
					ReddotManager.IncreaseLeafNodeCount(NodeName,DeltaCount)
				end
            end
        end
    end
end


function M:ResetItem()
    self:CleanTimer()
    self.Group_Item:SetVisibility(ESlateVisibility.Visible)
    self.Panel_SoldOut:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Panel_Discount:SetVisibility(ESlateVisibility.Collapsed)
end

function M:RefreshSoldOutInfo()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.ShopType == "GiftShop" then --送礼商店专用逻辑
        self:RefreshGiftSoldOutInfo()
        return 
    end
    local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
    if PurchaseLimit > -1 then
        self.Group_BuyLimit:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Text_Limit:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Text_Limit:SetText(GText("UI_SHOP_SHOPITEMLIMIT")..PurchaseLimit.."/"..self.ShopItemData.PurchaseLimit)
        if PurchaseLimit == 0 or Avatar:CheckShopItemUnique(self.ShopItemData.ItemId) then
            if PurchaseLimit ~= 0 and Avatar:CheckShopItemUnique(self.ShopItemData.ItemId) then
                self.Text_SoldOut:SetText(GText("UI_SHOP_ALREADYOWNED"))
            else
                self.Text_SoldOut:SetText(GText("UI_SHOP_SOLDOUT"))
            end
            self.Panel_Discount:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Panel_SoldOut:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Panel_SoldOut:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    else
        self.Group_BuyLimit:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Text_Limit:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end
--送礼商店专用的限送逻辑
function M:RefreshGiftSoldOutInfo()
    local giftMain = GiftController:GetGiftMainPage()
    local Uid = giftMain and giftMain.FriendUid or nil
    local PurchaseLimit = ShopUtils:GetGiftItemPurchaseLimit(self.ShopItemData.ItemId, Uid)
    local TotalLimit = ShopUtils:GetGiftItemPurchaseTotalLimit(self.ShopItemData.ItemId, Uid)
    if PurchaseLimit > -1 then
        self.Group_BuyLimit:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Text_Limit:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        if TotalLimit > -1 then
            self.Text_Limit:SetText(GText("UI_SendGift_SendGiftLimit")..PurchaseLimit.."/"..TotalLimit)
        else
            self.Text_Limit:SetText(GText("UI_SendGift_SendGiftLimit"))
        end
        if PurchaseLimit == 0 then
            self.Text_SoldOut:SetText(GText("UI_SendGift_GiftItemMax"))
            self.Panel_Discount:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Panel_SoldOut:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Panel_SoldOut:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    else
        self.Group_BuyLimit:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Text_Limit:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    return
end
function M:UpdateCutoffTime(EndTime)
    local CurrentTime = TimeUtils.NowTime();
    local RemainRefreshTime = EndTime - CurrentTime
    if RemainRefreshTime <= 0 then
        self:RemoveTimer("RefreshCutoffTimer")
        self:InitShopItem(self.ShopId)
    end
    local RemainTimeStr = ShopUtils:GetRefreshTimeStr(RemainRefreshTime)
    self.Text_Time:SetText(RemainTimeStr)
    self:RefreshSoldOutInfo()
end

function M:UpdateLimitTime()
    if not self.ShopItemData.EndTime then
        self:CleanTimer()
        return
    end
    local StartTiem = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
    local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(self.ShopItemData.EndTime.GetTime())
    local RemainTime = UKismetMathLibrary.Subtract_DateTimeDateTime(EndTime, StartTiem)
    local RemainTimeStr = ""
    local TimeCount = 0
    if UKismetMathLibrary.GetDays(RemainTime) > 0 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_DAY"), UKismetMathLibrary.GetDays(RemainTime))
    end
    if UKismetMathLibrary.GetHours(RemainTime) > 0 or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_HOUR"), UKismetMathLibrary.GetHours(RemainTime))
    end
    if (UKismetMathLibrary.GetMinutes(RemainTime) > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_MINUTE"), UKismetMathLibrary.GetMinutes(RemainTime))
    end
    if (UKismetMathLibrary.GetSeconds(RemainTime) > 0 and TimeCount < 2) or TimeCount ==1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), UKismetMathLibrary.GetSeconds(RemainTime))
    end
    self.Text_Time:SetText(RemainTimeStr)
    -- self:RefreshSoldOutInfo()
end

function M:UpdateShopItemRefreshTime(RefreshTime)
    if not RefreshTime then
        self.Panel_RefreshTime:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Panel_RefreshTime:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        ShopUtils:RefreshShopRefreshTime(RefreshTime, self.Text_RefreshTime, self.ShopItemData.ItemId)
        self:AddTimer(1, ShopUtils.RefreshShopRefreshTime, true, 0, "RefreshTimeTimer", true, RefreshTime, self.Text_RefreshTime, self.ShopItemData.ItemId)
    end
end

function M:ShowItemDetail()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if Avatar:CheckShopItemEnhanceRedDot(self.ShopItemData.ItemId) then
        Avatar:CleanShopItemEnhanceRedDot(self.ShopId, function()
            self:EMShowReddot( false,EReddotType.New)
            -- local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
            -- if ShopMain then
            --     ShopMain:ResetReddot(ShopMain.ShopType)
            --     ShopMain:SetTabNewReddot(ShopMain.ShopType)
            --     ShopMain:SetTabReddot(ShopMain.ShopType)
            -- end
        end)
    end
    local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
    if ShopMain then
        ShopMain.SelectShopItemId = self.ShopItemData.ItemId
    end
    local ShopActivity = UIManager(GWorld.GameInstance):GetUIObj("ShopActivity")
    if ShopActivity then
        ShopActivity.SelectShopItemId = self.ShopItemData.ItemId
    end
    if DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId] then
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        if not HeroUSDKSubsystem():IsHeroSDKEnable() then
            local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
            GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(),"sgm pgi "..DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId])
            return
        end
        Avatar:RequestPay(DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
            if not ErrorCode:Check(ret) then 
                return 
            end
            local PaymentParameters = FHeroUPaymentParameters()
            PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId]
            PaymentParameters.cpOrder = OrderId
            PaymentParameters.callbackUrl = CallbackUrl

            local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()

            HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo);
        end)
    else
        AudioManager(self):PlayItemSound(self,self.ShopItemData.TypeId,"Click",self.ShopItemData.ItemType)
        local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
        local ItemData = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId]
        local bForbidden = not ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId))
        local CommonPopupUIID
        if UIUtils.CanOpenSkinPreview(self.ShopItemData.ItemType, self.ShopItemData.TypeId) then
            UIManager(self):LoadUINew("SkinPreview", self.ShopItemData, self)
        elseif self.ShopItemData.ItemType == "Reward" and (DataMgr.Reward[ItemData.RewardId].Mode == "Fixed" or DataMgr.Reward[ItemData.RewardId].Mode == "Once") then
            -- Bg == 1 means yellow
            -- Bg == 2 means purple
            if self.ShopItemData.Bg == 1 then
                UIManager(self):LoadUINew("PayGiftPopup_Yellow", self.ShopItemData, self)
            elseif self.ShopItemData.Bg == 2 then
                UIManager(self):LoadUINew("PayGiftPopup_Purple", self.ShopItemData, self)
            else
                UIManager(self):LoadUINew("PayGiftPopup_Purple", self.ShopItemData, self)
            end
        else
            if RemainTimes == 0 or self.ShopItemData.PurchaseFailRes == 6 then
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
        local CommonDialog = UIManager(self):ShowCommonPopupUI(CommonPopupUIID, { ShopItemData = self.ShopItemData, ShopType = 0, Funds = Funds, ShowParentTabCoin = true, UIName = ShopUIName,
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
            ForbidRightBtn = not ShopUtils:CanPurchase(self.ShopItemData, Funds[1].FundId, Funds[1].FundNeed),
        }, UIManager(self):GetUIObj(ShopUIName))
    end
end
--礼物商店专属的点击详情函数
function M:ShowGiftItemDetail()
    if not self.ShopItemData or not self.ShopItemData.ItemId then
        return
    end
    AudioManager(self):PlayItemSound(self,self.ShopItemData.TypeId,"Click",self.ShopItemData.ItemType)
    local ItemData = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId]
    if UIUtils.CanOpenSkinPreview(self.ShopItemData.ItemType, self.ShopItemData.TypeId) then
        UIManager(self):LoadUINew("SkinPreview", self.ShopItemData, self)
        return
    end

    local giftMain = GiftController:GetGiftMainPage()
    local Uid = giftMain and giftMain.FriendUid or nil
    local GiftController = require("BluePrints.UI.WBP.Gift.GiftController")
    if Uid then
        GiftController:TryToSendGift(Uid, self.ShopItemData.ItemId)
    else
        GiftController:OpenSelectFriendPopup(self.ShopItemData.ItemId)
    end
end

function M:OnBtnHovered()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self.Item_Shop:StopAllAnimations()
    self.Item_Shop:PlayAnimation(self.Item_Shop.Hover)
end

function M:OnBtnUnhovered()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self.Item_Shop:StopAllAnimations()
    self.Item_Shop:PlayAnimation(self.Item_Shop.Normal)
end

function M:OnBtnPressed()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self.StartPressTime = os.clock()
    self.Item_Shop:PlayAnimation(self.Item_Shop.Press)
    local ShopTabConf = DataMgr.ShopTabSub[self.ShopItemData.SubTabId]
    local NodeName = ShopTabConf and ShopTabConf.ReddotNode
    if NodeName and not self.IsFree and not self.bNewShopItem then
        if ReddotManager.DecreaseLeafNodeCount(ShopTabConf.ReddotNode,1,{ShopItemId = self.ShopId}) then
            self:EMShowReddot(false,EReddotType.New)
        end
    end
end

function M:OnBtnReleased()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    self.PressedTime = os.clock() - self.StartPressTime or os.clock()
    if self.PressedTime > 0.2 then
        self.IsLongPress = true
        self.Item_Shop:PlayAnimation(self.Item_Shop.Normal)
    end
end

function M:OnBtnClicked()
    if self:IsAnimationPlaying(self.In) then
        return
    end
    if not self.IsLongPress then
        self.Item_Shop:PlayAnimation(self.Item_Shop.Click)
        if self.ShopType == "GiftShop" then
            self:ShowGiftItemDetail()--送礼商店专属流程
        else
            self:ShowItemDetail()
        end
    end
    self.IsLongPress = false
end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.In then
        self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end


return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local EMCache = require "EMCache.EMCache"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local TimeUtils = require "Utils.TimeUtils"
---@type WBP_Shop_Recharge_Item_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Text_DoubleTitle:SetText(GText("UI_Shop_Bonus"))
    self.Text_MoreTitle:SetText(GText("UI_Shop_More"))
    ---@todo ZDX 如何区分不同区服设置不同的支付币种
    self.Text_PriceSign:SetText(GText(ShopUtils:GetCurrencyType()))

    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnClicked:Add(self, self.BtnOnClicked)
    -- self.Btn_Click.OnHovered:Add(self, self.BtnOnHovered)
end

--- 设置充值商品信息
---@param Cost number               @所需花费
---@param Count number              @所得商品数目
---@param DoubleCount number        @双倍数目
---@param AdditionalCount number    @额外所得数目
function M:SetRechargeItemCost(ShopItemData, Cost, Count)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self.ShopItemId = ShopItemData.ItemId
    local bFisrtBonus = Avatar:CheckIsFirstBonus(self.ShopItemId)
    self.Text_PriceNum:SetText(Cost)
    self.Text_StoneNum:SetText(Count)
    self.Text_StoneNum_Reflection:SetText(Count)

    self.Group_Double:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_More:SetVisibility(ESlateVisibility.Collapsed)

    if bFisrtBonus then
        local DoubleCount = DataMgr.FirstBonusNum[self.ShopItemId].FirstBonusNum
        self.Group_Double:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_DoubleNum:SetText("+"..DoubleCount)
    else
        local AdditionalCount = DataMgr.FirstBonusNum[self.ShopItemId].BonusNum
        if AdditionalCount and AdditionalCount ~= 0 then
            self.Group_More:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Text_MoreNum:SetText("+"..AdditionalCount)
        end
    end
    self.Cost = Cost
    local ItemId = ShopItemData.TypeId
    local ItemType = ShopItemData.ItemType
    self.ItemName = ItemUtils.GetItemName(ItemId, ItemType)
    assert(DataMgr[ItemType][ItemId], "未找到商品信息", ItemType, ItemId)
    self.Text_StoneName:SetText(GText(self.ItemName))
end

-- function M:BtnOnHovered()
--     AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_large_crystal", "RechargeItemHover", nil)
-- end

function M:BtnOnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
    if ShopUtils:GetSDKRegisterRegionCode() == "JP" then
        local CommonDialog = UIManager(self):ShowCommonPopupUI(100233, {
            ShopItemId = self.ShopItemId,
            Tips = {[1] = self.Cost.."円"},
            RightCallbackObj = self,
            RightCallbackFunction = function(Obj)
                self:Charge()
            end,
            ForbiddenRightCallbackObj = self
        }, self)
    elseif ShopUtils:GetSDKRegisterRegionCode() == "TW" or ShopUtils:GetSDKRegisterRegionCode() == "MO" or ShopUtils:GetSDKRegisterRegionCode() == "HK" then
        local PickUpCache = EMCache:Get("RechargeHint",true) or {}
        if not PickUpCache["TMH"] then
            local CommonDialog = UIManager(self):ShowCommonPopupUI(100236, {
                ShopItemId = self.ShopItemId,
                RightCallbackObj = self,
                RightCallbackFunction = function(Obj, Data)
                    if Data.SelectHint.IsSelected then
                        PickUpCache["TMH"] = Data.SelectHint.IsSelected
                        EMCache:Set("RechargeHint",PickUpCache,true)
                    end
                    self:Charge()
                end,
                ForbiddenRightCallbackObj = self
            }, self)
        else
            self:Charge()
        end
    else
        self:Charge()
    end
end

function M:Charge()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return false
    end
    if not HeroUSDKSubsystem():IsHeroSDKEnable() then
        local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
        GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(),"sgm pgi "..DataMgr.ShopItem2PayGoods[self.ShopItemId])
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", "RechargeItemClick", nil)
    Avatar:RequestPay(DataMgr.ShopItem2PayGoods[self.ShopItemId], function(ret, OrderId, CallbackUrl)
        if not ErrorCode:Check(ret) then 
            return 
        end
        local PaymentParameters = FHeroUPaymentParameters()
        PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[self.ShopItemId]
        PaymentParameters.cpOrder = OrderId
        PaymentParameters.callbackUrl = CallbackUrl

        local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()
        DebugPrint("Send HeroSDKPay:"..OrderId)
        HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo, GText(self.ItemName));
        local TrackInfo = {}
        TrackInfo.product_id = DataMgr.ShopItem2PayGoods[self.ShopItemId]
        if self.ShopItemId then
            TrackInfo.item_id = self.ShopItemId
            TrackInfo.product_type = DataMgr.ShopItem[self.ShopItemId].ItemType
        end
        TrackInfo.game_order_id = OrderId
        TrackInfo.order_create_time = TimeUtils.NowTime()
        HeroUSDKSubsystem(self):UploadTrackLog_Lua("charge_client", TrackInfo)
    end)
end
return M

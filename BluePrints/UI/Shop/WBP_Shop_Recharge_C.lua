--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_Recharge_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.UI.BP_EMUserWidgetUtils_C"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddInputMethodChangedListen()
    self:PlayAnimation(self.In)
    if ShopUtils:GetSDKRegisterRegionCode() == "JP" then
        self.Group_JPRecharge:SetVisibility(ESlateVisibility.Visible)
        self.Btn_JPRechargeLink.Button_Area.OnClicked:Add(self, self.OpenJPUrl)
        self.JumPUrl = GLink("PaymentPolicyJP")
        self.Text_JPRecharge:SetText(GText("UI_Shop_JP_Link"))

    elseif ShopUtils:GetSDKRegisterRegionCode() == "KR" then
        self.Group_JPRecharge:SetVisibility(ESlateVisibility.Visible)
        self.Btn_JPRechargeLink.Button_Area.OnClicked:Add(self, self.OpenJPUrl)
        self.JumPUrl = GLink("PaymentPolicyKR")
        self.Text_JPRecharge:SetText(GText("UI_Shop_KR_Link"))
    else
        self.Group_JPRecharge:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:InitRechargeInfo(RechargeInfo)
    for i = 1, 6 do
        assert(RechargeInfo[i], "商城充值页面商品数目错误，未找到第"..i.."个商品")
        local Widget = self["Recharge_Item_"..i]
        local PriceType = ShopUtils:GetCurrencyPrice()
        local Price = DataMgr.PayGoods[DataMgr.ShopItem2PayGoods[RechargeInfo[i].ItemId]][PriceType]
        local Count = DataMgr.ShopItem[RechargeInfo[i].ItemId].TypeNum
        Widget:SetRechargeItemCost(RechargeInfo[i], Price, Count)
    end
end

function M:OpenJPUrl()
    UE4.UKismetSystemLibrary.LaunchURL(self.JumPUrl)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == ECommonInputType.Gamepad then
        self:SetFocus()
    end
end

return M

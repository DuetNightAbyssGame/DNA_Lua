--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
---@type WBP_Gift_ShopTarget_PayContent_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.Text_GiftTitle:SetText(GText("UI_NotEnough99"))
    self.Text_DetaiDesc:SetText(GText("UI_SendGift_Pay1"))
    self.Text_NumTitle:SetText(GText("UI_SendGift_Pay2"))
    self.Btn_OtherLevel:SetText(GText("UI_SendGift_ChooseOtherQuota"))
    self.Text_DoubleTitle:SetText(GText("UI_Shop_Bonus"))
    self.Text_MoreTitle:SetText(GText("UI_Shop_More"))
    self.Btn_ShopPay.Text_BtnBuy:SetText(GText("UI_SHOP_PURCHASE"))
    self.Text_Tip:SetText(GText("UI_TRAIN_CLOSE"))
    self.Btn_OtherLevel:BindEventOnClicked(self, self.OnClickNo)
    self.Btn_ShopPay:BindEventOnClicked(self, self.OnClickYes)
    self.Btn_FullClose.OnClicked:Add(self, self.OnClickFullClose)
    self:AddDispatcher(EventID.OnRechargeFinished, self, self.OnRechargeFinished)

    self:InitGamePadKeyInfo()
end

function M:Destruct()
    M.Super.Destruct(self)
    self.IsClickYes = nil
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local Params = ...

    self.ShopItemId = Params.ShopItemId
    self.VoucherId = Params.VoucherId
    self.Uid = Params.Uid
    self.CallbackInfo = Params.CallbackInfo
    self.BeforeClickNoCallback = Params.BeforeClickNoCallback
    self.CloseBtnCallback = Params.CloseBtnCallback
    self.CostNum = Params.CostNum or 0
    self.CostType = Params.CostType
    if not self.CostType and not self.ShopItemId then
        return
    end
    self.PriceType = self.CostType
    if self.ShopItemId then
        self.PriceType = DataMgr.ShopItem[self.ShopItemId].PriceType
    end
    local TopResource = {self.PriceType}
    self.Com_Tab_ResourceBar:InitResourceBar(TopResource, false)
    self.Com_Tab_ResourceBar:SetGamePadKeyImgByPath(UIUtils.UtilsGetKeyIconPathInGamepad(
        DataMgr.KeyboardText[UIConst.GamePadKey.RightThumb].KeyText))

    local Need = ShopUtils:GetNeedRechargeCount(self.ShopItemId, self.PriceType, self.CostNum, self.VoucherId)

    self.Text_DetaiNum:SetText(Need)

    local CurrencyId = self.PriceType
    local CurrencyConfig = DataMgr.Resource[CurrencyId]

    -- self.Icon_Currency:Init({
    --     Id = CurrencyConfig.ResourceId,
    --     Icon = ItemUtils.GetItemIcon(self.PriceType, "Resource"),
    --     ItemType = CurrencyConfig.ResourceSType,
    --     UIName = "GiftGet",
    --     IsShowDetails = true,
    --     MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
    -- })
    self.NeedShopItemData = ShopUtils:GetRechargeItem(self.ShopItemId, self.PriceType, self.CostNum, self.VoucherId)

    if not self.NeedShopItemData then
        return
    end
    local PriceType = ShopUtils:GetCurrencyPrice()
    local Price = DataMgr.PayGoods[DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId]][PriceType]
    local Count = DataMgr.ShopItem[self.NeedShopItemData.ItemId].TypeNum
    self:SetRechargeItemCost(self.NeedShopItemData, Price, Count)
    self.Btn_ShopPay.WS_Detail:SetActiveWidgetIndex(0)

    self.Btn_ShopPay.Text_PriceMoneySymbol:SetText(GText(ShopUtils:GetCurrencyType()))
    self.Btn_ShopPay.Text_PriceMoneyNum:SetText(Price)

    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/gift_recommend_info_show", "gift_recommend_info_show", nil)
end

function M:SetRechargeItemCost(ShopItemData, Price, Count)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self.Text_StoneNum:SetText(Count)
    self.Text_PriceSign:SetText(GText(ShopUtils:GetCurrencyType()))
    self.Text_PriceNum:SetText(Price)

    local bFisrtBonus = Avatar:CheckIsFirstBonus(ShopItemData.ItemId)
    self.Group_Double:SetVisibility(ESlateVisibility.Collapsed)
    self.Group_More:SetVisibility(ESlateVisibility.Collapsed)
    if bFisrtBonus then
        local DoubleCount = DataMgr.FirstBonusNum[ShopItemData.ItemId].FirstBonusNum
        self.Group_Double:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_DoubleNum:SetText("+" .. DoubleCount)
    else
        local AdditionalCount = DataMgr.FirstBonusNum[ShopItemData.ItemId].BonusNum
        if AdditionalCount and AdditionalCount ~= 0 then
            self.Group_More:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Text_MoreNum:SetText("+" .. AdditionalCount)
        end
    end

    if ShopItemData.ItemId == 110101 then
        self.WS_Icon:SetActiveWidgetIndex(0)
    elseif ShopItemData.ItemId == 110102 then
        self.WS_Icon:SetActiveWidgetIndex(1)
    elseif ShopItemData.ItemId == 110103 then
        self.WS_Icon:SetActiveWidgetIndex(2)
    elseif ShopItemData.ItemId == 110104 then
        self.WS_Icon:SetActiveWidgetIndex(3)
    elseif ShopItemData.ItemId == 110105 then
        self.WS_Icon:SetActiveWidgetIndex(4)
    elseif ShopItemData.ItemId == 110106 then
        self.WS_Icon:SetActiveWidgetIndex(5)
    end

end

function M:OnClickYes()
    if DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId] then
        self:CloseSelf()
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return false
        end
        self.IsClickYes = true
        if not HeroUSDKSubsystem():IsHeroSDKEnable() then
            local GMFunctionLibrary = require "BluePrints.UI.GMInterface.GMFunctionLibrary"
            GMFunctionLibrary.ExecConsoleCommand(self:GetGameInstance(),
                "sgm pgi " .. DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId])
            return
        end
        Avatar:RequestPay(DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId], function(ret, OrderId, CallbackUrl)
            if not ErrorCode:Check(ret) then
                return
            end
            self.OrderId = OrderId
            local PaymentParameters = FHeroUPaymentParameters()
            PaymentParameters.goodsId = DataMgr.ShopItem2PayGoods[self.NeedShopItemData.ItemId]
            PaymentParameters.cpOrder = OrderId
            PaymentParameters.callbackUrl = CallbackUrl

            local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()

            HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo);
        end)
    end
end

function M:OnRechargeFinished(Result, GoodsId, ShopItems, OrderId)
    if Result == ErrorCode.RET_SUCCESS then
        if self.CallbackInfo and self.IsClickYes then
            self.CallbackInfo.Func(self.CallbackInfo.Obj, GoodsId, ShopItems, OrderId)
        end
    else
        -- UIManager(GWorld.GameInstance):ShowError(Result,1.0,"CommonToastMain")
    end
end

function M:OnClickNo()
    if self.BeforeClickNoCallback and self.BeforeClickNoCallback.Func and self.BeforeClickNoCallback.Obj then
        self.BeforeClickNoCallback.Func(self.BeforeClickNoCallback.Obj)
    end
    ShopUtils:SetCloseGetItemPageCallback({
        CloseGetItemPageCallback = nil
    })
    PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
    self:CloseSelf()
end

function M:OnClickFullClose()
    if self.CloseBtnCallback and self.CloseBtnCallback.Func then
        self.CloseBtnCallback.Func(self.CloseBtnCallback.Obj)
    end
    self:CloseSelf()
end

function M:CloseSelf()
    AudioManager(self):SetEventSoundParam(self, "gift_recommend_info_show", {
        ToEnd = 1
    })
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:PlayAnimation(self.Out)

end

function M:OnAnimationFinished(InAnim)
    if InAnim == self.Out then
        self:Close()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == UIConst.GamePadKey.FaceButtonTop then
            self:OnClickNo()
            IsEventHandled = true
        elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
            self:OnClickYes()
            IsEventHandled = true
        elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
            self:CloseSelf()
            IsEventHandled = true
        elseif InKeyName == UIConst.GamePadKey.RightThumb then
            self.Com_Tab_ResourceBar:FocusToResource()
        end
    else
        if (InKeyName == "Escape") then
            self:CloseSelf()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:InitGamePadKeyInfo()
    self.Btn_OtherLevel:SetDefaultGamePadImg("Y")
    self.Btn_ShopPay:SetDefaultGamePadImg("A")
    self.Btn_ShopPay:SetGamePadIconVisible(true)

    -- self.Btn_OtherLevel:SetNavigationRuleExplicit(EUINavigation.Right, self.Btn_ShopPay)
    -- self.Btn_ShopPay.Btn_Buy:SetNavigationRuleExplicit(EUINavigation.Up, self.Com_Tab_ResourceBar)
    -- self.Btn_ShopPay.Btn_Buy:SetNavigationRuleExplicit(EUINavigation.Left, self.Btn_OtherLevel)

    self.Panel_Key:ClearChildren()
    self.GamePadKeyB = self:CreateWidgetNew("ComKeyTextDesc")

    self.GamePadKeyB:CreateCommonKey({
        KeyInfoList = {{
            Type = "Img",
            ImgShortPath = "B"
        }},
        Desc = GText("UI_BACK")
    })

    self.Panel_Key:AddChild(self.GamePadKeyB)

    self:UpdateGamePadKeyInfo()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self:UpdateGamePadKeyInfo(CurInputType)
end

function M:UpdateGamePadKeyInfo(CurInputDevice)
    if CurInputDevice == ECommonInputType.Gamepad then
        self.GamePadKeyB:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Tip:SetVisibility(ESlateVisibility.Collapsed)
        self:SetFocus()
    else
        self.GamePadKeyB:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Tip:SetVisibility(ESlateVisibility.Visible)
    end

end

function M:BP_GetDesiredFocusTarget()
    return self
end

return M

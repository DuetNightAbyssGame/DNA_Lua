require "UnLua"
---@type WBP_BattlePass_PurchasePage_P_C
local M = Class("BluePrints.UI.BP_UIState_C")
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local TimeUtils = require "Utils.TimeUtils"
local BattlePassController = require "BluePrints.UI.WBP.BattlePass.Controller.BattlePassController"
local BattlePassUtils = require "BluePrints.UI.WBP.BattlePass.BattlePassUtils"

M._components = {
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
    "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent",
}

local RANK_TYPE = 
{
    RANK2 = 1,
    RANK3 = 2,
    RANK2TO3 = 3,
}

local TYPE_2_GOODS_ID =
{
    [RANK_TYPE.RANK2] = "com.hero.dna.Pay_BattlePassRank2",
    [RANK_TYPE.RANK3] = "com.hero.dna.Pay_BattlePassRank3",
    [RANK_TYPE.RANK2TO3] = "com.hero.dna.Pay_BattlePassRank2to3",
}

function M:Construct()
    self:InitSound()
    self:InitData()
    self:InitInputSettings()
    self:InitTabInfo()
    self:InitPanel()
    self:InitButtons()
    self:InitRewards()
    self:InitEvents()
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    DebugPrint("gmy@WBP_BattlePass_Purchase_C M:OnLoaded")
    
    self:UpdatePreviewActor()
    self.ActorController = BattlePassController:GetModelData("ActorController")
    
    if self.Bg_BattlePass then
        self.Bg_BattlePass:PlayAnimation(self.Bg_BattlePass.In)
    end
end

function M:InitSound()
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "BattlePassPurchaseOpen", nil, nil)
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_buy_page_in", nil, nil)
end

function M:InitEvents()
    self:AddDispatcher(EventID.BattlePassBuySuccessNotify, self, self.BuySuccessNotify)
    self:AddDispatcher(EventID.OnPayCallBack, self, self.OnPayCallBack)
end

function M:InitData()
    local Avatar = GWorld:GetAvatar()
end

function M:InitPanel()
    self.bIsFocusable = true
    self:SetFocus()
    
    -- 文本静态内容
    self.Text_Show:SetText(GText('UI_BattlePass_PetClaimDetail'))
    self.Title_High:SetText(GText('UI_BattlePass_GoldRank'))
    self.Text_Buy_High:SetText(GText('BATTLEPASS_RANK1_PURCHASE_DESC1'))
    self.Title_Super:SetText(GText('UI_BattlePass_PlatinumRank'))
    self.Text_LevelUp:SetText(GText('BATTLEPASS_RANK2_PURCHASE_DESC1'))
    self.Text_Buy_Super:SetText(GText('BATTLEPASS_RANK2_PURCHASE_DESC2'))
    self.Text_Unlock:SetText(GText('BATTLEPASS_RANK2_PURCHASE_DESC3'))
    self:RefreshCloudTimeText()
end

function M:InitTabInfo()
    self.Tab_PurchasePage:Init({
        TitleName = GText('MAIN_UI_BATTLEPASS'),
        DynamicNode = {"Back", "BottomKey"},
        BottomKeyInfo = {
            {
                GamePadInfoList =  {{
                                        Type="Img",
                                        ImgShortPath="A",
                                        Owner=self
                                    }},
                Desc = GText("UI_Controller_Check"),
                bLongPress = false,
            }, 
            {
                KeyInfoList = {{Type="Text", Text="Esc", ClickCallback=self.ExitPurchase, Owner=self}},
                GamePadInfoList = {{Type="Img", ImgShortPath="B", ClickCallback=self.ExitPurchase, Owner=self}}, Desc=GText("UI_BACK")
            },
        },
        BackCallback = self.ExitPurchase,
        OwnerPanel = self,
    })
end

function M:ExitPurchase()
    AudioManager(self):SetEventSoundParam(self, "BattlePassPurchaseOpen", { ToEnd = 1 })
    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_buy_page_out", nil, nil)
    self:Close()
end

function M:InitButtons()
    self:RefreshButtons(nil)
end

function M:RefreshButtons(PayRankType)
    local Avatar = GWorld:GetAvatar()
    
    -- Rank2 
    local bHasRank2 = Avatar.BattlePassUnlockRank2
    local Rank2State = bHasRank2 and "Forbidden" or "Normal"
    if PayRankType == CommonConst.BattlePassPayType.RANK2 then
        Rank2State = "UnlockForbidden"
    end
    local Rank2Desc = bHasRank2 and "UI_UNLOCKED" or self:GetRank2Price()
    self.BtnBuy_High:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.BtnBuy_High:InitBtnInfo(Rank2State, Rank2Desc, function()
        self:StartPayRank2()
    end, "X", false)

    -- Rank3
    local bHasRank3 = Avatar.BattlePassUnlockRank3
    local Rank3State = bHasRank3 and "Forbidden" or "Normal"
    if PayRankType == CommonConst.BattlePassPayType.RANK2_UPGRADE_RANK3 
            or PayRankType == CommonConst.BattlePassPayType.RANK3 then
        Rank3State = "UnlockForbidden"
    end
    local bDiscount = false
    local Rank3Desc = bHasRank3 and "UI_UNLOCKED" or self:GetRank3Price()
    local OriginPriceDesc = nil
    if bHasRank2 or bHasRank3 then
        bDiscount = false
    else
        bDiscount = true
        OriginPriceDesc = self:GetRank3OriginPrice()
    end

    self.BtnBuy_Super:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.BtnBuy_Super:InitBtnInfo(Rank3State, Rank3Desc, function()
        self:StartPayRank3()
    end, bDiscount, OriginPriceDesc, "Y", false)

    -- 按下摇杆
    if self.Key_GamePad2 then
        self.Key_GamePad2:CreateCommonKey({
            KeyInfoList = {{Type = "Img", ImgShortPath = "LS", }},
            Desc = GText("UI_Controller_Check"),
        })
    end
    if self.Key_GamePad1 then
        self.Key_GamePad1:CreateCommonKey({
            KeyInfoList = {{Type = "Img", ImgShortPath = "LS", }},
            Desc = GText("UI_Controller_Check"),
        })
    end
    
    self.Btn_Pet.OnClicked:Clear()
    self.Btn_Pet.OnClicked:Add(self, function()
        EventManager:FireEvent(EventID.BattlePassPetChange)
    end)
end

function M:RefreshCloudTimeText(BattlePassPayType)
    local HideText = function(bHide)
        if self.Panel_HighPresent then
            self.Panel_HighPresent:SetVisibility(bHide and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        if self.Panel_SuperPresent then
            self.Panel_SuperPresent:SetVisibility(bHide and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then HideText(true) return end
    local ChannelId = Avatar.ChannelId
    if not ChannelId then HideText(true) return end
    local ChannelInfo = DataMgr.ChannelInfo[ChannelId]
    if not ChannelInfo then HideText(true) return end
    local Providers = {
        ["nil"] = false,
        ["hero"] = true,
        ["wegame"] = true,
        ["lenovo"] = true,
        ["cloud"] = true,
        ["oppo"] = true,
    }
    local bIsCNOfficial = (ChannelInfo.Region == "china") and Providers[ChannelInfo.Provider or "nil"]
    if not bIsCNOfficial then HideText(true) return end

    HideText(false)
    local bHasRank2 = Avatar.BattlePassUnlockRank2
    local bHasRank3 = Avatar.BattlePassUnlockRank3
    if BattlePassPayType then
        if BattlePassPayType == CommonConst.BattlePassPayType.RANK2 and bHasRank2 then
            if self.Text_Present then
                self.Text_Present:SetText(GText('UI_BattlePass_CloudGameTime_Rank2'))
            end
            if self.Text_Present_1 then
                self.Text_Present_1:SetText(GText('UI_BattlePass_CloudGameTime_UpdatetoRank3'))
            end
        elseif BattlePassPayType == CommonConst.BattlePassPayType.RANK3 and bHasRank3 then
            if self.Text_Present then
                self.Text_Present:SetText(GText('UI_BattlePass_CloudGameTime_Rank2'))
            end
            if self.Text_Present_1 then
                self.Text_Present_1:SetText(GText('UI_BattlePass_CloudGameTime_Rank3'))
            end
        elseif BattlePassPayType == CommonConst.BattlePassPayType.RANK2_UPGRADE_RANK3 and bHasRank3 then
            if self.Text_Present then
                self.Text_Present:SetText(GText('UI_BattlePass_CloudGameTime_Rank2'))
            end
            if self.Text_Present_1 then
                self.Text_Present_1:SetText(GText('UI_BattlePass_CloudGameTime_UpdatetoRank3'))
            end
        end
    else
        if not bHasRank2 and not bHasRank3 then
            if self.Text_Present then
                self.Text_Present:SetText(GText('UI_BattlePass_CloudGameTime_Rank2'))
            end
            if self.Text_Present_1 then
                self.Text_Present_1:SetText(GText('UI_BattlePass_CloudGameTime_Rank3'))
            end
        elseif bHasRank2 and not bHasRank3 then
            if self.Text_Present then
                self.Text_Present:SetText(GText('UI_BattlePass_CloudGameTime_Rank2'))
            end
            if self.Text_Present_1 then
                self.Text_Present_1:SetText(GText('UI_BattlePass_CloudGameTime_UpdatetoRank3'))
            end
        elseif bHasRank2 and bHasRank3 then
            if self.Text_Present then
                self.Text_Present:SetText(GText('UI_BattlePass_CloudGameTime_Rank2'))
            end
            if self.Text_Present_1 then
                self.Text_Present_1:SetText(GText('UI_BattlePass_CloudGameTime_Rank3'))
            end
        end
    end
end
function M:StartPayRank2()
    DebugPrint("gmy@WBP_BattlePurchase_P M:StartPayRank2")
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local bHasRank2 = Avatar.BattlePassUnlockRank2
    if bHasRank2 then
        return
    end

    BattlePassUtils:TryOpenWithEndTimeReminder(self, function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)

        Avatar:BattlePassReuqestPay(CommonConst.BattlePassPayType.RANK2, function(ret, OrderId, CallbackUrl, goodsId)
            DebugPrint("gmy@WBP_BattlePass_Purchase_C M:BattlePassReuqestPay", ret, OrderId, CallbackUrl, goodsId, os.time())
            if ret == ErrorCode.RET_SUCCESS then
                local PaymentParameters = FHeroUPaymentParameters()
                PaymentParameters.goodsId = goodsId
                PaymentParameters.cpOrder = OrderId
                PaymentParameters.callbackUrl = CallbackUrl

                local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()

                HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo)

                self:TrackPayInfo(goodsId, OrderId)
            end
        end)
    end)
end

function M:StartPayRank3()
    DebugPrint("gmy@WBP_BattlePurchase_P M:StartPayRank3")
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    local bHasRank3 = Avatar.BattlePassUnlockRank3
    if bHasRank3 then
        return
    end

    local BattlePassPayType = CommonConst.BattlePassPayType.RANK3
    if Avatar.BattlePassUnlockRank2 then
        BattlePassPayType = CommonConst.BattlePassPayType.RANK2_UPGRADE_RANK3
    end

    BattlePassUtils:TryOpenWithEndTimeReminder(self, function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_special", nil, nil)

        Avatar:BattlePassReuqestPay(BattlePassPayType, function(ret, OrderId, CallbackUrl, goodsId)
            DebugPrint("gmy@WBP_BattlePass_Purchase_C M:BattlePassReuqestPay", ret, OrderId, CallbackUrl, goodsId)
            local PaymentParameters = FHeroUPaymentParameters()
            PaymentParameters.goodsId = goodsId
            PaymentParameters.cpOrder = OrderId
            PaymentParameters.callbackUrl = CallbackUrl

            local GameRoleInfo = HeroUSDKUtils.GenHeroHDCGameRoleInfo()

            HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo)

            self:TrackPayInfo(goodsId, OrderId)
        end)
    end)
end

function M:InitRewards()
    local BattlePassDta = DataMgr.BattlePassMain[BattlePassController:GetModelData("BattlePassId")]
    local Rank2RewardView = BattlePassDta.Rank2RewardView
    local Rank3RewardView = BattlePassDta.Rank3RewardView
    
    self:InitRewardList(self.List_Item_High, Rank2RewardView)
    self:InitRewardList(self.List_Item_Super, Rank3RewardView, {BonusType = 1})
end

function M:InitRewardList(List, RewardViewId, BonusInfo)
    local RewardViewData = RewardUtils:GetRewardViewInfoById(RewardViewId)
    
    List:ClearListItems()
    for Index, ItemData in ipairs(RewardViewData) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())

        Content.Id = ItemData.Id
        Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
        Content.ParentWidget = self
        Content.ItemType = ItemData.Type
        Content.Rarity = ItemData.Rarity or 1
        Content.IsShowDetails = false
        Content.Count = ItemData.Quantity and ItemData.Quantity[1]
        
        Content.Root = self
        Content.IsShowDetails = true
        if BonusInfo then
            Content.BonusType = BonusInfo.BonusType
            Content.ExtraBonusText = BonusInfo.ExtraBonusText 
        end
        List:AddItem(Content)
    end
end

function M:InitInputSettings()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    
    -- 模型交互相关
    self.Image_Click.OnMouseButtonDownEvent:Unbind()
    self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

-- function M:OnMouseWheel(MyGeometry, MouseEvent)
--     return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
-- end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
    return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
    return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    DebugPrint("gmy@WBP_BattlePurchase_C M:OnUpdateUIStyleByInputTypeChange", CurInputDevice, CurGamepadName)

    if (self.CurInputDeviceType == CurInputDevice) then
        return
    end
    self.CurInputDeviceType = CurInputDevice

    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if IsUseKeyAndMouse then
        self.UsingGamepad = false
        -- 当切回鼠标键盘，清空内部焦点状态（按需）
        self.CurrentFocusedList = nil

        self.Key_GamePad1:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Key_GamePad2:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.CurrentFocusedList = nil
    else
        self.UsingGamepad = true

        -- 默认情况下，切到手柄状态开始时，显示 Key_GamePad2 隐藏 Key_GamePad1（你要求的默认）
        if self.Key_GamePad1 then
            self.Key_GamePad1:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if self.Key_GamePad2 then
            self.Key_GamePad2:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end

        -- 初始聚焦到 List_Item_High（保持你原本行为）
        self:AddTimer(0.1, function()
            -- 这里同时把内部状态也设置为 High
            self:SetFocusToList("High")
        end, false)
    end
end


function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    
    DebugPrint("gmy@WBP_BattlePurchase_C M:OnKeyDown", InKeyName)
    if InKeyName == "Escape" or InKeyName == Const.GamepadFaceButtonRight then
        self:ExitPurchase()
    elseif InKeyName == Const.GamepadFaceButtonLeft then
        self:StartPayRank2()
    elseif InKeyName == Const.GamepadFaceButtonUp then
        self:StartPayRank3()
    elseif InKeyName == Const.GamepadLeftThumbstick then
        self:ToggleListFocusOnLeftThumbstick()
    elseif InKeyName == Const.GamepadFaceButtonDown then
        -- 列表自己实现了
        UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:ShowItemDetails()
    DebugPrint("gmy@WBP_BattlePurchase_C M:ShowItemDetails")
end

function M:BuySuccessNotify(PayRankType)
    DebugPrint("gmy@WBP_BattlePass_Purchase_C M:BuySuccessNotify", PayRankType)
    -- TODO 播放对应挡位的购买动效

    AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_pay_money_unlock", nil, nil)
    -- 刷新按钮状态
    self:RefreshButtons(PayRankType)
    -- 刷新云游戏时间文本
    self:RefreshCloudTimeText(PayRankType)
end

function M:GetRank2Price()
    return self:GetBattlePassPriceText(RANK_TYPE.RANK2)
end

function M:GetRank3Price()
    local Avatar = GWorld:GetAvatar()
    if Avatar then
        -- Rank3
        local bHasRank2 = Avatar.BattlePassUnlockRank2
        if not bHasRank2 then
            return self:GetBattlePassPriceText(RANK_TYPE.RANK3)
        end
        return self:GetBattlePassPriceText(RANK_TYPE.RANK2TO3)
    end
    return ""
end

function M:GetRank3OriginPrice()
    local CurrencySymbol = ShopUtils:GetCurrencyType()
    local Price1 = self:GetBattlePassPrice(RANK_TYPE.RANK2)
    local Price2 = self:GetBattlePassPrice(RANK_TYPE.RANK2TO3)
    local Price = Price2 + Price1
    return CurrencySymbol .. Price
end

function M:GetBattlePassPrice(Type)
    local GoodsId = TYPE_2_GOODS_ID[Type]
    if GoodsId then
        local PayGoodData = DataMgr.PayGoods[GoodsId]
        local PriceType = ShopUtils:GetCurrencyPrice()
        local Price = PayGoodData[PriceType]
        return Price or 0
    end
    
    -- TODO 严重错误
    DebugPrint("gmy@WBP_BattlePass_Purchase_C M:GetBattlePassPrice Error: Invalid Type", Type)
    return 0
end

function M:GetBattlePassPriceText(Type)
    local CurrencySymbol = ShopUtils:GetCurrencyType()
    local Price = self:GetBattlePassPrice(Type)
    return CurrencySymbol .. Price
end

-- 埋点
function M:TrackPayInfo(GoodsId, OrderId)
    local TrackInfo = {}
    TrackInfo.product_id = GoodsId
    TrackInfo.product_type = "BattlePass"
    --TrackInfo.item_id = item_id
    TrackInfo.game_order_id = OrderId
    TrackInfo.order_create_time = TimeUtils.NowTime()
    HeroUSDKSubsystem():UploadTrackLog_Lua("charge_client", TrackInfo)
end

function M:OnPayCallBack(Result, PaymentOrder, Msg)
    DebugPrint("gmy@WBP_BattlePass_Purchase_C M:OnPayCallBack", Result, PaymentOrder, Msg)
    if Result == 0 then
        -- 支付成功
    end
end

--region ------------------------------------预览模型相关------------------------------------

function M:UpdatePreviewActor()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local CharInfo = Avatar.Chars[Avatar.CurrentChar]
    if not CharInfo then return end

    -- CameraName是Char_Skin_Purchase_XXX
    --self:EnterCameraAnimation()
end

function M:EnterCameraAnimation()
end

--endregion ------------------------------------预览模型相关------------------------------------

-- 新增：内部焦点状态与切换辅助函数
function M:UpdateGamepadKeyVisibilityBasedOnCurrentFocus()
    local bShowSuperKey = true
    if self.CurrentFocusedList == "High" then
        bShowSuperKey = false
    elseif self.CurrentFocusedList == "Super" then
        bShowSuperKey = true
    else
        bShowSuperKey = true
    end

    self.Key_GamePad1:SetVisibility(bShowSuperKey and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_GamePad2:SetVisibility(bShowSuperKey and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
end

function M:SetFocusToList(ListName)
    if ListName == "High" and self.List_Item_High then
        if self.GameInputModeSubsystem and self.GameInputModeSubsystem.SetTargetUIFocusWidget then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.List_Item_High)
        end
        if self.List_Item_High.SetFocus then
            self.List_Item_High:SetFocus()
        end
        self.CurrentFocusedList = "High"
        self:UpdateGamepadKeyVisibilityBasedOnCurrentFocus()
        return true
    elseif ListName == "Super" and self.List_Item_Super then
        if self.GameInputModeSubsystem and self.GameInputModeSubsystem.SetTargetUIFocusWidget then
            self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.List_Item_Super)
        end
        if self.List_Item_Super.SetFocus then
            self.List_Item_Super:SetFocus()
        end
        self.CurrentFocusedList = "Super"
        self:UpdateGamepadKeyVisibilityBasedOnCurrentFocus()
        return true
    end
    return false
end

function M:ToggleListFocusOnLeftThumbstick()
    if not self.UsingGamepad then
        return
    end

    if not self.CurrentFocusedList then
        if not self:SetFocusToList("Super") then
            self:SetFocusToList("High")
        end
        return
    end

    if self.CurrentFocusedList == "High" then
        self:SetFocusToList("Super")
    elseif self.CurrentFocusedList == "Super" then
        self:SetFocusToList("High")
    else
        -- 兜底：切到 Super
        self:SetFocusToList("Super")
    end
end

function M:Close()
    M.Super.Close(self)
    EventManager:FireEvent(EventID.BattlePassSkinClose, self.Eid)
end


AssembleComponents(M)
return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local FriendModel = FriendController:GetModel()
local GiftCommon = require("BluePrints.UI.WBP.Gift.GiftCommon")
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"

---@type WBP_Gift_GetGift_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

local EGreetingMode = {
    SenderMode = 1,
    RecverMode = 2
}

---仅初始化lua变量时使用，千万不要有控件操作！！
function M:Initialize(Initializer)
end

function M:Construct()
    self:AddDispatcher(EventID.OnGetMailRewards, self, self.OnGetMailRewards)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
    M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)

    local OtherUid, ShopItemId, GreetingsMode, Mail, SendPlayerInfo = ...
    ShopItemId = tonumber(ShopItemId)
    if OtherUid == "Test" then
        return
    end
    self.Mail = Mail
    self.ShopItemId = ShopItemId
    self.GreetingsMode = GreetingsMode
    self:InitTab()

    -- 送出的道具
    local ShopItemConfig = DataMgr.ShopItem[ShopItemId]
    self.ShopItemConfig = ShopItemConfig
    local ResourceConfig = DataMgr[ShopItemConfig.ItemType] and DataMgr[ShopItemConfig.ItemType][ShopItemConfig.TypeId]
    local ResourceObj = LoadObject(ResourceConfig.Icon)
    if ResourceObj then
        self.Image_GiftItem:SetBrushResourceObject(ResourceObj)
    end
    local SubName = DataMgr.ShopTabSub[ShopItemConfig.GiftSubTabId].SubName
    self.Text_ItemType:SetText(GText(SubName))
    self.Text_ItemName:SetText(GText(ResourceConfig.Name or ResourceConfig.ResourceName))

    ---region发送者和接收者
    local Anim, SenderInfo, RecverInfo
    if GreetingsMode == EGreetingMode.SenderMode then
        SenderInfo = GWorld:GetAvatar()
        RecverInfo = FriendModel:GetFriendDict()[OtherUid].Info
        self.RecverUid = OtherUid
        self.SenderUid = SenderInfo.Uid
        Anim = self.SendOut_In
    elseif GreetingsMode == EGreetingMode.RecverMode then
        if SendPlayerInfo then
            SenderInfo = SendPlayerInfo
        else
            SenderInfo = FriendModel:GetFriendDict()[OtherUid].Info
        end
        RecverInfo = GWorld:GetAvatar()
        Anim = self.Accept_In
    end

    -- 播放入场动画
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    self:BindToAnimationFinished(Anim, {self, self.LoopAnim})
    self:PlayAnimation(Anim)

    -- 送给谁
    self.Text_To:SetText(GText("UI_SendGift_To"))
    self.Text_PlayerName:SetText(GText(RecverInfo.Nickname))

    local HeadSculptureConfig = DataMgr.HeadSculpture[RecverInfo.HeadIconId]
    self.HeadTo:SetHeadIconById(HeadSculptureConfig.HeadId)

    local HeadFrameConfig = DataMgr.HeadFrame[RecverInfo.HeadFrameId]
    if HeadFrameConfig then
        self.HeadTo:SetHeadFrame(HeadFrameConfig.FrameID)
    end

    ---region 谁送的
    self.Text_PlayerName_From:SetText(GText(SenderInfo.Nickname))

    local HeadSculptureConfig = DataMgr.HeadSculpture[SenderInfo.HeadIconId]
    self.HeadFrom:SetHeadIconById(HeadSculptureConfig.HeadId)

    local HeadFrameConfig = DataMgr.HeadFrame[SenderInfo.HeadFrameId]
    if HeadFrameConfig then
        self.HeadFrom:SetHeadFrame(HeadFrameConfig.FrameID)
    end
    ---endregion
    self.Com_Input_Multiline:SetLineHeightPercentage(1)

    if GreetingsMode == EGreetingMode.RecverMode then
        self.HB_TextNum:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Text_Date:SetVisibility(UIConst.VisibilityOp["Visible"])

        local DateText = Utils.GDate_YMD_Timestamp(Mail.MailDate)
        self.Text_Date:SetText(DateText)

        self:GetCurrentSystemLanguage()
        local MailContent = GText(Mail.MailContent[self.CurrentSystemLanguage] or Mail.MailContent['CN'])
        self.Com_Input_Multiline.Text_Input:SetText(GText(MailContent))

        self:UpdateReceiveBtn()
        self.Com_Input_Multiline:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])

        AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "RecverModeToEnd", nil)
        AudioManager(self):PlayUISound(self, "event:/ui/common/recieve_gift", nil, nil)
    else
        self.HB_TextNum:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.Text_Date:SetVisibility(UIConst.VisibilityOp["Collapsed"])

        self.Text_Num01:SetText(GText("0")) -- 已输入字数
        self.Text_Num02:SetText(GText("40")) -- 最大字数限制
        self.Com_Input_Multiline:Init({
            bNeedPasteBtn = false,
            Owner = self,
            Events = {
                OnTextChanged = function(Owner, Text)
                    local WordCount = self.Com_Input_Multiline:Utf8StrLen(Text)
                    -- local WordCount = UKismetStringLibrary.Len(Text)
                    self.Text_Num01:SetText(GText(tostring(WordCount)))
                end,
                OnFocusReceived = function()
                    self.Com_Input_Multiline:SetHintText("")
                end,
                OnFocusLost = function()
                    self.Com_Input_Multiline:SetHintText(GText("UI_SendGift_DefaultWord"))
                end
            },
            HintText = GText("UI_SendGift_DefaultWord"), -- 默认赠言
            TextLimit = 40, -- 最大字数限制
            BackFocusWidget = self,
            HideGamePadDeleteBtn = true

        })
        self.WS_Btn:SetActiveWidgetIndex(0)
        self.Com_Input_Multiline:SetVisibility(UIConst.VisibilityOp["Visible"])
        -- region 付费按钮
        self:UpdatePayPrice()

        local CurrencyId = ShopItemConfig.PriceType
        local CurrencyConfig = DataMgr.Resource[CurrencyId]
        self.Btn_GiftPay.Icon_Currency:Init({
            Id = CurrencyConfig.ResourceId,
            Icon = ItemUtils.GetItemIcon(ShopItemConfig.PriceType, "Resource"),
            ItemType = CurrencyConfig.ResourceSType,
            UIName = "GiftGet",
            IsShowDetails = true,
            MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
        })
        self.Btn_GiftPay.Text_BtnBuy:SetText(GText("UI_SendGift_BuyGift"))
        self.Btn_GiftPay:BindEventOnClicked(self, self.OnPurChaseClick)
        self.Btn_GiftPay:SetGamePadIconVisible(true)
        ---endregion

        AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SenderModeToEnd", nil)
        AudioManager(nil):PlayUISound(nil, "event:/ui/common/send_gift_start", nil, nil)
    end
end

function M:InitTab()
    local Platform = CommonUtils.GetDeviceTypeByPlatformName(self) -- 移动端还是PC端
    local IsPC = Platform == "PC"
    self.WS_Tab:SetActiveWidgetIndex(IsPC and 0 or 1)

    local TitleName = GText("UI_SendGift_SystemName")
    if self.GreetingsMode == EGreetingMode.SenderMode then
        if IsPC then
            self.Com_Tab_P:Init({
                DynamicNode = {"Back", "ResourceBar", "BottomKey"},
                OverridenTopResouces = {CommonConst.Coins.Coin4},
                TitleName = TitleName,
                StyleName = "Text",
                OwnerPanel = self,
                BackCallback = self.OnPressESC,
                BottomKeyInfo = {{
                    KeyInfoList = {{
                        Type = "Text",
                        Text = "Esc",
                        ClickCallback = self.OnPressESC,
                        Owner = self
                    }},
                    GamePadInfoList = {{
                        Type = "Img",
                        ImgShortPath = "B",
                        ClickCallback = self.OnPressESC,
                        Owner = self
                    }},
                    Desc = GText("UI_BACK")
                }}
            })
        else
            self.Com_Tab_M:Init({
                DynamicNode = {"Back", "ResourceBar"},
                OverridenTopResouces = {CommonConst.Coins.Coin4},
                TitleName = TitleName,
                StyleName = "Text",
                OwnerPanel = self,
                BackCallback = self.OnPressESC
            })
        end
    else
        if IsPC then
            self.Com_Tab_P:Init({
                DynamicNode = {"Back", "BottomKey"},

                TitleName = TitleName,
                StyleName = "Text",
                OwnerPanel = self,
                BackCallback = self.OnPressESC,
                BottomKeyInfo = {{
                    KeyInfoList = {{
                        Type = "Text",
                        Text = "Esc",
                        ClickCallback = self.OnPressESC,
                        Owner = self
                    }},
                    GamePadInfoList = {{
                        Type = "Img",
                        ImgShortPath = "B",
                        ClickCallback = self.OnPressESC,
                        Owner = self
                    }},
                    Desc = GText("UI_BACK")
                }}
            })
        else
            self.Com_Tab_M:Init({
                DynamicNode = {"Back"},
                TitleName = TitleName,
                StyleName = "Text",
                OwnerPanel = self,
                BackCallback = self.OnPressESC
            })
        end
    end
end

function M:OnPressESC()
    self:Close()
end

function M:LoopAnim()
    self:BlockAllUIInput(false)
    self:PlayAnimation(self.loop, 0, 0)
end

function M:UpdatePayPrice()
    if not self.ShopItemConfig then
        -- 此时界面InitUIInfo还没有执行
        return
    end
    local OwnedCurrency = GWorld:GetAvatar().Resources[self.ShopItemConfig.PriceType]
    local OwnedCurrencyAmount = OwnedCurrency and OwnedCurrency.Count or 0
    -- 不同地区显示的价格不同
    local Cost = ShopUtils:GetShopItemPrice(self.ShopItemId) or 0
    local IsEnough = OwnedCurrencyAmount >= Cost
    self.IsEnough = IsEnough
    if not IsEnough then
        self.Btn_GiftPay.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
    else
        self.Btn_GiftPay.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFFF"))
    end

    self.Btn_GiftPay.Text_Price:SetText(GText(tostring(Cost)))
    self.Btn_GiftPay.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:OnPurChaseClick()
    -- 如果此时拿不到好友数据，说明好友突然被删除了
    local FriendData = FriendModel:GetFriendDict()[self.RecverUid]
    if not FriendData then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_NoLongerFriend"))
        return
    end

    local SendCheck = function()
        if self.IsEnough then
            self:SendGift()
        else
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)

            -- 充值后直接关闭弹窗，并调用UpdatePayPrice刷新信息，如果一次充值游戏货币还是不够，则如此反复
            -- UIManager(self):ShowCommonPopupUI(GiftCommon.GiftShopPayContent, {
            --     Uid = self.SenderUid,
            --     ShopItemId = self.ShopItemId,
            --     RightCallbackObj = self,
            --     CallbackInfo = {
            --         Func = self.OnRechargeCallback,
            --         Obj = self
            --     },
            --     LeftGamepadKey = Const.GamepadFaceButtonUp,
            --     ShowBKeyClose = true
            -- })

            local Params = {}
            Params.ShopItemId = self.ShopItemId
            Params.Uid = self.SenderUid
            Params.CallbackInfo = {
                Func = self.OnRechargeCallback,
                Obj = self
            }

            UIManager(self):LoadUINew("ShopTargetPay", Params)
        end
    end

    if self.Com_Input_Multiline:GetText() == "" then
        SendCheck()
    else
        if not HeroUSDKSubsystem():IsHeroSDKEnable() then
            SendCheck()
        else
            HeroUSDKUtils.CheckStringSensitive(self, self.Com_Input_Multiline:GetText(), function()
                SendCheck()
            end, function()
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_SensitiveToast"))
            end, false)
        end
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == UIConst.GamePadKey.RightThumb then
        local IsEventHandled = self.Com_Tab_P:Handle_KeyEventOnGamePad(InKeyName) or false
        if IsEventHandled then
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end

    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        -- A
        if self.GreetingsMode == EGreetingMode.SenderMode then
            self:HandleA()
            return UIUtils.Handled
        else
            if self.Mail.RewardGot == 1 then
                return UIUtils.Handled
            else
                self:ReceiveGift()
                return UIUtils.Handled
            end
        end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        -- B
        self:Close()
        return self:HandleX()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        -- X
        if self.GreetingsMode == EGreetingMode.SenderMode then
            return self:HandleX()
        end
    end
    return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:HandleA()
    self:OnPurChaseClick()
end

-- 聚焦送礼文本输入框
function M:HandleX()
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.Com_Input_Multiline)
end

function M:SendGift()
    local Content = self.Com_Input_Multiline:GetText()
    if Content == "" then
        Content = GText("UI_SendGift_DefaultWord")
    end

    -- 如果此时拿不到好友数据，说明好友突然被删除了
    local FriendData = FriendModel:GetFriendDict()[self.RecverUid]
    if not FriendData then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_NoLongerFriend"))
        return
    end

    local Callbacks_Style2 = {
        OnSuccess = {
            Obj = self,
            Func = function(_Self)
                GiftController:SendToShopResourceGift(self.RecverUid, self.ShopItemId, self.ShopItemConfig.TypeNum,
                    Content, {
                        Obj = self,
                        Func = self.OnSendCallback
                    })
            end
        },

        OnCancel = {
            Obj = self,
            Func = function()

            end
        }
    }

    SecondaryPasswordController:RequestSecPasswordValidation(Callbacks_Style2)
end

function M:OnSendCallback(ErrCode, ...)
    local anim
    if ErrCode == ErrorCode.RET_SUCCESS then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_Success"))
        anim = self.SendOut_Out
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
        AudioManager(nil):PlayUISound(nil, "event:/ui/common/send_gift_end", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
        anim = self.Out
    end

    self:Close(anim)
end

-- function M:Tick(MyGeometry, InDeltaTime)
-- end

function M:Close(Anim)
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    Anim = Anim or self.Out
    self:BindToAnimationFinished(Anim, {self, function()
        if self.GreetingsMode == EGreetingMode.SenderMode then
            AudioManager(self):SetEventSoundParam(self, "SenderModeToEnd", {
                ToEnd = 1
            })
        else
            AudioManager(self):SetEventSoundParam(self, "RecverModeToEnd", {
                ToEnd = 1
            })
        end

        M.Super.Close(self)
        GiftController:OnSendGiftFinished() -- 关闭贺卡界面后要回到商店主界面
        self:BlockAllUIInput(false)
        self.ShopItemId = nil
        self.IsEnough = nil
        self.RecverUid = nil
        self.ShopItemConfig = nil
        self.SenderUid = nil
        self.Mail = nil

    end})
    self:PlayAnimation(Anim)
end

-- function M:Destruct()
-- end

function M:GetCurrentSystemLanguage()
    local SystemLanguages = {
        CN = "TextMapContent",
        EN = "ContentEN",
        JP = "ContentJP",
        KR = "ContentKR",
        TC = "ContentTC",
        FR = "ContentFR",
    }
    self.CurrentSystemLanguage = 'CN'
    for key, value in pairs(SystemLanguages) do
        if CommonConst.SystemLanguage == value then
            self.CurrentSystemLanguage = key
        end
    end
end

function M:UpdateReceiveBtn()
    if self.Mail then
        if self.Mail.RewardGot == 1 then
            self.WS_Btn:SetActiveWidgetIndex(2)
            self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(0)
            self.Com_Hint.WS_Normal:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Com_Hint.Text_Hint_Normal:SetText(GText("UI_SendGift_AlreadyGet"))
        else
            self.WS_Btn:SetActiveWidgetIndex(1)
            self.Btn_Reward:BindEventOnClicked(self, self.ReceiveGift)
            self.Btn_Reward.Text_Button:SetText(GText("UI_SendGift_Get"))
            self.Btn_Reward:TryOverrideSoundFunc(self.PlayReceiveSound)
            self.Btn_Reward:SetGamePadIconVisible(true)
        end
    end
end

function M:PlayReceiveSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large_crystal", nil, nil)
end

-- 充值成功后弹出充值弹窗
function M:OnRechargeCallback(GoodsId, ShopItems, OrderId)
    if ShopItems then
        if DataMgr.PayGoods[GoodsId].ItemId then
            -- if not UIManager(self):GetUIObj("ShopMain") then
            --     local ShopItemData = DataMgr.ShopItem[DataMgr.PayGoods[GoodsId].ItemId]
            --     assert(ShopItemData, "购买成功后读表ShopItemData为空", DataMgr.PayGoods[GoodsId].ItemId)
            --     if ShopItemData.ItemType == "DailyPack" then
            --         UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, ShopItems, ShopItemData.IsSpPopup, function()
            --             UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_DailyPack_PurchaseDone"))
            --         end)
            --     else
            --         UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, ShopItems, ShopItemData.IsSpPopup)
            --     end
            -- end
            self:UpdatePayPrice()
        end
    end
end

function M:ReceiveGift()
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:GetMailRewards(self.Mail.UniqueId)
end

function M:OnGetMailRewards()
    self:BlockAllUIInput(false)
    self:UpdateReceiveBtn()
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    self:UpdatePayPrice()
end

return M

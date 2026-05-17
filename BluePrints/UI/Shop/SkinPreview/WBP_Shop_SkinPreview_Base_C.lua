require "UnLua"

---@type WBP_Shop_SkinPreview_C
local M = Class("BluePrints.UI.BP_UIState_C")
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local GiftController = require "BluePrints.UI.WBP.Gift.GiftController"
local GiftCommon = require "BluePrints.UI.WBP.Gift.GiftCommon"
M._components = {
    "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
    "BluePrints.UI.Shop.SkinPreview.SkinPreview_ActorComponent",
    "BluePrints.UI.Shop.SkinPreview.SkinPreview_DescriptionComponent",
    "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent",
}

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    M.Super.Construct(self)

    -- 初始化按键
    self.KeyDownEvents = {}
    self.RepeatKeyDownEvents = {}
    self.TabStyleName = "Text"
    self.UKey = "U"
    self.RKey = "R"
    -- self.LeftMouseButton = EKeys.LeftMouseButton.KeyName
    self.EscapeKey = EKeys.Escape.KeyName
    self.LeftThumbstickKey = UIConst.GamePadKey.LeftThumb
    self.GamePadHideUIKey = UIConst.GamePadKey.FaceButtonLeft
    self.GamePadBackKey = UIConst.GamePadKey.FaceButtonRight
    self.GamePadConfirmKey = UIConst.GamePadKey.FaceButtonBottom
    self.GamePadOpenSuitKey = UIConst.GamePadKey.FaceButtonTop
    self.LeftShoulderKey = UIConst.GamePadKey.LeftShoulder
    self.RightShoulderKey = UIConst.GamePadKey.RightShoulder
    self.LeftTriggerKey = UIConst.GamePadKey.LeftTriggerThreshold
    self.RightTriggerKey = UIConst.GamePadKey.RightTriggerThreshold
    self.DPadLeftKey = UIConst.GamePadKey.DPadLeft
    self.DPadRightKey = UIConst.GamePadKey.DPadRight
    self.DPadUpKey = UIConst.GamePadKey.DPadUp
    self.MenuKey = UIConst.GamePadKey.SpecialRight
    self.ViewKey = UIConst.GamePadKey.SpecialLeft

    self.ZoomKey = "Mouse_Button"
    self.ReplayKey = "R"

    self.MainTabsStyle = {
        TitleName = GText("UI_Armory_Appearance"),
        LeftKey = "NotShow",
        RightKey = "NotShow",
        Tabs = {},
        DynamicNode= {
            "Back",
            "ResourceBar",
        },
        BottomKeyInfo = {},
        StyleName = "Text",
        OwnerPanel = self,
        LastFocusWidget = self,
        OnResourceBarAddedToFocusPath = function()
            self.Btn_Function:SetGamePadVisibility(ESlateVisibility.Collapsed)
            self.Key_GamePad_L:SetVisibility(ESlateVisibility.Collapsed)
            self.Key_GamePad_R:SetVisibility(ESlateVisibility.Collapsed)

        end,
        OnResourceBarRemovedFromFocusPath = function()
            if self.IsGamepadInput then
                self.Btn_Function:SetGamePadVisibility(ESlateVisibility.SelfHitTestInvisible)
                self.Key_GamePad_L:SetVisibility((self.bFirst or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
                self.Key_GamePad_R:SetVisibility((self.bLast or self.ShopItemData.SinglePreview) and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
            end
        end,
        BackCallback = self.OnBackKeyDown
    }

    -- 套装预览按钮初始化
    local ConfigData = {
        ClickCallback = self.OnClickSuitPreviewDialog,   --按钮的回调
        OwnerWidget = self,       --所属的对象
        -- SoundFunc = function,       --列表点击音效
        -- SoundFuncReceiver = Obj,    --列表点击音效接收对象
    }
    self.Btn_Preview:Init(ConfigData)
    self.Btn_Preview.SoundFunc = function()
        AudioManager(self):PlayUISound(self.Btn_Preview, "event:/ui/common/click_btn_small", nil, nil)
    end

    -- 按钮点击回调绑定
    self:ResetPreviewCheckBox()
    self.CheckBox_Preview:RemoveEventOnCheckStateChanged(self)
    self.CheckBox_Preview:AddEventOnCheckStateChanged(self, self.OnSwitchSuitPreview)
    self.Btn_Function:BindEventOnClicked(self, self.PurChase)
    self.Btn_Function:TryOverrideSoundFunc(function()
        -- AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
    end)
    self.Btn_Selective = self.Btn_Dye.Btn_Click
    self.Text_Color = self.Btn_Dye.Text_Btn
    self.HorizontalBox_Color = self.Btn_Dye
    self.Btn_Selective.OnClicked:Add(self, self.OnClickDyeingPreview)
    self.Btn_L:BindEventOnClicked(self, self.OnClickPreviousSkin)
    self.Btn_R:BindEventOnClicked(self, self.OnClickNextSkin)
    self.Image_Click.OnMouseButtonDownEvent:Unbind()
    self.Image_Click.OnMouseButtonDownEvent:Bind(self,self.On_Image_Click_MouseButtonDown)
    -- 送礼按钮
    self.Btn_Choose:UnBindEventOnClickedByObj(self)
    self.Btn_Choose:BindEventOnClicked(self, self.OnBtnChooseGiftClicked)
    self.Btn_Choose:BindForbidStateExecuteEvent(self, self.OnBtnChooseGiftClicked)
    -- 解锁条件按钮
    self.Com_Hint:UnBindEventOnClickedByObj(self)
    self.Com_Hint:BindEventOnClicked(self, function()
        ShopUtils:OpenLockConditionPopup(self.ShopItemData)
    end)

    -- 设置文本信息
    self.Text_Preview:SetText(GText("UI_SkinPreview_ShowSuit"))
    self.Text_Color:SetText(GText("UI_SkinPreview_Dye"))
    self.Btn_Function:SetText(GText("UI_SHOP_PURCHASE"))

    -- 初始化控件显隐
    self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
    self.WBP_Com_Cost:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Num_Price:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

    -- 初始化布尔值
    self.bForbiddenButton = false
    self.bSelfHidden = false
    self.BtnChooseGiftEnable = false
    self.BtnSkinLevelUp = false

    -- 初始化切换近战远程武器Tab
    self.Tab_Change.Text_Alive:SetText(GText("UI_Armory_Meleeweapon"))
    self.Tab_Change.Text_Dying:SetText(GText("UI_Armory_Longrange"))

    -- 初始化手柄状态变量
    self.IsGamepadInput = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad

    self.Btn_Discount_Light:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:Destruct()
    self:DestroyPreviewActor()
    self.CheckBox_Preview:RemoveEventOnCheckStateChanged(self)
    self.Btn_Function:UnBindEventOnClickedByObj(self)
	self.Btn_Selective.OnClicked:Clear()
    self.Image_Click.OnMouseButtonDownEvent:Unbind()
    M.Super.Destruct(self)
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self)

    self.ShopItemData, self.ParentWidget = ...

    -- 识别是否来自礼物商店，以便调整购买按钮与流程
    self.bInGiftShop = (self.ParentWidget and self.ParentWidget.ShopType == "GiftShop") or false

    -- 根据上下文更新按钮文案（在 OnLoaded 中进行，确保 bInGiftShop 已赋值）
    if self.bInGiftShop then
        self.Btn_Function:SetText(GText("UI_SendGift_Send"))
    else
        self.Btn_Function:SetText(GText("UI_SHOP_PURCHASE"))
    end

    if not self.ShopItemData.SinglePreview then
        --- 添加对传入皮肤列表的支持
        if self.ShopItemData.SkinList then
            self.SkinList = self.ShopItemData.SkinList
            self.Index2ShopSkin = {}
            self.ShopSkin2Index = {}
            self.SkinCount = #self.SkinList
            for Index, SkinId in ipairs(self.SkinList) do
                self.Index2ShopSkin[Index] = SkinId
                self.ShopSkin2Index[SkinId] = Index
            end
            self.ShopItemData.TypeId = self.Index2ShopSkin[1]
            self.ShopItemData.ItemId = self.Index2ShopSkin[1]
        else
            -- 获取商城记录的皮肤列表
            self.Index2ShopSkin, self.ShopSkin2Index, self.SkinCount = ShopUtils:GetShopSkinList()
        end
        if self.Index2ShopSkin == nil or self.ShopSkin2Index == nil or self.SkinCount == nil then
            self.ShopItemData.SinglePreview = true
            self.ShopItemData.HidePurchase = false
        end
    end

    self.HidePurchase = self.ShopItemData.HidePurchase or false

    -- 初始化设置Tab信息
    self.Tab_Skin:Init(self.MainTabsStyle)
    
    -- 设置资源栏返回控件
    if self.Tab_Skin.WBP_Com_Tab_ResourceBar then
        self.Tab_Skin.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self)
    end

    -- 初始化近战/远程武器Tab
    self.Tab_Change:Init({
        Parent = self,
        TabIdx = 1,
        OnTabClicked = self.OnTabChangeClicked,
    })

    -- 初始化键位设置
    self:InitKeySetting()

    -- 更新UI
    self:UpdateUI()

    -- 播放音效
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SkinPreviewIn", nil)

    -- 播放进入动画
    self:PlayAnimation(self.In)
    self:BlockAllUIInput(true,"SP_DisplayOnly")

    self:SetFocus()

    -- 设置皮肤升级效果
    self:InitLevelUpPreview(self.ShopItemData)
end

function M:InitKeySetting()

    -- 初始化按键事件
    self.KeyDownEvents[self.EscapeKey] = self.OnBackKeyDown
    -- self.KeyDownEvents[self.LeftMouseButton] = self.OnLeftMouseButtonDown
    self.KeyDownEvents[self.UKey] = self.OnHideUIKeyDown
    self.KeyDownEvents[self.RKey] = self.OnRKeyDown

    -- 初始化手柄按钮事件
    self.KeyDownEvents[self.GamePadBackKey] = self.OnBackKeyDown
    self.RepeatKeyDownEvents[self.LeftTriggerKey] = self.OnCameraScrollBackwardKeyDown
    self.RepeatKeyDownEvents[self.RightTriggerKey] = self.OnCameraScrollForwardKeyDown
    self.KeyDownEvents[self.GamePadHideUIKey] = self.OnHideUIKeyDown
    self.KeyDownEvents[self.MenuKey] = self.OnClickSuitPreviewDialog
    self.KeyDownEvents[self.ViewKey] = self.OnClickDyeingPreview
    self.KeyDownEvents[self.LeftThumbstickKey] = self.OnBtnChooseGiftClicked
    self.KeyDownEvents[self.GamePadConfirmKey] = self.OnConfirmKeyDown
    self.KeyDownEvents[self.DPadLeftKey] = self.OnClickPreviousSkin
    self.KeyDownEvents[self.DPadRightKey] = self.OnClickNextSkin
    self.KeyDownEvents[self.DPadUpKey] = self.OnClickDiscount
    self.KeyDownEvents[self.LeftShoulderKey] = function(self)
        if self.ShopItemData.ItemType ~= "WeaponAccessory" then
            return
        end
        self.Tab_Change:TriggerSwitch("Left")
        return UIUtils.Handled, true
    end
    self.KeyDownEvents[self.RightShoulderKey] = function(self)
        if self.ShopItemData.ItemType ~= "WeaponAccessory" then
            return
        end
        self.Tab_Change:TriggerSwitch("Right")
        return UIUtils.Handled, true
    end
end

function M:OnBtnChooseGiftClicked()
    if self.BtnChooseGiftEnable then
        if self.Btn_Choose:IsBtnForbidden() then
            ShopUtils:OpenForbidGiftChooseTip()
        else
            ShopUtils:OpenChooseGiftTarget(self.ShopItemData.ItemId, self)
        end
    elseif self.BtnSkinLevelUp then
        if self.WBP_Armory_Skin_LevelUp_1.Btn_Area:HasAnyUserFocus() or self.WBP_Armory_Skin_LevelUp_2.Btn_Area:HasAnyUserFocus() or self.WBP_Armory_Skin_LevelUp_3.Btn_Area:HasAnyUserFocus() then
            return
        else
            self.WBP_Armory_Skin_LevelUp_1:SetFocus()
        end
    end
    return UIUtils.Handled, true
end

--- 套装预览CheckBox点击
function M:OnClickSuitPreview()
    if self.ShopItemData.SuitRewardId == nil or #self.ShopItemData.SuitRewardId == 0 then
        return
    end
    if self.bBlockClickSuitPreview or self.bBlockClickChangeSkin then return end
    self.CheckBox_Preview:OnBtnClicked()
    return UIUtils.Handled, true
end

--- 套装预览CheckBox切换回调
function M:OnSwitchSuitPreview(IsChecked)
    -- 防止快速点击切换套装预览
    self.bBlockClickSuitPreview = true
    self.CheckBox_Preview.ButtonArea:SetVisibility(ESlateVisibility.HitTestInvisible)
    self:AddTimer(0.6, function(self)
        self.bBlockClickSuitPreview = false
        self.CheckBox_Preview.ButtonArea:SetVisibility(ESlateVisibility.Visible)
    end)

    self.SwitchSuitChecked = IsChecked

    if IsChecked then
        self:ApplySuitPreview(self.ShopItemData)
    else
        self:RevertToSingleItemPreview(self.ShopItemData)
    end
end

--- ESC/手柄返回键按下
function M:OnBackKeyDown()
    if(self.bSelfHidden)then
        return self:OnHideUIKeyDown()
    else
        self:CloseSelf()
        return UIUtils.Handled, true
    end
end

--- 隐藏UI按键按下
function M:OnHideUIKeyDown()
    self.bSelfHidden = not self.bSelfHidden
    if(self.bSelfHidden)then
        self:SetRenderOpacity(0)
        self.Image_Click.Slot:SetZOrder(10)
    else
        self:SetRenderOpacity(1)
        self.Image_Click.Slot:SetZOrder(-1)
    end
    return UIUtils.Handled, true
end

--- 打开套装内容弹窗
function M:OnClickSuitPreviewDialog()
    if self.ShopItemData.SuitRewardId == nil or #self.ShopItemData.SuitRewardId == 0 then
        return
    end
    local Rewards = DataMgr.Reward[self.ShopItemData.SuitRewardId[1]]
    if Rewards then
        local Params = {
            ItemId = Rewards.Id,
            ItemType = Rewards.Type,
        }
        UIManager(self):ShowCommonPopupUI(100240, Params, self)
    end
    return UIUtils.Handled, true
end

function M:OnRKeyDown()
    if self.ShopItemData.ItemType ~= "Resource" and self.ShopItemData.ItemType ~= "Mount" then
        return
    end
    if self.ShopItemData.ResourceSType == "GestureItem" then
        self:OnReplayGesture()
    elseif self.ShopItemData.ItemType == "Mount" then
        self:OnRideMount()
    end
    return UIUtils.Handled, true
end

function M:OnReplayGesture()
    if self.ShopItemData.ItemType ~= "Resource" then
        return
    end
    if self.ReplayGesture then
        self:ReplayGesture(self.ShopItemData.TypeId)
    end
end

function M:OnRideMount()
    if self.ShopItemData.ItemType ~= "Mount" then
        return
    end
    if self.RiderMount then
        self:RiderMount(self.ShopItemData.TypeId)
    end
end

--- 染色预览
function M:OnClickDyeingPreview()
    if self.bBlockClickSuitPreview or self.bBlockClickChangeSkin then return end
    if self.ShopItemData.ItemType ~= "Skin" and self.ShopItemData.ItemType ~= "WeaponSkin" and self.ShopItemData.ItemType ~= "Hair" then
        return
    end
    if self.SwitchSuitChecked then
        self.CheckBox_Preview:OnBtnClicked()
    end
    local SkinType
    if self.ShopItemData.ItemType == "Hair" then
        SkinType = CommonConst.DataType.Hair
    elseif self.ShopItemData.ItemType == "Skin" or self.ShopItemData.ItemType == "WeaponSkin" then
        SkinType = CommonConst.DataType.Skin
    end
    AudioManager(self):PlayUISound(self.Btn_Selective, "event:/ui/common/click_btn_small", nil, nil)
    local Params = {Target = self.Params.Target, Type = self.Params.Type, SkinId = self.Params.SkinId, HairId = self.Params.HairId,
    IsPreviewMode = self.IsPreviewMode,Parent = self, OpenPreviewDyeFromShopItem = true, SkinType = SkinType,
    OnCloseCallback = function()
        local Avatar = ArmoryUtils:GetAvatar()
        if(self.Params.Type == CommonConst.ArmoryType.Char)then
            self.Params.Target = Avatar.Chars[self.Params.Target.Uuid] or self.Params.Target
        elseif (self.Params.Type == CommonConst.ArmoryType.Weapon)then
            self:ResetWeaponCamera()
            self.Params.Target = Avatar.Weapons[self.Params.Target.Uuid] or self.Params.Target
        end
    end}
    if Params.Target and Params.Target.Uuid == 1 then
        Params.Target.Uuid = Params.SkinId
        local RealAvatar = ArmoryUtils:GetAvatar()
        if RealAvatar and self.Type == CommonConst.ArmoryType.Char and RealAvatar.Chars then
            for CharUuid, RealChar in pairs(RealAvatar.Chars) do
                if RealChar.CharId == Params.Target.CharId then
                    Params.Target = RealChar
                    Params.bRealCharOrWeapon = true
                    break
                end
            end
        elseif self.Type == CommonConst.ArmoryType.Weapon and RealAvatar.Weapons then
            for WeaponUuid, RealWeapon in pairs(RealAvatar.Weapons) do
                if RealWeapon.WeaponId == Params.Target.WeaponId then
                    Params.Target = RealWeapon
                    Params.bRealCharOrWeapon = true
                    break
                end
            end
        end
    elseif Params.Target and Params.Target.Uuid ~= 1 then
        Params.bRealCharOrWeapon = true
    end
    Params.IsPreviewMode = true
    local UIConfig = DataMgr.SystemUI.ArmoryDye
    if self.Parent then
        UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName,self.Parent:GetZOrder(),Params)
    else
        UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName,100,Params)
    end
    return UIUtils.Handled, true
end

--- 武器近战/远程切换回调
function M:OnTabChangeClicked(TabIdx)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.SwitchSuitChecked then
        self.CheckBox_Preview:OnBtnClicked()
    else
        if self.SwitchWeaponAccessoryPreview then
            self:SwitchWeaponAccessoryPreview(TabIdx)
        end
    end
end

function M:ResetPreviewCheckBox()
    local Checked = self.CheckBox_Preview:GetChecked()
    self.CheckBox_Preview.IsChecked = false
    self.CheckBox_Preview.ButtonArea:SetVisibility(ESlateVisibility.Visible)
    self.SwitchSuitChecked = false
    if Checked then
        self.CheckBox_Preview:PlayAnimation(self.CheckBox_Preview.Close_Normal)
    end
end

--- 切换至前一个皮肤
function M:OnClickPreviousSkin()
    if self.bFirst or self.bBlockClickChangeSkin or self.bBlockClickSuitPreview or self.ShopItemData.SinglePreview then
        return
    end
    self:ResetPreviewCheckBox()
    self.LastItemType = self.ShopItemData.ItemType
    self:SwitchToSkin(self.Index - 1)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_addMulti", nil, nil)
    return UIUtils.Handled, true
end

--- 切换至后一个皮肤
function M:OnClickNextSkin()
    if self.bLast or self.bBlockClickChangeSkin or self.bBlockClickSuitPreview or self.ShopItemData.SinglePreview then
        return
    end
    self:ResetPreviewCheckBox()
    self.LastItemType = self.ShopItemData.ItemType
    self:SwitchToSkin(self.Index + 1)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_addMulti", nil, nil)
    return UIUtils.Handled, true
end

function M:OnClickDiscount()
    if self.bSelfHidden then
        return
    end
    if self.Btn_Discount_Light and self.Btn_Discount_Light:IsVisible() and self.bCanOpenDiscount then
        self.Btn_Discount_Light:OnButtonClicked()
    end
    return UIUtils.Handled, true
end

--- 切换到指定索引的皮肤
function M:SwitchToSkin(targetIndex)
    local SkinInfo = self:GetSkinInfo(targetIndex)
    if not SkinInfo then
        return
    end
    self.ShopItemData = SkinInfo

    if (self.ShopItemData.ItemType == "WeaponAccessory") or (self.ShopItemData.ItemType == "CharAccessory") then
        AudioManager(self):PlayItemSound(self, self.ShopItemData.TypeId, "Equip", self.ShopItemData.ItemType)
    end

    -- 更新UI
    self:UpdateUI()

    -- 播放切换动画
    self:PlayAnimation(self.Change)
    self:BlockAllUIInput(true,"SP_DisplayOnly")
end

function M:UpdateUI()
    self.Btn_Selective.OnClicked:Clear()

    -- 更新预览Actor
    self:UpdatePreviewActor(self.ShopItemData, FVector(40, 35, 0))

    -- 更新皮肤描述
    self:UpdateDescription(self.ShopItemData)

    -- 防止快速点击左右切换皮肤
    self.bBlockClickChangeSkin = true
    self.Btn_L.Btn:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.Btn_R.Btn:SetVisibility(ESlateVisibility.HitTestInvisible)
    self:AddTimer(0.6, function(self)
        self.bBlockClickChangeSkin = false
        self.Btn_L.Btn:SetVisibility(ESlateVisibility.Visible)
        self.Btn_R.Btn:SetVisibility(ESlateVisibility.Visible)
    end)

    -- 更新顶部资源栏
    if not self.HidePurchase then
        if self.ShopItemData.PriceType == CommonConst.Coins.Coin1 then
            self.MainTabsStyle.OverridenTopResouces = {CommonConst.Coins.Coin4, CommonConst.Coins.Coin1}
        else
            self.MainTabsStyle.OverridenTopResouces = {self.ShopItemData.PriceType}
        end
        self.Tab_Skin:OverrideTopResource(self.MainTabsStyle.OverridenTopResouces, true)
    end

    -- 更新套装预览组件显示状态
    if self.ShopItemData.SuitRewardId then
        self.Panel_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Preview:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.CheckBox_Preview:SetVisibility(ESlateVisibility.Visible)
    else
        self.Panel_Preview:SetVisibility(ESlateVisibility.Collapsed)
        self.Text_Preview:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Preview:SetVisibility(ESlateVisibility.Collapsed)
        self.CheckBox_Preview:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 更新左右箭头状态
    if not self.ShopItemData.SinglePreview then
        self.Index, self.bFirst, self.bLast = self:GetSkinIndex(self.ShopItemData.ItemId)
        self.Btn_L:SetVisibility(self.bFirst and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
        self.Btn_R:SetVisibility(self.bLast and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
    else
        self.Btn_L:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_R:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 更新购买按钮状态
    self.bCanOpenDiscount = false
    if not self.HidePurchase then

        --- BDC埋点上传
        local TrackInfo = {}
        TrackInfo.product_id = self.ShopItemData.ItemId
        TrackInfo.shop_id = self.ShopItemData.SubTabId
        HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_previewpage", TrackInfo)

        self.IsLockState = ShopUtils:CheckShopItemCondition(self.ShopItemData)
        if self.IsLockState then
            self:UpdateLockCondition()
        else
            -- 更新价格显示
            self:UpdateDiscount()
            self:UpdatePrice()
            self:UpdateButtonBuy()
            self:RemoveTimer("UpdatePriceTimer")
                -- 如果是限时折扣商品，添加定时器在折扣结束时刷新价格
            local CutoffInfo = ShopUtils:GetShopItemCutoffData(self.ShopItemData.ItemId)
            if CutoffInfo and CutoffInfo.CutoffEndTime then
                local NowTime = TimeUtils and TimeUtils.NowTime() or 0
                local RemainTime = CutoffInfo.CutoffEndTime - NowTime
                if RemainTime > 0 then
                    self:AddTimer(RemainTime, function()
                        if not self or not IsValid(self) then
                            return
                        end
                        self:UpdateDiscount()
                        self:UpdatePrice()
                        self:UpdateButtonBuy()
                    end, false, 0, "UpdatePriceTimer")
                end
            end
        end
    else
        self.WidgetSwitcher_BtnState:SetVisibility(ESlateVisibility.Collapsed)
        self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Discount_Light:SetVisibility(ESlateVisibility.Collapsed)
        self.bForbiddenButton = true
    end

    self:UpdateReplayTips()
end

--- 更新商品解锁条件
function M:UpdateLockCondition()
    self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
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

-- 计算可用折扣券
function M:UpdateDiscount()
    self.AutoSelectDiscount = EMCache:Get("AutoSelectDiscount", true)
    self.AvailableDiscounts = ShopUtils:GetValidVouchers(self.ShopItemData)
    self.bCanOpenDiscount = self.AvailableDiscounts and #self.AvailableDiscounts > 0

    local bSelectedVoucherExpired = false
    if self.SelectedDiscount then
        local bIsStillValid = false
        for _, voucher in ipairs(self.AvailableDiscounts) do
            if voucher.VoucherId == self.SelectedDiscount.VoucherId then
                bIsStillValid = true
                break
            end
        end

        if not bIsStillValid then
            bSelectedVoucherExpired = true
        end
    end

    local bIsNewItem = (self.LastDiscountItemId ~= self.ShopItemData.ItemId)
    if bIsNewItem or bSelectedVoucherExpired then
        if self.AvailableDiscounts and #self.AvailableDiscounts > 0 then
            if self.AutoSelectDiscount then
                self.SelectedDiscount = ShopUtils:GetBestVoucher(self.AvailableDiscounts)
            else
                self.SelectedDiscount = nil
            end
        else
            self.AvailableDiscounts = {}
            self.SelectedDiscount = nil
        end
        self.LastDiscountItemId = self.ShopItemData.ItemId
    end

    self:RemoveTimer("VoucherExpireTimer")
    ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, nil))
    local failReason = self.ShopItemData.PurchaseFailRes
    if ShopUtils:HasAnyVoucherConfig(self.ShopItemData.ItemId)
        and self.ShopItemData.PurchaseLimit == 1
        and not DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId]
        and not (failReason == 1 or failReason == 6) 
        and ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId) == 1 then
        self.Btn_Discount_Light:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Discount_Light:Init({
            ParentWidget = self,
            IsInPreview = true,
            ShopItemData = self.ShopItemData,
            AvailableDiscounts = self.AvailableDiscounts,
            SelectedDiscount = self.SelectedDiscount,
            OnDiscountChangedCallback = function(NewDiscount)
                self:OnDiscountChanged(NewDiscount)
            end,
            OnMenuStateChangedCallback = function(bIsOpen)
                self:OnDiscountMenuStateChanged(bIsOpen)
            end,
            TipsStateChangedCallback = function(Data, bIsOpen)
                if self.TipsStateChangedCallback then
                    self:TipsStateChangedCallback(Data, bIsOpen)
                end
            end,
            ItemTipsStateChangedCallback = function(Data, bIsOpen)
                if self.ItemTipsStateChangedCallback then
                    self:ItemTipsStateChangedCallback(Data, bIsOpen)
                end
            end,
            ItemFocusReceivedCallback = function(Data)
                if self.ItemFocusReceivedCallback then
                    self:ItemFocusReceivedCallback(Data)
                end
            end,
        })
        self:SetupVoucherExpireTimer()
    else
        self.Btn_Discount_Light:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:SetupVoucherExpireTimer()
    if not self.AvailableDiscounts or #self.AvailableDiscounts == 0 then return end
    
    local NearestExpireTime = math.huge
    local NowTime = TimeUtils.NowTime()
    
    for _, voucher in ipairs(self.AvailableDiscounts) do
        if voucher.ExpireTime and voucher.ExpireTime > NowTime and voucher.ExpireTime < NearestExpireTime then
            NearestExpireTime = voucher.ExpireTime
        end
    end
    
    if NearestExpireTime ~= math.huge then
        local RemainTime = NearestExpireTime - NowTime + 1 
        self:AddTimer(RemainTime, function()
            if not IsValid(self) then return end
            if IsValid(self.Btn_Discount_Light) and self.Btn_Discount_Light:IsVisible() and self.Btn_Discount_Light.ForceCloseMenu then
                self.Btn_Discount_Light:ForceCloseMenu()
            end
            self:UpdateDiscount()
            self:UpdatePrice()
            self:UpdateButtonBuy()
        end, false, 0, "VoucherExpireTimer")
    end
end

-- 计算商品价格及显示
function M:UpdatePrice()
    self.CurrentCount = 1
    self.UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
    self.CutoffData = ShopUtils:GetShopItemCutoffData(self.ShopItemData.ItemId)
    self.canPurchase = ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, self.UnitPrice)
    if self.CutoffData ~= nil or self.SelectedDiscount ~= nil then
        self.WBP_Com_Cost:InitContent({ResourceId = self.ShopItemData.PriceType, bShowDenominator = false, Numerator = self.UnitPrice})
        self.WBP_Com_Cost:SetGamePadIconVisible(false)
        local Resource = DataMgr.Resource[self.ShopItemData.PriceType]
        local Icon = LoadObject(Resource.Icon)
        self.WBP_Com_Cost.Common_Item_Icon:Init({
            Id = self.ShopItemData.PriceType,
            Icon = Icon,
            ItemType = "Resource",
            UIName = "CommonDialog",
            NotInteractive = false,
            IsShowDetails = true,
            IsCantItemSelection = false,
            MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
            HandleMouseDown = true,
            HandleKeyDown = false,
        })
        -- self.Text_Price:SetText(self.CutoffData.CutoffPrice)
        if self.SelectedDiscount then
             self.Text_Undiscounted_Price:SetText(ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId))
        else
            self.Text_Undiscounted_Price:SetText(self.ShopItemData.Price)
        end
    else
        self.WBP_Com_Cost:InitContent({ResourceId = self.ShopItemData.PriceType, bShowDenominator = false, Numerator = self.UnitPrice})
        self.WBP_Com_Cost:SetGamePadIconVisible(false)
        local Resource = DataMgr.Resource[self.ShopItemData.PriceType]
        local Icon = LoadObject(Resource.Icon)
        self.WBP_Com_Cost.Common_Item_Icon:Init({
            Id = self.ShopItemData.PriceType,
            Icon = Icon,
            ItemType = "Resource",
            UIName = "CommonDialog",
            NotInteractive = false,
            IsShowDetails = true,
            IsCantItemSelection = false,
            MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
            HandleMouseDown = true,
            HandleKeyDown = false,
        })
        -- self.Text_Price:SetText(self.ShopItemData.Price)
        self.Text_Undiscounted_Price:SetText("")
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
end

-- 控制购买按钮的显示状态和交互状态
function M:UpdateButtonBuy()
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Btn_Function:UnBindButtonPerformances()
    local failReason = self.ShopItemData.PurchaseFailRes
    self.WidgetSwitcher_BtnState:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.bInGiftShop then
        local shouldSoldOut = ShopUtils:ShouldPlaySoldOutAnimation(self.ShopItemData.ItemId)
        if shouldSoldOut then
            self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
            self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(1)
            self.Text_Desc:SetText(GText("UI_SendGift_GiftItemMax"))
            self.bForbiddenButton = true
            return
        else
            self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
            self.WBP_Com_Cost:SetIsEnough(true)
            self.Btn_Function:ForbidBtn(false)
            self.Btn_Function:BindButtonPerformances()
            self.bForbiddenButton = false
            return
        end
    end
    if failReason == 1 or failReason == 6 then
        -- 售罄 (1) 或 已持有唯一商品 (6)
        self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(1)
        self.Text_Desc:SetText(GText("UI_SHOP_ALREADYOWNED"))
        self.bForbiddenButton = true
    elseif failReason == 2 or failReason == 3 then
        -- 货币不足/等级不足
        local CurrentCount = self.Avatar:GetResourceNum(self.ShopItemData.PriceType)
        local Cost = self.UnitPrice
        self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
        self.WBP_Com_Cost:SetIsEnough(CurrentCount >= Cost)
        self.Btn_Function:ForbidBtn(true)
        self.Btn_Function.Button_Area.OnClicked:Add(self, self.PurChase)
        self.bForbiddenButton = false
    elseif failReason == 4 or failReason == 5 then
        -- 月石、月石晶胚不足
        self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
        self.WBP_Com_Cost:SetIsEnough(false)
        self.Btn_Function:ForbidBtn(false)
        self.Btn_Function:BindButtonPerformances()
        self.bForbiddenButton = false
    elseif self.canPurchase then
        self.Panel_Buy:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(0)
        self.WBP_Com_Cost:SetIsEnough(true)
        self.Btn_Function:ForbidBtn(false)
        self.Btn_Function:BindButtonPerformances()
        self.bForbiddenButton = false
    end
    self.BuyButtonState = self.Btn_Function:IsBtnForbidden()

    -- 刷新折扣选择Button
    if self.Btn_Discount_Light and self.Btn_Discount_Light:IsVisible() then
        self.Btn_Discount_Light:SetSelectedDiscount(self.SelectedDiscount)
    end
end

function M:OnDiscountChanged(NewDiscount)
    self.SelectedDiscount = NewDiscount
    
    self:PlayAnimation(self.Text_Refresh)
    self:UpdatePrice()
    self:UpdateButtonBuy()
end

function M:EnterSelectDiscountMode()
    --子类实现
end

function M:ExitSelectDiscountMode()
    --子类实现
end

function M:OnDiscountMenuStateChanged(bIsOpen)
    if bIsOpen then
        self.Btn_Function:ForbidBtn(true)
        self:EnterSelectDiscountMode()
    else
        if not self.BuyButtonState then
            self.Btn_Function:ForbidBtn(false)
        end
        self:ExitSelectDiscountMode()
        if UIUtils.IsGamepadInput() then
            self:SetFocus()
        end
    end
end

--- 更新重播按键
function M:UpdateReplayTips()
end

function M:GetOverrideTopResource()
    if self.ShopItemData.PriceType == CommonConst.Coins.Coin1 then
        return {CommonConst.Coins.Coin4, CommonConst.Coins.Coin1}
    else
        return {self.ShopItemData.PriceType}
    end
end

function M:OnConfirmKeyDown()
    if self.bSelfHidden then
        return
    end
    if self.IsLockState then
        if self.ConditionDisplay then
            return
        end
        ShopUtils:OpenLockConditionPopup(self.ShopItemData)
    else
        self:PurChase()
    end
end

--- 购买皮肤/配饰
function M:PurChase()
    if self.bSelfHidden then
        return
    end
    if self.bInGiftShop then
        return self:PurchaseGift()
    end
    if self.bForbiddenButton then
        return
    end
    if self.canPurchase then
        AudioManager(self):PlayUISound(self.Btn_Function, "event:/ui/activity/shop_small_btn_click", nil, nil)
    end
    local TrackInfo = {}
    TrackInfo.product_id = self.ShopItemData.ItemId
    TrackInfo.shop_id = self.ShopItemData.SubTabId
    TrackInfo.status = 2

    -- 4:月石不足 5:月石晶胚不足
    if self.ShopItemData.PurchaseFailRes == 2 then
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[self.ShopItemData.PriceType].ResourceName)), 1.0)
        HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
        return
    elseif self.ShopItemData.PurchaseFailRes == 3 then
        UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), self.ShopItemData.UnlockLevel), 1.0)
        HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
        return
    elseif self.ShopItemData.PurchaseFailRes == 4 then
        HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
        local PopUpId =  100136
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local ItemName = ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType)

        local PriceCount = Avatar.Resources[self.ShopItemData.PriceType] and Avatar.Resources[self.ShopItemData.PriceType].Count or 0

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
            PopoverText = string.gsub(PopoverText,'&Num1&',self.CurrentCount * self.UnitPrice - PriceCount)
        end
        if string.find(PopoverText,'&Num2&') then
            PopoverText = string.gsub(PopoverText,'&Num2&',self.CurrentCount)
        end

        local Confirm = function()
            local Coin4Count = 0
            if Avatar.Resources[CommonConst.Coins.Coin4] then
                Coin4Count =  Avatar.Resources[CommonConst.Coins.Coin4].Count
            end
            if self.CurrentCount * self.UnitPrice - PriceCount > Coin4Count then
                local JumpToShop = function()
                    self:CloseSelf()
                    local UIName = DataMgr.Shop["Shop"].ShopUIName
                    local ShopMainPage = UIManager(self):GetUIObj(UIName)
                    ShopMainPage:InitShop(110, nil, nil, "Shop", nil, nil)
                    -- PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId,nil,nil, "Shop")
                end
                local Params = {}
                Params.Title = GText("UI_COMMONPOP_TITLE_100137")
                Params.ShortText = GText("UI_COMMONPOP_TEXT_100137")
                Params.LeftCallbackObj = self
                Params.RightCallbackObj = self
                Params.RightCallbackFunction = JumpToShop
                UIManager(self):ShowCommonPopupUI(100137,Params, self)
            else
                ShopUtils:SendExchangeRequest(self.ShopItemData.ItemId, self.CurrentCount)
            end
        end
        local ItemList = {}
        local Coin4Count = Avatar.Resources[CommonConst.Coins.Coin4] and Avatar.Resources[CommonConst.Coins.Coin4].Count or 0
        table.insert(ItemList,{ItemId = CommonConst.Coins.Coin4,
            ItemType = CommonConst.ItemType.Resource,
            ItemNum = Coin4Count,
            ItemNeed = self.CurrentCount * self.UnitPrice - PriceCount})
        local Params = {
            RightCallbackFunction = Confirm,
            ItemList = ItemList,
            ShortText = PopoverText
        }
        UIManager(self):ShowCommonPopupUI(PopUpId,Params)
        return
    elseif self.ShopItemData.PurchaseFailRes == 5 then
        HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
            return
        end
        local ReOpenPurchase = function()
            if not IsValid(self) then
                return
            end
            self:UpdatePrice()
            self:UpdateButtonBuy()
            self:PurChase()
        end
        ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = ReOpenPurchase})
        local Params = {}
        Params.ShopItemId = self.ShopItemData.ItemId
        Params.VoucherId = self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil
        Params.Uid = Avatar.Uid
        Params.CloseBtnCallback = {
            Func = function()
                ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = nil})
            end
        }
        Params.BeforeClickNoCallback = {
            Obj = self,
            Func = self.Close
        }
        UIManager(self):LoadUINew("ShopTargetPay", Params)
        return
    end
    local RemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
    local CommonPopupUIID
    if RemainTimes == 0 then
        CommonPopupUIID = 100042
    else
            TrackInfo.status = 1
        CommonPopupUIID = 100041
    end
    if not CommonPopupUIID then
        return
    end
    local Funds = {}
    Funds[1] = {}
    Funds[1].FundId = self.ShopItemData.PriceType
    Funds[1].FundNeed = self.UnitPrice

    HeroUSDKSubsystem(self):UploadTrackLog_Lua("shop_confirmpage", TrackInfo)

    ---@type WBP_Common_Dialog_PC_C
    UIManager(self):ShowCommonPopupUI(CommonPopupUIID,
    {
        ShopItemData = self.ShopItemData,
        ShopType = 0,
        Funds = Funds,
        ShowParentTabCoin = true,
        SingleItemNotInteractive = true,
        SelectedDiscount = self.SelectedDiscount,
        bHasDraftDiscount = true,
        LeftCallbackObj = self,
        LeftCallbackFunction = function()
            local SkinPreview = UIManager(self):GetUIObj("SkinPreview")
            if SkinPreview then
                SkinPreview:SetFocus()
            end
        end,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, Data)
            if Obj then
                local count = 1
                if Data and Data.Content_1 and Data.Content_1.CallObj then
                    count = Data.Content_1.CallObj.CurrentCount or 1
                    Obj.SelectedDiscount = Data.Content_1.CallObj.SelectedDiscount
                end
                Obj:PurchaseShopItem(count)
            end
        end,
        ForbiddenRightCallbackObj = self,
        ForbiddenRightCallbackFunction = function(Obj, PackageData)
            PackageData.Content_1.CallFunc(PackageData.Content_1.CallObj)
        end,
        DontFocusParentWidget = true,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = function()
            local SkinPreview = UIManager(self):GetUIObj("SkinPreview")
            if SkinPreview then
                SkinPreview:SetFocus()
            end
        end,
        ForbidRightBtn = not self.canPurchase
    }, self)
end

function M:PurchaseGift()
    if self.canPurchase then
        AudioManager(self):PlayUISound(self.Btn_Function, "event:/ui/activity/shop_small_btn_click", nil, nil)
    end
    local giftMain = UIManager(self):GetUIObj(GiftCommon.GiftShopViewName)
    local OtherUid = giftMain and giftMain.FriendUid or nil
    if OtherUid then
        GiftController:TryToSendGift(OtherUid, self.ShopItemData.ItemId)
    else
        GiftController:OpenSelectFriendPopup(self.ShopItemData.ItemId, self)
    end
end

function M:PurchaseShopItem(Count)
    local FinalCount = Count or self.CurrentCount or 1
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
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
            local ItemName = ""
            ItemName = GText(ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType))

            HeroUSDKSubsystem():HeroSDKPay(PaymentParameters, GameRoleInfo, ItemName);
            local TrackInfo = {}
            TrackInfo.product_id = DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId]
            if self.ShopItemData.ItemId then
                TrackInfo.item_id = self.ShopItemData.ItemId
                TrackInfo.product_type = DataMgr.ShopItem[self.ShopItemData.ItemId].ItemType
            end
            TrackInfo.game_order_id = OrderId
            TrackInfo.order_create_time = TimeUtils.NowTime()
            HeroUSDKSubsystem(self):UploadTrackLog_Lua("charge_client", TrackInfo)
        end)
        return
    end
    if self.ShopItemData.PurchaseFailRes ~= 0 then
        if self.ShopItemData.PurchaseFailRes == 1 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO, 1.0, "CommonToastMain")
        elseif self.ShopItemData.PurchaseFailRes == 2 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[self.ShopItemData.PriceType].ResourceName)), 1.0)
        elseif self.ShopItemData.PurchaseFailRes == 3 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), self.ShopItemData.UnlockLevel), 1.0)
        elseif self.ShopItemData.PurchaseFailRes == 6 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_UNIQUE_ALREDAY_OWNED,1.0,"CommonToastMain")
        end
        return
    end
    self:BlockAllUIInput(true)
    Avatar:PurchaseShopItem(self.ShopItemData.ItemId, FinalCount, nil, nil, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
end

function M:RefreshPurchaseState()
    if ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId) == 0 then
        self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(1)
        self.Text_Desc:SetText(GText("UI_SHOP_ALREADYOWNED"))
        self.bForbiddenButton = true
        self.bCanOpenDiscount = false
        self.Btn_Discount_Light:SetVisibility(ESlateVisibility.Collapsed)
    else
        self:UpdateDiscount()
        self:UpdatePrice()
        self:UpdateButtonBuy()
        self.Btn_Discount_Light:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
end

--- 关闭当前UI
function M:CloseSelf()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
    
    AudioManager(self):SetEventSoundParam(self, "SkinPreviewIn", {ToEnd = 1})
    self:ClosePreview()
end

--- 处理按键按下事件
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local KeyDownEvent = self.KeyDownEvents[InKeyName]
    if self.InSelectDiscountMode then
        return UIUtils.Handled
    end
    if(KeyDownEvent)then
        local Reply,IsHandled = KeyDownEvent(self)
        if(IsHandled)then
            return Reply
        end
    else
        if(not self.bSelfHidden)then
            self.Tab_Skin:Handle_KeyEventOnGamePad(InKeyName)
        end
    end
    return UIUtils.Handled
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local RepeatKeyDownEvent = self.RepeatKeyDownEvents[InKeyName]
    if(RepeatKeyDownEvent)then
        local Reply,IsHandled = RepeatKeyDownEvent(self)
        if(IsHandled)then
            return Reply
        end
    end
    return UIUtils.Unhandled
end

--#region 交互事件

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
    return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
    return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

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

function M:OnCameraScrollBackwardKeyDown()
    self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
    self:ScrollCamera(-1)
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if self.InSelectDiscountMode then
        return UIUtils.Unhandled
    end
    if(InKeyName == "Gamepad_RightX")then
        if(self.ActorController)then
            if self.EnableDrag == false then
                return UIUtils.Unhandled
            end
            local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
            self.ActorController:OnDragViewActor({X=DeltaX})
        end
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

function M:OnMouseCaptureLost()
    self:OnPointerCaptureLost()
end

function M:OnBackgroundClicked()
    if(self.bSelfHidden)then
        self:OnHideUIKeyDown()
    end
end

--endregion

--- 动画结束回调
function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:CloseMVPSequence()
        M.Super.Close(self)
        -- self:Close()
        self:RefreshShopUI()
    elseif InAnimation == self.In or InAnimation == self.Change then
        self:BlockAllUIInput(false)
    end
end

--- 刷新商店UI，使手柄重新聚焦到Shop
function M:RefreshShopUI()
    local Shop = UIManager(self):GetLastJumpPage()
    if Shop then
        if Shop.RefreshSubTabData then
            Shop:RefreshSubTabData(Shop.CurSubTabMap, true, true)
        elseif Shop.UpdateShopDetail then
            Shop:UpdateShopDetail(Shop.CurSubTabMap)
        end
        return
    end
    local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
    if ShopMain then
        ShopMain.NotNeedPlayEntryAnimation = true
        ShopMain:RefreshSubTabData(ShopMain.CurSubTabMap, true, true)
    end
    local CommonShopActivity = UIManager(GWorld.GameInstance):GetUIObj("ShopActivity")
    if CommonShopActivity then
        CommonShopActivity:RefreshSubTabData(CommonShopActivity.CurSubTabMap, true, true)
    end
    local ActivityShop = UIManager(GWorld.GameInstance):GetUIObj("ActivityShop")
    if ActivityShop then
        ActivityShop:UpdateShopDetail(ActivityShop.CurSubTabMap)
    end
end

--- 输入模式切换
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
end

--- Utils

function M:GetSkinIndex(ShopItemId)
    local Index = self.ShopSkin2Index[ShopItemId]
    local bFirst = Index == 1
    local bLast = Index == self.SkinCount
    return Index, bFirst, bLast
end

function M:GetSkinInfo(Index)
    --- 获取传入皮肤列表中的对应项
    if self.SkinList then
        local SkinTypeId = self.SkinList[Index]
        local SkinItemData = {}
        SkinItemData.ItemType = self.ShopItemData.ItemType
        SkinItemData.TypeId = SkinTypeId
        SkinItemData.ItemId = SkinTypeId
        return SkinItemData
    end
    local ShopItemId = self.Index2ShopSkin[Index]
    local ShopItemData = nil
    if ShopItemId and DataMgr.ShopItem[ShopItemId] then
        ShopItemData = setmetatable({}, {__index = DataMgr.ShopItem[ShopItemId]})
    end
    return ShopItemData
end

function M:HideZoomKey(IsHidden)
end

function M:HideReplayKey(IsHidden)
end

function M:UpdateSkinNameFontByRarity(Rarity)
    local rarityFontMap = {
        [6] = self.Font_Red,
        [5] = self.Font_Gold,
        [4] = self.Font_Purple,
        [3] = self.Font_Blue,
    }

    local fontToSet = rarityFontMap[Rarity]
    if fontToSet then
        self.Text_SkinName:SetFont(fontToSet)
    end
end

function M:GetCutoffInfo(ItemId)
    if not ItemId then return nil end
    for _, CutoffData in pairs(DataMgr.Cutoff or {}) do
        if CutoffData.ItemId and CutoffData.ItemId == ItemId then
            return CommonUtils.DeepCopy(CutoffData)
        end
    end
    return nil
end

-- region 皮肤升级
function M:InitLevelUpPreview(ItemData)
    if ItemData.ItemType == "Skin" then
        local IsDisplay = DataMgr.SkinUpgrade and DataMgr.SkinUpgrade[ItemData.ItemId]
        if not IsDisplay then
            self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
            return
        end

        self.Panel_LevelUp:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.BtnSkinLevelUp = true
        local MaxLevel = self.WB_LevelUp:GetChildrenCount()

        for Index = 1, MaxLevel do
            local LevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. Index]
            if LevelUpWidget then
                local Params = {
                    Level = Index,
                    IsLocked = false,
                    IsShowReddot = false,
                    Obj = self,
                    ClickedCallback = self.OnLevelUpWidgetClicked
                }
                LevelUpWidget:InitContent(Params)
            end
        end

        self.SelectedSkinLevel = 1

        self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]:PlaySelectedAnimation()
    end
end

-- 皮肤等级按钮点击事件
function M:OnLevelUpWidgetClicked(Level)
    if Level == self.SelectedSkinLevel then
        return
    end

    -- 上一个等级按钮恢复普通态
    local LastLevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
    if LastLevelUpWidget then
        LastLevelUpWidget:PlayNormalAnimation()
    end

    -- 当前等级按钮播放选中态
    self.SelectedSkinLevel = Level
    local CurLevelUpWidget = self["WBP_Armory_Skin_LevelUp_" .. self.SelectedSkinLevel]
    if CurLevelUpWidget then
        CurLevelUpWidget:PlaySelectedAnimation()
    end

    -- 预览界面默认展示解锁信息
    local SkinId = self.ShopItemData.ItemId
    self.ShopItemData.SkinLevel = Level
    local SkinLevelUpData = DataMgr.SkinUpgrade[SkinId][Level]
    if SkinLevelUpData then
        self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Text_Undiscounted_Price:SetVisibility(ESlateVisibility.Collapsed)
        self.WBP_Com_Cost:InitContent({
                CostText = "UI_Skin_Upgrade_Cost",
                ResourceId = SkinLevelUpData.UnlockCurrency,
                Numerator = SkinLevelUpData.UnlockAmount,
        })
        self.WBP_Com_Cost:SetGamePadIconVisible(false)
    else
        self.Panel_Buy:SetVisibility(ESlateVisibility.Collapsed)
    end

    -- 刷新等级预览表现
    if self.UpdateSkinLevelPreview then
        self:UpdateSkinLevelPreview(Level)
    elseif self.UpdatePreviewActor then
        self:UpdatePreviewActor(self.ShopItemData, FVector(40, 35, 0))
    end
end

AssembleComponents(M)

return M

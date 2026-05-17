--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
---@type WBP_Shop_Recommend_WeaponSkin_C
local M = Class({"BluePrints.UI.Shop.Banner.WBP_Shop_Banner_Base_C", "BluePrints.UI.BP_EMUserWidgetUtils_C"})
function M:Construct()
    M.Super.Construct(self)
    local BannerTab = self:GetBannerTabData("WBP_Shop_Recommend_WeaponSkin")
    if not BannerTab then 
        return
    end
    self.BannerTab = setmetatable({}, {__index = BannerTab})
    self.BannerTab.ItemId = self:GetValidItemId(self.BannerTab)
    self.Btn_Qa:BindEventOnClicked(self, self.OnClickQa)
    self.Btn_Pay.Btn_Buy.OnClicked:Add(self, self.OnBtn_BuyClick)
    
    -- 绑定武器皮肤获取事件
    self:AddDispatcher(EventID.OnNewWeaponSkinObtained, self, self.OnNewWeaponSkinObtained)
    self.Btn_Pay.Key_ControllerBuy:CreateCommonKey({
            KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            }
        },
    })
    local bIsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    self:UpdateGamePadKeyInfo(bIsGamepad)
end

function M:Destruct()
    if self.Btn_Qa then
        self.Btn_Qa:UnBindEventOnClicked(self, self.OnClickQa)
    end
    if self.Btn_Pay and self.Btn_Pay.Btn_Buy then
        self.Btn_Pay.Btn_Buy.OnClicked:Remove(self, self.OnGoToInterface)
        self.Btn_Pay.Btn_Buy.OnClicked:Remove(self, self.OnBtn_BuyClick)
        self.Btn_Pay.Btn_Buy.OnHovered:Remove(self, self.OnGoToHovered)
    end
    
    
    self:RemoveTimer("RefreshLeftTime")
    M.Super.Destruct(self)
end

function M:OnClickQa()
    if self.BannerTab and self.BannerTab.PreviewType == "WeaponSkin" and self.BannerTab.PreviewId then
        UIManager(self):LoadUINew("ArmorySkin", {Type = "Weapon", SkinId = self.BannerTab.PreviewId[1],IsPreviewMode = true, OpenPreviewDyeFromShopItem = true})
    end
end

function M:OnBtn_BuyClick()
    -- 获取商品数据
    local ShopItemData = self:GetShopItemInfo(self.BannerTab.ItemId)
    if not ShopItemData then
        return
    end
    local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(self.BannerTab.ItemId)
    if PurchaseLimit <= 0 then -- 已售罄
        self:OnSoldOutClicked()
        return
    end
    
    -- 显示购买确认弹窗
    local Funds = {{FundId = ShopItemData.PriceType, FundNeed = self.FinalPrice}}
    UIManager(self):ShowCommonPopupUI(100041, {
        ShopItemData = ShopItemData,
        ShopType = 0,
        Funds = Funds,
        ShowParentTabCoin = true,
        RightCallbackObj = self,
        RightCallbackFunction = self.PurchaseWeaponSkin,
        ForbidRightBtn = false,
    }, self)
    AudioManager(self):PlayUISound(self, "event:/ui/common/gacha_btn_click_normal", nil, nil)
end

-- 购买武器皮肤
function M:PurchaseWeaponSkin(PackageResult, DialogWidget)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local ShopItemData = self:GetShopItemInfo(self.BannerTab.ItemId)
    if not ShopItemData then
        return
    end

    local PurchasePrice = self.FinalPrice
    local SelectedDiscount = nil
    if PackageResult and PackageResult.Content_1 and PackageResult.Content_1.CallObj then
        if PackageResult.Content_1.CallObj.SelectedDiscount then
            SelectedDiscount = PackageResult.Content_1.CallObj.SelectedDiscount
        end
    end
    PurchasePrice = ShopUtils:GetPriceAfterDiscount(ShopItemData.ItemId, PurchasePrice, SelectedDiscount and SelectedDiscount.VoucherId or nil)

    local CurrentCount = Avatar:GetResourceNum(ShopItemData.PriceType)
    if CurrentCount < PurchasePrice then
        local JumpToShop = function()
            self:AddTimer(0.3, function()
                PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId, nil, nil, "Shop")
            end)
        end
        local Params = {}
        Params.RightCallbackObj = self
        Params.CostNum = PurchasePrice
        Params.CostType = ShopItemData.PriceType
        UIManager(self):LoadUINew("ShopTargetPay", Params)
        return
    end

    Avatar:PurchaseShopItem(ShopItemData.ItemId, 1, false, nil, SelectedDiscount and SelectedDiscount.VoucherId or nil)
end

-- 购买结果回调
function M:OnNewWeaponSkinObtained(SkinId)
    -- 获得新武器皮肤时刷新UI状态
    if SkinId and self.BannerTab and self.BannerTab.PreviewId then
        -- 检查获得的皮肤是否是当前推荐的皮肤
        for _, PreviewSkinId in ipairs(self.BannerTab.PreviewId) do
            if SkinId == PreviewSkinId then
                self:InitBtn_PayInfo()
                break
            end
        end
    end
end

-- 售罄状态下的点击事件处理
function M:OnSoldOutClicked()
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_SHOP_SOLDOUT"))
end

--- 初始化UI信息
function M:InitBannerPage(BannerId, Parent)
    self.Parent = Parent
    if BannerId and self.BannerTab.Id and self.BannerTab.Id == BannerId then
        self.BannerId = BannerId
    else
        return
    end
    local bQualityTag = false
    local SkinRarity = nil
    if self.Com_QualityTag and self.BannerTab.PreviewId[1] then
        local SkinInfo = DataMgr.WeaponSkin[self.BannerTab.PreviewId[1]]
        if SkinInfo then
            SkinRarity = SkinInfo.Rarity
            self.Com_QualityTag:Init(SkinRarity)
            bQualityTag = true
        end
    end
    if not bQualityTag then
        self.Com_QualityTag:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.WBP_Shop_Recommend_Common_TItle and self.WBP_Shop_Recommend_Common_TItle.Text_MainTitle and SkinRarity then
        local SkinNameFonts = { nil, nil, "Font_Blue", "Font_Purple", "Font_Gold", "Font_Red"} --分别对应稀有度3，4，5，6
        if SkinNameFonts[SkinRarity] and self.WBP_Shop_Recommend_Common_TItle[SkinNameFonts[SkinRarity]] then
            self.WBP_Shop_Recommend_Common_TItle.Text_MainTitle:SetFont(self.WBP_Shop_Recommend_Common_TItle[SkinNameFonts[SkinRarity]])
        end
    end
    if self.WBP_Shop_Recommend_Common_TItle and self.WBP_Shop_Recommend_Common_TItle.Text_MainTitle and self.BannerTab.Text1 then
        self.WBP_Shop_Recommend_Common_TItle:SetText(GText(self.BannerTab.Text1))
    end
    if self.Text_ActivityDesc_White then
        self.Text_ActivityDesc_White:SetText(GText("UI_WeaponSkin_Preview"))
    end

    if self.Text_Detail and self.BannerTab.Text1Sub then
        self.Text_Detail:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Detail:SetText(GText(self.BannerTab.Text1Sub))
    elseif self.Text_Detail then
        self.Text_Detail:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self:InitActivity_TimeInfo()
    if not self:IsAnyAnimationPlaying() then
        self:PlayInAnimation()
    end
    self:AdjustGroupDetail()
    self:InitBtn_PayInfo()
    AudioManager(self):PlayUISound(self, "event:/ui/common/shop_recommend_lightblade", nil, nil)
end

function M:InitBtn_PayInfo()
    local CutoffInfo = self:GetCutoffInfo(self.BannerTab.ItemId)
    local ShopItemInfo = self:GetShopItemInfo(self.BannerTab.ItemId)
    local NowTime = TimeUtils.NowTime()
    local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(self.BannerTab.ItemId)
    if self.Btn_Pay and self.Btn_Pay.Btn_Buy then
        if PurchaseLimit <= 0 then -- 已售罄
            self.Btn_Pay.Text_BtnEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
            self.Btn_Pay.Text_BtnEmpty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Btn_Pay.Text_BtnBuy:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Btn_Pay:ForbidBtn(true)
            self.Btn_Pay.Group_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Btn_Pay.Group_BuyNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Btn_Pay.WS_Detail:SetVisibility(UIConst.VisibilityOp.Collapsed)
            if not self.bAddSoldOutClicked then
                self.bAddSoldOutClicked = true
            end
            return
        end
        self.Btn_Pay.Btn_Buy.OnHovered:Add(self, self.OnGoToHovered)
        if self.Btn_Pay.Text_BtnBuy then
            self.Btn_Pay.Text_BtnBuy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Btn_Pay.Text_BtnBuy:SetText(GText("UI_SHOP_PURCHASE"))
        end
        --购买次数
        -- if ShopItemInfo and ShopItemInfo.PurchaseLimit then
        --     self.Btn_Pay.Group_BuyNum:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        --     self.Btn_Pay.Text_BuyNum:SetText(GText("UI_Banner_Remain_Buy")..tostring(ShopItemInfo.PurchaseLimit))
        -- elseif ShopItemInfo and not ShopItemInfo.PurchaseLimit then
        --     self.Btn_Pay.Group_BuyNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
        -- end
        self.Btn_Pay.Group_BuyNum:SetVisibility(UIConst.VisibilityOp.Collapsed)

        if ShopItemInfo and ShopItemInfo.Price then
            self.Btn_Pay.Text_Undiscounted_Price:SetText(ShopItemInfo.Price)
        end
        --货币类型和数值
        self.FinalPrice = ShopItemInfo and ShopItemInfo.Price or 0
        if ShopItemInfo and ShopItemInfo.PriceType and ShopItemInfo.PriceType == 99 then
            self.Btn_Pay.WS_Detail:SetActiveWidgetIndex(1)
        elseif ShopItemInfo and ShopItemInfo.PriceType and ShopItemInfo.PriceType ~= 99 then
            self.Btn_Pay.WS_Detail:SetActiveWidgetIndex(0)
        end
        --折扣信息
        local bInCutoffTime = false
        if CutoffInfo and CutoffInfo.CutoffStartTime and NowTime >= CutoffInfo.CutoffStartTime then
            if (not CutoffInfo.CutoffEndTime) or (CutoffInfo.CutoffEndTime and NowTime <= CutoffInfo.CutoffEndTime) then
                bInCutoffTime = true
            end
        end
        if CutoffInfo and CutoffInfo.CutoffShow and CutoffInfo.CutoffPrice and bInCutoffTime then
            self.Btn_Pay.Group_More:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Btn_Pay.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            --local ShowNum = 100 - CutoffInfo.CutoffShow
            --self.Btn_Pay.Text_MoreNum:SetText(string.format("-%d",ShowNum))
            self.FinalPrice = CutoffInfo.CutoffPrice
        else
            self.Btn_Pay.Group_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.Btn_Pay.Text_Undiscounted_Price:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        --设置最终价格
        if self.Btn_Pay and self.Btn_Pay.Text_Price and self.FinalPrice then
            self.Btn_Pay.Text_Price:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            self.Btn_Pay.Text_Price:SetText(self.FinalPrice)
        else
            self.Btn_Pay.Text_Price:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        
        -- 货币不足时显示红色价格
        if ShopItemInfo and ShopItemInfo.PriceType then
            local Avatar = GWorld:GetAvatar()
            if Avatar then
                local CurrentCount = Avatar:GetResourceNum(ShopItemInfo.PriceType)
                if CurrentCount < self.FinalPrice then
                    self.Btn_Pay.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
                else
                    self.Btn_Pay.Text_Price:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFF"))
                end
            end
        end
    end
end

function M:InitActivity_TimeInfo()
    if self.BannerTab and self.BannerTab.EndTime then
        --下架时间更新,1s一次
        self:AddTimer(1.0, self.RefreshLeftTime, true, 0, "RefreshLeftTime", true)
        self:RefreshLeftTime()
    else
        if self.HB then
            self.HB:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
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

function M:GetShopItemInfo(ItemId)
    if not ItemId then return nil end
    for _, ShopItemData in pairs(DataMgr.ShopItem or {}) do
        if ShopItemData.ItemId and ShopItemData.ItemId == ItemId then
            return CommonUtils.DeepCopy(ShopItemData)
        end
    end
    return nil
end

function M:RefreshLeftTime()
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.BannerTab.EndTime)
    if RemainTimeDict then
        self.Activity_Time:SetTimeText(GText("UI_Banner_RemainTime"), RemainTimeDict)
    else
        self.Activity_Time:SetForeverTimeText(GText("UI_GameEvent_EventTimeRemain"))
        self:RemoveTimer("RefreshLeftTime")
    end
end

--- 播放加载动画In
function M:PlayInAnimation()
    if self.In then
        self:PlayAnimation(self.In)
    end
end

--- 播放加载动画Out
function M:PlayOutAnimation()
    if self.Out then
        self:PlayAnimation(self.Out)
    end
end

--- 是否正在播放动画
function M:IsAnyAnimationPlaying()
    if self:IsAnimationPlaying(self.In) or
    self:IsAnimationPlaying(self.Out) then
        return true
    end
    return false
end


--------------------------------------输入交互相关-----------------------------------
-- function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
--     return UE4.UWidgetBlueprintLibrary.Unhandled()
-- end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        IsEventHandled = self:OnPCKeyDown(InKeyName)
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        self:OnBtn_BuyClick()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        self:OnClickQa()
        IsEventHandled = true
    end
    return IsEventHandled
end

function M:OnPCKeyDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "SpaceBar" then
        self:OnBtn_BuyClick()
        IsEventHandled = true
    end
    return IsEventHandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local bGamePad = CurInputDevice == ECommonInputType.Gamepad
    self:UpdateGamePadKeyInfo(bGamePad)
end

function M:UpdateGamePadKeyInfo(bGamePad)
    local TargetVisiblity = bGamePad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
    if self.Btn_Pay and self.Btn_Pay.Key_ControllerBuy then
        self.Btn_Pay.Key_ControllerBuy:SetVisibility(TargetVisiblity)
    end
end


return M

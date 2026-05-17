      
--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local WalnutBagController = require "BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagController"
local WalnutBagModel = WalnutBagController:GetModel()

---@type Shop_BuySinglePart_PC_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.TypeSort = {
        self.SubItem01.Com_Item_1,
        self.SubItem02.Com_Item_1,
        self.SubItem02.Com_Item_2,
        self.SubItem03.Com_Item_1,
        self.SubItem03.Com_Item_2,
        self.SubItem03.Com_Item_3
    }
    self.Text_RewardDesc:SetText(GText("UI_Reward_Walnut_Preview"))
    --- 公共初始化
    self.Text_CanUpgrade:SetText(GText("UI_RougeLike_Blessing_CanUpgrade"))
    self.Text_Exchange:SetText(GText("UI_Shop_ExchangeAmount"))
    self.Text_BuyLeftTitle:SetText(GText("UI_SHOP_SHOPITEMLIMIT"))
    self.Text_Hold01:SetText(GText("UI_Bag_Sellconfirm_Hold"))
    self.Text_HoldMod01:SetText(GText("UI_ModHolding_Num"))

    self.Key_Mod:CreateGamepadKey(DataMgr.KeyboardText[UIConst.GamePadKey.SpecialRight].KeyText)
    self.Key_Suit:CreateGamepadKey(DataMgr.KeyboardText[UIConst.GamePadKey.SpecialRight].KeyText)
    self.Btn_Mod.Button_Area.OnClicked:Add(self, self.OnWalnutModDetailsClick)
end

function M:Destruct()
    self.Btn_Mod.Button_Area.OnClicked:Clear()
end

function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
    self:AddInputMethodChangedListen()
    self.Params = Params
    self.ShopItemData = setmetatable({}, {__index = Params.ShopItemData})
    self.ShopType = Params.ShopType
    self.ShopId = Params.ShopId
    self.UIName = nil
    if Params.UIName then
        self.UIName = Params.UIName
    end
    self.SingleItemNotInteractive = Params.SingleItemNotInteractive -- 是否左侧道具栏不可交互
    self.SelectedDiscount = Params.SelectedDiscount
    self.CurrentCount = 1
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.Com_Time_Remainder.Text_TimeTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.Com_Time_Remainder.Image_ClockIcon:SetVisibility(ESlateVisibility.Collapsed)
    self.Com_Time_Refresh.Text_TimeTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.Com_Time_Refresh.Image_ClockIcon:SetVisibility(ESlateVisibility.Collapsed)

    --- 商店类型 0:普通商店,1:肉鸽商店
    ---@type number
    self:InitUI(self.ShopType)
    self:AddTimer(0.1, function()
        if self.ShopItemData.ItemType ~= "Walnut" and self.ScrollBox_0:GetScrollOffsetOfEnd() > 0 and UIUtils.IsGamepadInput() then
            self:ShowGamepadShortcut(self.GamepadScrollBtnIndex)
        else
            self:HideGamepadShortcut(self.GamepadScrollBtnIndex)
        end
        --- 决定显示哪个提示
        if self.ShopItemData.PurchaseFailRes == 6 then
            self:BroadcastDialogEvent("UpdateDialogTipText", { Tips = {GText("UI_SHOP_ALREADYOWNED")}, DialogItemIndex = 1, bShowTip = true})
        else
            self:BroadcastDialogEvent("UpdateDialogTipText", { Tips = {GText("UI_SHOP_SOLDOUT")}, DialogItemIndex = 1, bShowTip = true})
        end
    end)

    if not(self.ShopItemData.ItemType and self.ShopItemData.ItemType == "WeaponSkin")  then
        self.OpenTipsButtonIndex = self:ShowGamepadShortcutBtn({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = DataMgr.KeyboardText[UIConst.GamePadKey.LeftThumb].KeyText
                },
            },
            Desc = GText("UI_Controller_CheckDetails"),
        })
    end

    self.ButtonIndexB = self:ShowGamepadShortcutBtn({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B"
            },
        },
        Desc = GText("UI_BACK"),
    })
    self.ButtonIndexA = self:ShowGamepadShortcutBtn({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "A"
            },
        },
        Desc = GText("UI_Tips_Ensure"),
    })
    self.ButtonX = self:ShowGamepadShortcutBtn({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "X"
            },
        },
        Desc = GText("UI_Controller_CheckDetails"),
    })
    self.GamepadScrollBtnIndex = self:ShowGamepadShortcutBtn({        
        KeyInfoList = {
        {
            Type = "Img",
            ImgShortPath = "RV",
            -- ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("RV", self.CurGamepadName)
        }},
        Desc = GText("UI_Controller_Slide")
    })

    -- 手柄端菜单键按钮提示
    local Key_RewardDesc_Params = {
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = DataMgr.KeyboardText[UIConst.GamePadKey.SpecialLeft].KeyText
            },
        },
    }
    self.Key_RewardDesc:CreateCommonKey(Key_RewardDesc_Params)
    if self.GameInputModeSubsystem:GetCurrentInputType() ~= ECommonInputType.Gamepad then 
        self.Key_Mod:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Suit:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_RewardDesc:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Key_Mod:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Suit:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_RewardDesc:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end

    -- 初始化手柄交互相关状态
    self.bTipsOpen = false
    self.FocusOnSubItem = false
    self:SetGamepadButtonState(false, false, not self.SingleItemNotInteractive)
    self:HideGamepadShortcut(self.ButtonX)
end

function M:MinusBtnCallback()
    self.CurrentCount = self.Com_Slider.CurrentCount
    self:UpdatePricePanel()
end

function M:AddBtnCallback()
    self.CurrentCount = self.Com_Slider.CurrentCount
    self:UpdatePricePanel()
end

function M:SliderChangeCallback(Value)
    self.CurrentCount = Value
    self:UpdatePricePanel()
end

function M:InitUI(ShopType)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self.WS_Item:SetActiveWidgetIndex(ShopType)
    self.WS_BuyDetail:SetActiveWidgetIndex(ShopType)
    self:SetWidgetVisibility(ShopType)
    local ItemName
    local ItemDesc
    if ShopType == 0 then
        local ItemData = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId]
        if not ItemData then
            return
        end
        self.Group_BuyDetail:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.Id = self.ShopItemData.TypeId 
        Content.ItemType = self.ShopItemData.ItemType
        Content.Icon = ItemUtils.GetItemIconPath(self.ShopItemData.TypeId, self.ShopItemData.ItemType)
        Content.Rarity = ItemData.Rarity or ItemData[self.ShopItemData.ItemType .. "Rarity"] or 0
        Content.IsShowDetails = true
        if self.UIName then
            Content.UIName = self.UIName
        else
            Content.UIName = "ShopMain"
        end
        Content.NotInteractive = self.SingleItemNotInteractive
        if self.ShopItemData.ItemType == "Char" then
            Content.OnMouseButtonUpEvents = {
                Obj = self,
                Callback = self.OpenCharDetails,
                Params = {self.ShopItemData.TypeId}
            }
        end
        self:SetNameRarity(Content.Rarity)
        self.SingleItem:Init(Content)
        local Events = {}
        Events.OnMenuOpenChanged = self.ItemMenuAnchorChanged
        self.SingleItem:BindEvents(self, Events)
        ItemName = ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType)
        if self.ShopItemData.TypeNum and self.ShopItemData.TypeNum > 1 then
            ItemName = ItemName .. " x" .. self.ShopItemData.TypeNum
        end
        self.Group_TimeSpace:SetVisibility(ESlateVisibility.Collapsed)
        self.CutoffData = ShopUtils:GetShopItemCutoffData(self.ShopItemData.ItemId)
        if self.CutoffData and self.CutoffData.CutoffEndTime then
            self.Group_BuyDetail:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_RemainderTime:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_TimeSpace:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self:UpdateShopItemCutoffRefreshTime()
            self:AddTimer(1, self.UpdateShopItemCutoffRefreshTime, true, 0, "UpdateShopItemCutoffRefreshTime", true)
        elseif self.ShopItemData.StartTime and self.ShopItemData.EndTime then
            self.Group_BuyDetail:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_RemainderTime:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_TimeSpace:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self:UpdateLimitTime()
            if TimeUtils.NowTime() < self.ShopItemData.EndTime then
                self:AddTimer(1, self.UpdateLimitTime, true, 0, "UpdateShopItemEndRefreshTime", true)
            end
        else
            self.Group_RemainderTime:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end

        self:UpdateShopItemRefreshTime(self.ShopItemData.RefreshTime, self.Com_Time_Refresh.Text_TimeDesc)
        ItemDesc = GText(ItemData.Description or ItemData[self.ShopItemData.ItemType .. "Description"] or ItemData[self.ShopItemData.ItemType .. "Describe"] or ItemData.DetailDes or ItemData.Des)
        if self.ShopItemData.ItemType == "Draft" then
            ItemDesc = "UI_DraftDes_General"
            ItemName = ItemUtils:GetDraftName(ItemData.DraftId)
        elseif self.ShopItemData.ItemType == "Mount" then
            ItemDesc = ItemData.MountDes
        end
        self.Text_Name:SetText(GText(ItemName))
        if self.ShopItemData.ItemType == "Resource" then
            self.Text_Describe:SetText(GText(ItemData.FunctionDes))
            self.Text_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        elseif self.ShopItemData.ItemType == "WeaponSkin" then
            self.Text_Describe:SetText(GText(ItemData.Dec))
            self.Text_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
            self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
        end
        if self.ShopItemData.ItemType == "Mod" then
            self.WS_Info:SetActiveWidgetIndex(1)
            local ModData = DataMgr.Mod[Content.Id]
            self:UpdataModDetails(ModData, 0)
        else
            self.WS_Info:SetActiveWidgetIndex(0)
            for i = 1, 6 do
                ---@type Shop_ItemStar_PC_C
                local Img_Star = self["Shop_ItemStar_PC_" .. i]
                local Rarity = DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId].Rarity or DataMgr[self.ShopItemData.ItemType][self.ShopItemData.TypeId][self.ShopItemData.ItemType .. "Rarity"] or 0
                Img_Star:SetLight(i <= Rarity)
            end
            self.Text_Desc:SetText(GText(ItemDesc))
        end
        self.UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId)
        self:UpdatePricePanel(true)

        local ShopItemRemainTimes = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
        local TotalPurchaseLimit = self.ShopItemData.PurchaseLimit
        if ShopItemRemainTimes > -1 then
            self.Group_BuyDetail:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_BuyLeftTimes:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Text_BuyLeftTimes:SetText(ShopItemRemainTimes.."/"..TotalPurchaseLimit)
        else
            self.Group_BuyLeftTimes:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end

        self:BindDialogEvent("UpdatePricePanel", self.UpdateDialogBtn)

        if self.ShopItemData.ItemDes then
            self.Group_BuyDetail:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Button_Detail:SetVisibility(ESlateVisibility.Visible)
            self.Button_Detail.OnClicked:Add(self, self.OnBtnDetailClick)
        else
            self.Button_Detail:SetVisibility(ESlateVisibility.Collapsed)
        end
    end

    if self.ShopItemData.ItemType == "Walnut" then
        self.WidgetSwitcher_0:SetActiveWidgetIndex(1)
        local WalnutId = self.ShopItemData.TypeId
        local WalnutDataTable = DataMgr.Walnut[WalnutId]

        self.Group_HoldNormal:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_HoldMod:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_SuitMod:SetVisibility(ESlateVisibility.SelfHitTestInvisible)

        if WalnutDataTable.MainRewardType == "Char" then
            self.Group_HoldMod:SetVisibility(ESlateVisibility.Collapsed)
            local CharData = DataMgr.Char[WalnutDataTable.MainRewardId]
            assert(CharData, "未找到对应角色数据"..WalnutDataTable.MainRewardId)
            self.Btn_Suit:Init({
                OwnerWidget = self,
                TextContent = GText("UI_Shop_CharWalnutLevel"),
                MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
            })
            local CharNetData
            local GradeLevel = 0
            self.Text_SuitMod:SetText(GText(CharData.CharName))
            for CharUid, Data in pairs(Avatar.Chars) do
                if Data.CharId == WalnutDataTable.MainRewardId then
                    CharNetData = Data
                    GradeLevel = CharNetData.GradeLevel
                    break
                end
            end
            if not CharNetData then
                self.Group_SuitMod:SetVisibility(ESlateVisibility.Collapsed)
            else
                GradeLevel = GradeLevel + (CharNetData.ExtraGradeLevel or 0)
            end
            self.Text_Suit:SetText(GradeLevel)
        elseif WalnutDataTable.MainRewardType == "Weapon" then
            self.Group_HoldMod:SetVisibility(ESlateVisibility.Collapsed)
            local WeaponData = DataMgr.Weapon[WalnutDataTable.MainRewardId]
            assert(WeaponData, "未找到对应角色数据"..WalnutDataTable.MainRewardId)
            self.Btn_Suit:Init({
                OwnerWidget = self,
                TextContent = GText("UI_Shop_WeaponWalnutLevel"),
                MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight

            })
            local WeaponNetData
            local GradeLevel = 0
            self.Text_SuitMod:SetText(GText(WeaponData.WeaponName))
            for WeaponUid, Data in pairs(Avatar.Weapons) do
                if Data.WeaponId == WalnutDataTable.MainRewardId then
                    WeaponNetData = Data
                    if WeaponNetData.GradeLevel > GradeLevel then
                        GradeLevel = WeaponNetData.GradeLevel
                    end
                end
            end
            if not WeaponNetData then
                self.Group_SuitMod:SetVisibility(ESlateVisibility.Collapsed)
            end
            self.Text_Suit:SetText(GradeLevel)
        elseif WalnutDataTable.MainRewardType == "Mod" then
            local ModCount = Avatar:GetModCount2ModId(WalnutDataTable.MainRewardId)
            if ModCount == 0 then
                self.Group_HoldMod:SetVisibility(ESlateVisibility.Collapsed)
            else
            self.Text_HoldMod02:SetText(Avatar:GetModCount2ModId(WalnutDataTable.MainRewardId))
            end
            self.Group_SuitMod:SetVisibility(ESlateVisibility.Collapsed)
        end

        self.Text_Hold02:SetText(WalnutBagModel:GetWalnutCountById(WalnutId))
        
        local RewardLst = {}
        for i = 1, 6 do
            local Content
            local RewardId = WalnutDataTable["Id"][i]
            local RewardType = WalnutDataTable["Type"][i]
            local RewardCount = WalnutDataTable["Count"][i][1]
            local RewardDataTable = DataMgr[RewardType]
            if (RewardDataTable) then
                local RewardConfigData = RewardDataTable[RewardId]
                if (RewardConfigData) then
                    Content = {
                        Id = RewardId,
                        ItemType = RewardType,
                        Icon = ItemUtils.GetItemIconPath(RewardId, RewardType),
                        Rarity = ItemUtils.GetItemRarity(RewardId, RewardType),
                        Count = RewardCount,
                        IsShowDetails = true,
                        OnMenuOpenChangedEvents = {
                            Obj = self,
                            Callback = self.ItemMenuAnchorChanged
                        }
                    }
                    if self.UIName then
                        Content.UIName = self.UIName
                    else
                        Content.UIName = "ShopMain"
                    end
                    if self.TypeSort[i] then
                        self.TypeSort[i]:Init(Content)
                    end
                    table.insert(RewardLst, Content)
                end
            end
        end

        -- 设置手柄导航
        for Index, ItemUI in pairs(self.TypeSort) do
            -- 右边有
            if Index + 1 <= #self.TypeSort then
                ItemUI:SetNavigationRuleExplicit(EUINavigation.Right, self.TypeSort[Index + 1])
            end
            -- 左边有
            if Index - 1 > 0 then
                ItemUI:SetNavigationRuleExplicit(EUINavigation.Left, self.TypeSort[Index - 1])
            end
        end
    else
        self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    end
    local ConfigData = {
        InitValue = 1,
        MinValue = 1,
        MaxValue = self:GetMaxCount(),
        ClickInterval = 1,
        MinusBtnCallback = self.MinusBtnCallback,
        AddBtnCallback = self.AddBtnCallback,
        SliderChangeCallback = self.SliderChangeCallback,
        SoundResPath = {Minus="event:/ui/common/click_btn_minus"},
        OwnerPanel = self,
        PlatformName = "PC",
        -- EnableMiniBtn = true,
        -- EnableMaxBtn = true,
        bEnableMinusSpecificBtn = true,
        bEnableAddSpecificBtn = true,
        SpecificChangeCount = 10,
        MinusSpecificBtnGamePadKey = "DPadLeft",
        AddSpecificBtnGamePadKey = "DPadRight",
    }
    if self.ShopItemData.PurchaseLimit == 1 then
        if DataMgr.ShopItem2PayGoods[self.ShopItemData.ItemId] then
            self.VB_BottomInfo:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        elseif ShopUtils:HasAnyVoucherConfig(self.ShopItemData.ItemId) then
            self.VB_BottomInfo:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Group_ExChange:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Group_Slider:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Shop_Discount_Btn:SetVisibility(UIConst.VisibilityOp["Visible"])
            self:InitDiscount()
            self.UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
            self:UpdatePricePanel(true)
        else
            self.VB_BottomInfo:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    else
        self.VB_BottomInfo:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Group_ExChange:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Group_Slider:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Shop_Discount_Btn:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self.Com_Slider:Init(ConfigData)

    self.IsLockState = ShopUtils:CheckShopItemCondition(self.ShopItemData)
    if self.IsLockState then
        self.Owner:GetButtonBar().WS_Btn:SetActiveWidgetIndex(1)
        self.Owner:GetButtonBar().Com_Hint:UnBindEventOnClickedByObj(self)
        self.Owner:GetButtonBar().Com_Hint:BindEventOnClicked(self, function()
            ShopUtils:OpenLockConditionPopup(self.ShopItemData)
            self.Owner:OnClose()
        end)
        self.ConditionDisplay = self.ShopItemData.ItemConditionDisplay and self.ShopItemData.ItemCondition
        if self.ConditionDisplay then
            self.Owner:GetButtonBar().Com_Hint.IsForbidden = true
            self.Owner:GetButtonBar().Com_Hint:SetText(GText(DataMgr.Condition[self.ShopItemData.ItemCondition[1]] and DataMgr.Condition[self.ShopItemData.ItemCondition[1]].ConditionText or ""))
            self.Owner:GetButtonBar().Com_Hint.bAutoButtonChange = false
            self.Owner:GetButtonBar().Com_Hint:SetIconPanelVisibility(ESlateVisibility.Collapsed)
            self.Owner:GetButtonBar().Com_Hint:SetGamepadIconVisibility(false)
            self.Owner:GetButtonBar().Com_Hint:SetGamePadVisibility(ESlateVisibility.Collapsed)
            self.Owner:GetButtonBar().Com_Hint.Button_Area:SetIsEnabled(false)
            self.Owner.DontCloseWhenRightBtnClicked = true
        else
            self.Owner:GetButtonBar().Com_Hint.IsForbidden = false
            self.Owner:GetButtonBar().Com_Hint:SetText(GText("UI_Shop_ItemUnlock"))
            self.Owner:GetButtonBar().Com_Hint.bAutoButtonChange = true
            self.Owner:GetButtonBar().Com_Hint:SetIconPanelVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Owner:GetButtonBar().Com_Hint:SetGamepadIconVisibility(true)
            self.Owner:GetButtonBar().Com_Hint.Button_Area:SetIsEnabled(true)
            self.Owner.DontCloseWhenRightBtnClicked = false
        end
    end
end

function M:OnWalnutModDetailsClick()
    self.ItemDetails_ModMenuAnchor:Open(true)
    if self.WalnutModItemDetails then
        self.WalnutModItemDetails:PlayAnimation(self.WalnutModItemDetails.In)
        local WalnutDataTable = DataMgr.Walnut[self.ShopItemData.TypeId]
        self.WalnutModItemDetails:InitModList(WalnutDataTable.MainRewardId)
    end
end

function M:OpenCharDetails(CharId)
    local CommonDialog = UIManager(self):GetUI("CommonDialog");
    if CommonDialog then
        if CommonDialog.CloseBtnCallbackFunction then
            local Data = CommonDialog:PackageResult()
            CommonDialog.CloseBtnCallbackFunction(CommonDialog.CloseBtnCallbackObj,Data)
        end
        CommonDialog:Close()
    end
    local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
    ShopMain.SelectShopItemId = self.ShopItemData.ItemId
    UIManager(self):LoadUINew("ArmoryDetail",{
        PreviewCharIds = {CharId},
        EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        bHideCharAppearance = true,  --隐藏角色外观
        bHideWeaponAppearance = true,  --隐藏武器外观
        bHideBoxBtn = true, --隐藏左下角列表展开按钮
        bNoEndCamera = true,  --不需要收场镜头
        OnCloseDelegate = {
            ShopMain, ShopMain.ShowItemDetail
        }
    })
end

function M:SetNameRarity(Rarity)
    local FontMaterial = self.Text_Name:GetDynamicFontMaterial()
    if Rarity == 6 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_6)
    elseif Rarity == 5 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_5)
    elseif Rarity == 4 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_4)
    elseif Rarity == 3 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_3)
    elseif Rarity == 2 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_2)
    elseif Rarity == 1 then
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_1)
    else
        FontMaterial:SetTextureParameterValue("IconTex", self.Img_Text_0)
    end
end

function M:SetWidgetVisibility(ShopType)
    if ShopType == 0 then
        self.Group_Slider:SetVisibility(UE4.ESlateVisibility.Visible)
    elseif ShopType == 1 then
        self.Group_Slider:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:OnBtnDetailClick()
    local Content = {}
    Content.ItemType = "Tips"
    Content.Type = self.ShopItemData.ItemType
    Content.ItemId = self.ShopItemData.TypeId
    Content.Tips = self.ShopItemData.ItemDes
    Content.MenuPlacement = 7 ---估计是MenuPlacement_CenteredAboveAnchor，不过替换接口还是遵循原业务代码不变的原则...

    self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
end

function M:GetMaxCount()
    local Avatar = GWorld:GetAvatar()
    local CoinCount = Avatar.Resources[self.ShopItemData.PriceType] and Avatar.Resources[self.ShopItemData.PriceType].Count or 0
    local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(self.ShopItemData.ItemId)
    if self.UnitPrice == 0 then
        return PurchaseLimit
    end
    if PurchaseLimit < 0 then
        return math.floor(CoinCount / self.UnitPrice)
    end
    local MaxCount = math.min(math.floor(CoinCount / self.UnitPrice), PurchaseLimit)
    return MaxCount
end
function M:UpdateLimitTime()
    if not self.ShopItemData.EndTime then
        self:RemoveTimer("UpdateShopItemEndRefreshTime")
    end
    local EndTime = self.ShopItemData.EndTime
    if TimeUtils.NowTime() >= self.ShopItemData.EndTime then
        self:CleanTimer()
        self.Group_RemainderTime:SetVisibility(ESlateVisibility.Collapsed)
        local ConfirmPanel = UIManager(self):ShowCommonPopupUI(100016, {
            RightCallbackObj = self,
            RightCallbackFunction = function(Obj, PackageData)
                self:Close()
            end
        }, self)
        return
    end
    local StartTiem = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(TimeUtils.NowTime())
    local EndTime = URuntimeCommonFunctionLibrary.GetDateTimeFromUnixTime(EndTime and EndTime.GetTime())
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
    if (UKismetMathLibrary.GetSeconds(RemainTime) > 0 and TimeCount < 2) or TimeCount == 1 then
        TimeCount = TimeCount + 1
        RemainTimeStr = RemainTimeStr .. string.format(GText("UI_SHOP_REMAINTIME_SECOND"), UKismetMathLibrary.GetSeconds(RemainTime))
    end
    self.Com_Time_Remainder.Text_TimeDesc:SetText(string.format(GText("UI_SHOP_REMAINTIME"), RemainTimeStr))
end

function M:UpdateShopItemCutoffRefreshTime()
    local CurrentTime = TimeUtils.NowTime();
    local EndTime = self.CutoffData.CutoffEndTime
    local RemainRefreshTime = EndTime - CurrentTime
    local RemainTimeStr = ShopUtils:GetRefreshTimeStr(RemainRefreshTime)
    self.Com_Time_Remainder.Text_TimeDesc:SetText(RemainTimeStr)
end

function M:UpdateShopItemRefreshTime(RefreshTime)
    if not RefreshTime then
        self.Group_RefreshTime:SetVisibility(ESlateVisibility.Collapsed)
        self.Com_Time_Refresh:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.Group_RefreshTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Com_Time_Refresh:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Group_TimeSpace:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        ShopUtils:RefreshShopRefreshTime(RefreshTime, self.Com_Time_Refresh.Text_TimeDesc, self.ShopItemData.ItemId)
        self:AddTimer(1, ShopUtils.RefreshShopRefreshTime, true, 0, "RefreshTimeTimer", true, RefreshTime, self.Com_Time_Refresh.Text_TimeDesc, self.ShopItemData.ItemId)
    end
end

function M:UpdatePricePanel(bInit)
    local MaxCount = self:GetMaxCount()
    if MaxCount <= 0 then
        self.Split:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Num_Max_1:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        if self.ShopItemData.PurchaseLimit == 1 then
            self.Group_Slider:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self.Group_Slider:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        self.Split:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Num_Max_1:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Num_Max_1:SetText(tostring(MaxCount))
    end

    self.Num_Exchange:SetText(tostring(self.CurrentCount))
    local Funds = {}
    Funds[1] = {}
    Funds[1].FundId = self.ShopItemData.PriceType
    Funds[1].FundNeed = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil) * self.CurrentCount
    if bInit and self.Params then
        self.Params.Funds = Funds
    end
    
    self:BroadcastDialogEvent("UpdateFunds", { Funds = Funds })
    if not(self.ShopItemData.ItemType and self.ShopItemData.ItemType == "WeaponSkin")  then
        self:BroadcastDialogEvent("UpdatePricePanel")
    end
end


function M:OnSliderValueChanged(Value)
    local MaxCount = self:GetMaxCount()
    self.CurrentCount = math.ceil(Value * (MaxCount - 1) + 1)
    self:UpdatePricePanel()
end

function M:UpdataModDetails(ModDataInfo, ModLevel)
    -- 容量 & 极性
    self.Text_Polarity01:SetText(GText("UI_Tips_Polarity_Cost"))

    if ModDataInfo.Polarity ~= -1 then
        self.Text_Polarity:SetVisibility(UIConst.VisibilityOp.Visible)
        if ModDataInfo.Polarity~=CommonConst.NonePolarity then
            local PolarityText = ModController:GetModel():GetPolarityText(ModDataInfo.Polarity)
            self.Text_Polarity:SetText(PolarityText)
        end
    else
        self.Text_Polarity:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end

    self.Text_Level:SetText("0")
    self.Text_MaxLevel:SetText(ModDataInfo.MaxLevel)
    self.Text_Polarity02:SetText(ModDataInfo.Cost)

    self.VB_PolarityDetail:ClearChildren()
    local ModAttrs = ModDataInfo.AddAttrs
    if ModAttrs then
        for _, ModAttr in ipairs(ModAttrs) do
            local AttrConfig = DataMgr.AttrConfig[ModAttr.AttrName]
            if not AttrConfig then goto continue end
            local _, ValueStr = ArmoryUtils:GenModAttrData(ModAttr, ModLevel, AttrConfig, ModDataInfo.Id)
            local ModAttrText = GText(AttrConfig.Name)..ValueStr
            local EffectItem = UIManager(self):_CreateWidgetNew("CommonItemDetailsEffect")
            EffectItem.Text_Effect:SetText(ModAttrText)
            EffectItem.Switch_Type:SetActiveWidgetIndex(0)
            self.VB_PolarityDetail:AddChild(EffectItem)
            ::continue::
        end
    end
    if (ModDataInfo.PassiveEffectsDesc) then
        local ModDescText = ArmoryUtils:GenModPassiveEffectDesc(ModDataInfo, ModLevel)
        local EffectItem = UIManager(self):_CreateWidgetNew("CommonItemDetailsEffect")
        EffectItem.Text_Effect01:SetText(GText("UI_MOD_Effect")..ModDescText)
        EffectItem.Switch_Type:SetActiveWidgetIndex(1)
        self.VB_PolarityDetail:AddChild(EffectItem)
    end
end

--#region 折扣券
function M:InitDiscount()
    self.AvailableDiscounts = ShopUtils:GetValidVouchers(self.ShopItemData)
    self.CanOpenDiscount = self.AvailableDiscounts and #self.AvailableDiscounts > 0
    self.AutoSelectDiscount = EMCache:Get("AutoSelectDiscount", true)

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

    if bSelectedVoucherExpired then
        if self.Params.bHasDraftDiscount then
            self.SelectedDiscount = self.Params.SelectedDiscount
        else
            if self.CanOpenDiscount then
                if self.AutoSelectDiscount then
                    self.SelectedDiscount = ShopUtils:GetBestVoucher(self.AvailableDiscounts)
                else
                    self.SelectedDiscount = nil
                end
            else
                self.SelectedDiscount = nil
            end
        end
    end

    self.Shop_Discount_Btn:Init({
        ParentWidget = self,
        IsInPreview = false,
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
            if UIUtils.IsGamepadInput() then
                if bIsOpen then
                    self:SetGamepadButtonState(false, true, false)
                    self:HideGamepadShortcut(self.ButtonX)
                else
                    self:SetGamepadButtonState(true, true, false)
                    if Data and Data.IsVoucher then
                        self:ShowGamepadShortcut(self.ButtonX)
                    end
                end
            end
        end,
        ItemTipsStateChangedCallback = function(Data, bIsOpen)
            if UIUtils.IsGamepadInput() then
                if bIsOpen then
                    self:SetGamepadButtonState(false, false, false)
                    self:HideGamepadShortcut(self.ButtonX)
                else
                    self:SetGamepadButtonState(true, true, false)
                    if Data and Data.IsVoucher then
                        self:ShowGamepadShortcut(self.ButtonX)
                    end
                end
            end
        end,
        ItemFocusReceivedCallback = function(Data)
            if UIUtils.IsGamepadInput() then
                if Data and Data.IsVoucher then
                    self:ShowGamepadShortcut(self.ButtonX)
                else
                    self:HideGamepadShortcut(self.ButtonX)
                end
            end
        end,
    })
    self:SetupVoucherExpireTimer()
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
            if IsValid(self.Shop_Discount_Btn) and self.Shop_Discount_Btn:IsVisible() and self.Shop_Discount_Btn.ForceCloseMenu then
                self.Shop_Discount_Btn:ForceCloseMenu()
            end
            self:InitDiscount()
            self.UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
            self:UpdatePricePanel()
            local ItemCurrencyWidget = self.Owner:GetContentWidgetByName("Item_Currency")
            if ItemCurrencyWidget then
                ItemCurrencyWidget:PlayAnimation(ItemCurrencyWidget.Text_Refrash)
            end
        end, false, 0, "VoucherExpireTimer")
    end
end

function M:OnDiscountChanged(NewDiscount)
    self.SelectedDiscount = NewDiscount
    self.Shop_Discount_Btn:SetSelectedDiscount(self.SelectedDiscount)
    self.UnitPrice = ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
    self:UpdatePricePanel()
    local ItemCurrencyWidget = self.Owner:GetContentWidgetByName("Item_Currency")
    if ItemCurrencyWidget then
        ItemCurrencyWidget:PlayAnimation(ItemCurrencyWidget.Text_Refrash)
    end
end

function M:OnDiscountMenuStateChanged(bIsOpen)
    self.FocusOnSubItem = bIsOpen
    self.InSelectDiscountMode = bIsOpen
    if UIUtils.IsGamepadInput() then
        if bIsOpen then
            -- self.FocusOnSubItem = true
            -- self.InSelectDiscountMode = true
            self:SetGamepadButtonState(true, true, false)
            self.Owner:GetButtonBar():SetGamepadBtnKeyVisibility(false)
            self.Owner:GetButtonBar().Btn_Yes:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Owner:GetButtonBar().Btn_Quit:SetIconPanelVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self:ForbidFocusToResource(true)
        else
            -- self.FocusOnSubItem = false
            -- self.InSelectDiscountMode = false
            self:SetGamepadButtonState(false, false, false)
            self:HideGamepadShortcut(self.ButtonX)
            self.Owner:GetButtonBar():SetGamepadBtnKeyVisibility(true)
            self.Owner:GetButtonBar().Btn_Yes:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
            self.Owner:GetButtonBar().Btn_Quit:SetIconPanelVisibility(UIConst.VisibilityOp["Collapsed"])
            self:ForbidFocusToResource(false)
            self.Owner:SetFocus()
        end
    else
        -- self.FocusOnSubItem = false
        -- self.InSelectDiscountMode = false
        self:HideGamepadShortcut(self.ButtonX)
        if not bIsOpen then
            self.Owner:SetFocus()
        end
    end
end

function M:ForbidFocusToResource(IsForbid)
    self.Owner.bForbidFocusToResource = IsForbid
    if UIUtils.IsGamepadInput() then
        if IsForbid then
            if self.Owner.WBP_Com_Tab_Node_ResourceBar then
                self.Owner.WBP_Com_Tab_Node_ResourceBar:HideGamePadKey(true)
            end
        else
            if self.Owner.WBP_Com_Tab_Node_ResourceBar then
                self.Owner.WBP_Com_Tab_Node_ResourceBar:HideGamePadKey(false)
            end
        end
    end
end
--#endregion

--- 发送普通商店购买RPC
--- self.ShopItemData.PurchaseFailRes 0:可购买 1:已售罄 2:货币不足
function M:Purchase()
    if self.IsLockState then
        if self.ConditionDisplay then
            return
        else
            ShopUtils:OpenLockConditionPopup(self.ShopItemData)
            return
        end
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    if self.ShopItemData.PurchaseFailRes ~= 0 then
        if self.ShopItemData.PurchaseFailRes == 1 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_REMAIN_PURCHASE_TIMES_EQUAL_ZERO, 1.0, "CommonToastMain")
        elseif self.ShopItemData.PurchaseFailRes == 2 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_No_Coin"), GText(DataMgr.Resource[self.ShopItemData.PriceType].ResourceName)), 1.0)
        elseif self.ShopItemData.PurchaseFailRes == 3 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("UI_Shop_Toast_Locked"), self.ShopItemData.UnlockLevel), 1.0)
        elseif self.ShopItemData.PurchaseFailRes == 7 then
            UIManager(self):ShowUITip("CommonToastMain", string.format(GText("RaidDungeon_Shop_Locked"), self.ShopItemData.UnlockRaidPoint), 1.0)
        elseif self.ShopItemData.PurchaseFailRes == 6 then
            UIManager(GWorld.GameInstance):ShowError(ErrorCode.RET_SHOPITEM_UNIQUE_ALREDAY_OWNED,1.0,"CommonToastMain")
        elseif self.ShopItemData.PurchaseFailRes == 4 then
            local PopUpId =  100136
            local Avatar = GWorld:GetAvatar()
            if not Avatar then
                return
            end
            local ItemName = ItemUtils:GetDropName(self.ShopItemData.TypeId, self.ShopItemData.ItemType)

            local PriceCount = Avatar.Resources[self.ShopItemData.PriceType] and Avatar.Resources[self.ShopItemData.PriceType].Count or 0

            local PopoverText = GText(DataMgr.CommonPopupUIContext[PopUpId].PopoverText)
            if string.find(PopoverText,'&ResourceName&') then
                PopoverText = string.gsub(PopoverText,'&ResourceName&', GText(DataMgr.Resource[CommonConst.Coins.Coin1].ResourceName))
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
                        PageJumpUtils:JumpToShopPage(CommonConst.GachaJumpToShopMainTabId,nil,nil, "Shop")
                    end
                    local Params = {}
                    Params.LeftCallbackObj = self
                    Params.RightCallbackObj = self
                    Params.RightCallbackFunction = JumpToShop
                    self.PopupUI = UIManager(self):ShowCommonPopupUI(100137,Params, self)
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
            self.PopupUI = UIManager(self):ShowCommonPopupUI(PopUpId,Params)
        elseif self.ShopItemData.PurchaseFailRes == 5 then

            local CachedParams = self.Params
            local CachedUIName = self.UIName
            local CachedCount = self.CurrentCount

            local ReOpenPurchaseSingle = function()
                local CommonPopupUIID = 100041
                ShopUtils:CanPurchase(CachedParams.ShopItemData, CachedParams.ShopItemData.PriceType, CachedCount * ShopUtils:GetShopItemPrice(CachedParams.ShopItemData.ItemId))
                UIManager(GWorld.GameInstance):ShowCommonPopupUI(CommonPopupUIID, CachedParams, UIManager(GWorld.GameInstance):GetUIObj(CachedUIName))
            end
            ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = ReOpenPurchaseSingle})
            local Params = {}
            Params.ShopItemId = self.ShopItemData.ItemId
            Params.Uid = Avatar.Uid
            Params.CloseBtnCallbackFunction = function(Obj, PackageData)
                ShopUtils:SetCloseGetItemPageCallback({CloseGetItemPageCallback = nil})
            end
            UIManager(self):LoadUINew("ShopTargetPay", Params)
        end
        return
    end
    ShopUtils:SendPurchaseRequest(self.ShopItemData.ItemId, self.CurrentCount, self.SelectedDiscount and self.SelectedDiscount.VoucherId or nil)
end

function M:OpenExchangeDialog()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    Avatar:TransformCoin4ToCoin1()
end


function M:CloseSelf()
    if self:IsAnimationPlaying(self.Out) then
        return
    end
    self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(Animation)
    if Animation == self.Out then
        ---@type Shop_Main_PC_C
        local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
        if ShopMain then
            ShopMain:RefreshSubTabData(ShopMain.CurSubTabMap)
            ShopMain:SetFocus()
        end
        self:Close()
    end
end

--- 根据当前状态更新所有UI元素
function M:UpdateUIByCurrentState()
    local isFocusOnSubItem = self.FocusOnSubItem
    local isTipsOpen = self.bTipsOpen
    local isGamePad = UIUtils.IsGamepadInput()

    if isGamePad then
        -- 设置滑块控件状态
        self:SetSliderState(not (isFocusOnSubItem or isTipsOpen))
        -- 设置手柄按钮可见性
        self:SetGamepadBtnKeyVisibility(not (isFocusOnSubItem or isTipsOpen))
        -- 更新UI元素可见性
        self:UpdateUIElementsVisibility(isGamePad, isFocusOnSubItem, isTipsOpen)
    else
        self:SetSliderState(true)
        self:SetGamepadBtnKeyVisibility(false)
        self:UpdateUIElementsVisibility(isGamePad, false, isTipsOpen)
    end

    -- 设置手柄按钮状态
    if isTipsOpen then
        -- 提示打开时，隐藏所有按钮
        self:SetGamepadButtonState(false, false, false)
    elseif isFocusOnSubItem then
        -- 子项目获得焦点时
        self:SetGamepadButtonState(true, true, false)
    else
        -- 正常状态
        self:SetGamepadButtonState(false, false, not self.SingleItemNotInteractive)
    end

    -- 如果不在子项目焦点状态且不是提示打开状态，更新价格面板
    if not isFocusOnSubItem and not isTipsOpen then
        self:UpdatePricePanel()
    end
end

--- 设置滑块控件状态
function M:SetSliderState(enabled)
    self.Com_Slider:SetEnabled(enabled)
    self.Com_Slider:ForbidMinOperation(not enabled)
    self.Com_Slider:ForbidAddOperation(not enabled)
end

--- 更新UI元素可见性
--- @param isSubItemFocused boolean 子项目是否获得焦点
--- @param isTipsOpen boolean 提示是否打开
function M:UpdateUIElementsVisibility(isGamePad, isSubItemFocused, isTipsOpen)
    -- 处理滚动按钮
    local shouldShowScrollBtn = isGamePad and not (isSubItemFocused or isTipsOpen) and
                                self.ShopItemData.ItemType ~= "Walnut" and
                                self.ScrollBox_0:GetScrollOffsetOfEnd() > 0
    if shouldShowScrollBtn then
        self:ShowGamepadShortcut(self.GamepadScrollBtnIndex)
    else
        self:HideGamepadShortcut(self.GamepadScrollBtnIndex)
    end

    -- 处理奖励描述和详情按钮
    local keyRewardVisibility = ESlateVisibility.Collapsed
    local keyBtnDetailVisibility = ESlateVisibility.Collapsed

    if isGamePad and not isTipsOpen and not isSubItemFocused then
        keyRewardVisibility = ESlateVisibility.SelfHitTestInvisible
    end

    self.Key_RewardDesc:SetVisibility(keyRewardVisibility)
    self.Key_Mod:SetVisibility(keyRewardVisibility)
    self.Key_Suit:SetVisibility(keyRewardVisibility)
    self.Key_BtnDetail:SetVisibility(keyBtnDetailVisibility)
end

--- 设置手柄按钮显示状态
function M:SetGamepadButtonState(showA, showB, showTips)
    -- 取消按钮
    if showB then
        self:ShowGamepadShortcut(self.ButtonIndexB)
    else
        self:HideGamepadShortcut(self.ButtonIndexB)
    end
    -- 确认按钮
    if showA then
        self:ShowGamepadShortcut(self.ButtonIndexA)
    else
        self:HideGamepadShortcut(self.ButtonIndexA)
    end
    -- 查看详情按钮
    if showTips then
        self:ShowGamepadShortcut(self.OpenTipsButtonIndex)
    else
        self:HideGamepadShortcut(self.OpenTipsButtonIndex)
    end
end

--- 手柄端打开物品详情时需隐藏弹窗的手柄样式
function M:ItemMenuAnchorChanged(bIsOpen)
    local wasOpen = self.bTipsOpen
    self.bTipsOpen = bIsOpen

    -- 如果从打开状态关闭，需要重置焦点
    if wasOpen and not bIsOpen and not self.FocusOnSubItem then
        self.Owner:SetFocus()
    end

    -- 更新UI状态
    self:UpdateUIByCurrentState()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        -- if InKeyName == "Escape" then
        --     self:CloseSelf()
        -- end
    end
    return IsEventHandled
end

function M:OnContentKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadUp(InKeyName)
    end

    return IsEventHandled
end

--- 处理手柄按键按下事件
function M:OnGamePadDown(InKeyName)
    local IsEventHandled = self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
    if self.InSelectDiscountMode then
        return UIUtils.Handled
    end
    if InKeyName == UIConst.GamePadKey.LeftThumb then
        -- 打开物品详情菜单
        if not self.SingleItemNotInteractive then
            if self.ShopItemData.ItemType == "Walnut" then
                self.SingleItem:OpenWalnutRewardDialog()
            elseif self.ShopItemData.ItemType ~= "WeaponSkin" then
                self.SingleItem:OpenItemMenu()
            end
        end
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
        if self.ShopItemData.ItemType == "Walnut" then
            self.TypeSort[1]:SetFocus()
            self.FocusOnSubItem = true
        end
        self:UpdateUIByCurrentState()
    elseif  InKeyName == UIConst.GamePadKey.SpecialRight then
        local WalnutDataTable = DataMgr.Walnut[self.ShopItemData.TypeId]
        if WalnutDataTable.MainRewardType == "Char" or WalnutDataTable.MainRewardType == "Weapon" then
            self.Btn_Suit:OnViewInfoHover()
        elseif WalnutDataTable.MainRewardType == "Mod" then
            self.FocusOnSubItem = true
            self:OnWalnutModDetailsClick()
        end
        self:UpdateUIByCurrentState()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and self.FocusOnSubItem then
        -- 从子项目回到主界面
        self.FocusOnSubItem = false
        self.Owner:SetFocus()
        self:UpdateUIByCurrentState()
        IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.DPadUp then
        if self.CanOpenDiscount then
            self.Shop_Discount_Btn:OnButtonClicked()
        end
    end

    return IsEventHandled
end

function M:OnGamePadUp(InKeyName)
    local IsEventHandled = self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
    if  InKeyName == UIConst.GamePadKey.SpecialRight then
        local WalnutDataTable = DataMgr.Walnut[self.ShopItemData.TypeId]
        if WalnutDataTable.MainRewardType == "Char" or WalnutDataTable.MainRewardType == "Weapon" then
            self.Btn_Suit:OnViewInfoUnHover()
        end
    end

    return IsEventHandled
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if self.InSelectDiscountMode then
        return UIUtils.Handled
    end
    if (InKeyName == UIConst.GamePadKey.RightAnalogY) then
        local DeltaOffset = (-1) * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
        local CurrentOffset = self.ScrollBox_0:GetScrollOffset()
        local NextOffset = math.clamp(CurrentOffset + DeltaOffset,0, self.ScrollBox_0:GetScrollOffsetOfEnd())
        self.ScrollBox_0:SetScrollOffset(NextOffset)
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

function M:UpdateDialogBtn()
    self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(not ShopUtils:CanPurchase(self.ShopItemData, self.ShopItemData.PriceType, self.CurrentCount * ShopUtils:GetShopItemPrice(self.ShopItemData.ItemId)))
end

function M:PackageData()
    return { CallObj = self, CallFunc = self.Purchase, CallFuncRougeShop = self.RougePurchase}
end

--- 根据输入设备类型更新UI样式
function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if CurInputDevice == UE4.ECommonInputType.Gamepad then
        self:UpdateUIByCurrentState()
    else
        if not self.bTipsOpen then
            self.Owner:SetFocus()
            self.FocusOnSubItem = false
        end
        self:UpdateUIByCurrentState()
    end
end

return M
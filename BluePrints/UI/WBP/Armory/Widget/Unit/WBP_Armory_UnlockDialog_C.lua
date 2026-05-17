--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local ArmoryUtils = require "BluePrints.UI.WBP.Armory.ArmoryUtils"
local FSM = require("Blueprints.UI.FocusStateMachine")
local FocusStates = {CardResource = "CardResource", ResourceBar = "ResourceBar",Tab = "Tab"}

---@type WBP_Armory_UnlockDialog_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
M._components = {
    "BluePrints.UI.KeyInputComponent"
}

function M:Construct()
    self.Text_Hold:SetText(GText("UI_Armory_WalnutNumber"))
    self.Btn_GetMore:SetText(GText("UI_Armory_JumpToWalnutArchive"))
    rawset(self,"FSM",FSM:New(self,{StateNames = FocusStates,
    OnStateChanged = self.OnFocusStateChanged,
    CheckFunction = self.IsFocusStateValid,}))
    rawset(self,"TabWidgets",{
        self.UnlockItem_1,self.UnlockItem_2
    })
    self.Btn_Close:BindEventOnClicked(self,self.OnCloseBtnClicked)
    self.Text_Close:SetText(GText("UI_Armory_ClickEmpty"))
    self.Btn_GetMore:SetDefaultGamePadImg("X")
    self.Btn_GetMore:BindEventOnClicked(self,self.OnGetMoreWalnutBtnClicked)
    self.Btn_Use:SetDefaultGamePadImg("Y")
    self.Btn_Use:BindEventOnClicked(self,self.OnUseWalnutBtnClicked)
    self.Btn_Use:BindForbidStateExecuteEvent(self,self.OnForbiddenUseWalnutBtnClicked)
    self.Btn_Exchange:SetDefaultGamePadImg("X")
    self.Btn_CheckForg:SetText(GText("UI_Armory_JumpToForgeArchive"))
    self.Btn_CheckForg:SetDefaultGamePadImg("X")
    self.Btn_CheckForg:BindEventOnClicked(self,self.OnJumpToForginPathBtnClicked)
    self.Item_Piece:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Text",
                Text = "LS",
            }
        }
    })
    self.Node_ResourceBar:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RS",
            }
        },
    })
    self:AddDispatcher(EventID.OnResourcesChanged,self,self.OnResourcesChanged)
    self:AddDispatcher(EventID.OnUpdateWalnutItem,self,self.OnUpdateWalnutCount)
    self:AddInputMethodChangedListen()
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:OnBackGroundBtnPressed()
    if(rawget(self,"IsMenuOpened"))then
        rawset(self,"bNextBackGroundClickDontClose",true)
    end
end

function M:OnBackGroundBtnClicked()
    if(rawget(self,"bNextBackGroundClickDontClose"))then
        rawset(self,"bNextBackGroundClickDontClose",false)
    else
        self:OnCloseBtnClicked()
    end
end

function M:OnCloseBtnClicked()
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:BindToAnimationFinished(self.Out, {self,self.Close})
    self:PlayAnimation(self.Out,0,1,0,1)
end

function M:Close()
    self:RemoveFromParent()
    if(self._OnClose)then
        self._OnClose(self.Owner)
    end
end

function M:PlayInAnim()
    self:UnbindAllFromAnimationFinished(self.Out)
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
end

function M:OnGetMoreWalnutBtnClicked()
    if(self.JumpToWalnutFunc)then
        self.JumpToWalnutFunc()
    else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Walnut_Toast_CanNotGet"))
    end
end

function M:OnJumpToForginPathBtnClicked()
    if(self.Type == "Weapon")then
        local DraftIds = DataMgr.Item2DraftIdMap["Weapon"][self.TargetId]
        local DraftId = DraftIds and DraftIds.DraftIds and DraftIds.DraftIds[1]
        if(DraftId)then
            PageJumpUtils:JumpToForgeCompendiumPathByDraftId(DraftId)
        end
    end
end

function M:OnUseWalnutBtnClicked()
    if(self.WalnutData)then
        local Avatar = GWorld:GetAvatar()
        local WalnutCount = Avatar.Walnuts.WalnutBag[self.WalnutData.WalnutId] or 0
        if(WalnutCount > 0)then
            PageJumpUtils:JumpToWalnutDungeonPage(self.WalnutData.WalnutType,self.WalnutData.WalnutId)
        else
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Walnut_Toast_LackWalnut"))
        end
    end
end

function M:OnForbiddenUseWalnutBtnClicked()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Walnut_Toast_LackWalnut"))
end

function M:Init(Params)
    self:PlayInAnim()
    Params = Params or {}
    rawset(self,"Type",Params.Type)
    rawset(self,"TargetId",Params.TargetId)
    rawset(self,"EscapeArmoryCharID",Params.EscapeArmoryCharID)
    rawset(self,"Parent",Params.Parent)
    rawset(self,"_OnClose",Params.OnClose)
    self:BindArmoryVisibilityChangedEvent()
    self:InitStand()
    self:UpdateResource()
    self:CreateJumpToJumpToWalnutFunc()
    self:UpdateResourceBar()
    self:InitTabs()
    self:SelectTab(self.Tabs[1])
end

function M:BindArmoryVisibilityChangedEvent()
    local ArmoryMain = UIManager(self):GetUIObj("ArmoryMain")
    if(ArmoryMain)then
        ArmoryMain.OnVisibilityChanged:Remove(self, self.OnArmoryVisibilityChanged)
        ArmoryMain.OnVisibilityChanged:Add(self,self.OnArmoryVisibilityChanged)
        ArmoryMain:BindEventOnClose(self,self.OnArmoryDestruct)
        ArmoryMain:BindEventOnDestruct(self,self.OnArmoryDestruct)
    end
end

function M:OnArmoryDestruct()
    if(IsValid(self))then
        self:Close()
    end
end

function M:Destruct()
    local ArmoryMain = UIManager(self):GetUIObj("ArmoryMain")
    if(ArmoryMain)then
        ArmoryMain:BindEventOnDestruct(self,nil)
    end
end

function M:OnArmoryVisibilityChanged(Visibility)
    self:SetVisibility(Visibility)
end

function M:InitStand()
    local IconPath
    if(self.Type == "Char")then
        self.Text_Title:SetText(GText("UI_Armory_UnlockCharTitle"))
        self.WS_Type:SetActiveWidgetIndex(0)
        self.Item_Piece:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        local SkinData = DataMgr.Skin[self.TargetId]
        IconPath = SkinData and SkinData.LongIcon
    elseif(self.Type == "Weapon")then
        self.Text_Title:SetText(GText("UI_Armory_UnlockWeaponTitle"))
        self.WS_Type:SetActiveWidgetIndex(1)
        self.Item_Piece:SetVisibility(UIConst.VisibilityOp.Collapsed)
        local WeaponData = DataMgr.Weapon[self.TargetId]
        IconPath = WeaponData.LongIcon or WeaponData.GachaIcon
    end
    local IconDynaMaterial = self.Img_Unlock:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetTextureParameterValue("IconMap",LoadObject(IconPath))
    end
end

function M:OnUpdateWalnutCount()
    self:SelectTab(self.CurrentTab)
end

function M:OnResourcesChanged(ResourceId)
    if(ResourceId == CommonConst.Coins.Coin4)then
        self:SelectTab(self.CurrentTab)
    elseif(self.Type == "Char" and ResourceId == rawget(self,"CardResourceId"))then
        self:UpdateResource()
        self:SelectTab(self.CurrentTab)
    end
end

function M:UpdateResource()
    if(self.Type ~= "Char")then
        return
    end
    local Data = DataMgr.Char[self.TargetId]
    local CardRid = Data and Data.CharPieceId
    if(not CardRid)then
        return
    end
    rawset(self,"CardResourceId",CardRid)
    local Avatar = GWorld:GetAvatar()
    local Resource = Avatar.Resources[CardRid] or {Count = 0}
    local ResourceData = DataMgr.Resource[CardRid]
    self.Item_Piece:Init({
        Owner = self,
        OnMenuOpenChanged = self.OnMenuOpenChanged,
        OnAddedToFocusPath = self.OnCharCardResourceAddedToFocusPath,
        Count = Resource.Count,
        CountNeed = Data.CharUnlockRequiredPiece,
        IconPath = ResourceData and ResourceData.Icon,
        Type = CommonConst.DataType.Resource,
        Id = CardRid,
        IsShowDetails = true,
    })
end

function M:UpdateResourceBar()
    local Info = {}
    if(self.WalnutData)then
        table.insert(Info,{WalnutId = self.WalnutData.WalnutId, Type = "Walnut"})
    end
    table.insert(Info,{CoinId = CommonConst.Coins.Coin4, Type = "Resource"})
    self.Node_ResourceBar:InitResourceBar(Info)
    self.Node_ResourceBar:BindEvents(self,{
        OnAddedToFocusPath = self.OnResourceBarAddedToFocusPath,
    })
    self.Node_ResourceBar:SetGetReplyOnBack(function()
        return self:OnBackFromResourceBar()
    end)
end

function M:OnMenuOpenChanged(IsOpen)
    rawset(self,"IsMenuOpened",IsOpen)
    if(not IsOpen)then
        self.FSM:Pop()
        self:GetDesiredFocusTarget():SetFocus()
    end
end

function M:InitTabs()
    rawset(self,"Tabs",{
        {
            Owner = self,OnClicked = self.OnTabClicked,
            OnAddedToFocusPath = self.OnTabWidgetAddedToFocusPath,
        },
        {
            Owner = self,OnClicked = self.OnTabClicked,
            OnAddedToFocusPath = self.OnTabWidgetAddedToFocusPath,
            Text = GText("UI_Armory_WeaponGetByMoney"),IconPath = ""
        },
    })
    local ResourceData = DataMgr.Resource[CommonConst.Coins.Coin4]
    self.Tabs[2].IconPath = ResourceData.Icon
    if(self.Type == CommonConst.DataType.Char)then
        self.Tabs[1].Text = GText("UI_Armory_CharPieceGetByWalnut")
        self.WS_Type:SetActiveWidgetIndex(0)
        if(rawget(self,"WalnutData"))then
            self.Tabs[1].IconPath = self.WalnutData.Icon
        end
    elseif(self.Type == CommonConst.DataType.Weapon)then
        self.Tabs[1].Text = GText("UI_Armory_WeaponGetByForge")
        self.WS_Type:SetActiveWidgetIndex(1)
        if(rawget(self,"WalnutData"))then
            self.Tabs[1].IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Unlock_ForgeIcon.T_Armory_Unlock_ForgeIcon'"
        end
    end
    self.TabWidgets[1]:Init(self.Tabs[1])
    self.TabWidgets[2]:Init(self.Tabs[2])
end

function M:CreateJumpToJumpToWalnutFunc()
    local WalnutIds
    if(self.Type == CommonConst.DataType.Char)then
        local Data = DataMgr.Char[self.TargetId]
        local CardRid = Data and Data.CharPieceId
        WalnutIds = DataMgr.Item2WalnutIdMap["Resource"][CardRid]
    elseif(self.Type == CommonConst.DataType.Weapon)then
        local DraftIds = DataMgr.Item2DraftIdMap["Weapon"][self.TargetId]
        local DraftId = DraftIds and DraftIds.DraftIds and DraftIds.DraftIds[1]
        WalnutIds = DataMgr.Item2WalnutIdMap["Draft"][DraftId]
    end
    if(not WalnutIds)then
        return
    end
    local WalnutId = WalnutIds and WalnutIds[1]
    local WalnutData = WalnutId and DataMgr.Walnut[WalnutId]
    rawset(self,"WalnutData",WalnutData)
    if WalnutData and WalnutData.AccessKey then
        local AccessData = DataMgr.Access["Shop_Main"]
        --目前有三种可能
        
        local IsShopAccessValid = AccessData and AccessData.UIUnlockRuleId and PageJumpUtils:IsValidAccess(AccessData.UIUnlockRuleId)
        local Success, JumpToWalnutFunc
        if(IsShopAccessValid)then
            Success, JumpToWalnutFunc = PageJumpUtils:CreateJumpToShopAccess("Walnut", "Shop", WalnutId, nil, 
            {
                CallBack = function()
                    self:SetFocus()
                end,
                CallBackObj = self
            })
            if(Success and JumpToWalnutFunc)then
                rawset(self,"JumpToWalnutFunc",JumpToWalnutFunc)
                return
            end
        end
        AccessData = DataMgr.Access["HardBoss"]
        local IsHardBossAccessValid = AccessData and AccessData.UIUnlockRuleId and PageJumpUtils:IsValidAccess(AccessData.UIUnlockRuleId)
        if(IsHardBossAccessValid)then
            Success, JumpToWalnutFunc = PageJumpUtils:CreateJumpToHardBoss(self.WalnutData.WalnutId,{UIUnlockRuleId = AccessData.UIUnlockRuleId})
            if(Success and JumpToWalnutFunc)then
                rawset(self,"JumpToWalnutFunc",JumpToWalnutFunc)
                return
            end
        end
        AccessData = DataMgr.Access["Abyss"]
        local IsAbyssAccessValid = AccessData and AccessData.UIUnlockRuleId and PageJumpUtils:IsValidAccess(AccessData.UIUnlockRuleId)
        if(IsAbyssAccessValid)then
            Success, JumpToWalnutFunc = PageJumpUtils:CreateJumpToAbyss(self.WalnutData.WalnutId)
            if(Success and JumpToWalnutFunc)then
                rawset(self,"JumpToWalnutFunc",JumpToWalnutFunc)
                return
            end
        end
        --TODO:没有获取途径怎么处理？
    end
end

function M:OnTabClicked(Tab)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
    self:SelectTab(Tab)
end

function M:SelectTab(Tab)
    self.CurrentTab = Tab
    if(Tab == self.Tabs[1])then
        self.TabWidgets[1]:OnSelect(true)
        self.TabWidgets[2]:OnSelect(false)
    elseif(Tab == self.Tabs[2])then
        self.TabWidgets[1]:OnSelect(false)
        self.TabWidgets[2]:OnSelect(true)
    end
    self.ExChangeBtnFunc = nil
    self.Btn_Exchange:UnBindEventOnClickedByObj(self)
    local Avatar = GWorld:GetAvatar()
    rawset(self,"BuyShopItemParams",{})
    if(self.Type == CommonConst.DataType.Char)then
        --角色
        self.WB_Enter:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Cost_Piece:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self.Btn_Use:SetText(GText("UI_Armory_JumpToWalnutDungeon"))
        local Data = DataMgr.Char[self.TargetId]
        local CardRid = Data and Data.CharPieceId
        if(not CardRid)then
            return
        end
        if(Tab == self.Tabs[1])then
            --密函tab
            self.WS_State:SetActiveWidgetIndex(0)
            self.Text_Tip:SetText(GText("UI_Armory_CharWalnutDes"))
            local WalnutIds = DataMgr.Item2WalnutIdMap["Resource"][CardRid]
            local WalnutId = WalnutIds and WalnutIds[1]
            local WalnutCount = WalnutId and Avatar.Walnuts.WalnutBag[WalnutId] or 0
            self.Num_Hold:SetText(WalnutCount)
            self.Btn_Use:ForbidBtn(WalnutCount <= 0)
        else
            --晶胚tab
            self.WS_State:SetActiveWidgetIndex(1)
            self.Text_Cost:SetText(GText("UI_Armory_CharPurchaseDes"))
            local CardResource = Avatar.Resources[CardRid] or {Count = 0}
            local NeedCount = 0
            if(CardResource.Count < Data.CharUnlockRequiredPiece)then
                --所需角色碎片
                NeedCount = Data.CharUnlockRequiredPiece - CardResource.Count
            end
            local ShopItemId,ShopItemData = ShopUtils:GetShopItemDataById(CardRid,CommonConst.DataType.Resource,true)
            if(not ShopItemData)then
                return
            end
            local NeedCoinCount = ShopItemData.Price * NeedCount
            local CoinResource = Avatar.Resources[ShopItemData.PriceType] or {Count = 0}
            local Denominator = NeedCoinCount
            if(NeedCoinCount > CoinResource.Count)then
                --显示红色文本样式，分母需要大于分子
                Denominator = Denominator + 1
            end
            self.Cost_Coin:InitContent({
                Owner = self,
                ResourceId = ShopItemData.PriceType,
                Numerator = NeedCoinCount,
                Denominator = Denominator,
                bShowDenominator = false,
                IsGamePadIconVisible = false,
            })
            self.Cost_Piece:InitContent({
                Owner = self,
                ResourceId = CardRid,
                Numerator = NeedCount,
                IsGamePadIconVisible = false,
            })
            if(CoinResource.Count < NeedCoinCount)then
                self.Btn_Exchange:SetText(GText("UI_Armory_JumpToShop"))
                self.ExChangeBtnFunc = self.OnGoToShop
                self.Btn_Exchange:BindEventOnClicked(self,self.OnGoToShop)
            else
                self.Btn_Exchange:SetText(GText("UI_Armory_CharPurchaseConfirm"))
                self.ExChangeBtnFunc = self.OnBuyCharBtnClicked
                self.Btn_Exchange:BindEventOnClicked(self,self.OnBuyCharBtnClicked)
                self.BuyShopItemParams.Resource1 = {
                    Id = CardRid,
                    ShopItemId = ShopItemId,
                    NeedCount = NeedCount,
                    Count = CardResource.Count,
                    ItemType = CommonConst.DataType.Resource,
                }
                self.BuyShopItemParams.Resource2 = {
                    Id = CoinResource.ResourceId,
                    NeedCount = NeedCoinCount,
                    Count = CoinResource.Count,
                    ItemType = CommonConst.DataType.Resource,
                }
            end
        end
    elseif(self.Type == CommonConst.DataType.Weapon)then
        self.WB_Enter:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Cost_Piece:SetVisibility(UIConst.VisibilityOp.Collapsed)
        if(Tab == self.Tabs[1])then
            self.WS_State:SetActiveWidgetIndex(2)
            self.Text_ForgTip:SetText(GText("UI_Armory_WeaponForgeDes"))
        else
            self.Text_Cost:SetText(GText("UI_Armory_WeaponPurchaseDes"))
            self.WS_State:SetActiveWidgetIndex(1)
            local ShopItemId,ShopItemData = ShopUtils:GetShopItemDataById(self.TargetId,CommonConst.DataType.Weapon,true)
            if(not ShopItemData)then
                return
            end
            local NeedCoinCount = ShopItemData.Price
            local CoinResource = Avatar.Resources[ShopItemData.PriceType] or {Count = 0}
            local Denominator = NeedCoinCount
            if(NeedCoinCount > CoinResource.Count)then
                --显示红色文本样式，分母需要大于分子
                Denominator = Denominator + 1
            end
            self.Cost_Coin:InitContent({
                Owner = self,
                ResourceId = ShopItemData.PriceType,
                Numerator = NeedCoinCount,
                Denominator = Denominator,
                bShowDenominator = false,
                IsGamePadIconVisible = false,
            })
            if(CoinResource.Count < NeedCoinCount)then
                self.Btn_Exchange:SetText(GText("UI_Armory_JumpToShop"))
                self.ExChangeBtnFunc = self.OnGoToShop
                self.Btn_Exchange:BindEventOnClicked(self,self.OnGoToShop)
            else
                self.Btn_Exchange:SetText(GText("UI_Armory_WeaponPurchaseConfirmButton"))
                self.ExChangeBtnFunc = self.OnBuyWeaponBtnClicked
                self.Btn_Exchange:BindEventOnClicked(self,self.OnBuyWeaponBtnClicked)
                self.BuyShopItemParams.ShopItemId = ShopItemId
                self.BuyShopItemParams.Resource1 = {
                    Id = CoinResource.ResourceId,
                    NeedCount = NeedCoinCount,
                    Count = CoinResource.Count,
                    ItemType = CommonConst.DataType.Resource,
                }
            end
        end
    end
end

---点击购买角色碎片
function M:OnBuyCharBtnClicked()
    if(not self.BuyShopItemParams or not next(self.BuyShopItemParams))then
        return
    end
    local Resource1 = self.BuyShopItemParams.Resource1
    local Resource2 = self.BuyShopItemParams.Resource2
    local R1Data = DataMgr.Resource[Resource1.Id]
    local BuyCount = Resource1.NeedCount
    local Params = {
        LeftItems = {{
            ItemId = Resource2.Id,
            ItemType = Resource2.ItemType,
            Count = Resource2.NeedCount,
        }},
        RightItems = {{
            ItemId = Resource1.Id,
            ItemType = Resource2.ItemType,
            Count = BuyCount,
        }},
        ShortTextParams = {Resource2.NeedCount,BuyCount,GText(R1Data.ResourceName)},
        RightCallbackFunction = function()
            self:BlockAllUIInput(true)
            self.IsWatingForBuyResource = true
            local Avatar = GWorld:GetAvatar()
            Avatar:PurchaseShopItem(Resource1.ShopItemId, BuyCount, true,function(Ret)
                self:OnPurchaseShopItem(Ret)
            end)
        end,
    }
    UIManager(self):ShowCommonPopupUI(100247, Params,self)
end

---购买角色碎片成功
function M:OnBuyCardResource()
    self:BlockAllUIInput(true)
    local Avatar = GWorld:GetAvatar()
    Avatar:UnlockCharUsePiece(self.TargetId,function(Ret,CharId)
        ArmoryUtils:OnUnlockCharUsePiece(Ret,CharId,self.EscapeArmoryCharID,function()
            self:BlockAllUIInput(false)
        end,function()
        end,function()
            self:OnCloseBtnClicked()
        end)
    end)
end

---点击购买武器
function M:OnBuyWeaponBtnClicked()
    local ResourceData = DataMgr.Resource[self.BuyShopItemParams.Resource1.Id]
    local WeaponData = DataMgr.Weapon[self.TargetId]
    if(not ResourceData or not WeaponData)then
        return
    end
    local Str1 = tostring(self.BuyShopItemParams.Resource1.NeedCount or "")
    local Str2 = GText(WeaponData.WeaponName or "")
    local Params = {
        ShortTextParams = {Str1,Str2},
        RightCallbackFunction = function()
            if(self.BuyShopItemParams.ShopItemId)then
                self:BlockAllUIInput(true)
                local Data = DataMgr.ShopItem[self.BuyShopItemParams.ShopItemId]
                self.WatingForBuyWeaponId = Data.TypeId
                local Avatar = GWorld:GetAvatar()
                Avatar:PurchaseShopItem(self.BuyShopItemParams.ShopItemId, 1, true,function(Ret)
                    self:OnPurchaseShopItem(Ret)
                end)
            end
        end,
    }
    UIManager(self):ShowCommonPopupUI(100262, Params,self)
end

---购买商品回调
function M:OnPurchaseShopItem(Ret)
    if(not self.IsWatingForBuyResource and not self.WatingForBuyWeaponId)then
        return
    end
    self:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then return end
    if(self.IsWatingForBuyResource)then
        self.IsWatingForBuyResource = false
        self:OnBuyCardResource()
    elseif(self.WatingForBuyWeaponId)then
        local ShowWeaponParams = {
            TargetIdList = {self.WatingForBuyWeaponId},
            CallbackObj = self,
            CallbackFunc = function()
                self:OnCloseBtnClicked()
            end
        }
        self.WatingForBuyWeaponId = nil
        local ArmoryMain = UIManager(self):GetUIObj("ArmoryMain")
        if(ArmoryMain and ArmoryMain.ActorController)then
            ArmoryMain.ActorController:StopPlayerSound()
        end
        UIManager(self):LoadUINew("GetWeaponPage",ShowWeaponParams)
    end
end

---跳转商店
function M:OnGoToShop()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    local CostType
    local CostNum
    if self.Type == CommonConst.DataType.Char then
        local Data = DataMgr.Char[self.TargetId]
        if not Data then
            return
        end
        local CardRid = Data.CharPieceId
        local CardResource = Avatar.Resources[CardRid] or {Count = 0}
        local NeedCount = 0
        if CardResource.Count < Data.CharUnlockRequiredPiece then
            NeedCount = Data.CharUnlockRequiredPiece - CardResource.Count
        end
        local _, ShopItemData = ShopUtils:GetShopItemDataById(CardRid, CommonConst.DataType.Resource, true)
        if not ShopItemData then
            return
        end
        CostType = ShopItemData.PriceType
        CostNum = ShopItemData.Price * NeedCount
    elseif self.Type == CommonConst.DataType.Weapon then
        local _, ShopItemData = ShopUtils:GetShopItemDataById(self.TargetId, CommonConst.DataType.Weapon, true)
        if not ShopItemData then
            return
        end
        CostType = ShopItemData.PriceType
        CostNum = ShopItemData.Price
    end
    UIManager(self):LoadUINew("ShopTargetPay", {
        CostNum = CostNum,
        CostType = CostType,
        RightCallbackObj = self,
        CallbackInfo = {
            Func = self.OnRechargeCallback,
            Obj = self,
        }
    }, self)
end

function M:OnRechargeCallback(GoodsId, ShopItems, OrderId)
    if ShopItems and DataMgr.PayGoods[GoodsId].ItemId then
        self:SelectTab(self.CurrentTab)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Reply,IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    if(IsHandled)then
        return Reply,IsHandled
    end
    return UIUtils.Handled
end

--#region 手柄相关

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    M.Super.OnUpdateUIStyleByInputTypeChange(self,CurInputDevice, CurGamepadName)
    if(self.IsGamepadInput)then
        self.Key_Close_Gamepad:CreateCommonKey({
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B",
                }
            },
            Desc = GText("UI_BACK"),
        })
        self.WS_MP:SetActiveWidgetIndex(1)
        if(self.InFocusPath)then
            local Widget = self:GetDesiredFocusTarget()
            if(Widget)then
                Widget:SetFocus()
            end
        end
    else
        self.WS_MP:SetActiveWidgetIndex(0)
    end
    self:OnFocusChanged()
end

function M:OnFocusChanged()
    self:AddKeyDownEvent(EKeys.Escape.KeyName,self.OnBackKeyDown)
    self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight,self.OnBackKeyDown)
    self:AddKeyDownEvent(UIConst.GamePadKey.LeftThumb,self.OnFocusToCardResourceKeyDown)
    self:AddKeyDownEvent(UIConst.GamePadKey.RightThumb,self.OnFocusToResourceBarKeyDown)
    self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonLeft,self.OnFaceButtonLeftKeyDown)
    self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonTop,self.OnFaceButtonTopKeyDown)
    if(not self.IsGamepadInput)then
        return
    end
    local State = self.FSM:Peak()
    local StateName = State.Name
    if(StateName == FocusStates.Tab)then
        if(self.CurrentTab ~= State.Tab)then
            self:SelectTab(State.Tab)
        end
    end
end

function M:OnBackKeyDown()
    if(self.IsGamepadInput)then
        self.FSM:Pop()
        local State = self.FSM:Peak()
        local StateName = State.Name
        if(StateName == FocusStates.Tab)then
            return  UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget()),true
        else
            self:OnCloseBtnClicked()
        end
    else
        self:OnCloseBtnClicked()
    end
end

function M:OnFaceButtonLeftKeyDown()
    if(self.WS_State:GetActiveWidgetIndex() == 0)then
        self:OnGetMoreWalnutBtnClicked()
    elseif(self.WS_State:GetActiveWidgetIndex() == 1)then
        if(self.ExChangeBtnFunc)then
            self.ExChangeBtnFunc(self)
        end
    elseif(self.WS_State:GetActiveWidgetIndex() == 2)then
        self:OnJumpToForginPathBtnClicked()
    end
end

function M:OnFaceButtonTopKeyDown()
    if(self.WS_State:GetActiveWidgetIndex() == 0)then
        self:OnUseWalnutBtnClicked()
    end
end

function M:OnFocusToCardResourceKeyDown()
    if(self.Item_Piece:IsVisible())then
        self.Item_Piece:OnBtnClicked()
        return UIUtils.Handled,true
    end
end

function M:OnFocusToResourceBarKeyDown()
    self.Node_ResourceBar:FocusToResource()
end

function M:OnTabWidgetAddedToFocusPath(Tab)
    self.FSM:Pop()
    self.FSM:Push({Name = FocusStates.Tab,Widget = Tab.Widget,Tab = Tab})
    if(not self.IsGamepadInput)then
        return
    end
    self:SelectTab(Tab)
end

function M:OnResourceBarAddedToFocusPath(Widget)
    self.FSM:Push({Name = FocusStates.ResourceBar,Widget = Widget})
    if(not self.IsGamepadInput)then
        return
    end
end

function M:OnCharCardResourceAddedToFocusPath(Widget)
    --self.FSM:Push({Name = FocusStates.CardResource,Widget = Widget})
end

function M:OnAddedToFocusPath()
    rawset(self,"InFocusPath",true)
end

function M:OnRemovedFromFocusPath()
    rawset(self,"InFocusPath",false)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return  UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget())
end

function M:OnBackFromResourceBar()
    self.FSM:Pop()
    return  UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self:GetDesiredFocusTarget())
end

function M:GetDesiredFocusTarget()
    local State = self.FSM:Peak()
    local StateName = State.Name
    if(StateName == FocusStates.CardResource)then
        return State.Widget
    elseif(StateName == FocusStates.Tab)then
        return State.Widget
    elseif(StateName == FocusStates.ResourceBar)then
        return State.Widget
    else
        return self.TabWidgets[1]
    end
end

--#endregion

AssembleComponents(M)
return M

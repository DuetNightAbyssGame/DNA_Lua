--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local MiscUtils = require "Utils.MiscUtils"
---@type WBP_Activity_Store_P_C
local M = Class("BluePrints.UI.Shop.WBP_Shop_Base_New_C")

M._components = {
    "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp",
    "BluePrints.UI.UI_PC.Common.LSFocusComp",
}
function M:Initialize(Initializer)
    self.Super.Initialize(self)
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self)
    self.bIsFocusable = true
    self.Filters = { "UI_Select_Default", "UI_Select_Time", "UI_RARITY_NAME", "UI_PRICE_NAME" }
    self.MainTabMap = {}
    self.SubTabMap = {}
    self.bFilterOwned = false
    self:PlayAnimationReverse(self.Filtrate_Normal)
    self.Text_CountdownTime:SetVisibility(ESlateVisibility.Collapsed)
    local MainTabIdx, SubTabIdx, ShopItemId, ShopSystemName, CloseCallBack, ClsoeCallBackObj = ...
    self.SelectShopItemId = ShopItemId
    self.CloseCallBack = CloseCallBack
    self.ClsoeCallBackObj = ClsoeCallBackObj
    self.List_Item:SetVisibility(ESlateVisibility.Visible)
    self.Group_Own:SetVisibility(ESlateVisibility.Collapsed)

    self.Common_Tab:BindEventOnTabSelected(self, self.OnMainTabChanged)
    if ShopSystemName then
        local ShopBGM = DataMgr.Shop[ShopSystemName].PlaySystemUIBGM
        if ShopBGM then
            AudioManager(self):PlaySystemUIBGM(ShopBGM, nil, ShopSystemName)
        end
    end
    self:InitShop(MainTabIdx, SubTabIdx, ShopItemId, ShopSystemName)
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    self:OnUpdateUIStyleByInputTypeChange(self.CurInputDeviceType, self.CurGamepadName)
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    if self.ShopType then
        local ShopBGM = DataMgr.Shop[self.ShopType].PlaySystemUIBGM
        if ShopBGM then
            AudioManager(self):PlaySystemUIBGM(ShopBGM, nil, self.ShopType)
        end
    end
end

function M:ReceiveExitState(StackAction)
    M.Super.ReceiveExitState(self, StackAction)
end

function M:Construct()
    M.Super.Construct(self)
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
        local Content = NewObject(self.ShopItemContentClass)
        Content.ShopId = nil
        return Content
    end)
    self.Text_ShopItemEmpty:SetText(GText("UI_SHOP_SOLDOUT"))
    self:AddDispatcher(EventID.OnRechargeFinished, self, self.OnRechargeFinished)
    if self.Common_Tab.WBP_Com_Tab_ResourceBar then
        self.Common_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self.List_Item)
    end
end

--- 初始化商店页签信息
---@param MainTabIdx number @主页签索引
---@param SubTabIdx number @子页签索引
---@param ShopType number @商店类型[Shop表中SystemName]
function M:InitShopTabInfo(MainTabIdx, SubTabIdx, ShopType)

    local MainShopTabData = DataMgr.Shop[ShopType]
    assert(MainShopTabData, "获取商店类型信息失败:"..ShopType)
    self:LoadShopTabInfo(MainShopTabData)

    self.Common_Tab:Init({
        LeftKey = "Q", RightKey = "E", Tabs = self.MainTabList, 
        DynamicNode = { "Back","ResourceBar",},
        StyleName = "Text",
        TitleName = GText(MainShopTabData.ShopName),
        OverridenTopResouces = self.OverridenTopResouces,
        OwnerPanel = self,
        BackCallback = self.CloseSelf}
    )

    self.Common_Tab:BindEventOnTabSelected(self, self.OnMainTabChanged)
    if not MainTabIdx then
        self.Common_Tab:SelectTab(1)
    else
        self.Common_Tab:SelectTab(self.MainTabs[MainTabIdx])
        if self.Common_Toggle_TabGroup_PC then
            self.Common_Toggle_TabGroup_PC:SelectTab(self.SubTabMapIdx[SubTabIdx])
        end
    end
    self:AddLSFocusTarget(nil, {self.Common_SortList_PC})
end

--- 主页签切换回调方法
---@param TabWidget Common_Tab_Item_PC_C
function M:OnMainTabChanged(TabWidget)
    local MainTabId = self.MainTabMap[TabWidget.Idx]
    if not MainTabId then
        return
    end
    self:LoadMainTabInfo(MainTabId)

    if self.Common_Toggle_TabGroup_PC then
        self.Common_Toggle_TabGroup_PC:Init( { 
            LeftKey = "A", 
            RightKey = "D",
            Tabs = self.SubTabList,
        } )
        self.Common_Toggle_TabGroup_PC:BindEventOnTabSelected(self, self.OnSubTabChanged)
        self.Common_Toggle_TabGroup_PC:SelectTab(1)
        if #self.SubTabList <= 1 then
            self.Tab:SetVisibility(ESlateVisibility.Collapsed)
        else
            self.Tab:SetVisibility(ESlateVisibility.Visible)
        end
    end
end

---@param TabWidget Common_Tab_Item_PC_C
function M:OnSubTabChanged(TabWidget)
    local SubTabData = self.SubTabMap[TabWidget.Idx]
    if not SubTabData then
        return
    end
    self.Group_Item:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:RefreshSubTabData(SubTabData)
end

function M:RefreshSubTabData(SubTabData)
    self:LoadSubTabInfo(SubTabData)
    if self.Change then
        self:PlayAnimation(self.Change)
    end
    self:UpdateShopDetail(self.CurSubTabMap)
end

function M:UpdateShopDetail(SubTabData)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end
    self:SetTabReddot(self.ShopType)
    M.Super.UpdateShopDetail(self, SubTabData)

end


function M:Close()
    local MenuWorld = UIManager(self):GetUIObj("MenuWorld")
    if MenuWorld then
        MenuWorld:InitSystemItem()
    end
    AudioManager(self):StopSystemUIBGM(self.ShopType)
    if IsValid(self.ClsoeCallBackObj) and self.CloseCallBack then
        self.CloseCallBack(self.ClsoeCallBackObj)
    end
    self.Super.Close(self)
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:BlockAllUIInput(true,"SP_DisplayOnly")
        self:Close()
    elseif InAnimation == self.In then
        self:BlockAllUIInput(false)
        if self.SelectShopItemId then
            self:AddTimer(0.1, function()
                self:ShowItemDetail()
                self.SelectShopItemId = nil
            end, false, 0, "OpenShopItemDialog", true)
        end
    end
end


function M:Destruct()
    local Player = UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player then
        Player:SetCanInteractiveTrigger(true)
    end
    self:HorizontalListViewResize_TearDown()
    self:CleanTimer()
    self.List_Item.OnCreateEmptyContent:Unbind()
    self.Super.Destruct(self)
end

function M:SetTabReddot(ShopType)
    for _, MainTabId in pairs(DataMgr.Shop[ShopType].MainTabId) do
        local Data = DataMgr.ShopItem2ShopTab[MainTabId]
        local MainTabNeedReddot = false
        if Data then
            for SubTabId, ShopItemData in pairs(Data) do
                local SubTabNeedReddot = false
                for _, ItemId in pairs(ShopItemData) do
                    if ShopUtils:IsFree(ItemId) then
                        SubTabNeedReddot = true
                        MainTabNeedReddot = true
                        break
                    end
                end
                if SubTabNeedReddot then
                    self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, false, true, false)
                else
                    self.Common_Toggle_TabGroup_PC:ShowTabRedDotByTabId(SubTabId, false, false, false)
                end
            end
            if MainTabNeedReddot then
                self.Common_Tab:ShowTabRedDotByTabId(MainTabId, false, true, false)
            else
                self.Common_Tab:ShowTabRedDotByTabId(MainTabId, false, false, false)
            end
        end
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_LeftTrigger" or InKeyName == "Gamepad_RightTrigger"  then
        if self.Common_Toggle_TabGroup_PC then
            IsEventHandled = self.Common_Toggle_TabGroup_PC:Handle_KeyEventOnGamePad(InKeyName)
        end
    elseif InKeyName == "Gamepad_FaceButton_Right" then
        if not UIManager(self):GetUIObj("CommonDialog") then
            self:CloseSelf()
        end
        IsEventHandled = true
    else
        IsEventHandled = self.Common_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
    return IsEventHandled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 输入设备切换通知
    if CurInputDevice == ECommonInputType.Gamepad then
        self:InitGamepadView()
    else
        self:InitKeyboardView()
    end
end

function M:InitGamepadView()
    local BottomKeyInfo = {
        {
            KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback=self.CloseSelf, Owner=self} },
            Desc = GText("UI_Tips_Close")
        },
    }
    self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
end

function M:InitKeyboardView()
    local BottomKeyInfo = {
        {
            KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback=self.CloseSelf, Owner=self} },
            Desc = GText("UI_BACK")
        },
    }
    self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
end
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnKeyDownForLSComp(MyGeometry, InKeyEvent)
        if not IsEventHandled then
            IsEventHandled = self:OnGamePadDown(InKeyName)
        end
    else
        if InKeyName == "Escape" then
            if  not UIManager(self):GetUIObj("CommonDialog") and
                not self.bCannotResponseEscape then
                    IsEventHandled = true
                self:CloseSelf()
            end
        elseif InKeyName == "Q" then
            IsEventHandled = true
            self.Common_Tab:TabToLeft()
        elseif InKeyName == "E" then
            IsEventHandled = true
            self.Common_Tab:TabToRight()
        elseif InKeyName == "A" then
            if self.Common_Toggle_TabGroup_PC then
                IsEventHandled = true
                self.Common_Toggle_TabGroup_PC:TabToLeft()
            end
        elseif InKeyName == "D" then
            if self.Common_Toggle_TabGroup_PC then
                IsEventHandled = true
                self.Common_Toggle_TabGroup_PC:TabToRight()
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end
AssembleComponents(M)
return M

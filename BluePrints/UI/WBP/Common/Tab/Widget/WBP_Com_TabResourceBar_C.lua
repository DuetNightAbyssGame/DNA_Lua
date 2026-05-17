--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_TabResourceBar_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C"})

function M:Construct()
    self.Btn_Add.OnClicked:Add(self, self.OnBtnClicked)
    self.Btn_Item.OnHovered:Add(self, self.OnIconHovered)
    self.Btn_Item.OnUnhovered:Add(self, self.OnIconUnhovered)
    self.Btn_Item.OnPressed:Add(self, self.OnIconPressed)
    --self.Btn_Item.OnReleased:Add(self, self.OnIconReleased)
    self.Btn_Item.OnClicked:Add(self, self.OnIconClicked)
    self.Common_Item_Icon:BindEvents(self,{OnMenuOpenChanged = self.OnMenuOpenChanged})
    self:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})
    self:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})
    self:SetNavigationRuleBase(EUINavigation.Up,EUINavigationRule.Stop)
    self:SetNavigationRuleBase(EUINavigation.Down,EUINavigationRule.Stop)
    EventManager:AddEvent(EventID.OnResourcesChanged, self, self.OnResourcesChanged)
    EventManager:AddEvent(EventID.OnUpdateWalnutItem, self, self.OnUpdateWalnutItem)
     -- 监听输入设备变化
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self:GetOwningPlayer())
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:Destruct()
	EventManager:RemoveEvent(EventID.OnResourcesChanged, self)
	EventManager:RemoveEvent(EventID.OnUpdateWalnutItem, self)
end

function M:OnResourcesChanged(ResourceId)
    if(self.Id and self.Id == ResourceId and self.ItemType == "Resource")then
        self:RefreshItemInfo()
    end
end

function M:OnUpdateWalnutItem()
    if(self.Id and self.ItemType == "Walnut")then
        self:RefreshItemInfo()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:SetItemId(ItemId, Type)
    self.Panel_Resource:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.Id = ItemId
    self.ItemType = Type or "Resource"

    self:RefreshItemInfo()
end
--- 设置通用代币栏加号的隐藏恢复
---@param bIsVisible 是否显示加号
function M:SetAddVisibilty(bIsVisible)
    if  bIsVisible then
        self.Btn_Add:SetVisibility(UIConst.VisibilityOp["Visible"])
        self.SizeBox_Add:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Btn_Add:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.SizeBox_Add:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:ShowBubble(ConfigData)
    self.HudBubbleWidget = UIManager(self):_CreateWidgetNew('CommonHudBubble')
    self.Pos_Bubble:AddChild(self.HudBubbleWidget)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.HudBubbleWidget)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Center)
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Center)
    self.HudBubbleWidget:Init({
        IconPath = ConfigData.IconPath,
        Text = ConfigData.Text,
        ColorType = ConfigData.ColorType,
        Arrow = ConfigData.Arrow,
    })
    self.HudBubbleWidget:PlayAnimation(self.HudBubbleWidget.In)
end

function M:HideBubble()
    if IsValid(self.HudBubbleWidget) then
        self.HudBubbleWidget:StopAnimation(self.HudBubbleWidget.In)
        self.HudBubbleWidget:PlayAnimation(self.HudBubbleWidget.Out)
    end
    self.HudBubbleWidget = nil
    
    --     self.Pos_Bubble:ClearChildren()
end

function M:RefreshItemInfo()
    if self.Id then
        local Avatar = GWorld:GetAvatar()
        local FormData = DataMgr.CurrencyForm[self.Id]
        if(FormData and FormData.IfAdd)then
            self.Btn_Add:SetVisibility(UIConst.VisibilityOp["Visible"])
            self.SizeBox_Add:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Btn_Add:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            self.SizeBox_Add:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
        local Data
        if self.ItemType == "Walnut" then
            Data = DataMgr.Walnut[self.Id]
        else
            Data = DataMgr.Resource[self.Id]
        end
        if(Avatar and Data)then
            -- local icon = LoadObject(DataMgr.Resource[self.Id].Icon)
            -- self.Img_Currency:SetBrushResourceObject(icon)
            local Item
            if self.ItemType == "Walnut" then
                local Count = Avatar.Walnuts.WalnutBag[self.Id] or 0
                self.Text_Num:SetText(Count)
            elseif(self.Id == CommonConst.ActionPoint)then
                --如果为精力
                Item = {Count = Avatar.ActionPoint or 0}
                if(FormData and FormData.IfMax)then
                    self.WidgetSwitcher_Num:SetActiveWidgetIndex(1)
                    self.Num_AP_Now:SetText(Item.Count)
                    self.Num_AP_Total:SetText(DataMgr.GlobalConstant.CostRecoveryMax.ConstantValue)
                else
                    self.WidgetSwitcher_Num:SetActiveWidgetIndex(0)
                    self.Text_Num:SetText(Item.Count)
                end
            else
                Item = Avatar.Resources[self.Id] or {Count = 0}
                self.Text_Num:SetText(Item.Count)
            end
            self.Panel_Resource:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            return
        end
    end
    self.Panel_Resource:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self:BindEventOnClicked()
end

function M:BindEventOnClicked(obj,event)
    self.Obj_OnClick = obj
    self.Event_OnClick = event
end

function M:OnBtnClicked()
    if(self.Event_OnClick)then
        self.Event_OnClick(self.Obj_OnClick)
    end
    --临时，按照Id处理不同点击逻辑
    if self.Id == CommonConst.PhysicalStrengthId then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small",nil,nil)
        local GameInstance = self:GetGameInstance()
        local UIManager = GameInstance:GetGameUIManager()
        --UIManager:LoadUI(UIConst.RecoverUI,"RecoverUI",99)
        --UIManager:LoadUINew(UIConst.RecoverUI)
        --体力系统删除先注释了
        --UIManager:ShowCommonPopupUI(100185, {},Obj)
    elseif self.Id == CommonConst.Coins.Coin1 then
        local GameInstance = self:GetGameInstance()
        local UIManager = GameInstance:GetGameUIManager()
        local MaxValue = 0
        local Data = DataMgr.Resource[CommonConst.Coins.Coin4]
        local Avatar = GWorld:GetAvatar()
        if(Avatar and Data)then
            local Resource = Avatar.Resources[CommonConst.Coins.Coin4] or {Count = 0}
            MaxValue = Resource.Count
        end
        local CommonDialogWidget = UIManager:GetUIObj("CommonDialog")
        if CommonDialogWidget then
            if CommonDialogWidget:GetContentWidgetByName("Shop_ExchangePart") then
                return
            end
            UIManager:ShowCommonPopupUI_Interrupt(100198, {AutoFocus = true, Funds = {{FundId = CommonConst.Coins.Coin4, FundNeed = MaxValue}}})
        else
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small",nil,nil)
            UIManager:ShowCommonPopupUI(100198, {AutoFocus = true, Funds = {{FundId = CommonConst.Coins.Coin4, FundNeed = MaxValue}}})
        end
    end
end

function M:PlayInAnim()
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    return self.In:GetEndTime()
end

function M:PlayOutAnim()
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
    return self.Out:GetEndTime()
end

function M:OnIconHovered()
    return self.Common_Item_Icon:OnMouseEnter()
end

function M:OnIconUnhovered()
    return self.Common_Item_Icon:OnMouseLeave()
end

function M:OnIconPressed()
    return self.Common_Item_Icon:OnMouseButtonDown()
end

function M:OnIconClicked()
    return self.Common_Item_Icon:OnMouseButtonUp()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),self.Btn_Item)
end

function M:BindEventOnMenuOpenChanged(obj,event)
    self.Obj_OnMenuOpenChanged = obj
    self.Event_OnMenuOpenChanged = event
end

function M:OnMenuOpenChanged(bIsOpen)
    self.bIsMenuOpened = bIsOpen
    if(not bIsOpen and self.IsGamePad)then
        --使用鼠标关闭菜单聚焦会给到上级界面。
        --使用按键关闭菜单时User会丢失聚焦，
        --但此控件仍在聚焦路径内，导致一些UI样式出问题
        --因此使用手柄关闭菜单时需要重新聚焦一下
        self:SetFocus()
    end
    if(self.Event_OnMenuOpenChanged)then
        self.Event_OnMenuOpenChanged(self.Obj_OnMenuOpenChanged, bIsOpen)
    end
end

function M:IsMenuOpened()
    return self.bIsMenuOpened
end

--#region 手柄相关

function M:BindNavigationEvents(Obj,Events)
    Events = Events or {}
    self.Obj_Navigation = Obj
    self.Event_OnNavigationToBoundary = Events.OnNavigationToBoundary
    self.Event_OnAddedToFocusPath = Events.OnAddedToFocusPath
    self.Event_OnRemovedFromFocusPath = Events.OnRemovedFromFocusPath
end

function M:OnNavigationToBoundary(NavigationDirection)
    if(self.Event_OnNavigationToBoundary)then
        return self.Event_OnNavigationToBoundary(self.Obj_Navigation,NavigationDirection)
    end
    return nil
end

function M:OnAddedToFocusPath(InFocusEvent)
    --自身添加到聚焦路径时通知父控件更新样式
    if(self.Event_OnAddedToFocusPath)then
        self.Event_OnAddedToFocusPath(self.Obj_Navigation,self)
    end
end
function M:OnRemovedFromFocusPath(InFocusEvent)
    --自身从聚焦路径移除时通知父控件
    if(self.Event_OnRemovedFromFocusPath)then
        self.Event_OnRemovedFromFocusPath(self.Obj_Navigation,self)
    end
end

function M:OnUINavigation(NavigationDirection)
    if(self.Btn_Add:HasAnyUserFocus())then                              --如果+号有聚焦
        if(NavigationDirection == EUINavigation.Left)then
            return self.Btn_Item                                        --向左导航到货币按钮
        else
            return self:OnNavigationToBoundary(NavigationDirection)     --向右导航交给父控件处理
        end
    else                                                                --如果+号有聚焦但自身能接收导航事件，说明聚焦在货币按钮上
        if(NavigationDirection == EUINavigation.Left)then
            return self:OnNavigationToBoundary(NavigationDirection)     --向左导航交给父控件处理
        else
            if(self.Btn_Add:IsVisible() and not self:IsMenuOpened())then
                return self.Btn_Add                                     --如果有+号按钮而且没打开菜单，向右导航+号
            else
                return self:OnNavigationToBoundary(NavigationDirection) --否则交给父控件处理
            end
        end
    end
end

--#endregion 手柄相关

return M

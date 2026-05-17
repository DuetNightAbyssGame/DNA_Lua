--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_Recommend_ListItem_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C", "BluePrints.Common.DelayFrameComponent"})

function M:Construct()
    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)
    self.Btn_Click.OnPressed:Add(self, self.OnItemOnPressed)
end


--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:OnListItemObjectSet(Content)
    self.Content = Content
    self.Content.SelfWidget = self
    self.BannerId = Content.BannerId
    self.VirtualClickCallback = Content.VirtualClickCallback
    self.OnKeyDownCallBack = Content.OnKeyDownCallBack
    self.SetListItemCallBack = Content.SetListItemCallBack
    self.UpToSwitchWidget = Content.UpToSwitchWidget
    self.Parent = Content.Parent
    self.ScrollboxIndex = Content.ScrollboxIndex

    if self.UpToSwitchWidget then
        self:SetNavigationRuleExplicit(EUINavigation.Up, self.UpToSwitchWidget)
    end

    local BannerData = DataMgr.ShopBannerTab[self.BannerId]
    assert(BannerData, "未找到对应的Banner页信息："..self.BannerId)
    local BannerIcon = LoadObject(BannerData.BannerIcon)
    assert(BannerIcon, "未找到Banner页对应的Icon:"..self.BannerId)
    self.Text_Title:SetText(GText(BannerData.Text1))

    local IconDynaMaterial = self.Image_ItemIcon:GetDynamicMaterial()
    if IconDynaMaterial then
        IconDynaMaterial:SetTextureParameterValue("IconMap", BannerIcon)
    end
    
    if BannerData.MarkText then
        self.Group_Sign:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Text_MoreNum:SetText(GText(BannerData.MarkText))
    else
        self.Group_Sign:SetVisibility(ESlateVisibility.Hidden)
    end
    self:BindClickEvent(Content.ClickEvent)
    if Content.bSelected then
        self:OnItemClick(nil, true)
    end
end

function M:BindClickEvent(ClickEvent)
    self.ClickObj = ClickEvent.Obj
    self.ClickCallback = ClickEvent.Callback
end

function M:OnItemClick(bTriggerClickWhenHover, bNotPlayMusic)
    if self.bSelected then
        if not bTriggerClickWhenHover and (type(self.VirtualClickCallback) == "function") then
            self.VirtualClickCallback(self.Parent, self.BannerId)
        end
        local ShopMain = UIManager(self):GetUIObj("ShopMain")
        if ShopMain and ShopMain.TabType == "Banner" and ShopMain.SelectBannerId and ShopMain.BannerIdMap and type(ShopMain.BannerIdMap) == "table" then
            local CurrentPage = ShopMain.BannerIdMap[ShopMain.SelectBannerId]
            if CurrentPage and CurrentPage.HandlePreviewKeyDown and UIUtils.IsGamepadInput() then
                CurrentPage:HandlePreviewKeyDown(nil, Const.GamepadFaceButtonDown)
            end
        end
        return
    end
    if not self.ClickCallback then
        return
    end
    self.bSelected = true
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    self.ClickCallback(self.ClickObj, self.BannerId, self.Content, not bNotPlayMusic)
end

function M:OnItemHovered()
    if self.bSelected then
        return
    end
    if UIUtils.IsMobileInput() then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
    if UIUtils.IsGamepadInput() then
        self:OnItemClick(true)
    end
end

function M:OnItemUnhovered()
    if self.bSelected then
        return
    end
    if UIUtils.IsMobileInput() then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Unhover)
end

function M:OnItemOnPressed()
    if self.bSelected then
        return
    end
    if UIUtils.IsMobileInput() then
        return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:UnSelect()
    self.bSelected = false
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.bSelected and self.Parent and self.Parent.LastFocusScrollboxIndex == self.ScrollboxIndex then
        return UIUtils.Handle
    end
    if not UIUtils.IsGamepadInput() then
        return UIUtils.Handle
    end
    if self.Parent.LastFocusListItem and IsValid(self.Parent.LastFocusListItem) then
        self.Parent.LastFocusListItem:SetFocus()
    end
    self.Parent.ScrollBox_Recommend:ScrollWidgetIntoView(self, false, UE4.EDescendantScrollDestination.IntoView)
    self:AddDelayFrameFunc(function()
        if not self then return end
        self.Parent.LastFocusScrollboxIndex = self.ScrollboxIndex
        self.Parent.LastFocusListItem = self
        self.Selected = true
        self:SetFocus() 
    end, 1, "DelaySetFocus")

    if self.ScrollboxIndex == 0 then
        self.Parent.ScrollBox_Recommend:SetScrollOffset(0)
    end
    return UIUtils.Handle
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    -- 用于在月卡界面响应手柄操作打开的提示信息栏关闭后将聚焦还给ListItem
    if self.SetListItemCallBack then
        self.SetListItemCallBack(self.Parent, self.BannerId, self)
    end
    if self.OnKeyDownCallBack then
        return self.OnKeyDownCallBack(self.Parent, self.BannerId, MyGeometry, InKeyEvent)
    end
    return UIUtils.UnHandled
end

return M

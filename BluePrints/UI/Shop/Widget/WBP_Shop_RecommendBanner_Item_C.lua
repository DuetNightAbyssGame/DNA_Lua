--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_RecommendBanner_C
local M = Class({"BluePrints.UI.BP_UIState_C", "BluePrints.Common.DelayFrameComponent"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
    self.Btn_Click.OnClicked:Add(self, self.OnItemClick)
    self.Btn_Click.OnHovered:Add(self, self.OnItemHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnItemUnhovered)
    
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if self.CurInputDeviceType == ECommonInputType.Touch then
        self.Btn_Click:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Key_Left:CreateGamepadKey(UIConst.GamePadImgKey.DPadLeft)
    self.Key_Right:CreateGamepadKey(UIConst.GamePadImgKey.DPadRight)

end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Super.Destruct(self)
    self.CurrentIndex = nil
    self:CleanTimer()
    self.ScrollboxIndex = 0
end

function M:InitItemInfo()
    self.bSelected = false
    self.SwitchBannerList = ShopUtils:GetBannerInfo(true)
    if not self.SwitchBannerList or not next(self.SwitchBannerList) then
        return
    end
    
    self.SwitchBannerIndexMap = {}
    self.SwitchBannerBottomProgressMap = {}
    if not self.CurrentIndex then
        self.CurrentIndex = 1
    end
    
    self:SetBannerItemIcon(self.Image_ItemIcon01, self.SwitchBannerList[self.CurrentIndex].BannerIcon)
    self:SetBannerItemIcon(self.Image_ItemIcon02, self.SwitchBannerList[self.CurrentIndex].BannerIcon)

    self:SetItemInfo()
    self.List_Progress:ClearListItems()
    if #self.SwitchBannerList > 1 then
        for index, v in ipairs(self.SwitchBannerList) do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            if index == self.CurrentIndex then
                Content.NeedStartTick = true
            end
            self.SwitchBannerIndexMap[index] = v
            Content.LastTime = v.SwitchTime or 10
            self.List_Progress:AddItem(Content)
            self.SwitchBannerBottomProgressMap[index] = Content
        end
        local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
        if ShopMain then
            if not ShopMain.ShowSwitchBanner then
                self:AddTimer(self.SwitchBannerList[self.CurrentIndex].SwitchTime or 10, function()
                    self:SwitchBannerItem(nil, true, true)
                end, false, 0, "SwitchBannerPage", true)
            end
        end
    end
end

function M:StopBannerTimer()
    self:CleanTimer()
end

function M:StartBannerTimer()
    if not self.SwitchBannerList or not next(self.SwitchBannerList) or not self.CurrentIndex then
        return
    end
    self:AddTimer(self.SwitchBannerList[self.CurrentIndex].SwitchTime or 10, function()
        self:SwitchBannerItem(nil, true, true)
    end, false, 0, "SwitchBannerPage", true)
end

---设置BannerItem的Icon图标
---@param Widget 
---@param IconPath string 图标路径
function M:SetBannerItemIcon(Widget, IconPath)
    local IconDynaMaterial = Widget:GetDynamicMaterial()
    if IconDynaMaterial then
        local Icon = LoadObject(IconPath)
        IconDynaMaterial:SetTextureParameterValue("IconMap", Icon)
    end
end


--------------------------------------------------------------------- 轮播Banner页逻辑 ---------------------------------------------------------------------
--- 切换Banner页
---@param Index int @要跳转的Banner页Index(可为空，为空时根据bRight判断是否自动循环)
---@param bRight boolean @是否向右切换
---@param bNotPlaySound boolean @是否播放音效
function M:SwitchBannerItem(Index, bRight, bNotPlaySound)
    local SwitchBannerLength = #self.SwitchBannerList
    if self.CurrentIndex then
        if self.SwitchBannerBottomProgressMap[self.CurrentIndex] and self.SwitchBannerBottomProgressMap[self.CurrentIndex].SelfWidget then
            self.SwitchBannerBottomProgressMap[self.CurrentIndex].SelfWidget:ResetItem()
        end
    end
    if Index then
        self.CurrentIndex = Index
    else
        if bRight then
            self.CurrentIndex = (self.CurrentIndex) % SwitchBannerLength + 1
        else
            self.CurrentIndex = (self.CurrentIndex - 2 + SwitchBannerLength) % SwitchBannerLength + 1
        end
    end
    self:StopAllAnimations()
    if bRight then
        self:PlayAnimation(self.Change_LToR)
    else
        self:PlayAnimation(self.Change_RToL)
    end

    self:RemoveTimer("SwitchBannerPage")
    local SwitchTime = 10
    if self.SwitchBannerIndexMap[self.CurrentIndex] then
        SwitchTime = self.SwitchBannerIndexMap[self.CurrentIndex].SwitchTime
        if self.Func then
            self.Func(self.Obj, self.SwitchBannerIndexMap[self.CurrentIndex].Id, true, bRight)
        end
    end
    local ShopMain = UIManager(GWorld.GameInstance):GetUIObj("ShopMain")
    if ShopMain then
        if not ShopMain.ShowSwitchBanner then
            self:AddTimer(SwitchTime, function()
                self:SwitchBannerItem(nil, true, true)
            end, false, 0, "SwitchBannerPage", true)
        end
    end
end

function M:SetItemInfo()
    if self.CurrentIndex then
        self.Text_Title:SetText(GText( self.SwitchBannerList[self.CurrentIndex].Text1))
        if self.SwitchBannerList[self.CurrentIndex].MarkText then
            self.Group_Sign:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Text_MoreNum:SetText(GText(self.SwitchBannerList[self.CurrentIndex].MarkText))
        else
            self.Group_Sign:SetVisibility(ESlateVisibility.Hidden)
        end
        self:SetBannerItemIcon(self.Image_ItemIcon01, self.SwitchBannerList[self.CurrentIndex].BannerIcon)
        if self.SwitchBannerBottomProgressMap[self.CurrentIndex] and self.SwitchBannerBottomProgressMap[self.CurrentIndex].SelfWidget then
            self.SwitchBannerBottomProgressMap[self.CurrentIndex].SelfWidget:StartTick()
        end
    end
end

function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Change_LToR or InAnimation == self.Change_RToL then
        if self.CurrentIndex then
            self:SetBannerItemIcon(self.Image_ItemIcon02, self.SwitchBannerList[self.CurrentIndex].BannerIcon)
        end
    end
end

function M:ClearAllTimer()
    self:CleanTimer()
end

--- 绑定拖拽事件
function M:BindBtnEvent(Obj, Func)
    self.Obj = Obj
    self.Func = Func
end

--- 绑定点击事件
function M:BindBtnClickEvent(Obj, Func)
    self.ClickObj = Obj
    self.ClickFunc = Func
end

function M:OnItemClick(bSwitch, bRight)
    if self.bSelected then
        local ShopMain = UIManager(self):GetUIObj("ShopMain")
        if ShopMain and ShopMain.TabType == "Banner" and ShopMain.SelectBannerId and ShopMain.BannerIdMap and type(ShopMain.BannerIdMap) == "table" then
            local CurrentPage = ShopMain.BannerIdMap[ShopMain.SelectBannerId]
            if CurrentPage and CurrentPage.HandlePreviewKeyDown and UIUtils.IsGamepadInput() then
                CurrentPage:HandlePreviewKeyDown(nil, Const.GamepadFaceButtonDown)
            end
        end
        return
    end

    self.bSelected = true
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    if self.ClickObj then
        self.ClickFunc(self.ClickObj, self.SwitchBannerIndexMap[self.CurrentIndex].Id, bSwitch, bRight)
    end
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

function M:UnSelect()
    self.bSelected = false
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
end


function M:OnBtnPressed()
    if UIUtils.IsMobileInput() then
        return
    end
    self:PlayAnimation(self.Press)
    local MousePos = UWidgetLayoutLibrary.GetMousePositionOnPlatform()
    self.PressX = MousePos.X
end

function M:OnBtnReleased()
    if self:IsAnimationPlaying(self.Change_LToR) or self:IsAnimationPlaying(self.Change_RToL) then
        return
    end
    if not self.PressX then
        return
    end
    local MousePos = UWidgetLayoutLibrary.GetMousePositionOnPlatform()
    if MousePos.X > self.PressX then
        self:SwitchBannerItem(nil, false, true)
        AudioManager(self):PlayUISound(self, "event:/ui/common/shop_banner_scroll", nil, nil)
    elseif MousePos.X < self.PressX then
        self:SwitchBannerItem(nil, true, true)
        AudioManager(self):PlayUISound(self, "event:/ui/common/shop_banner_scroll", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/activity/large_btn_click", nil, nil)
    end
end

function M:OnScrollBoxMouseButtonDown(MyGeometry, InTouchEvent)
    local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
    local MousePos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(MyGeometry, ScreenSpacePosition)
    self.PressX = MousePos.X
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end


function M:OnScrollBoxMouseButtonUp(MyGeometry, InTouchEvent)
    if self:IsAnimationPlaying(self.Change_LToR) or self:IsAnimationPlaying(self.Change_RToL) then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    if not self.PressX then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    local ScreenSpacePosition = UE4.UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(InTouchEvent)
    local MousePos = UE4.USlateBlueprintLibrary.AbsoluteToLocal(MyGeometry, ScreenSpacePosition)
    if MousePos.X > self.PressX then
        self:SwitchBannerItem(nil, false, true)
        AudioManager(self):PlayUISound(self, "event:/ui/common/shop_banner_scroll", nil, nil)
    elseif MousePos.X < self.PressX then
        self:SwitchBannerItem(nil, true, true)
        AudioManager(self):PlayUISound(self, "event:/ui/common/shop_banner_scroll", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/activity/large_btn_click", nil, nil)
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
    return self:OnScrollBoxMouseButtonUp(MyGeometry, InTouchEvent)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if not UIUtils.IsGamepadInput() then
        self:OnItemClick(false)
        return UIUtils.Handle
    end
    if self.bSelected then
        return UIUtils.Handle
    end
    self:OnItemClick()
    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    if self.ScrollboxIndex == 0 then
        self:AddDelayFrameFunc(function()
            DebugPrint("lgc@OnFocusReceived", ShopMain.ScrollBox_Recommend:GetScrollOffset())
            if not self or not ShopMain or not ShopMain.ScrollBox_Recommend then return end
            ShopMain.ScrollBox_Recommend:SetScrollOffset(0)
        end, 5, "DelaySetScrollOffset")
    elseif ShopMain and ShopMain.ScrollBox_Recommend then
        ShopMain.ScrollBox_Recommend:ScrollWidgetIntoView(self, true, UE4.EDescendantScrollDestination.IntoView)
    end
    return UIUtils.Handle
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

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    local IsHandled = false
    local ShopMain = UIManager(self):GetUIObj("ShopMain")
    if ShopMain and ShopMain.TabType == "Banner" and ShopMain.SelectBannerId and ShopMain.BannerIdMap and type(ShopMain.BannerIdMap) == "table" then
        local CurrentPage = ShopMain.BannerIdMap[ShopMain.SelectBannerId]
        if CurrentPage and CurrentPage.HandleRepeatKeyDown and not IsHandled then
            IsHandled = CurrentPage:HandleRepeatKeyDown(InKey, InKeyName)
        end
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M

--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_ShowItem_Base_C
local M = Class({"BluePrints.UI.BP_EMUserWidgetUtils_C", "BluePrints.UI.BP_EMUserWidget_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self:AddInputMethodChangedListen()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:Init(Content)
    self:OnListItemObjectSet(Content)
end

function M:OnListItemObjectSet(Content)
    Content.Entry = self
    self.Content = Content
    self:InitData(Content)
    self.Item:Init(self)
    self:InitCompView()
end

---@field Id number                                         @武器/角色Id
---@field Name string                                       @名称
---@field ItemIcon string                                   @ItemIcon路径
---@field TypeIcon string                                   @TypeIcon路径
---@field Type string                                       @类型，目前支持"Character"和"Weapon"
---@field Rarity number                                     @稀有度
---@field IsLock boolean                                    @是否上锁
---@field IsEmpty boolean                                   @是否是空态
---@field EnhanceLevel number                               @突破等级
---@field GradeLevel number                                 @溯源/熔炼等级
---@field NotInteractive boolean                            @是否不能交互
---@field bPlayInAnim boolean                               @是否播放In动画
---@field OnClickCheckBtnEvent table                        @查看详情 事件回调方法 {Obj = , Callback = , Params =}

---@field IsNew boolean                                     @是否有New标识
---@field IsSelect boolean                                  @是否被选中

---@field OnMouseEnterEvent table
---@field OnMouseLeaveEvent table
---@field OnMouseButtonDownEvent table
---@field OnMouseButtonUpEvent table                        @点击事件回调方法 {Obj = , Callback = , Params =}
---@field OnFocusReceivedEvent table
---@field OnAddedToFocusPathEvent table
---@field OnRemovedFromFocusPathEvent table
function M:InitData(Content)
    self.Id = Content.Id
    self.Name = Content.Name
    self.ItemIcon = Content.ItemIcon
    self.TypeIcon = Content.TypeIcon
    self.Type = Content.Type
    self.Rarity = Content.Rarity
    self.IsLock = Content.IsLock
    self.EnhanceLevel = Content.EnhanceLevel
    self.GradeLevel = Content.GradeLevel
    self.NotInteractive = Content.NotInteractive
    self.bPlayInAnim = Content.bPlayInAnim
    self.OnClickCheckBtnEvent = Content.OnClickCheckBtnEvent

    self.OnMouseEnterEvent = Content.OnMouseEnterEvent
    self.OnMouseLeaveEvent = Content.OnMouseLeaveEvent
    self.OnMouseButtonDownEvent = Content.OnMouseButtonDownEvent
    self.OnMouseButtonUpEvent = Content.OnMouseButtonUpEvent
    self.OnFocusReceivedEvent = Content.OnFocusReceivedEvent
    self.OnAddedToFocusPathEvent = Content.OnAddedToFocusPathEvent
    self.OnRemovedFromFocusPathEvent = Content.OnRemovedFromFocusPathEvent
end

function M:InitCompView()
    self:InitCommonView()
end

function M:InitCommonView()
    self.Item:InitCommonView()
    --- 播放动画
    if self.bPlayInAnim then
        self:PlayInAnimation()
    end
end

function M:SetSelected(IsSelect)
    if self.NotInteractive then
        return
    end
    self.Content.IsSelect = IsSelect
    self.Item.Item:StopAllAnimations()
    if IsSelect then
        self.Item.Item:PlayAnimation(self.Item.Item.Click)
        self.Item:PlayAttributeWidgeClick()
    else
        self.Item.Item:PlayAnimation(self.Item.Item.Normal)
        self.Item:PlayAttributeWidgetNormal()
    end
end

function M:SetNew(IsNew)
    self.Content.IsNew = IsNew
    self.Item:SetNew(IsNew)
end

function M:SetCheckBtnKeyTipVisible(IsVisible)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.Item:SetCheckBtnKeyTipVisible(IsVisible)
    end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or self.NotInteractive or self.Content.IsSelect or self:IsInAnimationPlaying() then
        return 
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/hover_btn_pic_large", nil, nil)
    if self.OnMouseEnterEvent and self.OnMouseEnterEvent.Callback then
        if self.OnMouseEnterEvent.Params then
            self.OnMouseEnterEvent.Callback(self.OnMouseEnterEvent.Obj, table.unpack(self.OnMouseEnterEvent.Params))
        else
            self.OnMouseEnterEvent.Callback(self.OnMouseEnterEvent.Obj)
        end
    end
    self.Item.Item:StopAllAnimations()
    self.Item.Item:PlayAnimation(self.Item.Item.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        return
    end
    if not self.Content or  self.NotInteractive or self.Content.IsSelect or self:IsInAnimationPlaying() then
        return
    end
    if self.OnMouseLeaveEvent and self.OnMouseLeaveEvent.Callback then
        if self.OnMouseLeaveEvent.Params then
            self.OnMouseLeaveEvent.Callback(self.OnMouseLeaveEvent.Obj, table.unpack(self.OnMouseLeaveEvent.Params))
        else
            self.OnMouseLeaveEvent.Callback(self.OnMouseLeaveEvent.Obj)
        end
    end
    self.bMouseButtonDown = false
    self.Item.Item:StopAllAnimations()
    self.Item.Item:PlayAnimation(self.Item.Item.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
    if self.HandleMouseDown then
        return UWidgetBlueprintLibrary.Handled()
    end
    if self.NotInteractive or self:IsInAnimationPlaying() then
        return UWidgetBlueprintLibrary.UnHandled()
    end
    -- self:StopAllAnimations()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Item.Item:PlayAnimation(self.Item.Item.Press)
    end
    if self.OnMouseButtonDownEvent and self.OnMouseButtonDownEvent.Callback then
        if self.OnMouseButtonDownEvent.Params then
            self.OnMouseButtonDownEvent.Callback(self.OnMouseButtonDownEvent.Obj, table.unpack(self.OnMouseButtonDownEvent.Params))
        else
            self.OnMouseButtonDownEvent.Callback(self.OnMouseButtonDownEvent.Obj)
        end
    end
    self.bMouseButtonDown = true
    return UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    if self.NotInteractive or self:IsInAnimationPlaying() or not self.bMouseButtonDown then
        return UWidgetBlueprintLibrary.Unhandled()
    end
    self.bMouseButtonDown = false
    if self.Type == "Character" then
        AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_role", nil, nil)
    elseif self.Type == "Weapon" then
        AudioManager(self):PlayUISound(self, "event:/ui/armory/click_select_weapon", nil, nil)
    end
    self.Item.Item:PlayAnimation(self.Item.Item.Click)
    if self.OnMouseButtonUpEvent and self.OnMouseButtonUpEvent.Callback then
        if self.OnMouseButtonUpEvent.Params then
            self.OnMouseButtonUpEvent.Callback(self.OnMouseButtonUpEvent.Obj, table.unpack(self.OnMouseButtonUpEvent.Params))
        else
            self.OnMouseButtonUpEvent.Callback(self.OnMouseButtonUpEvent.Obj)
        end
    end
    return UWidgetBlueprintLibrary.Handled()
end

function M:OnTouchEnded(MyGeometry, TouchEvent)
    return self:OnMouseButtonUp(MyGeometry, TouchEvent)
end

function M:OnTouchStarted(MyGeometry, TouchEvent)
    return self:OnMouseButtonDown(MyGeometry, TouchEvent)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.OnFocusReceivedEvent then 
        local Obj = self.OnFocusReceivedEvent.Obj
        local Callback = self.OnFocusReceivedEvent.Callback
        local Params = self.OnFocusReceivedEvent.Params
        if Params then
            Callback(Obj, table.unpack(Params))
        else
            Callback(Obj)
        end
    end
    return UIUtils.Handled
end

function M:OnAddedToFocusPath(InFocusEvent)
    if(self.OnAddedToFocusPathEvent)then
        local Obj = self.OnAddedToFocusPathEvent.Obj
        local Callback = self.OnAddedToFocusPathEvent.Callback
        local Params = self.OnAddedToFocusPathEvent.Params
        if Params then
            Callback(Obj, table.unpack(Params))
        else
            Callback(Obj)
        end
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    if(self.OnRemovedFromFocusPathEvent)then
        local Obj = self.OnRemovedFromFocusPathEvent.Obj
        local Callback = self.OnRemovedFromFocusPathEvent.Callback
        local Params = self.OnRemovedFromFocusPathEvent.Params
        if Params then
            Callback(Obj, table.unpack(Params))
        else
            Callback(Obj)
        end
    end
end

--- 播放加载动画In
function M:PlayInAnimation()
end

--- 是否正在播放In动画
function M:IsInAnimationPlaying()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if self.OnClickCheckBtnEvent and self.OnClickCheckBtnEvent.KeyName == InKeyName then
            IsEventHandled = true
            if self.OnClickCheckBtnEvent.Params then
                self.OnClickCheckBtnEvent.Callback(self.OnClickCheckBtnEvent.Obj, table.unpack(self.OnClickCheckBtnEvent.Params))
            else
                self.OnClickCheckBtnEvent.Callback(self.OnClickCheckBtnEvent.Obj)
            end
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
    M.Super.RefreshOpInfoByInputDevice(self, CurInputType, CurGamepadName)
    self.Item:OnParentRefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
end

return M

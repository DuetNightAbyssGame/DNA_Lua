--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
---@type WBP_Com_Tab_Node_ResourceBar_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.ResourceBarWidget = {}
    self.bIsFocusable = true
    self.bHasFocusedDescendants = false
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self:GetOwningPlayer())
    if (IsValid(self.GameInputModeSubsystem)) then
        self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    -- 清理所有气泡定时器
    if self.BubbleTimers then
        for TimerId, _ in pairs(self.BubbleTimers) do
            if self:IsExistTimer(TimerId) then
                self:RemoveTimer(TimerId)
            end
        end
        self.BubbleTimers = nil
    end
    
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnUpdateUIStyleByInputTypeChange)
    end
end

function M:InitResourceBar(Info,bShowBubble)
    self.Info = Info
    if (Info ~= nil) then
        self:ClearChildren()
        for i, v in ipairs(Info) do
            if type(v) == "table" and v.Type == "Walnut" then
                local WalnutId = v.WalnutId
                local ResourceBarWidget = self.ResourceBarWidget[WalnutId]
                if (not IsValid(ResourceBarWidget)) then
                    ResourceBarWidget = UIManager(self):_CreateWidgetNew("ResourceBar")
                    ResourceBarWidget:BindNavigationEvents(self,{OnNavigationToBoundary = self.OnResourceNavigationToBoundary,
                                                                OnAddedToFocusPath = self.OnResourceAddedToFocusPath})
                    ResourceBarWidget:BindEventOnMenuOpenChanged(self, self.OnMenuOpenChanged)
                    self.ResourceBarWidget[WalnutId] = ResourceBarWidget
                end
                local WalnutIcon = LoadObject(DataMgr.Walnut[WalnutId].Icon)
                ResourceBarWidget.Common_Item_Icon:Init({
                    UIName = "BagMain",
                    IsShowDetails = true,
                    IsCantItemSelection = true,
                    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
                    Id = WalnutId,
                    Icon = WalnutIcon,
                    ItemType = "Walnut",
                    HandleMouseDown = true,
                })
                ResourceBarWidget:SetItemId(WalnutId, "Walnut")
                -- ResourceBarWidget:PlayInAnim()
                self.Panel_ResourceBar:AddChild(ResourceBarWidget)

                -- 检查是否为限时资源，如果是则显示气泡提示
                if bShowBubble then
                    self:CheckAndShowLimitedResourceBubble(WalnutId, ResourceBarWidget)
                end
            else
                local CoinId
                if type(v) == "table" and v.Type == "Resource" then
                    CoinId = v.CoinId
                else
                    CoinId = v
                end
                local ResourceBarWidget = self.ResourceBarWidget[CoinId]
                if (not IsValid(ResourceBarWidget)) then
                    ResourceBarWidget = UIManager(self):_CreateWidgetNew("ResourceBar")
                    ResourceBarWidget:BindNavigationEvents(self,{OnNavigationToBoundary = self.OnResourceNavigationToBoundary,
                                                                OnAddedToFocusPath = self.OnResourceAddedToFocusPath})
                    ResourceBarWidget:BindEventOnMenuOpenChanged(self, self.OnMenuOpenChanged)
                    self.ResourceBarWidget[CoinId] = ResourceBarWidget
                end
                local CoinIcon = LoadObject(DataMgr.Resource[CoinId].Icon)
                ResourceBarWidget.Common_Item_Icon:Init({
                    UIName = "BagMain",
                    IsShowDetails = true,
                    IsCantItemSelection = true,
                    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
                    Id = CoinId,
                    Icon = CoinIcon,
                    ItemType = "Resource",
                    HandleMouseDown = true,
                })
                ResourceBarWidget:SetItemId(CoinId, "Resource")
                -- ResourceBarWidget:PlayInAnim()
                self.Panel_ResourceBar:AddChild(ResourceBarWidget)
                
                -- 检查是否为限时资源，如果是则显示气泡提示
                if bShowBubble then
                    self:CheckAndShowLimitedResourceBubble(CoinId, ResourceBarWidget)
                end
            end
        end
        self.Panel_ResourceBar:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Panel_ResourceBar:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:RefreshGamePadKey()
end

--- 检查并显示限时资源气泡提示
---@param ResourceId number 资源ID
---@param ResourceBarWidget table 资源栏控件
function M:CheckAndShowLimitedResourceBubble(ResourceId, ResourceBarWidget)
    local ResourceInfo = DataMgr.Resource[ResourceId]
    local LimitedInfo = ItemUtils.GetItemLimitedInfo(ResourceId)
    if ResourceInfo and LimitedInfo then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local Count = Avatar:GetResourceNum(ResourceId)
            -- local Count = 10
            if Count > 0 then
                -- 这是一个有库存的限时资源，显示气泡提示
                local NowTime = TimeUtils.NowTime()
                if LimitedInfo.EndTime then
                    local TimeDiff = LimitedInfo.EndTime - NowTime
                    -- local TimeDiff = 180000
                    if TimeDiff > 0 and TimeDiff < CommonConst.SECOND_IN_DAY then
                        -- 剩余时间小于1天，显示红色气泡
                        local ConfigData = {
                            -- IconPath = ResourceInfo.Icon, -- TAB中不显示资源图标
                            Text = GText("UI_GachaTicket_Bubble"), -- 气泡文本
                            ColorType = 2,
                            Arrow = 1,
                        }
                        ResourceBarWidget:ShowBubble(ConfigData)
                        self:HideLimitedResourceBubbleAfterDelay(ResourceBarWidget, 3.0)
                    elseif TimeDiff >= CommonConst.SECOND_IN_DAY and TimeDiff < CommonConst.SECOND_IN_WEEKDAY then
                        -- 剩余时间1天到1周，显示橙色气泡
                        local ConfigData = {
                            -- IconPath = ResourceInfo.Icon,
                            Text = GText("UI_GachaTicket_Bubble"),
                            ColorType = 1,
                            Arrow = 1,
                        }
                        ResourceBarWidget:ShowBubble(ConfigData)
                        self:HideLimitedResourceBubbleAfterDelay(ResourceBarWidget, 3.0)
                    end
                end
            end
        end
    end
end

--- 延迟隐藏限时资源气泡
---@param ResourceBarWidget table 资源栏控件
---@param DelayTime number 延迟时间（秒）
function M:HideLimitedResourceBubbleAfterDelay(ResourceBarWidget, DelayTime)
    if not self.BubbleTimers then
        self.BubbleTimers = {}
    end
    
    -- 生成唯一的定时器ID
    local TimerId = "LimitedResourceBubble_" .. tostring(ResourceBarWidget.Id)
    
    -- 如果已有相同的定时器，先移除
    if self:IsExistTimer(TimerId) then
        self:RemoveTimer(TimerId)
    end
    
    -- 添加新的定时器
    local HideBubbleFunc = function()
        if IsValid(ResourceBarWidget) then
            ResourceBarWidget:HideBubble()
        end
        if self:IsExistTimer(TimerId) then
            self:RemoveTimer(TimerId)
        end
        if self.BubbleTimers then
            self.BubbleTimers[TimerId] = nil
        end
    end
    
    self:AddTimer(DelayTime, HideBubbleFunc, false, 0.1, TimerId, true)
    self.BubbleTimers[TimerId] = true
end

-- --- 显示资源栏气泡提示
-- ---@param ResourceId number 代币资源Id
-- ---@param ConfigData table 气泡配置数据 {IconPath = "图标路径", Text = "提示文本", TextColor = "文本颜色"}
-- function M:ShowResourceBubble(ResourceId, ConfigData)
--     if self.ResourceBarWidget[ResourceId] then
--         self.ResourceBarWidget[ResourceId]:ShowBubble(ConfigData)
--     else
--         ScreenPrint("无效资源Id:"..ResourceId or "nil")
--     end
-- end

-- --- 隐藏资源栏气泡提示
-- ---@param ResourceId number 代币资源Id
-- function M:HideResourceBubble(ResourceId)
--     if self.ResourceBarWidget[ResourceId] then
--         self.ResourceBarWidget[ResourceId]:HideBubble()
--     end
-- end

--- 通过ResourceId设置通用代币栏加号的隐藏恢复
---@param ResourceId 代币资源Id
---@param bIsVisible 是否显示加号 默认取消显示
function M:SetResourceBarVisibility(ResourceId,bIsVisible)
     if  self.ResourceBarWidget[ResourceId] then
     self.ResourceBarWidget[ResourceId]:SetAddVisibilty(bIsVisible)
     else
        ScreenPrint("无效资源Id:"..ResourceId or "nil" )
     end
end
--- 通过位置设置通用代币栏加号的隐藏恢复
---@param Index 位置索引 从1开始
---@param bIsVisible any 是否显示加号 默认取消显示
function M:SetResourceBarVisibilityByIndex(Index,bIsVisible)
  -- 通过面板子控件顺序直接访问
  local widget = self.Panel_ResourceBar:GetChildAt(Index-1)
  if IsValid(widget) then
      widget:SetAddVisibilty(bIsVisible)
  else
    ScreenPrint("无效资源索引:"..Index or nil .."索引从左到右1开始，如果有隐藏的tab也算上" )
  end
end
function M:FocusToResource()
    if(self.Panel_ResourceBar:HasAnyChildren())then
        self:SetFocus()
    end
end

function M:HideGamePadKey(bHide)
    if(not bHide and next(self.ResourceBarWidget))then
        self.KeyImg_GamePad:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.KeyImg_GamePad:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:CreateCommonKey(...)
    self.KeyImg_GamePad:CreateCommonKey(...)
end

function M:SetGamePadKeyImgByPath(Path)
    local Img = LoadObject(Path)
    self.KeyImg_GamePad.Img:SetBrushFromTexture(Img)
end

function M:InitGamePadTip(Params)
    if (Params.bNeedLongPressInfo) then
        Params.KeyInfo.bLongPress = true
        self.Tip_GamePad:CreateCommonKey(Params.KeyInfo)
        self.Tip_GamePad:AddExecuteLogic(Params.ClickFuncObj, Params.ClickFunc)
    else
        self.Tip_GamePad:CreateCommonKey(Params.KeyInfo)
    end
    self.Tip_PC.Button_Area.OnClicked:Clear()
    self.Tip_PC.Button_Area.OnClicked:Add(Params.ClickFuncObj, Params.ClickFunc)
end

function M:HideTip(bHide)
    if(bHide)then
        self.Panel_Tip:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Panel_Tip:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

function M:OnGamePadTipPressed()
    self.Tip_GamePad:OnButtonPressed()
end

function M:OnGamePadTipReleased()
    self.Tip_GamePad:OnButtonReleased()
end

function M:SwitchTipStyle(Index)
    self.Panel_Tip:SetActiveWidgetIndex(Index)
end

function M:GetCurrentResourceIndex()
    if(self.CurrentResourceWidget)then
        return self.Panel_ResourceBar:GetChildIndex(self.CurrentResourceWidget)
    end
    return -1
end

function M:ClearChildren()
    self.Panel_ResourceBar:ClearChildren()
    self.ResourceBarWidget = {}
end

function M:UpdateResource()
    for k, v in pairs(self.ResourceBarWidget) do
        if (IsValid(v)) then
            v:RefreshItemInfo()
        end
    end
end

function M:OnPropSetResources(ResourceId, OldValue)
    if (self.ResourceBarWidget and self.ResourceBarWidget[ResourceId]) then
        self.ResourceBarWidget[ResourceId]:RefreshItemInfo()
    end
end

function M:BindEvents(Obj,Events)
    Events = Events or {}
    self.Obj = Obj
    self.Event_OnAddedToFocusPath = Events.OnAddedToFocusPath
    self.Event_OnRemovedFromFocusPath = Events.OnRemovedFromFocusPath
    self.Event_OnMenuOpenChanged = Events.OnMenuOpenChanged
end

function M:OnMenuOpenChanged(bIsOpen)
    if(self.Event_OnMenuOpenChanged)then
        self.Event_OnMenuOpenChanged(self.Obj, bIsOpen)
    end
end

--#region 手柄相关

-- function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
--     self.CurInputDeviceType = CurInputDevice
--     self:RefreshGamePadKey()
-- end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    self.CurInputDeviceType = CurInputType
    self:RefreshGamePadKey()
end

function M:RefreshGamePadKey()
    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        if(self.bHasFocusedDescendants and self.Panel_ResourceBar:IsVisible())then
            self:HideGamePadKey(true)
        else
            self:HideGamePadKey(false)
        end
    else
        self:HideGamePadKey(true)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local WidgetToFocus = nil
    if (InKeyName == "Gamepad_LeftShoulder") then
        WidgetToFocus = self:ClickToLeftOnGamePad()
    elseif (InKeyName == "Gamepad_RightShoulder") then
        WidgetToFocus = self:ClickToRightOnGamePad()
    elseif(InKeyName == "Gamepad_FaceButton_Right") then
        if(self.GetReplyOnBack)then
            local Reply = self.GetReplyOnBack()
            if(Reply)then
                return Reply
            end
        end
        WidgetToFocus = self.LastFocusWidget or self:GetParent()
    end
    if(WidgetToFocus)then
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),WidgetToFocus)
    end
    return UIUtils.Unhandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    local ResourceWidget = self.Panel_ResourceBar:GetChildAt(0)
    if(ResourceWidget)then
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),ResourceWidget)
    end
    return UIUtils.Unhandled
end

function M:OnResourceNavigationToBoundary(NavigationDirection)
    if(NavigationDirection == EUINavigation.Left)then
        return self:ClickToLeftOnGamePad()
    elseif(NavigationDirection == EUINavigation.Right)then
        return self:ClickToRightOnGamePad()
    end
    return nil
end

function M:OnResourceAddedToFocusPath(ResourceWidget)
    if(self.NeedOpenMenuWhenResoureFocused and ResourceWidget)then
        ResourceWidget.Common_Item_Icon:OnMouseButtonDown()
        ResourceWidget.Common_Item_Icon:OnMouseButtonUp()
    end
    self.CurrentResourceWidget = ResourceWidget
    self.NeedOpenMenuWhenResoureFocused = false
end

function M:OnAddedToFocusPath(InFocusEvent)
    self.bHasFocusedDescendants = true
    self:RefreshGamePadKey()
    if(self.Event_OnAddedToFocusPath)then
        self.Event_OnAddedToFocusPath(self.Obj,self)
    end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
    self.bHasFocusedDescendants = false
    self:RefreshGamePadKey()
    if(self.Event_OnRemovedFromFocusPath)then
        self.Event_OnRemovedFromFocusPath(self.Obj,self)
    end
end

function M:IsHasFocusedDescendants()
    return self.bHasFocusedDescendants
end

function M:ClickToLeftOnGamePad()
    local FocusWidget = nil
    local CurrentResourceIdx = self:GetCurrentResourceIndex()
    if (CurrentResourceIdx - 1 >= 0) then
        local CurSelectChild = self.Panel_ResourceBar:GetChildAt(CurrentResourceIdx)
        local NextSelectChild = self.Panel_ResourceBar:GetChildAt(CurrentResourceIdx-1)
        if (NextSelectChild ~= nil) then
            --NextSelectChild.Common_Item_Icon:OnMouseEnter()
            if (CurSelectChild and CurSelectChild:IsMenuOpened()) then
                self.NeedOpenMenuWhenResoureFocused = true
            end
            FocusWidget = NextSelectChild
        end
        if (CurSelectChild ~= nil) then
            CurSelectChild.Common_Item_Icon:OnCloseMenuAnchor(true)
        end
    end
    return FocusWidget
end

function M:ClickToRightOnGamePad()
    self.NeedOpenMenuWhenResoureFocused = false
    local FocusWidget = nil
    local CurrentResourceIdx = self:GetCurrentResourceIndex()
    if (CurrentResourceIdx + 1 < self.Panel_ResourceBar:GetChildrenCount()) then
        local CurSelectChild = self.Panel_ResourceBar:GetChildAt(CurrentResourceIdx)
        local NextSelectChild = self.Panel_ResourceBar:GetChildAt(CurrentResourceIdx + 1)
        if (NextSelectChild ~= nil) then
            --NextSelectChild.Common_Item_Icon:OnMouseEnter()
            if (CurSelectChild and CurSelectChild:IsMenuOpened()) then
                self.NeedOpenMenuWhenResoureFocused = true
            end
            FocusWidget = NextSelectChild
        end
        if (CurSelectChild ~= nil) then
            CurSelectChild.Common_Item_Icon:OnCloseMenuAnchor(true)
        end
    end
    return FocusWidget
end

-- 设置从资源栏返回之后，光标应该移动到哪个控件
function M:SetLastFocusWidget(Widget)
    self.LastFocusWidget = Widget
end

-- 设置从资源栏返回时用于获取事件回复的函数
function M:SetGetReplyOnBack(GetReplyOnBack)
    self.GetReplyOnBack = GetReplyOnBack
end

--#endregion 手柄相关

return M

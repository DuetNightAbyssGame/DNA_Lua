--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR zhangdongxu
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Shop_Tab_C
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.SoundFunc = self.PlayClickSound
    self.SoundFuncReceiver = self
end

function M:Init(ConfigData)
    self.CurrentTab = nil
    -- ConfigData({
    --     PlatformName = "PC", 平台类型 (PC、Mobile、GamePad)
    --     LeftKey = "Q",    左快捷键（不传PC默认显示Q，期望不显示则传NotShow）
    --     RightKey = "E",   右快捷键（不传PC默认显示E，期望不显示则传NotShow）
    --     ChildWidgetName = "" Item名称，配置在WidgetUI之中（不填则用默认的TabSubTextItem）
    --     ChildWidgetBPPath = "/Game/UI/WBP/Activity/Widget/WBP_Activity_TabSubItem.WBP_Activity_TabSubItem", Item蓝图路径，如果填了的话（对没有填在WidgetUI之中的Item使用）
    --     Tabs = {
    --             Text = "任务"   Tab文本
    --             TabId = 1, Tab的Id
    --             ShowRedDot = 1/true, 显示红点,
    --             IsNew = 1, 显示新图标,
    --             ShowRedDotNum = 10, 显示数量红点
    --             RedDotTreeName = "Portrait", 红点树名称（需要填在ReddotNode的才生效，否则需要在外部进行监听）
    --             IsLocked = false, 是否此Tab仍处于锁定状态（true为锁定）
    --             LockReasonText = GText("UI_RegionMap_MaxMark"), 未解锁点击提示文本
    --     },
    --     SoundFunc = function,       音效播放
    --     SoundFuncReceiver = Obj,    音效播放接收对象
    -- })
    -- 初始化设置Tab信息
    self.ConfigData = ConfigData
    self.ChildWidgetName = ConfigData.ChildWidgetName
    self.ChildWidgetBPPath = ConfigData.ChildWidgetBPPath
    -- 初始化音效播放函数
    self.SoundFunc = ConfigData.SoundFunc or self.PlayClickSound
    self.SoundFuncReceiver = ConfigData.SoundFuncReceiver or self
    -- 平台
    self.DeviceTypeByPlatformName = ConfigData.PlatformName or CommonUtils.GetDeviceTypeByPlatformName(self)

    if (self.DeviceTypeByPlatformName == CommonConst.CLIENT_DEVICE_TYPE.MOBILE or ConfigData.LeftKey == "NotShow") then
        self.Key_Left:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    if (self.DeviceTypeByPlatformName == CommonConst.CLIENT_DEVICE_TYPE.MOBILE or ConfigData.LeftKey == "NotShow") then
        self.Key_Right:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    self:UpdateTabs(self.ConfigData.Tabs or {})
    -- 设置基本内容信息
    self:RefreshBaseInfo()
end

function M:UpdateTabs(Tabs)
    -- 若后续二级Tab需要排序可以将这段逻辑打开
    -- local SortFunc = function(ComPareA, ComPareB)
    --     local IsALocked = ComPareA.IsLocked or false
    --     local IsBLocked = ComPareB.IsLocked or false

    --     if (IsALocked == IsBLocked) then 
    --         local SortA = ComPareA.SortId
    --         local SortB = ComPareB.SortId
    --         if (SortA ~= nil and SortB ~= nil) then
    --             return SortA > SortB 
    --         else
    --             local TabIdA = ComPareA.TabId or 1
    --             local TabIdB = ComPareB.TabId or 1
    --             return TabIdA < TabIdB 
    --         end
    --     else
    --         return not IsALocked
    --     end
    -- end
    -- table.sort(Tabs, SortFunc)

    self.Tabs = Tabs
    self.List_Tab:ClearChildren()
    for i = 1, #Tabs do
        local Child = nil
        if (self.ChildWidgetBPPath) then
            Child = UIManager(self):CreateWidget(self.ChildWidgetBPPath)
        else
            Child = UIManager(self):_CreateWidgetNew(self.ChildWidgetName or "TabSubTextItem")
        end
        self.List_Tab:AddChild(Child)
        if (self.bUserTabItemSize and type(Child.SetFitSize) == "function") then
            Child:SetFitSize(self.TabItem_Size)
        else
            local SizeStruct = FSlateChildSize()
            SizeStruct.Value = 1.0
            Child.Slot:SetSize(SizeStruct)
        end
        Child:Update(i, Tabs[i], self.DeviceTypeByPlatformName)
        Child:BindEventOnSwitchOn(self, self.OnTabSwitchOn)
        Child:BindSoundFunc(self.SoundFunc,self.SoundFuncReceiver)
    end
    -- if (self.DeviceTypeByPlatformName == CommonConst.CLIENT_DEVICE_TYPE.PC) then
    --     if (#Tabs <= 1) then
    --         self.Key_Left:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    --         self.Key_Right:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    --     else
    --         self.Key_Left:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    --         self.Key_Right:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    --     end
    -- end

    -- 交互需求，只有一个Item的时候，不显示Tab栏
    if (#Tabs <= 1) then
        self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        if (self.DeviceTypeByPlatformName == CommonConst.CLIENT_DEVICE_TYPE.PC) then
            self.Key_Left:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            self.Key_Right:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"]) 
    end
end

function M:RefreshBaseInfo()
    -- 刷新设备热键信息
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    self.CurInputDeviceType = CurInputDevice
    if (self.DeviceTypeByPlatformName == CommonConst.CLIENT_DEVICE_TYPE.MOBILE) then
        -- 手机模式下，不显示左右按键
        self.Key_Left:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_Right:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self:UpdateUIStyleInPlatform(self.CurInputDeviceType == ECommonInputType.Gamepad)
        self:UpdateHotKeyInfo(CurGamepadName)
    end
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
    if (IsUseGamePad) then
        self:CreateHotKeyAndAddToParent(self.Key_Left, "Img", "LB")
        self:CreateHotKeyAndAddToParent(self.Key_Right, "Img", "RB")
    else
        self:CreateHotKeyAndAddToParent(self.Key_Left, "Text", self.ConfigData.LeftKey or "A")
        self:CreateHotKeyAndAddToParent(self.Key_Right, "Text", self.ConfigData.RightKey or "D")
    end

    if (self.CurInputDeviceType == ECommonInputType.Gamepad and not IsUseGamePad) then
        -- 手柄模式下或者特殊情况下，需要隐藏左右按键
        self.Key_Left:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Key_Right:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Key_Left:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Key_Right:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

function M:UpdateHotKeyInfo(CurGamepadName)
end

function M:CreateHotKeyAndAddToParent(PanelWidget, KeyType, KeyContent)
    PanelWidget:ClearChildren()
    local HotKeyWidget = nil
    if (KeyType == "Img") then
        HotKeyWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Key/WBP_Com_KeyImg.WBP_Com_KeyImg', false)
    else
        HotKeyWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Key/WBP_Com_KeyText.WBP_Com_KeyText', false)
        HotKeyWidget.IsButton = false
    end
    if (HotKeyWidget ~= nil) then
        if (KeyType == "Img") then
            HotKeyWidget:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Img",
                        ImgShortPath = KeyContent,
                    }
                }
            }) 
        else
            HotKeyWidget:CreateCommonKey({
                KeyInfoList={
                    {
                        Type = "Text",
                        Text = KeyContent
                    }
                },
            })
            -- HotKeyWidget:AddExecuteLogic(self, self.TabToLeft)
        end
    end
    PanelWidget:AddChildToOverlay(HotKeyWidget)
end

function M:OnTabSwitchOn(TabWidget)
    if(TabWidget and self.Tabs[TabWidget.Idx])then
        if(self.CurrentTab and TabWidget.Idx ~= self.CurrentTab) then
            local PrevTabWidget = self.List_Tab:GetChildAt(self.CurrentTab - 1)
            if PrevTabWidget then 
                PrevTabWidget:SetSwitchOn(false)
            end
            -- self.List_Tab:GetChildAt(self.CurrentTab - 1):SetSwitchOn(false)
        end
        self.CurrentTab = TabWidget.Idx
    end
    if(self.EventTabSelected)then
        self.EventTabSelected(self.ObjTabSelected, TabWidget)
    end
end

function M:BindEventOnTabSelected(Obj,Event)
    self.ObjTabSelected = Obj
    self.EventTabSelected = Event
end

function M:SelectTab(Idx)
    if self.Tabs[Idx] then
        self.List_Tab:GetChildAt(math.max(Idx - 1, 0)):SetSwitchOn(true)
    end
end

function M:GetCurrentTabIndex()
    return self.CurrentTab
end

function M:TabToLeft()
    if(self.CurrentTab and self.CurrentTab - 1 >= 1 )then
        -- UIUtils.PlayCommonBtnSe(self)
        self.SoundFunc(self.SoundFuncReceiver,self.CurrentTab - 1)
        self.List_Tab:GetChildAt(self.CurrentTab - 2):SetSwitchOn(true, true)
    end
end

function M:TabToRight()
    if(self.CurrentTab and self.CurrentTab + 1 <= #self.Tabs)then
        -- UIUtils.PlayCommonBtnSe(self)
        self.SoundFunc(self.SoundFuncReceiver,self.CurrentTab + 1)
        self.List_Tab:GetChildAt(self.CurrentTab):SetSwitchOn(true, true)
    end
end

function M:UnLockTabByIndex(bUnLock, TabIndex)
    local AllItemCount = self.List_Tab:GetChildrenCount()
    if (TabIndex ~= nil) then
        for i = 1, AllItemCount, 1 do
            local Child = self.List_Tab:GetChildAt(i - 1)
            if (TabIndex == Child.Idx) then
                Child:SetLockInfo(bUnLock)
                break 
            end
        end
    else
        for i = 1, AllItemCount, 1 do
            local Child = self.List_Tab:GetChildAt(i - 1)
            Child:SetLockInfo(bUnLock)
        end 
    end
end

function M:UpdateReddots()
    for _, Tab in pairs(self.Tabs) do
        if(IsValid(Tab.UI) and Tab.UI.SetReddot)then
            Tab.UI:SetReddot(Tab.Upgradeable,Tab.OtherReddot)
        end
    end
end

function M:ShowTabRedDot(Idx, IsNew,Upgradeable,OhterReddot)
    if self.Tabs[Idx] then 
        local TabWidget = self.List_Tab:GetChildAt(math.max(Idx - 1, 0))
        TabWidget:SetReddot(IsNew,Upgradeable,OhterReddot)
    end
end

function M:ShowTabRedDotByTabId(TabId, IsNew, Upgradeable, OhterReddot)
    local AllItemCount = self.List_Tab:GetChildrenCount()
    for i = 1, AllItemCount, 1 do
        local TabWidget = self.List_Tab:GetChildAt(i - 1)
        if (TabId == TabWidget:GetTabId()) then
            TabWidget:SetReddot(IsNew,Upgradeable,OhterReddot)
            break 
        end
    end
end

function M:PlayClickSound()

    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end


-----------------------------------------------输入事件相关------------------------------------------------
-- function M:Handle_MouseEventOnPC(MyGeometry, MouseEvent, InMouseOpName)
--     if (InMouseOpName == "MouseMove") then
--         local CurMousePosition = UKismetInputLibrary.PointerEvent_GetScreenSpacePosition(MouseEvent)
--         local LastMousePosition = UKismetInputLibrary.PointerEvent_GetLastScreenSpacePosition(MouseEvent)
--         if ((math.abs(CurMousePosition.X - LastMousePosition.X) + math.abs(CurMousePosition.Y - LastMousePosition.Y)) > 5) then
--             -- 近似计算一下移动的距离
--             self:CheckInputEventAndRefresh("KeyboardAndMouse")
--             return true
--         end
--         return false
--     end
-- end

function M:Handle_KeyEventOnPC(InKeyName)
    local IsEventHandled = true
    -- 处理键盘相关的交互事件
    if (InKeyName == UE4.EKeys.A.KeyName) then
        self:TabToLeft()
    elseif (InKeyName == UE4.EKeys.D.KeyName) then
        self:TabToRight()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    local IsEventHandled = true
    -- 处理手柄相关的交互事件
    if (InKeyName == UIConst.GamePadKey.LeftShoulder) then
        self:TabToLeft()
    elseif (InKeyName == UIConst.GamePadKey.RightShoulder) then
        self:TabToRight()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M

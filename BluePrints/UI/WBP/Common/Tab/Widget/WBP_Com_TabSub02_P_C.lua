--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_TabSub02
local M = Class("BluePrints.UI.BP_EMUserWidget_C")


--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.SoundFunc = nil
    self.HoverSoundFunc = nil
    self.SoundFuncReceiver = self
end

function M:Init(ConfigData)
    self.CurrentTab = nil
    -- ConfigData({
    --     PlatformName = "PC", 平台类型 (PC、Mobile、GamePad)
    --     Tabs = {
    --             Text = "任务"   Tab文本
    --             TabId = 1, Tab的Id
    --             ShowRedDot = 1/true, 显示红点,
    --             IsNew = 1/true, 显示新道具图标
    --             IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
    --             IsLocked = false, 是否此Tab仍处于锁定状态（true为锁定）
    --             LockReasonText = GText("UI_RegionMap_MaxMark"), 未解锁点击提示文本
    --     },
    --     SoundFunc = function,       音效播放
    --     HoverSoundFunc = function,  悬浮音效播放
    --     SoundFuncReceiver = Obj,    音效播放接收对象
    -- })
    -- 初始化设置Tab信息
    self.ConfigData = ConfigData
    self.ChildWidgetName = ConfigData.ChildWidgetName

    -- 初始化音效播放函数
    self.SoundFunc = ConfigData.SoundFunc or self.PlayClickSound
    self.HoverSoundFunc = ConfigData.HoverSoundFunc
    self.SoundFuncReceiver = ConfigData.SoundFuncReceiver or self

    -- 平台
    self.DeviceTypeByPlatformName = ConfigData.PlatformName or CommonUtils.GetDeviceTypeByPlatformName(self)

    self:UpdateTabs(self.ConfigData.Tabs or {})
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

    -- 2024.7.25新增 只有一个Tab的时候需要隐藏自身
    self.Tabs = Tabs
    self.ScrollBox_Tab:ClearChildren()
    for i = 1, #Tabs do
        local Child = UIManager(self):_CreateWidgetNew(self.ChildWidgetName or "TabSubIconTextItem")
        self.ScrollBox_Tab:AddChild(Child)
        Child:Update(i, Tabs[i], self.DeviceTypeByPlatformName)
        Child:BindEventOnSwitchOn(self, self.OnTabSwitchOn)
        Child:BindSoundFunc(self.SoundFunc,self.SoundFuncReceiver)
        Child:BindHoverSoundFunc(self.HoverSoundFunc,self.SoundFuncReceiver)
    end
    if (#Tabs <= 1) then
        self:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"]) 
    end
    self:InitNavigationRules()
end

function M:OnTabSwitchOn(TabWidget)
    if (TabWidget and self.Tabs[TabWidget.Idx]) then
        if(self.CurrentTab and TabWidget.Idx ~= self.CurrentTab)then
            self.ScrollBox_Tab:GetChildAt(self.CurrentTab - 1):SetSwitchOn(false)
        end
        self.CurrentTab = TabWidget.Idx
        self.ScrollBox_Tab:ScrollWidgetIntoView(TabWidget)
    end

    if(self.EventTabSelected)then
        self.EventTabSelected(self.ObjTabSelected, TabWidget)
    end
    if (type(self.ScrollBox_Tab.SetSelectItemIndex) == "function") then
        self.ScrollBox_Tab:SetSelectItemIndex(self.CurrentTab - 1)
    end
end

function M:BindEventOnTabSelected(Obj,Event)
    self.ObjTabSelected = Obj
    self.EventTabSelected = Event
end

function M:SelectTab(Idx)
    if self.Tabs[Idx] then
        self.ScrollBox_Tab:GetChildAt(math.max(Idx - 1, 0)):SetSwitchOn(true)
    end
end

function M:TabToUp()
    if(self.CurrentTab and self.CurrentTab - 1 >= 1 )then
        UIUtils.PlayCommonBtnSe(self)
        self.ScrollBox_Tab:GetChildAt(self.CurrentTab - 2):SetSwitchOn(true, true)
    end
end

function M:TabToDown()
    if(self.CurrentTab and self.CurrentTab + 1 <= #self.Tabs)then
        UIUtils.PlayCommonBtnSe(self)
        self.ScrollBox_Tab:GetChildAt(self.CurrentTab):SetSwitchOn(true, true)
    end
end

function M:UnLockTabByIndex(bUnLock, TabIndex)
    local AllItemCount = self.ScrollBox_Tab:GetChildrenCount()
    if (TabIndex ~= nil) then
        for i = 1, AllItemCount, 1 do
            local Child = self.ScrollBox_Tab:GetChildAt(i - 1)
            if (TabIndex == Child.Idx) then
                Child:SetLockInfo(bUnLock)
                break 
            end
        end
    else
        for i = 1, AllItemCount, 1 do
            local Child = self.ScrollBox_Tab:GetChildAt(i - 1)
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
        local TabWidget = self.ScrollBox_Tab:GetChildAt(math.max(Idx - 1, 0))
        TabWidget:SetReddot(IsNew,Upgradeable,OhterReddot)
    end
end

function M:ShowTabRedDotByTabId(TabId, IsNew, Upgradeable, OhterReddot)
    local AllItemCount = self.ScrollBox_Tab:GetChildrenCount()
    for i = 1, AllItemCount, 1 do
        local TabWidget = self.ScrollBox_Tab:GetChildAt(i - 1)
        if (TabId == TabWidget:GetTabId()) then
            TabWidget:SetReddot(IsNew,Upgradeable,OhterReddot)
            break 
        end
    end
end

function M:PlayClickSound()
    UIUtils.PlayCommonBtnSe(self)
    -- AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

function M:Handle_KeyEventOnPC(InKeyName)
    local IsEventHandled = true
    -- 处理键盘相关的交互事件
    if (InKeyName == UE4.EKeys.W.KeyName) then
        self:TabToUp()
    elseif (InKeyName == UE4.EKeys.S.KeyName) then
        self:TabToDown()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    local IsEventHandled = true
    -- 处理手柄相关的交互事件
    if (InKeyName == UIConst.GamePadKey.LeftTriggerThreshold) then
        self:TabToUp()
    elseif (InKeyName == UIConst.GamePadKey.RightTriggerThreshold) then
        self:TabToDown()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    local Widget = self.ScrollBox_Tab:GetChildAt(0)
    if(Widget)then
        return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),Widget)
    end
    return  UIUtils.Unhandled
end

function M:InitNavigationRules()
    local Widgets = self.ScrollBox_Tab:GetAllChildren():ToTable()
    for index, Widget in ipairs(Widgets) do
        local LastWidgt = Widgets[index - 1]
        if(LastWidgt)then
            local function OnNavigateUp()
                self.ScrollBox_Tab:ScrollWidgetIntoView(LastWidgt)
                return LastWidgt
            end
            Widget:SetNavigationRuleCustom(EUINavigation.Up, OnNavigateUp)
        else
            Widget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Escape)
        end
        local NextWidget = Widgets[index + 1]
        if(NextWidget)then
            local function OnNavigateDown()
                self.ScrollBox_Tab:ScrollWidgetIntoView(NextWidget)
                return NextWidget
            end
            Widget:SetNavigationRuleCustom(EUINavigation.Down, OnNavigateDown)
        else
            Widget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Escape)
        end
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

return M

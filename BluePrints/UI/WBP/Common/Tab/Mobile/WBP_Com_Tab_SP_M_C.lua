--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local TimeUtils = require "Utils.TimeUtils"
local ItemUtils = require "Utils.ItemUtils"
---@type WBP_Com_Tab_SP_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function M:Construct()
    self.SoundFunc = self.PlayClickSound
    self.SoundFuncReceiver = self
end

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
    
    self:ClearListenEvent()
end

function M:Init(ConfigData, NotPlayInAnim)
-- ConfigData({
--     PlatformName = "Mobile", 平台类型 (PC、Mobile、GamePad)
--     Tabs = {
--             Text = "任务", Tab文本
--             TabId = 1, Tab的Id,
--             ShowRedDot = 1/true, 显示红点,
--             IsNew = 1/true, 显示新道具图标
--             IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
--             IsLocked = false, 是否此Tab仍处于锁定状态（true为锁定）
--             LockReasonText = GText("UI_RegionMap_MaxMark"), 未解锁点击提示文本
--     },
--     ForceHideTabs = Boolean, 是否强制隐藏Tabs，目前仅印象商店在用
--     DynamicNode={
--             "ResourceBar", 顶部资源条
--     }, 需要动态添加的节点 （根据需要填入）
--     StyleName = "Text", 类型："Text" 或 "Image" (各个Tab是Icon文本类型还是圆角图标类型)
--     TitleName = "Text", 标题名字
--     OverridenTopResouces = {101， 102}, 自定义顶部资源条（不填则默认用SystemUI表里的）
--     PopupInfoId = Number,       信息按钮的弹窗ID (如果不填，则会尝试从SystemUI表里去读取)
--     InfoCallback = function,    信息按钮的确认回调 (通常可以不填)
--     BackCallback = function,    返回按钮的回调
--     SoundFunc = function,       列表点击音效
--     SoundFuncReceiver = Obj,    列表点击音效接收对象
--     OwnerPanel = ParentWidget,  父对象
--     IconSignPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 左下角图片路径
-- })
    -- 初始化设置Tab信息
    self.ConfigData = ConfigData
    -- 返回按钮的回调
    self.BackCallback = ConfigData.BackCallback
    -- Info按钮的回调
    self.InfoCallback = ConfigData.InfoCallback
    -- 所属的对象
    self.OwnerPanel = ConfigData.OwnerPanel
    -- Item的样式Type
    self.StyleName = ConfigData.StyleName or "Text"
    -- Tab的标题
    self.TitleName = ConfigData.TitleName
    -- Tab的副标题
    self.SubTitleName = ConfigData.SubTitleName
    -- 自定义顶部资源条
    self.OverridenTopResouces = ConfigData.OverridenTopResouces
    -- 初始化音效播放函数
    self.SoundFunc = ConfigData.SoundFunc or self.PlayClickSound
    self.SoundFuncReceiver = ConfigData.SoundFuncReceiver or self
    -- 平台
    self.DeviceTypeByPlatformName = ConfigData.PlatformName or CommonUtils.GetDeviceTypeByPlatformName(self)
    -- 左下角图片路径
    self.IconSignPath = ConfigData.IconSignPath
    self.CurrentTab = nil
    self.bEnableSelectTab = true
    self.ShowSquadBuildBtn = ConfigData.ShowSquadBuildBtn
    self.bShowBubble = ConfigData.bShowBubble
    -- 动态增加节点
    self:ResetDynamicNode()
    -- 填充Tab内容
    self:UpdateTabs(self.ConfigData.Tabs or {})
    -- 设置基本内容信息
    self:RefreshBaseInfo()
    if (NotPlayInAnim) then
        self:StopAnimation(self.In)
    end
    -- 添加需要监听的事件
    self:InitListenEvent()
end

function M:InitListenEvent()
    EventManager:RemoveEvent(EventID.OnPropSetResources,self,self.OnPropSetResources)
end

function M:ClearListenEvent()
    EventManager:RemoveEvent(EventID.OnPropSetResources, self)
end

function M:RefreshBaseInfo()
    -- 设置文本标题相关
    if (self.TitleName ~= nil) then
        self.Text_Title:SetText(self.TitleName)
        self.Text_Title:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"]) 
    else
        self.Text_Title:SetVisibility(UIConst.VisibilityOp["Collapsed"]) 
    end


    -- 设置返回按钮相关
    self.Btn_Back.Btn_Back.OnClicked:Clear()
    self.Btn_Back.Btn_Back.OnClicked:Add(self, self.OnReturnClick)
    -- 刷新左下角图片
    if (self.IconSignPath) then
        local IconSignTexture = LoadObject(self.IconSignPath)
        if (IsValid(IconSignTexture)) then
            self.Icon_Sign:SetBrushFromTexture(IconSignTexture)
        end
    end
end

function M:ResetDynamicNode()
    local DynamicNodeName = {Panel_ResourceBar={NeedRemoveChild=true}, }
    for k, v in pairs(DynamicNodeName) do
        if (self[k] ~= nil) then
            if (v.NeedRemoveChild) then
                self[k]:ClearChildren() 
            end
            self[k]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end 
    end

    if (self.ConfigData.DynamicNode == nil) then
        return
    end
    for i, v in ipairs(self.ConfigData.DynamicNode) do
        if (v == "ResourceBar") then
            local UIWidgetName = self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName
            local SystemUIConfig = DataMgr.SystemUI[UIWidgetName] or {}
            local TopResource = self.OverridenTopResouces or SystemUIConfig.TabCoin
            if (TopResource ~= nil) then
                for i, CoinId in ipairs(TopResource) do
                    local ResourceBar = self.ResourceBar[CoinId]
                    if (not IsValid(ResourceBar)) then
                        ResourceBar = UIManager(self):_CreateWidgetNew("ResourceBar")
                        self.ResourceBar[CoinId] = ResourceBar
                    end
                    local CoinIcon = LoadObject(DataMgr.Resource[CoinId].Icon)
                    ResourceBar.Common_Item_Icon:Init({
                        UIName = UIWidgetName,
                        IsShowDetails = true,
                        IsCantItemSelection = true,
                        MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
                        Id = CoinId,
                        Icon = CoinIcon,
                        ItemType = "Resource",
                        HandleMouseDown = true
                    })
                    ResourceBar:SetItemId(CoinId)
                    
                    -- 检查是否为限时资源，如果是则显示气泡提示
                    if self.bShowBubble then
                        self:CheckAndShowLimitedResourceBubble(CoinId, ResourceBar)
                    end
                end
                self.ResourceBar:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            else
                self.ResourceBar:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            end
        end
    end
    -- local SystemUIConfig = DataMgr.SystemUI[self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName] or {}
    -- local IsChat = SystemUIConfig.IsChat
    -- if IsChat then
    --     local ChatUI = UIManager(self):CreateWidget('/Game/UI/WBP/Chat/Mobile/WBP_Chat_CommonEnter_M.WBP_Chat_CommonEnter_M', false)
    --     if self.Panel_Chat then
    --         self.Panel_Chat:ClearChildren()
    --         self.Panel_Chat:AddChildToOverlay(ChatUI)
    --     end
    -- else
    --     if self.Panel_Chat then
    --         self.Panel_Chat:ClearChildren()
    --     end
    -- end
end

function M:SetBgRenderOpacity(Value)
    self.Bg_Bottom:SetRenderOpacity(Value)
    self.Bg_Top:SetRenderOpacity(Value)
end

-- 动态覆盖资源,注意需在ResetDynamicNode之前调用（还是建议直接在Init之中额外传入OverridenTopResouces）
function M:OverrideTopResource(OverridenTopResouces)
    self.OverridenTopResouces = OverridenTopResouces
end

function M:UpdateResource()
    -- 刷新右上方货币条
    for k, v in pairs(self.ResourceBar) do
        if (IsValid(v)) then
            v:RefreshItemInfo()
        end
    end
end

function M:UpdateTopTitle(TitleName)
    -- 刷新左上方标题
    self.TitleName = TitleName
    if (TitleName ~= nil) then
        self.Text_Title:SetText(TitleName)
        self.Text_Title:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Text_Title:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
end

function M:UpdateTabs(Tabs)
    -- 刷新Tab信息
    local SortFunc = function(ComPareA, ComPareB)
        local IsALocked = ComPareA.IsLocked or false
        local IsBLocked = ComPareB.IsLocked or false

        if (IsALocked == IsBLocked) then 
            local SortA = ComPareA.SortId
            local SortB = ComPareB.SortId
            if (SortA ~= nil and SortB ~= nil) then
                return SortA > SortB 
            else
                local TabIdA = ComPareA.TabId or 1
                local TabIdB = ComPareB.TabId or 1
                return TabIdA < TabIdB
            end
        else
            return not IsALocked
        end
    end
    table.sort(Tabs, SortFunc)
    self.Tabs = Tabs
    if (#Tabs < 1) then
        self.ScrollBox_Tab:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end
    self.ScrollBox_Tab:ClearChildren()
    for i = 0, #Tabs - 1, 1 do
        local Child, TabItemClass = nil, nil
        TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabItem_SP_M.WBP_Com_TabItem_SP_M_C")
        if (TabItemClass ~= nil) then
            Child = UE4.UWidgetBlueprintLibrary.Create(self, TabItemClass)  
            if (IsValid(Child)) then
                self.ScrollBox_Tab:AddChild(Child)
                Child:Update(i + 1,Tabs[i + 1])
                Child:BindEventOnSwitchOn(self,self.OnTabSwitchOn)
                Child:BindSoundFunc(self.SoundFunc,self.SoundFuncReceiver)
            end
        end
    end
    self.ScrollBox_Tab:SetVisibility(UIConst.VisibilityOp["Visible"])
end

function M:OnReturnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    -- 点击退出
    if (type(self.BackCallback) == "function") then
        self.BackCallback(self.OwnerPanel)
    end
end

function M:OnTabSwitchOn(TabWidget)
    if(TabWidget and self.Tabs[TabWidget.Idx])then
        if(self.CurrentTab and TabWidget.Idx ~= self.CurrentTab)then
            local CurSwitchChildWidget = self.ScrollBox_Tab:GetChildAt(self.CurrentTab - 1)
            if (CurSwitchChildWidget ~= nil) then
                CurSwitchChildWidget:SetSwitchOn(false)
            end
            local CurChildWidget = self.ScrollBox_Tab:GetChildAt(TabWidget.Idx - 1)
            self.ScrollBox_Tab:ScrollWidgetIntoView(CurChildWidget)
        end
        self.CurrentTab = TabWidget.Idx
    end
    if(self.EventTabSelected)then
        self.EventTabSelected(self.ObjTabSelected,TabWidget,self.Tabs[TabWidget.Idx])
    end
end

function M:BindEventOnTabSelected(Obj,Event)
    self.ObjTabSelected = Obj
    self.EventTabSelected = Event
end

--- @param Idx number Tab的索引
function M:SelectTab(Idx)
    if(self.Tabs[Idx])then
        local ChildWidget = self.ScrollBox_Tab:GetChildAt(math.max(Idx - 1, 0))
        ChildWidget:SetSwitchOn(true)
        self.ScrollBox_Tab:ScrollWidgetIntoView(ChildWidget)
    end
end

--- @param TabId number Tab的TabId
function M:SelectTabById(TabId)
    local AllItemCount = self.ScrollBox_Tab:GetChildrenCount()
    for i = 1, AllItemCount, 1 do
        local ChildWidget = self.ScrollBox_Tab:GetChildAt(i - 1)
        if (TabId == ChildWidget:GetTabId()) then
            ChildWidget:SetSwitchOn(true)
            self.ScrollBox_Tab:ScrollWidgetIntoView(ChildWidget)
            break 
        end
    end
end

function M:ShowTabRedDot(Idx, IsNew,Upgradeable,OhterReddot)
    if self.Tabs[Idx] then 
        local TabWidget = self.ScrollBox_Tab:GetChildAt(math.max(Idx - 1, 0))
        TabWidget:SetReddot(IsNew, Upgradeable, OhterReddot)
    end
end

function M:ShowTabRedDotByTabId(TabId, IsNew, Upgradeable, OhterReddot)
    local AllItemCount = self.ScrollBox_Tab:GetChildrenCount()
    for i = 1, AllItemCount, 1 do
        local TabWidget = self.ScrollBox_Tab:GetChildAt(i - 1)
        if (TabId == TabWidget:GetTabId()) then
            TabWidget:SetReddot(IsNew, Upgradeable, OhterReddot)
            break 
        end
    end
end

function M:TabToUp()
    if (not self.bEnableSelectTab) then
        return
    end
    if(self.CurrentTab and self.CurrentTab - 1 >= 1 )then
        local ChildWidget = self.ScrollBox_Tab:GetChildAt(self.CurrentTab - 2)
        ChildWidget:SetSwitchOn(true, true)
        self.ScrollBox_Tab:ScrollWidgetIntoView(ChildWidget)
        self.SoundFunc(self.SoundFuncReceiver,self.CurrentTab - 1)
    end
end

function M:TabToDown()
    if (not self.bEnableSelectTab) then
        return
    end
    if(self.CurrentTab and self.CurrentTab + 1 <= #self.Tabs)then
        local ChildWidget = self.ScrollBox_Tab:GetChildAt(self.CurrentTab)
        ChildWidget:SetSwitchOn(true, true)
        self.ScrollBox_Tab:ScrollWidgetIntoView(ChildWidget)
        self.SoundFunc(self.SoundFuncReceiver,self.CurrentTab + 1)
    end
end

function M:EnableTabByIndex(bEnable, TabIndex)
    self.bEnableSelectTab = bEnable
    local AllItemCount = self.ScrollBox_Tab:GetChildrenCount()
    if (TabIndex ~= nil) then
        for i = 1, AllItemCount, 1 do
            local Child = self.ScrollBox_Tab:GetChildAt(i - 1)
            if (TabIndex == Child.Idx) then
                Child:SetClickEnable(bEnable)
                break 
            end
        end
    else
        for i = 1, AllItemCount, 1 do
            local Child = self.ScrollBox_Tab:GetChildAt(i - 1)
            Child:SetClickEnable(bEnable)
        end 
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

function M:PlayInAnim()
    if (self.In == nil) then
        return -1
    end
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    return self.In:GetEndTime()
end

function M:PlayOutAnim()
    if (self.Out == nil) then
        return -1
    end
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
    return self.Out:GetEndTime()
end

function M:PlayTabInAnim()
    self:StopAnimation(self.Panel_Tab_Out)
    self:PlayAnimation(self.Panel_Tab_In)
end

function M:PlayTabOutAnim()
    self:StopAnimation(self.Panel_Tab_In)
    self:PlayAnimation(self.Panel_Tab_Out)
end

function M:SetBackBtnAttrColor(AttrName)
    AttrName = AttrName or "Fire"
    if (self.Btn_Back) then
        local img = LoadObject("/Game/UI/UI_PC/Common/Material/Noise/MI_Common_Noise_" .. AttrName .. ".MI_Common_Noise_" .. AttrName)
        self.Btn_Back.VX_BackWave:SetBrushFromMaterial(img)
    end
end

function M:OnPropSetResources(ResourceId)
    if self.ResourceBar and self.ResourceBar[ResourceId] then
        self.ResourceBar[ResourceId]:RefreshItemInfo()
    end
end

function M:EnterViewSingleMode()
end

function M:LeaveViewSingleMode()
end

function M:PlayClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

function M:UpdateReddots()
    for _, Tab in pairs(self.Tabs) do
        if(IsValid(Tab.UI) and Tab.UI.SetReddot)then
            Tab.UI:SetReddot(Tab.IsNew,Tab.Upgradeable,Tab.OtherReddot)
        end
    end
end


-----------------------------------------------输入事件相关------------------------------------------------
function M:Handle_KeyEventOnTouch(InKeyName)
    local IsEventHandled = true
    -- 处理其他触控相关的交互事件
    if (InKeyName == UE4.EKeys.Escape.KeyName) then
        self:OnReturnClick()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    return false
    -- local IsEventHandled = true
    -- -- 处理手柄相关的交互事件
    -- if (InKeyName == "Gamepad_FaceButton_Right") then
    --     if (self:GetSelectMode() ~= TabSelectStateEnum.SelectTab) then
    --         self:ExitTabSelectMode()
    --     else
    --         self:OnReturnClick()
    --     end
    -- elseif (InKeyName == "Gamepad_LeftShoulder") then
    --     self:ClickToLeftOnGamePad("Tab")
    -- elseif (InKeyName == "Gamepad_LeftStick_Left" or InKeyName == "Gamepad_DPad_Left") then
    --     self:ClickToLeftOnGamePad("Resource")
    -- elseif (InKeyName == "Gamepad_RightShoulder") then
    --     self:ClickToRightOnGamePad("Tab")
    -- elseif (InKeyName == "Gamepad_LeftStick_Right" or InKeyName == "Gamepad_DPad_Right") then
    --     self:ClickToRightOnGamePad("Resource")
    -- elseif (InKeyName == "Gamepad_RightThumbstick") then
    --     self:EnterResourceSelectMode()
    -- elseif (InKeyName == "Gamepad_FaceButton_Bottom") then
    --     self:EnterResourceViewDetailMode()
    -- elseif (InKeyName == "Gamepad_Special_Right") then
    --     self:OnInfoClick()
    -- else
    --     IsEventHandled = false
    -- end
    -- return IsEventHandled
end

--- 检查并显示限时资源气泡提示
---@param ResourceId number 资源ID
---@param ResourceBar table 资源栏控件
function M:CheckAndShowLimitedResourceBubble(ResourceId, ResourceBar)
    local ResourceInfo = DataMgr.Resource[ResourceId]
    local LimitedInfo = ItemUtils.GetItemLimitedInfo(ResourceId)
    if ResourceInfo and LimitedInfo then
        local Avatar = GWorld:GetAvatar()
        if Avatar then
            local Count = Avatar:GetResourceNum(ResourceId)
            -- local Count = 10
            if Count > 0 then
                -- 这是一个有库存的限时资源，从LimitedTimeResource表获取最近的EndTime
                local NowTime = TimeUtils.NowTime()
                if LimitedInfo.EndTime then
                    local TimeDiff = LimitedInfo.EndTime - NowTime
                    -- local TimeDiff = 180000
                    if TimeDiff > 0 and TimeDiff < CommonConst.SECOND_IN_DAY then
                        -- 剩余时间小于1天，显示红色气泡
                        local ConfigData = {
                            -- IconPath = ResourceInfo.Icon, -- TAB中不显示资源图标
                            Text = GText("UI_GachaTicket_Bubble"),
                            TextColor = 1 -- 红色
                        }
                        ResourceBar:ShowBubble(ConfigData)
                        self:HideLimitedResourceBubbleAfterDelay(ResourceBar, 3.0)
                    elseif TimeDiff >= CommonConst.SECOND_IN_DAY and TimeDiff < CommonConst.SECOND_IN_WEEKDAY then
                        -- 剩余时间1天到1周，显示橙色气泡
                        local ConfigData = {
                            -- IconPath = ResourceInfo.Icon,
                            Text = GText("UI_GachaTicket_Bubble"),
                            TextColor = 0 -- 橙色
                        }
                        ResourceBar:ShowBubble(ConfigData)
                        self:HideLimitedResourceBubbleAfterDelay(ResourceBar, 3.0)
                    end
                    -- 如果剩余时间 >= 1周，则不显示气泡
                end
            end
        end
    end
end

--- 延迟隐藏限时资源气泡
---@param ResourceBar table 资源栏控件
---@param DelayTime number 延迟时间（秒）
function M:HideLimitedResourceBubbleAfterDelay(ResourceBar, DelayTime)
    if not self.BubbleTimers then
        self.BubbleTimers = {}
    end
    
    -- 生成唯一的定时器ID
    local TimerId = "LimitedResourceBubble_" .. tostring(ResourceBar.Id)
    
    -- 如果已有相同的定时器，先移除
    if self:IsExistTimer(TimerId) then
        self:RemoveTimer(TimerId)
    end
    
    -- 添加新的定时器
    local HideBubbleFunc = function()
        if IsValid(ResourceBar) then
            ResourceBar:HideBubble()
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

return M

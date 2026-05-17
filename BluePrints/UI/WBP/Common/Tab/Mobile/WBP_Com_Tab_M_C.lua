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
---@type WBP_Com_Tab_P_C
local M = Class({"BluePrints.UI.BP_EMUserWidget_C","BluePrints.Common.TimerMgr"})

function M:Construct()
    self.SoundFunc = self.PlayClickSound
    self.SoundFuncReceiver = self
    self.Panel_Team:SetVisibility(UIConst.VisibilityOp.Collapsed)
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
    -- Popup弹窗ID
    self.PopupInfoId = ConfigData.PopupInfoId
    -- 初始化音效播放函数
    self.SoundFunc = ConfigData.SoundFunc or self.PlayClickSound
    self.SoundFuncReceiver = ConfigData.SoundFuncReceiver or self
    -- 平台
    self.DeviceTypeByPlatformName = ConfigData.PlatformName or CommonUtils.GetDeviceTypeByPlatformName(self)

    self.CurrentTab = nil
    self.bEnableSelectTab = true
    self.ResourceBarWidget = {}
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
    -- 更新副标题
    self:UpdateTopSubTitle()

    -- 更新右上角信息
    self.Btn_Tip.Button_Area.OnClicked:Clear()
    self.Btn_Tip.Button_Area.OnClicked:Add(self, self.OnInfoClick)
    self:UpdateTopRightTips()

    -- 设置返回按钮相关
    self.Btn_Back.Btn_Back.OnClicked:Clear()
    self.Btn_Back.Btn_Back.OnClicked:Add(self, self.OnReturnClick)
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
                self.Panel_ResourceBar:ClearChildren()
                self.ResourceBarWidget = {}
                for i, CoinId in ipairs(TopResource) do
                    local ResourceBarWidget = self.ResourceBarWidget[CoinId]
                    if (not IsValid(ResourceBarWidget)) then
                        ResourceBarWidget = UIManager(self):_CreateWidgetNew("ResourceBar")
                        self.ResourceBarWidget[CoinId] = ResourceBarWidget
                    end
                    -- local CoinIcon = LoadObject(DataMgr.Resource[CoinId].Icon)
                    local CoinIconPath = DataMgr.Resource[CoinId].Icon
                    ResourceBarWidget.Common_Item_Icon:Init({
                        UIName = UIWidgetName,
                        IsShowDetails = true,
                        IsCantItemSelection = true,
                        MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight,
                        Id = CoinId,
                        Icon = CoinIconPath,
                        ItemType = "Resource",
                        HandleMouseDown = true
                    })
                    ResourceBarWidget:SetItemId(CoinId)
                    -- ResourceBarWidget:PlayInAnim()
                    self.Panel_ResourceBar:AddChild(ResourceBarWidget)

                    -- 检查是否为限时资源，如果是则显示气泡提示
                    if self.bShowBubble then
                        self:CheckAndShowLimitedResourceBubble(CoinId, ResourceBarWidget)
                    end
                end
                self.Panel_ResourceBar:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
            else
                self.Panel_ResourceBar:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            end
        end
    end
    local SystemUIConfig = DataMgr.SystemUI[self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName] or {}
    local IsChat = SystemUIConfig.IsChat
    if IsChat then
        local ChatUI = UIManager(self):CreateWidget('/Game/UI/WBP/Chat/Mobile/WBP_Chat_CommonEnter_M.WBP_Chat_CommonEnter_M', false)
        if self.Panel_Chat then
            self.Panel_Chat:ClearChildren()
            self.Panel_Chat:AddChildToOverlay(ChatUI)
        end
    else
        if self.Panel_Chat then
            self.Panel_Chat:ClearChildren()
        end
    end
end

function M:SetBgRenderOpacity(Value)
    self.Bg_Bottom:SetRenderOpacity(Value)
    self.Bg_Top:SetRenderOpacity(Value)
end

-- 动态覆盖资源,注意需在ResetDynamicNode之前调用（还是建议直接在Init之中额外传入OverridenTopResouces）
function M:OverrideTopResource(OverridenTopResouces, bIsRequestRefresh)
    self.OverridenTopResouces = OverridenTopResouces
    if bIsRequestRefresh then
        self:ResetDynamicNode()
    end
end

function M:SetPopupInfoId(PopupInfoId, IsNeedRefresh)
    self.PopupInfoId = PopupInfoId
    if (IsNeedRefresh) then
        self:UpdateTopRightTips() 
    end
end

function M:UpdateInfoBySelectTabItem(TabWidget)
    -- 切换Tab之后需要更新的信息
    self:UpdateTopRightTips()
    self:UpdateTopSubTitle(TabWidget:GetShowText())
end

function M:UpdateResource()
    -- 刷新右上方货币条
    for k, v in pairs(self.ResourceBarWidget) do
        if (IsValid(v)) then
            v:RefreshItemInfo()
        end
    end
end

function M:SetResourceBarVisibility(Visibility)
    self.Panel_ResourceBar:SetVisibility(Visibility)
end

function M:UpdateTopRightTips()
    -- 更新右上角信息
    local function RealUpdateTopRightTips()
        if (self.PopupInfoId ~= nil or type(self.InfoCallback) == "function") then
            self.Panel_Tip:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            self.Panel_Tip:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end

    if (self.PopupInfoId == nil) then
        if (self.OwnerPanel ~= nil and type(self.OwnerPanel.GetUIConfigName) == "function") then
            local UIConfigName = self.OwnerPanel:GetUIConfigName()
            local SystemUIConfig = DataMgr.SystemUI[UIConfigName] or {}
            self.PopupInfoId = SystemUIConfig.PopupInfoId
        end 
    end
    RealUpdateTopRightTips()
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

function M:UpdateTopSubTitle(SubTitleName)
    -- 刷新左上方副标题标题
    self.SubTitleName = SubTitleName or self.SubTitleName
    if (self.SubTitleName ~= nil) then
        self.Split:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"]) 
        self.Text_SubTitle:SetText(self.SubTitleName)
        self.Text_SubTitle:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"]) 
    else
        self.Split:SetVisibility(UIConst.VisibilityOp["Collapsed"]) 
        self.Text_SubTitle:SetVisibility(UIConst.VisibilityOp["Collapsed"]) 
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
        self.Panel_Tab:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.EMScrollBox_TabItem:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end
    -- self.EMScrollBox_TabItem:ClearChildren()
    -- for i = 0, #Tabs - 1, 1 do
    --     local Child, TabItemClass = nil, nil
    --     if (self.StyleName == "Image") then
    --         TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabItem_M.WBP_Com_TabItem_M_C")
    --     elseif(self.StyleName == "Armory")then
    --         TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabArmItem_M.WBP_Com_TabArmItem_M_C")
    --     else
    --         TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabItem_M.WBP_Com_TabItem_M_C")
    --     end
    --     if (TabItemClass ~= nil) then
    --         Child = UE4.UWidgetBlueprintLibrary.Create(self, TabItemClass)  
    --         if (IsValid(Child)) then
    --             self.EMScrollBox_TabItem:AddChild(Child)
    --             Child:Update(i + 1,Tabs[i + 1])
    --             Child:BindEventOnSwitchOn(self,self.OnTabSwitchOn)
    --             Child:BindSoundFunc(self.SoundFunc,self.SoundFuncReceiver)
    --         end
    --     end
    -- end

    for index = 1, #Tabs, 1 do
        local CurChildWidget = self.EMScrollBox_TabItem:GetChildAt(index - 1)
        if (not CurChildWidget) then
            local TabItemClass = nil
            if (self.StyleName == "Image") then
                TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabItem_M.WBP_Com_TabItem_M_C")
            elseif(self.StyleName == "Armory")then
                TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabArmItem_M.WBP_Com_TabArmItem_M_C")
            elseif(self.StyleName == "TextImage")then
                TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabItem_M.WBP_Com_TabItem_M")
            else
                TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabItem_M.WBP_Com_TabItem_M_C")
            end
            if (TabItemClass ~= nil) then
                CurChildWidget = UE4.UWidgetBlueprintLibrary.Create(self, TabItemClass)
                if (IsValid(CurChildWidget)) then
                    self.EMScrollBox_TabItem:AddChild(CurChildWidget)
                end
            end
        end
        -- 进行内容的设置
        if (CurChildWidget) then
            CurChildWidget:Update(index,Tabs[index])
            CurChildWidget:BindEventOnSwitchOn(self,self.OnTabSwitchOn)
            CurChildWidget:BindSoundFunc(self.SoundFunc,self.SoundFuncReceiver)
            CurChildWidget:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end

    local CurChildCount = self.EMScrollBox_TabItem:GetChildrenCount()
    for ExtraIdx = #Tabs + 1, CurChildCount, 1 do
        local ExtraChildWidget = self.EMScrollBox_TabItem:GetChildAt(ExtraIdx - 1)
        if (ExtraChildWidget) then
            ExtraChildWidget:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
    self.EMScrollBox_TabItem:SetVisibility(UIConst.VisibilityOp["Visible"])

    if self.ConfigData.ForceHideTabs then
        self.Panel_Tab:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Panel_Tab:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end

    if self.ShowSquadBuildBtn then
        self.Entrance_Build:SetVisibility(ESlateVisibility.Visibility)
        self.Entrance_Build:InitUI()
    end
end

function M:OnReturnClick()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    -- 点击退出
    if (type(self.BackCallback) == "function") then
        self.BackCallback(self.OwnerPanel)
    end
end

function M:OnInfoClick()
    if (self.PopupInfoId ~= nil) then
        -- 点击Info按钮
        local Params = {
            RightCallbackFunction = function()
                if (type(self.InfoCallback) == "function") then
                    self.InfoCallback(self.OwnerPanel)
                end
            end
        }
        UIManager(self):ShowCommonPopupUI(self.PopupInfoId, Params)
    elseif (type(self.InfoCallback) == "function") then
        self.InfoCallback(self.OwnerPanel)
    end
end

function M:OnTabSwitchOn(TabWidget)
    if(TabWidget and self.Tabs[TabWidget.Idx])then
        if(self.CurrentTab and TabWidget.Idx ~= self.CurrentTab)then
            local CurSwitchChildWidget = self.EMScrollBox_TabItem:GetChildAt(self.CurrentTab - 1)
            if (CurSwitchChildWidget ~= nil) then
                CurSwitchChildWidget:SetSwitchOn(false)
            end
            local CurChildWidget = self.EMScrollBox_TabItem:GetChildAt(TabWidget.Idx - 1)
            self.EMScrollBox_TabItem:ScrollWidgetIntoView(CurChildWidget)
        end
        self.CurrentTab = TabWidget.Idx
        self:UpdateInfoBySelectTabItem(TabWidget)
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
        local ChildWidget = self.EMScrollBox_TabItem:GetChildAt(math.max(Idx - 1, 0))
        ChildWidget:SetSwitchOn(true)
        self.EMScrollBox_TabItem:ScrollWidgetIntoView(ChildWidget)
    end
end

--- @param TabId number Tab的TabId
function M:SelectTabById(TabId)
    local AllItemCount = self.EMScrollBox_TabItem:GetChildrenCount()
    for i = 1, AllItemCount, 1 do
        local ChildWidget = self.EMScrollBox_TabItem:GetChildAt(i - 1)
        if (TabId == ChildWidget:GetTabId()) then
            ChildWidget:SetSwitchOn(true)
            self.EMScrollBox_TabItem:ScrollWidgetIntoView(ChildWidget)
            break 
        end
    end
end

function M:ShowTabRedDot(Idx, IsNew,Upgradeable,OhterReddot)
    if self.Tabs[Idx] then 
        local TabWidget = self.EMScrollBox_TabItem:GetChildAt(math.max(Idx - 1, 0))
        TabWidget:SetReddot(IsNew, Upgradeable, OhterReddot)
    end
end

function M:ShowTabRedDotByTabId(TabId, IsNew, Upgradeable, OhterReddot)
    local AllItemCount = self.EMScrollBox_TabItem:GetChildrenCount()
    for i = 1, AllItemCount, 1 do
        local TabWidget = self.EMScrollBox_TabItem:GetChildAt(i - 1)
        if (TabId == TabWidget:GetTabId()) then
            TabWidget:SetReddot(IsNew, Upgradeable, OhterReddot)
            break 
        end
    end
end

function M:TabToLeft()
    if (not self.bEnableSelectTab) then
        return
    end
    if(self.CurrentTab and self.CurrentTab - 1 >= 1 )then
        local ChildWidget = self.EMScrollBox_TabItem:GetChildAt(self.CurrentTab - 2)
        ChildWidget:SetSwitchOn(true, true)
        self.EMScrollBox_TabItem:ScrollWidgetIntoView(ChildWidget)
        self.SoundFunc(self.SoundFuncReceiver,self.CurrentTab - 1)
    end
end

function M:TabToRight()
    if (not self.bEnableSelectTab) then
        return
    end
    if(self.CurrentTab and self.CurrentTab + 1 <= #self.Tabs)then
        local ChildWidget = self.EMScrollBox_TabItem:GetChildAt(self.CurrentTab)
        ChildWidget:SetSwitchOn(true, true)
        self.EMScrollBox_TabItem:ScrollWidgetIntoView(ChildWidget)
        self.SoundFunc(self.SoundFuncReceiver,self.CurrentTab + 1)
    end
end

function M:EnableTabByIndex(bEnable, TabIndex)
    self.bEnableSelectTab = bEnable
    local AllItemCount = self.EMScrollBox_TabItem:GetChildrenCount()
    if (TabIndex ~= nil) then
        for i = 1, AllItemCount, 1 do
            local Child = self.EMScrollBox_TabItem:GetChildAt(i - 1)
            if (TabIndex == Child.Idx) then
                Child:SetClickEnable(bEnable)
                break 
            end
        end
    else
        for i = 1, AllItemCount, 1 do
            local Child = self.EMScrollBox_TabItem:GetChildAt(i - 1)
            Child:SetClickEnable(bEnable)
        end 
    end
end

function M:UnLockTabByIndex(bUnLock, TabIndex)
    local AllItemCount = self.EMScrollBox_TabItem:GetChildrenCount()
    if (TabIndex ~= nil) then
        for i = 1, AllItemCount, 1 do
            local Child = self.EMScrollBox_TabItem:GetChildAt(i - 1)
            if (TabIndex == Child.Idx) then
                Child:SetLockInfo(bUnLock)
                break 
            end
        end
    else
        for i = 1, AllItemCount, 1 do
            local Child = self.EMScrollBox_TabItem:GetChildAt(i - 1)
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

function M:SetBackBtnAttrColor(AttrName, bAsyncLoadIcon)
    AttrName = AttrName or "Fire"
    if (self.Btn_Back) then
        local IconPath = "/Game/UI/UI_PC/Common/Material/Noise/MI_Common_Noise_" .. AttrName .. ".MI_Common_Noise_" .. AttrName
        if (bAsyncLoadIcon) then
            self:LoadTextureAsync(IconPath, function(Texture)
                if not Texture then
                    DebugPrint(ErrorTag,string.format("SetBackBtnAttrColor 用错图标路径了！！！错误的路径是：%s",IconPath))
                    return
                end
                if(Texture)then
                    self.Btn_Back.VX_BackWave:SetBrushFromMaterial(Texture)
                    -- self.Item.Item_BG:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
                end
            end, "LoadBackBtnIcon")
        else
            local img = LoadObject(IconPath)
            self.Btn_Back.VX_BackWave:SetBrushFromMaterial(img)
        end
    end
end

function M:OnPropSetResources(ResourceId)
    if self.ResourceBarWidget and self.ResourceBarWidget[ResourceId] then
        self.ResourceBarWidget[ResourceId]:RefreshItemInfo()
    end
end

function M:EnterViewSingleMode()
    self.Panel_Tab:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Panel_ResourceBar:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:LeaveViewSingleMode()
    self.Panel_Tab:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.Panel_ResourceBar:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
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
                    -- 如果剩余时间 >= 1周，则不显示气泡
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

--- @todo 手机端预留接口
--- @param SubKeyIndex number 子键索引
--- @param SingleKeyInfo table 单键信息
function M:UpdateSingleBottomKeyInfo(SubKeyIndex, SingleKeyInfo)
end

--- 显示资源栏气泡提示
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

return M

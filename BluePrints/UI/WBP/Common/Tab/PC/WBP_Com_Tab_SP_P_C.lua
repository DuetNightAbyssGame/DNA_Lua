--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Tab_SP_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

local TabSelectStateEnum = {
    SelectTab = 1,
    SelectResource = 2,
}

function M:Construct()
    self.ClickSoundFunc = nil
    self.HoverSoundFunc = nil
    self.SoundFuncReceiverObj = nil
    self.ResourceBar:BindEvents(self,{
        OnAddedToFocusPath = self.OnResourceBarAddedToFocusPath,
        OnRemovedFromFocusPath = self.OnResourceBarRemovedFromFocusPath
    })
end

function M:BP_GetDesiredFocusTarget()
    local ChildWidget = self.ScrollBox_Tab:GetChildAt(self.CurrentTab)
    if (IsValid(ChildWidget)) then
        return ChildWidget
    end
    return nil
end

function M:Destruct()
    self:ClearListenEvent()
end

function M:Init(ConfigData, NotPlayInAnim)
-- ConfigData({
--     PlatformName = "PC", 平台类型 (PC、Mobile、GamePad)
--     LeftKey = "Q",     左快捷键（不传PC默认显示Q，期望不显示则传NotShow）
--     RightKey = "E",    右快捷键（不传PC默认显示E，期望不显示则传NotShow）
--     GamePadLeftKey = "LB",     手柄左快捷键（不传PC默认显示LB，期望不显示则传NotShow）
--     GamePadRightKey = "RB",    手柄右快捷键（不传PC默认显示RB，期望不显示则传NotShow）
--     Tabs = {
--             Text = "任务", Tab文本
--             TabId = 1, Tab的Id,
--             ShowRedDot = 1/true, 显示红点,
--             IsNew = 1/true, 显示新道具图标
--             ShowRedDotNum = 10, 显示数量红点
--             IconPath = "/Game/UI/UI_PNG/Atlas/Tab/T_Tab_All.T_Tab_All", 图片路径
--             IsLocked = false, 是否此Tab仍处于锁定状态（true为锁定）
--             IsForbidden = false, 是否此Tab处于禁用状态（true为禁用，默认不禁用）
--             LockReasonText = GText("UI_RegionMap_MaxMark"), 未解锁点击提示文本
--     },
--     DynamicNode={
--             "Back", 返回按钮
--             "ResourceBar", 顶部资源条
--             "Tip", 信息按钮
--             "BottomKey", 下方提示文本
--     }, 需要动态添加的节点 （根据需要填入）
--     BottomKeyInfo = { {KeyInfoList = {{Type="Text", Text="Esc"}}, GamePadInfoList = {{Type="Img", ImgShortPath="B"}}, 
--                                              Desc=GText("")} }（BottomKey节点的额外信息（选择传入））
--     StyleName = "Text", 类型："Text"或 "Image" (各个Tab是Icon文本类型还是圆角图标类型)
--     TitleName = "Text", 标题名字
--     OverridenTopResouces = {101， 102}, 自定义顶部资源条（不填则默认用SystemUI表里的）
--     PopupInfoId = Number,       信息按钮的弹窗ID (如果不填，则会尝试从SystemUI表里去读取)
--     InfoCallback = function,    信息按钮的确认回调 (通常可以不填)
--     BackCallback = function,    返回按钮的回调
--     SoundFunc = function,       列表点击音效
--     HoverSoundFunc = function,  列表悬浮音效
--     SoundFuncReceiver = Obj,    列表点击音效接收对象
--     LastFocusWidget = Widget,   Tab上某些特殊状态返回之后，应该聚焦到哪个控件
--     GetReplyOnBack = function,  Tab上某些特殊状态返回时，用于获取事件回复，优先级比LastFocusWidget高
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
    -- 自定义顶部资源条
    self.OverridenTopResouces = ConfigData.OverridenTopResouces
    -- Popup弹窗ID
    self.PopupInfoId = ConfigData.PopupInfoId
    -- 初始化音效播放函数
    self.ClickSoundFunc = ConfigData.SoundFunc or self.PlayClickSound
    self.HoverSoundFunc = ConfigData.HoverSoundFunc
    self.SoundFuncReceiverObj = ConfigData.SoundFuncReceiver or self
    -- 返回之后聚焦的控件
    self.LastFocusWidget = ConfigData.LastFocusWidget or self.OwnerPanel
    -- 返回是用于获取事件回复的函数
    self.GetReplyOnBack = ConfigData.GetReplyOnBack
    -- 平台
    self.DeviceTypeByPlatformName = ConfigData.PlatformName or CommonUtils.GetDeviceTypeByPlatformName(self)
    -- 左下角图片路径
    self.IconSignPath = ConfigData.IconSignPath
    self.CurrentTab = nil
    self.bEnableSelectTab = true
    self.CurSelectMode = TabSelectStateEnum.SelectTab
    self.CurInputDeviceType = nil
    self.bShowBubble = ConfigData.bShowBubble
    self.BottomKeyWidget = {}
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
    EventManager:AddEvent(EventID.OnPropSetResources, self, self.OnPropSetResources)
    EventManager:AddEvent(EventID.OnChangeActionPoint, self, self.OnPropSetResources)
    -- EventManager:AddEvent(EventID.OpenChatView, self, self.OpenChatView)
    -- EventManager:AddEvent(EventID.InterruptChatView, self, self.InterruptChatView)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
end

function M:ClearListenEvent()
    EventManager:RemoveEvent(EventID.OnPropSetResources, self)
    EventManager:RemoveEvent(EventID.OnChangeActionPoint, self)
    -- EventManager:RemoveEvent(EventID.OpenChatView, self)
    -- EventManager:RemoveEvent(EventID.InterruptChatView, self)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end

    self.CurInputDeviceType = CurInputDevice
    self:UpdateTopRightTips()
    self:UpdateUIStyleInPlatform(self.CurInputDeviceType == ECommonInputType.Gamepad)
    self:UpdateHotKeyInfo(CurGamepadName)
end

function M:RefreshBaseInfo()
    -- 填充数据
    self:FillWithBaseInfo()
    -- 刷新左上方标题
    self:UpdateTopTitle()
    -- 刷新按键信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    -- 刷新左下角图片
    if (self.IconSignPath) then
        local IconSignTexture = LoadObject(self.IconSignPath)
        if (IsValid(IconSignTexture)) then
            self.Icon_Sign:SetBrushFromTexture(IconSignTexture)
        end
    end
end

function M:FillWithBaseInfo()
    -- 手柄相关内容设置
    local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
    self.ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
    self.ResourceBar:SetLastFocusWidget(self.LastFocusWidget)
    self.ResourceBar:SetGetReplyOnBack(self.GetReplyOnBack)

    local bAllowForbid = self.ConfigData.bAllowKeyForbid
    self.ResourceBar:InitGamePadTip({
        KeyInfo = {
            KeyInfoList = {
                {
                    Type = "Img",
                    ImgShortPath = "Menu",
                }
            },
            Desc = GText('UI_GACHA_DESDETAIL'),
            bAllowForbid = bAllowForbid,
        },
        ClickFuncObj = self,
        ClickFunc = self.OnInfoClick,
    })
end

-- 动态覆盖资源,注意需在ResetDynamicNode之前调用（还是建议直接在Init之中额外传入OverridenTopResouces）
function M:OverrideTopResource(OverridenTopResouces, bIsRequestRefresh)
    self.OverridenTopResouces = OverridenTopResouces
    -- 是否立即强制刷新
    if (bIsRequestRefresh) then
        self.ResourceBar:ClearChildren()
        local SystemUIConfig = DataMgr.SystemUI[self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName] or {}
        local TopResource = self.OverridenTopResouces or SystemUIConfig.TabCoin
        self.ResourceBar:InitResourceBar(TopResource)
    end
end

function M:ResetDynamicNode()
    local DynamicNodeName = {Panel_Back={NeedRemoveChild=true}, Panel_Key={ParentWidget="Com_KeyTips", NeedRemoveChild=true},}
    for k, v in pairs(DynamicNodeName) do
        if (v.ParentWidget ~= nil) then
            local TargetWidget = self[v.ParentWidget]
            if (TargetWidget[k] ~= nil) then
                if (v.NeedRemoveChild) then
                    TargetWidget[k]:ClearChildren()
                end
                TargetWidget[k]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            end
        else
            if (self[k] ~= nil) then
                if (v.NeedRemoveChild) then
                    self[k]:ClearChildren()
                end
                self[k]:SetVisibility(UIConst.VisibilityOp["Collapsed"])
            end 
        end
    end
    self.ResourceBar:ClearChildren()

    local CorrectTabLocation = function()
        local HBSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.HB)
        local HBPos = HBSlot:GetPosition()
        HBPos.X = 0
        HBSlot:SetPosition(HBPos)
    end

    if (self.ConfigData.DynamicNode == nil) then
        CorrectTabLocation()
        return
    end
    for i, v in ipairs(self.ConfigData.DynamicNode) do
        if (v == "Back") then
            if (not IsValid(self.BackWidget)) then
                self.BackWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Tab/PC/WBP_Com_TabBack_P.WBP_Com_TabBack_P', false)
            end
            self.Panel_Back:AddChild(self.BackWidget)
            self.BackWidget.TextBlock_Back:SetText(GText("UI_BACK"))
            self.BackWidget.Btn_Back.OnClicked:Clear()
            self.BackWidget.Btn_Back.OnClicked:Add(self, self.OnReturnClick)
            self.Panel_Back:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        elseif (v == "ResourceBar") then
            local SystemUIConfig = DataMgr.SystemUI[self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName] or {}
            local TopResource = self.OverridenTopResouces or SystemUIConfig.TabCoin
            self.ResourceBar:InitResourceBar(TopResource,self.bShowBubble)
        elseif (v == "BottomKey") then
            for i, KeyInfo in ipairs(self.ConfigData.BottomKeyInfo) do
                local BottomKeyWidget = self.BottomKeyWidget[i]
                if (not IsValid(BottomKeyWidget)) then
                    if KeyInfo.KeyInfoList and KeyInfo.KeyInfoList.SubKeyInfoList and not KeyInfo.Desc then
                        if KeyInfo.KeyInfoList[1].Type == "Add" then
                            BottomKeyWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Key/WBP_Com_KeyAdd.WBP_Com_KeyAdd_C', false)
                        else
                            BottomKeyWidget = UIManager(self):CreateWidget('/Game/UI/WBP/Common/Key/WBP_Com_KeyOr.WBP_Com_KeyOr_C', false)
                        end
                    else
                        BottomKeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
                    end
                    self.BottomKeyWidget[i] = BottomKeyWidget
                end
                self.Com_KeyTips.Panel_Key:AddChild(BottomKeyWidget)
            end
            self.Com_KeyTips.Panel_Key:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end
    -- 聊天相关，暂时注释
    -- local SystemUIConfig = DataMgr.SystemUI[self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName] or {}
    -- self.IsChat = SystemUIConfig.IsChat
    -- if self.IsChat then
    --     local ChatUI = UIManager(self):CreateWidget('/Game/UI/WBP/Chat/PC/WBP_Chat_CommonEnter_P.WBP_Chat_CommonEnter_P', false)
    --     self.Group_Chat:ClearChildren()
    --     self.Group_Chat:AddChildToOverlay(ChatUI)
    -- else
    --     self.Group_Chat:ClearChildren()
    -- end
    --@note 当不存在BackWidget时，则将Tab拉到前面去
    if not IsValid(self.BackWidget) then
        CorrectTabLocation()
    end
end

function M:SetBgRenderOpacity(Value)
    self.Bg_Bottom:SetRenderOpacity(Value)
    self.Bg_Top:SetRenderOpacity(Value)
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
end

function M:UpdateResource()
    -- 刷新右上方货币条
    self.ResourceBar:UpdateResource()
end

function M:UpdateTopTitle(TitleName)
    -- 更新标题信息(超过1个Item的则不显示标题)
    self.TitleName = TitleName or self.TitleName
    if (self.TitleName ~= nil) then
        self.Text_Title:SetText(self.TitleName)
        self.Text_Title:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"]) 
    else
        self.Text_Title:SetVisibility(UIConst.VisibilityOp["Collapsed"]) 
    end
end

function M:UpdateTopRightTips()
    -- 更新右上角信息
    local function RealUpdateTopRightTips()
        -- TODO 临时处理，后面把NotShow迭代了
        if (self.PopupInfoId ~= nil or type(self.InfoCallback) == "function") then
            if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
                self.ResourceBar:SwitchTipStyle(1)
            elseif (self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard) then
                self.ResourceBar:SwitchTipStyle(0)
            end
            self.ResourceBar:HideTip(false)
        else
            self.ResourceBar:HideTip(true)
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

function M:UpdateHotKeyInfo(CurGamepadName)
    -- 更新按键信息（PC/手柄）
    if (self.CurInputDeviceType == ECommonInputType.Gamepad)  then
        -- 手柄Tab切换按键提示图片
        self:FillWithBottomKeyInfoList(true)
        -- 手柄资源选择按键图片
        local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", CurGamepadName)
        self.ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
        if(self.ResourceBar:HasUserFocusedDescendants(self:GetOwningPlayer()))then
            self:EnterResourceSelectMode()
        end
        -- if self.IsChat then
        --     local Chat = self.Group_Chat:GetChildAt(0)
        --     Chat:RefreshKey(true)
        -- end
    else
        -- PC Tab切换按键提示图片
        self:FillWithBottomKeyInfoList(false)
        -- PC资源选择按键图片
        self:ExitResourceSelectMode()
        -- if self.IsChat then
        --     local Chat = self.Group_Chat:GetChildAt(0)
        --     Chat:RefreshKey(false)
        -- end
        --self.ResourceBar:HideGamePadKey(true)
    end
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
    local ActiveWidgetIndex = IsUseGamePad and 1 or 0
    -- 右上方快捷键
    self.ResourceBar:HideGamePadKey(not IsUseGamePad)
end

function M:CheckNeedHideChangeKey()
    local TabCount = self.Tabs and #self.Tabs or 0
    local IsNotShow = false

    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        IsNotShow = self.ConfigData.GamePadLeftKey == "NotShow" or self.ConfigData.GamePadRightKey == "NotShow"
    else
        IsNotShow = self.ConfigData.LeftKey == "NotShow" or self.ConfigData.RightKey == "NotShow"
    end

    if (IsNotShow or TabCount <= 1) then
        return true
    end
    return false
end

function M:FillWithBottomKeyInfoList(bIsGamePadKey)
    if (bIsGamePadKey)  then
        -- 手柄Tab切换按键提示图片
        for i, v in ipairs(self.BottomKeyWidget) do
            if (IsValid(v)) then
                local AllKeyInfoList = self.ConfigData.BottomKeyInfo[i]
                if not AllKeyInfoList.GamePadInfoList then
                    v:SetVisibility(UE4.ESlateVisibility.Collapsed)
                    goto continue0
                else
                    v:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                end
                if AllKeyInfoList.GamePadInfoList.GamePadSubKeyInfoList then
                    if AllKeyInfoList.Desc then
                        v:CreateSubKeyDesc({
                            KeyInfoList = AllKeyInfoList.GamePadInfoList.GamePadSubKeyInfoList,
                            Desc = AllKeyInfoList.Desc,
                            Type = AllKeyInfoList.GamePadInfoList[1].Type,
                            -- bLongPress = AllKeyInfoList.bLongPress,
                            -- bSpecialLongPress = AllKeyInfoList.bSpecialLongPress,
                        })
                    else
                        v:CreateCommonKey({
                            KeyInfoList = AllKeyInfoList.GamePadInfoList.GamePadSubKeyInfoList,
                        })
                    end
                else
                    v:CreateCommonKey({
                        KeyInfoList = AllKeyInfoList.GamePadInfoList,
                        Desc = AllKeyInfoList.Desc,
                        bLongPress = AllKeyInfoList.bLongPress,
                        bSpecialLongPress = AllKeyInfoList.bSpecialLongPress,
                    })
                end
                ::continue0::
            end
        end
    else
        -- PC Tab切换按键提示图片
        for i, v in ipairs(self.BottomKeyWidget) do
            if (IsValid(v)) then
                local AllKeyInfoList = self.ConfigData.BottomKeyInfo[i]
                if not AllKeyInfoList.KeyInfoList then 
                    v:SetVisibility(UE4.ESlateVisibility.Collapsed)
                    goto continue
                else
                    v:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
                end
                if AllKeyInfoList.KeyInfoList.SubKeyInfoList then
                    if AllKeyInfoList.Desc then
                    ---@type Common_Key_PC
                        v:CreateSubKeyDesc({
                            KeyInfoList = AllKeyInfoList.KeyInfoList.SubKeyInfoList,
                            Desc = AllKeyInfoList.Desc,
                            Type = AllKeyInfoList.KeyInfoList[1].Type
                        })
                    else
                        v:CreateCommonKey({
                            KeyInfoList = AllKeyInfoList.KeyInfoList.SubKeyInfoList,
                        })
                    end
                else
                    v:CreateCommonKey({
                        KeyInfoList = AllKeyInfoList.KeyInfoList,
                        Desc = AllKeyInfoList.Desc,
                        bLongPress = AllKeyInfoList.bLongPress,
                    })
                end
                ::continue::
            end
        end
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
    self.ScrollBox_Tab:ClearChildren()
    for i = 0, #Tabs - 1, 1 do
        local Child, TabItemClass = nil, nil
        TabItemClass = LoadClass("/Game/UI/WBP/Common/Tab/PC/WBP_Com_TabItem_SP_P.WBP_Com_TabItem_SP_P_C")
        if (TabItemClass ~= nil) then
            Child = UE4.UWidgetBlueprintLibrary.Create(self, TabItemClass)
            if (IsValid(Child)) then
                self.ScrollBox_Tab:AddChild(Child)
                Child:Update(i + 1,Tabs[i + 1])
                Child:BindEventOnSwitchOn(self,self.OnTabSwitchOn)
                Child:BindSoundFunc(self.ClickSoundFunc,self.SoundFuncReceiverObj)
                Child:BindHoverSoundFunc(self.HoverSoundFunc,self.SoundFuncReceiverObj)
            end
        end
    end

    -- 设置完成之后，遍历设置导航规则，往上是上面的那个tab，往下是下面那个Tab，
    for i = 0, #Tabs - 1, 1 do
        local CurrentChild = self.ScrollBox_Tab:GetChildAt(i)
        if IsValid(CurrentChild) then
            -- 设置向上导航
            if i == 0 then
                -- 第一个Tab向上导航设置为Stop
                CurrentChild:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
            else
                -- 其他Tab向上导航到上一个Tab
                local UpChild = self.ScrollBox_Tab:GetChildAt(i - 1)
                if IsValid(UpChild) then
                    CurrentChild:SetNavigationRuleExplicit(EUINavigation.Up, UpChild)
                end
            end
            
            -- 设置向下导航
            if i == #Tabs - 1 then
                -- 最后一个Tab向下导航设置为Stop
                CurrentChild:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
            else
                -- 其他Tab向下导航到下一个Tab
                local DownChild = self.ScrollBox_Tab:GetChildAt(i + 1)
                if IsValid(DownChild) then
                    CurrentChild:SetNavigationRuleExplicit(EUINavigation.Down, DownChild)
                end
            end
        end
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
    --组队相关弹窗打开时且手柄模式需要屏蔽相关操作..
    if TeamController:IsTeamPopupBarOpenInGamepad() then
        return
    end
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

function M:OnTabSwitchOn(TabWidget, CalledFromInputType)
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
function M:ClickTab(Idx)
    if(self.Tabs[Idx])then
        local ChildWidget = self.ScrollBox_Tab:GetChildAt(math.max(Idx - 1, 0))
        ChildWidget:Btn_Click()
        self.ScrollBox_Tab:ScrollWidgetIntoView(ChildWidget)
    end
end
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

function M:TabToUp()
    if (not self.bEnableSelectTab) then
        return
    end
    if (self.CurrentTab and self.CurrentTab - 1 >= 1 ) then
        for i = self.CurrentTab - 1, 1, -1 do
            local ChildWidget = self.ScrollBox_Tab:GetChildAt(i - 1)
            if (ChildWidget ~= nil) then
                if (ChildWidget:IsTabLocked()) then
                    -- 策划说不用继续寻找下一个可以选中的Tab
                    ChildWidget:SetSwitchOn(false, false)
                else
                    ChildWidget:SetSwitchOn(true, true)
                    self.ScrollBox_Tab:ScrollWidgetIntoView(ChildWidget)
                    self.ClickSoundFunc(self.SoundFuncReceiverObj,i)
                end
                break
            end
        end
    end
end

function M:TabToDown()
    if (not self.bEnableSelectTab) then
        return
    end
    if (self.CurrentTab and self.CurrentTab + 1 <= #self.Tabs) then
        for i = self.CurrentTab, #self.Tabs - 1, 1 do
            local ChildWidget = self.ScrollBox_Tab:GetChildAt(i)
            if (ChildWidget ~= nil) then
                if (ChildWidget:IsTabLocked()) then
                    -- 策划说不用继续寻找下一个可以选中的Tab
                    ChildWidget:SetSwitchOn(false, false)
                else
                    ChildWidget:SetSwitchOn(true, true)
                    self.ScrollBox_Tab:ScrollWidgetIntoView(ChildWidget)
                    self.ClickSoundFunc(self.SoundFuncReceiverObj,i + 1)
                end
                break
            end
        end
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
    if (self.BackWidget) then
        local img = LoadObject("/Game/UI/UI_PC/Common/Material/Noise/MI_Common_Noise_" .. AttrName .. ".MI_Common_Noise_" .. AttrName)
        self.BackWidget.VX_BackWave:SetBrushFromMaterial(img)
    end
end

function M:OnPropSetResources(ResourceId, OldValue)
    self.ResourceBar:OnPropSetResources(ResourceId, OldValue)
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

-----------------------------------------------输入事件相关------------------------------------------------
function M:Handle_KeyEventOnPC(InKeyName)
    local IsEventHandled = true
    -- 处理键盘相关的交互事件
    if (InKeyName == UE4.EKeys.Escape.KeyName) then
        self:OnReturnClick()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    local IsEventHandled = true
    -- 处理手柄相关的交互事件
    if (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        self:OnReturnClick()
    elseif (InKeyName == UIConst.GamePadKey.RightThumb) then
        self.ResourceBar:FocusToResource()
    elseif (InKeyName == UIConst.GamePadKey.SpecialRight) then
        self:OnInfoClick()
    else
        IsEventHandled = false
    end
    return IsEventHandled
end



-----------------------------------------------手柄相关------------------------------------------------

function M:ClickToLeftOnGamePad(OpType)
    -- 手柄向左选择
    --if (OpType == "Tab" and self.CurSelectMode == TabSelectStateEnum.SelectTab) then
        self:TabToLeft()
    --end
end

function M:ClickToRightOnGamePad(OpType)
    -- 手柄向右选择
    --if (OpType == "Tab" and self.CurSelectMode == TabSelectStateEnum.SelectTab) then
        self:TabToRight()
    --end
end

function M:OnResourceBarAddedToFocusPath()
    self:EnterResourceSelectMode()
end

function M:OnResourceBarRemovedFromFocusPath()
    self:ExitResourceSelectMode()
end

function M:EnterViewSingleMode(TitleName)
    local TabInfo = self.Tabs[self.CurrentTab]
    if (not TabInfo) then
        return
    end
    self.IsInViewSingleMode = true
    --self.Text_Title:SetText(self.TitleName.."/"..TabInfo.Text)
    if TitleName then
        self.Title_Tab:SetText(TitleName .. " / " .. TabInfo.Text)
    else
        self.Title_Tab:SetText(self.TitleName .. " / " .. TabInfo.Text)
    end
    self.ResourceBar:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:LeaveViewSingleMode()
    self.IsInViewSingleMode = false
    self.Text_Title:SetText(self.TitleName)
    self.ResourceBar:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
end

function M:EnterResourceSelectMode()
end

function M:ExitResourceSelectMode()
end

--- @param BottomKeyWidget Common_Key_PC 底部键对应的Widget
--- @param SingleKeyInfo table 单键信息
function M:SetSingleBottomKeyInfo(BottomKeyWidget, SingleKeyInfo)
    if (SingleKeyInfo.KeyInfoList == nil and SingleKeyInfo.GamePadInfoList == nil) then
        BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        return
    end

    if (self.CurInputDeviceType == ECommonInputType.Gamepad) then
        -- 当前是手柄模式
        if SingleKeyInfo.GamePadInfoList then
            if SingleKeyInfo.GamePadInfoList.GamePadSubKeyInfoList then
                if SingleKeyInfo.Desc then
                    BottomKeyWidget:CreateSubKeyDesc({
                        KeyInfoList = SingleKeyInfo.GamePadInfoList.GamePadSubKeyInfoList,
                        Desc = SingleKeyInfo.Desc,
                        Type = SingleKeyInfo.GamePadInfoList[1].Type
                    })
                else
                    BottomKeyWidget:CreateCommonKey({
                        KeyInfoList = SingleKeyInfo.GamePadInfoList.GamePadSubKeyInfoList,
                    })
                end
            else
                BottomKeyWidget:CreateCommonKey({
                    KeyInfoList = SingleKeyInfo.GamePadInfoList,
                    Desc = SingleKeyInfo.Desc
                })
            end
            BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    else
        -- 当前是鼠标和键盘模式
        if SingleKeyInfo.KeyInfoList then
            if SingleKeyInfo.KeyInfoList.SubKeyInfoList then
                if SingleKeyInfo.Desc then
                    ---@type Common_Key_PC
                    BottomKeyWidget:CreateSubKeyDesc({
                        KeyInfoList = SingleKeyInfo.KeyInfoList.SubKeyInfoList,
                        Desc = SingleKeyInfo.Desc,
                        Type = SingleKeyInfo.KeyInfoList[1].Type
                    })
                else
                    BottomKeyWidget:CreateCommonKey({
                        KeyInfoList = SingleKeyInfo.KeyInfoList.SubKeyInfoList,
                    })
                end
            else
                BottomKeyWidget:CreateCommonKey({
                    KeyInfoList = SingleKeyInfo.KeyInfoList,
                    Desc = SingleKeyInfo.Desc
                })
            end
            BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        else
            BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        end
    end
end

--- @param SubKeyIndex number 子键索引
--- @param SingleKeyInfo table 单键信息
function M:UpdateSingleBottomKeyInfo(SubKeyIndex, SingleKeyInfo)
    self.ConfigData.BottomKeyInfo[SubKeyIndex] = SingleKeyInfo
    local BottomKeyWidget = self.BottomKeyWidget[SubKeyIndex]
    if (BottomKeyWidget ~= nil) then
        if (SingleKeyInfo == nil) then
            BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        else
            self:SetSingleBottomKeyInfo(BottomKeyWidget, SingleKeyInfo)
        end
    else
        BottomKeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
        self.BottomKeyWidget[SubKeyIndex] = BottomKeyWidget
        self.Com_KeyTips.Panel_Key:AddChild(BottomKeyWidget)
        self:SetSingleBottomKeyInfo(BottomKeyWidget, SingleKeyInfo)
    end
end

-- 设置单个快捷键的可见性，要求该索引的快捷键存在
--- @param SubKeyIndex number 子键索引
function M:SetSingleBottomKeyInfoVisibility(SubKeyIndex, VisibilityOp)
    local BottomKeyWidget = self.BottomKeyWidget[SubKeyIndex]
    if BottomKeyWidget then 
        BottomKeyWidget:SetVisibility(VisibilityOp)
    end
end

--- @param BottomKeyInfo table 底部键信息
function M:UpdateBottomKeyInfo(BottomKeyInfo)
    self.ConfigData.BottomKeyInfo = BottomKeyInfo
    for i, KeyInfo in ipairs(BottomKeyInfo) do
        local BottomKeyWidget = self.BottomKeyWidget[i]
        if (not IsValid(BottomKeyWidget)) then
            BottomKeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
            self.BottomKeyWidget[i] = BottomKeyWidget
            self.Com_KeyTips.Panel_Key:AddChild(BottomKeyWidget)
        else
            BottomKeyWidget:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
    end

    for i = #BottomKeyInfo+1,#self.BottomKeyWidget do
        local BottomKeyWidget = self.BottomKeyWidget[i]
        if ( IsValid(BottomKeyWidget)) then
            BottomKeyWidget:RemoveFromParent()
        end
        self.BottomKeyWidget[i] = nil
    end
    self.Com_KeyTips.Panel_Key:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self:UpdateHotKeyInfo(self.CurInputDeviceType)
end

function M:UpdateBottomKeyInfo_Quick(Infos)
    local BottomKeyInfos = {}
    for Index, Info in ipairs(Infos) do
        local BottomKeyInfo = {
            GamePadInfoList = {
                {Type="Img",ImgShortPath=Info[1]}
            },
            Desc=Info[2]
        }
        table.insert(BottomKeyInfos, BottomKeyInfo)
    end
    self:UpdateBottomKeyInfo(BottomKeyInfos)
end

function M:SetBottomKeyInfoVisible(bVisible)
    if bVisible then 
        self.Com_KeyTips.Panel_Key:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else 
        self.Com_KeyTips.Panel_Key:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- function M:OpenChatView(InputKey)
--     local KeyName = InputKey
--     local SystemUIConfig = DataMgr.SystemUI[self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName] or {}
--     local IsChat = SystemUIConfig.IsChat
--     if IsChat then
--         if KeyName == "Enter" then
--             ChatController:OpenView(self)
--         else 
--             local Chat = self.Group_Chat:GetChildAt(0)
--             Chat.ControllerKeyImg:OnButtonPressed()
--         end
--     end
-- end

-- function M:InterruptChatView()
--     local SystemUIConfig = DataMgr.SystemUI[self.OwnerPanel.ConfigName or self.OwnerPanel.WidgetName] or {}
--     local IsChat = SystemUIConfig.IsChat
--     if IsChat then
--         local Chat = self.Group_Chat:GetChildAt(0)
--         Chat.ControllerKeyImg:OnButtonReleased()
--     end
-- end

--- 显示资源栏气泡提示    已在dynamicnode自动实现
---@param ResourceId 代币资源Id
---@param ConfigData table 气泡配置数据
-- function M:ShowResourceBubble(ResourceId, ConfigData)
--     self.ResourceBar:ShowResourceBubble(ResourceId, ConfigData)
-- end

-- function M:HideResourceBubble(ResourceId)
--     self.ResourceBar:HideResourceBubble(ResourceId)
-- end

--- 根据代币id，设置Tab顶部资源代币栏加号的显隐
---@param ResourceId 代币资源Id
---@param bVisible 是否显示
function M:SetResourceAddVisibleByResocurceId(ResourceId, bVisible)
    self.ResourceBar:SetResourceBarVisibility(ResourceId, bVisible)
end
---根据代币位置Index，设置Tab顶部资源代币栏加号的显隐
---@param Index 从左到右，从1开始
---@param bVisible 是否显示
function M:SetResourceAddVisibleByIndex(Index, bVisible)
    self.ResourceBar:SetResourceBarVisibilityByIndex(Index, bVisible)
end

return M

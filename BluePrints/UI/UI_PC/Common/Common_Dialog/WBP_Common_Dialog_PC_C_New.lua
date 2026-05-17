require "UnLua"

---@class Common_Dialog_Params_FundInfo
---@field FundId number @货币ID
---@field FundNeed number @需要的数量

---@class Common_Dialog_Params_ItemInfo 
---@field ItemId number @物品ID
---@field ItemType string @物品类型["Weapon" | "Mod" | "Resource"]
---@field ItemNum number @(可选)物品数量
---@field ItemNeed number @(可选)需要的物品数量
---@field ItemUuid number @(可选)物品的UuId

---@class Common_Dialog_Text03_ListViewContent 
---@field Title string @标题
---@field Text string @文本内容

---@class Common_Dialog_Params_PageFlipInfo 
---@field PageNumber number @页签总页数
---@field CurrentPage number @当前页签

---@class CountDownParams
---@field name string @倒计时名词
---@field RemainTime number @倒计时时间
---@field TimeIconPath string @(可选)倒计时图标路径

---@class Common_Dialog_Params 
---@field BindScript stirng @(可选) 通用弹窗绑定的脚本，将会在弹窗初始化完毕后执行脚本的Initialize方法
---@field IsHideBg bool @(可选)显隐Bg_Switch,true隐藏，false显示
---@field Title string @(可选)弹窗标题，覆盖表中内容
---@field TabConfigData table @(可选)若标题栏为通用Tab，则为通用Tab的初始化数据，详见WBP_Common_Dialog_Title_SubTab_PC_C.lua
---@field ShortText string @(可选)短文本内容，覆盖表中内容
---@field LongText string @(可选)长文本内容，覆盖表中内容
---@field HintText string @(可选)选择框文本内容，覆盖表中内容
---@field Text03_ListView Common_Dialog_Text03_ListViewContent[] @(可选) 带分割线的文本列表内容
---@field Tips string[] @(可选)Tip内容数组，覆盖表中内容
---@field HideItemTips bool @(可选) 初始化时是否隐藏Tip
---@field ItemList Common_Dialog_Params_ItemInfo[] @(可选)通用物品栏信息
---@field Funds Common_Dialog_Params_FundInfo[] @(可选)货币信息列表
---@field DynamicNodes table @(可选)动态挂接Widget列表，里面传组件实例
---@field NoButtonText string @(可选)左侧按钮文本内容，覆盖表中内容
---@field YesButtonText string @(可选)右侧按钮文本内容，覆盖表中内容
---@field ForbidLeftBtn bool @(可选) 设置左侧按钮禁用态
---@field ForbidRightBtn bool @(可选) 设置右侧按钮禁用态
---@field ButtonBarName string @(可选) 自定义按纽栏，对应CommonDialogContent表的ID，将指定控件替换到弹窗按钮栏
---@field PageFlipInfo Common_Dialog_Params_PageFlipInfo @(可选) 如果为页签模式，页签的页数
---@field ForbiddenLeftCallbackObj table @(可选)左侧按钮禁用态点击回调的接收对象
---@field ForbiddenLeftCallbackFunction function @(可选)左侧按钮禁用态点击的回调
---@field ForbiddenRightCallbackObj table @(可选)右侧按钮禁用态点击回调的接收对象
---@field ForbiddenRightCallbackFunction function @(可选)右侧按钮禁用态点击的回调
---@field LeftCallbackObj table @(可选)左侧按钮回调的接收对象
---@field LeftCallbackFunction function @(可选)左侧按钮的回调
---@field RightCallbackObj table @(可选)右侧按钮回调的接收对象
---@field RightCallbackFunction function @(可选)右侧按钮的回调
---@field CloseBtnCallbackObj table @(可选)右上角关闭按钮回调的接收对象
---@field CloseBtnCallbackFunction function @(可选)右上角关闭按钮回调
---@field OnCloseCallbackObj table @(可选)关闭结束回调的接收对象
---@field OnCloseCallbackFunction function @(可选)关闭结束按钮回调
---@field DontCloseWhenLeftBtnClicked bool @(可选)左侧按钮点击时不关闭弹窗
---@field DontCloseWhenRightBtnClicked bool @(可选)右侧按钮点击时不关闭弹窗
---@field OnKeyDownCallbackObj table @(可选)弹窗内按键回调的接收对象
---@field OnKeyDownCallbackFunction function @(可选)弹窗内按键时的回调
---@field OnMouseDownCallbackObj table @(可选)弹窗内鼠标回调的接收对象
---@field OnMouseDownCallbackFunction function @(可选)弹窗内鼠标时的回调
---@field DontPlayOutAnimation bool @(可选)关闭时不播放Out动画
---@field DontFocusParentWidget bool @(可选)关闭时不聚焦ParentWidget
---@field ShowParentTabCoin bool @(可选)显示父级Tab右上角的货币信息
---@field CountDownParams CountDownParams @(可选)倒计时组件参数，
---@field UseCachedWidget table @(可选)使用参数提供的控件，而非重新创建。key为控件的位置，value为控件对象
----------------------------------------------------------------手柄相关参数
---@field AutoFocus bool @(可选)弹窗打开时是否自动聚焦第一个控件
---@field ShowBKeyClose bool @(可选)在下方显示B键关闭
---@field DisableEscClose bool @(可选)禁用ESC关闭
---@field LeftGamepadImg string @(可选)左侧按钮手柄按键图标
---@field RightGamepadImg string @(可选)右侧按钮手柄按键图标
---@field LeftGamepadKey string @(可选)左侧按钮手柄按键重载
---@field RightGamepadKey string @(可选)右侧按钮手柄按键重载
-----------------------------------------------------------------弹窗表中支持的ExtraParams额外参数
---@field ShowBKeyClose bool 强制显示手柄按B关闭
---@field DisableEscClose bool 强制禁止弹窗ESC关闭
---@field FixTipHeight bool 给弹窗默认预留提示条高度
---@field NoButtonPCKey string 左侧按钮PC按键绑定
---@field YesButtonPCKey string 右侧按钮PC按键绑定


local DialogMinHeightWithButton = 136   -- 底部有按钮的最小高度
local DialogMinHeightWithoutButton = 216    -- 底部无按钮的最小高度
local DialogMinWidthNormal = 800 -- 普通尺寸弹窗的最小宽度
local DialogMinWidthBig = 1100 -- 大尺寸弹窗的最小宽度

local Rule = FSlateChildSize()
Rule.SizeRule = UE.ESlateSizeRule.Fill
Rule.Value = 1.0


---@class WBP_Common_Dialog_PC_C : WBP_Com_Dialog_C
local WBP_Common_Dialog_PC_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_Common_Dialog_PC_C:Initialize()
    self.Super.Initialize(self)
end

---@param PopupId number @ 创建弹窗所需的参数
---@param Params Common_Dialog_Params
function WBP_Common_Dialog_PC_C:OnLoaded(PopupId, Params, ParentWidget)
    self.Super.OnLoaded(self)
    ---ParentWidget被卸载时，弹窗也跟着关了
    self:AddDispatcher(EventID.UnLoadUI,self,function(self, UIName)
        if IsValid(ParentWidget) and UIName == ParentWidget.WidgetName then
            self:OnClose()
        end
    end)
    self.PopupQueue = self.PopupQueue or {}
end

-- 关闭当前弹窗，根据新参数显示一个新的弹窗，当新弹窗关闭后，重新打开当前弹窗
-- 注意重新打开当前弹窗后，数据都会被重置
function WBP_Common_Dialog_PC_C:ShowPopupInterrupt(PopupId, Params, ParentWidget)
    if #self.PopupQueue <= 0 then 
        self:ShowPopup(PopupId, Params, ParentWidget)
    end

    table.insert(self.PopupQueue, 1, {PopupId, Params, ParentWidget})
    table.insert(self.PopupQueue, 1, {})    -- Dummy
    self:OnClose()
end

-- 插队显示新弹窗，不关闭当前弹窗
function WBP_Common_Dialog_PC_C:ShowPopupPush(PopupId, Params, ParentWidget)
    self.PopupQueue = self.PopupQueue or {}
    if #self.PopupQueue <= 0 then 
        self:ShowPopup(PopupId, Params, ParentWidget)
        return
    end
    table.insert(self.PopupQueue, 1, {PopupId, Params, ParentWidget})
    self:InitView(PopupId, Params, ParentWidget)
end

-- 移除最上面这个弹窗
function WBP_Common_Dialog_PC_C:RemoveFirstItemInPopupQueue()
    table.remove(self.PopupQueue, 1)
end

function WBP_Common_Dialog_PC_C:ShowPopup(PopupId, Params, ParentWidget)
    table.insert(self.PopupQueue, {PopupId, Params, ParentWidget})
    if #self.PopupQueue == 1 then 
        self:InitView(PopupId, Params, ParentWidget)
    end
end

-- 如果有其他弹窗正在排队，则显示出来
function WBP_Common_Dialog_PC_C:ShowNextPopup()
    self.PopupQueue = self.PopupQueue or {}
    table.remove(self.PopupQueue, 1)
    if #self.PopupQueue > 0 then 
        local PopupParam = self.PopupQueue[1]
        self:SetFocus()
        self:InitView(PopupParam[1], PopupParam[2], PopupParam[3])
    else 
        self.Super.Close(self)
    end
end


function WBP_Common_Dialog_PC_C:InitView(PopupId, Params, ParentWidget)
    if ParentWidget then self.ParentWidget = ParentWidget end
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/window_filter_common", "CommonDialogIn", nil)
    self.CloseMask.OnPressed:Add(self, self.OnCloseMaskClicked)

    self.ResourceBarWidget = {}
    self.ContentWidgetTable = {}
    self.Contents = {}
    self.Tips = {}
    self.Panel_ResourceBar:ClearChildren()
    self.Panel_ResourceBar:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:RefreshView(PopupId, Params)
    
    -- 如果有绑脚本，在弹窗初始化完成后尝试加载脚本并调用Initialize方法
    if Params and Params.BindScript then
        self.Script = require(Params.BindScript)
        if self.Script then
            self.Script:BindDialogWidget(PopupId, self)
            self.Script:Initialize()
            DebugPrint("Tianyi@ 弹窗成功绑定脚本: ", Params.BindScript)
        end
    end
end

function WBP_Common_Dialog_PC_C:RefreshView(PopupId, Params)
    self.ContentWidgetTable = {}
    self:ClearDelegates()
    
    self.Index2GamepadShortcut = {
        self.Gamepad_Shortcut01,
        self.Gamepad_Shortcut02,
        self.Gamepad_Shortcut03,
        self.Gamepad_Shortcut04,
        self.Gamepad_Shortcut05,
        }
        for Index = 1, #self.Index2GamepadShortcut do 
            self:HideGamepadShortcut(Index)
        end
        
    self:HideAllGamepadShortcut()
    local PopupData = DataMgr.CommonPopupUIContext[PopupId]
    if PopupData and PopupData.Style then 
        self:UpdateView(PopupData.Style, Params, PopupData)
    else 
        DebugPrint("Tianyi@ PopupData is nil")
    end
    
    self:RefreshOpInfoByInputDevice()
end

-- 作为一个独立Widget显示出来，隐藏掉大部分不需要的控件
function WBP_Common_Dialog_PC_C:InitWidgetView(PopupId, Params)
    self.IsWidgetView = true

    self.ResourceBarWidget = {}
    self.ContentWidgetTable = {}
    self.Contents = {}
    self.Tips = {}
    self.Panel_ResourceBar:ClearChildren()
    self.Panel_ResourceBar:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:RefreshView(PopupId, Params)
    self.CloseMask:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WBP_Com_Bg:SetVisibility(UE4.ESlateVisibility.Collapsed)

end

function WBP_Common_Dialog_PC_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    if self.CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
        self:InitGamepadView(self.CurGamepadName)
    else
        self:InitKeyboardView(self.CurGamepadName)
    end
end
        
function WBP_Common_Dialog_PC_C:InitKeyboardView(CurGamepadName)
    self.Switcher_Text:SetActiveWidgetIndex(0)
    for _, ContentWidget in pairs(self.ContentWidgetTable) do
        if ContentWidget.InitKeyboardView then 
            ContentWidget:InitKeyboardView()
        end
    end
end 

function WBP_Common_Dialog_PC_C:InitGamepadView(CurGamepadName)
    self.Switcher_Text:SetActiveWidgetIndex(1)

    local ForceShow = self.Params.ShowBKeyClose
    local HasCloseBtn = not self.PopupData.NotShowCloseButton   -- 是否显示关闭按钮
    local HasQuitTip = self.PopupData.ShowQuitTip               -- 是否显示退出提示
    local HasButtonBar = self.ButtonBar                         -- 是否显示按钮栏
    
    -- 判断是否要显示按B关闭提示
    if ForceShow ~= nil then
        self:ShowGamepadCloseBtn(ForceShow)
    else
        self:ShowGamepadCloseBtn(((HasCloseBtn or HasQuitTip) and not HasButtonBar))
    end

    -- 聚焦第一个控件
    if self.Params and self.Params.AutoFocus and self.VB_Node:GetChildrenCount() > 2 then 
        local Widget = self.VB_Node:GetChildAt(1)
        Widget:SetFocus()
    end

    for _, ContentWidget in pairs(self.ContentWidgetTable) do
        if ContentWidget.InitGamepadView then 
            ContentWidget:InitGamepadView()
        end
    end

end
        
function WBP_Common_Dialog_PC_C:AddEventListener(EventName, ListenerObj, ListenerFunc)
    if not self.EventListenerMap[EventName] then 
        self.EventListenerMap[EventName] = {}
    end

    table.insert(self.EventListenerMap[EventName], {
        ListenerObj = ListenerObj, 
        ListenerFunc = ListenerFunc
    })
end

function WBP_Common_Dialog_PC_C:RemoveEventListener(EventName)
    self.EventListenerMap[EventName] = nil
end

function WBP_Common_Dialog_PC_C:BroadcastDialogEvent(EventName, ...)
    local EventListeners = self.EventListenerMap[EventName] 
    if EventListeners then 
        for _, Listener in ipairs(EventListeners) do 
            Listener.ListenerFunc(Listener.ListenerObj, ...)
        end
    end
end

-- 清掉一些之前绑定的委托, 用于复用弹窗
function WBP_Common_Dialog_PC_C:ClearDelegates()
    self.CloseBtnCallbackObj = nil
    self.CloseBtnCallbackFunction = nil

    self.OnCloseCallbackObj = nil
    self.OnCloseCallbackFunction = nil

    self.OnKeyDownCallbackObj = nil
    self.OnKeyDownCallbackFunction = nil
    self.OnMouseDownCallbackObj = nil 
    self.OnMouseDownCallbackFunction = nil
    self.OnKeyUpCallbackObj = nil
    self.OnKeyUpCallbackFunction = nil

    self.RightBtnCallbackObj = nil
    self.RightBtnClickedCallback = nil
    self.ForbiddenRightBtnCallbackObj = nil
    self.ForbiddenRightBtnClickedCallback = nil
    self.DontCloseWhenRightBtnClicked = false 

    self.LeftBtnCallbackObj = nil
    self.LeftBtnClickedCallback = nil
    self.ForbiddenLeftBtnCallbackObj = nil
    self.ForbiddenLeftBtnClickedCallback = nil
    self.DontCloseWhenLeftBtnClicked = false 

    self.DontPlayOutAnimation = false
    self.DontFocusParentWidget = false

    self.IsClosing = false 
end

---@param PopupStyleID number @ 样式ID
---@param Params Common_Dialog_Params @ 程序提供的额外参数
---@params PopupData table @ 表中参数
function WBP_Common_Dialog_PC_C:UpdateView(PopupStyleID, Params, PopupData)
    if PopupStyleID and not PopupData then 
        PopupData = {Style = PopupStyleID}
    end

    self.ResourceBarWidget = {}
    self.Tips = {}
    self.ContentWidgetTable = {}
    self.EventListenerMap = {}
    self.PackageFuncs = {}
    self.Contents = {}
    self.CurItemIndex = nil 
    self.PopupData = PopupData
    self.Params = Params or {}
    
    for k, v in pairs(PopupData.ExtraParams or {}) do 
        self.Params[k] = v
    end
    

    local PopupStyle = DataMgr.CommonPopupUIStyle[PopupStyleID]
    if not PopupStyle then
        DebugPrint("Tianyi@ 找不到 " .. tostring(PopupStyleID) .. " 对应的弹窗样式")
        return
    end

    self.PopupStyle = PopupStyle

    if Params then 
        self.CloseBtnCallbackObj = Params.CloseBtnCallbackObj
        self.CloseBtnCallbackFunction = Params.CloseBtnCallbackFunction
        self.OnCloseCallbackObj = Params.OnCloseCallbackObj
        self.OnCloseCallbackFunction = Params.OnCloseCallbackFunction
        self.OnKeyDownCallbackObj = Params.OnKeyDownCallbackObj
        self.OnKeyDownCallbackFunction = Params.OnKeyDownCallbackFunction
        self.OnMouseDownCallbackObj = Params.OnMouseDownCallbackObj 
        self.OnMouseDownCallbackFunction = Params.OnMouseDownCallbackFunction
        self.OnKeyUpCallbackObj = Params.OnKeyUpCallbackObj
        self.OnKeyUpCallbackFunction = Params.OnKeyUpCallbackFunction
        self.DontPlayOutAnimation = Params.DontPlayOutAnimation
        self.DontFocusParentWidget = Params.DontFocusParentWidget
    end


    -- 初始化按钮栏
    self.Pos_Btn:ClearChildren()
    local ButtonBarWidgetName = nil 
    if Params and Params.ButtonBarName then 
        ButtonBarWidgetName = Params.ButtonBarName
    elseif PopupStyle.ShowLeftButton or PopupStyle.ShowRightButton or PopupStyle.ShowFlipPage then 
        ButtonBarWidgetName = "Dialog_Button"
    end

    self.ButtonBar = nil
    if ButtonBarWidgetName then 
        local ButtonBar = self:CreateContentWidget(ButtonBarWidgetName)
        if ButtonBar then
            self.Pos_Btn:AddChild(ButtonBar)
            ButtonBar:InitContent(Params, PopupData, self)
            local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(ButtonBar)
            OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
            self:RegisterContentWidget("Dialog_Button", ButtonBar)
            self.ButtonBar = ButtonBar
        end
    end

    if Params then 
        self.LeftBtnCallbackObj = Params.LeftCallbackObj
        self.LeftBtnClickedCallback = Params.LeftCallbackFunction
        self.ForbiddenLeftBtnCallbackObj = Params.ForbiddenLeftCallbackObj
        self.ForbiddenLeftBtnClickedCallback = Params.ForbiddenLeftCallbackFunction
        self.DontCloseWhenLeftBtnClicked = Params.DontCloseWhenLeftBtnClicked

        self.RightBtnCallbackObj = Params.RightCallbackObj
        self.RightBtnClickedCallback = Params.RightCallbackFunction
        self.ForbiddenRightBtnCallbackObj = Params.ForbiddenRightCallbackObj
        self.ForbiddenRightBtnClickedCallback = Params.ForbiddenRightCallbackFunction
        self.DontCloseWhenRightBtnClicked = Params.DontCloseWhenRightBtnClicked
    end

    -- 显示标题
    self.Pos_Title:ClearChildren()
    local DialogTitle = nil
    if PopupStyle.UseTabTitle then 
        DialogTitle = self:CreateContentWidget("Dialog_Title_SubTab")
    else 
        DialogTitle = self:CreateContentWidget("Dialog_Title")
    end
    if DialogTitle then
        self.Pos_Title:AddChild(DialogTitle)
        DialogTitle:InitContent(Params, PopupData, self)
        DialogTitle:BindOnCloseButtonClicked(self, self.OnCloseBtnClicked)
        local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(DialogTitle)
        OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
        OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        self:RegisterContentWidget("DialogTitle", DialogTitle)
        self.DialogTitle = DialogTitle
    end
    
    for i = 1, self.VB_Node:GetChildrenCount() - 2 do 
        self.VB_Node:RemoveChildAt(1)
    end
    if PopupStyle.ShowContent then
        self.VB_Node:RemoveChildAt(self.VB_Node:GetChildrenCount() - 1)
        local ContentWidget = nil
        for Index, ContentTypeIdx in ipairs(PopupStyle.ShowContent) do 
            if Params and Params.UseCachedWidget and Params.UseCachedWidget[Index] then
                ContentWidget = Params.UseCachedWidget[Index]
            else
                ContentWidget = self:CreateContentWidget(ContentTypeIdx)
            end
            
            if ContentWidget then 
                self.VB_Node:AddChild(ContentWidget)
                self:RegisterContentWidget(ContentTypeIdx, ContentWidget)
                table.insert(self.Contents, ContentWidget)
            end
        end
        self.VB_Node:AddChild(self.Spacer_VBNode_Botton)
    end

    self.Pos_Tips:ClearChildren()
    if PopupStyle.ShowTip then 
        self.Pos_Tips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        for Index, ContentTypeIdx in ipairs(PopupStyle.ShowTip) do 
            local TipWidget = self:CreateContentWidget(ContentTypeIdx)
            if TipWidget then 
                self.Pos_Tips:AddChild(TipWidget)
                self:RegisterContentWidget(ContentTypeIdx, TipWidget)
                table.insert(self.Tips, TipWidget)
            else
                DebugPrint("Tianyi@ 在弹窗控件表中找不到ContentId: " .. ContentTypeIdx)
            end
        end

        local AllChildrend = self.Pos_Tips:GetAllChildren()
        local Length = AllChildrend:Length()
        for i = 1, Length do 
            local TipWidget = AllChildrend:GetRef(i)
            ---@type UOverlaySlot
            local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(TipWidget)
            OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
            OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        end
    else
        self.Pos_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self.Pos_BGEffect:ClearChildren()
    if PopupStyle.ShowBG then
        local BGWidget = UIManager(self):_CreateWidgetNew(PopupStyle.ShowBG)
        if BGWidget then
            self.Pos_BGEffect:AddChild(BGWidget)
        else
            DebugPrint(LogTag.Error, "Tianyi@ 创建BG控件失败", PopupStyle.ShowBG)
        end
    end

    -- 初始化Content和Tip
    local AllChildrend = self.VB_Node:GetAllChildren()
    local Length = AllChildrend:Length()
    for i = 2, Length - 1 do
        local ContentWidget = AllChildrend:GetRef(i)
        if ContentWidget.PreInitContent then 
            ContentWidget:PreInitContent(Params, PopupData, self)
        end
            -- 如果支持返回内部信息
        if ContentWidget.PackageData then 
            local PackageFunc = function()
                return ContentWidget.PackageKey or "Content_"..(i - 1), ContentWidget:PackageData()
            end
            table.insert(self.PackageFuncs, PackageFunc)
        end
    end

    local AllChildrend = self.Pos_Tips:GetAllChildren()
    local Length = AllChildrend:Length()
    for i = 1, Length do 
        local TipWidget = AllChildrend:GetRef(i)
        if TipWidget.PreInitContent then 
            TipWidget:PreInitContent(Params, PopupData, self)
        end
        -- 如果支持返回内部信息
        if TipWidget.PackageData then 
            local PackageFunc = function()
                return TipWidget.PackageKey or "Tip_"..i, TipWidget:PackageData()
            end
            table.insert(self.PackageFuncs, PackageFunc)
        end 
    end

    local AllChildrend = self.VB_Node:GetAllChildren()
    local Length = AllChildrend:Length()
    for i = 2, Length - 1 do
        local ContentWidget = AllChildrend:GetRef(i)
        if ContentWidget.InitContent then 
            ContentWidget:InitContent(Params, PopupData, self)
        end
    end

    local AllChildrend = self.Pos_Tips:GetAllChildren()
    local Length = AllChildrend:Length()
    for i = 1, Length do 
        local TipWidget = AllChildrend:GetRef(i)
        if TipWidget.InitContent then 
            TipWidget:InitContent(Params, PopupData, self)
        end
    end

    -- 显示右上角资源栏
    local TopResources = nil
    if PopupData and PopupData.TabCoin then 
        TopResources = PopupData.TabCoin
    end
    if Params and Params.ShowParentTabCoin and self.ParentWidget then 
        local ConfigName = self.ParentWidget.ConfigName 
        if ConfigName and DataMgr.SystemUI[ConfigName] then 
            local SystemUIConfig = DataMgr.SystemUI[ConfigName]
            TopResources = SystemUIConfig.TabCoin
            if self.ParentWidget.GetOverrideTopResource then
                TopResources = self.ParentWidget:GetOverrideTopResource() or TopResources
            end
        end
    end
    if TopResources then 
        local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
        self.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Visible)
        self.WBP_Com_Tab_Node_ResourceBar:InitResourceBar(TopResources)
        self.WBP_Com_Tab_Node_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
        self.WBP_Com_Tab_Node_ResourceBar:SetLastFocusWidget(self)
    else
        self.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if Params and Params.bHideDialogItem then
        self:BroadcastDialogEvent(DialogEvent.HideDialogItem, Params)
    end

    self.CloseMask.OnClicked:Clear()
    if PopupData.ShowQuitTip then 
        self.Text_Tips:SetText(GText("UI_TRAIN_CLOSE"))
        self.Panel_Tips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.CloseMask.OnPressed:Add(self, self.OnCloseMaskClicked)
        self.CloseMask:SetVisibility(UE4.ESlateVisibility.Visible)
    else
        self.Panel_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.CloseMask:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if PopupStyle.ShowContent then 
        local AllChildrend = self.VB_Node:GetAllChildren()
        local Length = AllChildrend:Length()
        for i = 2, Length - 1 do
            local ContentWidget = AllChildrend:GetRef(i)
            if ContentWidget.PostInitContent then 
                ContentWidget:PostInitContent(Params, PopupData, self)
            end
        end
    end


    self:AutofitDialog(PopupStyle)
end

function WBP_Common_Dialog_PC_C:BP_GetDesiredFocusTarget()
    -- 依次遍历Content控件，若有一个控件希望被聚焦，则聚焦在它身上
    if not self.ContentWidgetTable then return end
    local ContentWidgetDesiredFocusTarget = nil
    for _, ContentWidget in pairs(self.ContentWidgetTable) do
        if ContentWidget.HandleDialogFocused then 
            ContentWidgetDesiredFocusTarget = ContentWidget:HandleDialogFocused()
            if ContentWidgetDesiredFocusTarget then 
                DebugPrint("Tianyi@ 弹窗控件: " .. ContentWidget:GetName() .. " Handle了弹窗的聚焦, 新聚焦为: " .. ContentWidgetDesiredFocusTarget:GetName())
                break
            end
        end
    end

    return ContentWidgetDesiredFocusTarget 
end


function WBP_Common_Dialog_PC_C:PrintVBNode()
    local Length = self.VB_Node:GetChildrenCount()
    for i = 0, Length - 1 do 
        local Child = self.VB_Node:GetChildAt(i)
        DebugPrint("Tianyi Child " .. tostring(i) .. " : " .. tostring(Child.Name))
    end
end

-- 根据策划配置，自动适配弹窗细节样式
function WBP_Common_Dialog_PC_C:AutofitDialog()
    -- 如果不显示按钮拦，则显示圆角边缘
    if self.Pos_Btn:GetChildrenCount() <= 0 then
        self.Bg_Switch:SetActiveWidgetIndex(1)
        self.Switcher_Light:SetActiveWidgetIndex(1)
        self.Size_Bg:SetMinDesiredHeight(DialogMinHeightWithoutButton)
    else
        self.Bg_Switch:SetActiveWidgetIndex(0)
        self.Switcher_Light:SetActiveWidgetIndex(0)
        self.Size_Bg:SetMinDesiredHeight(DialogMinHeightWithButton)
    end

    if self.PopupStyle.BigSize then 
        self.Size_Bg:SetMinDesiredWidth(DialogMinWidthBig)
    else 
        self.Size_Bg:SetMinDesiredWidth(DialogMinWidthNormal)
    end

    if self.Params.FixTipHeight then   -- 默认预留Tips高度
        self.Spacer_VBNode_Top:SetSize(UE4.FVector2D(0, self.Spacer_VBNode_Top_Y_Large))
        self.Spacer_VBNode_Botton:SetSize(UE4.FVector2D(0, self.Spacer_VBNode_Botton_Y_Large))
    else
        local AllChildrend = self.Pos_Tips:GetAllChildren()
        local Length = AllChildrend:Length()
        local HasTipWidgetVisible = false
        for i = 1, Length do 
            local TipWidget = AllChildrend:GetRef(i)
            local WidgetVisibility = TipWidget:GetVisibility()
            if WidgetVisibility == UE4.ESlateVisibility.Visible or WidgetVisibility == UE4.ESlateVisibility.SelfHitTestInvisible then 
                HasTipWidgetVisible = true
                break
            end
        end
    
        if self.PopupStyle.ShowTip and HasTipWidgetVisible then 
            self.Spacer_VBNode_Top:SetSize(UE4.FVector2D(0, self.Spacer_VBNode_Top_Y_Large))
            self.Spacer_VBNode_Botton:SetSize(UE4.FVector2D(0, self.Spacer_VBNode_Botton_Y_Large))
        else 
            self.Spacer_VBNode_Top:SetSize(UE4.FVector2D(0, self.Spacer_VBNode_Top_Y_Normal))
            self.Spacer_VBNode_Botton:SetSize(UE4.FVector2D(0, self.Spacer_VBNode_Botton_Y_Normal))
        end
    end
end


-- 收集弹窗内所有需要返回的信息，在窗口关闭时作为参数发给回调 
function WBP_Common_Dialog_PC_C:PackageResult()
    -- 如果脚本重载了PackageData，则优先使用脚本的逻辑
    if self.Script and self.Script.PackageData then
        local Data = self.Script:PackageData()
        if Data then return Data end
    end
    
    local Result = {}
    for _, Func in ipairs(self.PackageFuncs) do 
        local PackageName, PackageValue = Func()
        if PackageName and PackageValue then 
            Result[PackageName] = PackageValue 
        end
    end

    return Result
end

function WBP_Common_Dialog_PC_C:OnMouseButtonDown(MyGeometry, InPointerEvent)
    local IsContentWidgetHandled = false
    for _, ContentWidget in pairs(self.ContentWidgetTable) do
        if ContentWidget.OnContentMouseButtonDown then 
            IsContentWidgetHandled = ContentWidget:OnContentMouseButtonDown(MyGeometry, InPointerEvent)
            if IsContentWidgetHandled then 
                return UE4.UWidgetBlueprintLibrary.Handled()
            end
        end
    end
    if self.OnMouseDownCallbackFunction then
        self.OnMouseDownCallbackFunction(self.OnMouseDownCallbackObj, MyGeometry, InPointerEvent)
    end

    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function WBP_Common_Dialog_PC_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsContentWidgetHandled = false
    for _, ContentWidget in pairs(self.ContentWidgetTable) do
        if ContentWidget.OnContentPreviewKeyDown then 
            IsContentWidgetHandled = ContentWidget:OnContentPreviewKeyDown(MyGeometry, InKeyEvent)
            if IsContentWidgetHandled then 
                return UE4.UWidgetBlueprintLibrary.Handled()
            end
        end
    end

    if InKeyName == self.Params.NoButtonPCKey or InKeyName == self.Params.YesButtonPCKey then
        -- 如果指定了PC端的按钮按键，优先处理
        local ButtonBar = self:GetButtonBar()
        if ButtonBar then
            if InKeyName == self.Params.NoButtonPCKey then
                ButtonBar:SimulateLeftBtnClick()
            else
                AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
                ButtonBar:SimulateRightBtnClick()
            end
            return UE4.UWidgetBlueprintLibrary.Handled()
        end
    end

    return UE4.UWidgetBlueprintLibrary.UnHandled()
end



function WBP_Common_Dialog_PC_C:OnKeyDown(MyGeometry, InKeyEvent)
    if self.IsClosing then return UE4.UWidgetBlueprintLibrary.Handled() end 

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if self.OnKeyDownCallbackFunction then
        self.OnKeyDownCallbackFunction(self.OnKeyDownCallbackObj,InKeyName)
    end

    local IsContentWidgetHandled = false
    for _, ContentWidget in pairs(self.ContentWidgetTable) do
        if ContentWidget.OnContentKeyDown then 
            IsContentWidgetHandled = ContentWidget:OnContentKeyDown(MyGeometry, InKeyEvent)
            if IsContentWidgetHandled then 
                return UE4.UWidgetBlueprintLibrary.Handled()
            end
        end
    end

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        local res = self:ProcessGamepadKeydown(InKeyName)
        if res then return UE4.UWidgetBlueprintLibrary.Handled() end
    else
        if InKeyName == "Escape" and not self.Params.DisableEscClose then
            if self.IsClosing then return UE4.UWidgetBlueprintLibrary.Handled() end
            if self.CloseBtnCallbackFunction then
                local Data = self:PackageResult()
                self.CloseBtnCallbackFunction(self.CloseBtnCallbackObj,Data)
            end

            self:OnClose()
        end
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

function WBP_Common_Dialog_PC_C:ProcessGamepadKeydown(InKeyName)
    local ButtonBar = self:GetButtonBar()
    local RightBtnKey = Const.GamepadFaceButtonDown
    if self.Params and self.Params.RightGamepadKey then
        RightBtnKey = self.Params.RightGamepadKey
    end

    local LeftBtnKey = Const.GamepadFaceButtonRight
    if self.Params and self.Params.LeftGamepadKey then
        LeftBtnKey = self.Params.LeftGamepadKey
    end

    if InKeyName == Const.GamepadFaceButtonRight and self.GamepadCloseBtnIndex then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", nil, nil)
        self:OnCloseBtnClicked()
        return true
    elseif InKeyName == RightBtnKey then
        if self.PopupStyle.ShowRightButton then 
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
            if ButtonBar then
                ButtonBar:SimulateRightBtnClick()
            end
            return true
        end
    elseif InKeyName == LeftBtnKey then
        if self.PopupStyle.ShowLeftButton then 
            if ButtonBar then
                ButtonBar:SimulateLeftBtnClick()
            end
        end
        return true
    elseif InKeyName == Const.GamepadRightThumbstick then 
        self.WBP_Com_Tab_Node_ResourceBar:FocusToResource()
        return true
    end
    return false
end

function WBP_Common_Dialog_PC_C:OnKeyUp(MyGeometry, InKeyEvent)
    if self.IsClosing then return UE4.UWidgetBlueprintLibrary.Handled() end 

    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    for _, ContentWidget in pairs(self.ContentWidgetTable) do
        if ContentWidget.OnContentKeyUp then 
            local IsContentWidgetHandled = ContentWidget:OnContentKeyUp(MyGeometry, InKeyEvent)
            if IsContentWidgetHandled then 
                return UE4.UWidgetBlueprintLibrary.Handled()
            end
        end
    end

    if self.OnKeyUpCallbackFunction then
        self.OnKeyUpCallbackFunction(self.OnKeyUpCallbackObj,InKeyName)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
end

function WBP_Common_Dialog_PC_C:OnLeftBtnClicked()
    if self.IsClosing then return end
    if not self.PopupStyle.ShowLeftButton then return end
    self:BroadcastDialogEvent(DialogEvent.OnLeftBtnClicked)
    if self.LeftBtnClickedCallback then 
        local Data = self:PackageResult()
        self.LeftBtnClickedCallback(self.LeftBtnCallbackObj, Data, self)
    end

    if self.DontCloseWhenLeftBtnClicked then
        return
    end

    self:OnClose()
end

function WBP_Common_Dialog_PC_C:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then 
        if IsValid(self.ParentWidget) and (self.ParentWidget.bIsFocusable) and (not self.DontFocusParentWidget)then 
            if (type(self.ParentWidget.SetFocus_Lua) == "function") then
                self.ParentWidget:SetFocus_Lua()
            else
                self.ParentWidget:SetFocus()
            end
        end
        self:ShowNextPopup()
    end
end

function WBP_Common_Dialog_PC_C:OnRightBtnClicked()
    if self.IsClosing then return end
    if not self.PopupStyle.ShowRightButton then return end
    self:BroadcastDialogEvent(DialogEvent.OnRightBtnClicked)
    if self.RightBtnClickedCallback then 
        local Data = self:PackageResult()
        self.RightBtnClickedCallback(self.RightBtnCallbackObj,Data, self)
    end

    if self.DontCloseWhenRightBtnClicked then
        return
    end

    self:OnClose()
end

function WBP_Common_Dialog_PC_C:OnCloseMaskClicked()
    if (not self.PopupData.ShowQuitTip) or UIManager(self):IsHaveMenuAnchorOpen() then 
        return 
    end
    self:OnCloseBtnClicked()
end

function WBP_Common_Dialog_PC_C:OnCloseBtnClicked()
    if self.CloseBtnCallbackFunction then
        local Data = self:PackageResult() 
        self.CloseBtnCallbackFunction(self.CloseBtnCallbackObj, Data, self)
    end

    self:OnClose()
end

function WBP_Common_Dialog_PC_C:OnForbiddenLeftBtnClicked()
    if self.IsClosing then return end
    if self.ForbiddenLeftBtnClickedCallback then 
        local Data = self:PackageResult()
        self.ForbiddenLeftBtnClickedCallback(self.ForbiddenLeftBtnCallbackObj, Data, self)
    elseif self.PopupData and self.PopupData.NoButtonForbiddenToast then 
        UIManager(self):ShowUITip("CommonToastMain", GText(self.PopupData.NoButtonForbiddenToast))
    end
end

function WBP_Common_Dialog_PC_C:OnForbiddenRightBtnClicked()
    if self.IsClosing then return end
    if self.ForbiddenRightBtnClickedCallback then 
        local Data = self:PackageResult()
        self.ForbiddenRightBtnClickedCallback(self.ForbiddenRightBtnCallbackObj, Data, self)
    elseif self.PopupData and self.PopupData.YesButtonForbiddenToast then 
        UIManager(self):ShowUITip("CommonToastMain", GText(self.PopupData.YesButtonForbiddenToast))
    end
end

function WBP_Common_Dialog_PC_C:PlaySound(SoundFile, SoundEventName, Params)
    AudioManager(self):PlayUISound(self, SoundFile, SoundEventName, nil)
    if Params then 
        AudioManager(self):SetEventSoundParam(self, SoundEventName, Params)
    end
end

function WBP_Common_Dialog_PC_C:CreateContentWidget(WidgetName)
    local ContentData = DataMgr.CommonDialogContent[WidgetName]
    if not ContentData then 
        DebugPrint("Tianyi@ 在弹窗控件表中找不到ContentId: " .. WidgetName)
        return nil 
    end

    local ContentBPPath = ContentData.BPPath 
    if ContentBPPath then 
        local ContentWidget = UIManager(self):CreateWidget(ContentBPPath, false)
        if ContentWidget.SetContentWidgetName then 
            ContentWidget:SetContentWidgetName(WidgetName)
        end
        return ContentWidget 
    end

    return nil
end

function WBP_Common_Dialog_PC_C:RegisterContentWidget(ContentWidgetName, ContentWidget)
    if ContentWidgetName then 
        if self.ContentWidgetTable[ContentWidgetName] then
            -- 策划应该不会填同样的控件吧....
            DebugPrint("Tianyi@ 重复注册控件：" .. ContentWidgetName)
        end
        self.ContentWidgetTable[ContentWidgetName] = ContentWidget
    else
        DebugPrint("Tianyi@ ContentWidget:" .. ContentWidget:GetName() .. "没有设置ContentWidgetName, 也许是未继承DialogContentBase类?")
    end
end

function WBP_Common_Dialog_PC_C:GetContentWidgetByName(WidgetName)
    return self.ContentWidgetTable[WidgetName]  
end

----------------------------- Utils

-- 获得弹窗标题栏（如果存在）
function WBP_Common_Dialog_PC_C:GetTitle()
    return self.DialogTitle
end

-- 获得弹窗按钮栏（如果存在）
function WBP_Common_Dialog_PC_C:GetButtonBar()
    return self.ButtonBar
end

-- 禁用弹窗左侧按钮
function WBP_Common_Dialog_PC_C:ForbidLeftBtn(IsForbid)
    local ButtonBar = self:GetButtonBar()
    if ButtonBar then 
        ButtonBar:ForbidLeftBtn(IsForbid)
    end
end

-- 禁用弹窗右侧按钮
function WBP_Common_Dialog_PC_C:ForbidRightBtn(IsForbid)
    local ButtonBar = self:GetButtonBar()
    if ButtonBar then 
        ButtonBar:ForbidRightBtn(IsForbid)
    end
end


-- 显示一条弹窗Tip
---@param DialogItemIndex number DialogItem的位置
---@param bShouldPlayAnim boolean 是否需要播放动画
function WBP_Common_Dialog_PC_C:ShowDialogTip(DialogItemIndex, bShouldPlayAnim)
    self:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
        DialogItemIndex = DialogItemIndex,
        bHideDialogItem = false,
        bShouldPlayAnim = bShouldPlayAnim})
end


-- 隐藏一条弹窗Tip
---@param DialogItemIndex number DialogItem的位置
---@param bShouldPlayAnim boolean 是否需要播放动画
function WBP_Common_Dialog_PC_C:HideDialogTip(DialogItemIndex, bShouldPlayAnim)
    self:BroadcastDialogEvent(DialogEvent.HideDialogItem, {
        DialogItemIndex = DialogItemIndex,
        bHideDialogItem = true,
        bShouldPlayAnim = bShouldPlayAnim})
end


function WBP_Common_Dialog_PC_C:GetGamepadShortcutByIndex(Index)
    return self.Index2GamepadShortcut[Index]
end

-- 初始化并显示一个快捷键提示，返回一个Index，用于后续隐藏
function WBP_Common_Dialog_PC_C:InitGamepadShortcut(Params, TargetIndex)
    local Index, Widget = self:DispatchGamepadShortcut(TargetIndex)
    if not (Index and Widget) then 
        return 
    end

    Widget:CreateCommonKey(Params)
    Widget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible) 
    return Index
end

-- 根据Index隐藏一个快捷键提示
function WBP_Common_Dialog_PC_C:HideGamepadShortcut(Index)
    local GamepadShortcut = self:GetGamepadShortcutByIndex(Index)
    if GamepadShortcut then
        GamepadShortcut:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- 隐藏所有快捷键提示
function WBP_Common_Dialog_PC_C:HideAllGamepadShortcut()
    local GamepadShortcutNum = #self.Index2GamepadShortcut
    for Index = 1, GamepadShortcutNum do 
        self:HideGamepadShortcut(Index)
    end
end

function WBP_Common_Dialog_PC_C:ShowGamepadShortcut(Index)
    local GamepadShortcut = self:GetGamepadShortcutByIndex(Index)
    if GamepadShortcut then
        GamepadShortcut:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end

-- 跨场景/跨内容前置清理：仅清空内容数据，避免 ShowAll 恢复旧索引
-- 使用说明：当在新内容中准备使用 ShowAllGamepadShortcut 时，建议先调用本方法
function WBP_Common_Dialog_PC_C:ClearAllGamepadShortcutContent()
    if not self.Index2GamepadShortcut then return end
    for _, Shortcut in ipairs(self.Index2GamepadShortcut) do
        if Shortcut then
            Shortcut.KeyInfoList = nil
            Shortcut.CreateInfo = nil
            if Shortcut.SubWidgetList and Shortcut.SubWidgetList.Clear then
                Shortcut.SubWidgetList:Clear()
            end
        end
    end
end

-- 显示所有快捷键提示（与 HideAllGamepadShortcut 配套）
    -- 使用提示：若为跨场景/跨内容进入后直接调用 ShowAll，为避免恢复旧索引
    -- 请在合适的时机先调用 Owner:ClearAllGamepadShortcutContent()
function WBP_Common_Dialog_PC_C:ShowAllGamepadShortcut()
    local GamepadShortcutNum = #self.Index2GamepadShortcut
    for Index = 1, GamepadShortcutNum do
        local Shortcut = self:GetGamepadShortcutByIndex(Index)
        if Shortcut and Shortcut.KeyInfoList and #Shortcut.KeyInfoList > 0 then
            self:ShowGamepadShortcut(Index)
        end
    end
end

-- 分配一个隐藏的GamepadShortcutIndex
function WBP_Common_Dialog_PC_C:DispatchGamepadShortcut(TargetIndex)
    if TargetIndex then 
        return TargetIndex, self.Index2GamepadShortcut[TargetIndex]
    end

    local GamepadShortcutNum = #self.Index2GamepadShortcut
    for Index = GamepadShortcutNum - 1, 1, -1 do 
        if not self:IsGamepadShortcutVisible(Index) then 
            return Index, self.Index2GamepadShortcut[Index]
        end
    end

    return nil
end

function WBP_Common_Dialog_PC_C:IsGamepadShortcutVisible(Index)
    local GamepadShortcut = self:GetGamepadShortcutByIndex(Index)
    return GamepadShortcut:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible
end

-- 显示手柄按B关闭提示
function WBP_Common_Dialog_PC_C:ShowGamepadCloseBtn(bShow)
    if bShow then 
        if self.GamepadCloseBtnIndex then return end
        self.GamepadCloseBtnIndex = self:InitGamepadShortcut({
            KeyInfoList = {
            {
                Type = "Img",
                ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("B", self.CurGamepadName)
            }},
            Desc = GText("UI_Controller_Close")
        }, #self.Index2GamepadShortcut)
    else 
        if self.GamepadCloseBtnIndex then 
            self:HideGamepadShortcut(self.GamepadCloseBtnIndex)
            self.GamepadCloseBtnIndex = nil
        end
    end
end

function WBP_Common_Dialog_PC_C:SetGamepadBtnKeyVisibility(IsShow)
    local ButtonBar = self:GetButtonBar()
    if ButtonBar then 
        ButtonBar:SetGamepadBtnKeyVisibility(IsShow)
    end
end



-- 在手柄端模式下，显示右摇杆滚动
function WBP_Common_Dialog_PC_C:ShowGamepadScrollBtn(bShow)
    if bShow then 
        if self.GamepadScrollBtnIndex then return end
        self.GamepadScrollBtnIndex = self:InitGamepadShortcut({        
            KeyInfoList = {
            {
                Type = "Img",
                ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("RV", self.CurGamepadName)
            }},
            Desc = GText("UI_Controller_Slide")
        })
    else 
        if self.GamepadScrollBtnIndex then 
            self:HideGamepadShortcut(self.GamepadScrollBtnIndex)
            self.GamepadScrollBtnIndex = nil
        end
    end
end


-- 分配一个通用Item的序号
function WBP_Common_Dialog_PC_C:GetItemIndex()
    if not self.CurItemIndex then 
        self.CurItemIndex = 0
    end

    self.CurItemIndex = self.CurItemIndex + 1
    return self.CurItemIndex
end
----------------------------- Utils end

function WBP_Common_Dialog_PC_C:OnClose()
    if self.IsClosing then return end
    self.IsClosing = true
    AudioManager(self):SetEventSoundParam(self, "CommonDialogIn", {ToEnd = 1})

    if self.DontPlayOutAnimation then
        self:OnAnimationFinished(self.Out) 
    else
        self:PlayAnimation(self.Out)
    end
end

function WBP_Common_Dialog_PC_C:RealClose()
    self.Super.RealClose(self)
    if self.OnCloseCallbackFunction then
        local Data = self:PackageResult()
        self.OnCloseCallbackFunction(self.OnCloseCallbackObj, Data, self)
    end
end

function WBP_Common_Dialog_PC_C:SequenceEvent_ListViewAnim()
    self:BroadcastDialogEvent("PlayAttrListInAnim")
end

--- 刷新消耗道具格子的接口
function WBP_Common_Dialog_PC_C:UpdateResourceInfos(DialogContent,Res)
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    DialogContent.Params.ItemList = {}
    for _,ResourceUse in ipairs(Res.ResourceUse) do
        if(ResourceUse.Count <=0) then goto continue end
        local ResourceId = ResourceUse.ResourceId
        table.insert(DialogContent.Params.ItemList, {
            ItemId = ResourceId,
            ItemType = CommonConst.ItemType.Resource, 
            ItemNum = Avatar.Resources[ResourceId] and Avatar.Resources[ResourceId].Count or 0,
            ItemNeed = ResourceUse.Count,
        })
        ::continue::
    end
    self:BroadcastDialogEvent("UpdateItemSubSize", DialogContent.Params)
end

function WBP_Common_Dialog_PC_C:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.ContentWidgetTable then
        for _, ContentWidget in pairs(self.ContentWidgetTable) do
            if ContentWidget.OnContentFocusReceived then 
                ContentWidget:OnContentFocusReceived(MyGeometry, InFocusEvent)
            end
        end
    end
    return WBP_Common_Dialog_PC_C.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end
function WBP_Common_Dialog_PC_C:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local AllChildrend = self.VB_Node:GetAllChildren()
    local Length = AllChildrend:Length()
    for i=1,Length do
        local ContentWidget = AllChildrend:GetRef(i)
        if ContentWidget.OnContentAnalogValueChanged then 
            ContentWidget:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
        end
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return WBP_Common_Dialog_PC_C

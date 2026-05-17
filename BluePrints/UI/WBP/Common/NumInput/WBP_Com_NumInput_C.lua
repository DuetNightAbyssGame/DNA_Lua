--
-- DESCRIPTION
-- 通用数量选择器 （PC、移动端公用）
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"

local StringUtils = require "Utils.StringUtils"

local LongPressInterval = 0.15

local M = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
})

local MAX_NUMBER_COUNT = 5

function M:Construct()
    self.IsForbidStyleUpdate = false
    -- 当前的输入数值
    self.CurInputNumber = nil
    self.CurInputDeviceType = nil
    self.AddTime = 0
    self.MinTime = 0

    self:InitAnimationEvent()
end

function M:Destruct()
    -- self:LeaveNumInputMode()
    self:RemoveTextInputCallback()
    self:ClearListenEvent()
    self:ClearAnimationEvent()
end

---@param ConfigData table<string, any> 配置信息
function M:Init(ConfigData)
-- ConfigData({
--     InitValue = Number, 初始个数，默认为1
--     MinValue = Number, 最小个数，默认为1
--     MaxValue = Number, 最大个数, 默认为999
--     ClickInterval = Number, 每次点击增加/减少个数，默认为1
--     SpecificNumInterval = Number, 固定数量增减间隔（如每次增加5个），默认为nil(不显示)
--     MinusBtnCallback = function, 减少按钮的回调
--     AddBtnCallback = function, 增加按钮的回调
--     MinBtnCallback = function, 最小按钮的回调
--     MaxBtnCallback = function, 最大按钮的回调
--     InputCallback = function, 数字输入的回调
--     IsNotAllowTextFieldInput = boolean, 不允许使用输入框输入
--     SoundResPath = {Minus="event:/ui/common/click_btn_minus"}, 非特殊情况就用默认的音效
--     LeaveFocusWidget = FocusWidget, 退出后需要聚焦的Widget
--     OwnerPanel = OwnerPanel,  父对象
--     bForceInputInt, 是否强制输入整数
--     PlatformName = "PC", 平台类型 (PC、Mobile、GamePad) 可选参数 
--     bForbidPressAccelerate = bool, 是否禁用长按加速（若有自己对滑条加速处理的话设为true） 默认为false
-- })
    -- 初始化设置选择器的信息
    self.ConfigData = ConfigData
    -- 配置信息
    self.CurInputNumber = ConfigData.InitValue or 1
    -- 最小个数
    self.MinValue = ConfigData.MinValue or 1
    -- 最大个数
    self.MaxValue = ConfigData.MaxValue or 999
    -- 每次点击增加/减少个数
    self.ClickInterval = ConfigData.ClickInterval or 1
    -- 固定数量增减间隔（如每次增加5个）
    self.SpecificNumInterval = ConfigData.SpecificNumInterval
    -- 减少按钮的正常点击回调
    self.MinusBtnCallback = ConfigData.MinusBtnCallback
    -- 减少按钮的禁用点击回调
    self.MinusBtnForbidCallback = ConfigData.MinusBtnForbidCallback
    -- 增加按钮的正常点击回调
    self.AddBtnCallback = ConfigData.AddBtnCallback
    -- 增加按钮的禁用点击回调
    self.AddBtnForbidCallback = ConfigData.AddBtnForbidCallback
    -- 最小按钮的正常点击回调
    self.MinBtnCallback = ConfigData.MinBtnCallback
    -- 最小按钮的禁用点击回调
    self.MinBtnForbidCallback = ConfigData.MinBtnForbidCallback
    -- 最大按钮的正常点击回调
    self.MaxBtnCallback = ConfigData.MaxBtnCallback
    -- 最大按钮的禁用点击回调
    self.MaxBtnForbidCallback = ConfigData.MaxBtnForbidCallback
    -- 特定数量减少按钮的回调
    self.SpecificNumMinusCallback = ConfigData.SpecificNumMinusCallback
    -- 特定数量增加按钮的回调
    self.SpecificNumAddCallback = ConfigData.SpecificNumAddCallback
    -- 数字输入的回调
    self.InputCallback = ConfigData.InputCallback
    -- 所有音频资源路径
    self.SoundResPath = ConfigData.SoundResPath or {}
    -- 是否允许使用输入框输入
    self.IsNotAllowTextFieldInput = ConfigData.IsNotAllowTextFieldInput
    -- 是否强制输入整数，默认是
    self.bForceInputInt = ConfigData.bForceInputInt or true
    -- 退出后需要聚焦的Widget
    self.LeaveFocusWidget = ConfigData.LeaveFocusWidget or ConfigData.OwnerPanel
    -- 所属的对象
    self.OwnerPanel = ConfigData.OwnerPanel
    -- 是否禁用长按加速
    self.bForbidPressAccelerate = ConfigData.bForbidPressAccelerate or false

    -- 手柄 视图键支持参数更改
    self.ViewGamePad = ConfigData.ViewGamePad or "SpecialLeft"

    -- 手柄 特定数量增减按键键支持参数配置
    self.SpecificNumAddGamePad = ConfigData.SpecificNumAddGamePad or "RightShoulder"
    self.SpecificNumMinusGamePad = ConfigData.SpecificNumMinusGamePad or "LeftShoulder"

    -- 是否需要打开数字键盘，默认根据当前输入设备决定
    self.bOpenNumberKeyboard = not UIUtils.IsKeyboardInput()

    -- 绑定输入操作
    self:BindAllClickAction()
    -- 基础信息
    self:RefreshBaseInfo()
    -- 添加需要监听的事件
    self:InitListenEvent()
end

function M:BindAllClickAction()
    self.Btn_NumRight:Init({
        OwnerPanel = self,
        ClickedCallback = self.OnClickToSpecialNumAdd,
        SpecificChangeCount = string.format("+%d", self.SpecificNumInterval or 1),
        GamePadKey = self.SpecificNumAddGamePad,
    })
    self.Btn_NumLeft:Init({
        OwnerPanel = self,
        ClickedCallback = self.OnClickToSpecialNumMinus,
        SpecificChangeCount = string.format("-%d", self.SpecificNumInterval or 1),
        GamePadKey = self.SpecificNumMinusGamePad,
    })

    self.Btn_Min:BindEventOnPressed(self, self.OnMinusKeyDown)
    self.Btn_Min:BindEventOnReleased(self,self.OnMinusKeyUp)
    self.Btn_Min:BindForbidStateExecuteEvent(self, self.OnClickToMinusInForbidState)
    self.Btn_Add:BindEventOnPressed(self, self.OnAddKeyDown)
    self.Btn_Add:BindEventOnReleased(self,self.OnAddKeyUp)
    self.Btn_Add:BindForbidStateExecuteEvent(self, self.OnClickToAddInForbidState)
    self.Btn_Mini:BindEventOnClicked(self, self.OnClickToMin)
    self.Btn_Mini:BindForbidStateExecuteEvent(self, self.OnClickToMinInForbidState)
    self.Btn_Max:BindEventOnClicked(self, self.OnClickToMax)
    self.Btn_Max:BindForbidStateExecuteEvent(self, self.OnClickToMaxInForbidState)

    -- 一些按钮音效相关
    self.Btn_Min.SoundFunc = function(Btn)
        local EventSoundPath = self.SoundResPath["Minus"] or "event:/ui/common/click_btn_minus"
        AudioManager(self):PlayUISound(self.Btn_Min, EventSoundPath, nil, nil)
    end
    self.Btn_Add.SoundFunc = function(Btn)
        local EventSoundPath = self.SoundResPath["Add"] or "event:/ui/common/click_btn_add"
        AudioManager(self):PlayUISound(self.Btn_Add, EventSoundPath, nil, nil)
    end
    self.Btn_Mini.SoundFunc = function(Btn)
        local EventSoundPath = self.SoundResPath["Max"] or "event:/ui/common/click_level_01"
        AudioManager(self):PlayUISound(self.Btn_Mini, EventSoundPath, nil, nil)
    end
    self.Btn_Max.SoundFunc = function(Btn)
        local EventSoundPath = self.SoundResPath["Max"] or "event:/ui/common/click_btn_addMulti"
        AudioManager(self):PlayUISound(self.Btn_Max, EventSoundPath, nil, nil)
    end
end

function M:SetSimpleMode(bSimpleMode)
    self.IsSimpleMode = bSimpleMode
    if (bSimpleMode) then
        self.WS_Left:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.WS_Right:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.WS_Left:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.WS_Right:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
end

function M:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self.Text_Num:SetText(tostring(self.CurInputNumber))

    self:RefreshBtnState()

    if (self.MinBtnCallback ~= nil) then
        self.Group_BtnMini:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Group_ControllerMini:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end
    if (self.MaxBtnCallback ~= nil) then
        self.Group_BtnMax:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Group_ControllerMax:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    end

    if (self.IsNotAllowTextFieldInput) then
        self.Text_Input:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Group_View:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        self.Text_Input:SetVisibility(UIConst.VisibilityOp["Visible"])
    end

    if (self.SpecificNumInterval) then
        self.Btn_NumRight:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self.Btn_NumLeft:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    else
        self.Btn_NumRight:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        self.Btn_NumLeft:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    end
    -- 初始化手柄按钮信息
    self:InitWidgetInfoInGamePad()
end

function M:InitWidgetInfoInGamePad()
    self.Key_ControllerMini_Text:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Left",
            },
        },
        Desc = GText("UI_SHOP_MIN")
    }) 

    self.Key_Min:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "LT",
            },
        },
    }) 

    self.Key_ControllerMax_Text:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "Right",
            },
        },
        Desc = GText("UI_SHOP_MAX")
    }) 

    self.Key_Add:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "RT",
            },
        },
    }) 

    self.Key_View:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = UIConst.GamePadImgKey[self.ViewGamePad],
            },
        },
    }) 

    self.Key_Cancel:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B",
            },
        },
    }) 
    self.Text_Cancel:SetText(GText("UI_PATCH_CANCEL"))

    self.Group_ControllerTips:SetVisibility(UIConst.VisibilityOp["Collapsed"])
end

function M:InitAnimationEvent()
    self:PlayAnimation(self.Normal)
    self:BindToAnimationFinished(self.UnHover, self,function()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    end)
    self.Text_Input.OnPressed:Add(self, function()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
    end)
    self.Text_Input.OnReleased:Add(self, function()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    end)
    self.Text_Input.OnHovered:Add(self, function()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
    end)
    self.Text_Input.OnUnhovered:Add(self, function()
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
    end
    )
end

function M:AddTextInputCallback()
    if (self.bOpenNumberKeyboard) then
        self.Text_Input.OnPressed:Add(self, self.ExecOnTextOnPressed)
        self.Text_Input.OnFocusReceived:Add(self,self.EditOnTextFocusReceived)
    else
        self.Text_Input.OnTextChanged:Add(self, self.OnInputTextChanged)
        self.Text_Input.OnTextComposing:Add(self, self.OnTextComposing)
        self.Text_Input.OnPressed:Add(self, self.ExecOnTextOnPressed)
        self.Text_Input.OnTextCommitted:Add(self, self.ExecOnTextCommintted)
        self.Text_Input.OnFocusReceived:Add(self,self.EditOnTextFocusReceived)
        self.Text_Input.OnFocusLost:Add(self,self.EditOnTextFocusLost)
    end
end

function M:RemoveTextInputCallback()
    if (self.bOpenNumberKeyboard) then
        self.Text_Input.OnPressed:Remove(self, self.ExecOnTextOnPressed)
        self.Text_Input.OnPressed:Clear()
        self.Text_Input.OnFocusReceived:Clear()
    else
        self.Text_Input.OnTextChanged:Remove(self, self.OnInputTextChanged)
        self.Text_Input.OnPressed:Remove(self, self.ExecOnTextOnPressed)
        self.Text_Input.OnPressed:Clear()
        self.Text_Input.OnTextCommitted:Clear()
        self.Text_Input.OnFocusReceived:Clear()
        self.Text_Input.OnFocusLost:Clear()
    end
end

function M:GetChangeCount()
    local PressTime  = self.AddTime ~= 0 and self.AddTime or self.MinTime
    local Multiple = 1
    if not self.bForbidPressAccelerate and self.LongPressCurve then
        Multiple = self.LongPressCurve:GetFloatValue(PressTime)
    end
    local StepCount = self.ClickInterval * Multiple
    StepCount = math.floor(StepCount + 0.5)
    local FinalCount = math.floor(math.max(1, math.min(StepCount, self.MaxValue)))
    return FinalCount
end

function M:OnMinusKeyDown()
    self:AddTimer(LongPressInterval ,self.OnClickToMinus, true, 0, "PreMinusLoop", true)
    local AddTimerKey = self:_GetTimerInfo("PreAddLoop")
    if AddTimerKey then
        self.AddTime = 0
        self:RemoveTimer("PreAddLoop")
        self:RemoveTimer("PreMinusLoop")
    else
        self:OnClickToMinus()
    end
end

function M:OnMinusKeyUp()
    self.MinTime = 0
    self:RemoveTimer("PreMinusLoop",true)
    -- local AddTimerKey = self:_GetTimerInfo("PreAddLoop")
    -- if AddTimerKey then
    --     self:UnPauseTimer("PreAddLoop")
    -- end
end

function M:OnAddKeyDown()
    self:AddTimer(LongPressInterval ,self.OnClickToAdd, true, 0, "PreAddLoop", true)
    local AddTimerKey = self:_GetTimerInfo("PreMinusLoop")
    if AddTimerKey then
        self.MinTime = 0
        self:RemoveTimer("PreMinusLoop")
        self:RemoveTimer("PreAddLoop")
    else
        self:OnClickToAdd()
    end
end

function M:OnAddKeyUp()
    self.AddTime = 0
    self:RemoveTimer("PreAddLoop",true)
    -- local AddTimerKey = self:_GetTimerInfo("PreMinusLoop")
    -- if AddTimerKey then
    --     self:UnPauseTimer("PreMinusLoop")
    -- end
end

function M:ClearAnimationEvent()
    self.Text_Input.OnPressed:Clear()
    self.Text_Input.OnReleased:Clear()
    self.Text_Input.OnHovered:Clear()
    self.Text_Input.OnUnhovered:Clear()
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

-- 是否禁止样式切换
function M:SetIsForbidStyleUpdate(bIsForbidStyleUpdate)
    self.IsForbidStyleUpdate = bIsForbidStyleUpdate
end

-- 是否允许切换到手柄 UI模式
function M:IsCanChangeToGamePadViewMode(bIsForbidStyleUpdate)
    return not self.IsForbidStyleUpdate
end

-- 是否允许切换到PC UI模式
function M:IsCanChangeToPCViewMode()
    return not self.IsForbidStyleUpdate
end

-- 根据输入设备刷新操作信息
function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end

    -- 输入设备发生了切换
    self.bOpenNumberKeyboard = CurInputDevice ~= ECommonInputType.MouseAndKeyboard
    -- 先尝试移除数字输入监听
    self:RemoveTextInputCallback()
    -- 添加数字输入的监听
    self:AddTextInputCallback()

    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
end

-- 尝试切换UI样式
function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
    if (CurInputType == ECommonInputType.MouseAndKeyboard and not self:IsCanChangeToGamePadViewMode()) then
        DebugPrint("Com_NumInput OnUpdateUIStyleByInputTypeChange, Now Is forbid Change to GamePad View! CurInputType is", CurInputType)
        return
    end

    if (CurInputType == ECommonInputType.Gamepad and not self:IsCanChangeToPCViewMode()) then
        DebugPrint("Com_NumInput OnUpdateUIStyleByInputTypeChange, Now is forbid Change to PC View! CurInputType is", CurInputType)
        return
    end
    --- 输入设备切换通知
    self.CurInputDeviceType = CurInputType
    local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse, CurGamepadName)
end

-- 真正切换UI样式
function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse, CurGamepadName)
    local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
    self.WS_Left:SetActiveWidgetIndex(ActiveWidgetIndex)
    self.WS_Right:SetActiveWidgetIndex(ActiveWidgetIndex)
    self.Btn_NumLeft:ChangeUIStyleForCurPlatform(IsUseKeyAndMouse)
    self.Btn_NumRight:ChangeUIStyleForCurPlatform(IsUseKeyAndMouse)
    if (IsUseKeyAndMouse) then
        self.Group_View:SetVisibility(UIConst.VisibilityOp["Collapsed"])
        -- self.Group_ControllerTips:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    else
        if (self.Text_Input ~= nil and self.Text_Input:IsVisible()) then
            self.Group_View:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        end
        -- self.Group_ControllerTips:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
        self:UpdateHotKeyImage(CurGamepadName)
    end
end

-- 重写值限制, 并刷新面板信息
function M:OverrideValueLimit(InitValue, MaxValue, MinValue, bRefresh)
    self.CurInputNumber = InitValue or 1

    self.MaxValue = MaxValue or 999
    self.MinValue = MinValue or 1

    if (bRefresh) then
        -- 刷新面板信息
        self:RefreshBaseInfo()
    else
        self:RefreshBtnState()
    end
end

function M:RefreshCurInputNumber(NewNumber)
    self.CurInputNumber = NewNumber or 1
    if (self.IsSimpleMode) then
        self.Text_Num:SetText(tostring(self.CurInputNumber))
        self:RefreshBtnState()
    else
        -- 刷新面板信息
        self:RefreshBaseInfo()
    end
end

function M:RefreshBtnState()
    self.Btn_Add:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    self.Btn_Max:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    self.Btn_Min:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    self.Btn_Mini:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)

    self.Btn_NumRight:SetForbid(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    self.Btn_NumLeft:SetForbid(self.CurInputNumber - self.ClickInterval < self.MinValue)
end

-- 输入框按下回调
function M:ExecOnTextOnPressed()
    self.Text_Input:SetText(tostring(self.CurInputNumber))
    self.Text_Input:SetRenderOpacity(1.0)
    self.Text_Num:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if (self.bOpenNumberKeyboard) then
        self:OpenVirtualKeyboard()
    end
    self.IsInNumInputState = true
end

-- 打开虚拟键盘
function M:OpenVirtualKeyboard()
    UIManager(self):LoadUINew("CommonNumInput", UIConst.InputNumMode.NUMBER, {
        Min = self.MinValue, Max = self.MaxValue,
        ConfirmCB = {Obj=self, Func=self.ExecOnTextAfterNumInput},
        CancelCB = {Obj=self, Func=self.OnCloseVirtualKeyboard},
        InitVal = self.CurInputNumber,
    })
end

-- 输入框提交回调
function M:ExecOnTextCommintted(InText, CommitType)
    local TempNumber = InText ~= "" and tonumber(InText) or 1
    self:ExecOnTextAfterNumInput(TempNumber)
end

-- 数字输入完成后的执行的方法
function M:ExecOnTextAfterNumInput(TempNumber)
    local OldNumberValue = self.CurInputNumber
    self.CurInputNumber = math.min(self.MaxValue, math.max(TempNumber, self.MinValue))

    -- 刷新面板信息
    self:RefreshBtnState()

    self.Text_Num:SetText(tostring(self.CurInputNumber))
    self.Text_Input:SetRenderOpacity(0.0)
    self.Text_Num:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])

    if (type(self.InputCallback) == "function") then
        self.InputCallback(self.OwnerPanel, self.CurInputNumber, OldNumberValue)
    end
    self.IsInNumInputState = false
end

--输入法组合时会调用这个事件而不是OnInputTextChanged
function M:OnTextComposing(Text)
    if not self.bForceInputInt then return end
    -- 强制整数模式：过滤掉所有非数字字符
    local FilteredText = string.gsub(Text, "%D", "")
    
    -- 如果过滤后文本为空，设置为最小值（而不是固定为1）
    if FilteredText == "" then
        FilteredText = tostring(self.MinValue)
    end
    -- 如果文本发生了变化，更新输入框
    if FilteredText ~= Text then
        self.Text_Input:SetText(FilteredText)
    end
end

-- 输入框文本变化回调
function M:OnInputTextChanged(Text)
    -- 强制整数模式：过滤掉所有非数字字符
    local FilteredText = string.gsub(Text, "%D", "")
    
    -- 如果过滤后文本为空，设置为最小值（而不是固定为1）
    if FilteredText == "" then
        FilteredText = tostring(self.MinValue)
    end
    
    -- 如果文本发生了变化，更新输入框
    -- 注意：这里需要小心处理，避免无限递归
    if FilteredText ~= Text then
        self.Text_Input:SetText(FilteredText)
    end
end

-- 输入框获得焦点回调
function M:EditOnTextFocusReceived()
    -- 获得聚焦
    self:ExecOnTextOnPressed()
end

-- 输入框失去焦点回调
function M:EditOnTextFocusLost()
    -- 失去聚焦
    self:AddTimer(0.1, self.OnReturnFocusToWidget, false, 0, "OnReturnFocusToWidget", true)
end


function M:OnCloseVirtualKeyboard()
    self.Text_Input:SetRenderOpacity(0.0)
    self.Text_Num:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])

    self.IsInNumInputState = false
    self:EditOnTextFocusLost()
end

-- 特殊数量减少按钮的点击回调
function M:OnClickToSpecialNumMinus()
    local NeedChangeCount = self.SpecificNumInterval
    if (self.CurInputNumber - self.SpecificNumInterval < self.MinValue) then
        NeedChangeCount = self.CurInputNumber - self.MinValue
    end

    if NeedChangeCount <= 0 then
        return
    end

    local OldNumberValue = self.CurInputNumber
    self.CurInputNumber = self.CurInputNumber - NeedChangeCount
    self.Text_Num:SetText(tostring(self.CurInputNumber))
    if (self.Btn_Add.IsForbidden) then
        self.Btn_Add:ForbidBtn(false)
    end
    if (self.Btn_Max.IsForbidden) then
        self.Btn_Max:ForbidBtn(false)
    end
    if (self.Btn_NumRight:IsInForbidState()) then
        self.Btn_NumRight:SetForbid(false)
    end
    self.Btn_Min:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    self.Btn_Mini:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    self.Btn_NumLeft:SetForbid(self.CurInputNumber - self.ClickInterval < self.MinValue)

    if (type(self.SpecificNumMinusCallback) == "function") then
        self.SpecificNumMinusCallback(self.OwnerPanel, self.CurInputNumber, OldNumberValue)
    end
end

-- 特殊数量增加按钮的点击回调
function M:OnClickToSpecialNumAdd()
    local NeedChangeCount = self.SpecificNumInterval
    if (self.CurInputNumber + self.SpecificNumInterval > self.MaxValue) then
        NeedChangeCount = self.MaxValue - self.CurInputNumber
    end

    if NeedChangeCount <= 0 then
        return
    end

    local OldNumberValue = self.CurInputNumber
    self.CurInputNumber = self.CurInputNumber + NeedChangeCount
    self.Text_Num:SetText(tostring(self.CurInputNumber))
    if (self.Btn_Min.IsForbidden) then
        self.Btn_Min:ForbidBtn(false)
    end
    if (self.Btn_Mini.IsForbidden) then
        self.Btn_Mini:ForbidBtn(false)
    end
    if (self.Btn_NumLeft:IsInForbidState()) then
        self.Btn_NumLeft:SetForbid(false)
    end
    self.Btn_Add:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    self.Btn_Max:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    self.Btn_NumRight:SetForbid(self.CurInputNumber + self.ClickInterval > self.MaxValue)

    if (type(self.SpecificNumAddCallback) == "function") then
        self.SpecificNumAddCallback(self.OwnerPanel, self.CurInputNumber, OldNumberValue)
    end
end

-- 减少按钮的正常点击回调
function M:OnClickToMinus()
    self.MinTime = self.MinTime + LongPressInterval
    local FinalCount = self:GetChangeCount()
    if (self.CurInputNumber - self.MinValue < FinalCount)  then
        FinalCount = self.CurInputNumber - self.MinValue
        self:RemoveTimer("PreMinusLoop",true)
    end
    if FinalCount <= 0 then
        return
    end
    if (self.CurInputNumber - FinalCount < self.MinValue) then
        if (not self.Btn_Min.IsForbidden) then
            self.Btn_Min:ForbidBtn(true)
        end
        if (not self.Btn_Mini.IsForbidden) then
            self.Btn_Mini:ForbidBtn(true)
        end
        if (not self.Btn_NumLeft:IsInForbidState()) then
            self.Btn_NumLeft:SetForbid(true)
        end
        return
    end
    local OldNumberValue = self.CurInputNumber
    self.CurInputNumber = self.CurInputNumber - FinalCount
    self.Text_Num:SetText(tostring(self.CurInputNumber))
    if (self.Btn_Add.IsForbidden) then
        self.Btn_Add:ForbidBtn(false)
    end
    if (self.Btn_Max.IsForbidden) then
        self.Btn_Max:ForbidBtn(false)
    end
    if (self.Btn_NumRight:IsInForbidState()) then
        self.Btn_NumRight:SetForbid(false)
    end
    self.Btn_Min:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    self.Btn_Mini:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    self.Btn_NumLeft:SetForbid(self.CurInputNumber - self.ClickInterval < self.MinValue)
    if (type(self.MinusBtnCallback) == "function") then
        self.MinusBtnCallback(self.OwnerPanel, self.CurInputNumber, OldNumberValue)
    end
end

-- 减少按钮的禁用点击回调
function M:OnClickToMinusInForbidState()
    if (type(self.MinusBtnForbidCallback) == "function") then
        self.MinusBtnForbidCallback(self.OwnerPanel, self.CurInputNumber)
    end
end

-- 增加按钮的正常点击回调
function M:OnClickToAdd()
    self.AddTime = self.AddTime + LongPressInterval
    local FinalCount = self:GetChangeCount()
    if (self.MaxValue - self.CurInputNumber < FinalCount)  then
        FinalCount = self.MaxValue - self.CurInputNumber
        self:RemoveTimer("PreAddLoop",true)
    end
    if FinalCount <= 0 then
        return
    end
    if (self.CurInputNumber + FinalCount > self.MaxValue) then
        if (not self.Btn_Add.IsForbidden) then
            self.Btn_Add:ForbidBtn(true)
        end
        if (not self.Btn_Max.IsForbidden) then
            self.Btn_Max:ForbidBtn(true)
        end
        if (not self.Btn_NumRight:IsInForbidState()) then
            self.Btn_NumRight:SetForbid(true)
        end
        return
    end
    local OldNumberValue = self.CurInputNumber
    self.CurInputNumber = self.CurInputNumber + FinalCount
    self.Text_Num:SetText(tostring(self.CurInputNumber))
    if (self.Btn_Min.IsForbidden) then
        self.Btn_Min:ForbidBtn(false)
    end
    if (self.Btn_Mini.IsForbidden) then
        self.Btn_Mini:ForbidBtn(false)
    end
    if (self.Btn_NumLeft:IsInForbidState()) then
        self.Btn_NumLeft:SetForbid(false)
    end
    self.Btn_Add:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    self.Btn_Max:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    self.Btn_NumRight:SetForbid(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    if (type(self.AddBtnCallback) == "function") then
        self.AddBtnCallback(self.OwnerPanel, self.CurInputNumber, OldNumberValue)
    end
end

-- 增加按钮的禁用点击回调
function M:OnClickToAddInForbidState()
    if (type(self.AddBtnForbidCallback) == "function") then
        self.AddBtnForbidCallback(self.OwnerPanel, self.CurInputNumber)
    end
end

-- 增加按钮的禁用点击回调
function M:OnClickToMax()
    -- 设置为最大
    local OldNumberValue = self.CurInputNumber
    self.CurInputNumber = self.MaxValue
    self.Text_Num:SetText(tostring(self.CurInputNumber))
    if (self.Btn_Min.IsForbidden) then
        self.Btn_Min:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    end
    if (self.Btn_Mini.IsForbidden) then
        self.Btn_Mini:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    end
    if (self.Btn_NumLeft:IsInForbidState()) then
        self.Btn_NumLeft:SetForbid(self.CurInputNumber - self.ClickInterval < self.MinValue)
    end
    self.Btn_Add:ForbidBtn(true)
    self.Btn_Max:ForbidBtn(true)
    self.Btn_NumRight:SetForbid(true)

    if (type(self.MaxBtnCallback) == "function") then
        self.MaxBtnCallback(self.OwnerPanel, self.CurInputNumber, OldNumberValue)
    end
end

-- 最大按钮的禁用点击回调
function M:OnClickToMaxInForbidState()
    if (type(self.MaxBtnForbidCallback) == "function") then
        self.MaxBtnForbidCallback(self.OwnerPanel, self.CurInputNumber)
    end
end

-- 最小按钮的正常点击回调
function M:OnClickToMin()
    -- 设置为最小
    local OldNumberValue = self.CurInputNumber
    self.CurInputNumber = self.MinValue
    self.Text_Num:SetText(tostring(self.CurInputNumber))
    if (self.Btn_Add.IsForbidden) then
        self.Btn_Add:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    end
    if (self.Btn_Max.IsForbidden) then
        self.Btn_Max:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    end
    if (self.Btn_NumRight:IsInForbidState()) then
        self.Btn_NumRight:SetForbid(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    end
    self.Btn_Min:ForbidBtn(true)
    self.Btn_Mini:ForbidBtn(true)
    self.Btn_NumLeft:SetForbid(true)
    if (type(self.MinBtnCallback) == "function") then
        self.MinBtnCallback(self.OwnerPanel, self.CurInputNumber, OldNumberValue)
    end
end

-- 最小按钮的禁用点击回调
function M:OnClickToMinInForbidState()
    if (type(self.MinBtnForbidCallback) == "function") then
        self.MinBtnForbidCallback(self.OwnerPanel, self.CurInputNumber)
    end
end

function M:PlayCommonClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_01", nil, nil)
end

function M:OverrideFocusWidget(NewFocusWidget)
    self.CurFocusWidget = NewFocusWidget
end

-------------------------------输入设备相关--------------------------
function M:UpdateHotKeyImage(CurGamepadName)
    -- TODO手柄资源选择按键图片 (目前需要更新的都在通用快捷键里面处理)
    if (CurGamepadName == "PS") then
        -- PS
    else
        -- XboxOne、Generic
    end
end

function M:HandleGamepadAdd()
    ScreenPrint("add")
    if self.ForbidGamePadLTRTKey then return end
    -- Cancel pending cleanup
    self:RemoveTimer("GamepadCleanupTimer", true)

    -- If the main long-press logic isn't running, start it.
    if not self.isRT_Pressed then
        self.isRT_Pressed = true
        self:OnAddKeyDown()
    end

    -- Set the auto-cleanup timer
    local cleanup_f = function()
        self.isRT_Pressed = false
        self:OnAddKeyUp()
    end
    self:AddTimer(LongPressInterval - 0.01, cleanup_f, false, 0, "GamepadCleanupTimer", true)
end

function M:HandleGamepadMinus()
    ScreenPrint("minus")
    if self.ForbidGamePadLTRTKey then return end
    self:RemoveTimer("GamepadCleanupTimer", true)

    if not self.isLT_Pressed then
        self.isLT_Pressed = true
        self:OnMinusKeyDown()
    end

    -- Set the auto-cleanup timer
    local cleanup_f = function()
        self.isLT_Pressed = false
        self:OnMinusKeyUp()
    end
    self:AddTimer(LongPressInterval -0.01, cleanup_f, false, 0, "GamepadCleanupTimer", true)
end

function M:Handle_KeyEventOnGamePad(InKeyName)
    -- 处理手柄相关的交互事件
    local IsEventHandled = false
    if (InKeyName == UIConst.GamePadKey.FaceButtonRight) then
        if (self.Text_Input ~= nil and self.Text_Input:HasAnyUserFocus()) then
            IsEventHandled = true
            self:LeaveNumInputMode()
        end
    elseif (InKeyName == UIConst.GamePadKey[self.ViewGamePad]) then
        if (not self.IsNotAllowTextFieldInput) then
            -- 允许使用输入框输入
            IsEventHandled = true
            self:EnterNumInputMode()
        end
    elseif (InKeyName == UIConst.GamePadKey.LeftTriggerThreshold) then
        IsEventHandled = true
        local EventSoundPath = self.SoundResPath["Minus"] or "event:/ui/common/click_btn_minus"
        AudioManager(self):PlayUISound(self.Btn_Min, EventSoundPath, nil, nil)
        self:HandleGamepadMinus()
    elseif (InKeyName == UIConst.GamePadKey.DPadLeft) then
        IsEventHandled = true
        local EventSoundPath = self.SoundResPath["Max"] or "event:/ui/common/click_level_01"
        AudioManager(self):PlayUISound(self.Btn_Mini, EventSoundPath, nil, nil)
        self:OnClickToMin()
    elseif (InKeyName == UIConst.GamePadKey.RightTriggerThreshold) then
        IsEventHandled = true
        local EventSoundPath = self.SoundResPath["Add"] or "event:/ui/common/click_btn_add"
        AudioManager(self):PlayUISound(self.Btn_Add, EventSoundPath, nil, nil)
        self:HandleGamepadAdd()
    elseif (InKeyName == UIConst.GamePadKey.DPadRight) then
        IsEventHandled = true
        local EventSoundPath = self.SoundResPath["Max"] or "event:/ui/common/click_btn_addMulti"
        AudioManager(self):PlayUISound(self.Btn_Max, EventSoundPath, nil, nil)
        self:OnClickToMax()
    elseif (InKeyName == UIConst.GamePadKey[self.SpecificNumMinusGamePad]) then
        if (self.SpecificNumInterval ~= nil) then
            IsEventHandled = true
            local EventSoundPath = self.SoundResPath["SpecificMinus"] or "event:/ui/common/click_btn_minus"
            AudioManager(self):PlayUISound(self.Btn_NumLeft, EventSoundPath, nil, nil)
            self:OnClickToSpecialNumMinus()
        end
    elseif (InKeyName == UIConst.GamePadKey[self.SpecificNumAddGamePad]) then
        if (self.SpecificNumInterval ~= nil) then
            IsEventHandled = true
            local EventSoundPath = self.SoundResPath["SpecificAdd"] or "event:/ui/common/click_btn_add"
            AudioManager(self):PlayUISound(self.Btn_NumRight, EventSoundPath, nil, nil)
            self:OnClickToSpecialNumAdd()
        end
    end
    return IsEventHandled
end

function M:CheckIsFocusInTextInput()
    local PlayerController = self:GetOwningPlayer()
    if (self.Text_Input:HasUserFocus(PlayerController)) then
        return true
    end
    return false
end

function M:EnterNumInputMode()
    if (self.IsNotAllowTextFieldInput) then
        -- 不允许使用输入框输入
        return
    end
    if (self.IsInNumInputState) then
        return
    end

    self:UpdateUIStyleInPlatform(not self.bOpenNumberKeyboard)
    -- self.Group_ControllerTips:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.Text_Num:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    if (self.Text_Input ~= nil and self.Text_Input:IsVisible()) then
        self.IsInNumInputState = true
        if (self.bOpenNumberKeyboard) then
            self:ExecOnTextOnPressed()
        else
            self.Text_Input:SetFocus()
        end
        if (self.OwnerPanel and self.OwnerPanel.UpdateCurFocusInfo) then
            self.OwnerPanel:UpdateCurFocusInfo("NumInputEdit")
        end
    end
end

function M:LeaveNumInputMode()
    if (self.IsNotAllowTextFieldInput) then
        -- 不允许使用输入框输入
        return
    end
    if (not self.IsInNumInputState) then
        return
    end
    self:UpdateUIStyleInPlatform(false)

    -- self.Group_ControllerTips:SetVisibility(UIConst.VisibilityOp["Collapsed"])
    self.Text_Num:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])
    self.IsInNumInputState = false
    self:OnReturnFocusToWidget()
end

function M:OverrideFocusToWidget(FocusWidget)
    self.LeaveFocusWidget = FocusWidget
end

function M:OnReturnFocusToWidget()
    if (self.LeaveFocusWidget) then
        if (type(self.LeaveFocusWidget.SetFocus_Lua) == "function") then
            self.LeaveFocusWidget:SetFocus_Lua()
        else
            self.LeaveFocusWidget:SetFocus()
        end
    elseif (self.OwnerPanel) then
        if (self.OwnerPanel.SetFocus_Lua) then
            self.OwnerPanel:SetFocus_Lua()
        else
            self.OwnerPanel:SetFocus()
        end
    end
end

return M

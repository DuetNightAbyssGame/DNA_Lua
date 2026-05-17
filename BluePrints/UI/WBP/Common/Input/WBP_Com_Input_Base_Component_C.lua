--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local StringUtils = require "Utils.StringUtils"
---@class WBP_Com_Input_Base_Component_C
local M = {}

--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Group_InputTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Input:SetText("")
    self.Text_Input.OnFocusReceived:Add(self,self.OnEditTextFocusReceived)
    self.Text_Input.OnFocusLost:Add(self,self.OnEditTextFocusLost)
    self.Text_Input.OnCursorMoved:Add(self,self.OnEditTextCursorMoved)
    self.Text_Input.OnDoubleClicked:Add(self,self.OnDoubleClicked)
    self.Text_Input.OnTextChanged:Add(self,self.HandleOnTextChanged)
    self.Text_Input.OnTextComposing:Add(self,self.HandleOnTextComposing)
    self.Text_Input.OnTextCommitted:Add(self,self.HandleOnTextCommitted)
    -- self.Text_Input.OnReleased:Add(self, function(self)
    --     AudioManager(self):PlayUISound(self, "event:/ui/common/click_input_bar", nil, nil)
    -- end)
    self.TextLimit = 9999
    self.bNeedPasteBtn = false
    self:SetHintText(GText("UI_Chat_InputHint"))
    self.NewText = ""
    self.CurrentText = ""
    self.ComposingText = ""
    self.bTipsShowed = false
    self.CursorLineIdx = 0
    self.CursorOffset = 0
    self.IgnoredSpaceCount = 0
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self:GetOwningPlayer())
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice) 
    end
    self.DefaultFocusKeyName = "X"
    self.DefaultPasteKeyName = "LS"
    -- self:SetGamePadKey(self.DefaultFocusKeyName,self.DefaultPasteKeyName)
    -- self:UpdateBtns()
    self:PlayAnimation(self.Normal)
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self.Text_Input.OnFocusReceived:Clear()
    self.Text_Input.OnFocusLost:Clear()
    self.Text_Input.OnCursorMoved:Clear()
    self.Text_Input.OnDoubleClicked:Clear()
    self.Text_Input.OnTextChanged:Clear()
    self.Text_Input.OnTextComposing:Clear()
    self.Text_Input.OnTextCommitted:Clear()
    self.Text_Input.OnReleased:Clear()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice) 
    end
end

--region public

---初始化
---@param Config table 配置参数
---@param DialogParams table 弹窗专用参数，不用传
function M:Init(Config,DialogParams)
    -- Config = {
    --     Owner = self, --父对象
    --     Events = {
    --         OnTextChanged = function(Owner,Text),   --文本改变时
    --         OnTextComposing = function(Owner,Text), --文本改变时（中文输入法按选词之前）
    --         OnTextCommitted = function(Owner,Text,CommitMethod), --文本提交时
    --         OnCheckTextLegality = function(Owner,Text) , --文本合法性校验函数，OnTextChanged和OnTextCommitted前会调用
    --                                                      -- 两个返回值：  bool 是否合法（true则将第二个返回值设置给输入框，false则本次输入无效），
    --                                                      --              string 字符串
    --         OnTextLengthExceedLimit = function(Owner,Text) -- 当校验文本长度超过限制时
    --                                                        -- 一个返回值：bool 是否裁剪文本（true或nil都会裁剪文本到最大长度）
    --         OnFocusReceived = function(Owner), --文本框聚焦时
    --         OnFocusLost = function(Owner), --文本框失去聚焦时
    --     },
    --     Text = "", --初始设置的文本，不会触发回调
    --     HintText = "", --空文本时的提示文本
    --     ResidentTipText = "", --常驻的提示文本（仅弹窗内生效）
    --     TextLimit = 9999,    --最大字数限制
    --     bLimitBr = false,    --限制换行符输入
    --     bLimitSpaces = false,  --是否限制连续空格输入，true则文字之间最多包含一个空格
    --     bNeedPasteBtn = false    --是否需要粘贴按钮
    --     FocusKeyName = "X", --手柄聚焦按键样式，默认nil
    --     FocusKey = Const.GamepadFaceButtonLeft, --手柄聚焦按键，也用于退出聚焦
    --     PasteKeyName = "LS", --手柄粘贴按键样式，默认nil
    --     OnGetBackFocusWidget = function --按手柄返回键时获取聚焦控件用的函数
    --     BackFocusWidget = Owner --按手柄返回键时需要聚焦的控件
    -- }
    Config = Config or {}
    self.Owner = Config.Owner
    self:SetText(Config.Text or "")
    self:BindEvent(Config.Events or {})
    self.HintText = Config.HintText or GText("UI_Chat_InputHint")
    self.bLimitBr = Config.bLimitBr
    self.TextLimit = Config.TextLimit or 9999
    self.bLimitSpaces = Config.bLimitSpaces
    self.bNeedPasteBtn = Config.bNeedPasteBtn
    self.HideGamePadDeleteBtn = Config.HideGamePadDeleteBtn
    self.DialogParams = DialogParams
    self.OnGetBackFocusWidget = Config.OnGetBackFocusWidget
    self.BackFocusWidget = Config.BackFocusWidget or (self.DialogParams and self.DialogParams.OwnerDialog) or self.Owner
    self:SetHintText(self.HintText)
    self:SetResidentTips(Config.ResidentTipText)
    self.CurrentText = self:GetText()
    self.ComposingText = self.CurrentText
    self.FocusKey = Config.FocusKey or Const.GamepadFaceButtonLeft
    local FocusKeyName = Config.FocusKeyName or self.DefaultFocusKeyName
    local PasteKeyName = Config.PasteKeyName or self.DefaultPasteKeyName
    self:SetGamePadKey(FocusKeyName,PasteKeyName)
end

---设置手柄按键
---@param FocusKeyName string 聚焦输入框的按键名
---@param PasteKeyName string 粘贴/删除文本的按键名
function M:SetGamePadKey(FocusKeyName,PasteKeyName)
    if(FocusKeyName and PasteKeyName)then
        self.IsShowGamPadKey = true
        local FocusKeyImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(FocusKeyName)
        self.Image_ControllerChooseKey:SetBrushFromTexture(LoadObject(FocusKeyImgPath))
        local PasteKeyImgPath = UIUtils.UtilsGetKeyIconPathInGamepad(PasteKeyName)
        self.Image_ControllerControlKey:SetBrushFromTexture(LoadObject(PasteKeyImgPath))
    else
        self.IsShowGamPadKey = false
    end
    self:UpdateBtns()
    self:UpdateGamePadFocusKey()
end

---绑定事件
---@param Events table 与Init时的Config.Events一样
function M:BindEvent(Events)
    Events = Events or {}
    self.OnTextChanged = Events.OnTextChanged
    self.OnTextComposing = Events.OnTextComposing
    self.OnTextCommitted = Events.OnTextCommitted
    self.OnEditTextFocusEvent = Events.OnFocusReceived
    self.OnEditTextFocusLostEvent = Events.OnFocusLost
    self.OnCheckTextLegality = Events.OnCheckTextLegality
    self.OnTextLengthExceedLimit = Events.OnTextLengthExceedLimit
end

---设置空文本时的提示文本
function M:SetHintText(Text)
    self.Text_Input:SetHintText(Text)
end

---设置文本(会检测合法性)
function M:SetText(Text)
    Text = Text or ""
    self:TrySetText(Text)
end

---插入文本(会检测合法性),暂时不支持多行文本,如果插入后文本被修正光标可能错位
---@param Position number 要插入的位置，0是最左边，传空则插入上一光标位置
function M:InsertText(InStr,Position)
    InStr = InStr or ""
    local NewCursotPos = nil
    if(Position == nil)then
        NewCursotPos = self.CursorOffset + UKismetStringLibrary.Len(InStr)
    end
    Position = Position or self.CursorOffset
    local SelfStr = self.Text_Input:GetText()
    local LeftStr = UE4.UKismetStringLibrary.GetSubstring(SelfStr,0,Position)
    local RightStr = UE4.UKismetStringLibrary.GetSubstring(SelfStr,Position,UE4.UKismetStringLibrary.Len(SelfStr))
    local Text = LeftStr .. InStr .. RightStr
    self:TrySetText(Text)
    if(NewCursotPos)then
        self:SetCursorPosition(self.CursorLineIdx,NewCursotPos)
    end
end

---获取文本
function M:GetText()
    return self.Text_Input:GetText()
end

---设置最大字数限制
---@param TextLimit number
function M:SetTextLimit(TextLimit)
    self.TextLimit = TextLimit
end

---弹出文本不合法的提示
---@param TipText string  提示文本
---@param Style number Tips样式，1:红色（错误）, 2:黄色（警告）, 默认1
function M:ShowTips(TipText,Style,Time)
    if(not TipText)then
        return
    end
    if(self.bTipsShowed and self.TipsText == TipText)then
        return
    end
    self.TipsText = TipText
    Style = Style or 1
    if(self.DialogParams)then
        if(self.HasResidentTips or self.bTipsShowed)then
            self.DialogParams.bHideDialogItem = true
            self.DialogParams.OwnerDialog:BroadcastDialogEvent(DialogEvent.HideDialogItem,self.DialogParams)
        end
        self.DialogParams.bHideDialogItem = false
        self.DialogParams.DialogItemIndex = Style
        self.DialogParams.Tips = self.DialogParams.Tips or {}
        self.DialogParams.Tips[self.DialogParams.DialogItemIndex] = TipText
        self.DialogParams.OwnerDialog:BroadcastDialogEvent("UpdateDialogTipText",self.DialogParams)
        self.DialogParams.OwnerDialog:BroadcastDialogEvent(DialogEvent.HideDialogItem,self.DialogParams)
    else
        self.Group_InputTips:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.InputTips:StopAnimation(self.InputTips.Remind_Out)
        self.InputTips:PlayAnimation(self.InputTips.Remind_In)
        if(Style == 1)then
            self.InputTips.Group_Forbbiden:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            self.InputTips.Group_Limit:SetVisibility(UIConst.VisibilityOp.Collapsed)
        else
            self.InputTips.Group_Forbbiden:SetVisibility(UIConst.VisibilityOp.Collapsed)
            self.InputTips.Group_Limit:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        end
        self.InputTips.Text_InputTips:SetText(TipText)
    end
    self.bTipsShowed = true
    self:RemoveTimer("DelayHideTips")
    if(Time and Time~=0)then
        self:AddTimer(Time,function()
            self:HideTips()
        end,false, 0, "DelayHideTips",true)
    end
end

---设置常驻提示文本（仅弹窗内生效）
function M:SetResidentTips(TipText)
    if(TipText and TipText ~= "")then
        self.HasResidentTips = true
    else
        self.HasResidentTips = false
    end
    if(self.DialogParams)then
        if(self.HasResidentTips)then
            self.DialogParams.Tips = self.DialogParams.Tips or {}
            self.DialogParams.Tips[3] = TipText
            self.DialogParams.OwnerDialog:BroadcastDialogEvent("UpdateDialogTipText",self.DialogParams)
        end
        if(not self.bTipsShowed)then
            self.DialogParams.DialogItemIndex = 3
            self.DialogParams.bHideDialogItem = false
            self.DialogParams.OwnerDialog:BroadcastDialogEvent(DialogEvent.HideDialogItem,self.DialogParams)
        end
    end
end

---隐藏文本不合法提示（自动调用，如无特殊情况不需要手动调）
function M:HideTips()
    if(self.bTipsShowed)then
        self.bTipsShowed = false
        if(self.DialogParams)then
            self.DialogParams.bHideDialogItem = true
                self.DialogParams.OwnerDialog:BroadcastDialogEvent(DialogEvent.HideDialogItem,self.DialogParams)
            if(self.HasResidentTips)then
                self.DialogParams.DialogItemIndex = 3
                self.DialogParams.bHideDialogItem = false
                self.DialogParams.OwnerDialog:BroadcastDialogEvent(DialogEvent.HideDialogItem,self.DialogParams)
            end
        else
            self.InputTips:StopAnimation(self.InputTips.Remind_In)
            self.InputTips:PlayAnimation(self.InputTips.Remind_Out)
        end
    end
end

---粘贴文本
function M:PasteText()
    self:OnPasteBtnClicked()
end

---按输入设备改变按键样式
---@param InputDevice ECommonInputType
function M:ChangeKeyByInputDevice(InputDevice)
    self:RefreshOpInfoByInputDevice(InputDevice)
end

--endregion public

--region private

function M:CheckTextLegality(Text,NeedLengthTips)
    local bLegal = true
    local ResText = Text
        local Len = self:Utf8StrLen(Text)
        if(Len < self.TextLimit)then
            self:HideTips()
        else
            if(NeedLengthTips)then
                self:ShowTips(GText("UI_REGISTER_OVERLENGTH"),2,self.LengthLimitTipsDuration or 1.5)
            end
            local NeedClampText
            if(self.OnTextLengthExceedLimit)then
                NeedClampText = self.OnTextLengthExceedLimit(self.Owner,ResText)
            end
            if(NeedClampText or NeedClampText == nil)then
                ResText = self:ClampText(ResText,self.TextLimit)
            end
        end
    if(self.OnCheckTextLegality)then
        bLegal, ResText = self.OnCheckTextLegality(self.Owner,ResText)
    end
    return bLegal,ResText
end

function M:Utf8StrLen(Str)
    local Len = 0
    local TextTable = StringUtils.Utf8ToTable(Str)
    for _, value in ipairs(TextTable) do
        if(string.len(value) <=1)then
            Len = Len + 1
        else
            Len = Len + 2
        end
    end
    return Len
end

function M:ClampText(Text,MaxLen)
    local Len = 0
    local ResText = ""
    local TextTable = StringUtils.Utf8ToTable(Text)
    local CharLen = 0
    for _, value in ipairs(TextTable) do
        CharLen = string.len(value)
        if(CharLen > 1)then
            CharLen = 2
        end
        if(CharLen + Len <= MaxLen)then
            Len = CharLen + Len
            ResText = ResText .. value
        else
            break
        end
    end
    return ResText
end

function M:FilterSpaceAndBr(Text)
    if(not self.bLimitSpaces and not self.bLimitBr)then
        return Text
    end
    if(self.bLimitBr)then
        --TODO:粘贴带换行的文本后光标位置不对
        Text = string.gsub(Text, "\n", "")
        Text = string.gsub(Text, "\r", "")
    end
    local DeletedSpaceCount = 0
    local DeletedBrCount = 0
    local Res = ""
    local TextTable = StringUtils.Utf8ToTable(Text)
    local bIsLastCharSpace = false
    for _, value in ipairs(TextTable) do
        if(self.bLimitSpaces and (value == " " or value == "　"))then
            if(not bIsLastCharSpace)then
                Res = Res .. value
            else
                DeletedSpaceCount = DeletedSpaceCount + 1
            end
            bIsLastCharSpace = true
        else
            Res = Res .. value
            bIsLastCharSpace = false
        end
    end
    return Res,DeletedSpaceCount,DeletedBrCount
end

function M:HandleOnTextChanged(Text)
    self.NewText = Text
    self.bHasNewText = true
    self.bCursorMoveByComposing = false
    if(CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile")then
        local InputSetting = UE4.UInputSettings.GetInputSettings()
        if(InputSetting and not InputSetting.bUseMouseForTouch)then
            --真实移动端输入时光标不一定改变，临时处理
            self:OnEditTextCursorMoved(0,UKismetStringLibrary.Len(self.NewText))
        end
    end
end

function M:CorrectText(Text,NeedLengthTips)
    Text,self.IgnoredSpaceCount,self.IgnoredBrCount = self:FilterSpaceAndBr(Text)
    local bLegal,LegalText = self:CheckTextLegality(Text,NeedLengthTips)
    if(not bLegal)then
        self:RealSetText(self.CurrentText)
        return false,self.CurrentText
    else
        self:RealSetText(LegalText)
    end
    return true,LegalText
end

function M:HandleOnTextComposing(Text)
    self.bCursorMoveByComposing = true
    self.ComposingText = Text
    self:UpdateBtns()
    if(self.OnTextComposing)then
        self.OnTextComposing(self.Owner,Text)
    end
end

function M:HandleOnTextCommitted(Text,CommitMethod)
    -- local bNeedCallback,CorrectedText = self:CorrectText(Text)
    -- if(not bNeedCallback)then
    --     return
    -- end
    if(self.OnTextCommitted)then
        self.OnTextCommitted(self.Owner,Text,CommitMethod)
    end
end

function M:OnPasteBtnClicked()
    local Str = ULowEntryExtendedStandardLibrary.ClipboardGet()
    Str = string.gsub(Str, "^[%s\n\r\t]*(.-)[%s\n\r\t]*$", "%1")
    self:TrySetText(Str)
    self:FocusInputField()
end

function M:FocusInputField()
    self._bFocusing = true
    self.Text_Input:SetFocus()
    self._bFocusing = false
end

function M:OnDeleteBtnClicked()
    -- 播放点击音效
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)

    self:TrySetText("")
    self:FocusInputField()
end

function M:TrySetText(Text)
    self.Text_Input:SetText(Text)
    self:SetCursorPosition(self.CursorLineIdx,self.CursorOffset + UKismetStringLibrary.Len(Text))
    self:UpdateBtns()
end

function M:RealSetText(Text)
    self.Text_Input.OnTextChanged:Clear()
    self.Text_Input.OnCursorMoved:Clear()
    self.Text_Input:SetText(Text)
    self.Text_Input.OnCursorMoved:Add(self,self.OnEditTextCursorMoved)
    self.Text_Input.OnTextChanged:Add(self,self.HandleOnTextChanged)
    self.CurrentText = Text
    self.ComposingText = Text
    self:UpdateBtns()
end

function M:OnEditTextFocusReceived()
    if(self._bFocusing)then
        self:StopAnimation(self.Normal)
        self:PlayAnimation(self.Press)
        self:PlayAnimation(self.Click)
    end
    self:HideTips()
    if(self.OnEditTextFocusEvent)then
        self.OnEditTextFocusEvent(self.Owner)
    end
end

function M:OnFocusLost(InFocusEvent)
end

function M:OnEditTextFocusLost()
    if(self.bHasNewText)then
        if(CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile")then
            self:OnEditTextCursorMoved(0,UKismetStringLibrary.Len(self.NewText))
        end
    end
    if(self.OnEditTextFocusLostEvent)then
        self.OnEditTextFocusLostEvent(self.Owner)
    end
end

function M:OnEditTextCursorMoved(LineIdx,Offset)
    if(self.bHasNewText)then
        self.bHasNewText = false
        local OldText = self.CurrentText
        local bNeedCallback,CorrectedText = self:CorrectText(self.NewText,true)
        if(bNeedCallback)then
            if(self.OnTextChanged)then
                self.OnTextChanged(self.Owner,CorrectedText)
            end
        else
            --如果文本不合法则不移动光标
            self:SetCursorPosition(self.CursorLineIdx,self.CursorOffset)
            return
        end
        if(CorrectedText ~= OldText and (self.CursorLineIdx ~= LineIdx or self.CursorOffset~= Offset))then
            --文本被改变且需要将光标移到正确的位置
            self.CursorLineIdx = LineIdx -- self.IgnoredBrCount
            self.CursorOffset = Offset - (self.IgnoredSpaceCount or 0) --减去被删除的空格偏移
            self.IgnoredSpaceCount = 0
        end
        self:SetCursorPosition(self.CursorLineIdx,self.CursorOffset)
        return
    end
    if(self.bCursorMoveByComposing)then
        return
    end
    self.CursorLineIdx = LineIdx
    self.CursorOffset = Offset
end

function M:SetCursorPosition(LineIdx,Offset)
    self.Text_Input:CursorGoto(LineIdx,Offset)
end

function M:OnDoubleClicked()
    self.Text_Input:SelectAllText()
end

function M:UpdateBtns()
    --在WBP_Com_Input_C|WBP_Com_Input_Multiline_C中实现
end

function M:UpdateGamePadFocusKey()
    --在WBP_Com_Input_C|WBP_Com_Input_Multiline_C中实现
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    if(CurInputDevice == ECommonInputType.Gamepad)then
        self.Text_Input.HoverAnimName = ""
    else
        self.Text_Input.HoverAnimName = "Hover"
    end
    if(self.Text_Input:HasAnyUserFocus() and self.CurInputDeviceType == ECommonInputType.Gamepad)then
        self.Text_Input.HoverAnimName = ""
        self.IsLastInputDeviceTypeGamepad = true
    else
        self.IsLastInputDeviceTypeGamepad = false
    end
    self.CurInputDeviceType = CurInputDevice
    self:UpdateBtns()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (InKeyName == Const.GamepadFaceButtonRight or InKeyName == self.FocusKey)
    and self.Text_Input:HasAnyUserFocus()
    and self.CurInputDeviceType == ECommonInputType.Gamepad then
        local Widget
        if(self.OnGetBackFocusWidget)then
            Widget = self.OnGetBackFocusWidget(self.Owner)
        end
        Widget = Widget or self.BackFocusWidget
        if(Widget)then
            return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(),Widget)
        end
    end
    return UIUtils.Unhandled
end

--endregion private

return M

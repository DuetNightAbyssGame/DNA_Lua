---WBP_Com_Dialog_PanelNum.lua
require "UnLua"

local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    self.CursorLineIdx = 0
    self.CursorOffset = 0
    self.CurrentText = ""
    self.bHasNewText = false

    if self.Text_Input then
        self.Text_Input.OnTextChanged:Add(self, self.OnInputTextChanged)
        self.Text_Input.OnTextComposing:Add(self, self.OnTextComposing)
        self.Text_Input.OnPressed:Add(self, self.ExecOnTextOnPressed)
        self.Text_Input.OnTextCommitted:Add(self, self.ExecOnTextCommintted)
        self.Text_Input.OnFocusReceived:Add(self,self.EditOnTextFocusReceived)
        self.Text_Input.OnFocusLost:Add(self,self.EditOnTextFocusLost)
        self.Text_Input.OnCursorMoved:Add(self, self.OnEditTextCursorMoved)
        self.CurrentText = self.Text_Input:GetText()
        self.CursorOffset = string.len(self.CurrentText)
    end

    self:PlayAnimation(self.Click)

    if not UIUtils.IsGamepadInput() then
        self.Text_Input:SetKeyboardFocus()
    end
end

function M:Init(Params)
    self.InputCallback = Params.InputCallback or nil
    self.OwnerPanel = Params.OwnerPanel or nil
    self.TextLimit = Params.TextLimit or 9999
    self.OnDataChangedCallback = Params.OnDataChanged or nil
end

function M:SetTextLimit(Limit)
    self.TextLimit = Limit or 9999
end

function M:OnInputTextChanged(Text)
    -- 强制整数模式：过滤掉所有非数字字符
    local FilteredText = string.gsub(Text, "%D", "")

    if string.len(FilteredText) > self.TextLimit then
        if self.Text_Input:GetText() ~= self.CurrentText then
            self.Text_Input:SetText(self.CurrentText)
            self:SetCursorPosition(0, self.CursorOffset)
        end
        if not self.bIsLimitTipShowing then
            self.OwnerPanel:ShowTip("UI_Number_MaxNumber", false)
            self.bIsLimitTipShowing = true
        end
        return
    else
        if self.bIsLimitTipShowing then
            self.OwnerPanel:HideTip()
            self.bIsLimitTipShowing = false
        end
    end

    -- 如果文本发生了变化，更新输入框
    -- 注意：这里需要小心处理，避免无限递归
    if FilteredText ~= Text then
        local RestorePos = self.CursorOffset
        self.Text_Input:SetText(FilteredText)
        self:SetCursorPosition(0, RestorePos)
        return
    end
    self.CurrentText = FilteredText

    if self.OnDataChangedCallback then
        self.OnDataChangedCallback(FilteredText)
    end
end

--输入法组合时会调用这个事件而不是OnInputTextChanged
function M:OnTextComposing(Text)
    -- 强制整数模式：过滤掉所有非数字字符
    local FilteredText = string.gsub(Text, "%D", "")

    if string.len(FilteredText) > self.TextLimit then
        if self.Text_Input:GetText() ~= self.CurrentText then
            self.Text_Input:SetText(self.CurrentText)
            self:SetCursorPosition(0, self.CursorOffset)
        end
        return
    else
    end

    -- 如果文本发生了变化，更新输入框
    if FilteredText ~= Text then
        self.Text_Input:SetText(FilteredText)
    end
    self.CurrentText = FilteredText
end

function M:ExecOnTextOnPressed()
    self.Text_Input:SetText(tostring(self.CurrentText))
    self.Text_Input:SetRenderOpacity(1.0)
end

function M:ExecOnTextCommintted(InText, CommitType)
    local TempNumber = InText ~= "" and tonumber(InText) or 1
    local OldNumberValue = self.CurrentText
    -- self.CurrentText = math.min(self.MaxValue, math.max(TempNumber, self.MinValue))

    -- 刷新面板信息
    -- self.Btn_Add:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    -- self.Btn_Max:ForbidBtn(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    -- self.Btn_Min:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)
    -- self.Btn_Mini:ForbidBtn(self.CurInputNumber - self.ClickInterval < self.MinValue)

    -- self.Btn_NumRight:SetForbid(self.CurInputNumber + self.ClickInterval > self.MaxValue)
    -- self.Btn_NumLeft:SetForbid(self.CurInputNumber - self.ClickInterval < self.MinValue)

    -- self.Text_Num:SetText(tostring(self.CurInputNumber))
    -- self.Text_Input:SetRenderOpacity(0.0)
    -- self.Text_Num:SetVisibility(UIConst.VisibilityOp["SelfHitTestInvisible"])

    if (type(self.InputCallback) == "function") then
        self.InputCallback(self.OwnerPanel, self.CurrentText, OldNumberValue)
    end
    -- self.IsInNumInputState = false
end

function M:EditOnTextFocusReceived()
    -- 获得聚焦
    -- self:ExecOnTextOnPressed()
end

function M:EditOnTextFocusLost()
    -- 失去聚焦
    -- self:AddTimer(0.1, self.OnReturnFocusToWidget, false, 0, "OnReturnFocusToWidget", true)
end

function M:OnEditTextCursorMoved(LineIdx, Offset)
    -- 处理输入法提交时的光标修正逻辑
    if(self.bHasNewText)then
        self.bHasNewText = false
        local OldText = self.CurrentText
        self.CurrentText = self.NewText
        
        -- 简单处理：更新光标
        self:SetCursorPosition(LineIdx, Offset)
        self.CursorLineIdx = LineIdx
        self.CursorOffset = Offset
        return
    end
    
    self.CursorLineIdx = LineIdx
    self.CursorOffset = Offset
end

function M:SetCursorPosition(LineIdx, Offset)
    if self.Text_Input then
        self.Text_Input:CursorGoto(LineIdx, Offset)
    end
end

--endregion

--region 对外接口 (供 InputNum 调用)

---设置初始文本
function M:SetText(Text)
    if self.Text_Input then
        self.Text_Input:SetText(Text)
        self.CurrentText = Text
        
        if not UIUtils.IsGamepadInput() then
            self.Text_Input:SetKeyboardFocus()
        end
        -- 光标移到最后
        self.CursorOffset = string.len(Text)
        self:SetCursorPosition(0, self.CursorOffset)
    end
end

---获取文本
function M:GetText()
    if self.Text_Input then
        return self.Text_Input:GetText()
    end
    return ""
end

---在光标处插入文本 (数字键逻辑)
function M:InsertTextAtCursor(InStr)
    if not self.Text_Input then return end
    
    local Position = self.CursorOffset
    local SelfStr = self.Text_Input:GetText()
    local Len = string.len(SelfStr)

    if Len + string.len(InStr) > self.TextLimit then
        if not self.bIsLimitTipShowing then
            self.OwnerPanel:ShowTip("UI_Number_MaxNumber", false)
            self.bIsLimitTipShowing = true
        end
        if not UIUtils.IsGamepadInput() then
            self.Text_Input:SetKeyboardFocus()
        end
        self:SetCursorPosition(0, Position)
        return
    else
    end

    if Position > Len then Position = Len end
    local LeftStr = string.sub(SelfStr, 1, Position)
    local RightStr = string.sub(SelfStr, Position + 1)
    local NewText = LeftStr .. InStr .. RightStr

    self.Text_Input:SetText(NewText)
    self.CurrentText = NewText

    local NewCursorPos = Position + string.len(InStr)
    self.CursorOffset = NewCursorPos

    if not UIUtils.IsGamepadInput() then
        self.Text_Input:SetKeyboardFocus()
    end
    self:SetCursorPosition(0, NewCursorPos)
end

---删除光标前的一个字符 (退格键逻辑)
function M:DeleteTextBack()
    if not self.Text_Input then return end

    local Position = self.CursorOffset
    local SelfStr = self.Text_Input:GetText()

    if Position <= 0 or SelfStr == "" then
        if not UIUtils.IsGamepadInput() then
            self.Text_Input:SetKeyboardFocus()
        end
        self:SetCursorPosition(0, Position)
        return
    end

    local LeftStr = string.sub(SelfStr, 1, Position - 1)
    local RightStr = string.sub(SelfStr, Position + 1)
    local NewText = LeftStr .. RightStr

    self.Text_Input:SetText(NewText)
    self.CurrentText = NewText

    local NewCursorPos = Position - 1
    self.CursorOffset = NewCursorPos

    if not UIUtils.IsGamepadInput() then
        self.Text_Input:SetKeyboardFocus()
    end
    self:SetCursorPosition(0, NewCursorPos)
end

--endregion

return M
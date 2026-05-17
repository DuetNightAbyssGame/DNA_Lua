--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"

---@type WBP_Com_Dialog_Input_C
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

--function M:Initialize(Initializer)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:PreInitContent(Params, PopupData, Owner)
    self.Super.PreInitContent(self, Params, PopupData, Owner)
    if not Params then return end
    if(Params.UseGenaral)then
        self._components = {
            "BluePrints.UI.UI_PC.Common.Common_Dialog.WBP_CommonDialog_InputGenaral_C"
        }
    elseif(Params.UseReName) then
        self._components = {
            "BluePrints.UI.UI_PC.Common.Common_Dialog.WBP_CommonDialog_Input_PC_C"
        }
    end
    AssembleComponents(self)
end

function M:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self.PackageKey = "ComDialogInput"
    self.Params = Params
    self.bNeedCheckStringSensitive = false
    self.OnCheckStringSensitive = nil
    Owner.bShoulFocusToLastFocusedWidget = false
    Params.OwnerDialog = Owner
    local EditTextConfig = Params.EditTextConfig or {}
    self.bNeedCheckStringSensitive = EditTextConfig.bNeedCheckStringSensitive
    self.OnCheckStringSensitive =  EditTextConfig.OnCheckStringSensitive
    self.bNotAllowEmpty = EditTextConfig.bNotAllowEmpty
    Params.OwnerDialog = Owner
    if(Params.IsMultiLine)then
        self.WS_Input:SetActiveWidgetIndex(0)
        self.CurrentInputWidget = self.Input_Multiline
        self.Input_Multiline:Init(EditTextConfig,Params)
    else
        self.WS_Input:SetActiveWidgetIndex(1)
        self.CurrentInputWidget = self.Input
        self.Input:Init(EditTextConfig,Params)
    end
    if(self.bNeedCheckStringSensitive)then
        self.bSuccess = false
        Owner.DontCloseWhenRightBtnClicked = true
        self:BindDialogEvent(DialogEvent.OnRightBtnClicked, self.OnDialogRightBtnClicked)
    end
    self:InitContentComp(Params, PopupData, Owner)
end

function M:OnDialogRightBtnClicked()
    local Str = self:GetText()
    if(self.bNotAllowEmpty)then
        local TrimStr = string.trim(Str)
        if(TrimStr == "")then
            self:ShowTips(GText("UI_REGISTER_EMPTY"),2)
            return
        end
    end
    if(self.bNeedCheckStringSensitive)then
        HeroUSDKUtils.CheckStringSensitive(self, Str,
        function()
            self.bSuccess = false
            self:ShowTips(GText("UI_REGISTER_BANNEDINPUT"),1)
            if(self.OnCheckStringSensitive)then
                self.OnCheckStringSensitive(self.Params.Owner,self.bSuccess,self:GetText())
            end
        end,
        function()
            self.bSuccess = true
            if(self.OnCheckStringSensitive)then
                self.OnCheckStringSensitive(self.Params.Owner,self.bSuccess,self:GetText())
            end
            self.Params.OwnerDialog:OnClose()
        end, false)
    end
end

function M:PackageData()
    return {Text = self:GetText(),bSuccess = self.bSuccess}
end

function M:InitContentComp(Params, PopupData, Owner)
end

---设置手柄按键
---@param FocusKeyName string 聚焦输入框的按键名
---@param PasteKeyName string 粘贴/删除文本的按键名
function M:SetGamePadKey(FocusKeyName,PasteKeyName)
    self.CurrentInputWidget:SetGamePadKey(FocusKeyName,PasteKeyName)
end

---绑定事件
function M:BindEvent(Events)
    self.CurrentInputWidget:BindEvent(Events)
end


---设置空文本时的提示文本
function M:SetHintText(Text)
    self.CurrentInputWidget:SetHintText(Text)
end

---设置文本(会检测合法性)
function M:SetText(Text)
    self.CurrentInputWidget:SetText(Text)
end

---插入文本(会检测合法性)
---@param Position number 要插入的位置，0是最左边，传空则插入上一光标位置
function M:InsertText(InStr,Position)
    self.CurrentInputWidget:InsertText(InStr,Position)
end

---获取文本
function M:GetText()
    return self.CurrentInputWidget:GetText()
end

---设置最大字数限制
---@param TextLimit number
function M:SetTextLimit(TextLimit)
    self.CurrentInputWidget:SetTextLimit(TextLimit)
end

---弹出文本不合法的提示
---@param TipText string  提示文本
---@param Style number Tips样式，1:红色（错误）, 2:黄色（警告），默认1
function M:ShowTips(TipText,Style)
    self.CurrentInputWidget:ShowTips(TipText,Style)
end

---设置常驻的提示（灰色样式）
function M:SetResidentTips(TipText)
    self.CurrentInputWidget:SetResidentTips(TipText)
end

---隐藏文本不合法提示（自动调用，如无特殊情况不需要手动调）
function M:HideTips()
    self.CurrentInputWidget:HideTips()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_LeftThumbstick") then
            self.CurrentInputWidget:SetText("")
        elseif (InKeyName == "Gamepad_FaceButton_Left") then  
            self.CurrentInputWidget:SetFocus()
        end
    end
end

function M:OnContentFocusReceived()
    --self.CurrentInputWidget:SetFocus()
end

return M

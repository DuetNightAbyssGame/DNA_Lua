--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

require "UnLua"
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"
local StringUtils = require "Utils.StringUtils"

---@type WBP_Com_Dialog_InputNew_C|Common_Dialog_ContentBase|BP_UIState|TimerMgr
local Component = {}

function Component:OnClickButtonContinue()
    local Text = self.Common_EditText:GetText()
    HeroUSDKUtils.CheckStringSensitive(self, Text, self.OnTextSensitive, self.OnTextQualified)
end

function Component:OnTextSensitive(ReplaceName, Text, Words)
    self.bLegal = false
    self.Common_EditText:ShowTips(GText("UI_REGISTER_BANNEDINPUT"), 1)
    self.Owner.DontCloseWhenRightBtnClicked = true
    if self.Params.OnSDKChecked then
        self.Params.OnSDKChecked(false,self, ReplaceName, Text, Words)
    end
end

function Component:OnTextQualified(InText)
    self.bLegal = true
    local NewText = InText
    if self.Params.OnSDKChecked then
        self.Params.OnSDKChecked(true,self, NewText)
    end
    self.Owner:OnClose()
end


function Component:StartNormalTimer()
    self:StopNormalTimer()
    local _,NormalTimerKey = self:AddTimer(1.5, function()
        self.NormalTimerKey = nil
    end)
    self.NormalTimerKey = NormalTimerKey
end

function Component:StopNormalTimer()
    if self.NormalTimerKey and self:IsExistTimer(self.NormalTimerKey) then
        self:RemoveTimer(self.NormalTimerKey)
        self.NormalTimerKey = nil
    end
end

function Component:ShowBeyondHintWithCD()
    if self.BeyondTimerKey and self:IsExistTimer(self.BeyondTimerKey) then
        return
    end
    local _,BeyondTimerKey = self:AddTimer(1.5, function()
        self.BeyondTimerKey = nil
    end)
    self.BeyondTimerKey = BeyondTimerKey
end

function Component:OnTextChange(InText,bComposing)
    if InText == "" then
        self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(true)
        return ""
    end
    self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(false)
    local NewText = InText
    local bLegal, IllegalRange =StringUtils.CheckUtf8StrCJKLegal(InText)
    self.bLegal = bLegal
    local LenMax = self.Params.TextLenMax * (bComposing and 2 or 1)
    if utf8.len(NewText) > LenMax then
        NewText = table.concat({table.unpack(StringUtils.Utf8ToTable(NewText),1,self.Params.TextLenMax)})
        if self.bLegal then
            self.Common_EditText:SetText(NewText)
            self:ShowBeyondHintWithCD()
            self:StartNormalTimer()
        end
    end
    if not self.bLegal then
        self.Common_EditText:SetText(NewText)
    end
    return NewText
end


---@alias DialogInputParams {DefaultText:string,MultilineType:number, TextLenMax:number, HintText:string, OnSDKChecked:fun(bRes:boolean, InputWidget:Common_Dialog_Input_PC_C,...),}
---@param Params DialogInputParams
function Component:InitContentComp(Params, PopupData, Owner)
    ---@type DialogInputParams
    self.Params = Params
    local Index = Params.MultilineType ---0:Mulitline , 1:Singleline
    self.WS_Input:SetActiveWidgetIndex(Index)
    if Index == 0 then     
        ---@type WBP_Com_Input_Base_Component_C
        self.Common_EditText = self.Input_Multiline
    elseif Index == 1 then
        ---@type WBP_Com_Input_Base_Component_C
        self.Common_EditText = self.Input
    end
    self.Common_EditText:Init({
        Owner = self,
        HintText = Params.HintText,
        TextLimit = Params.TextLenMax,
        Events = {
            OnTextChanged = function(self, InText)
                self:OnTextChange(InText)
            end
        }
    },Params)
    if Params.DefaultText then
        self.Owner:GetButtonBar().Btn_Yes:ForbidBtn(false)
        self.Common_EditText:SetText(Params.DefaultText)
    end
    self:BindDialogEvent(DialogEvent.OnRightBtnClicked, function ()
        self.Owner.DontCloseWhenRightBtnClicked=true
        if not self.Owner:GetButtonBar().Btn_Yes.IsForbidden then
            self:OnClickButtonContinue()
        end
    end)
    self.Owner:GetButtonBar().Btn_Yes:BindForbidStateExecuteEvent(self, function()
        self.Common_EditText:ShowTips(GText("UI_REGISTER_EMPTY"), 2)
    end)
    self.Owner.DontCloseWhenRightBtnClicked=true
end

-- function Component:ShowHint(PopInfo, SoundPath, bCloseTip)
--     if bCloseTip == nil then bCloseTip = false end
--     local PopupConf = DataMgr.CommonPopupUIContext[PopInfo[1]]
--     if not PopupConf or not PopupConf.Style then return end
--     local Params = {}
--     Params.DontCloseWhenRightBtnClicked=true
--     if PopInfo[2] then
--         Params.Tips = {PopInfo[2],}
--     end
--     if self.Common_EditText:GetText() == "" then
--         Params.ForbidRightBtn=true
--     end
--     if SoundPath then
--         AudioManager(self):PlayUISound(self, SoundPath, nil, nil)
--     end
--     if not bCloseTip then
--         --self.Owner.VB_Node:RemoveChildAt(1)
--         self.Owner:UpdateView(PopupConf.Style,Params, PopupConf)
--         self:BindDialogEvent(DialogEvent.OnRightBtnClicked, function ()
--             self.Owner.DontCloseWhenRightBtnClicked=true
--             if not self.Owner:GetButtonBar().Btn_Yes.IsForbidden then
--                 self:OnClickButtonContinue()
--             end
--         end)
--     end
--     Params.bHideDialogItem = bCloseTip
--     Params.DialogItemIndex = 1
--     Params.bShouldPlayAnim = true
--     self:BroadcastDialogEvent(DialogEvent.HideDialogItem, Params)
    
-- end

return Component

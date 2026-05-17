--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Com_Input_Multiline_C|WBP_Com_Input_Base_Component_C
local M = Class({
    "BluePrints.Common.TimerMgr",
    "BluePrints.UI.BP_EMUserWidget_C",
})
M._components = {
    "BluePrints.UI.WBP.Common.Input.WBP_Com_Input_Base_Component_C"
}
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Group_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_ControllerChoose:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_ControllerChoose:SetText(GText("UI_Input_Input"))
    self.Text_Btn:SetText("")
    self.Btn_Paste.OnClicked:Clear()
    self.Btn_Paste.OnClicked:Add(self,self.OnBtnClicked)
    self.bIsFocusable = true
end

function M:SetLineHeightPercentage(LineHeight)
    self.Text_Input.LineHeightPercentage = LineHeight
end

function M:OnBtnClicked()
    if(self:GetText() == "")then
        self:OnPasteBtnClicked()
    else
        self:OnDeleteBtnClicked()
    end
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

--function M:Destruct()
--end

function M:UpdateBtns()
    self.Group_Btn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Image_Btn_BG:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if(self.IsShowGamPadKey and self.CurInputDeviceType == ECommonInputType.Gamepad)then
        if(self:GetText() == "")then
            if(self.bNeedPasteBtn)then
                self.WS_Icon:SetActiveWidgetIndex(2)
                self.Text_Btn:SetText(GText("UI_Input_Paste"))
            else
                self.Group_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
                self.Image_Btn_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        else
            if not self.HideGamePadDeleteBtn then
                self.WS_Icon:SetActiveWidgetIndex(2)
                self.Text_Btn:SetText(GText("UI_Input_Clean"))
            else
                self.Group_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
                self.Image_Btn_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end
    else
        if(self:GetText() == "")then
            if(self.bNeedPasteBtn)then
                self.WS_Icon:SetActiveWidgetIndex(0)
                self.Text_Btn:SetText(GText("UI_Input_Paste"))
            else
                self.Group_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
                self.Image_Btn_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        else
            -- if(self.IsShowGamPadKey and self.IsLastInputDeviceTypeGamepad and self.Text_Input:HasAnyUserFocus())then
            --     self.WS_Icon:SetActiveWidgetIndex(2)
            -- else
            --     self.WS_Icon:SetActiveWidgetIndex(1)
            -- end
          if(self.bNeedPasteBtn)then
                self.WS_Icon:SetActiveWidgetIndex(1)
                self.Text_Btn:SetText(GText("UI_Input_Clean"))
            else
                self.Group_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
                self.Image_Btn_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
            end
        end
    end
    self:UpdateGamePadFocusKey()
end

function M:UpdateGamePadFocusKey()
    if(self.IsShowGamPadKey)then
        if(self.CurInputDeviceType == ECommonInputType.Gamepad)then
            if(self.Text_Input:HasAnyUserFocus())then
                self.HB_ControllerChoose:SetVisibility(UIConst.VisibilityOp.Collapsed)
            else
                self.HB_ControllerChoose:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
            end
        else
            self.HB_ControllerChoose:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
    else
        self.HB_ControllerChoose:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnEditTextFocusReceived()
    self:UpdateGamePadFocusKey()
end

function M:OnEditTextFocusLost()
    self:UpdateGamePadFocusKey()
    if(self.IsLastInputDeviceTypeGamepad)then
        self.IsLastInputDeviceTypeGamepad = false
        self:UpdateBtns()
    end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if(not self.Text_Input:HasAnyUserFocus())then
        self:FocusInputField()
    end
    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

AssembleComponents(M)
return M

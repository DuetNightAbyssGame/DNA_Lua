require "UnLua"

---@class Common_Dialog_Text01_PC_C : WBP_Com_Dialog_Btn_C
local WBP_Common_Dialog_Button_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")




---@param Params Common_Dialog_Params
function WBP_Common_Dialog_Button_PC_C:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    local PopupStyle = DataMgr.CommonPopupUIStyle[PopupData.Style]
    if self.Btn_Switch then 
        if PopupStyle.ShowFlipPage then 
            self.Btn_Switch:SetActiveWidgetIndex(1) 
            self:InitPageFlitStyle(Params, PopupData, Owner) 
        else
            self.Btn_Switch:SetActiveWidgetIndex(0) 
            self:InitButtonStyle(Params, PopupData, Owner)
        end
    end
    self:InitInputSettings()
end

function WBP_Common_Dialog_Button_PC_C:InitInputSettings()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)

    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

-- 显示页签风格
function WBP_Common_Dialog_Button_PC_C:InitPageFlitStyle(Params, PopupData, Owner)
    local PopupStyle = DataMgr.CommonPopupUIStyle[PopupData.Style]
    self.Flip_Page_PC:InitContent(Params, PopupData, Owner)
end

function WBP_Common_Dialog_Button_PC_C:BindOnLeftClickFunc(Obj, OnClickedFunc, OnForbiddenClickedFunc)
    self.Btn_Quit:BindEventOnClicked(Obj, OnClickedFunc)
    self.Btn_Quit:BindForbidStateExecuteEvent(Obj, OnForbiddenClickedFunc)
end

function WBP_Common_Dialog_Button_PC_C:BindOnRightClickFunc(Obj, OnClickedFunc, OnForbiddenClickedFunc)
    self.Btn_Yes:BindEventOnClicked(Obj, OnClickedFunc)
    self.Btn_Yes:BindForbidStateExecuteEvent(Obj, OnForbiddenClickedFunc)
end


-- 显示按钮风格
function WBP_Common_Dialog_Button_PC_C:InitButtonStyle(Params, PopupData, Owner)
    self.HideBtnQuitIcon = nil
    self.HideBtnYesIcon = nil
    -- 绑定弹窗的事件
    self:BindOnLeftClickFunc(Owner, Owner.OnLeftBtnClicked, Owner.OnForbiddenLeftBtnClicked)
    self:BindOnRightClickFunc(Owner, Owner.OnRightBtnClicked, Owner.OnForbiddenRightBtnClicked)

    local PopupStyle = DataMgr.CommonPopupUIStyle[PopupData.Style]
    local ButtonNum = (PopupStyle.ShowLeftButton and 1 or 0) + (PopupStyle.ShowRightButton and 1 or 0)

    self.Btn_Yes:SetBtnHovered(false)
    self.Btn_Yes.SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
    end
    self.Btn_Quit:SetBtnHovered(false) 
    self.Btn_Quit.SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", nil, nil)
    end
    
    -- 显示左侧按钮
    if PopupStyle.ShowLeftButton then 
        local Text = nil
        if PopupData then Text = Text or PopupData.NoButtonText end
        if Params and Params.NoButtonText then
            Text = Params.NoButtonText
        end
        self.Btn_Quit:SetText(GText(Text or "UI_PATCH_CANCEL"))
        self.Btn_Quit:SetIconPanelVisibility(UE4.ESlateVisibility.Visible)
        self.Panel_Quit:SetVisibility(UE4.ESlateVisibility.Visible) 

        if Params and Params.ForbidLeftBtn then
            self.Btn_Quit:ForbidBtn(true)
        else
            if PopupStyle.ShowLeftButton == 2 then 
                self.Btn_Quit:ForbidBtn(true)
            else
                self.Btn_Quit:ForbidBtn(false)
            end
        end

        if Params and Params.LeftGamepadImg then 
            self.Btn_Quit:SetDefaultGamePadImg(Params.LeftGamepadImg)
        end

        if PopupData.NoButtonIconPath then 
            self.Btn_Quit:SetNewIcon(PopupData.NoButtonIconPath)
        end

        if PopupData.NoButtonRGBA then 
            self.Btn_Quit:SetIconColor(PopupData.NoButtonRGBA)
        end

        if Params and Params.NoButtonPCKey then
            self.HideBtnQuitIcon = true
            self.Btn_Quit:SetPCImg(Params.NoButtonPCKey)
            self.Btn_Quit:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
        end

    else
        self.Panel_Quit:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    -- 显示右侧按钮
    if PopupStyle.ShowRightButton then 
        local Text = nil
        if PopupData then Text = Text or PopupData.YesButtonText end
        if Params and Params.YesButtonText then
            Text = Params.YesButtonText
        end
        self.Btn_Yes:SetText(GText(Text or "UI_PATCH_ENSURE"))
        self.Btn_Yes:SetIconPanelVisibility(UE4.ESlateVisibility.Visible)
        self.Panel_Yes:SetVisibility(UE4.ESlateVisibility.Visible)

        if Params and Params.ForbidRightBtn then
            self.Btn_Yes:ForbidBtn(true)
        else
            if PopupStyle.ShowRightButton == 2 then 
                self.Btn_Yes:ForbidBtn(true)
            else
                self.Btn_Yes:ForbidBtn(false)
            end
        end

        if Params and Params.RightGamepadImg then 
            self.Btn_Yes:SetDefaultGamePadImg(Params.RightGamepadImg)
        end

        if PopupData.YesButtonIconPath then 
            self.Btn_Yes:SetNewIcon(PopupData.YesButtonIconPath)
        end

        if PopupData.YesButtonRGBA then 
            self.Btn_Yes:SetIconColor(PopupData.YesButtonRGBA)
        end

        if Params and Params.YesButtonPCKey then 
            self.HideBtnYesIcon = true
            self.Btn_Yes:SetPCImg(Params.YesButtonPCKey)
            self.Btn_Yes:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
        end

    else 
        self.Panel_Yes:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function WBP_Common_Dialog_Button_PC_C:SimulateLeftBtnClick()
    self.Btn_Quit:OnBtnPressed()
    self.Btn_Quit:OnBtnClicked()
end

function WBP_Common_Dialog_Button_PC_C:SimulateRightBtnClick()
    self.Btn_Yes:OnBtnPressed()
    self.Btn_Yes:OnBtnClicked()
end

function WBP_Common_Dialog_Button_PC_C:ForbidLeftBtn(IsForbid)
    self.Btn_Quit:ForbidBtn(IsForbid)
end

function WBP_Common_Dialog_Button_PC_C:ForbidRightBtn(IsForbid)
    self.Btn_Yes:ForbidBtn(IsForbid)
end

function WBP_Common_Dialog_Button_PC_C:IsLeftBtnForbidden()
    return self.Btn_Quit:IsBtnForbidden()
end

function WBP_Common_Dialog_Button_PC_C:IsRightBtnForbidden()
    return self.Btn_Yes:IsBtnForbidden()
end


function WBP_Common_Dialog_Button_PC_C:SetGamepadBtnKeyVisibility(IsShow)
    if IsShow then 
        self.Btn_Quit:OverrideGamePadVisibility(nil)
        self.Btn_Yes:OverrideGamePadVisibility(nil)
        self.Btn_Quit:SetGamePadVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else 
        self.Btn_Quit:OverrideGamePadVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Yes:OverrideGamePadVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Quit:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
    end

end

function WBP_Common_Dialog_Button_PC_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    
    --更新UI
    if self.CurInputDeviceType == ECommonInputType.Gamepad then
        self.Btn_Yes:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.Btn_Quit:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        self.Btn_Yes:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Quit:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.Btn_Yes:SetVisibility(UE4.ESlateVisibility.Visible)
        self.Btn_Quit:SetVisibility(UE4.ESlateVisibility.Visible)
        if not self.HideBtnYesIcon then
            self.Btn_Yes:SetIconPanelVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Btn_Yes:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if not self.HideBtnQuitIcon then
            self.Btn_Quit:SetIconPanelVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.Btn_Quit:SetIconPanelVisibility(UE4.ESlateVisibility.Collapsed)
        end
    end
end


return WBP_Common_Dialog_Button_PC_C
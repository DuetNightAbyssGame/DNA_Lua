require "UnLua"

---@class WBP_Common_Dialog_Title_PC_C : WBP_Com_DialogTitle_C
local WBP_Common_Dialog_Title_PC_C = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

WBP_Common_Dialog_Title_PC_C._components = {
    "Blueprints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_Title.Common_Dialog_TitleBase"
}

---@param Params Common_Dialog_Params
function WBP_Common_Dialog_Title_PC_C:InitContent(Params, PopupData, Owner)
    self.Super.InitContent(self, Params, PopupData, Owner)
    self:RegisterCloseButton(self.BtnClose, PopupData)

    local Text = nil 
    if PopupData then Text = Text or PopupData.Title end
    if Params and Params.Title then Text = Params.Title end
    if Text then 
        self.Text_Title:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Text_Title:SetText(GText(Text))
    else
        self.Text_Title:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    if Params and Params.TitleWidget then 
        local Widget = UIManager(self):_CreateWidgetNew(Params.TitleWidget)
        if Widget then
            self.Pos_Info:AddChild(Widget)
            if Widget.InitContent then
                Widget:InitContent(Params, PopupData, Owner)
            end
            self.TitleWidget = Widget
        end
    end

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    end

    self:RefreshOpInfoByInputDevice()
end

-- function WBP_Common_Dialog_Title_PC_C:BindOnCloseButtonClicked(Obj, ClickedFunc)
--     self.BtnClose:BindEventOnClicked(Obj, ClickedFunc)
-- end

function WBP_Common_Dialog_Title_PC_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
    if not self.NotShowCloseButton then 
        if self.CurInputDeviceType == UE4.ECommonInputType.Gamepad then 
            self.BtnClose:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        else
            self.BtnClose:SetVisibility(UE4.ESlateVisibility.Visible)        
        end
    end
end


function WBP_Common_Dialog_Title_PC_C:GetTitleSubWidget(Index)
    return self.Pos_Info:GetChildAt(Index)
end


AssembleComponents(WBP_Common_Dialog_Title_PC_C)

return WBP_Common_Dialog_Title_PC_C
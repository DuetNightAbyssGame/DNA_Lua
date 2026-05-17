require "UnLua"

local S = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function S:Construct()
    self:AddInputMethodChangedListen()
end

function S:InitContent(Params, PopupData, Owner)
    S.Super.InitContent(self, Params, PopupData, Owner)
    self.Parent = Params.Parent
    self.Data = Params.Data
    self.Text_Log:SetText(GText("UI_OPTION_Log"))
    self.Text_Upload:SetText(GText("UI_OPTION_LogUpdate"))
    self.Text_Upload_1:SetText(GText("UI_OPTION_LogUpdate"))
    self.Text_Hint:SetText(GText("UI_OPTION_NeedLog"))
    self.Text_Clean:SetText(GText("UI_OPTION_LogClean"))

    self.Btn_Clean.Button_Area.OnClicked:Clear()
    self.Btn_Clean.Button_Area.OnClicked:Add(self, self.OnLogCleanClicked) 
    self.Btn_Upload.Button_Area.OnClicked:Clear()
    self.Btn_Upload.Button_Area.OnClicked:Add(self, self.OnUploadLogClicked) 
    self.SwitchCheckBox:AddEventOnCheckStateChanged(self, self.OnEnhanceLogStateChange)
    self.EnhanceLogSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEnhanceLogSubsystem:StaticClass())
    self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem(self)
    self:RestoreState(self.EnhanceLogSubsystem)
end

function S:InitGamepadView()
    if not self.GamepadAKeyIndex then 
        self.GamepadAKeyIndex = self:ShowGamepadShortcutBtn({
            KeyInfoList = {
                { Type = "Img", ImgShortPath = "A", Owner = self }
            },
            Desc = GText("UI_Tips_Ensure"),
            bLongPress = false,
        })
    end
    self:ShowGamepadShortcut(self.GamepadAKeyIndex)
    self:ShowGamepadShortcut(self.GamepadAKeyIndex + 1)
end

function S:RestoreState(EnhanceLogSubsystem)
    local IsEnhanceLog = EnhanceLogSubsystem and EnhanceLogSubsystem:GetEnableEnhanceLog()
    self.WS_Upload:SetActiveWidgetIndex(IsEnhanceLog and 1 or 0)
    self.SwitchCheckBox:SetChecked(IsEnhanceLog, false)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    local InterruptId = self.Data.InterruptId
    self.Data.InterruptId = nil
    if InterruptId then 
        if InterruptId == 100280 then 
            self.SwitchCheckBox:SetFocus()
        elseif InterruptId == 100281 and IsEnhanceLog then 
            self.Text_Upload_1:SetFocus()
        else 
            self.Btn_Clean:SetFocus()
        end
    else 
        self.Btn_Clean:SetFocus()
    end
end

function S:ShowCommonPopupUI_Interrupt(InterruptId, Params)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    self.Data.InterruptId = InterruptId
    UIManager(self):ShowCommonPopupUI_Interrupt(InterruptId, Params, self.Parent)
end

function S:OnEnhanceLogStateChange(IsChecked)
	local EnhanceLogSubsystem = self.EnhanceLogSubsystem
    if not IsChecked then
        if EnhanceLogSubsystem and EnhanceLogSubsystem:GetEnableEnhanceLog() then
            EnhanceLogSubsystem:SetEnableEnhanceLog(false)
            UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Opition_Log_Closed"))
            self.WS_Upload:SetActiveWidgetIndex(0)
        end
    else
        local Params = {}
        Params.RightCallbackFunction = function()
            if EnhanceLogSubsystem then
                EnhanceLogSubsystem:SetEnableEnhanceLog(true)
            end
        end
        self:ShowCommonPopupUI_Interrupt(100280, Params)
    end
end

function S:OnUploadLogClicked()
	local EnhanceLogSubsystem = self.EnhanceLogSubsystem
    if EnhanceLogSubsystem and EnhanceLogSubsystem:GetEnableEnhanceLog() then
        local Params = {}
        Params.RightCallbackFunction = function()
            if EnhanceLogSubsystem then
                EnhanceLogSubsystem:UploadEnhanceLog()
                UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Opition_Log_Updating"))
            end
        end
        self:ShowCommonPopupUI_Interrupt(100281, Params)
    else
        UEPrint("请先开启增强日志功能")
    end
end

function S:OnLogCleanClicked()
	local EnhanceLogSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UEnhanceLogSubsystem:StaticClass())
    if EnhanceLogSubsystem then
        EnhanceLogSubsystem:DeleteAllLogFiles()
    end
end

function S:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    if CurInputDevice == ECommonInputType.Gamepad and not self:HasFocusedDescendants() then 
        self.Btn_Clean:SetFocus()
    end
    self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

return S
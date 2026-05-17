require "UnLua"
local UIUtils = require "Utils.UIUtils"
local AutoChessConst = require "BluePrints.UI.AutoChess.AutoChessConst"
local View = Class({
    "BluePrints.UI.BP_UIState_C",
})

function View:OnLoaded(MissionId, IsWin, First)
    self.UIController = require "BluePrints.UI.AutoChess.AutoChessUIController"
    self.UIController:OnAutoChessMainRegistered(self, MissionId, IsWin, First)
end

function View:BP_GetDesiredFocusTarget()
    DebugPrint("Tianyi@ AutoChessMain GetDesiredFocusTarget")
    return self:GetTopSubPage()
end

function View:InitView()
    self:InitTab()
    self.SubPageStack = {}
    self.MainPage = self:PushSubPage("AutoChessMainPage")
    self.MainPage:SetFocus()
    self:InitEvents()
    self:RefreshOpInfoByInputDevice()
    
    -- 播放音效
    AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AutoChessMainIn", nil)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_sub_page_in", nil, nil)
end

function View:PushSubPage(SubPageWidgetName, ...)
    local SubPageWidget = self:CreateWidgetNew(SubPageWidgetName)
    if not SubPageWidget then
        DebugPrint("Tianyi@ PushSubPage failed, widget is nil: "..SubPageWidgetName)
        return
    end

    self.Anchor:AddChild(SubPageWidget)
    local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(SubPageWidget)
    OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    table.insert(self.SubPageStack, SubPageWidget)
    SubPageWidget:_OnPagePushed(self)
    SubPageWidget:InitView(...)
    SubPageWidget:SetFocus()
    if UIUtils.IsGamepadInput() then
        self:RefreshControllerFSMState()
    end
    return SubPageWidget
end

function View:PopSubPage()
    if #self.SubPageStack == 0 then
        return
    end

    local TopSubPage = self.SubPageStack[#self.SubPageStack]
    TopSubPage:_OnPagePoped()
    table.remove(self.SubPageStack, #self.SubPageStack)

    local NewTopSubPage = self:GetTopSubPage()
    if not NewTopSubPage then
        self:CloseView()
    else
        NewTopSubPage:SetFocus()
        if UIUtils.IsGamepadInput() then
            self:RefreshControllerFSMState()
        end
    end


end


function View:GetTopSubPage()
    if #self.SubPageStack == 0 then
        return nil
    end
    return self.SubPageStack[#self.SubPageStack]
end


function View:InitTab()
    local TabConfigData = {
        TitleName = GText("Event_Title_103016"),
        DynamicNode = {
            "Back",
            "ResourceBar",
            "BottomKey", 
        }, 
        BackCallback = self.PopSubPage,
        BottomKeyInfo = {},
        OwnerPanel = self,  
        GetReplyOnBack = function()
            local DesiredFocusTarget = self:BP_GetDesiredFocusTarget()
            if DesiredFocusTarget then
                DesiredFocusTarget:SetFocus()
                return UE4.UWidgetBlueprintLibrary.Handled()
            end

            return UE4.UWidgetBlueprintLibrary.Unhandled()
        end
    }

    self.Tab:Init(TabConfigData)
end

function View:InitEvents()
end

function View:GetControllerFSM()
    return self.UIController.ControllerFSM
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false

    if UIUtils.IsGamepadInput() then
        IsHandled = self:Handle_KeyDownOnGamepad(InKeyName)
    else
        IsHandled = self:Handle_KeyDownOnKeyboard(InKeyName)
    end

    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:Handle_KeyDownOnGamepad(InKeyName)
    local IsHandled = false
    if InKeyName == Const.GamepadFaceButtonRight then
        self:PopSubPage()
        IsHandled = true
    end
    if not IsHandled then
        IsHandled = self.Tab:Handle_KeyEventOnGamePad(InKeyName) 
    end
    return IsHandled
end

function View:Handle_KeyDownOnKeyboard(InKeyName)
    local IsHandled = false
    if InKeyName == "Escape" then
        local TopSubPage = self:GetTopSubPage()
        if TopSubPage and not TopSubPage:IsAnyAnimationPlaying() then
            self:PopSubPage()
            IsHandled = true
        end
    end

    return IsHandled
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if UIUtils.IsGamepadInput() then
        self:RefreshControllerFSMState()
        self.Tab:UpdateBottomKeyInfo_Quick({{UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")}})
    elseif UIUtils.IsKeyboardInput() then
        self:GetControllerFSM():Reset()
        self.Tab:UpdateBottomKeyInfo({{
            KeyInfoList = {
                {Type="Text", Text="Esc", ClickCallback = self.PopSubPage, Owner = self},
            },
            Desc=GText("UI_BACK")
        }})
    end
end

function View:RefreshControllerFSMState()
    local TopSubPage = self:GetTopSubPage()
    if TopSubPage then
        local TargetState = TopSubPage:GetDefaultControllerFSMState()
        if TargetState then
            self:GetControllerFSM():Enter(TargetState)
        else
            DebugPrint("Tianyi@ TopSubPage has no default FSM state: ".. tostring(TopSubPage:GetName()))
        end
    end
end


function View:CloseView()
    AudioManager(self):SetEventSoundParam(self, "AutoChessMainIn", {ToEnd = 1})
    self:Close()
end

return View
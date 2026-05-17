--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"
require "DataMgr"

local WBP_Battle_Fort_P_C = Class("BluePrints.UI.Battle.Widget.WBP_Battle_Fort_Base_C")

function WBP_Battle_Fort_P_C:Initialize(Initializer)
    WBP_Battle_Fort_P_C.Super.Initialize(self)
end

function WBP_Battle_Fort_P_C:OnLoaded(...)
    WBP_Battle_Fort_P_C.Super.OnLoaded(self, ...)

    for i=1,2 do
        self:InitSkillButtonKey(i)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()

    if self.Key_Leave then
        self.Key_Leave:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = "F",
                }
            },
            Desc = GText("UI_Mechanism_ExitPaotai"),
        })
    end

    if self.Controller_Leave then
        self.Controller_Leave:CreateCommonKey({
            KeyInfoList = {
                {
                    Type = "Text",
                    Text = "Y",
                }
            },
            Desc = GText("UI_Mechanism_ExitPaotai"),
        })
    end
end

function WBP_Battle_Fort_P_C:InitSkillButtonKey(Index)
    --Gamepad
    local SkillName = self["FireUI_"..Index].SkillName
    local SkillIcons = UIUtils.GetIconListByActionName(SkillName)
    if SkillIcons then
        local SkillIcon = SkillIcons[2]
        if not SkillIcon then
            SkillIcon = SkillIcons[1]
        end
        self["FireUI_"..Index].Key_Img:CreateCommonKey({ KeyInfoList = {{Type = "Img", ImgShortPath = SkillIcon}} })
    end
    --PC
    local Avatar = GWorld:GetAvatar()
    local KeyName = ""
    if (Avatar and Avatar.ActionMapping ~= nil) then
        KeyName = Avatar.ActionMapping[SkillName] or DataMgr.KeyBoardMap[SkillName].Key
    else
        KeyName = DataMgr.KeyBoardMap[SkillName].Key
    end
    self["FireUI_"..Index].Common_Key_PC:CreateCommonKey({
        KeyInfoList = {
            {
                Type = "Text",
                Text = KeyName,
            }
        },
        bBattleKey = true
    })
end

function WBP_Battle_Fort_P_C:RefreshSkillButtonKey(Index, IsGamepadMode)
    if IsGamepadMode then
        self["FireUI_"..Index].Key_Img:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self["FireUI_"..Index].Key_Img:SetRenderOpacity(1)
        self["FireUI_"..Index].WidgetSwitcher_0:SetActiveWidgetIndex(1)
        if self.WS_KeyLeave then
            self.WS_KeyLeave:SetActiveWidgetIndex(1)
        end
    else
        self["FireUI_"..Index].Common_Key_PC:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        self["FireUI_"..Index].Common_Key_PC:SetRenderOpacity(1)
        self["FireUI_"..Index].WidgetSwitcher_0:SetActiveWidgetIndex(0)
        if self.WS_KeyLeave then
            self.WS_KeyLeave:SetActiveWidgetIndex(0)
        end
    end
end

function WBP_Battle_Fort_P_C:RefreshExitButtonKey(IsGamepadMode)
    if IsGamepadMode then
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_MP:SetActiveWidgetIndex(0)
    end
end

function WBP_Battle_Fort_P_C:Close()
    WBP_Battle_Fort_P_C.Super.Close(self)
    self:ClearListenEvent()
end

function WBP_Battle_Fort_P_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Battle_Fort_P_C:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function WBP_Battle_Fort_P_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function WBP_Battle_Fort_P_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function WBP_Battle_Fort_P_C:InitGamepadView()
    for i=1,2 do
        self:RefreshSkillButtonKey(i,true)
    end
end

function WBP_Battle_Fort_P_C:InitKeyboardView()
    for i=1,2 do
        self:RefreshSkillButtonKey(i,false)
    end
end

function WBP_Battle_Fort_P_C:HideSelf(IsHide)
    local AllChildrend = self.Root:GetAllChildren()
    local Length = AllChildrend:Length()
    for i = 1, Length do 
        local Widget = AllChildrend:GetRef(i)
        if Widget ~= self.Node_Activity then
            if IsHide then
                Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
            else
                Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
            end
        end
    end
end

return WBP_Battle_Fort_P_C

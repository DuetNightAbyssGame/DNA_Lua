--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Task_Fullfill_Popup_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

---仅初始化lua变量时使用，千万不要有控件操作！！
--function M:Initialize(Initializer)
--end

function M:Construct()
    self.Super.Construct(self)
    self.ConfirmFullfill = nil
    self.CurFocusedItem = nil
    self:BindToAnimationFinished(self.Out, {self, self.Close})
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:Destruct()
    self:RemoveChoiceCallback()
    self.Item01:UnBindEventOnClicked()
    self.Item02:UnBindEventOnClicked()
    self:ClearListenEvent()
    AudioManager(self):StopSound(self, "TaskFullfillPopupUIOpenSound")
    self.Super.Destruct(self)
end

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)

    self.ConfirmFullfill = nil
    self.CurFocusedItem = nil

    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/skip_main_story_panel_show", "TaskFullfillPopupUIOpenSound", nil)
    self.Params = ...
    self.Item01:Init(self, self.Params.PopUIContent and self.Params.PopUIContent[1], true)
    self.Item02:Init(self, self.Params.PopUIContent and self.Params.PopUIContent[2], false)
    local TitleText = GText("UI_SPECIALPOP_COMMON_TITLE")..GText(self.Params.PopUITitle)
    self.Text_Alert:SetText(GText("UI_SPECIALPOP_COMMON_TIPS_3"))
    self.Text_PopupTitle:SetText(TitleText)
    self.Item01:UnBindEventOnClicked()
    self.Item02:UnBindEventOnClicked()
    self.Item01:BindEventOnClicked(self, self.ChoiceFunction, {true})
    self.Item02:BindEventOnClicked(self, self.ChoiceFunction, {false})

    self.Item01:SetNavigationRuleCustom(EUINavigation.Right,{self,self.OnUINavigation})
    self.Item01:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    self.Item01:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Item01:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    self.Item02:SetNavigationRuleCustom(EUINavigation.Left,{self,self.OnUINavigation})
    self.Item02:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    self.Item02:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    self.Item02:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
    self:InitListenEvent()
    self:InitWidgetInfoInGamePad()
end

function M:ChoiceFunction(ConfirmFullfill)
    local ParentWidget = nil
    if ConfirmFullfill then
        ParentWidget = self.Item01
    else
        ParentWidget = self.Item02
    end
    local PopupUIId = nil
    local SecondPopupUIId = nil
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    local OnCloseCallbackFunction = function ()
        if IsValid(ParentWidget) then
            ParentWidget:SetFocus()
        end
    end
    local SecondParams = {
        AutoFocus = true,
        OnCloseCallbackFunction = OnCloseCallbackFunction,
    }
    local Params = {
        AutoFocus = true,
        RightCallbackObj = self,
        RightCallbackFunction = function(Obj, PackageData)
            UIManager:ShowCommonPopupUI(SecondPopupUIId, SecondParams, ParentWidget)
        end,
        OnCloseCallbackFunction = OnCloseCallbackFunction,
    }
    if ConfirmFullfill then
        PopupUIId = 100275
        SecondPopupUIId = 100276
        Params.ShortText = self.Params.PopUIContent and self.Params.PopUIContent[3]
        SecondParams.RightCallbackObj = self
        SecondParams.RightCallbackFunction = function(Obj, PackageData)
            self:RealConfirmFullfill()
        end
    else
        PopupUIId = 100277
        SecondPopupUIId = 100278
        Params.ShortText = self.Params.PopUIContent and self.Params.PopUIContent[4]
        SecondParams.RightCallbackObj = self
        SecondParams.RightCallbackFunction = function(Obj, PackageData)
            self:RealConfirmDoNotFullfill()
        end
    end
    UIManager:ShowCommonPopupUI(PopupUIId, Params, ParentWidget)
end

function M:RealConfirmDoNotFullfill()
    self.ConfirmFullfill = false
    self:PlayOutAnimation()
end

function M:RealConfirmFullfill()
    self.ConfirmFullfill = true
    self:PlayOutAnimation()
end

function M:PlayOutAnimation()
    AudioManager(self):StopSound(self, "TaskFullfillPopupUIOpenSound")
    self:PlayAnimation(self.Out)
end

function M:Close()
    if self.ChoiceCallback then
        self.ChoiceCallback(self.ConfirmFullfill)
    end
    self:RemoveChoiceCallback()
    self.Super.Close(self)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
    if IsUseKeyAndMouse then
		self:InitKeyboardView()
	else
		self:InitGamepadView()
	end
end

function M:InitGamepadView()
    self.Item01:SetFocus()
end

function M:InitKeyboardView()
    self:SetFocus()
    if self.CurFocusedItem then
        self.CurFocusedItem:StopHover(true)
        self.CurFocusedItem = nil
    end
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitWidgetInfoInGamePad()
    local BottomKeyInfo = {
        {
            KeyInfoList = {{Type = "Img", ImgShortPath = "RV"}},
            Desc = GText("UI_Controller_Slide")
        },
    }
    self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
end

function M:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice)
    end
end

function M:ClearListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    end
end

function M:OnUINavigation(NavigationDirection)
    if(NavigationDirection == EUINavigation.Left)then
        return self.Item01
    elseif(NavigationDirection == EUINavigation.Right) then
        return self.Item02
    end
    return nil
end

function M:TryChangeCurFocusedItem(Item)
    if self.CurFocusedItem and self.CurFocusedItem == Item then
        return
    end
    if self.CurFocusedItem then
        self.CurFocusedItem:StopHover()
    end
    self.CurFocusedItem = Item
    self.CurFocusedItem:BeginHover()
end

function M:AddChoiceCallback(ChoiceCallback)
    self.ChoiceCallback = ChoiceCallback
end

function M:RemoveChoiceCallback()
    self.ChoiceCallback = nil
end

return M

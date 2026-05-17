--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Activity_SoloTreasure_Main_C
local M = Class({"BluePrints.UI.BP_UIState_C"})
local UIUtils = require "Utils.UIUtils"
M._components = {
    "BluePrints.UI.UI_PC.Common.SubWidgetManagerComponent"
}

function M:OnLoaded(...)
    self.Super.OnLoaded(self, ...)
    EventManager:FireEvent(EventID.RefreshWuyoushengLevelReddot)
    self.EventId, self.Mode, self.bIsDifficult, self.EventDugeonId = ...
    self.EventId = math.floor(tonumber(self.EventId) or 103014)
    self.Mode = tonumber(self.Mode) or 1
    self.EventDugeonId = tonumber(self.EventDugeonId)
    self:InitSubWidgetManager(self.Anchor, nil)

    self:OpenSubUI({Idx = "ActivitySoloTreasureLevel"}, self.Mode, self.bIsDifficult, self.EventDugeonId)
    -- local CoinId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
    -- self.Com_Tab.WBP_Com_Tab_ResourceBar:InitResourceBar({CoinId}, false)

    if self.RewardText then
        self.RewardText:Init(nil, self.EventId)
    end
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
        self:RefreshOpInfoByInputDevice(
            self.GameInputModeSubsystem:GetCurrentInputType(),
            self.GameInputModeSubsystem:GetCurrentGamepadName()
        )
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.CurInputDevice = CurInputDevice
    self.CurGamepadName = CurGamepadName
    if (ModController:IsMobile()) then
        -- 触控模式即默认样式，不需要刷新
        return
    end
    --- 切换手柄端相关图标显隐
    for _, Widget in pairs(self.SubUI) do
        Widget:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false

    if UIUtils.IsGamepadInput() then
        if InKeyName == "Gamepad_RightThumbstick" then
            IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
            local CurrentSubUI = self:GetCurrentSubUI()
            self.Com_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(CurrentSubUI)
        end
    else
        if (InKeyName == "Escape") then
            IsEventHandled = true
            self:OnReturnKeyDown()
        end
    end

    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

function M:OnCloseAll()
    self:Close()
end

function M:Close()
    if self.SubUI then
        for _, Widget in pairs(self.SubUI) do
            --CurSubUI为AbyssMain特殊处理
            if Widget ~= self then
                Widget:RemoveFromParent()
            end
        end
    end
    self.Super.Close(self)
end

function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    if self.SubUI then
        for _, Widget in pairs(self.SubUI) do
            if type(Widget.ReceiveEnterStateSelf) == "function" then
                Widget:ReceiveEnterStateSelf(StackAction)
            end
        end
    end
end

AssembleComponents(M)
return M

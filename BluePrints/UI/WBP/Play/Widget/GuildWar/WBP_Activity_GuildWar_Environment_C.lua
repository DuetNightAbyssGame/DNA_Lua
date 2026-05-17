-- DESCRIPTION
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}

require "UnLua"

---@type WBP_Activity_GuildWar_Environment_C
local M = Class({"BluePrints.UI.BP_UIState_C"})

function M:Construct()
    M.Super.Construct(self)
    self:AddInputMethodChangedListen()
    
    self.Btn_Click.OnClicked:Add(self, function ()
        self:PlayAnimation(self.Out)
    end)

    self:UpdateGamePadKeyState()
end

function M:Init(RaidBuffIDArry)
    self.IsScroll = false
    self:PlayAnimation(self.In)
    self:SetFocus()
    self.Text_Title:SetText(GText("RaidDungeon_Buff_Title"))
    self.Text_Tip:SetText(GText("UI_Armory_ClickEmpty"))
    self.List_Buff:ClearListItems()
    if RaidBuffIDArry then
        for _, RaidBuffID in ipairs(RaidBuffIDArry) do
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.RaidDungeonBuffData = DataMgr.RaidBuff[RaidBuffID]
            Content.Parent = self.Parent
            self.List_Buff:AddItem(Content)
        end
    end

    -- 延迟一帧计算滚动情况
    self:AddTimer(0.03, function()
        self:CalcScrollState()
        self:UpdateGamePadKeyState()
    end, false, 0, "GuildWar_Environment")
end


function M:CalcScrollState()
    local showWidgets = self.List_Buff:GetDisplayedEntryWidgets()
    local totalItems = self.List_Buff:GetListItems()
    local maxShow = UIUtils.GetListViewContentMaxCount(self.List_Buff, showWidgets, true)

    self.IsScroll = totalItems:Length() > maxShow
end

function M:UpdateGamePadKeyState()
    local usingPad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad

    if usingPad then
        self.WS_Type:SetActiveWidgetIndex(1)
        self:SetupCloseKey()

        if self.IsScroll then
            self:SetupScrollKey(true)
        else
            self.Key_Scroll:SetVisibility(ESlateVisibility.Collapsed)
        end
    else
        self.WS_Type:SetActiveWidgetIndex(0)
        self.Key_Scroll:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:SetupScrollKey(visible)
    self.Key_Scroll:SetVisibility(visible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    if visible then
        self.Key_Scroll:CreateCommonKey({
            KeyInfoList = { { Type = "Img", ImgShortPath = "RS" } },
            Desc = GText("UI_Controller_Slide")
        })
    end
end

function M:SetupCloseKey()
    self.Key_Close:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Key_Close:CreateCommonKey({
        KeyInfoList = { { Type = "Img", ImgShortPath = "B" } },
        bLongPress = false,
        Desc = GText("UI_BACK")
    })
end



function M:RefreshOpInfoByInputDevice()
    self:UpdateGamePadKeyState()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if InKeyName == "Gamepad_RightY" and self.IsScroll then
        local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 0.5
        self.List_Buff:SetScrollOffset(self.List_Buff:GetScrollOffset() + a)
        return UWidgetBlueprintLibrary.Handled()
    end
    return UWidgetBlueprintLibrary.Unhandled()
end


function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
        return self:OnGamePadDown(InKeyName)
    end
    if InKeyName == "Escape" then
        --self:OnReturnKeyDown()
        self:PlayAnimation(self.Out)
        return UWidgetBlueprintLibrary.Unhandled()
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamePadDown(InKeyName)
    if InKeyName == "Gamepad_FaceButton_Right" then
        --self:OnReturnKeyDown()
        self:PlayAnimation(self.Out)
        return UWidgetBlueprintLibrary.Handled()
    end
    return UWidgetBlueprintLibrary.Unhandled()
end

--动画完成后的回调
function M:OnAnimationFinished(InAnimation)
    if InAnimation == self.Out then
        self:OnReturnKeyDown()
    end
end

function M:OnReturnKeyDown()
    AudioManager(self):SetEventSoundParam(self, "Play_DeputeDetail", {ToEnd = 1})
    self.Super.Close(self)

    local Item = UIManager(self):GetUIObj("GuildWarLevel")
    if Item then
        Item:SelectCellFocus()
    end
end

return M

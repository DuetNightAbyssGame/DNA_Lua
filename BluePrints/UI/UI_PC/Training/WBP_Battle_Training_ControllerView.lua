local ControllerFSM = require("Blueprints.UI.ControllerFSM")
local TrainingConst = require("Blueprints.UI.UI_PC.Training.TrainingConst")
local ControllerView = {}

function ControllerView:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 0.5
    local Current = self.ControllerFSM:Current()
    
    -- 死区
    if math.abs(AddOffset) < 0.01 then 
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end

    if Current == TrainingConst.FSMStates.FocusRightPanel then
        if InKeyName == UIConst.GamePadKey.RightAnalogY then
            local CurScrollOffset = self.List_Monster:GetScrollOffset()
            local MaxListScrollOffset = UIUtils.GetMaxScrollOffsetOfListView(self.List_Monster)
            local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, MaxListScrollOffset)
            self.List_Monster:SetScrollOffset(ScrollOffset)
        end
    elseif Current == TrainingConst.FSMStates.FocusTab_SelectItem or Current == TrainingConst.FSMStates.FocusTab then
        if InKeyName == UIConst.GamePadKey.RightAnalogY then
            local CurScrollOffset = self.ScrollTextDesc:GetScrollOffset()
            local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.ScrollTextDesc:GetScrollOffsetOfEnd())
            self.ScrollTextDesc:SetScrollOffset(ScrollOffset)
        end
    end
    
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function ControllerView:Handle_PreviewKeyDownOnGamePad(InKeyName)
    local IsHandled = false
    local CurrentState = self.ControllerFSM:Current()
    if not IsHandled then
        if CurrentState == TrainingConst.FSMStates.FocusTab_SelectItem then
            IsHandled = self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
        elseif CurrentState == TrainingConst.FSMStates.FocusRightPanel then
            IsHandled = self.Com_NumInput:Handle_KeyEventOnGamePad(InKeyName)
        end
    end

    return IsHandled
end

function ControllerView:Handle_KeyDownOnGamePad(InKeyName)
    local IsHandled = false
    local CurrentState = self.ControllerFSM:Current()

    if InKeyName == UIConst.GamePadKey.LeftThumb then
        self:SimulateShowUnlockedMonstersPressed()
        IsHandled = true

    elseif InKeyName == UIConst.GamePadKey.RightThumb then
        if not self.Btn_Confirm:IsBtnForbidden() then
            self:OnBtnConfirmClicked()
            self.List_Item:SetFocus()
            self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusTab)
            IsHandled = true
        end

    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
        if not self.Btn_Generate:IsBtnForbidden() then
            self:OnBtnGenerateClicked()
            IsHandled = true
        end

    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        if CurrentState == TrainingConst.FSMStates.FocusTab_SelectItem then
            self:OnItemBtnDeclineClicked(self.CurrentSelectedRuleId)
            IsHandled = true
        end

    elseif InKeyName == UIConst.GamePadKey.SpecialRight then
        if CurrentState == TrainingConst.FSMStates.FocusTab_SelectItem or CurrentState == TrainingConst.FSMStates.FocusTab then
            self.MaskLevelSetting:SetFocus()
            self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusRightPanel)
            IsHandled = true
        end

    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
        if CurrentState == TrainingConst.FSMStates.FocusRightPanel then
            self.List_Item:SetFocus()
            if self.WS:GetActiveWidgetIndex() == 0 then
                self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusTab_SelectItem)
            else
                self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusTab)
            end
            IsHandled = true
        elseif CurrentState == TrainingConst.FSMStates.FocusTab_SelectItem or CurrentState == TrainingConst.FSMStates.FocusTab then
            self:ClosePanel()
            IsHandled = true
        end
    end

    -- Delegate to state-specific widgets if still not handled
    if not IsHandled then
        if CurrentState == TrainingConst.FSMStates.FocusTab_SelectItem then
            IsHandled = self.Com_Slider:Handle_KeyDownEventOnGamePad(InKeyName)
        elseif CurrentState == TrainingConst.FSMStates.FocusRightPanel then
            IsHandled = self.Com_NumInput:Handle_KeyEventOnGamePad(InKeyName)
        end
    end

    if not IsHandled then
        IsHandled = self.Tab:Handle_KeyEventOnGamePad(InKeyName)
    end

    return IsHandled
end

function ControllerView:Handle_KeyUpOnGamePad(InKeyName)
    local IsHandled = false
    local CurrentState = self.ControllerFSM:Current()

    if not IsHandled then
        if CurrentState == TrainingConst.FSMStates.FocusTab_SelectItem then
            IsHandled = self.Com_Slider:Handle_KeyUpEventOnGamePad(InKeyName)
        end
    end

    return IsHandled
end

function ControllerView:ShowLockedInfo()
    if not UIUtils.IsGamepadInput() then
        return
    end

    self:UpdateTabKeyInfos({
        {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
    })
end

function ControllerView:ShowMonsterRuleInfoView(RuleId)
    if not UIUtils.IsGamepadInput() then
        return
    end

    if RuleId then
        self:AddTimer(0.05, function()
            self:UpdateTabKeyInfos(self:GetBottomKeyInfos())
        end)
    else

    end
end

-- 手柄端状态定义
function ControllerView:InitControllerFSM()
    self.ControllerFSM = ControllerFSM.New(self, {
        [TrainingConst.FSMStates.FocusTab] = {
            OnEnter = self.OnEnterState_FocusTab,
            OnLeave = self.OnLeaveState_FocusTab,
        },
        [TrainingConst.FSMStates.FocusTab_SelectItem] = {
            OnEnter = self.OnEnterState_FocusTab_SelectItem,
            OnLeave = self.OnLeaveState_FocusTab_SelectItem,
        },
        [TrainingConst.FSMStates.FocusRightPanel] = {
            OnEnter = self.OnEnterState_FocusRightPanel,
            OnLeave = self.OnLeaveState_FocusRightPanel,
        },
        [TrainingConst.FSMStates.Keyboard] = {
            OnEnter = self.OnEnterState_Keyboard,
        },
    })
end

function ControllerView:GetBottomKeyInfos()
    local CurrentState = self.ControllerFSM:Current()
    if CurrentState == TrainingConst.FSMStates.FocusTab then
        local IsMonsterInfoScrollable = self:IsMonsterInfoScrollable()
        if IsMonsterInfoScrollable then
            return {
                {UIConst.GamePadImgKey.RightTriggerAnalog, GText("UI_Controller_Slide")},
                {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Tips_Ensure")},
                {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
            }
        else
            return {
                {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Tips_Ensure")},
                {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
            }
        end
    elseif CurrentState == TrainingConst.FSMStates.FocusTab_SelectItem then
        local IsMonsterInfoScrollable = self:IsMonsterInfoScrollable()
        if IsMonsterInfoScrollable then
            return {
                {UIConst.GamePadImgKey.RightTriggerAnalog, GText("UI_Controller_Slide")},
                {UIConst.GamePadImgKey.FaceButtonLeft, GText("UI_CTL_Clear")},
                {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Tips_Ensure")},
                {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
            }
        else
            return {
                {UIConst.GamePadImgKey.FaceButtonLeft, GText("UI_CTL_Clear")},
                {UIConst.GamePadImgKey.FaceButtonBottom, GText("UI_Tips_Ensure")},
                {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
            }
        end
    end
end

function ControllerView:InitGamepadView()
    self.Com_NumInput:UpdateUIStyleInPlatform(true)
    self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusTab)
    if self:HasAnyFocus() then
        self.List_Item:SetFocus()
    end
    self.Btn_Confirm:SetGamepadIconVisibility(false)
end

function ControllerView:OnEnterState_Keyboard()

end

function ControllerView:OnEnterState_FocusTab()
    self:UpdateTabKeyInfos(self:GetBottomKeyInfos())
    self.WS:SetActiveWidgetIndex(1)
    self.Key_SelectTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function ControllerView:OnLeaveState_FocusTab()
    self.Key_SelectTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
end


function ControllerView:OnEnterState_FocusTab_SelectItem()
    self:UpdateTabKeyInfos(self:GetBottomKeyInfos())  
    self.WS:SetActiveWidgetIndex(0) 
    self.Key_SelectTitle:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function ControllerView:OnLeaveState_FocusTab_SelectItem()
    self.Key_SelectTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function ControllerView:OnEnterState_FocusRightPanel()
    self.Btn_Confirm:SetGamepadIconVisibility(true)
    self.Com_Slider:UpdateUIStyleInPlatform(false)
    self.VX_ListLine:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    local IsCountListScrollable = self:IsCountListScrollable()
    if IsCountListScrollable then
        self:UpdateTabKeyInfos({
            {UIConst.GamePadImgKey.RightTriggerAnalog, GText("UI_Controller_Slide")},
            {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
        })
    else
        self:UpdateTabKeyInfos({
            {UIConst.GamePadImgKey.FaceButtonRight, GText("UI_Tips_Close")},
        }) 
    end
    
    self.Com_NumInput:UpdateUIStyleInPlatform(false)
end

function ControllerView:OnLeaveState_FocusRightPanel()
    self.VX_ListLine:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Com_NumInput:UpdateUIStyleInPlatform(true)
    self.Btn_Confirm:SetGamepadIconVisibility(false)
    self.Com_Slider:UpdateUIStyleInPlatform(true)
end

function ControllerView:UpdateSelectedNum(CurrentSelectedNum, MaxSelectableNum, TotalSelectedNum)
    if UIUtils.IsGamepadInput() then
        if CurrentSelectedNum > 0 then
            self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusTab_SelectItem)
        else
            self.ControllerFSM:Enter(TrainingConst.FSMStates.FocusTab)
        end
    end
end




return ControllerView
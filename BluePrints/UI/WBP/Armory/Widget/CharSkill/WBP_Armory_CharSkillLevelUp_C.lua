--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_CharSkillLevelUp_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
    self.Text_Close:SetText(GText("UI_Armory_ClickEmpty"))
    self.Key_Close:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B",
            },
        },
        Desc = GText("UI_Controller_Close"),
    })
    self.Btn_Close.OnClicked:Clear()
    self.Btn_Close.OnClicked:Add(self,self.OnCloseBtnClicked)
    self:BindToAnimationFinished(self.In,{self,self.OnInAnimationFinished})
    self:BindToAnimationFinished(self.Out,{self,self.OnOutAnimationFinished})
    self.List_Atrr.bIsFocusable = false
    self.bIsDealWithVirtualAccept = true
    AudioManager(self):PlayUISound(self, "event:/ui/armory/strength_success", nil, nil)
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
    M.Super.RefreshOpInfoByInputDevice(self,CurInputDevice, CurGamepadName)
    self:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if(self:HasFocusedDescendants() and not self:HasAnyUserFocus())then
        self:SetFocus()
    end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    if(self.IsGamepadInput)then
        self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    else
        self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InputEvent = UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
    if(UKismetInputLibrary.InputEvent_IsRepeat(InputEvent))then
        return UIUtils.Handled
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == UE4.EKeys.Escape.KeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight or InKeyName == UIConst.GamePadKey.FaceButtonBottom)then
        self:OnCloseBtnClicked()
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UIUtils.Handled
end

function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if(InKeyName == "Gamepad_RightY")then
        local DeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
        self.List_Atrr:SetScrollOffset(self.List_Atrr:GetScrollOffset() + DeltaY)
        return UIUtils.Handled
    end
    return UIUtils.Unhandled
end

function M:OnLoaded(Params)
    M.Super.OnLoaded(self, Params)
    Params = Params or {
        -- Level = Level,
        -- NewLevel = NewLevel,
        -- ExText = ExText,
        -- Attrs = self.Attrs,
        -- SkillId = 0,
        -- ComparedAttrs = self.ComparedAttrs,
        -- OnClosedCallbackObj = self,
        -- OnClosedCallbackFunc = Callback
    }
    self.OnClosedCallbackObj = Params.OnClosedCallbackObj
    self.OnClosedCallbackFunc = Params.OnClosedCallbackFunc
    self:UpdateUpgradeInfo(Params)
    self:UpdataAttrListView(Params.Attrs,Params.ComparedAttrs)
    self:PlayInAnim()
end

function M:UpdateUpgradeInfo(Params)
    local Icon = UIUtils.LoadSkillIconById(Params.SkillId)
    local IconDynaMaterial = self.Icon_CharSkill:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetTextureParameterValue("IconTex",Icon)
    end
    IconDynaMaterial = self.Icon_CharSkill_Glow:GetDynamicMaterial()
    if(IconDynaMaterial)then
        IconDynaMaterial:SetTextureParameterValue("IconTex",Icon)
    end
    self.Text_Level_Before:SetText(Params.Level)
    self.Text_Level_After:SetText(Params.NewLevel)
    if(Params.ExText)then
        self.Text_Intensify_Level:SetText(Params.ExText)
        self.Text_Intensify_Level:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
        self.Text_Intensify_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:UpdataAttrListView(Attrs,ComparedAttrs)
    self.Attrs = Attrs
    self.ComparedAttrs = ComparedAttrs
    self.List_Atrr:ClearListItems()
    local Obj = nil
    local Idx = 1
    for i, Attr in ipairs(self.Attrs) do
        if(Attr.Value ~= self.ComparedAttrs[i].Value)then
            Obj = NewObject(UIUtils.GetCommonItemContentClass())
            Obj.Name  = Attr.Desc
            Obj.Value  = Attr.Value or 0
            Obj.CmpValue  = self.ComparedAttrs[i].Value or 0
            Obj.Desc  = Attr.Desc
            Obj.Idx  = Idx
            Obj.Style = self.ComparedAttrs[i].Style or "ShowValue"
            self.List_Atrr:AddItem(Obj)
            Idx = Idx + 1
        end
    end
    --self.List_Atrr:RequestRefresh()
end

function M:PlayInAnim()
    self.CannotClose = true
    self.Btn_Close:SetVisibility(UIConst.VisibilityOp["HitTestInvisible"])
    self.List_Atrr:SetRenderOpacity(0)
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/armory/strength_success_next_page", nil, nil)
end

function M:SequenceEvent_PlayAttrAnim()
    --self.List_Atrr:SetRenderOpacity(0)
    self.List_Atrr:RequestPlayEntriesAnim()
    --switcher会导致列表重建，需要在列表重建完成后才调用动画
    -- UIUtils.StopListViewFramingInAnimation(self.List_Atrr,{TimerKeys = self.FramingInTimers, UIState =self}) -- 重置动画状态
    -- self:AddTimer(0.01, function()
    --     self.FramingInTimers = UIUtils.PlayListViewFramingInAnimation(self, self.List_Atrr, {Visibility=UIConst.VisibilityOp.HitTestInvisible,Callback = function()
    --         --self.Text_Details:SetVisibility(UIConst.VisibilityOp.Visible)
    --     end})
    -- end)
end

function M:OnInAnimationFinished()
    self.CannotClose = false
    self.Btn_Close:SetVisibility(UIConst.VisibilityOp["Visible"])
end

function M:OnCloseBtnClicked()
    if self.CannotClose then
        return
    end
    self:PlayOutAnim()
end

function M:PlayOutAnim()
    self.CannotClose = true
    self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
    self:Close()
    if self.OnClosedCallbackFunc then
        self.OnClosedCallbackFunc(self.OnClosedCallbackObj)
    end
    --UIUtils.StopListViewFramingInAnimation(self.List_Atrr, {TimerKeys = self.FramingInTimers, UIState = self})
end

return M

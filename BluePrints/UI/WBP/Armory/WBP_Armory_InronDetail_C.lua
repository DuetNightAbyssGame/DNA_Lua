--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--
require "UnLua"

---@type WBP_Armory_InronDetail_P_C
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
    M.Super.Construct(self)
    self.Image_Click.OnMouseButtonDownEvent:Unbind()
    self.Image_Click.OnMouseButtonDownEvent:Bind(self,self.OnBackgroundClicked)
    self.Btn_Unlock:BindEventOnClicked(self, self.OnUnlockBtnClicked)
    self.Btn_Unlock:SetGamePadImg("Y")
    self.Key_Consume:CreateGamepadKey("LS")
    self:SwitchGamepadKeyState(1)

    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    self:OnInputChange()
end

function M:OnLoaded(...)
    M.Super.OnLoaded(self, ...)

    self.Parent, self.SelectTraceId, self.SelectMod = ...

    self.MaxGradeLevel = tonumber(DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue)
    self.TotalMaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue + 1
    self.FocusOnDetail = false
    self.CurSelectCanGrade = false
    self.UnlockPlaying = false

    self.Armory_Inron.SelectTraceId = self.SelectTraceId
    self.Armory_Inron.Details = self
    self.Armory_Inron.IsOpenDetails = true
    self.Armory_Inron:Init(self.Parent.Params)
    
    if self.Armory_Inron['InronItem_'..self.SelectTraceId] then
        self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetFocus()
    end

    self.InFinished = false
    self.IsInOutAnim = false
    self.Parent.Parent:BlockAllUIInput(true,"SP_DisplayOnly")
    self:BindToAnimationFinished(self.Detail_In, {self, self.OnInAnimFinished})
    self:PlayAnimation(self.Detail_In)

    for i = 1, self.TotalMaxGradeLevel do
        if self.Armory_Inron['InronItem_'..i] and i ~= self.SelectTraceId then
            self.Armory_Inron['InronItem_'..i].IsClick = false
            self.Armory_Inron['InronItem_'..i]:SetNormalState()
        end
    end
    if self.Armory_Inron['InronItem_'..self.SelectTraceId] then
        self.Armory_Inron['InronItem_'..self.SelectTraceId].IsClick = false
        self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetClickState()
        self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetFocus()
    end
end

function M:UpdateDetailInfo(TraceId, SelectMod)
    self.SelectTraceId = TraceId
    if self.Parent then
        self.Parent.SelectTraceId = TraceId
    end
    self.SelectMod = SelectMod
    -- self.Text_IntronNum:SetText(tostring(TraceId))
    self.Text_IntronName:SetText(GText("UI_ROOT_" .. TraceId))
    self.Text_IntronName_World:SetText(EnText("UI_ROOT_" .. TraceId))
    self.Text_IntronDesc:SetText(GText("UI_Armory_IntronDesc_" .. TraceId))
    local Desc = self.Armory_Inron:GetTraceDesc()
    self.Text_IntronDesc:SetText(Desc)

    self.HB_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.HB_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_Unlock:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if self.CurInputDeviceType == ECommonInputType.GamePad then
        self.Key_Consume:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self.Text_Consume:SetText(GText("UI_CTL_Armory_Consumables"))
    -- Type1:碎片充足 Type2:碎片不足，月石充足 Type3:碎片不足，月石不足 Type4:未检索到碎片信息
    local Res = self.Armory_Inron:InitResourceNeeded()
    self.Type, self.Resource1, self.Resource2 = Res[1], Res[2], Res[3]

    self.CurSelectCanGrade = false

    if SelectMod == 1 or SelectMod == 4 then
        -- 已解锁的/IsPreviewMode
        self.WidgetSwitcher_Btn:SetActiveWidgetIndex(1)
        self.Hint_Lock.WidgetSwitcher_State:SetActiveWidgetIndex(1)
        self.Hint_Lock.Text_Hint_Positive:SetText(GText("UI_UNLOCKED"))
        self.HB_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.HB_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Key_Consume:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if SelectMod == 4 then
            -- 预览中不显示下方按钮
            self.Panel_Unlock:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    elseif SelectMod == 2 then
        -- 当前可解锁的
        if TraceId == 7 then
            -- 溯源7有额外解锁条件，这里判断一下，self.Type只与材料是否足够相关
            local Avatar = GWorld:GetAvatar()
            local CharId = self.Parent.CharId
            local Condition = DataMgr.UltraCharCardLevelUp and DataMgr.UltraCharCardLevelUp[CharId] and DataMgr.UltraCharCardLevelUp[CharId].ExtraUnlockCondition
            local ConditionTrue = false
            local ConditionDesc = DataMgr.UltraCharCardLevelUp and DataMgr.UltraCharCardLevelUp[CharId] and DataMgr.UltraCharCardLevelUp[CharId].UnlockDes
            if Avatar and CharId and ConditionUtils.CheckCondition(Avatar, Condition) then
                ConditionTrue = true
            end

            if not ConditionTrue then
                -- 前置条件不满足，显示前置条件提示
                self.WidgetSwitcher_Btn:SetActiveWidgetIndex(1)
                self.Hint_Lock.WidgetSwitcher_State:SetActiveWidgetIndex(0)
                self.Hint_Lock.Text_Hint_Normal:SetText(GText(ConditionDesc))
            elseif self.Type == 1 then
                -- 材料充足，显示解锁按钮
                self.WidgetSwitcher_Btn:SetActiveWidgetIndex(0)
                self.Btn_Unlock:SetText(GText("UI_UNLOCK"))
                self.CurSelectCanGrade = true
            else
                -- 材料不足，切到提示状态
                self.WidgetSwitcher_Btn:SetActiveWidgetIndex(1)
                self.Hint_Lock.WidgetSwitcher_State:SetActiveWidgetIndex(0)
                self.Hint_Lock.Text_Hint_Locked:SetText(GText("UI_Prop_Notenough"))
                self.Hint_Lock.Text_Hint_Normal:SetText(GText("UI_Prop_Notenough"))
            end
        else
            -- 前6级保持原有逻辑
            self.WidgetSwitcher_Btn:SetActiveWidgetIndex(0)
            self.Btn_Unlock:SetText(GText("UI_UNLOCK"))
            self.CurSelectCanGrade = true
        end
    else
        -- 未解锁的（前置条件不满足）
        self.WidgetSwitcher_Btn:SetActiveWidgetIndex(1)
        self.Hint_Lock.WidgetSwitcher_State:SetActiveWidgetIndex(2)
        self.Hint_Lock.Text_Hint_Locked:SetText(GText("UI_ROOT_CONDITION"))
    end
    
    self:ShowCollectRewardExpText(TraceId, SelectMod)
    self.Armory_InronItem:Init(self.Armory_Inron, self.SelectTraceId, false)
    self.Armory_InronItem.Num_Intron:SetText(tostring(self.SelectTraceId))
    self.Armory_InronItem:SetNormalState()
    self.Armory_InronItem.VX_CircleNoise11:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Armory_InronItem.VX_CircleNoise10:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Armory_InronItem.VX_CirceMid24:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Armory_InronItem.VX_Dot:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:ShowCollectRewardExpText(TraceId, SelectMod)
    if SelectMod==2 or SelectMod==3 then
        self.Panel_ExpHint:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        local CollectRewardExp = 0
        if TraceId == 7 then
            -- 第7级从UltraCharCardLevelUp表读取
            local UltraData = DataMgr.UltraCharCardLevelUp and DataMgr.UltraCharCardLevelUp[self.Parent.CharId]
            CollectRewardExp = UltraData and UltraData.CollectRewardExp or 0
        else
            local CurCharLevelUpData = self.Parent.CharId and DataMgr.CharCardLevelUp[self.Parent.CharId] or {}
            local RewardData = CurCharLevelUpData[TraceId-1] or {}
            CollectRewardExp = RewardData.CollectRewardExp or 0
        end
        local HintText = string.format(GText("UI_Armory_CharCardUpExp"), CollectRewardExp)
        self.Text_ExpHint:SetText(HintText)
    else
        self.Panel_ExpHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:OnUnlockBtnClicked()
    self.Armory_Inron:OnClickBTN(self.Type, self.Resource1, self.Resource2)
end

function M:OnBackgroundClicked()
    if self.IsInOutAnim or not self.InFinished or self.UnlockPlaying then
        return
    end
    if self.Parent then
        for i = 1, self.TotalMaxGradeLevel do
            if self.Parent['InronItem_'..i] and self.Parent['InronItem_'..i]:IsAnimationPlaying(self.Parent['InronItem_'..i].UnLock) then
                return
            end
        end
    end
    self:OnCloseBtnClicked()
end

function M:OnCloseBtnClicked()
    self:StopAllAnimations()
    self.IsInOutAnim = true
    self:BindToAnimationFinished(self.Detail_Out, {self, self.OnOutAnimFinished})
    self:BlockAllUIInput(true,"SP_DisplayOnly")
    self:PlayAnimation(self.Detail_Out)
    if self.Armory_Inron['InronItem_'..self.SelectTraceId] and self.CurInputDeviceType ~= ECommonInputType.GamePad then
        self.Armory_Inron['InronItem_'..self.SelectTraceId].IsClick = false
        self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetNormalState()
    end
    if self.Parent then
        for i = 1, self.TotalMaxGradeLevel do
            if self.Parent['InronItem_'..i] then
                self.Parent['InronItem_'..i].IsClick = false
                self.Parent['InronItem_'..i]:SetNormalState()
            end
        end
    end
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain)then
        ArmoryMain:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        ArmoryMain.Panel_SubUI:SetVisibility(UIConst.VisibilityOp.Hidden)
        ArmoryMain:PlayAnimation(ArmoryMain.RoleList_In)
        ArmoryMain:PlayAnimation(ArmoryMain.BG_BackFirst)
        if ArmoryMain.BackgroundBlurWithMask_39 then
            ArmoryMain.BackgroundBlurWithMask_39:SetVisibility(ESlateVisibility.Collapsed)
        end
        ArmoryMain.Tab_Arm:PlayInAnim()
        ArmoryMain.ReceiveEnterStateNoAnim = true
        --ArmoryMain:PlayInAnim()
        ArmoryMain:UpdateMontageAndCamera()
    end
end

function M:OnOutAnimFinished()
    self.IsInOutAnim = false
    self:BlockAllUIInput(false)
    self.Parent:OnTraceDetailsDestruct(self.SelectTraceId)
    local ArmoryMain = UIManager(self):GetArmoryUIObj()
    if(ArmoryMain and ArmoryMain.BackgroundBlurWithMask_39)then
        ArmoryMain.BackgroundBlurWithMask_39:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:Close()
end

function M:OnInAnimFinished()
    self.Parent.Parent:BlockAllUIInput(false)
    self.InFinished = true
end

function M:OnTipsOpenChanged(bIsOpen)
    if not self.Panel_GamePad then return end
    if bIsOpen then
        self.HB_Key_GamePad:SetVisibility(UE4.ESlateVisibility.Hidden)
    else
        self.HB_Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
end




function M:ReceiveEnterState(StackAction)
    M.Super.ReceiveEnterState(self, StackAction)
    -- 刷新一下
    if self.Parent and self.SelectTraceId then
        self.Armory_Inron:OnClickTraceItem(self.SelectTraceId)
        if self.Armory_Inron['InronItem_'..self.SelectTraceId] then
            -- 手柄端直接选中
            self.Armory_Inron['InronItem_'..self.SelectTraceId].IsClick = false
            self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetClickState()
            self.Armory_Inron.LastFocusItem = self['InronItem_'..self.SelectTraceId]

            -- 红点刷新：区分前6级和第7级
            if self.SelectTraceId == 7 then
                self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetReddotState(self.Armory_Inron:CheckCharCanUpUltraGradeLevel())
            else
                self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetReddotState(self.Armory_Inron:CheckCharCanUpGradeLevel())
            end
        end
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (self.CurInputDeviceType == CurInputDevice) then
        -- 已经显示的是该输入模式，不需要进行刷新
        return
    end
    --更新输入模式
    self.CurInputDeviceType = CurInputDevice
    self.CurGamepadName = CurGamepadName

    self:OnInputChange()
end

function M:OnInputChange()
    if not self.Panel_GamePad then return end
    if self.CurInputDeviceType == ECommonInputType.GamePad then
        if self.SelectTraceId then
            self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetFocus()
            self.FocusOnDetail = false
        end

        self.Key_Consume:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Panel_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SwitchGamepadKeyState(1)
    else
        self.Key_Consume:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Panel_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

-- 监听PC/手柄按键
function M:OnKeyDown(MyGeometry, InKeyEvent)
    if not self.InFinished or self.IsInOutAnim then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    local IsEventHandled = false
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:Handle_OnGamePadDown(InKeyName)
    else
        IsEventHandled = self:Handle_OnPCDown(InKeyName)
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
end

-- PC按键按下
function M:Handle_OnPCDown(InKeyName)
    if (InKeyName == "Escape") then
        self:OnBackgroundClicked()
        return true
    end
    return false
end

-- 手柄按键按下
function M:Handle_OnGamePadDown(InKeyName)
    if not self.Panel_GamePad then return end
    if (InKeyName == "Gamepad_FaceButton_Right") then -- 返回
        if not self.FocusOnDetail then
            self:OnBackgroundClicked()
        else
            self.FocusOnDetail = false
            self.Armory_Inron['InronItem_'..self.SelectTraceId]:SetFocus()
            self.Key_Consume:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self:SwitchGamepadKeyState(1)
        end
        return true
    elseif (InKeyName == "Gamepad_FaceButton_Top") then -- 升级
        if self.CurSelectCanGrade then
            self:OnUnlockBtnClicked()
        end
        return true
    elseif (InKeyName == "Gamepad_LeftThumbstick") then -- 查看消耗材料
        if self.HB_Item:GetVisibility() ~= UE4.ESlateVisibility.Collapsed and self.HB_Item:GetChildrenCount() > 0 then
            local FirstItem = self.HB_Item:GetChildAt(0)
            FirstItem:SetFocus()
            self.FocusOnDetail = true
            self.Key_Consume:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self:SwitchGamepadKeyState(2)
        end
        return true
    end
    return false
end

-- 下方手柄按键提示
function M:SwitchGamepadKeyState(State)
    if not self.HB_Key_GamePad then return end
    self.HB_Key_GamePad:ClearChildren()
    if State == 1 then
        -- 返回
        local Info1 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B",
                },
                    
            },
            Desc = GText("UI_BACK"),
        }
        local Item = self:CreateWidgetNew("ComKeyTextDesc")
        self.HB_Key_GamePad:AddChild(Item)
        Item:CreateCommonKey(Info1)
    elseif State == 2 then
        -- 查看 + 返回
        local Info1 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "A",
                },
                    
            },
            Desc = GText("UI_Controller_Check"),
        }
        local Info2 = {
            KeyInfoList={
                {
                    Type = "Img",
                    ImgShortPath = "B",
                },
                    
            },
            Desc = GText("UI_BACK"),
        }
        local Item1 = self:CreateWidgetNew("ComKeyTextDesc")
        self.HB_Key_GamePad:AddChild(Item1)
        Item1:CreateCommonKey(Info1)
        local Item2 = self:CreateWidgetNew("ComKeyTextDesc")
        self.HB_Key_GamePad:AddChild(Item2)
        Item2:CreateCommonKey(Info2)
    end
end


return M

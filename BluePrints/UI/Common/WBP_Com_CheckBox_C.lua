---@type WBP_Com_CheckBox_LeftText_C|WBP_Com_CheckBox_RightText_C|WBP_Com_SwitchCheckBox_C
local WBP_Com_CheckBox_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_Com_CheckBox_C:Construct()
    self.bShowImg = false
    self:InitCommonCheckBox()
    self:SetKey("Img", "LS", nil)
end

---@param KeyType "Img"|"Text"
function WBP_Com_CheckBox_C:SetKey(KeyType, KeyName, SoundFunc)
    self.Com_KeyImg:CreateCommonKey({
        KeyInfoList={{
                Type = KeyType,
                ImgShortPath = KeyType=="Img" and KeyName or nil,
                Text = KeyType == "Text" and KeyName or nil,
        }},
        SoundFunc = SoundFunc,
    })
end

function WBP_Com_CheckBox_C:InitGamepadKey(KeyName)
    if not KeyName then
        self.bShowImg = false
        self.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        return
    end
    self:SetKey("Img", KeyName, nil)
    self.bShowImg = true
    self:RefreshBaseInfo()
end

function WBP_Com_CheckBox_C:HideKey(bIsHide)
    if (bIsHide) then
        self.KeyHolder:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
        self.KeyHolder:SetVisibility(UE4.ESlateVisibility.Visibie)
    end
end

function WBP_Com_CheckBox_C:InitCommonCheckBox()
    rawset(self, "Checked", false)
    rawset(self, "IsHovering", false)
    rawset(self, "IsPressing", false)
    rawset(self, "IsForbidden", false)
    rawset(self, "NotShowBg", false)
    rawset(self, "CurrentClickIsForbid", false)
    rawset(self, "ClickLogics", {})
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    --EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch, EUMGSequencePlayMode.Reverse)
    self.Image_Check:SetRenderOpacity(0)
    -- 绑定输入操作
    self:BindButtonPerformances()
    -- 基础信息
    self:RefreshBaseInfo()
    -- 添加需要监听的事件
    self:InitListenEvent()
end

function WBP_Com_CheckBox_C:UnInitCommonCheckBox()
    rawset(self, "ClickLogics", {})
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch, EUMGSequencePlayMode.Reverse)

    self:UnBindButtonPerformances()
    self:UnInitListenEvent()
end

function WBP_Com_CheckBox_C:InitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function WBP_Com_CheckBox_C:UnInitListenEvent()
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice) 
    end
end

function WBP_Com_CheckBox_C:RefreshBaseInfo()
    -- 刷新一些基础信息
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local Subsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    rawset(self, "GameInputModeSubsystem", Subsystem)
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function WBP_Com_CheckBox_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    if (CurInputDevice == ECommonInputType.Touch) then
        return
    end
    --- 切换手柄端相关图标显隐
    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.Group_BG:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if self.bShowImg then
            self.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        if not self.NotShowBg then
            self.Group_BG:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
        if self.bShowImg then
            self.Com_KeyImg:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end
    end
end

function WBP_Com_CheckBox_C:BindEventOnClicked(PressCallback)
    if not PressCallback or not PressCallback.Inst or not PressCallback.Func then
        return
    end
    if not self.ClickLogics[PressCallback.Inst] then
        rawset(self.ClickLogics, PressCallback.Inst, {})
    end
    table.insert(self.ClickLogics[PressCallback.Inst], PressCallback.Func)
end

function WBP_Com_CheckBox_C:UnBindEventOnClicked(PressCallback)
    if not PressCallback.Inst or not PressCallback.Func then
        return
    end
    if self.ClickLogics[PressCallback.Inst] then
        local temp_table = {}
        for _, Callback in pairs(self.ClickLogics[PressCallback.Inst]) do
            if Callback ~= PressCallback.Func then
                -- table.remove(self.ClickLogics[Inst], i)
                table.insert(temp_table, Callback)
            end
        end
        rawset(self.ClickLogics, PressCallback.Inst, temp_table)
    end
end

function WBP_Com_CheckBox_C:UnBindEventOnClickedByObj(Obj)
    if not Obj then
        return
    end
    if self.ClickLogics[Obj] then
        rawset(self.ClickLogics, Obj, nil)
    end
end

function WBP_Com_CheckBox_C:BindButtonPerformances()
    self.Btn_Click.OnClicked:Add(self, self.OnClicked)
    self.Btn_Click.OnPressed:Add(self, self.OnPressed)
    self.Btn_Click.OnReleased:Add(self, self.OnReleased)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
    self.Btn_Click.OnUnhovered:Add(self, self.OnUnhovered)
end

function WBP_Com_CheckBox_C:UnBindButtonPerformances()
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnPressed:Clear()
    self.Btn_Click.OnReleased:Clear()
    self.Btn_Click.OnHovered:Clear()
    self.Btn_Click.OnUnhovered:Clear()
end

function WBP_Com_CheckBox_C:OnClicked()
    if self.CurrentClickIsForbid ~= self.IsForbidden then
        return
    end
    if self.IsForbidden == true then
        return
    end
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Click)
    if self.Checked == true then
        rawset(self, "Checked", false)
        self:PlayCheckSound(false)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch, EUMGSequencePlayMode.Reverse)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
    elseif self.Checked == false then
        rawset(self, "Checked", true)
        self:PlayCheckSound(true)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch)
    end
    if next(self.ClickLogics) ~= nil then
        for Inst, Callbacks in pairs(self.ClickLogics) do
            for _, Callback in pairs(Callbacks) do
                Callback(Inst, self.Checked)
            end 
        end
    end
end

function WBP_Com_CheckBox_C:OnPressed()
    if self.IsForbidden == true then
        rawset(self, "CurrentClickIsForbid", true)
        return
    end
    rawset(self, "CurrentClickIsForbid", false)
    rawset(self, "IsPressing", true)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Press)
end

function WBP_Com_CheckBox_C:OnReleased()
    rawset(self, "IsPressing", false)
    if self.IsForbidden == true then
        return
    end
    if self.IsHovering == true then
        -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        -- EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
    else
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
    end
end

function WBP_Com_CheckBox_C:OnHovered()
    if self.IsForbidden == true then
        return
    end
    rawset(self, "IsHovering", true)
    if not self.IsPressing then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
    end
end

function WBP_Com_CheckBox_C:OnUnhovered()
    rawset(self, "IsHovering", false)
    if self.IsForbidden == true then
        return
    end
    if not self.IsPressing then
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.UnHover)
    end
end

function WBP_Com_CheckBox_C:ForbidBtn(IsForbid)
    -- DebugPrint("Forbid Btn", IsForbid)
    if self.IsForbidden == false and IsForbid == true then
        rawset(self, "IsForbidden", true)
        EMUIAnimationSubsystem:EMPlayAnimation(self, self.Forbidden)
    elseif self.IsForbidden == true and IsForbid == false then
        rawset(self, "IsForbidden", false)
        if self.IsHovering == true then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Hover)
        else
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
        end
    end
end

function WBP_Com_CheckBox_C:IsChecked()
    return self.Checked
end

function WBP_Com_CheckBox_C:SetIsChecked(IsChecked,IsPlaySound)
    if self.Checked == false and IsChecked == true then
        rawset(self, "Checked", true)
        if IsPlaySound then
            self:PlayCheckSound(true)
        end
        if self.IsForbidden == false then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch)
        else
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch)
        end
    elseif self.Checked == true and IsChecked == false then
        rawset(self, "Checked", false)
        if IsPlaySound then
            self:PlayCheckSound(false)
        end
        if self.IsForbidden == false then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch, EUMGSequencePlayMode.Reverse)
        else
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch, EUMGSequencePlayMode.Reverse)
        end
    end
    if next(self.ClickLogics) ~= nil then
        for Inst, Callbacks in pairs(self.ClickLogics) do
            for _, Callback in pairs(Callbacks) do
                Callback(Inst, self.Checked)
            end 
        end
    end
end

function WBP_Com_CheckBox_C:SetIsCheckedWithoutCallback(IsChecked,IsPlaySound)
    if self.Checked == false and IsChecked == true then
        rawset(self, "Checked", true)
        if IsPlaySound then
            self:PlayCheckSound(true)
        end
        if self.IsForbidden == false then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch)
        else
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch)
        end
    elseif self.Checked == true and IsChecked == false then
        rawset(self, "Checked", false)
        if IsPlaySound then
            self:PlayCheckSound(false)
        end
        if self.IsForbidden == false then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch, EUMGSequencePlayMode.Reverse)
        else
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch, EUMGSequencePlayMode.Reverse)
        end
    end
end

function WBP_Com_CheckBox_C:SetIsCheckedState(IsChecked)
    if self.Checked == false and IsChecked == true then
        rawset(self, "Checked", true)

        if self.IsForbidden == false then
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch)
        else
            EMUIAnimationSubsystem:EMPlayAnimation(self, self.Check_Switch)
        end
    elseif self.Checked == true and IsChecked == false then
        rawset(self, "Checked", false)

        local Mat = self.Image_Check:GetDynamicMaterial()
        if self.IsForbidden == false then
            Mat:SetScalarParameterValue("percent", 0)
        else
            Mat:SetScalarParameterValue("percent", 0)
        end
    end
end

function WBP_Com_CheckBox_C:PlayCheckSound(IsChecked)
    if IsChecked then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
    else
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    end
end

function WBP_Com_CheckBox_C:HideGamepadBackground(bNotShowBg)
    rawset(self, "NotShowBg", bNotShowBg)
end

function WBP_Com_CheckBox_C:Activate()
    self:OnClicked()
end

return WBP_Com_CheckBox_C
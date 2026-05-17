
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
    self.Text_Title:SetText(GText("UI_Dungeon_Type_List"))
    self.SelectGlows = {
        [1] = self.Select_Glow_L,
        [2] = self.Select_Glow_R,
    }
    self.AttributeBtns = {
        [1] = self.Attribute_L,
        [2] = self.Attribute_R,
    }
    self.RecAttributes = {
        [1] = self.Recommend_L,
        [2] = self.Recommend_R,
    }
    self.Recommend_L.Text_Attribute:SetText(GText("UI_SuggestAttribute"))
    self.Recommend_R.Text_Attribute:SetText(GText("UI_SuggestAttribute"))
    self.Attributes = {}
    self.AttributeIcons = {}
    self.SelectedAttrId = -1
    self:RefreshBaseInfo()
    self:InitListenEvent()
    self:InitGamepadKeys()
    self:BindEvents()
end

function M:IsMobile()
    return self.Platform == CommonConst.CLIENT_DEVICE_TYPE.MOBILE
end

function M:Destruct()
    self:UnBindEvents()
end

function M:Init(BossInfo, Attributes, CurAttrIdx, ConfirmCallback, CloseCallback)
    if not BossInfo or not Attributes then 
        GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@Init: BossInfo or Attributes is nil!")
        self:Close()
        return
    end
    if not CurAttrIdx then
        self.Btn_Close:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Back:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.SelectedAttrId = (CurAttrIdx and CurAttrIdx~=-1) and CurAttrIdx or 1
    self.ConfirmCallback = ConfirmCallback
    self.CloseCallback = CloseCallback
    self:SetBossInfo(BossInfo)
    self:SetAttrInfo(Attributes, self.SelectedAttrId)
    self:PlayInAnim()
    AudioManager(self):PlayUISound(self, "event:/ui/common/drama_property_change_page_in",nil,nil)
    self:SetFocus()
end

function M:InitListenEvent()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:RefreshBaseInfo()
    -- 刷新一些基础信息
    if (IsValid(self.GameInputModeSubsystem)) then
        self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    end
end

function M:BindEvents()
    self.Confirm_Btn:BindEventOnClicked(self, self.OnConfirmBtnClicked)
    self.Btn_Close:Init("Close", self, self.OnCloseBtnClicked)
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
end

function M:UnBindEvents()
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
     if (IsValid(self.GameInputModeSubsystem)) then
        self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self,self.RefreshOpInfoByInputDevice) 
    end
end

function M:SetBossInfo(BossInfo)
    local BossIcon = BossInfo.BossIcon
    if BossIcon then
        local IconDynaMaterial = self.Head_Boss:GetDynamicMaterial()
        if (IconDynaMaterial) then
            IconDynaMaterial:SetTextureParameterValue("MainTex", BossIcon)
        end
        IconDynaMaterial = self.BG_Boss_L:GetDynamicMaterial()
        if (IconDynaMaterial) then
            IconDynaMaterial:SetTextureParameterValue("MainTex", BossIcon)
        end
        IconDynaMaterial = self.BG_Boss_R:GetDynamicMaterial()
        if (IconDynaMaterial) then
            IconDynaMaterial:SetTextureParameterValue("MainTex", BossIcon)
        end
    else
        GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@SetBossInfo: BossIcon is nil!")
    end
end

function M:SetAttrInfo(Attributes, InitialAttrIdx)
    if not Attributes then
        GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@SetAttrInfo: Attributes is nil !")
        return
    elseif #Attributes ~= 2 then
        GWorld.logger.error("WBP_Abyss_ChangeAttribute_C@SetAttrInfo: #Attributes != 2 !")
        return
    end
    local BossAttrs = {}
    local AttributeIcons = {}
    for Index = 1,2,1 do
        local Attribute = Attributes[Index]
        local AttrData = DataMgr.Attribute[Attribute]
        local Icon = AttrData.Icon
        local IconObj = LoadObject(Icon)
        local RecAttribute = self.RecAttributes[Index]
        RecAttribute.Attribute:SetBrushResourceObject(IconObj)

        local CounterAttr = AttrData.CounterType
        local CounterAttrData = DataMgr.Attribute[CounterAttr]
        local CounterIcon = CounterAttrData.Icon
        local AttributeBtn = self.AttributeBtns[Index]
        local AttrIconObj = LoadObject(CounterIcon)
        BossAttrs[Index] = CounterAttr
        AttributeIcons[Index] = AttrIconObj
        AttributeBtn:Init(Index, AttributeIcons[Index], self)

        if Index == InitialAttrIdx then
            if IsValid(AttrIconObj) then
                self.Attribute:SetBrushResourceObject(AttrIconObj)
            end
            AttributeBtn:SetIsChecked(true, false)
        else
            AttributeBtn:SetIsChecked(false, false)
        end
    end
    self.Attributes = BossAttrs
    self.AttributeIcons = AttributeIcons
end

function M:AttrSelectionChanged(SelectedAttrId)
    for Index = 1,2,1 do
        local AttributeBtn = self.AttributeBtns[Index]
        if SelectedAttrId ~= Index then
            AttributeBtn:SetIsChecked(false)
        end
        --特效更新
        local SelectGlow = self.SelectGlows[Index]
        if SelectedAttrId ~= Index then
            SelectGlow:PlayAnimation(SelectGlow.Unselect)
        else
            SelectGlow:PlayAnimation(SelectGlow.Select)
        end
    end
    self.SelectedAttrId = SelectedAttrId
    --中间属性图标变更
    local AttrIcon = self.AttributeIcons[SelectedAttrId]
    if IsValid(AttrIcon) then
        self.Attribute:SetBrushResourceObject(AttrIcon)
    end
end

function M:InitGamepadKeys()
    if self:IsMobile() then
        return
    end
    self.Key_Back:CreateCommonKey({
        KeyInfoList={
            {
                Type = "Img",
                ImgShortPath = "B",
            },
        },
        Desc = GText("UI_Tips_Close")
    })
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    --- 切换手柄端相关图标显隐
    if (self:IsMobile()) then
        -- 触控模式即默认样式，不需要刷新
        return
    end

    local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
    if (IsUseKeyAndMouse) then
        self.UsingGamepad = false
         self.WBox_Controller:SetVisibility(ESlateVisibility.Collapsed)
    else
        self.UsingGamepad = true
         self.WBox_Controller:SetVisibility(ESlateVisibility.HitTestInvisible)
        self:SetFocusTarget()
    end
    self.Confirm_Btn:SwitchUIType(self.UsingGamepad)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    self:SetFocusTarget()
    return UIUtils.Handle
end

function M:SetFocusTarget()
    if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
        return
    end
    local CurrentBtn = self.AttributeBtns[self.SelectedAttrId]
    if (self.UsingGamepad and CurrentBtn ~= nil) then
        CurrentBtn:SetFocus()
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_FaceButton_Left") then
            if not self.Confirm_Btn.IsHovering then
                self.Confirm_Btn:OnBtnHovered()
            end
        else
            IsHandled = false
        end
    else
        if (InKeyName == "Escape") then
            if self.Btn_Close:IsVisible() then
                self:OnCloseBtnClicked()
            end
        else
            IsHandled = false
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = true

    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_FaceButton_Left") then
            if self.Confirm_Btn.IsHovering then
                self.Confirm_Btn:OnBtnUnhovered()
                self.Confirm_Btn:OnBtnClicked()
            end
        elseif (InKeyName == "Gamepad_FaceButton_Right") then
            if self.Key_Back:IsVisible() then
                self:OnCloseBtnClicked()
            end
        else
            IsHandled = false
        end
    else
        IsHandled = false
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnConfirmBtnClicked()
    if self:IsAnimationPlaying(self.Out) then return end
    self.bConfirmed = true
    self:PlayOutAnim()
end

function M:OnCloseBtnClicked()
    if self:IsAnimationPlaying(self.Out) then return end
    self.bConfirmed = false
    self:PlayOutAnim()
end

function M:PlayOutAnim()
    self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
    if (self.bConfirmed == true) then
        local CurrentAttribute = self.Attributes[self.SelectedAttrId]
        if self.ConfirmCallback then
            self.ConfirmCallback(CurrentAttribute)
        end
    end
    self:Close()
end

function M:PlayInAnim()
    self:PlayAnimation(self.In)
    for Index = 1,2,1 do
        local SelectGlow = self.SelectGlows[Index]
        if self.SelectedAttrId ~= Index then
            SelectGlow:PlayAnimation(SelectGlow.Unselect)
        else
            SelectGlow:PlayAnimation(SelectGlow.Select_In)
        end
    end
end

function M:Close()
    if self.CloseCallback then
        local CurrentAttribute = self.Attributes[self.SelectedAttrId]
        self.CloseCallback(CurrentAttribute)
    end
    self:RemoveFromParent()
end

return M
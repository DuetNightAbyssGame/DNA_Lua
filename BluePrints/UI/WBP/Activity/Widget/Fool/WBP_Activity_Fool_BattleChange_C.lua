require "UnLua"

local M = Class({"BluePrints.UI.BP_UIState_C"})
local HUDUIName = "AprilFoolDayHUD"
local ROTATE_SENSITIVITY  = 0.1
local GAMEPAD_SENSITIVITY = 0.05
local GAMEPAD_VELOCITY = 20
local GAMEPAD_DEAD_ZONE = 5

function M:OnLoaded(...)
    self.TransformID = ...
    self:InitChangeList()
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/sell_panel_expand", nil, nil)
end

function M:Construct()
    self.Text_Title:SetText(GText("RESOURCE_NAME_6000002"))
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Close:Init("Close", self, self.OnCloseBtnClicked)
    self:BindToAnimationFinished(self.Out, {self, self.CloseSelf})
    self.Handled = UE4.UWidgetBlueprintLibrary.Handled()
    self.Image_ForClick.OnMouseButtonDownEvent:Bind(self, self.ImageClickButtonDown)
    -- 玩家死亡时关闭界面
    self:AddDispatcher(EventID.OnTeamRecoveryStateChange, self, self.CloseOnPlayerDead)

    -- 输入设备切换绑定
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if (IsValid(self.GameInputModeSubsystem))then
        local CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
        rawset(self,"IsGamepadInput",CurInputDeviceType == ECommonInputType.Gamepad)
        self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
        self:RefreshOpInfoByInputDevice(CurInputDeviceType, "")
    end
end

function M:Destruct()
    self:UnbindAllFromAnimationFinished(self.Out)
end

-- 玩家死亡时关闭界面
function M:CloseOnPlayerDead(Eid, Type, PrevType)
    local Controller = self:GetOwningPlayer()
    local Player = Controller:K2_GetPawn()
    if Player and (Eid == Player:GetEid()) then
        if (Type == UE4.ETeamRecoveryState.Dying) then
            self.SkipOpenFoolHUD = true
            self:Close()
        end
    end
end

-- PC自动显示隐藏
function M:InitListViewScrollbar()
    local IsPC = CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
    if IsPC then
        self.List_Change:SetScrollBarVisibility(UE4.ESlateVisibility.Hidden)
        self.List_Change:SetControlScrollbarInside(true)
    end
end

function M:InitChangeList()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
        return
    end

    self:InitListViewScrollbar()
    self.List_Change:ClearListItems()
    local Index = 1
    local NavageteIndex = 0
    self.UnLockedContents = {}
    -- 已拥有的变身（读取服务端列表）
    for ID, _ in pairs(Avatar.UnlockedFoolsDayTransforms) do
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        local TransformData = DataMgr.TransformAFDayEvent[ID]
        Content.IconPath = TransformData and TransformData.Icon or ""
        Content.TransformID = ID
        Content.ParentWidget = self
        Content.Index = Index
        Content.IsHUDChange = true
        self.List_Change:AddItem(Content)

        if self.TransformID == ID then
            NavageteIndex = Index - 1
        end
        Index = Index + 1
        table.insert(self.UnLockedContents, Content)
    end
    self.ValidItemCount = Index - 1

    -- 未拥有的变身
    for ID, _ in pairs(DataMgr.TransformAFDayEvent) do
        if not Avatar.UnlockedFoolsDayTransforms[ID] then
            local Content = NewObject(UIUtils.GetCommonItemContentClass())
            Content.Islock = true
            self.List_Change:AddItem(Content)
        end
    end

    -- 导航到当前变身
    self.SelectFirstItem = true -- 打开界面时，默认选中第一个
    self.List_Change:NavigateToIndex(NavageteIndex)
end

-- 客户端切换变身
function M:OnListItemClick(Content)
    if self.LastClickedItem == Content then
        return
    end
    AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_btn_item", nil, nil)

    local ItemWidget = Content.SelfWidget
    if not ItemWidget then
        return
    end
    -- 选中动画
    ItemWidget:StopAnimation(ItemWidget.Normal)
    ItemWidget:PlayAnimation(ItemWidget.Click)
    -- 取消上一次选中
    if self.LastClickedItem then
        local LastItemWidget = self.LastClickedItem.SelfWidget
        if LastItemWidget then
            LastItemWidget:StopAnimation(LastItemWidget.Click)
            LastItemWidget:PlayAnimation(LastItemWidget.Normal)
        end
    end
    -- 记录当前选中
    self.LastClickedItem = Content
    -- 切换变身
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Avatar = GWorld:GetAvatar()
    if PlayerCharacter and IsValid(PlayerCharacter) then
        PlayerCharacter:ApplyAFDTransform(Content.TransformID)
        Avatar:RegionOnlineTransformAFDay(Content.TransformID)
        AudioManager(self):PlayFMODSound(PlayerCharacter, nil, "event:/ui/activity/fools_day_transform_player_3d")
    end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
    local IsGamepadInput = (CurInputDevice == ECommonInputType.Gamepad)
    if (IsGamepadInput)then
        self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        local BottomKeyInfo = {
            { KeyInfoList = {{Type = "Img", ImgShortPath = "A"}}, Desc = GText("UI_PATCH_ENSURE")},
            { KeyInfoList = {{Type = "Img", ImgShortPath = "B"}}, Desc = GText("UI_BACK")},
        }
        self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
    else
        self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
end

function M:PlayAnimationOut()
    AudioManager(self):PlayUISound(self, "event:/ui/common/sell_panel_shrink", nil, nil)
    self:PlayAnimation(self.Out)
end

function M:OnCloseBtnClicked()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
    self:CloseSelf()
end

function M:CloseSelf()
    local TransformID = self.LastClickedItem and self.LastClickedItem.TransformID
    self:Close()
    -- 打开主界面
    if not self.SkipOpenFoolHUD then
        UIManager():LoadUINew(HUDUIName, TransformID)
    end
end

-- 输入处理
function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if self.LastClickedItem and self.LastClickedItem.SelfWidget then
        self.LastClickedItem.SelfWidget:SetFocus()
    end

    return UWidgetBlueprintLibrary.Handled()
end

--- Begin 输入处理
-- 按键处理
function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_FaceButton_Right" then
            self:PlayAnimationOut()
        end
    else
        if InKeyName == "Escape" then
            self:PlayAnimationOut()
        end
    end
    return UIUtils.Handled
end

-- 开启镜头移动
function M:ImageClickButtonDown(MyGeometry, MouseEvent)
    self.CanMove = true
    UE4.UWidgetBlueprintLibrary.LockMouse(self.Handled, self)
    UE4.UWidgetBlueprintLibrary.CaptureMouse(self.Handled, self)
    return self.Handled
end

-- 关闭镜头移动
function M:StopCameraMove()
    self.CanMove = false
    UE4.UWidgetBlueprintLibrary.UnlockMouse(self.Handled, self)
    UE4.UWidgetBlueprintLibrary.ReleaseMouseCapture(self.Handled, self)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
    self:StopCameraMove()
    return self.Handled
end

function M:OnMouseCaptureLost()
    self:StopCameraMove()
end

-- 拖动鼠标移动镜头
function M:OnMouseMove(MyGeometry, MouseEvent)
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(MouseEvent)
    if not self.CanMove then
        return UIUtils.Handled
    end

    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerCharacter and IsValid(PlayerCharacter) then
        PlayerCharacter:AddCharacterYawInput(CursorDelta.X * ROTATE_SENSITIVITY)
        PlayerCharacter:AddCharacterPitchInput(-CursorDelta.Y * ROTATE_SENSITIVITY)
    end

    return UIUtils.Handled
end

-- 拖动触摸屏移动镜头
function M:OnTouchMoved(MyGeometry, InTouchEvent)
    local CursorDelta = UE4.UKismetInputLibrary.PointerEvent_GetCursorDelta(InTouchEvent)
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if PlayerCharacter and IsValid(PlayerCharacter) then
        PlayerCharacter:AddCharacterYawInput(CursorDelta.X * ROTATE_SENSITIVITY)
        PlayerCharacter:AddCharacterPitchInput(-CursorDelta.Y * ROTATE_SENSITIVITY)
    end

    return UIUtils.Handled
end

-- 摇杆移动镜头
function M:OnAnalogValueChanged(MyGeometry,InAnalogInputEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)

    if not (InKeyName == UIConst.GamePadKey.RightAnalogX or InKeyName == UIConst.GamePadKey.RightAnalogY) then
       return UIUtils.Handled
    end

    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * GAMEPAD_VELOCITY
    if PlayerCharacter and math.abs(DeltaOffset) > GAMEPAD_DEAD_ZONE then
        if InKeyName == UIConst.GamePadKey.RightAnalogX then
            PlayerCharacter:AddCharacterYawInput(DeltaOffset * GAMEPAD_SENSITIVITY)
        else
            PlayerCharacter:AddCharacterPitchInput(DeltaOffset * GAMEPAD_SENSITIVITY)
        end
    end
    return UIUtils.Handled
end
--- End 输入处理

return M
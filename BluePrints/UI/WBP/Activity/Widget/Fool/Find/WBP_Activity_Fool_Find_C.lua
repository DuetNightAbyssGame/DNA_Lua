local EFindState = {
    None = 0,
    Playing = 1,
    PreSettlement = 2,
    Settling = 3,
    Completed = 4
}

local EFindResult = {
    None = 0,
    Abandoned = 1,
    Defeat = 2,
    Victory = 3
}

---@type WBP_Activity_Fool_Find_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr"
})

function M:Construct()
    self.TitleText = self.Text_PostTitle
    self.TimeText = self.Text_TimeNum
    self.Image = self.Image_Find
    self.CloseButton = self.Btn_Close
    self.KeyTips = self.Com_KeyTips
    self.GamepadCursor = self.FoolSelect_Controller
    self.Yes = self.Find_Yes
    self.No = self.Find_No

    self.FadeInAnimation = self.In
    self.FadeOutAnimation = self.Out
    self.RedTimeingAnimation = self.Countdown_Refresh_Red
    self.YellowTimeingAnimation = self.Countdown_Refresh_Yellow
    self.NormalTimeingAnimation = self.Countdown_Refresh_Normal

    self.BGMPathName = "event:/bgm/1_0/0090_system_shooting"
    self.CountdownBeginSoundPathName = "event:/ui/activity/fools_day_level_start_coutdown_first_time"
    self.CountdownUpdateSoundPathName = "event:/ui/activity/fools_day_level_start_coutdown_common"
    self.ClickYesSoundPathName = "event:/ui/activity/fools_day_level_click_correct"
    self.ClickNoSoundPathName = "event:/ui/activity/fools_day_level_click_error"

    self.TitleText:SetText(GText("AFDayEvent_MiniGame_Des"))
    self.CloseButton:Init("Close", self, self.Close)

    self.GamepadCursorMoveSpeed = 25
    self.GamepadCursorLerpAlpha = 0.85

    self.InputType = nil
    self.GamepadCursorTargetPosition = UE4.FVector2D(0, 0)

    self.PhotoId = nil
    self.TransformId = nil
    self.LikeCountDetails = nil
    self.MyLikeRecord = nil
    self.Texture = nil
    self.TextureAlpha = nil
    self.OnCompleted = nil
    self.FoolsDaySettlementUI = nil

    self.LimitSeconds = 10
    self.UpdateSeconds = 1
    self.ClickHalfWidth = 25

    self.FindState = EFindState.None
    self.ClickCount = 0
    self.RemainingSeconds = 0
    self.UpdateTimerHandle = nil
    self.bSuccess = false

    self:SetKeyboardFocus()
    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())

    self:ListenInputTypeChanged()
    self:BindToAnimationFinished(self.FadeOutAnimation, { self, self.RemoveFromParent })

    self:PlayAnimation(self.FadeInAnimation)
end

function M:Destruct()
    self:UnlistenInputTypeChanged()
    self:UnbindFromAnimationFinished(self.FadeOutAnimation, { self, self.RemoveFromParent })

    if (IsValid(self.FoolsDaySettlementUI)) then
        self.FoolsDaySettlementUI:Close()
    end

    if (self.OnCompleted) then
        self.OnCompleted[2](self.OnCompleted[1], self.bSuccess)
    end
end

function M:Tick(MyGeometry, InDeltaTime)
    self:UpdateGamepadCursorPosition()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    if (KeyName == UIConst.GamePadKey.FaceButtonRight) then
        self:Close()
    elseif (KeyName == UIConst.GamePadKey.FaceButtonBottom) then
        local Geometry = self.GamepadCursor:GetParent():GetCachedGeometry()
        local LocalPosition = self.GamepadCursor.RenderTransform.Translation
        local AbsolutePosition = UE4.USlateBlueprintLibrary.LocalToAbsolute(Geometry, LocalPosition)
        self:HandleImageClicked(AbsolutePosition)
    elseif (KeyName == "Escape") then
        self:Close()
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    if KeyName == UIConst.GamePadKey.LeftAnalogX then
        local InputX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        local MoveX = InputX * self.GamepadCursorMoveSpeed
        self:AddGamepadCursorOffset({ X = MoveX, Y = 0 })
    elseif KeyName == UIConst.GamePadKey.LeftAnalogY then
        local InputY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
        local MoveY = InputY * self.GamepadCursorMoveSpeed
        self:AddGamepadCursorOffset({ X = 0, Y = MoveY })
    end

    return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:ListenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
    end
end

function M:UnlistenInputTypeChanged()
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    if (IsValid(GameInputModeSubsystem)) then
        GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
    end
end

function M:SetInputType(NewInputType, NewGamepadName)
    if (self.InputType == NewInputType) then
        return
    end

    self.InputType = NewInputType

    if (NewInputType == ECommonInputType.Touch) then
        self.KeyTips:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.GamepadCursor:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif NewInputType == ECommonInputType.Gamepad then
        self.KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "A", ClickCallback = self.Close, Owner = self } },
                Desc = GText("UI_Tips_Ensure")
            },
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback = self.Close, Owner = self } },
                Desc = GText("UI_Tips_Close")
            }
        })
        self.KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:AddTimer(0.01, function()
            local ClickWidth = self.ClickHalfWidth * 2
            local CursorParentGeometry = self.GamepadCursor:GetParent():GetCachedGeometry()
            local LocalOriginPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CursorParentGeometry, UE4.FVector2D(0, 0))
            local LocalVertexPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(CursorParentGeometry, UE4.FVector2D(ClickWidth, ClickWidth))
            local CursorSize = UE4.FVector2D(LocalVertexPosition.X - LocalOriginPosition.X, LocalVertexPosition.Y - LocalOriginPosition.Y)
            self.GamepadCursor.Slot:SetSize(CursorSize)

            local CursorParentLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CursorParentGeometry)
            self.GamepadCursorTargetPosition = UE4.FVector2D(CursorParentLocalSize.X / 2, CursorParentLocalSize.Y / 2)
            self.GamepadCursor:SetRenderTranslation(self.GamepadCursorTargetPosition)
            self.GamepadCursor:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        end, false, 0, nil, true)
    else
        self.KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Close, Owner = self } },
                Desc = GText("UI_BACK")
            },
        })
        self.KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        self.GamepadCursor:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:Init(PhotoId, TransformId, LikeCountDetails, MyLikeRecord, Texture, TextureAlpha, LimitSeconds, OnCompleted)
    self.PhotoId = PhotoId
    self.TransformId = TransformId
    self.LikeCountDetails = LikeCountDetails
    self.MyLikeRecord = MyLikeRecord
    self.Texture = Texture
    self.TextureAlpha = TextureAlpha
    self.LimitSeconds = LimitSeconds
    self.OnCompleted = OnCompleted

    local Brush = UE4.FSlateBrush()
    Brush.ResourceObject = Texture
    Brush.ImageSize = UE4.UTextureLibrary.GetTextureSize(Texture)
    self.Image:SetBrush(Brush)
    self.TimeText:SetText(tostring(LimitSeconds))

    self:BeginGame()
end

function M:Close()
    if (self:IsAnimationPlaying(self.FadeOutAnimation)) then
        return
    end

    if (self.FindState == EFindState.Playing) then
        self:EndGame(EFindResult.Abandoned)
    end

    self:PlayAnimation(self.FadeOutAnimation)
end

function M:BeginGame()
    if (self.FindState ~= EFindState.None) then
        DebugPrint(_G.ErrorTag, string.format("%s begin game failed, current state is %d.", self:GetName(), self.FindState))
        return
    end

    self.FindState = EFindState.Playing

    self.ClickCount = 0
    self.RemainingSeconds = self.LimitSeconds

    local Avatar = GWorld:GetAvatar()
    if (Avatar) then
        Avatar:CallServerMethod("FoolsDayMiniGameStart", self.PhotoId)
    end

    AudioManager(self):PlaySystemUIBGM(self.BGMPathName, nil, self.BGMPathName)
    AudioManager(self):PlayUISound(self, self.CountdownBeginSoundPathName, nil, nil)

    self:UpdateGameTiming(0)
    self.UpdateTimerHandle = self:AddTimer(self.UpdateSeconds, function()
        self:UpdateGameTiming(self.UpdateSeconds)
    end, true, 0, nil, true)
end

function M:UpdateGameTiming(DeltaSeconds)
    if (self.FindState ~= EFindState.Playing) then
        DebugPrint(_G.ErrorTag, string.format("%s update game timing failed, current state is %d.", self:GetName(), self.FindState))
        return
    end

    self.RemainingSeconds = self.RemainingSeconds - DeltaSeconds
    self.TimeText:SetText(tostring(self.RemainingSeconds))

    AudioManager(self):PlayUISound(self, self.CountdownUpdateSoundPathName, nil, nil)

    if (self.RemainingSeconds <= 0) then
        self:EndGame(EFindResult.Defeat)
    elseif (self.RemainingSeconds <= 3) then
        self:PlayAnimation(self.RedTimeingAnimation)
    elseif (self.RemainingSeconds <= 6) then
        self:PlayAnimation(self.YellowTimeingAnimation)
    elseif (self.RemainingSeconds <= 10) then
        self:PlayAnimation(self.NormalTimeingAnimation)
    end
end

function M:EndGame(FindResult)
    if (self.FindState ~= EFindState.Playing) then
        DebugPrint(_G.ErrorTag, string.format("%s end game failed, current state is %d.", self:GetName(), self.FindState))
        return
    end

    self:RemoveTimer(self.UpdateTimerHandle)

    local Avatar = GWorld:GetAvatar()
    if (Avatar) then
        Avatar:CallServerMethod("FoolsDayCompleteMiniGame", self.PhotoId, self.TransformId or -1, self.ClickCount, FindResult == EFindResult.Victory)
    end

    if (FindResult == EFindResult.Abandoned) then
        self.FindState = EFindState.Completed
    elseif (FindResult == EFindResult.Defeat) then
        self:Settlement(false)
    elseif (FindResult == EFindResult.Victory) then
        self.FindState = EFindState.PreSettlement
        UE4.UTextureLibrary.ComputeTextureRedBound_Color(self.TextureAlpha, 0, { self, function(_, TextureSize, RectMinPoint, RectMaxPoint)
            local MinAbsolutePosition = self:ImagePixelPositionToAbsolutePosition(self.Image, RectMinPoint)
            local MaxAbsolutePosition = self:ImagePixelPositionToAbsolutePosition(self.Image, RectMaxPoint)
            self:ShowYes(MinAbsolutePosition, MaxAbsolutePosition, function()
                self:Settlement(true)
            end)
        end })
    end
end

function M:Settlement(bSuccess)
    if (self.FindState ~= EFindState.Playing and self.FindState ~= EFindState.PreSettlement) then
        DebugPrint(_G.ErrorTag, string.format("%s settlement failed, current state is %d.", self:GetName(), self.FindState))
        return
    end

    self.FindState = EFindState.Settling

    self.bSuccess = bSuccess

    AudioManager(self):SetEventSoundParam(self, self.BGMPathName, { state = 1 })

    self.FoolsDaySettlementUI = UIManager(self):_CreateWidgetNew("FoolsDaySettlement")
    self.FoolsDaySettlementUI:Init(self.PhotoId, self.TransformId, self.LikeCountDetails, self.MyLikeRecord, bSuccess, self.ClickCount, { self, function()
        self.FindState = EFindState.Completed
        AudioManager(self):StopSystemUIBGM(self.BGMPathName)
        self:Close()
    end })
end

function M:HandleImageClicked(AbsolutePosition)
    if (self.FindState ~= EFindState.Playing) then
        return
    end

    local MinAbsolutePosition = UE4.FVector2D(
            AbsolutePosition.X - self.ClickHalfWidth,
            AbsolutePosition.Y - self.ClickHalfWidth
    )

    local MaxAbsolutePosition = UE4.FVector2D(
            AbsolutePosition.X + self.ClickHalfWidth,
            AbsolutePosition.Y + self.ClickHalfWidth
    )

    local RectMinPoint = self:AbsolutePositionToImagePixelPosition(self.Image, MinAbsolutePosition)
    local RectMaxPoint = self:AbsolutePositionToImagePixelPosition(self.Image, MaxAbsolutePosition)
    UE4.UTextureLibrary.ReadTexturePixels_Color(self.TextureAlpha, RectMinPoint, RectMaxPoint, { self, function(_, TextureSize, Pixels)
        self:HandlePixelsRead(AbsolutePosition, TextureSize, Pixels)
    end })
end

function M:HandlePixelsRead(ClickAbsolutePosition, TextureSize, Pixels)
    if (self.FindState ~= EFindState.Playing) then
        return
    end

    self.ClickCount = self.ClickCount + 1

    local bHasPlayerCharacter = self:PixelsHasPlayerCharacter(Pixels)
    if (bHasPlayerCharacter) then
        self:EndGame(EFindResult.Victory)
    else
        self:ShowNo(ClickAbsolutePosition)
    end
end

function M:ShowYes(MinAbsolutePosition, MaxAbsolutePosition, OnShowCompleted)
    self.Yes:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Yes:StopAllAnimations()
    self.Yes:PlayAnimation(self.Yes.Show)

    local Geometry = self.Yes:GetParent():GetCachedGeometry()
    local MinLocalPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(Geometry, MinAbsolutePosition)
    local MaxLocalPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(Geometry, MaxAbsolutePosition)

    local Size = UE4.FVector2D(
            MaxLocalPosition.X - MinLocalPosition.X,
            MaxLocalPosition.Y - MinLocalPosition.Y
    )
    self.Yes.ImageScaleBG.Slot:SetSize(Size)

    local Position = UE4.FVector2D(
            (MinLocalPosition.X + MaxLocalPosition.X) / 2,
            (MinLocalPosition.Y + MaxLocalPosition.Y) / 2
    )
    self.Yes:SetRenderTranslation(Position)

    self:AddTimer(self.Yes.Show:GetEndTime(), function()
        if (OnShowCompleted) then
            OnShowCompleted()
        end
    end, false, 0, nil, true)

    AudioManager(self):PlayUISound(self, self.ClickYesSoundPathName, nil, nil)
end

function M:ShowNo(AbsolutePosition)
    self.No:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.No:StopAllAnimations()
    self.No:PlayAnimation(self.No.Show)

    local Geometry = self.No:GetParent():GetCachedGeometry()
    local LocalPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(Geometry, AbsolutePosition)
    self.No:SetRenderTranslation(LocalPosition)

    AudioManager(self):PlayUISound(self, self.ClickNoSoundPathName, nil, nil)
end

function M:UpdateGamepadCursorPosition()
    if (self.InputType ~= ECommonInputType.Gamepad) then
        return
    end

    local Current = self.GamepadCursor.RenderTransform.Translation
    local Target = self.GamepadCursorTargetPosition
    if (Current.X == Target.X and Current.Y == Target.Y) then
        return
    end

    local Alpha = self.GamepadCursorLerpAlpha
    local New = UE4.FVector2D(
            Current.X + (Target.X - Current.X) * Alpha,
            Current.Y + (Target.Y - Current.Y) * Alpha
    )

    self.GamepadCursor:SetRenderTranslation(New)
end

function M:AddGamepadCursorOffset(Offset)
    local Geometry = self.GamepadCursor:GetParent():GetCachedGeometry()
    local MinAbsolutePosition, MaxAbsolutePosition = self:CalculateGamepadCursorAbsoluteLimitPosition()
    local MinLocalPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(Geometry, MinAbsolutePosition)
    local MaxLocalPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(Geometry, MaxAbsolutePosition)

    local CursorTargetPosition = self.GamepadCursorTargetPosition
    CursorTargetPosition.X = math.clamp(CursorTargetPosition.X + Offset.X, MinLocalPosition.X, MaxLocalPosition.X)
    CursorTargetPosition.Y = math.clamp(CursorTargetPosition.Y - Offset.Y, MinLocalPosition.Y, MaxLocalPosition.Y)
end

function M:CalculateGamepadCursorAbsoluteLimitPosition()
    local Geometry = self.Image:GetCachedGeometry()
    local MinAbsolutePosition = UE4.UUIFunctionLibrary.GetGeometryAbsolutePosition(Geometry)
    local AbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(Geometry)
    local MaxAbsolutePosition = UE4.FVector2D(
            MinAbsolutePosition.X + AbsoluteSize.X,
            MinAbsolutePosition.Y + AbsoluteSize.Y
    )
    return MinAbsolutePosition, MaxAbsolutePosition
end

function M:PixelsHasPlayerCharacter(Pixels)
    for i = 1, Pixels:Length() do
        local Color = Pixels:GetRef(i)
        if (Color.R == 0 and Color.G == 0 and Color.B == 0) then
            return true
        end
    end
    return false
end

function M:ImagePixelPositionToAbsolutePosition(Image, PixelPosition)
    if (not IsValid(Image)) then
        return FVector2D(0, 0)
    end

    local Geometry = Image:GetCachedGeometry()
    local LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
    local LocalPosition = UE4.FVector2D(
            LocalSize.X * PixelPosition.X / Image.Brush.ImageSize.X,
            LocalSize.Y * PixelPosition.Y / Image.Brush.ImageSize.Y
    )

    local AbsolutePosition = UE4.USlateBlueprintLibrary.LocalToAbsolute(Geometry, LocalPosition)
    return AbsolutePosition
end

function M:AbsolutePositionToImagePixelPosition(Image, AbsolutePosition)
    if (not IsValid(Image)) then
        return FVector2D(0, 0)
    end

    local Geometry = Image:GetCachedGeometry()
    local LocalPosition = UE4.USlateBlueprintLibrary.AbsoluteToLocal(Geometry, AbsolutePosition)
    local LocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)

    local PixelPosition = UE4.FVector2D(
            Image.Brush.ImageSize.X * LocalPosition.X / LocalSize.X,
            Image.Brush.ImageSize.Y * LocalPosition.Y / LocalSize.Y
    )
    return PixelPosition
end

return M

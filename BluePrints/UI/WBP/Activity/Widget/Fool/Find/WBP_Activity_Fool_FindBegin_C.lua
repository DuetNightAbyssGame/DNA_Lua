local ELoadType = {
    Texture = 1,
    TextureAlpha = 2
}

local ELoadState = {
    None = 0,
    Loading = 1,
    Completed = 2
}

local ELoadResult = {
    None = 0,
    Succeed = 1,
    Failed = 2
}

---@type WBP_Activity_Fool_FindBegin_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
    self.TitleGroup = self.Group_Title
    self.TitleText = self.Text_PostTitle
    self.DescGroup = self.Group_IconDesc
    self.DescText = self.Text_IconDesc
    self.Image = self.Image_Find
    self.LoadGroup = self.Group_LoadFail
    self.LoadFailText = self.Text_LoadFail
    self.ReloadButton = self.Btn_Retry
    self.CloseButton = self.Btn_Close
    self.BeginFindGroup = self.GroupBtn
    self.BeginFindButton = self.Btn_Start
    self.KeyTips = self.Com_KeyTips
    self.GamepadReloadTip = self.Key_Fail

    self.FadeInAnimation = self.In
    self.FadeOutAnimation = self.Out
    self.LoadingAnimation = self.Loading_Loop
    self.LoadFailAnimation = self.LoadFail

    self.PanelSoundPathName = "event:/ui/activity/fools_day_level_start_panel_show"
    self.BeginFindButtonClickSoundPathName = "event:/ui/activity/fools_day_btn_common"

    self.TitleText:SetText(GText("AFDayEvent_MiniGame_Des"))
    self.LoadFailText:SetText(GText("AFDayEvent_PhotoWall_LoadFailed"))
    self.CloseButton:Init("Close", self, self.Close)
    self.BeginFindButton:SetText(GText("AFDayEvent_MiniGame_Start"))
    self.BeginFindButton:TryOverrideSoundFunc(function(_)
        AudioManager(self):PlayUISound(self, self.BeginFindButtonClickSoundPathName, nil, nil)
    end)
    self.GamepadReloadTip:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)

    self.InputType = nil

    self.PhotoId = nil
    self.TransformId = nil
    self.LikeCountDetails = nil
    self.MyLikeRecord = nil
    self.TextureURL = nil
    self.TextureAlphaURL = nil
    self.DescString = nil
    self.bIsOtherPicture = nil
    self.OnClosed = nil
    self.FoolsDayFindUI = nil

    self.LoadState = ELoadState.None
    self.LoadResult = ELoadResult.None

    self.FindLimitSeconds = DataMgr.EventConstant.MiniGameCountdown.ConstantValue or 0

    self:SetKeyboardFocus()
    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())

    self.ReloadButton.OnClicked:Add(self, self.TryLoadImage)
    self.BeginFindButton:BindEventOnClicked(self, self.BeginFind)
    self:ListenInputTypeChanged()
    self:BindToAnimationFinished(self.FadeOutAnimation, { self, self.RemoveFromParent })

    self:PlayAnimation(self.FadeInAnimation)
end

function M:Destruct()
    self.ReloadButton.OnClicked:Remove(self, self.TryLoadImage)
    self.BeginFindButton:UnBindEventOnClicked(self, self.BeginFind)
    self:UnlistenInputTypeChanged()
    self:UnbindFromAnimationFinished(self.FadeOutAnimation, { self, self.RemoveFromParent })

    if (IsValid(self.FoolsDayFindUI)) then
        self.FoolsDayFindUI:Close()
    end

    if (self.OnClosed) then
        self.OnClosed[2](self.OnClosed[1])
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    if (KeyName == UIConst.GamePadKey.FaceButtonRight) then
        self:Close()
    elseif (KeyName == UIConst.GamePadKey.FaceButtonBottom) then
        if (self.LoadResult == ELoadResult.Failed) then
            self:TryLoadImage()
        elseif (self.LoadResult == ELoadResult.Succeed and self.bIsOtherPicture) then
            self:BeginFind()
        end
    elseif (KeyName == "Escape") then
        self:Close()
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
        self.GamepadReloadTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif NewInputType == ECommonInputType.Gamepad then
        self.KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback = self.Close, Owner = self } },
                Desc = GText("UI_Tips_Close")
            }
        })
        self.KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        self.GamepadReloadTip:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.KeyTips:UpdateKeyInfo({
            {
                KeyInfoList = { { Type = "Text", Text = "Esc", ClickCallback = self.Close, Owner = self } },
                Desc = GText("UI_BACK")
            }
        })
        self.KeyTips:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        self.GamepadReloadTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
end

function M:Init(PhotoId, TransformId, LikeCountDetails, MyLikeRecord, TextureURL, TextureAlphaURL, Desc, bIsOtherPicture, OnClosed)
    self.PhotoId = PhotoId
    self.TransformId = TransformId
    self.LikeCountDetails = LikeCountDetails
    self.MyLikeRecord = MyLikeRecord
    self.TextureURL = TextureURL
    self.TextureAlphaURL = TextureAlphaURL
    self.DescString = Desc
    self.bIsOtherPicture = bIsOtherPicture
    self.OnClosed = OnClosed

    if (Desc and Desc ~= "") then
        self.DescText:SetText(Desc)
        self.DescGroup:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
        self.DescGroup:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end

    self:TryLoadImage()

    AudioManager(self):PlayUISound(self, self.PanelSoundPathName, nil, nil)
end

function M:Close()
    if (self:IsAnimationPlaying(self.FadeOutAnimation)) then
        return
    end

    self:PlayAnimation(self.FadeOutAnimation)

    AudioManager(self):PlayUISound(self, self.PanelSoundPathName, nil, { ToEnd = 1 })
end

function M:TryLoadImage()
    if (self.LoadResult == ELoadResult.Succeed) then
        DebugPrint(_G.ErrorTag, string.format("%s try load image ignored, image already loaded successfully.", self:GetName()))
        return
    end

    if (self.LoadState ~= ELoadState.None and self.LoadResult ~= ELoadState.Completed) then
        DebugPrint(_G.ErrorTag, string.format("%s try load image ignored, current state is %d.", self:GetName(), self.LoadState))
        return
    end

    self.LoadState = ELoadState.Loading
    self.LoadResult = ELoadResult.None

    self.LoadGroup:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.LoadingAnimation, 0, 0)

    self.TitleGroup:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Image:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BeginFindGroup:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.ReloadButton:SetVisibility(UE4.ESlateVisibility.Collapsed)

    local LoadTags = {
        [ELoadType.Texture] = false,
        [ELoadType.TextureAlpha] = false
    }

    local CompleteLoad = function(LoadTag)
        LoadTags[LoadTag] = true

        local AllLoaded = true
        for _, bLoaded in pairs(LoadTags) do
            if (not bLoaded) then
                AllLoaded = false
                break
            end
        end

        if (AllLoaded) then
            if (self.bIsOtherPicture) then
                if (IsValid(self.Texture) and IsValid(self.TextureAlpha)) then
                    self:EndLoadImage(ELoadResult.Succeed)
                else
                    self:EndLoadImage(ELoadResult.Failed)
                end
            else
                if (IsValid(self.Texture)) then
                    self:EndLoadImage(ELoadResult.Succeed)
                else
                    self:EndLoadImage(ELoadResult.Failed)
                end
            end
        end
    end

    local FoolsDaySubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UFoolsDaySubsystem)
    if (not IsValid(FoolsDaySubsystem)) then
        DebugPrint(_G.ErrorTag, string.format("%s try load image failed, FoolsDaySubsystem is invalid.", self:GetName()))
        CompleteLoad(ELoadType.Texture)
        CompleteLoad(ELoadType.TextureAlpha)
        return
    end

    FoolsDaySubsystem:RequestImage(self.TextureURL, { self, function(_, RequestedImage)
        self.Texture = RequestedImage
        CompleteLoad(ELoadType.Texture)
    end })

    FoolsDaySubsystem:RequestImage(self.TextureAlphaURL, { self, function(_, RequestedImage)
        self.TextureAlpha = RequestedImage
        CompleteLoad(ELoadType.TextureAlpha)
    end })
end

function M:EndLoadImage(LoadResult)
    if (self.LoadState ~= ELoadState.Loading) then
        DebugPrint(_G.ErrorTag, string.format("%s end load image failed, current state is %d.", self:GetName(), self.LoadState))
        return
    end

    self.LoadState = ELoadState.Completed
    self.LoadResult = LoadResult

    self:StopAnimation(self.LoadingAnimation)

    if (LoadResult == ELoadResult.Succeed) then
        local Brush = UE4.FSlateBrush()
        Brush.ResourceObject = self.Texture
        Brush.ImageSize = UE4.UTextureLibrary.GetTextureSize(self.Texture)
        self.Image:SetBrush(Brush)

        self.LoadGroup:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Image:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)

        if (self.bIsOtherPicture) then
            self.TitleGroup:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
            self.BeginFindGroup:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
            self.TitleGroup:SetVisibility(UE4.ESlateVisibility.Collapsed)
            self.BeginFindGroup:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
    else
        self:PlayAnimation(self.LoadFailAnimation)
        self.ReloadButton:SetVisibility(UE4.ESlateVisibility.Visible)
    end
end

function M:BeginFind()
    if (not self.bIsOtherPicture) then
        DebugPrint(_G.ErrorTag, string.format("%s begin find ignored, current picture is not other picture.", self:GetName()))
        return
    end

    self.FoolsDayFindUI = UIManager(self):_CreateWidgetNew("FoolsDayFind")
    self.FoolsDayFindUI:Init(self.PhotoId, self.TransformId, self.LikeCountDetails, self.MyLikeRecord, self.Texture, self.TextureAlpha, self.FindLimitSeconds, { self, function(_, bSuccess)
        if (bSuccess) then
            self:Close()
        else
            self:SetKeyboardFocus()
        end
    end })
end

return M

local GamepadKeys = {
    "X", "Y", "LS", "RS"
}

local GamepadKeyToFaceItemIndexMap = {
    [UIConst.GamePadKey.FaceButtonLeft] = 1,
    [UIConst.GamePadKey.FaceButtonTop] = 2,
    [UIConst.GamePadKey.LeftThumb] = 3,
    [UIConst.GamePadKey.RightThumb] = 4,
}

---@type WBP_Activity_Fool_Settlement_C
local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
    self.TitleText = self.Text_Title
    self.DescText = self.Text_SettlementDesc
    self.EvaluationText = self.Text_Desc
    self.KeyTipSwitcher = self.Switcher_Text
    self.CloseTipText = self.Text_Tips
    self.GamepadKeyTip = self.Com_MidKeyTips
    self.CloseButton = self.Btn_Close

    self.FaceItems = {}
    for i = 1, 4, 1 do
        local FaceItem = self["FaceItem_" .. i]
        local FaceSlot = self["WBP_Activity_Fool_Detail_FaceItemSlot0" .. i]
        self.FaceItems[i] = FaceItem
        FaceItem:Init(FaceSlot, GamepadKeys[i], function(bChecked)
            self:HandleOnLikeButtonClicked(i, bChecked)
        end, true)
    end

    self.VictoryInAnimation = self.Victory_In
    self.DefeatInAnimation = self.Defeat_In
    self.FadeOutAnimation = self.Out

    self.SuccessSoundPathName = "event:/ui/activity/fools_day_level_success_panel_show"
    self.FailSoundPathName = "event:/ui/activity/fools_day_level_fail_panel_show"

    self.EvaluationText:SetText(GText("AFDayEvent_MiniGame_InviteLike"))
    self.CloseTipText:SetText(GText("UI_Armory_ClickEmpty"))

    self.InputType = nil

    self.PhotoId = nil
    self.TransformId = nil
    self.LikeCountDetails = nil
    self.MyLikeRecord = nil
    self.bSuccess = false
    self.ClickCount = 0
    self.OnClosed = nil

    self:SetKeyboardFocus()
    self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())

    self.CloseButton.OnClicked:Add(self, self.Close)
    self:BindToAnimationFinished(self.FadeOutAnimation, { self, self.RemoveFromParent })
    self:ListenInputTypeChanged()
end

function M:Destruct()
    self.CloseButton.OnClicked:Remove(self, self.Close)
    self:UnbindFromAnimationFinished(self.FadeOutAnimation, { self, self.RemoveFromParent })
    self:UnlistenInputTypeChanged()

    if (self.OnClosed) then
        self.OnClosed[2](self.OnClosed[1])
    end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)

    if (KeyName == UIConst.GamePadKey.FaceButtonLeft
            or KeyName == UIConst.GamePadKey.FaceButtonTop
            or KeyName == UIConst.GamePadKey.LeftThumb
            or KeyName == UIConst.GamePadKey.RightThumb) then
        local FaceItemIndex = GamepadKeyToFaceItemIndexMap[KeyName]
        local FaceItem = self.FaceItems[FaceItemIndex]
        FaceItem:OnBtnClicked()
        FaceItem:PlayButtonClickSound()
    elseif (KeyName == UIConst.GamePadKey.FaceButtonRight) then
        self:Close()
        --elseif (KeyName == "Escape") then
        --    self:Close()
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
        for _, FaceItem in ipairs(self.FaceItems) do
            FaceItem:SwitchUIType(false)
        end

        self.KeyTipSwitcher:SetActiveWidget(self.CloseTipText)
    elseif NewInputType == ECommonInputType.Gamepad then
        for _, FaceItem in ipairs(self.FaceItems) do
            FaceItem:SwitchUIType(true)
        end

        self.GamepadKeyTip:UpdateKeyInfo({
            {
                KeyInfoList = { { Type = "Img", ImgShortPath = "B", ClickCallback = self.Close, Owner = self } },
                Desc = GText("UI_Tips_Close")
            }
        })

        self.KeyTipSwitcher:SetActiveWidget(self.GamepadKeyTip)
    else
        for _, FaceItem in ipairs(self.FaceItems) do
            FaceItem:SwitchUIType(false)
        end

        self.KeyTipSwitcher:SetActiveWidget(self.CloseTipText)
    end
end

function M:Init(PhotoId, TransformId, LikeCountDetails, MyLikeRecord, bSuccess, ClickCount, OnClosed)
    self.PhotoId = PhotoId
    self.TransformId = TransformId
    self.LikeCountDetails = LikeCountDetails or {}
    self.MyLikeRecord = MyLikeRecord or {}
    self.bSuccess = bSuccess
    self.ClickCount = ClickCount
    self.OnClosed = OnClosed

    if (bSuccess) then
        self.TitleText:SetText(GText("AFDayEvent_MiniGame_Success"))
        self.DescText:SetText(string.format(GText("AFDayEvent_MiniGame_Success_Roundup"), ClickCount))
        self:PlayAnimation(self.VictoryInAnimation)
    else
        self.TitleText:SetText(GText("AFDayEvent_MiniGame_Fail"))
        self.DescText:SetText(string.format(GText("AFDayEvent_MiniGame_Fail_Roundup"), ClickCount))
        self:PlayAnimation(self.DefeatInAnimation)
    end

    local LikeTypes = DataMgr.AFDayEventLike
    for Index, FaceItem in ipairs(self.FaceItems) do
        FaceItem:Enable()
        FaceItem:SetIsLoading(false)

        local LikeID = LikeTypes[Index].LikeID
        local LikeNum = LikeCountDetails[LikeID] or 0
        local bLiked = MyLikeRecord[LikeID] or false
        FaceItem:SetLikeNum(LikeNum)
        FaceItem:SetIsChecked(bLiked, false, false)
    end

    self:UploadTrackLog()

    AudioManager(self):PlayUISound(self, bSuccess and self.SuccessSoundPathName or self.FailSoundPathName, nil, nil)
end

function M:Close()
    if (self:IsAnimationPlaying(self.FadeOutAnimation)) then
        return
    end

    self:PlayAnimation(self.FadeOutAnimation)
end

function M:HandleOnLikeButtonClicked(Index, bChecked)
    local LikeType = DataMgr.AFDayEventLike[Index]
    if (not LikeType) then
        DebugPrint(_G.ErrorTag, string.format("%s handle like button clicked failed, like type is invalid, index: %d", self:GetName(), Index))
        return
    end

    local FaceItem = self.FaceItems[Index]
    if (not IsValid(FaceItem)) then
        DebugPrint(_G.ErrorTag, string.format("%s handle like button clicked failed, face item is invalid, index: %d", self:GetName(), Index))
        return
    end

    local Avatar = GWorld:GetAvatar()
    if (not Avatar) then
        DebugPrint(_G.ErrorTag, string.format("%s handle like button clicked failed, avatar is invalid", self:GetName()))
        return
    end

    FaceItem:Disable()
    if (bChecked) then
        Avatar:FoolsDayLikePhoto(self.PhotoId, LikeType.LikeID, function(Result)
            if (IsValid(self)) then
                self:HandleUploadLikePhotoFinished(FaceItem, LikeType.LikeID, bChecked, Result)
            end
        end)
    else
        Avatar:FoolsDayUnlikePhoto(self.PhotoId, LikeType.LikeID, function(Result)
            if (IsValid(self)) then
                self:HandleUploadLikePhotoFinished(FaceItem, LikeType.LikeID, bChecked, Result)
            end
        end)
    end
end

function M:HandleUploadLikePhotoFinished(FaceItem, LikeID, bChecked, Result)
    if (bChecked) then
        self.LikeCountDetails[LikeID] = (self.LikeCountDetails[LikeID] or 0) + 1
        self.MyLikeRecord[LikeID] = true
    end

    if (not IsValid(FaceItem)) then
        return
    end

    FaceItem:Enable()
    if (ErrorCode:Check(Result)) then
        FaceItem:SetIsChecked(bChecked, true, true)
        FaceItem:SetLikeNum(FaceItem:GetLikeNum() + 1)
    end
end

function M:UploadTrackLog()
    HeroUSDKSubsystem():UploadTrackLog_Lua("afday_game", {
        photo_uuid = self.PhotoId,
        transform_id = self.TransformId or -1,
        click_number = self.ClickCount,
        result_id = self.bSuccess and 1 or 0,
    })
end

return M

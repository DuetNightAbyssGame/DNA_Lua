local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})

local LocalTimeOut = 5

local EDetailState = {
    View = 0,
    Edit = 1,
}

function M:Construct()
    for i = 1, 4, 1 do
        local FaceItem = self["FaceItem_"..i]
        if IsValid(FaceItem) then
            local FaceSlot = self["WBP_Activity_Fool_Detail_FaceItemSlot0"..i]
            FaceItem:Init(FaceSlot)
        end
    end
    self.Text_LoadFail:SetText(GText("AFDayEvent_PhotoWall_LoadFailed"))
    self:BindFoolsDaySubsystem()
    self:BindButtonPerformances()
end

function M:Destruct()
    self:UnBindButtonPerformances()
end

function M:OnListItemObjectSet(Content)
    Content.Widget = self
    self.Content = Content
    self.HasSetPhoto = false
    self:CleanTimer()
    self:BindEvents()
    self:SwitchUIType(false)
    self:InitAnimState()
    if Content.IsEmpty then
        self.IsEmpty = true
        self.bIsFocusable = false
        self.WS_Item:SetActiveWidgetIndex(1)
        return
    end
    self.IsEmpty = false
    self.bIsFocusable = true
    self.WS_Item:SetActiveWidgetIndex(0)
    -- 将相片信息填入UI
    self:ResetEntryUI(Content.PhotoDoc)
    self:SwitchItemState(Content.State or EDetailState.View)
    self:SetIsSelected(Content.IsSelect, false, true)
end

function M:InitAnimState()
    self:SwitchNormalAnimation()
    self:PlayImgNormalAnimation()
    self:EndLoadingLoop()
end

function M:BindFoolsDaySubsystem()
    local FoolsDaySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UFoolsDaySubsystem:StaticClass())
    if IsValid(FoolsDaySubsystem) then
        self.FoolsDaySubsystem = FoolsDaySubsystem
    end
end

function M:BindEvents()
    self.Com_CheckBox:BindEventOnClicked({Inst = self, Func = function(Obj, bChecked)
        if self.Content.OnItemChecked then
            self.Content.OnItemChecked(self.Content, bChecked)
        end
    end})
end

function M:UnBindEvents()
    self.Com_CheckBox:UnBindEventOnClickedByObj(self)
end

function M:ResetEntryUI(PhotoDocs)
    self:UpdateDesc(PhotoDocs and PhotoDocs.Content)
    self:UpdatePhotoIcon(PhotoDocs and PhotoDocs.Small)
    self:UpdateLikeGroup(PhotoDocs)
    self.Btn_Retry:SetVisibility(ESlateVisibility.Collapsed)
end

function M:UpdateDesc(Desc)
    if not Desc or Desc == "" then
        self.Group_IconDesc:SetVisibility(ESlateVisibility.Collapsed)
        return
    end
    self.Group_IconDesc:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.Text_IconDesc:SetText(GText(Desc))
end

function M:UpdatePhotoIcon(URL)
    if not URL then return end
    if not self.Content then return end
    local PhotoId = self.Content.PhotoId
    if not IsValid(self.FoolsDaySubsystem) then return end
    self.FoolsDaySubsystem:RequestImage(URL, {self, function(Obj, Texture)
        self:OnGetPhoto(PhotoId, Texture)
    end})
    -- 若从缓存中读取到图片，直接return
    if self.HasSetPhoto then return end
    self.Group_Icon:SetVisibility(ESlateVisibility.Collapsed)
    self:AddTimer(LocalTimeOut, function()
        -- 图片加载超时后，开始播放转圈动效
        self:PlayItemUnHoverAnim()
        self:StartLoadingLoop()
    end, nil, nil, "DownloadTimeOut", true)
end

function M:UpdateLikeGroup(PhotoDocs)
    if not PhotoDocs then
        for i = 1, 4, 1 do
            local FaceItem = self["FaceItem_"..i]
            if IsValid(FaceItem) then
                FaceItem:SetIsLoading(true)
                FaceItem:SetLikeNum(0)
            end
        end
        return
    end
    local LikeInfo = PhotoDocs.LikeCountDetails
    local LikeTypes = DataMgr.AFDayEventLike
    for i = 1, 4, 1 do
        local FaceItem = self["FaceItem_"..i]
        if IsValid(FaceItem) then
            FaceItem:SetIsLoading(false)
            local LikeType = LikeTypes[i].LikeID
            local LikeNum = LikeInfo and LikeInfo[LikeType] or 0
            FaceItem:SetLikeNum(LikeNum)
        end
    end
end

function M:OnGetPhoto(PhotoId, Texture)
    if not self.Content then return end
    if PhotoId ~= self.Content.PhotoId then return end
    self:RemoveTimer("DownloadTimeOut")
    if not IsValid(Texture) then
        self:PlayLoadFail()
        return
    end
    self:EndLoadingLoop()
    self:SetPhotoFromTexture(Texture)
    self.Group_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.HasSetPhoto = true
end

function M:SetPhotoFromTexture(Texture)
    local Brush = UE4.FSlateBrush()
    Brush.ResourceObject = Texture
    Brush.ImageSize = UE4.UTextureLibrary.GetTextureSize(Texture)
    self.Image_Icon:SetBrush(Brush)
end

-- 浏览/编辑 模式切换
function M:SwitchItemState(EState)
    if self.Content then
        self.Content.State = EState
    end
    if EState == EDetailState.View then
        self.DetailState = EState
        self:ShowCheckBox(false)
        self.Group_IconExpand:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Expand:SetVisibility(ESlateVisibility.Visible)
        self.Btn_Check:SetVisibility(ESlateVisibility.Collapsed)
        local WasLoading = self:IsLoading()
        if not self.bLoadFail then
            self:SwitchNormalAnimation()
        end
        self:SwitchUIType(self.bGamepad)
        if WasLoading then
            self:StartLoadingLoop()
        end
    elseif EState == EDetailState.Edit then
        self.DetailState = EState
        self:ShowCheckBox(true)
        self.Group_IconExpand:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Expand:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Check:SetVisibility(ESlateVisibility.Visible)
        local WasLoading = self:IsLoading()
        self:PlayImgNormalAnimation()
        self:SwitchUIType(false)
        if WasLoading then
            self:StartLoadingLoop()
        end
    end
end

function M:ShowCheckBox(bShow)
    if bShow then
        self.Com_CheckBox:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Com_CheckBox:SetVisibility(ESlateVisibility.Collapsed)
        self:SetIsSelected(false, false, true)
    end
end

function M:SetIsSelected(IsSelect, IsPlaySound, bIgnoreCallback)
    if self.Content then
        self.Content.IsSelect = IsSelect
    end
    if bIgnoreCallback then
        self.Com_CheckBox:SetIsCheckedWithoutCallback(IsSelect, IsPlaySound)
    else
        self.Com_CheckBox:SetIsChecked(IsSelect, IsPlaySound)
    end
end

function M:OnRetryClicked()
    if not self.Content or not self.Content.PhotoDoc then return end
    local URL = self.Content.PhotoDoc.Small
    if not URL then 
        GWorld.logger.error("Fool_MyDetailItem:OnRetryClicked, URL not exist, PhotoId:"..self.Content.PhotoId)
        return
    end
    self.Btn_Retry:SetVisibility(ESlateVisibility.Collapsed)
    self:PlayItemUnHoverAnim()
    self:StartLoadingLoop()
    local PhotoId = self.Content.PhotoId
    if not IsValid(self.FoolsDaySubsystem) then return end
    self.FoolsDaySubsystem:RequestImage(URL, {self, function(Obj, Texture)
        self:OnGetPhoto(PhotoId, Texture)
    end})
end

-- 展开照片详情
function M:ExpandImgDetail()
    if not self.Content or not self.Content.PhotoDoc then return end
    local PhotoDoc = self.Content.PhotoDoc
    local Url, Desc = PhotoDoc.Large, PhotoDoc.Content
    self.FoolsDayFindBegin = UIManager(self):_CreateWidgetNew("FoolsDayFindBegin")
    if not IsValid(self.FoolsDayFindBegin) then
        return
    end
    if self.Content.OnDetailExpanded then
        self.Content.OnDetailExpanded(true)
    end
    self.FoolsDayFindBegin:Init(self.Content.PhotoId, PhotoDoc.TransformId, PhotoDoc.LikeCountDetails, {}, Url, nil, Desc, false, {self, function()
        self.FoolsDayFindBegin = nil
        if self.Content and self.Content.OnDetailExpanded then
            self.Content.OnDetailExpanded(false)
        end
        self:SetFocus()
    end})
end

function M:OnPhotoDeleted()
    if not IsValid(self.FoolsDayFindBegin) then
        return
    end
    ErrorCode:Check(ErrorCode.RET_FOOLS_DAY_PHOTO_NOT_EXIST)
    self.FoolsDayFindBegin:Close()
end

function M:InitKeyInfo()
    self.Key_Fail:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = "A",
                Type = "Img",
            }
        },
        bLongPress = false,
    })
end

function M:SwitchUIType(bGamepad)
    if bGamepad then
        if self.DetailState == EDetailState.View then
            self.Key_Fail:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
            self:PlayItemHoverAnim()
        end
    else
        self.Key_Fail:SetVisibility(ESlateVisibility.Collapsed)
        self:SwitchNormalAnimation()
        self.SwitchingToKeyAndMouse = true
        self:AddTimer(0.01, function()
            self.SwitchingToKeyAndMouse = false
        end, nil, nil, "DelaySwitch", true)
    end
    self.bGamepad = bGamepad
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
    if not self.bGamepad then return UIUtils.Handled end
    self:PlayItemHoverAnim()
    return UIUtils.Handled
end

function M:OnFocusLost(InFocusEvent)
    if not self.bGamepad then return end
    self:PlayItemUnHoverAnim()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
    if self.IsEmpty then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_FaceButton_Bottom") then
            if self.DetailState == EDetailState.View then
                if self.bLoadFail then
                    if not self.IsPressing then
                        self:OnItemPressed()
                        IsHandled = true
                    end
                elseif self.HasSetPhoto then
                    if not self.IsImgHovering then
                        self:OnImgHovered()
                        IsHandled = true
                    end
                end
            elseif self.DetailState == EDetailState.Edit then
                if not self.IsPressing then
                    self:OnItemPressed()
                    IsHandled = true
                end
            end
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    if self.IsEmpty then
        return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if (InKeyName == "Gamepad_FaceButton_Bottom") then
            if self.DetailState == EDetailState.View then
                if self.bLoadFail then
                    if self.IsPressing then
                        self:OnItemReleased()
                        self:OnRetryClicked()
                        IsHandled = true
                    end
                elseif self.HasSetPhoto then
                    if self.IsImgHovering then
                        self:OnImgUnhovered()
                        self:OnImgClicked()
                        IsHandled = true
                    end
                end
            elseif self.DetailState == EDetailState.Edit then
                if self.IsPressing then
                    self:OnItemReleased()
                    self:OnItemClicked()
                    IsHandled = true
                end
            end
        end
    end
    if IsHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:BP_OnEntryReleased()
    self:CleanTimer()
    self:UnBindEvents()
    if self.Content then
        self.Content.Widget = nil
        self.Content = nil
    end
    self.HasSetPhoto = false
end

-------------------------------- 图片 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    self.Btn_Expand.OnClicked:Add(self, self.OnImgClicked)
    self.Btn_Expand.OnPressed:Add(self, self.OnImgPressed)
    self.Btn_Expand.OnReleased:Add(self, self.OnImgReleased)
    self:BindToAnimationFinished(self.Icon_Click, {self, self.OnImgClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Expand.OnHovered:Add(self, self.OnImgHovered)
        self.Btn_Expand.OnUnhovered:Add(self, self.OnImgUnhovered)
    end

    self.Btn_Check.OnClicked:Add(self, self.OnItemClicked)
    self.Btn_Check.OnPressed:Add(self, self.OnItemPressed)
    self.Btn_Check.OnReleased:Add(self, self.OnItemReleased)
    self:BindToAnimationFinished(self.Click, {self, self.OnItemClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Check.OnHovered:Add(self, self.OnItemHovered)
        self.Btn_Check.OnUnhovered:Add(self, self.OnItemUnhovered)
    end

    self.Btn_Retry.OnClicked:Add(self, self.OnRetryClicked)
    self.Btn_Retry.OnPressed:Add(self, self.OnItemPressed)
    self.Btn_Retry.OnReleased:Add(self, self.OnItemReleased)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Retry.OnHovered:Add(self, self.OnItemHovered)
        self.Btn_Retry.OnUnhovered:Add(self, self.OnItemUnhovered)
    end
end

function M:UnBindButtonPerformances()
    self.Btn_Expand.OnClicked:Clear()
    self.Btn_Expand.OnPressed:Clear()
    self.Btn_Expand.OnReleased:Clear()
    self:UnbindFromAnimationFinished(self.Icon_Click, {self, self.OnImgClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Expand.OnHovered:Clear()
        self.Btn_Expand.OnUnhovered:Clear()
    end

    self.Btn_Check.OnClicked:Clear()
    self.Btn_Check.OnPressed:Clear()
    self.Btn_Check.OnReleased:Clear()
    self:UnbindFromAnimationFinished(self.Click, {self, self.OnItemClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Check.OnHovered:Clear()
        self.Btn_Check.OnUnhovered:Clear()
    end

    self.Btn_Retry.OnClicked:Clear()
    self.Btn_Retry.OnPressed:Clear()
    self.Btn_Retry.OnReleased:Clear()
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Retry.OnHovered:Clear()
        self.Btn_Retry.OnUnhovered:Clear()
    end
end

----------------------------------------  整体 相关动效 ---------------------------------------------------------------------------

----------------------------------------- 整体 Normal -----------------------------------------------
function M:SwitchNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self.IsPressing = false
    self.IsHovering = false
end

----------------------------------------- 整体 Loading ---------------------------------------------
function M:StartLoadingLoop()
    self:PlayAnimation(self.Loading_Loop, 0, 1000)
    self.bLoadFail = false
end

function M:IsLoading()
    return self:IsAnimationPlaying(self.Loading_Loop)
end

function M:PlayLoadFail()
    self:StopAllAnimations()
    self:PlayAnimation(self.LoadFail)
    self.Btn_Retry:SetVisibility(ESlateVisibility.Visible)
    self.bLoadFail = true
end

function M:EndLoadingLoop()
    self:StopAnimation(self.Loading_Loop)
    self:PlayAnimation(self.LoadEnd)
    self.bLoadFail = false
end

----------------------------------------- 整体 Click -----------------------------------------------
function M:PlayItemClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small",nil,nil)
    --UIUtils.PlayCommOnItemSe(self)
end

function M:PlayItemClickAnimation()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
end

function M:OnItemClicked()
    self:PlayItemClickSound()
    self:PlayItemClickAnimation()
    if self.Content then
        self:SetIsSelected(not self.Content.IsSelect, true, false)
    end
end

function M:OnItemClickAnimationFinished()
    if not self.IsHovering then
        self:PlayItemReleaseAndUnHoverAnim()
    else
        self:PlayItemReleaseButHoverAnim()
    end
end
----------------------------------------- 整体 Click -----------------------------------------------

----------------------------------------- 整体 Press -----------------------------------------------
function M:PlayItemPressAnim()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Press)
end

function M:OnItemPressed()
    --self:PlayItemClickSound()
    self.IsPressing = true
    self:PlayItemPressAnim()
end
----------------------------------------- 整体 Press -----------------------------------------------

----------------------------------------- 整体 Hover -----------------------------------------------
function M:PlayItemHoverAnim()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
end

function M:OnItemHovered()
    self.IsHovering = true
    self:PlayItemHoverAnim()
end
----------------------------------------- 整体 Hover -----------------------------------------------

----------------------------------------- 整体 Release -----------------------------------------------
function M:PlayItemReleaseButHoverAnim()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    self:PlayItemHoverAnim()
end

function M:PlayItemReleaseAndUnHoverAnim()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    if not self.bLoadFail then
        self:SwitchNormalAnimation()
    end
end

function M:OnItemReleased()
    self.IsPressing = false
end
----------------------------------------- 整体 Release -----------------------------------------------

----------------------------------------- 整体 UnHover -----------------------------------------------
function M:PlayItemUnHoverAnim()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.UnHover)
end

function M:OnItemUnhovered()
    self.IsHovering = false
    self:PlayItemUnHoverAnim()
end
----------------------------------------- 整体  UnHover -----------------------------------------------



----------------------------------------  图片 相关动效 ----------------------------------------------------------------------------

----------------------------------------- 图片 Normal -----------------------------------------------
function M:PlayImgNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Icon_Normal)
    self.IsImgPressing = false
    self.IsImgHovering = false
end

----------------------------------------- 图片 Click -----------------------------------------------
function M:PlayImgClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small",nil,nil)
end

function M:PlayImgClickAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Icon_Click)
end

function M:OnImgClicked()
    self:PlayImgClickSound()
    self:PlayImgClickAnimation()
    self:ExpandImgDetail()
end

function M:OnImgClickAnimationFinished()
    if not self.IsImgHovering then
        self:PlayImgReleaseAndUnHoverAnim()
    else
        self:PlayImgReleaseButHoverAnim()
    end
end
----------------------------------------- 图片 Click -----------------------------------------------

----------------------------------------- 图片 Press -----------------------------------------------
function M:PlayImgPressAnim()
    self:StopAllAnimations()
    self:PlayAnimation(self.Icon_Press)
end

function M:OnImgPressed()
    --self:PlayImgClickSound()
    self.IsImgPressing = true
    self:PlayImgPressAnim()
end
----------------------------------------- 图片 Press -----------------------------------------------

----------------------------------------- 图片 Hover -----------------------------------------------
function M:PlayImgHoverAnim()
    if self.bGamepad then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Icon_Hover)
end

function M:OnImgHovered()
    self.IsImgHovering = true
    self:PlayImgHoverAnim()
end
----------------------------------------- 图片 Hover -----------------------------------------------

----------------------------------------- 图片 Release -----------------------------------------------
function M:PlayImgReleaseButHoverAnim()
    self:StopAllAnimations()
    self:PlayImgHoverAnim()
end

function M:PlayImgReleaseAndUnHoverAnim()
    self:StopAllAnimations()
    self:PlayImgNormalAnimation()
end

function M:OnImgReleased()
    self.IsImgPressing = false
end
----------------------------------------- 图片 Release -----------------------------------------------

----------------------------------------- 图片 UnHover -----------------------------------------------
function M:PlayImgUnHoverAnim()
    if self.bGamepad or self.SwitchingToKeyAndMouse then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Icon_UnHover)
end

function M:OnImgUnhovered()
    self.IsImgHovering = false
    if not self.IsImgPressing then
        self:PlayImgUnHoverAnim()
    end
end
----------------------------------------- 图片  UnHover -----------------------------------------------

return M

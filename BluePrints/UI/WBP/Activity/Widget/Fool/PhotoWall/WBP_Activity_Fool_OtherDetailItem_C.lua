local M = Class({
    "BluePrints.UI.BP_EMUserWidget_C",
    "BluePrints.Common.TimerMgr",
})
M._components = { "BluePrints.UI.WBP.Activity.PC.Fool.Components.FoolHeadAnchorComp",}

local LocalTimeOut = 5

local GamepadKeys = {
    [1] = "X",
    [2] = "Y",
    [3] = "LS",
    [4] = "RS",
}

function M:Construct()
    self.bAnchorOpen = false
    self:InitBtns()
    self:InitFaceItems()
    self.Text_LoadFail:SetText(GText("AFDayEvent_PhotoWall_LoadFailed"))
    self:InitKeyInfo()
    self:BindFoolsDaySubsystem()
    self:BindButtonPerformances()
end

function M:InitBtns()
    self.Btn_Click:SetText(GText("AFDayEvent_MiniGame_Start"))
    self.Btn_Click:UnBindEventOnClickedByObj(self)
    self.Btn_Click:BindEventOnClicked(self, function()
        self:ExpandImgDetail()
    end)
    self.Btn_Click.AudioEventPath = "event:/ui/activity/fools_day_btn_common"
end

function M:InitFaceItems()
    for i = 1, 4, 1 do
        local FaceItem = self["FaceItem_"..i]
        if IsValid(FaceItem) then
            local FaceSlot = self["WBP_Activity_Fool_Detail_FaceItemSlot0"..i]
            FaceItem:Init(FaceSlot, GamepadKeys[i], function(bCheck)
                self:OnLikeBtnClicked(i, bCheck)
            end)
        end
    end
end

function M:Destruct()
    self:UnBindButtonPerformances()
end

function M:BindFoolsDaySubsystem()
    local FoolsDaySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UFoolsDaySubsystem:StaticClass())
    if IsValid(FoolsDaySubsystem) then
        self.FoolsDaySubsystem = FoolsDaySubsystem
    end
end

function M:OnListItemObjectSet(Content)
    Content.Widget = self
    self.Content = Content
    self.HasSetPhoto = false
    self:CleanTimer()
    self:InitAnimState()
    self:SwitchUIType(false)
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
end

function M:InitAnimState()
    self:SwitchNormalAnimation()
    self:EndLoadingLoop()
end

function M:ResetEntryUI(PhotoDoc)
    self:UpdateDesc(PhotoDoc and PhotoDoc.Content)
    self:UpdatePhotoIcon(PhotoDoc and PhotoDoc.Small)
    self:UpdateLikeGroup(PhotoDoc)
    self:UpdatePlayerHeadIcon(PhotoDoc)
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
    if self.HasSetPhoto then return end
    self:ShowIconAndButton(false)
    if not URL then return end
    if not self.Content then return end
    local PhotoId = self.Content.PhotoId
    if not IsValid(self.FoolsDaySubsystem) then return end
    self.FoolsDaySubsystem:RequestImage(URL, {self, function(Obj, Texture)
        self:OnGetPhoto(PhotoId, Texture)
    end})
    -- 若从缓存中读取到图片，直接return
    if self.HasSetPhoto then return end
    self:AddTimer(LocalTimeOut, function()
        -- 图片加载超时后，开始播放转圈动效
        self:PlayItemUnHoverAnim()
        self:StartLoadingLoop()
    end, nil, nil, "DownloadTimeOut", true)
end

function M:UpdateLikeGroup(PhotoDoc)
    if not self.Content then return end
    if not PhotoDoc then
        for i = 1, 4, 1 do
            local FaceItem = self["FaceItem_"..i]
            if IsValid(FaceItem) then
                FaceItem:Disable()
                FaceItem:SetIsLoading(true)
                FaceItem:SetLikeNum(0)
            end
        end
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local LikeTypes = DataMgr.AFDayEventLike
    local LikeInfo = PhotoDoc.LikeCountDetails
    for i = 1, 4, 1 do
        local FaceItem = self["FaceItem_"..i]
        if IsValid(FaceItem) then
            FaceItem:Enable()
            FaceItem:SetIsLoading(false)
            local LikeType = LikeTypes[i].LikeID
            local LikeNum = LikeInfo and LikeInfo[LikeType] or 0
            FaceItem:SetLikeNum(LikeNum)
            local IsLiked = false
            if LikeNum > 0 then
                IsLiked = Avatar:GetIsFoolsDayPhotoLiked(self.Content.PhotoId, LikeType)
            end
            FaceItem:SetIsChecked(LikeNum>0 and IsLiked, false, false)
        end
    end
end

function M:UpdatePlayerHeadIcon(PhotoDoc)
    if not PhotoDoc or not PhotoDoc.AvatarInfo then
        self.Head_Player:SetHeadIconEmpty(true)
        self.Head_Player:SetHeadFrame(CommonConst.DefaultNoHeadFrame)
        self.Group_Name:SetVisibility(ESlateVisibility.Collapsed)
        self.Group_Level:SetVisibility(ESlateVisibility.Collapsed)
        self:CleanUpAnchor()
        return
    end
    local PlayerInfo = PhotoDoc.AvatarInfo
    self.Head_Player:SetHeadIconEmpty(false)
    self.Group_Name:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.Head_Player:SetHeadIconById(PlayerInfo.HeadIconId)
    self.Head_Player:SetHeadFrame(PlayerInfo.HeadFrameId)
    self.Text_Name:SetText(PlayerInfo.Nickname)
    self.Group_Level:SetVisibility(ESlateVisibility.HitTestInvisible)
    self.Text_Level:SetText(PlayerInfo.Level)
    
    local AvatarInfo = setmetatable({}, {__index = PlayerInfo})
    AvatarInfo.Uid = PhotoDoc.Uid
    AvatarInfo.Url = PhotoDoc.Large
    AvatarInfo.PictureUniqueId = PhotoDoc.PhotoId
    self:SetupAnchor(self.Head_Anchor, self.Head_Player, AvatarInfo)
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
    self:ShowIconAndButton(true)
    self.HasSetPhoto = true
end

function M:SetPhotoFromTexture(Texture)
    local Brush = UE4.FSlateBrush()
    Brush.ResourceObject = Texture
    Brush.ImageSize = UE4.UTextureLibrary.GetTextureSize(Texture)
    self.Image_Icon:SetBrush(Brush)
end

function M:ShowIconAndButton(bShow)
    if(bShow) then
        self.Group_Icon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Click:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
        self.Group_Icon:SetVisibility(ESlateVisibility.Collapsed)
        self.Btn_Click:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:OnRetryClicked()
    if self:IsLoading() then return end
    if not self.Content or not self.Content.PhotoDoc then return end
    local URL = self.Content.PhotoDoc.Small
    if not URL then 
        GWorld.logger.error("Fool_OtherDetailItem:OnRetryClicked, URL not exist, PhotoId:"..self.Content.PhotoId)
        return
    end
    self:PlayItemClickSound()
    self:PlayItemClickAnimation()
    self:StartLoadingLoop()
    local PhotoId = self.Content.PhotoId
    if not IsValid(self.FoolsDaySubsystem) then return end
    self.FoolsDaySubsystem:RequestImage(URL, {self, function(Obj, Texture)
        self:OnGetPhoto(PhotoId, Texture)
    end})
end

function M:OnLikeBtnClicked(LikeIdx, bLike)
    if not self.Content then return end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    local PhotoId = self.Content.PhotoId
    local FaceItem = self["FaceItem_"..LikeIdx]
    if not IsValid(FaceItem) then 
        GWorld.logger.error("OnLikeBtnClicked: FaceItem not Valid, idx:"..LikeIdx)
        return 
    end
    local LikeType = DataMgr.AFDayEventLike[LikeIdx].LikeID
    if not LikeType then
        GWorld.logger.error("OnLikeBtnClicked: LikeType not exist, idx:"..LikeIdx)
        return
    end
    local Callback = function(Ret)
        if ErrorCode:Check(Ret) then
            if PhotoId == self.Content.PhotoId then
                FaceItem:SetIsChecked(bLike, true, true)
                FaceItem:SetLikeNum(FaceItem:GetLikeNum()+1)
                self:AddContentLikeCount(LikeType)
            end
        end
        FaceItem:Enable()
    end
    if bLike then
        Avatar:FoolsDayLikePhoto(PhotoId, LikeType, Callback)
    else
        -- 实际走不到此处，现不支持取消点赞
        Avatar:FoolsDayUnlikePhoto(PhotoId, LikeType, Callback)
    end
    FaceItem:Disable()
end

function M:AddContentLikeCount(LikeType)
    if not self.Content or not self.Content.PhotoDoc then return end
    local PhotoDoc = self.Content.PhotoDoc
    PhotoDoc.LikeCountDetails = PhotoDoc.LikeCountDetails or {}
    local LikeNum = PhotoDoc.LikeCountDetails[LikeType] or 0
    PhotoDoc.LikeCountDetails[LikeType] = LikeNum + 1
end

-- 展开照片详情
function M:ExpandImgDetail()
    if not self.Content or not self.Content.PhotoDoc then return end
    local PhotoDoc = self.Content.PhotoDoc
    local Url, AlphaUrl, Desc = PhotoDoc.Large, PhotoDoc.Pixel, PhotoDoc.Content
    local MyLikeRecord = {}
    local LikeTypes = DataMgr.AFDayEventLike
    local Avatar = GWorld:GetAvatar()
    for i = 1, 4, 1 do
        local LikeType = LikeTypes[i].LikeID
        if Avatar then
            MyLikeRecord[LikeType] = Avatar:GetIsFoolsDayPhotoLiked(self.Content.PhotoId, LikeType)
        end
    end
    self.FoolsDayFindBegin = UIManager(self):_CreateWidgetNew("FoolsDayFindBegin")
    if not IsValid(self.FoolsDayFindBegin) then
        return
    end
    if self.Content.OnDetailExpanded then
        self.Content.OnDetailExpanded(true)
    end
    self.FoolsDayFindBegin:Init(self.Content.PhotoId, PhotoDoc.TransformId, PhotoDoc.LikeCountDetails, MyLikeRecord, Url, AlphaUrl, Desc, true, {self, function()
        self.FoolsDayFindBegin = nil
        if self.Content and self.Content.OnDetailExpanded then
            self.Content.OnDetailExpanded(false)
        end
        if IsValid(self) then
            self:UpdateLikeGroup(PhotoDoc)
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
    self.Key_Name:CreateCommonKey({
        KeyInfoList = {
            {
                ImgShortPath = "View",
                Type = "Img",
            }
        },
        bLongPress = false,
    })
end

function M:OnHeadMenuOpenChanged(IsOpen)
    self.bAnchorOpen = IsOpen
    if IsOpen then
        self:SwitchUIType(false)
        if self.Content and IsValid(self.Content.Owner) then
            self.Content.Owner:UpdateBottomKeyInfo(nil, true)
        end
    else
        if UIUtils.IsGamepadInput() then
            self:SwitchUIType(true)
            if self.Content and IsValid(self.Content.Owner) then
                self.Content.Owner:UpdateBottomKeyInfo(false)
            end
        end
    end
end

function M:SwitchUIType(bGamepad)
    if bGamepad then
        if not self.bAnchorOpen then
            self.Key_Fail:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
            self.Key_Name:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
    else
        self.Key_Fail:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Name:SetVisibility(ESlateVisibility.Collapsed)
    end
    for i = 1, 4, 1 do
        local FaceItem = self["FaceItem_"..i]
        if IsValid(FaceItem) then
            FaceItem:SwitchUIType(bGamepad and not self.bAnchorOpen)
        end
    end
    self:SwitchVXGroup(bGamepad)
    self.Btn_Click:SetGamepadIconVisibility(bGamepad and not self.bAnchorOpen)
    self.bGamepad = bGamepad
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
            if not self.IsEmpty then
                if self.bLoadFail then
                    if not self.IsPressing then
                        self:OnItemPressed()
                        IsHandled = true
                    end
                elseif self.HasSetPhoto then
                    if not self.bAnchorOpen and not self.IsPressing then
                        self:OnItemPressed()
                        IsHandled = true
                    end
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
            if self.bLoadFail then
                if self.IsPressing then
                    self:OnItemReleased()
                    self:OnRetryClicked()
                    IsHandled = true
                end
            elseif self.HasSetPhoto then
                if not self.bAnchorOpen and self.IsPressing then
                    self:OnItemReleased()
                    self:OnImgClicked()
                    IsHandled = true
                end
            end
        elseif (InKeyName == "Gamepad_FaceButton_Left") then
            self.FaceItem_1:OnBtnClicked()
            self.FaceItem_1:PlayButtonClickSound()
            IsHandled = true
        elseif (InKeyName == "Gamepad_FaceButton_Top") then
            self.FaceItem_2:OnBtnClicked()
            self.FaceItem_1:PlayButtonClickSound()
            IsHandled = true
        elseif (InKeyName == "Gamepad_LeftThumbstick") then
            self.FaceItem_3:OnBtnClicked()
            self.FaceItem_1:PlayButtonClickSound()
            IsHandled = true
        elseif (InKeyName == "Gamepad_RightThumbstick") then
            self.FaceItem_4:OnBtnClicked()
            self.FaceItem_1:PlayButtonClickSound()
            IsHandled = true
        elseif (InKeyName == "Gamepad_Special_Left") then
            if self.Content and self.Content.PhotoDoc and self.Content.PhotoDoc.AvatarInfo then
                self.Head_Player:BtnAreaOnClicked()
                IsHandled = true
            end
        elseif (InKeyName == "Gamepad_FaceButton_Right") then
            if self.bAnchorOpen then
                self.Head_Anchor:Close()
                self:SetFocus()
                IsHandled = true
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
    if self.Content then
        self.Content.Widget = nil
        self.Content = nil
    end
end

-------------------------------- 整体 绑定/解绑 相关 -----------------------------------
function M:BindButtonPerformances()
    self.Btn_Check.OnClicked:Add(self, self.OnImgClicked)
    self.Btn_Check.OnPressed:Add(self, self.OnItemPressed)
    self.Btn_Check.OnReleased:Add(self, self.OnItemReleased)
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Check.OnHovered:Add(self, self.OnItemHovered)
        self.Btn_Check.OnUnhovered:Add(self, self.OnItemUnhovered)
    end

    self.Btn_Retry.OnClicked:Add(self, self.OnRetryClicked)
    self.Btn_Retry.OnPressed:Add(self, self.OnItemPressed)
    self.Btn_Retry.OnReleased:Add(self, self.OnItemReleased)
    self:BindToAnimationFinished(self.Click, {self, self.OnItemClickAnimationFinished})
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
        self.Btn_Retry.OnHovered:Add(self, self.OnItemHovered)
        self.Btn_Retry.OnUnhovered:Add(self, self.OnItemUnhovered)
    end

end

function M:UnBindButtonPerformances()
    self.Btn_Check.OnClicked:Clear()
    self.Btn_Check.OnPressed:Clear()
    self.Btn_Check.OnReleased:Clear()
    self:UnbindFromAnimationFinished(self.Icon_Click, {self, self.OnImgClickAnimationFinished})
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

function M:SwitchVXGroup(bItemOrIcon)
    self.PlayItemVX = bItemOrIcon
    if self:IsAnimationPlaying(self.UnHover) then
        self:AddTimer(self.UnHover:GetEndTime(), self.RealSwitchVXGroup, nil, nil, "DelaySwitchVX", true)
    else
        self:RealSwitchVXGroup()
    end
end

function M:RealSwitchVXGroup()
    self:RemoveTimer("DelaySwitchVX")
    self:EnableItemVX(self.PlayItemVX)
    self:EnableIconVX(not self.PlayItemVX)
end

function M:EnableItemVX(bEnable)
    if bEnable then
        self.VX_BtnGroup:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.VXItemBGGlow:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.VX_BtnGroup:SetVisibility(ESlateVisibility.Collapsed)
        self.VXItemBGGlow:SetVisibility(ESlateVisibility.Collapsed)
    end
end

function M:EnableIconVX(bEnable)
    if bEnable then
        self.VX_Hover01:SetVisibility(ESlateVisibility.HitTestInvisible)
        self.VX_Hover02:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
        self.VX_Hover01:SetVisibility(ESlateVisibility.Collapsed)
        self.VX_Hover02:SetVisibility(ESlateVisibility.Collapsed)
    end
end

----------------------------------------  整体 相关动效 -----------------------------------

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
    self:OnItemClickAnimationFinished()
    self.Btn_Retry:SetVisibility(ESlateVisibility.Visible)
    self.bLoadFail = true
end

function M:EndLoadingLoop()
    self:StopAnimation(self.Loading_Loop)
    self:PlayAnimation(self.LoadEnd)
    self:OnItemClickAnimationFinished()
    self.Btn_Retry:SetVisibility(ESlateVisibility.Collapsed)
    self.bLoadFail = false
end

----------------------------------------- 整体 Normal -----------------------------------------------
function M:SwitchNormalAnimation()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.Icon_Normal)
    self.IsPressing = false
    self.IsHovering = false
end

----------------------------------------- 整体 Normal -----------------------------------------------

----------------------------------------- 整体 Click -----------------------------------------------
function M:PlayItemClickSound()
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large",nil,nil)
    --UIUtils.PlayCommOnItemSe(self)
end

function M:PlayItemClickAnimation()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    self:PlayAnimation(self.Icon_Click)
end

function M:OnItemClickAnimationFinished()
    if not self.IsHovering then
        self:PlayItemReleaseAndUnHoverAnim()
    else
        self:PlayItemReleaseButHoverAnim()
    end
end
----------------------------------------- 整体 Click -----------------------------------------------

----------------------------------------- 整体 Hover -----------------------------------------------
function M:PlayItemHoverAnim()
    if not self:IsLoading() then
        self:StopAllAnimations()
        self:PlayAnimation(self.Icon_Hover)
    end
    self:PlayAnimation(self.Hover)
end

function M:OnItemHovered()
    self.IsHovering = true
    self:PlayItemHoverAnim()
end

function M:SetBtnHovered(IsHovered)
    if IsHovered then 
        self:OnItemHovered()
    else 
        self:OnItemUnhovered()
    end
end 
----------------------------------------- 整体 Hover -----------------------------------------------

----------------------------------------- 整体 UnHover -----------------------------------------------
function M:PlayItemUnHoverAnim()
    if not self:IsLoading() then
        self:StopAllAnimations()
        self:PlayAnimation(self.Icon_UnHover)
    end
    self:PlayAnimation(self.UnHover)
end

function M:OnItemUnhovered()
    self.IsHovering = false
    self:PlayItemUnHoverAnim()
end
----------------------------------------- 整体  UnHover -----------------------------------------------

----------------------------------------- 整体 Press -----------------------------------------------
function M:PlayItemPressAnim()
    if self:IsLoading() then return end
    self:StopAllAnimations()
    -- self:PlayAnimation(self.Press)
    self:PlayAnimation(self.Icon_Press)
end

function M:OnItemPressed()
    self.IsPressing = true
    self:PlayItemPressAnim()
end
----------------------------------------- 整体 Press -----------------------------------------------

----------------------------------------- 整体 Release -----------------------------------------------
function M:OnItemReleased()
    self.IsPressing = false
end

function M:PlayItemReleaseButHoverAnim()
    self:PlayItemHoverAnim()
end

function M:PlayItemReleaseAndUnHoverAnim()
    self:PlayAnimation(self.Normal)
    self:PlayAnimation(self.Icon_Normal)
end
----------------------------------------- 整体 Release -----------------------------------------------



----------------------------------------- 图片 Click -----------------------------------------------
function M:OnImgClicked()
    self:PlayItemClickSound()
    self:PlayItemClickAnimation()
    self:ExpandImgDetail()
end
----------------------------------------- 图片 Click -----------------------------------------------

AssembleComponents(M)
return M

local M = Class("BluePrints.UI.BP_UIState_C")

local LocalTimeOut = 5
local HeroUSDKUtils = require "Utils.HeroUSDKUtils"

function M:Construct()
    self.Text_PostTitle:SetText(GText("AFDayEvent_Photo_Publish"))
    self.Text_UploadTitle:SetText(GText("AFDayEvent_PhotoWall_Mywork"))
    self.Text_UploadNum01:SetText(0)
    self.Text_UploadNum02:SetText(DataMgr.EventConstant.PictureUploadLimit.ConstantValue)
    self.Btn_Cancel:SetText(GText("AFDayEvent_Photo_Cancel"))
    self.Btn_Cancel.AudioEventPath = "event:/ui/activity/fools_day_btn_common"
    self.Btn_Commit:SetText(GText("AFDayEvent_Photo_Publish"))
    self.Btn_Commit.AudioEventPath = "event:/ui/activity/fools_day_btn_confirm"
    self.MyWorkNum = 0
    self.UniqueId = nil
    self:OnLoaded()
    self:BindToAnimationFinished(self.In, {self, self.OnInAnimationFinished})
    self:BindToAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
end

function M:OnLoaded(...)
    self:InitBtns()
    self:InitMyWorkNum()
    self:InitInputArea()
    self:BindButtonEvents()
    self:BindFoolsDaySubsystem()
    if not IsValid(self.FoolsDaySubsystem) then return end
    local Texture = self.FoolsDaySubsystem:GetCapturedPhotoTexture()
    self:SetPhotoFromTexture(Texture)
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, "event:/ui/activity/fools_day_post_photo_in", nil, nil)
end

function M:InitBtns()
    self.Btn_Commit:ForbidBtn(false)
end

function M:OnInAnimationFinished()
    if not self:HasAnyUserFocus() and not self:HasFocusedDescendants() then
        self:SetFocus()
    end
end

function M:OnOutAnimationFinished()
    if IsValid(self.FoolsDaySubsystem) then
        self.FoolsDaySubsystem:ClearCapturedPhotoData()
    end
    self:Close()
end

function M:Destruct()
    self:UnbindFromAnimationFinished(self.Out, {self, self.OnOutAnimationFinished})
    self:CleanTimer()
end

function M:InitMyWorkNum()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end

    local MyWorks = Avatar:GetMyFoolsDayPhotoIds() or {}
    self.MyWorkNum = CommonUtils.Size(MyWorks)

    self.Text_UploadNum01:SetText(self.MyWorkNum)
end

function M:InitInputArea()
    local Config = {
        Owner = self, --父对象
        Text = "", --初始设置的文本，不会触发回调
        HintText = GText("AFDayEvent_Photo_Publish_Tips"), --空文本时的提示文本
        TextLimit = DataMgr.EventConstant.PictureCharacterLimit.ConstantValue,    --最大字数限制
        BackFocusWidget = self, --按手柄返回键时需要聚焦的控件
        bNeedPasteBtn = true,
    }
    self.Com_Input_Multiline:Init(Config)
    self.Com_Input_Multiline.Image_Copy:SetColorAndOpacity(self.Color_Text_Icon)
    self.Com_Input_Multiline.Image_Delete:SetColorAndOpacity(self.Color_Text_Icon)
    self.Com_Input_Multiline.Text_Btn:SetColorAndOpacity(self.Color_Text_Input)
    self.Com_Input_Multiline.Text_ControllerChoose:SetColorAndOpacity(self.Color_Text_Input)
    local InputStyle = self.Com_Input_Multiline.Text_Input.WidgetStyle
    InputStyle.ColorAndOpacity = self.Color_Text_Input
    self.Com_Input_Multiline.Text_Input:SetWidgetStyle(InputStyle)
end

function M:BindButtonEvents()
    self.Btn_Cancel:UnBindEventOnClickedByObj(self)
    self.Btn_Commit:UnBindEventOnClickedByObj(self)

    self.Btn_Cancel:BindEventOnClicked(self, self.OnCancelBtnClicked)
    self.Btn_Commit:BindEventOnClicked(self, self.OnCommitBtnClicked)
end

function M:OnCancelBtnClicked()
    self:PlayAnimation(self.Out)
end

function M:OnCommitBtnClicked()
    self.Btn_Commit:ForbidBtn(true)
    local Text = self.Com_Input_Multiline:GetText()
    if Text == "" then
        self:OnTextQualified()
    else
        HeroUSDKUtils.CheckStringSensitive(self, Text, self.OnTextSensitive, self.OnTextQualified)
    end
end

function M:OnTextSensitive()
    self.Btn_Commit:ForbidBtn(false)
    self.Com_Input_Multiline:ShowTips(GText("UI_REGISTER_BANNEDINPUT"))
end

function M:OnTextQualified()
    if self.MyWorkNum >= DataMgr.EventConstant.PictureUploadLimit.ConstantValue then
        self.Btn_Commit:ForbidBtn(false)
        self:ShowWorkNumExceedPopup()
        return
    end
    if not self.UniqueId then
        self:ApplyForNewPhoto()
    else
        self:UploadPhotoData(self.UniqueId)
        self:AddTimer(LocalTimeOut, function()
            self:OnPostFail()
        end, nil, nil, "PostTimeOut", true)
    end
end

function M:ApplyForNewPhoto()
    local Text = self.Com_Input_Multiline:GetText() or ""
    if not IsValid(self.FoolsDaySubsystem) then
        self:OnPostFail()
        return
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local CallbackId = Avatar:BindCallbackFunc(function(Res, UniqueId)
        DebugPrint("lhr1@ApplyForNewPhoto", Res)
        if Res == ErrorCode.RET_SENSITIVE_WORD_FOUND then
            self:RemoveTimer("PostTimeOut")
            self:OnTextSensitive()
        elseif ErrorCode:Check(Res) then
            self:UploadPhotoData(UniqueId)
        else
            self:RemoveTimer("PostTimeOut")
            self:OnPostFail()
        end
    end)
    self.bFailed = false
    self.FoolsDaySubsystem:ApplyForNewPhoto(Text, CallbackId)
    self:AddTimer(LocalTimeOut, function()
        self:OnPostFail()
    end, nil, nil, "PostTimeOut", true)
end

function M:UploadPhotoData(UniqueId)
    self.UniqueId = UniqueId
    if not IsValid(self.FoolsDaySubsystem) then
        self:RemoveTimer("PostTimeOut")
        self:OnPostFail()
        return
    end
    local SuccNum = 0
    local Avatar = GWorld:GetAvatar()
    if not Avatar then return end
    local Callback = function(Res)
        DebugPrint("lhr1@UploadPhotoData", Res)
        self:RemoveTimer("PostTimeOut")
        if ErrorCode:Check(Res) then
            SuccNum = SuccNum + 1
            if SuccNum == 3 then
                self:OnPostSuccess()
            end
        else
            self:OnPostFail()
        end
    end
    local CallbackId1 = Avatar:BindCallbackFunc(Callback)
    local CallbackId2 = Avatar:BindCallbackFunc(Callback)
    local CallbackId3 = Avatar:BindCallbackFunc(Callback)
    self.FoolsDaySubsystem:UploadPhotoData(UniqueId, CallbackId1, CallbackId2, CallbackId3)
end

function M:ShowWorkNumExceedPopup()
    local Params = {}
    Params.OnCloseCallbackFunction = function() 
        self:SetFocus()
    end
    Params.RightCallbackFunction = function() 
        -- 前往照片墙-我的作品tab
        self:PlayAnimation(self.Out)
        UIManager(self):LoadUINew("AprilFoolsDayMain", 2)
    end
    UIManager(self):ShowCommonPopupUI(100299, Params, self.Parent)
end

function M:BindFoolsDaySubsystem()
    local FoolsDaySubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(GWorld.GameInstance, UFoolsDaySubsystem:StaticClass())
    if IsValid(FoolsDaySubsystem) then
        self.FoolsDaySubsystem = FoolsDaySubsystem
    end
end

function M:SetPhotoFromTexture(Texture)
    if not IsValid(Texture) then return end
    local Brush = UE4.FSlateBrush()
    Brush.ResourceObject = Texture
    Brush.ImageSize = UE4.UTextureLibrary.GetTextureSize(Texture)
    self.Image_Post:SetBrush(Brush)
end

function M:OnPostFail()
    if self.bFailed then return end 
    self.bFailed = true
    self.Btn_Commit:ForbidBtn(false)
    self:ShowPostFailToast()
end

function M:OnPostSuccess()
    self:ShowPostSuccToast()
    HeroUSDKSubsystem():UploadTrackLog_Lua("afday_photo", {
        photo_uuid = self.UniqueId,
        transform_id = self.FoolsDaySubsystem:GetPlayerTransformID(),
    })
    self:PlayAnimation(self.Out)
end

function M:ShowPostFailToast()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("(TextMap待配置)上传失败"))
end

function M:ShowPostSuccToast()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("AFDayEvent_Photo_Publish_Success"))
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        IsEventHandled = self:OnGamePadDown(InKeyName)
    else
        if InKeyName == "Escape" then
            self:OnCancelBtnClicked()
        end
    end
    if (IsEventHandled) then
        return UE4.UWidgetBlueprintLibrary.Handled()
    else
        return UE4.UWidgetBlueprintLibrary.UnHandled()    
    end
end

function M:OnGamePadDown(InKeyName)
    local IsEventHandled = false
    if InKeyName == "Gamepad_FaceButton_Right"  then
        if not self.Btn_Cancel.IsPressing then
            self.Btn_Cancel:OnBtnPressed()
            IsEventHandled = true
        end
    elseif InKeyName == "Gamepad_FaceButton_Top"  then
        if not self.Btn_Commit.IsPressing then
            self.Btn_Commit:OnBtnPressed()
            IsEventHandled = true
        end
    end
    return IsEventHandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    local IsEventHandled = false
    if (UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey)) then
        if InKeyName == "Gamepad_FaceButton_Left"  then
            self.Com_Input_Multiline:SetFocus()
        elseif InKeyName == "Gamepad_FaceButton_Right" then
            if self.Btn_Cancel.IsPressing then
                self.Btn_Cancel:OnBtnReleased()
                self.Btn_Cancel:OnBtnClicked()
                IsEventHandled = true
            end
        elseif InKeyName == "Gamepad_FaceButton_Top"  then
            if self.Btn_Commit.IsPressing then
                self.Btn_Commit:OnBtnReleased()
                self.Btn_Commit:OnBtnClicked()
                IsEventHandled = true
            end
        elseif InKeyName == "Gamepad_LeftThumbstick"  then
            self.Com_Input_Multiline:OnBtnClicked()
        end
    end
    if IsEventHandled then
        return UE4.UWidgetBlueprintLibrary.Handled()
    end

    return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
